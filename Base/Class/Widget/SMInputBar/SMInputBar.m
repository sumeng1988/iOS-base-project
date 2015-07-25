//
//  SMInputBar.m
//  Base
//
//  Created by sumeng on 5/5/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#define kInputBarPaddingHorizontal 4
#define kInputBarPaddingVertical 8
#define kInputBarInputViewHeightMin (kInputBarHeightDefault-kInputBarPaddingVertical*2)
#define kInputBarInputViewHeightMax (kInputBarHeightMax-kInputBarPaddingVertical*2)

#define kSMInputBarAnimateDuration 0.25f

#import "SMInputBar.h"
#import "SMEmotionPanel.h"
#import "SMExtentionPanel.h"
#import "EmotionInfo.h"

@interface SMInputBar () <UITextViewDelegate, SMEmotionPanelDelegate, SMImagePickerDelegate>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UITextView *inputView;
@property (nonatomic, strong) UILabel *placeholderLbl;
@property (nonatomic, strong) UIButton *emotionBtn;
@property (nonatomic, strong) UIButton *extentionBtn;

@property (nonatomic, strong) UIView *panelView;
@property (nonatomic, strong) SMEmotionPanel *emotionPanel;
@property (nonatomic, strong) SMExtentionPanel *extentionPanel;

@end

@implementation SMInputBar

- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, 0, kUIScreenSize.width, kInputBarHeightDefault)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    _status = SMInputBarStatusNone;
    
    _headerView = [[UIView alloc] initWithFrame:self.bounds];
    _headerView.backgroundColor = [UIColor colorWithRGB:0xF7F7F7];
    _headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:_headerView];
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 1)];
    topLine.backgroundColor = [UIColor colorWithRGB:0xADADAD];
    topLine.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_headerView addSubview:topLine];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-1, self.width, 1)];
    bottomLine.backgroundColor = [UIColor colorWithRGB:0xADADAD];
    bottomLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [_headerView addSubview:bottomLine];
    
    UIImage *extentionImage = [UIImage imageNamed:@"inputbar_extention"];
    _extentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_extentionBtn setImage:extentionImage forState:UIControlStateNormal];
    _extentionBtn.size = CGSizeMake(extentionImage.size.width+kInputBarPaddingHorizontal*2, extentionImage.size.height+kInputBarPaddingHorizontal*2);
    _extentionBtn.rightCenter = CGPointMake(_headerView.width, _headerView.height / 2);
    _extentionBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [_extentionBtn addTarget:self action:@selector(onExtentionClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_extentionBtn];
    
    UIImage *emotionImage = [UIImage imageNamed:@"inputbar_emotion"];
    _emotionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_emotionBtn setImage:emotionImage forState:UIControlStateNormal];
    _emotionBtn.size = CGSizeMake(emotionImage.size.width+kInputBarPaddingHorizontal*2, emotionImage.size.height+kInputBarPaddingHorizontal*2);
    _emotionBtn.rightCenter = CGPointMake(_extentionBtn.x, _headerView.height / 2);
    _emotionBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [_emotionBtn addTarget:self action:@selector(onEmotionClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_emotionBtn];
    
    _inputView = [[UITextView alloc] init];
    _inputView.size = CGSizeMake(_emotionBtn.x - kInputBarPaddingHorizontal * 2, _headerView.height - kInputBarPaddingVertical * 2);
    _inputView.leftCenter = CGPointMake(kInputBarPaddingHorizontal, _headerView.height / 2);
    _inputView.delegate = self;
    _inputView.layer.borderColor = [[UIColor colorWithRGB:0xC7C7C7] CGColor];
    _inputView.layer.borderWidth = 1;
    _inputView.layer.cornerRadius = 4;
    _inputView.backgroundColor = [UIColor colorWithRGB:0xFAFAFA];
    _inputView.font = [UIFont systemFontOfSize:16];
    _inputView.textColor = [UIColor blackColor];
    _inputView.textContainerInset = UIEdgeInsetsMake(4, 2, 4, 2);
    _inputView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_headerView addSubview:_inputView];
    
    _placeholderLbl = [[UILabel alloc] init];
    _placeholderLbl.backgroundColor = [UIColor clearColor];
    _placeholderLbl.textColor = [UIColor colorWithRGB:0xC7C7C7];
    _placeholderLbl.font = [UIFont systemFontOfSize:16];
    [_headerView addSubview:_placeholderLbl];
    
    _panelView = [[UIView alloc] initWithFrame:CGRectMake(0, _headerView.height, self.width, 0)];
    _panelView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _panelView.backgroundColor = [UIColor colorWithRGB:0xF7F7F7];
    [self addSubview:_panelView];
    
    self.placeholder = @"Text Message";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShowKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willHideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - public

