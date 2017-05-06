//
//  GroupContentsViewController.m
//  Address
//
//  Created by LeeSungJu on 2017. 4. 23..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "GroupContentsViewController.h"

@interface GroupContentsViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *popupView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) IBOutlet UIButton *saveBtn;

@property (strong, nonatomic) IBOutlet UIView *normalView;
@property (strong, nonatomic) IBOutlet UILabel *normalTitleLabel;
@property (strong, nonatomic) IBOutlet UIView *normalContentsView;
@property (strong, nonatomic) IBOutlet UITextView *normalContentsLabel;
@property (strong, nonatomic) IBOutlet UIButton *normalFileBtn;
@property (strong, nonatomic) UIScrollView *normalPhotoView;

@property (strong, nonatomic) IBOutlet UIView *editView;
@property (strong, nonatomic) IBOutlet UITextField *editTitleTextField;
@property (strong, nonatomic) IBOutlet UITextView *editContentsTextView;
@property (strong, nonatomic) IBOutlet UIButton *editFileBtn;
@property (strong, nonatomic) UIScrollView *editPhotoView;

@property (strong, nonatomic) UIButton * addBtn;
@property (strong, nonatomic) NSMutableArray * btnArray;
@property (strong, nonatomic) NSMutableArray * imageArray;

@end

