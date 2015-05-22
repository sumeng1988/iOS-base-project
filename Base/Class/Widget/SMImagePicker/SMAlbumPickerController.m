//
//  SMAlbumPickerController.m
//  Base
//
//  Created by sumeng on 15/5/20.
//  Copyright (c) 2015年 sumeng. All rights reserved.
//

#import "SMAlbumPickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SMAssetPickerController.h"

@interface SMAlbumCell : UITableViewCell

@property (nonatomic, strong) UILabel *countLbl;

@end

@implementation SMAlbumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont systemFontOfSize:16];
        
        _countLbl = [[UILabel alloc] init];
        _countLbl.backgroundColor = [UIColor clearColor];
        _countLbl.font = [UIFont systemFontOfSize:16];
        _countLbl.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_countLbl];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat x = 0;
    
    self.imageView.frame = CGRectMake(0, 0, self.contentView.height, self.contentView.height);
    x += self.imageView.width;
    
    x += 10;
    [self.textLabel sizeToFit];
    self.textLabel.leftCenter = CGPointMake(x, self.contentView.height/2);
    x += self.textLabel.width;
    
    x += 10;
    [_countLbl sizeToFit];
    _countLbl.leftCenter = CGPointMake(x, self.contentView.height/2);
}

@end

@interface SMAlbumPickerController ()

@property (nonatomic, strong) ALAssetsLibrary *library;
@property (nonatomic, strong) NSMutableArray *groups;

@end

@implementation SMAlbumPickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Albums", nil);
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:_picker action:@selector(cancelImagePicker)];
    self.navigationItem.rightBarButtonItem = cancelButton;
    
    self.groups = [[NSMutableArray alloc] init];
    self.library = [SMAlbumPickerController defaultAssetsLibrary];
    
    [self loadAlbums];
}

#pragma mark - Private

- (void)loadAlbums {
    void (^enumerationBlock)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            NSString *groupName = (NSString *)[group valueForProperty:ALAssetsGroupPropertyName];
            NSUInteger nType = [[group valueForProperty:ALAssetsGroupPropertyType] intValue];
            
            if ([[groupName lowercaseString] isEqualToString:@"camera roll"] && nType == ALAssetsGroupSavedPhotos) {
                [_groups insertObject:group atIndex:0];
            }
            else {
                [_groups addObject:group];
            }
            
            NSURL *groupUrl = [group valueForProperty:ALAssetsGroupPropertyURL];
            NSURL *lastGroupUrl = [SMAlbumPickerController lastPickedGroupUrl];
            if ([groupUrl isEqual:lastGroupUrl]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    SMAssetPickerController *vc = [[SMAssetPickerController alloc] init];
                    vc.picker = _picker;
                    vc.group = group;
                    [self.navigationController pushViewController:vc animated:NO];
                });
            }
        }
        else {
            [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
        }
    };
    
    void (^failureBlock)(NSError *) = ^(NSError *error) {
        if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied) {
            NSString *errorMessage = NSLocalizedString(@"This app does not have access to your photos or videos. You can enable access in Privacy Settings.", nil);
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Access Denied", nil) message:errorMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil] show];
        } else {
            NSString *errorMessage = [NSString stringWithFormat:@"Album Error: %@ - %@", [error localizedDescription], [error localizedRecoverySuggestion]];
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:errorMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil] show];
        }
    };
    
    [_library enumerateGroupsWithTypes:ALAssetsGroupAll
                            usingBlock:enumerationBlock
                          failureBlock:failureBlock];
}

- (void)reloadTableView {
    [self.tableView reloadData];
}

+ (ALAssetsLibrary *)defaultAssetsLibrary {
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

#pragma mark - Last Picked Group

#define kSMAlbumPickerLastGroup @"SMImagePickerLastGroup"

+ (NSURL *)lastPickedGroupUrl {
    NSString *url = [[NSUserDefaults standardUserDefaults] valueForKey:kSMAlbumPickerLastGroup];
    return url ? [NSURL URLWithString:url] : nil;
}

+ (void)savePickedGroup:(ALAssetsGroup *)group {
    NSURL *groupUrl = [group valueForProperty:ALAssetsGroupPropertyURL];
    [[NSUserDefaults standardUserDefaults] setObject:groupUrl.absoluteString forKey:kSMAlbumPickerLastGroup];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _groups.count;
}

#pragma mark - UITableViewDelegate

static NSString * const reuseIdentifier = @"Cell";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SMAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[SMAlbumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    ALAssetsGroup *group = _groups[indexPath.row];
    [group setAssetsFilter:_picker.assetsFilter];
    
    NSString *name = [group valueForProperty:ALAssetsGroupPropertyName];
    NSInteger count = [group numberOfAssets];
    
    cell.textLabel.text = name;
    cell.countLbl.text = [NSString stringWithFormat:@"(%ld)", count];
    cell.imageView.image = [UIImage imageWithCGImage:[group posterImage]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SMAssetPickerController *vc = [[SMAssetPickerController alloc] init];
    vc.picker = _picker;
    vc.group = _groups[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