- (BOOL)canBecomeFirstResponder {
    return [_inputView canBecomeFirstResponder];
}

- (BOOL)becomeFirstResponder {
    return [_inputView becomeFirstResponder];
}

- (BOOL)canResignFirstResponder {
    return [_inputView canResignFirstResponder];
}

- (BOOL)resignFirstResponder {
    return [_inputView resignFirstResponder];
}

- (void)setText:(NSString *)text {
    _inputView.text = text;
    
    [self textViewDidChange:_inputView];
}

- (NSString *)text {
    return _inputView.text;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholderLbl.text = placeholder;
    [_placeholderLbl sizeToFit];
    if (_placeholderLbl.width > _inputView.width - 14) {
        _placeholderLbl.width = _inputView.width - 14;
    }
    _placeholderLbl.leftTop = CGPointMake(_inputView.x+7, _inputView.y+5);
}

- (NSString *)placeholder {
    return _placeholderLbl.text;
}

- (void)setStatus:(SMInputBarStatus)status {
    if (_status != status) {
        _status = status;
        [self setIconWithStatus:status];
        
        for (UIView *v in _panelView.subviews) {
            [v removeFromSuperview];
        }
        _panelView.height = 0;
        
        UIView *targetPanel = nil;
        if (status == SMInputBarStatusNone) {
            [self resignFirstResponder];
        }
        else if (status == SMInputBarStatusKeyboard) {
            [self becomeFirstResponder];
        }
        else if (status == SMInputBarStatusEmotion) {
            [self resignFirstResponder];
            if (_emotionPanel == nil) {
                _emotionPanel = [[SMEmotionPanel alloc] initWithFrame:CGRectMake(0, 0, _panelView.width, kSMEmotionPanelHeight)];
                _emotionPanel.backgroundColor = [UIColor colorWithRGB:0xF7F7F7];
                _emotionPanel.delegate = self;
                _emotionPanel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            }
            targetPanel = _emotionPanel;
        }
        else if (status == SMInputBarStatusExtantion) {
            [self resignFirstResponder];
            if (_extentionPanel == nil) {
                _extentionPanel = [[SMExtentionPanel alloc] initWithFrame:CGRectMake(0, 0, _panelView.width, kSMExtentionPanelHeight)];
                _extentionPanel.backgroundColor = [UIColor colorWithRGB:0xF7F7F7];
                _extentionPanel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                [_extentionPanel addTarget:self action:@selector(onExtentionGalleryClicked:) forEvent:SMExtentionPanelEventGallery];
                [_extentionPanel addTarget:self action:@selector(onExtentionCameraClicked:) forEvent:SMExtentionPanelEventCamera];
            }
            targetPanel = _extentionPanel;
        }
        if (targetPanel != nil) {
            _panelView.height = targetPanel.height;
            [_panelView addSubview:targetPanel];
            
            targetPanel.y = _panelView.height;
            [UIView animateWithDuration:kSMInputBarAnimateDuration
                             animations:^{
                                 targetPanel.y = 0;
                             }
                             completion:^(BOOL finished) {
                                 
                             }];
        }
        
        if (_status != SMInputBarStatusKeyboard) {
            CGRect frame = self.frame;
            frame.size.height = _headerView.height + _panelView.height;
            [self changeFrame:frame withDuration:kSMInputBarAnimateDuration];
        }
    }
}

