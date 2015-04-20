//
//  ViewController.m
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "ViewController.h"
#import "ApiDemo.h"

@interface ViewController () <SMImagePickerDelegate>

@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) SMImagePicker *picker;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"Base";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"take photo" style:UIBarButtonItemStylePlain target:self action:@selector(takePhoto)];
    
    _datas = [[NSMutableArray alloc] init];
    
    _picker = [[SMImagePicker alloc] initWithDelegate:self];
    _picker.maxCount = 3;
}

- (void)refresh:(BOOL)flush {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (flush) {
            [_datas removeAllObjects];
        }
        for (int i = 0; i < 5; i++) {
            [_datas addObject:@" "];
        }
        [self.tableView reloadData];
        [self endFlush];
        [self endLoadmore];
        self.noMoreData = _datas.count >= 10;
        self.needPullFlush = _datas.count < 10;
        self.needPullLoadmore = YES;
    });
}

#pragma mark - private

- (void)takePhoto {
    [_picker executeInViewController:self];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row+1];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

#pragma mark - SMImagePickerDelegate

- (void)imagePicker:(SMImagePicker *)picker successed:(NSArray *)thumbImages
{
    ApiDemo *api = [[ApiDemo alloc] init];
    api.username = @"demo";
    api.password = @"123";
    api.avatar = picker.paths[0];
    [api POST:nil failure:nil];
}

@end