@implementation GroupContentsViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _btnArray = [NSMutableArray new];
        _imageArray = [NSMutableArray new];
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
    [_popupView setRadius:10];
    if(!_contentsObj){
        _contentsObj = [ContentsObj new];
    }
    
    if(_type == kGroupContentsViewType_nomarl){
        
        [_normalView setHidden:NO];
        [_editView setHidden:YES];
        [_titleLabel setText:@"내용 상세"];
        [_normalTitleLabel setText:_contentsObj.contentsTitle];
        [_normalContentsLabel setText:_contentsObj.contents];
        [_normalContentsLabel setEditable:NO];
        [_saveBtn setTitle:@"수정" forState:UIControlStateNormal];
        if(_contentsObj.filePath.length > 0){
            [_normalFileBtn setEnabled:YES];
        }else{
            [_normalFileBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [_normalFileBtn setEnabled:NO];
        }
        
        if(_normalPhotoView == nil){
            _normalPhotoView = [UIScrollView new];
            [_normalPhotoView setDelegate:self];
            [_normalPhotoView setBackgroundColor:[UIColor whiteColor]];
        }
        [_normalPhotoView setFrame:CGRectMake(10, _normalContentsView.bottomY + 10, _normalView.width - 20, 100)];
        [_normalView addSubview:_normalPhotoView];
        
        [_imageArray removeAllObjects];
        [_saveBtn setEnabled:NO];
        if([_contentsObj.imageArray count] == 0){
            [_saveBtn setEnabled:YES];
            if(_addBtn == nil){
                _addBtn = [[UIButton alloc] initWithFrame:CGRectMake((_normalPhotoView.width - 90)/2, 5, 90, 90)];
                [_normalPhotoView addSubview:_addBtn];
            }
            [_addBtn setImage:[UIImage imageNamed:@"no_image"] forState:UIControlStateNormal];
            [_addBtn setImageEdgeInsets:UIEdgeInsetsMake(30, 30, 30, 30)];
            [_addBtn setCircle:[UIColor clearColor] width:1];
            [_addBtn setEnabled:NO];
        }else{
            for(int i =0;i<[_contentsObj.imageArray count];i++){
                UIButton * btn = [UIButton new];
                [btn setFrame:CGRectMake(5+(i*(90+5)), 5, 90, 90)];
                [btn addTarget:self action:@selector(showImage:) forControlEvents:UIControlEventTouchUpInside];
                [btn setTag:i];
                [btn setEnabled:NO];
                [btn setRadius:5];
                UIImage *img = [[ImageCacheManager sharedInstance] loadFromMemory:[_contentsObj.imageArray objectAtIndex:i]];
                if(img){
                    [btn setBackgroundImage:img forState:UIControlStateNormal];
                    [_imageArray addObject:img];
                    [_saveBtn setEnabled:YES];
                    [btn setEnabled:YES];;
                }else{
                    [btn setImage:[UIImage imageNamed:@"loading"] forState:UIControlStateNormal];
                    [[StorageManager sharedInstance] downFile:[_contentsObj.imageArray objectAtIndex:i] completion:^(UIImage *image) {
                        [[ImageCacheManager sharedInstance] saveImage:image forKey:[_contentsObj.imageArray objectAtIndex:i]];
                        [btn setBackgroundImage:image forState:UIControlStateNormal];
                        [_imageArray addObject:image];
                        [_saveBtn setEnabled:YES];
                        [btn setEnabled:YES];;
                    }];
                }
                [_normalPhotoView addSubview:btn];
            }
        }
        
    }else if(_type == kGroupContentsViewType_add){
        
        [_normalView setHidden:YES];
        [_editView setHidden:NO];
        [_titleLabel setText:@"내용 추가"];
        [_editContentsTextView setRadius:5];
        if(_editPhotoView == nil){
            _editPhotoView = [UIScrollView new];
            [_editPhotoView setDelegate:self];
            [_editPhotoView setBackgroundColor:[UIColor whiteColor]];
        }
        [_editPhotoView setFrame:CGRectMake(10, _editContentsTextView.bottomY + 10, _editView.width - 20, 100)];
        [_editView addSubview:_editPhotoView];
        if(_addBtn == nil){
            _addBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 90, 90)];
            [_btnArray addObject:_addBtn];
            [_editPhotoView addSubview:_addBtn];
            [_editPhotoView setShowsHorizontalScrollIndicator:NO];
        }
        [_addBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        [_addBtn setImageEdgeInsets:UIEdgeInsetsMake(30, 30, 30, 30)];
        [_addBtn addTarget:self action:@selector(addImageAction:) forControlEvents:UIControlEventTouchUpInside];
        [_addBtn setCircle:[UIColor clearColor] width:1];
        
    }else if(_type == kGroupContentsViewType_edit){
        
        [_normalView setHidden:YES];
        [_editView setHidden:NO];
        [_titleLabel setText:@"내용 수정"];
        [_editContentsTextView setRadius:5];
        [_saveBtn setTitle:@"저장" forState:UIControlStateNormal];
        
        [_editTitleTextField setText:_contentsObj.contentsTitle];
        [_editContentsTextView setText:_contentsObj.contents];
        [_editPhotoView removeFromSuperview];
        _editPhotoView = nil;
        if(_editPhotoView == nil){
            _editPhotoView = [UIScrollView new];
            [_editPhotoView setDelegate:self];
            [_editPhotoView setBackgroundColor:[UIColor whiteColor]];
        }
        [_editPhotoView setFrame:CGRectMake(10, _editContentsTextView.bottomY + 10, _editView.width - 20, 100)];
        [_editView addSubview:_editPhotoView];
        
        [_imageArray removeAllObjects];
        [_btnArray removeAllObjects];
        for(int i =0;i<[_contentsObj.imageArray count];i++){
            UIButton * btn = [UIButton new];
            [btn setFrame:CGRectMake(5+(i*(90+5)), 5, 90, 90)];
            [btn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(imageDeleteAction:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTag:i];
            [btn setRadius:5];
            [_btnArray addObject:btn];
            UIImage *img = [[ImageCacheManager sharedInstance] loadFromMemory:[_contentsObj.imageArray objectAtIndex:i]];
            if(img){
                [btn setBackgroundImage:img forState:UIControlStateNormal];
                [_imageArray addObject:img];
            }else{
                [btn setBackgroundImage
                 :[UIImage imageNamed:@"loading"] forState:UIControlStateNormal];
                [[StorageManager sharedInstance] downFile:[_contentsObj.imageArray objectAtIndex:i] completion:^(UIImage *image) {
                    [[ImageCacheManager sharedInstance] saveImage:image forKey:[_contentsObj.imageArray objectAtIndex:i]];
                    [btn setBackgroundImage:image forState:UIControlStateNormal];
                    [_imageArray addObject:image];
                }];
            }
            [_editPhotoView addSubview:btn];
        }
        
        [_addBtn removeFromSuperview];
        _addBtn = nil;
        if(_addBtn == nil){
            _addBtn = [[UIButton alloc] initWithFrame:CGRectMake(5+([_btnArray count]*(90+5)), 5, 90, 90)];
            [_btnArray addObject:_addBtn];
            [_editPhotoView addSubview:_addBtn];
            [_editPhotoView setShowsHorizontalScrollIndicator:NO];
            [_editPhotoView setContentSize:CGSizeMake(_addBtn.rightX+5, _editPhotoView.height)];
        }
        [_addBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        [_addBtn setImageEdgeInsets:UIEdgeInsetsMake(30, 30, 30, 30)];
        [_addBtn addTarget:self action:@selector(addImageAction:) forControlEvents:UIControlEventTouchUpInside];
        [_addBtn setCircle:[UIColor clearColor] width:1];
    }
}

#pragma mark - Action Methods

- (void)backgroundTouch:(id)sender
{
    [_editTitleTextField resignFirstResponder];
    [_editContentsTextView resignFirstResponder];
    
}

- (IBAction)addAction:(id)sender {
    
    if(_type == kGroupContentsViewType_nomarl){
        _type = kGroupContentsViewType_edit;
        [self initViews];
        
    }else if(_type == kGroupContentsViewType_add){
        [_contentsObj setContentsTitle:_editTitleTextField.text];
        [_contentsObj setContents:_editContentsTextView.text];
        [_contentsObj setCreateDt:[Util fullDateConvertString:[NSDate new]]];
        [_contentsObj setContentsId:[Util timeStamp]];
        [[GUIManager sharedInstance] showLoading];
        if([_imageArray count] > 0){
            [[StorageManager sharedInstance] fileUpload:_imageArray forKey:_contentsObj.contentsId completion:^(NSMutableArray *array) {
                [_contentsObj setImageArray:array];
                [[StorageManager sharedInstance] saveContents:[_contentsObj getDict] forKey:_group.groupId];
                NSMutableString * txt = [NSMutableString new];
                [txt appendString:@"그룹 "];
                [txt appendFormat:@"%@",[_group.groupContents stringByReplacingOccurrencesOfString:@"\n" withString:@" "]];
                [txt appendString:@"에 \n글이 등록 되었습니다."];
                [[PushManager sharedInstance] makePushMessage:_group.groupId message:txt];
                [[GUIManager sharedInstance] hideLoading];
                [[GUIManager sharedInstance] hidePopup:self animation:YES completeData:[_contentsObj getDict]];
            }];
        }else{
            [_contentsObj setImageArray:[NSMutableArray new]];
            [[StorageManager sharedInstance] saveContents:[_contentsObj getDict] forKey:_group.groupId];
            NSMutableString * txt = [NSMutableString new];
            [txt appendString:@"그룹 "];
            [txt appendFormat:@"%@",[_group.groupContents stringByReplacingOccurrencesOfString:@"\n" withString:@" "]];
            [txt appendString:@"에 \n글이 등록 되었습니다."];
            [[PushManager sharedInstance] makePushMessage:_group.groupId message:txt];
            [[GUIManager sharedInstance] hideLoading];
            [[GUIManager sharedInstance] hidePopup:self animation:YES completeData:[_contentsObj getDict]];
        }
        
    }else if(_type == kGroupContentsViewType_edit){
        [[GUIManager sharedInstance] showLoading];
        [_contentsObj setContentsTitle:_editTitleTextField.text];
        [_contentsObj setContents:_editContentsTextView.text];
        [_contentsObj setCreateDt:[Util fullDateConvertString:[NSDate new]]];
        if([_imageArray count] > 0){
            //        [[StorageManager sharedInstance] removeFile:_contentsObj.contentsId completion:^(UIImage *image) {
            [[StorageManager sharedInstance] fileUpload:_imageArray forKey:_contentsObj.contentsId completion:^(NSMutableArray *array) {
                [_contentsObj setImageArray:array];
                [[StorageManager sharedInstance] saveContents:[_contentsObj getDict] forKey:_group.groupId];
                [[GUIManager sharedInstance] hideLoading];
                [[GUIManager sharedInstance] hidePopup:self animation:YES completeData:[_contentsObj getDict]];
            }];
            //        }];
        }else{
            [_contentsObj setImageArray:[NSMutableArray new]];
            [[StorageManager sharedInstance] saveContents:[_contentsObj getDict] forKey:_group.groupId];
            [[GUIManager sharedInstance] hideLoading];
            [[GUIManager sharedInstance] hidePopup:self animation:YES completeData:[_contentsObj getDict]];
        }
    }
}

- (IBAction)cancelAction:(id)sender {
    [[GUIManager sharedInstance] hidePopup:self animation:YES completeData:nil];
}

- (IBAction)normalfileBtnAction:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_contentsObj.filePath] options:@{} completionHandler:nil];
}


