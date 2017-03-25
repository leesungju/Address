//
//  ContactManager.m
//  Address
//
//  Created by LeeSungJu on 2017. 3. 18..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "ContactManager.h"
@interface ContactManager () <CNContactViewControllerDelegate>

@end

@implementation ContactManager

+ (ContactManager *)sharedInstance
{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ _sharedInstance = [self new]; });
    return _sharedInstance;
}

- (NSMutableArray*)getContact
{
    NSMutableArray* contactList = [NSMutableArray new];
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if( status == CNAuthorizationStatusDenied || status == CNAuthorizationStatusRestricted)
    {
        NSLog(@"access denied");
    }
    else
    {
        CNContactStore *contactStore = [[CNContactStore alloc] init];
        
        NSArray *keys = [[NSArray alloc]initWithObjects:CNContactIdentifierKey, CNContactEmailAddressesKey, CNContactBirthdayKey, CNContactImageDataKey, CNContactPhoneNumbersKey, CNContactViewController.descriptorForRequiredKeys, nil];
        
        CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
        request.predicate = nil;
        
        [contactStore enumerateContactsWithFetchRequest:request
                                                  error:nil
                                             usingBlock:^(CNContact* __nonnull contact, BOOL* __nonnull stop)
         {
             NSString *phoneNumber = @"";
             if( contact.phoneNumbers)
                 phoneNumber = [[[contact.phoneNumbers firstObject] value] stringValue];
             
             NSString * name =@"";
             if(contact.familyName.length > 0){
                 name = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName] ;
             }else if(contact.givenName.length > 0){
                 name = contact.givenName;
             }else{
                 return;
             }
             NSString * address =@"";
             if([contact.postalAddresses firstObject] != nil){
                 address = [[contact.postalAddresses firstObject] value].city;
             }
             
             NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
             [dateformate setDateFormat:@"yyyy-MM-dd"]; // Date formater
             NSString *birthDay = [dateformate stringFromDate:contact.birthday.date];
             NSString * phone = ([[[contact.phoneNumbers firstObject] value] stringValue] > 0)?[[[contact.phoneNumbers firstObject] value] stringValue] : @"";
             
             NSLog(@"givenName = %@", [NSStrUtils getJasoLetter:name]);

             AddressObj * obj = [AddressObj new];
             [obj setName:name];
             [obj setSection:[[NSStrUtils getJasoLetter:name] substringToIndex:1].uppercaseString];
             [obj setGroup:contact.organizationName];
             [obj setEmail:[[contact.emailAddresses firstObject] value]];
             [obj setAddress:address];
             [obj setBirthDay:birthDay];
             [obj setImageData:contact.imageData];
             [obj setPhoneNumber:[NSStrUtils replacePhoneNumber:phone]];

             [contactList addObject:obj];
         }];
    }
    return contactList;
    
}

-(void)saveContact:(NSString*)familyName givenName:(NSString*)givenName phoneNumber:(NSString*)phoneNumber
{
    CNMutableContact *mutableContact = [[CNMutableContact alloc] init];
    
    mutableContact.givenName = givenName;
    mutableContact.familyName = familyName;
    CNPhoneNumber * phone =[CNPhoneNumber phoneNumberWithStringValue:phoneNumber];
    
    mutableContact.phoneNumbers = [[NSArray alloc] initWithObjects:[CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberiPhone value:phone], nil];
    CNContactStore *store = [[CNContactStore alloc] init];
    CNSaveRequest *saveRequest = [[CNSaveRequest alloc] init];
    [saveRequest addContact:mutableContact toContainerWithIdentifier:store.defaultContainerIdentifier];
    
    NSError *error;
    if([store executeSaveRequest:saveRequest error:&error]) {
        NSLog(@"save");
    }else {
        NSLog(@"save error");
    }
}

-(void)updateContact:(CNContact*)contact memo:(NSString*)memo
{
    CNMutableContact *mutableContact = contact.mutableCopy;
    
    mutableContact.note = memo;
    
    CNContactStore *store = [[CNContactStore alloc] init];
    CNSaveRequest *saveRequest = [[CNSaveRequest alloc] init];
    [saveRequest updateContact:mutableContact];
    
    NSError *error;
    if([store executeSaveRequest:saveRequest error:&error]) {
        NSLog(@"save");
    }else {
        NSLog(@"save error : %@", [error description]);
    }
}

-(void)loadContactView:(CNContact*)contact
{
    // Create a new contact view
    CNContactViewController *contactController = [CNContactViewController viewControllerForContact:contact];
    contactController.delegate = self;
    contactController.allowsEditing = YES;
    contactController.allowsActions = YES;
    
    // Display the view
    [[GUIManager sharedInstance] moveToController:contactController animation:YES];
}

@end
