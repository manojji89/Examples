/*
     File: KeychainItemWrapper.m 
 Abstract: 
 Objective-C wrapper for accessing a single keychain item.
  
  Version: 1.2 
  
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple 
 Inc. ("Apple") in consideration of your agreement to the following 
 terms, and your use, installation, modification or redistribution of 
 this Apple software constitutes acceptance of these terms.  If you do 
 not agree with these terms, please do not use, install, modify or 
 redistribute this Apple software. 
  
 In consideration of your agreement to abide by the following terms, and 
 subject to these terms, Apple grants you a personal, non-exclusive 
 license, under Apple's copyrights in this original Apple software (the 
 "Apple Software"), to use, reproduce, modify and redistribute the Apple 
 Software, with or without modifications, in source and/or binary forms; 
 provided that if you redistribute the Apple Software in its entirety and 
 without modifications, you must retain this notice and the following 
 text and disclaimers in all such redistributions of the Apple Software. 
 Neither the name, trademarks, service marks or logos of Apple Inc. may 
 be used to endorse or promote products derived from the Apple Software 
 without specific prior written permission from Apple.  Except as 
 expressly stated in this notice, no other rights or licenses, express or 
 implied, are granted by Apple herein, including but not limited to any 
 patent rights that may be infringed by your derivative works or by other 
 works in which the Apple Software may be incorporated. 
  
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE 
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION 
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS 
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND 
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS. 
  
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL 
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, 
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED 
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), 
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE 
 POSSIBILITY OF SUCH DAMAGE. 
  
 Copyright (C) 2010 Apple Inc. All Rights Reserved. 
  
*/ 

#import "KeychainItemWrapper.h"
@import Security;

/*

These are the default constants and their respective types,
available for the kSecClassGenericPassword Keychain Item class:

kSecAttrAccessGroup			-		CFStringRef
kSecAttrCreationDate		-		CFDateRef
kSecAttrModificationDate    -		CFDateRef
kSecAttrDescription			-		CFStringRef
kSecAttrComment				-		CFStringRef
kSecAttrCreator				-		CFNumberRef
kSecAttrType                -		CFNumberRef
kSecAttrLabel				-		CFStringRef
kSecAttrIsInvisible			-		CFBooleanRef
kSecAttrIsNegative			-		CFBooleanRef
kSecAttrAccount				-		CFStringRef
kSecAttrService				-		CFStringRef
kSecAttrGeneric				-		CFDataRef
 
See the header file Security/SecItem.h for more details.

*/

@interface KeychainItemWrapper ()
// The actual keychain item data backing store.
@property (nonatomic, readwrite) NSMutableDictionary *keychainItemData;
// A placeholder for the generic keychain item query used to locate the
@property (nonatomic, readonly) NSMutableDictionary *genericPasswordQuery;

/*
The decision behind the following two methods (secItemFormatToDictionary and dictionaryToSecItemFormat) was
to encapsulate the transition between what the detail view controller was expecting (NSString *) and what the
Keychain API expects as a validly constructed container class.
*/
- (NSMutableDictionary *)secItemFormatToDictionary:(NSDictionary *)dictionaryToConvert;
- (NSMutableDictionary *)dictionaryToSecItemFormat:(NSDictionary *)dictionaryToConvert;

// Updates the item in the keychain, or adds it if it doesn't exist.
- (void)writeToKeychain;

@end

@implementation KeychainItemWrapper

