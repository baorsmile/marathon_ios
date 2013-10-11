//
//  AddressBookUtils.h
//  LeheV2
//
//  Created by zhangluyi on 11-6-25.
//  Copyright 2011年 www.Lehe.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import "RegexKitLite.h"

@interface AddressBookUtils : NSObject {
    
}

+ (NSArray *)getPhones:(ABRecordRef)person;
+ (NSDictionary *)getPerson:(ABRecordRef)person;
+ (NSArray *)getEmails:(ABRecordRef)person;
+ (NSString *)getFirstName:(ABRecordRef)person;
+ (NSString *)getLastName:(ABRecordRef)person;
+ (NSString *)getFullName:(ABRecordRef)person;
+ (BOOL)isMobilePhoneNumber:(NSString*)phoneNumberString;

@end
