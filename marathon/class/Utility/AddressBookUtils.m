//
//  AddressBookUtils.m
//  LeheV2
//
//  Created by zhangluyi on 11-6-25.
//  Copyright 2011年 www.Lehe.com. All rights reserved.
//

#import "AddressBookUtils.h"

@implementation AddressBookUtils

+ (NSArray *)getPhones:(ABRecordRef)person
{
    NSMutableArray *phoneList   = [[[NSMutableArray alloc] init] autorelease];
    ABMultiValueRef phones      = ABRecordCopyValue(person, kABPersonPhoneProperty);

    //get person full name
    NSString *fullName = [self getFullName:person];

    if (phones){
        int count = ABMultiValueGetCount(phones);
        for (CFIndex i = 0; i < count; i++) {
            
            //get phone label 
            NSString *origLabel = (NSString *)ABMultiValueCopyLabelAtIndex(phones, i);    
            NSString *localizedLabel = (NSString *)ABAddressBookCopyLocalizedLabel((CFStringRef)origLabel);
            NSString *phoneLabel = [NSString stringWithString:localizedLabel];
            
            phoneLabel = [phoneLabel stringByReplacingOccurrencesOfString:@"_$!<" withString:@""];
            phoneLabel = [phoneLabel stringByReplacingOccurrencesOfString:@">!$_" withString:@""];    
            
            [localizedLabel release];
            [origLabel release];

            //get phone number
            NSString *phoneNumber = (NSString *)ABMultiValueCopyValueAtIndex(phones, i);
            NSString *trimedPhoneNumber = [phoneNumber stringByReplacingOccurrencesOfRegex:@"[^0-9]" withString:@""];
            
            NSString *cutPrefix = nil;
            if ([trimedPhoneNumber length] >= 11) {
                if ([trimedPhoneNumber hasPrefix:@"86"]) {
                    cutPrefix = [trimedPhoneNumber substringFromIndex:2];
                    if (![AddressBookUtils isMobilePhoneNumber:cutPrefix]) {
                        [phoneNumber release];
                        continue;
                    }
                } else {
                    if (![AddressBookUtils isMobilePhoneNumber:trimedPhoneNumber]) {
                        [phoneNumber release];
                        continue;
                    }
                }
            } else {
                [phoneNumber release];
                continue;
            }
            
            // add to dict
            NSMutableDictionary *phoneDict = [NSMutableDictionary dictionaryWithCapacity:2];
            [phoneDict setObject:fullName forKey:@"fullName"];
            [phoneDict setObject:phoneLabel forKey:@"label"];
            if (cutPrefix) {
                [phoneDict setObject:cutPrefix forKey:@"phone"];
            } else {
                [phoneDict setObject:trimedPhoneNumber forKey:@"phone"];
            }
            
            [phoneDict setObject:@"mobile" forKey:@"type"];
            
//            if ([AddressBookUtils isMobilePhoneNumber:[phoneDict objForKey:@"phone"]]) {
//                [phoneDict setObject:@"mobile" forKey:@"type"];
//            } else {
//                [phoneDict setObject:@"telephone" forKey:@"type"];
//            }
            
            [phoneNumber release];
            
            [phoneList addObject:phoneDict];
        }
    }
    if(phones != NULL) CFRelease(phones);
    return phoneList;
}

