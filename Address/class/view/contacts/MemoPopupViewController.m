//
//  MemoPopupViewController.m
//  Address
//
//  Created by LeeSungJu on 2017. 4. 9..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "MemoPopupViewController.h"

@interface MemoPopupViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *popupView;
@property (strong, nonatomic) IBOutlet UIView *titleView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UIView *editView;
@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UITextField *dateTextField;
@property (strong, nonatomic) IBOutlet UITextField *locationTextField;
@property (strong, nonatomic) IBOutlet UITextView *detailTextView;

@property (strong, nonatomic) IBOutlet UIView *detailView;
@property (strong, nonatomic) IBOutlet UIView *detailTitleView;
@property (strong, nonatomic) IBOutlet UILabel *detailTitleLabel;
@property (strong, nonatomic) IBOutlet UIView *detailDateView;
@property (strong, nonatomic) IBOutlet UILabel *detailDateLabel;
@property (strong, nonatomic) IBOutlet UIView *detailLocationView;
@property (strong, nonatomic) IBOutlet UILabel *detailLocationLabel;
@property (strong, nonatomic) IBOutlet UIView *detailContentView;
@property (strong, nonatomic) IBOutlet UITextView *detailContentTextView;

@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) IBOutlet UIButton *saveBtn;

@end

@implementation MemoPopupViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataArray = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addTapGestureTarget:self action:@selector(backgroundTouch:)];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self initViews];
}

- (void)initViews
{
    NSMutableDictionary * dict = [NSMutableDictionary new];
    if([_dataArray count] > 0){
        dict = [_dataArray objectAtIndex:_index];
    }
    
    [_popupView setRadius:10];
    
    if(_viewMode == kViewPopupMode_nomarl){
        [_detailView setHidden:NO];
        [_editView setHidden:YES];
        [_titleLabel setText:@"메모"];
        [_saveBtn setTitle:@"수정" forState:UIControlStateNormal];
        [_detailTitleView setRadius:5];
        [_detailTitleLabel setText:[dict objectForKey:@"title"]];
        [_detailDateView setRadius:5];
        [_detailDateLabel setText:[dict objectForKey:@"date"]];
        [_detailLocationView setRadius:5];
        [_detailLocationLabel setText:[dict objectForKey:@"location"]];
        [_detailContentView setRadius:5];
        [_detailContentTextView setText:[dict objectForKey:@"detail"]];
        [_detailContentTextView setEditable:NO];
    }else if(_viewMode == kViewPopupMode_add){
        [_detailView setHidden:YES];
        [_editView setHidden:NO];
        [_titleLabel setText:@"메모 등록"];
        [_saveBtn setTitle:@"저장" forState:UIControlStateNormal];
        [_dateTextField setDelegate:self];
        [_detailTextView setRadius:5];
    }else if(_viewMode == kViewPopupMode_edit){
        [_detailView setHidden:YES];
        [_editView setHidden:NO];
        [_titleLabel setText:@"메모 수정"];
        [_saveBtn setTitle:@"저장" forState:UIControlStateNormal];
        [_dateTextField setDelegate:self];
        [_detailTextView setRadius:5];
        
        [_titleTextField setText:[dict objectForKey:@"title"]];
        [_dateTextField setText:[dict objectForKey:@"date"]];
        [_locationTextField setText:[dict objectForKey:@"location"]];
        [_detailTextView setText:[dict objectForKey:@"detail"]];
    }
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
    
    if(_viewMode == kViewPopupMode_add || _viewMode == kViewPopupMode_edit){
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
    }else{
        _viewMode = kViewPopupMode_edit;
        [self initViews];
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
