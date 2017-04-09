//
//  MemoPopupViewController.m
//  Address
//
//  Created by LeeSungJu on 2017. 4. 9..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "MemoPopupViewController.h"

@interface MemoPopupViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *titleView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UITextField *dateTextField;
@property (strong, nonatomic) IBOutlet UITextField *locationTextField;
@property (strong, nonatomic) IBOutlet UITextView *detailTextView;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) IBOutlet UIButton *saveBtn;

@end

@implementation MemoPopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view addTapGestureTarget:self action:@selector(backgroundTouch:)];
    
    [_dateTextField setDelegate:self];
}


#pragma mark - Action Methods
- (void)backgroundTouch:(id)sender
{
    [_titleTextField resignFirstResponder];
    [_dateTextField resignFirstResponder];
    [_locationTextField resignFirstResponder];
    [_detailTextView resignFirstResponder];
}

- (IBAction)cancelAction:(id)sender {
    [[GUIManager sharedInstance] hidePopup:self animation:YES completeData:nil];
}

- (IBAction)saveAction:(id)sender {
    NSMutableDictionary * saveDict = [NSMutableDictionary new];
    if(_titleTextField.text.length > 0 &&
       _dateTextField.text.length > 0 &&
       _locationTextField.text.length > 0 &&
       _detailTextView.text.length > 0){
        [saveDict setObject:_titleTextField.text forKey:@"title"];
        [saveDict setObject:_dateTextField.text forKey:@"date"];
        [saveDict setObject:_locationTextField.text forKey:@"location"];
        [saveDict setObject:_detailTextView.text forKey:@"detail"];
        [[GUIManager sharedInstance] hidePopup:self animation:YES completeData:saveDict];
    }else{
        
    }
    
}

- (void)datePickerAction:(UIDatePicker*)sender
{
    NSDateFormatter *formate=[[NSDateFormatter alloc]init];
    [formate setDateFormat:@"yyyy년 MM월 dd일"];
    _dateTextField.text=[formate stringFromDate:sender.date];
}

- (void)selectDate:(id)sender
{
    [_dateTextField resignFirstResponder];
}


#pragma mark - UITextField Delegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == _dateTextField){
        UIDatePicker *datePicker = [[UIDatePicker alloc]init];
        [datePicker setDate:[NSDate date]];
        NSDateFormatter *formate=[[NSDateFormatter alloc]init];
        [formate setDateFormat:@"yyyy년 MM월 dd일"];
        _dateTextField.text=[formate stringFromDate:[NSDate date]];
        datePicker.datePickerMode = UIDatePickerModeDate;
        [datePicker addTarget:self action:@selector(datePickerAction:) forControlEvents:UIControlEventValueChanged];
        [_dateTextField setInputView:datePicker];
        
        UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        [toolBar setTintColor:[UIColor grayColor]];
        UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(selectDate:)];
        UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
        [_dateTextField setInputAccessoryView:toolBar];
    }
}


@end
