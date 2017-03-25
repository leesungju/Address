//
//  ContactManager.h
//  Address
//
//  Created by LeeSungJu on 2017. 3. 18..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactManager : NSObject

+ (ContactManager *)sharedInstance;

- (NSMutableArray*)getContact;
-(void)saveContact:(NSString*)familyName givenName:(NSString*)givenName phoneNumber:(NSString*)phoneNumber;
-(void)updateContact:(CNContact*)contact memo:(NSString*)memo;
-(void)loadContactView:(CNContact*)contact;
@end