#pragma mark - private

- (void)sendText {
    if (_delegate && [_delegate respondsToSelector:@selector(inputBar:sendText:)])
    {
        [_delegate inputBar:self sendText:self.text];
    }
}

- (void)sendImages:(NSArray *)paths {
    if (_delegate && [_delegate respondsToSelector:@selector(inputBar:sendImages:)])
    {
        [_delegate inputBar:self sendImages:paths];
    }
}

- (void)willChangeFrame:(CGRect)frame withDuration:(NSTimeInterval)duration {
    if (_delegate && [_delegate respondsToSelector:@selector(inputBar:willChangeFrame:withDuration:)])
    {
        [_delegate inputBar:self willChangeFrame:frame withDuration:duration];
    }
}

- (void)didChangeFrame:(CGRect)frame {
    if (_delegate && [_delegate respondsToSelector:@selector(inputBar:didChangeFrame:)])
    {
        [_delegate inputBar:self didChangeFrame:frame];
    }
}

- (void)changeFrame:(CGRect)frame withDuration:(NSTimeInterval)duration {
    if (self.height != frame.size.height) {
        self.frame = frame;
        [self willChangeFrame:frame withDuration:duration];
        [UIView animateWithDuration:duration
                         animations:^{
//                             self.frame = frame;
                         }
                         completion:^(BOOL finished) {
                             [self didChangeFrame:frame];
                         }];
    }
}

- (void)setIconWithStatus:(SMInputBarStatus)status {
    UIImage *emotionImage = [UIImage imageNamed:@"inputbar_emotion"];
    UIImage *extentionImage = [UIImage imageNamed:@"inputbar_extention"];
    UIImage *keyboardImage = [UIImage imageNamed:@"inputbar_keyboard"];
    switch (status) {
        case SMInputBarStatusEmotion:
            [_emotionBtn setImage:keyboardImage
                         forState:UIControlStateNormal];
            [_extentionBtn setImage:extentionImage
                           forState:UIControlStateNormal];
            break;
        case SMInputBarStatusExtantion:
            [_emotionBtn setImage:emotionImage
                         forState:UIControlStateNormal];
            [_extentionBtn setImage:keyboardImage
                           forState:UIControlStateNormal];
            break;
        default:
            [_emotionBtn setImage:emotionImage
                         forState:UIControlStateNormal];
            [_extentionBtn setImage:extentionImage
                           forState:UIControlStateNormal];
            break;
    }
}

- (void)onEmotionClicked:(id)sender {
    if (_status != SMInputBarStatusEmotion) {
        self.status = SMInputBarStatusEmotion;
    }
    else {
        [self becomeFirstResponder];
    }
}

- (void)onExtentionClicked:(id)sender {
    if (_status != SMInputBarStatusExtantion) {
        self.status = SMInputBarStatusExtantion;
    }
    else {
        [self becomeFirstResponder];
    }
}

- (void)willShowKeyboard:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSTimeInterval duration = [userInfo doubleForKey:UIKeyboardAnimationDurationUserInfoKey def:kSMInputBarAnimateDuration];
    CGRect kbFrame = [value CGRectValue];
    _panelView.height = kbFrame.size.height;
    
    CGRect frame = self.frame;
    frame.size.height = _headerView.height + _panelView.height;
    [self changeFrame:frame withDuration:duration];
}

- (void)willHideKeyboard:(NSNotification *)notification {
    if (_status == SMInputBarStatusKeyboard
        || _status == SMInputBarStatusNone)
    {
        NSDictionary *userInfo = [notification userInfo];
        NSTimeInterval duration = [userInfo doubleForKey:UIKeyboardAnimationDurationUserInfoKey def:kSMInputBarAnimateDuration];
        _panelView.height = 0;
        
        CGRect frame = self.frame;
        frame.size.height = _headerView.height + _panelView.height;
        [self changeFrame:frame withDuration:duration];
    }
}