+ (NSDictionary *)getPerson:(ABRecordRef)person
{
    NSMutableArray *phoneList   = [[[NSMutableArray alloc] init] autorelease];
    NSMutableArray *phoneLabelList  = [[[NSMutableArray alloc] init] autorelease];
    ABMultiValueRef phones      = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    //get person full name
    NSString *fullName = [self getFullName:person];
    NSString *phoneLabel = @"";
    if (phones){
        int count = ABMultiValueGetCount(phones);
        for (CFIndex i = 0; i < count; i++) {
            
            //get phone label 
            NSString *origLabel = (NSString *)ABMultiValueCopyLabelAtIndex(phones, i);    
            NSString *localizedLabel = (NSString *)ABAddressBookCopyLocalizedLabel((CFStringRef)origLabel);
            phoneLabel = [NSString stringWithString:localizedLabel];
            
            phoneLabel = [phoneLabel stringByReplacingOccurrencesOfString:@"_$!<" withString:@""];
            phoneLabel = [phoneLabel stringByReplacingOccurrencesOfString:@">!$_" withString:@""];
            
            [phoneLabelList addObject:phoneLabel];
            
            [localizedLabel release];
            [origLabel release];
            
            //get phone number
            NSString *phoneNumber = (NSString *)ABMultiValueCopyValueAtIndex(phones, i);
            NSString *trimedPhoneNumber = [phoneNumber stringByReplacingOccurrencesOfRegex:@"[^0-9]" withString:@""];
            
            NSString *cutPrefix = nil;
            if ([trimedPhoneNumber length] >= 11) {
                if ([trimedPhoneNumber hasPrefix:@"86"]) {
                    cutPrefix = [trimedPhoneNumber substringFromIndex:2];
                    if (![AddressBookUtils isMobilePhoneNumber:cutPrefix]) {
                        [phoneNumber release];
                        continue;
                    }
                } else {
                    if (![AddressBookUtils isMobilePhoneNumber:trimedPhoneNumber]) {
                        [phoneNumber release];
                        continue;
                    }
                }
            } else {
                [phoneNumber release];
                continue;
            }
            
            if (cutPrefix) {
                [phoneList addObject:cutPrefix];
            } else {
                [phoneList addObject:trimedPhoneNumber];
            }
            
            [phoneNumber release];

        }
    }
    // add to dict
    NSMutableDictionary *phoneDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [phoneDict setObject:fullName forKey:@"fullName"];
    [phoneDict setObject:phoneLabel forKey:@"label"];
    [phoneDict setObject:phoneList forKey:@"phones"];
    [phoneDict setObject:phoneLabelList forKey:@"phoneLabels"];
    [phoneDict setObject:@"mobile" forKey:@"type"];
    
    if(phones != NULL) CFRelease(phones);
    return phoneDict;
}

+ (NSArray *)getEmails:(ABRecordRef)person
{
    NSMutableArray* emailList   = [[[NSMutableArray alloc] init] autorelease];
    ABMultiValueRef emails      = ABRecordCopyValue(person, kABPersonEmailProperty);    
    if (emails) {
        for (CFIndex i = 0; i < ABMultiValueGetCount(emails); i++) {
            //get mail label 
            NSString *origLabel = (NSString *)ABMultiValueCopyLabelAtIndex(emails, i);    
            NSString *localizedLabel = (NSString *)ABAddressBookCopyLocalizedLabel((CFStringRef)origLabel);
            NSString *mailLabel = [NSString stringWithString:localizedLabel];
            
            mailLabel = [mailLabel stringByReplacingOccurrencesOfString:@"_$!<" withString:@""];
            mailLabel = [mailLabel stringByReplacingOccurrencesOfString:@">!$_" withString:@""];    
            
            [localizedLabel release];
            [origLabel release];

            //get mail
            NSString *value = (NSString *)ABMultiValueCopyValueAtIndex(emails, i);
            
            NSMutableDictionary *mailDict = [NSMutableDictionary dictionaryWithCapacity:2];
            [mailDict setObject:mailLabel forKey:@"label"];
            [mailDict setObject:value forKey:@"mail"];
            [value release];
            
            [emailList addObject:mailDict];
        }
    }
    if (emails != NULL) CFRelease(emails);  
    return emailList;
}

+ (NSString *)getFirstName:(ABRecordRef)person 
{
    NSString *firstName = (NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    return (firstName == nil) ? @"" : [firstName autorelease];
}

+ (NSString *)getLastName:(ABRecordRef)person 
{
    NSString *lastName  = (NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    return (lastName == nil) ? @"" : [lastName autorelease];
}

+ (NSString *)getFullName:(ABRecordRef)person 
{
    NSString *fullName = [NSString stringWithFormat:@"%@%@",[self getLastName:person], [self getFirstName:person]];
    fullName = [fullName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return (fullName == nil) ? @"" : fullName;
}

+ (BOOL)isMobilePhoneNumber:(NSString*)phoneNumberString {
	if (phoneNumberString == nil) {
        return NO;
    }
	NSInteger len = [phoneNumberString length];
	if (len<10 || len>12) {
		return NO;
	}
	
	BOOL matchContainsResult = [phoneNumberString isMatchedByRegex:@"(01.[3-9]{1}.[0-9]{9,10})|(1.[0-9]{9,11})"];
	BOOL matchNotContainsResult = [phoneNumberString isMatchedByRegex:@"[^0-9]+$"];
	BOOL matchResult = matchContainsResult & !matchNotContainsResult;
	
	return matchResult;
}

@end
