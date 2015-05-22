//
//  PickImagesVC.m
//  Base
//
//  Created by sumeng on 15/5/22.
//  Copyright (c) 2015年 sumeng. All rights reserved.
//

#import "PickImagesVC.h"
#import "SMImagePickerController.h"

@interface PickCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation PickCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_imageView];
    }
    return self;
}

@end

static NSString * const reuseIdentifier = @"Cell";

@interface PickImagesVC () <SMImagePickerControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *selectedAssets;
@property (nonatomic, strong) UIBarButtonItem *addItem;
@property (nonatomic, strong) UIBarButtonItem *clearItem;

@end

@implementation PickImagesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Pick";
    _addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add)];
    _clearItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(clear)];
    self.navigationItem.rightBarButtonItems = @[_clearItem, _addItem];
    
    _selectedAssets = [[NSMutableArray alloc] init];
    
    CGFloat w = (MIN(kUIScreenSize.width, kUIScreenSize.height) - (4 + 1) * 2) / 4;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(w, w);
    layout.minimumInteritemSpacing = 2;
    layout.minimumLineSpacing = 2;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_collectionView registerClass:[PickCell class]
        forCellWithReuseIdentifier:reuseIdentifier];
    [self.view addSubview:_collectionView];
    
    [self refreshItems];
}

- (void)refreshItems {
    _clearItem.enabled = _selectedAssets.count > 0;
}

- (void)add {
    SMImagePickerController *picker = [[SMImagePickerController alloc] init];
    picker.imagePickerDelegate = self;
    picker.selectedAssets = _selectedAssets;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)clear {
    [_selectedAssets removeAllObjects];
    [_collectionView reloadData];
    
    [self refreshItems];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _selectedAssets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PickCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    ALAsset *asset = _selectedAssets[indexPath.row];
    cell.imageView.image = [UIImage imageWithCGImage:[asset thumbnail]];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(2+1, 2, 2, 2);
}

#pragma mark - SMImagePickerControllerDelegate

- (void)smImagePickerController:(SMImagePickerController *)picker didFinishPickingMediaWithAssets:(NSArray *)asset {
    [_selectedAssets removeAllObjects];
    [_selectedAssets addObjectsFromArray:asset];
    [_collectionView reloadData];
    [self refreshItems];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
