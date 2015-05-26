//
//  PickImagesVC.m
//  Base
//
//  Created by sumeng on 15/5/22.
//  Copyright (c) 2015年 sumeng. All rights reserved.
//

#import "PickImagesVC.h"
#import "SMImagePicker.h"

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

@interface PickImagesVC () <SMImagePickerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *pickedInfos;
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
    
    _pickedInfos = [[NSMutableArray alloc] init];
    
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
    _clearItem.enabled = _pickedInfos.count > 0;
}

- (void)add {
    SMImagePicker *picker = [[SMImagePicker alloc] initWithDelegate:self];
    picker.maximumNumberOfSelection = 9 - _pickedInfos.count;
    [picker execute:UIImagePickerControllerSourceTypePhotoLibrary inViewController:self];
}

- (void)clear {
    [_pickedInfos removeAllObjects];
    [_collectionView reloadData];
    
    [self refreshItems];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _pickedInfos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PickCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSDictionary *info = _pickedInfos[indexPath.row];
    cell.imageView.image = [info objectForKey:kImagePickerThumbImage];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(2+1, 2, 2, 2);
}

#pragma mark - SMImagePickerDelegate

- (void)imagePicker:(SMImagePicker *)picker didFinishPickingWithInfos:(NSArray *)infos {
    [_pickedInfos addObjectsFromArray:infos];
    [_collectionView reloadData];
    [self refreshItems];
}

@end