- (void)deleteTextOfInputViewInRange:(NSRange)rg {
    NSInteger location = rg.location+rg.length;
    if (self.text.length >= location && self.text.length > 0 && rg.length > 0) {
        NSString * keepstr = [self.text substringFromIndex:location];
        NSString * changedstr = [self.text substringToIndex:location];
        NSRange range = NSMakeRange(changedstr.length-rg.length, rg.length);
        if ([changedstr endOfEmotion].length > 0) {
            range = [changedstr endOfEmotion];
        }
        changedstr = [changedstr substringToIndex:range.location];
        self.text = [changedstr stringByAppendingString:keepstr];
        _inputView.selectedRange = NSMakeRange(location-range.length, 0);
    }
}

- (void)onExtentionGalleryClicked:(id)sender {
    SMImagePicker *picker = [[SMImagePicker alloc] initWithDelegate:self];
    [picker execute:UIImagePickerControllerSourceTypePhotoLibrary inViewController:[self viewController]];
}

- (void)onExtentionCameraClicked:(id)sender {
    SMImagePicker *picker = [[SMImagePicker alloc] initWithDelegate:self];
    [picker execute:UIImagePickerControllerSourceTypeCamera inViewController:[self viewController]];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.status = SMInputBarStatusKeyboard;
}

- (void)textViewDidChange:(UITextView *)textView {
    _placeholderLbl.hidden = textView.text.notEmpty;
    
    CGSize size = [textView sizeThatFits:textView.size];
    textView.scrollEnabled = size.height >= kInputBarInputViewHeightMax;
    
    if (size.height < kInputBarInputViewHeightMin) {
        size.height = kInputBarInputViewHeightMin;
    }
    else if (size.height > kInputBarInputViewHeightMax) {
        size.height = kInputBarInputViewHeightMax;
    }
    if (size.height != textView.size.height) {
        _headerView.height = size.height + kInputBarPaddingVertical * 2;
        _panelView.y = _headerView.height;
        
        CGRect frame = self.frame;
        frame.size.height = _headerView.height + _panelView.height;
        [self changeFrame:frame withDuration:kSMInputBarAnimateDuration];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self sendText];
        return NO;
    }
    else if ([text isEqualToString:@""]) {
        [self deleteTextOfInputViewInRange:range];
        return NO;
    }
    return YES;
}

#pragma mark - SMEmotionPanelDelegate

- (void)emotionPanel:(SMEmotionPanel *)panel pickEmotion:(NSString *)emotion {
    NSRange range = _inputView.selectedRange;
    NSMutableString *str = [NSMutableString stringWithString:self.text];
    [str insertString:emotion atIndex:range.location];
    self.text = str;
    _inputView.selectedRange = NSMakeRange(range.location + emotion.length, 0);
}

- (void)emotionPanelDelete:(SMEmotionPanel *)panel {
    NSRange range = _inputView.selectedRange;
    if (range.location > 0) {
        NSRange characterRange = [self.text rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:self.text] options:NSBackwardsSearch];
        NSInteger length = MAX(1, characterRange.length);
        [self deleteTextOfInputViewInRange:NSMakeRange(range.location-length, length)];
    }
}

- (void)emotionPanelSend:(SMEmotionPanel *)panel {
    [self sendText];
}

#pragma mark - SMImagePickerDelegate

- (void)imagePicker:(SMImagePicker *)picker didFinishPickingWithInfos:(NSArray *)infos; {
    NSMutableArray *paths = [[NSMutableArray alloc] initWithCapacity:infos.count];
    for (NSDictionary *info in infos) {
        [paths addObject:[info objectForKey:kImagePickerPath]];
    }
    [self sendImages:paths];
}

@end