- (IBAction)editFileBtnAction:(id)sender {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"알림"
                                                                              message: @"파일 URL을 입력해 주세요!"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"File URL";
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"취소" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * urlTextField = textfields[0];
        [_contentsObj setFilePath:urlTextField.text];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void)addImageAction:(UIButton*)sender
{
    UIImagePickerController * picker = [UIImagePickerController new];
    picker.allowsEditing = YES;
    [picker setDelegate:self];
    
    UIAlertController *av = [UIAlertController alertControllerWithTitle:@"알림" message:@"선택하세요!" preferredStyle:UIAlertControllerStyleActionSheet];
    [av addAction:[UIAlertAction actionWithTitle:@"카메라" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                   {
                       [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
                       [self presentViewController:picker animated:YES completion:nil];
                   }]];
    [av addAction:[UIAlertAction actionWithTitle:@"앨범" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                   {
                       [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                       [self presentViewController:picker animated:YES completion:nil];
                   }]];
    [av addAction:[UIAlertAction actionWithTitle:@"취소" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action)
                   {
                       
                   }]];
    [self presentViewController:av animated:YES completion:nil];
}

- (void)imageDeleteAction:(UIButton*)sender
{
    [_imageArray removeObjectAtIndex:sender.tag];
    [_btnArray removeObjectAtIndex:sender.tag];
    [sender removeFromSuperview];
    sender = nil;
    dispatch_async (dispatch_get_main_queue(), ^{
        for(int i =0;i<[_btnArray count];i++){
            UIButton * btn = [_btnArray objectAtIndex:i];
            [btn setFrame:CGRectMake(5+(i*(90+5)), 5, 90, 90)];
            [btn setTag:i];
        }
    });
    
    
    
}

- (void)showImage:(UIButton*)sender
{
    [[GUIManager sharedInstance] showFullScreenZoomingViewWithImage:[_imageArray objectAtIndex:sender.tag] animate:YES];
}

#pragma mark - UIImagePicker Delegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage * img = [info valueForKey:UIImagePickerControllerEditedImage];
    
    if([_btnArray count] > 0){
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(5+(([_btnArray count]-1)*(90+5)), 5, 90, 90)];
        [btn setBackgroundImage:img forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(imageDeleteAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTag:[_btnArray count]-1];
        [_editPhotoView addSubview:btn];
        [btn setRadius:5];
        [_btnArray insertObject:btn atIndex:[_btnArray count]-1];
        UIButton * add = [_btnArray lastObject];
        [add setFrame:CGRectMake(5+(([_btnArray count]-1)*(90+5)), 5, 90, 90)];
        [_editPhotoView setContentSize:CGSizeMake(add.rightX+5, _editPhotoView.height)];
        [_imageArray addObject:img];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
