//
//  SMAssetPickerController.m
//  Base
//
//  Created by sumeng on 15/5/20.
//  Copyright (c) 2015年 sumeng. All rights reserved.
//

#import "SMAssetPickerController.h"

@interface SMAssetModel : NSObject

@property (nonatomic, strong) ALAsset *asset;
@property (nonatomic, strong) UIImage *thumbImage;
@property (nonatomic, assign) BOOL selected;

@end

@implementation SMAssetModel

@end

@interface SMAssetCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *checkedView;

@end

@implementation SMAssetCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_imageView];
        
        _checkedView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ImagePickerChecked"]];
        _checkedView.rightTop = CGPointMake(self.width, 0);
        _checkedView.hidden = YES;
        _checkedView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:_checkedView];
    }
    return self;
}

@end

#define kSMAssetPickerItemSpacing 2.0f
#define kSMAssetPickerItemColumn 4

@interface SMAssetPickerController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSMutableArray *pickedAssets;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *countLbl;
@property (nonatomic, strong) UIButton *doneBtn;

@end

@implementation SMAssetPickerController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [_group valueForProperty:ALAssetsGroupPropertyName];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:_picker action:@selector(cancelImagePicker)];
    self.navigationItem.rightBarButtonItem = cancelButton;
    
    CGFloat w = (MIN(kUIScreenSize.width, kUIScreenSize.height) - (kSMAssetPickerItemColumn + 1) * kSMAssetPickerItemSpacing) / kSMAssetPickerItemColumn;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(w, w);
    layout.minimumInteritemSpacing = kSMAssetPickerItemSpacing;
    layout.minimumLineSpacing = kSMAssetPickerItemSpacing;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 44) collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.allowsMultipleSelection = YES;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_collectionView registerClass:[SMAssetCell class]
            forCellWithReuseIdentifier:reuseIdentifier];
    [self.view addSubview:_collectionView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 44, self.view.width, 44)];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:bottomView];
    
    _doneBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_doneBtn setTitle:@"Done" forState:UIControlStateNormal];
    _doneBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [_doneBtn sizeToFit];
    _doneBtn.rightCenter = CGPointMake(bottomView.width-10, bottomView.height/2);
    [_doneBtn addTarget:self action:@selector(onDoneClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_doneBtn];
    
    _countLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    _countLbl.backgroundColor = RGB(0, 89, 247);
    _countLbl.clipsToBounds = YES;
    _countLbl.layer.cornerRadius = _countLbl.width/2;
    _countLbl.font = [UIFont boldSystemFontOfSize:14];
    _countLbl.textColor = [UIColor whiteColor];
    _countLbl.textAlignment = NSTextAlignmentCenter;
    _countLbl.rightCenter = CGPointMake(_doneBtn.x-5, bottomView.height/2);
    [bottomView addSubview:_countLbl];
    
    self.datas = [[NSMutableArray alloc] init];
    self.pickedAssets = [[NSMutableArray alloc] init];
    if (_picker.pickedAssets.count > 0) {
        [_pickedAssets addObjectsFromArray:_picker.pickedAssets];
    }
    
    [self setSelectedCount:_pickedAssets.count];
    
    [self preparePhotos];
}

#pragma mark - Private

- (void)preparePhotos {
    [SMHud showProgressInView:self.view];
    [_datas removeAllObjects];
    [_group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            SMAssetModel *model = [[SMAssetModel alloc] init];
            model.asset = result;
            model.thumbImage = [UIImage imageWithCGImage:[result thumbnail]];
            model.selected = [self selected:result];
            
            [_datas addObject:model];
        }
    }];
    [SMHud hideProgress];
    [self reloadData];
}

- (BOOL)selected:(ALAsset *)aAsset {
    NSURL *assetUrl = [aAsset valueForProperty:ALAssetPropertyAssetURL];
    for (ALAsset *asset in _pickedAssets) {
        if ([assetUrl isEqual:[asset valueForProperty:ALAssetPropertyAssetURL]]) {
            return YES;
        }
    }
    return NO;
}

- (void)removeSelected:(ALAsset *)aAsset {
    NSURL *assetUrl = [aAsset valueForProperty:ALAssetPropertyAssetURL];
    for (ALAsset *asset in _pickedAssets) {
        if ([assetUrl isEqual:[asset valueForProperty:ALAssetPropertyAssetURL]]) {
            [_pickedAssets removeObject:asset];
            break;
        }
    }
}

- (void)reloadData {
    [_collectionView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_datas.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    });
}

- (void)onDoneClicked:(id)sender {
    [_picker finishPick:_pickedAssets group:_group];
}

- (void)setSelectedCount:(NSUInteger)count {
    _countLbl.text = [NSString stringWithFormat:@"%ld", count];
    _countLbl.hidden = count == 0;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SMAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    SMAssetModel *model = _datas[indexPath.row];
    cell.imageView.image = model.thumbImage;
    cell.checkedView.hidden = !model.selected;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    SMAssetModel *model = _datas[indexPath.row];
    if (model.selected) {
        model.selected = NO;
        [self removeSelected:model.asset];
    }
    else {
        if (_pickedAssets.count < _picker.maximumNumberOfSelection) {
            model.selected = YES;
            [_pickedAssets addObject:model.asset];
        }
    }
    SMAssetCell *cell = (SMAssetCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.checkedView.hidden = !model.selected;
    
    [self setSelectedCount:_pickedAssets.count];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(kSMAssetPickerItemSpacing+1, kSMAssetPickerItemSpacing, kSMAssetPickerItemSpacing, kSMAssetPickerItemSpacing);
}

@end