- (instancetype)initWithIdentifier: (NSString *)identifier accessGroup:(NSString *) accessGroup {
    self = [super init];

    if (self) {
        // Begin Keychain search setup. The genericPasswordQuery leverages the
        // special user defined attribute kSecAttrGeneric to distinguish itself
        // between other generic Keychain items which may be included by the
        // same application.
        _genericPasswordQuery = [NSMutableDictionary dictionary];
        
		_genericPasswordQuery[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
        _genericPasswordQuery[(__bridge id)kSecAttrGeneric] = identifier;
		
		// The keychain access group attribute determines if this item can be
        // shared amongst multiple apps whose code signing entitlements contain
        // the same keychain access group.
		if (accessGroup) {
#if TARGET_IPHONE_SIMULATOR
			// Ignore the access group if running on the iPhone simulator.
			// 
			// Apps that are built for the simulator aren't signed, so there's
            // no keychain access group for the simulator to check. This means
            // that all apps can see all keychain items when run on the
            // simulator.
			//
			// If a SecItem contains an access group attribute, SecItemAdd and
            // SecItemUpdate on the simulator will return -25243
            // (errSecNoAccessForItem).
#else			
			[_genericPasswordQuery setObject:accessGroup forKey:(id)kSecAttrAccessGroup];
#endif
		}
		
		// Use the proper search constants, return only the attributes of the
        // first match.
        _genericPasswordQuery[(__bridge id)kSecMatchLimit] = (__bridge id)kSecMatchLimitOne;
        _genericPasswordQuery[(__bridge id)kSecReturnAttributes] = (id)kCFBooleanTrue;
        
        NSDictionary *tempQuery = [NSDictionary dictionaryWithDictionary:_genericPasswordQuery];
        NSMutableDictionary *outDictionary;
        
        if ((! SecItemCopyMatching((__bridge CFDictionaryRef)tempQuery, (void *)&outDictionary)) == noErr) {
            // Stick these default values into keychain item if nothing found.
            [self resetKeychainItem];
			
			// Add the generic attribute and the keychain access group.
			_keychainItemData[(__bridge id)kSecAttrGeneric] = identifier;
            if (accessGroup) {
#if TARGET_IPHONE_SIMULATOR
				// Ignore the access group if running on the iPhone simulator.
#else			
				[_keychainItemData setObject:accessGroup
                                      forKey:(id)kSecAttrAccessGroup];
#endif
			}
		}
        else {
            // load the saved data from Keychain.
            _keychainItemData = [self secItemFormatToDictionary:outDictionary];
        }
    }
    
	return self;
}


- (void)setObject:(id)object forKey:(id)key  {
    NSAssert(object, @"The argument, \"object\" cannot be nil.");

    id currentObject = self.keychainItemData[key];
    if (![currentObject isEqual:object]) {
        self.keychainItemData[key] = object;
        [self writeToKeychain];
    }
}

- (id)objectForKey:(id)key {
    NSAssert(self.keychainItemData, @"Error, self.keychainItemData is nil.");
    return self.keychainItemData[key];
}

- (void)resetKeychainItem {
	OSStatus junk = noErr;
    if (!self.keychainItemData) {
        self.keychainItemData = [NSMutableDictionary dictionary];
    }

    else {
        NSMutableDictionary *tempDictionary = [self dictionaryToSecItemFormat:self.keychainItemData];
		junk = SecItemDelete((__bridge CFDictionaryRef)tempDictionary);
        NSAssert( junk == noErr || junk == errSecItemNotFound, @"Problem deleting current dictionary." );
    }
    
    // Default attributes for keychain item.
    self.keychainItemData[(__bridge id)kSecAttrAccount] = @"";
    self.keychainItemData[(__bridge id)kSecAttrLabel] = @"";
    self.keychainItemData[(__bridge id)kSecAttrDescription] = @"";
    
	// Default data for keychain item.
    self.keychainItemData[(__bridge id)kSecValueData] = @"";
}

- (NSMutableDictionary *)dictionaryToSecItemFormat:(NSDictionary *)dictionaryToConvert {
    // The assumption is that this method will be called with a properly
    // populated dictionary containing all the right key/value pairs for a
    // SecItem.
    
    // Create a dictionary to return populated with the attributes and data.
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionaryToConvert];
    
    // Add the Generic Password keychain item class attribute.
    returnDictionary[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    
    // Convert the NSString to NSData to meet the requirements for the value
    // type kSecValueData. This is where to store sensitive data that should be
    // encrypted.
    NSString *passwordString = dictionaryToConvert[(__bridge id)kSecValueData];
    returnDictionary[(__bridge id)kSecValueData] = [passwordString dataUsingEncoding:NSUTF8StringEncoding];
    
    return returnDictionary;
}

- (NSMutableDictionary *)secItemFormatToDictionary:(NSDictionary *)dictionaryToConvert {
    // The assumption is that this method will be called with a properly
    // populated dictionary containing all the right key/value pairs for the UI
    // element.
    
    // Create a dictionary to return populated with the attributes and data.
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionaryToConvert];
    
    // Add the proper search key and class attribute.
    returnDictionary[(__bridge id)kSecReturnData] = (id)kCFBooleanTrue;
    returnDictionary[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    
    // Acquire the password data from the attributes.
    NSData *passwordData;
    
    if (SecItemCopyMatching((__bridge CFDictionaryRef)returnDictionary, (void *)&passwordData) == noErr) {
        // Remove the search, class, and identifier key/value, we don't need
        // them anymore.
        [returnDictionary removeObjectForKey:(__bridge id)kSecReturnData];
        
        // Add the password to the dictionary, converting from NSData to NSString.
        NSString *password = [[NSString alloc] initWithBytes:passwordData.bytes
                                                      length:passwordData.length
                                                    encoding:NSUTF8StringEncoding];
        returnDictionary[(__bridge id)kSecValueData] = password;
    }
    else {
        // Do nothing if nothing is found.
        NSAssert(NO, @"Serious error, no matching item found in the keychain.\n");
    }
   
	return returnDictionary;
}

- (void)writeToKeychain {
    NSDictionary *attributes;
    NSMutableDictionary *updateItem;
	OSStatus result = noErr;
    
    if (SecItemCopyMatching((__bridge CFDictionaryRef)self.genericPasswordQuery, (void *)&attributes) == noErr){
        // First we need the attributes from the Keychain.
        updateItem = [NSMutableDictionary dictionaryWithDictionary:attributes];
        // Second we need to add the appropriate search key/values.
        updateItem[(__bridge id)kSecClass] = self.genericPasswordQuery[(__bridge id)kSecClass];
        
        // Lastly, we need to set up the updated attribute list being careful to remove the class.
        NSMutableDictionary *tempCheck = [self dictionaryToSecItemFormat:self.keychainItemData];
        [tempCheck removeObjectForKey:(__bridge id)kSecClass];
		
#if TARGET_IPHONE_SIMULATOR
		// Remove the access group if running on the iPhone simulator.
		[tempCheck removeObjectForKey:(__bridge id)kSecAttrAccessGroup];
#endif
        
        // An implicit assumption is that you can only update a single item at a time.
		
        result = SecItemUpdate((__bridge CFDictionaryRef)updateItem, (__bridge CFDictionaryRef)tempCheck);
		NSAssert(result == noErr, @"Failed to update the Keychain Item.");
    }
    else {
        // No previous item found; add the new one.
        result = SecItemAdd((__bridge CFDictionaryRef)[self dictionaryToSecItemFormat:self.keychainItemData], NULL);
		NSAssert(result == noErr, @"Failed to add the Keychain Item.");
    }
}

@end
