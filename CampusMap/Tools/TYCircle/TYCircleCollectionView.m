//
//  TYCircleCollectionView.m
//  TYCircleMenu
//
//  Created by Yeekyo on 16/3/24.
//  Copyright © 2016年 Yeekyo. All rights reserved.
//

#import "TYCircleCollectionView.h"
#import "TYCircleCell.h"
#import "TYCircleCollectionViewLayout.h"
#import "TYCircleMacros.h"

@interface TYCircleCollectionView() <UICollectionViewDataSource, UICollectionViewDelegate>

@end

static NSString *cellId = @"TYCircleCell";

@implementation TYCircleCollectionView
{
    NSInteger selectedIndex;
    BOOL _isCycle;
}
@synthesize isDismissWhenSelected = _isDismissWhenSelected;

- (instancetype)initWithFrame:(CGRect)frame itemOffset:(CGFloat)itemOffset cycle:(BOOL)isCycle imageArray:(NSArray *)images titleArray:(NSArray *)titles {
     _circleLayout = [[TYCircleCollectionViewLayout alloc]initWithRadius:frame.size.height-TYCircleViewMargin  itemOffset:itemOffset];
    return [self initWithFrame:frame collectionViewLayout:_circleLayout cycle:isCycle imageArray:images titleArray:titles];
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout cycle:(BOOL)isCycle imageArray:(NSArray *)images titleArray:(NSArray *)titles {
    
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.showsVerticalScrollIndicator = NO;
        self.dataSource = self;
        self.delegate = self;

        _isCycle = isCycle;
        _menuImages = images;
        _menuTitles = titles;
        selectedIndex = -1;
        [self registerClass:[TYCircleCell class] forCellWithReuseIdentifier:cellId];
    }
    return self;
}

#pragma mark - UICollectionView Delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.menuImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TYCircleCell *cell;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:self.menuImages[indexPath.item]];
    cell.titleLabel.text = self.menuTitles[indexPath.item];
    if (!_isDismissWhenSelected) {
        if (selectedIndex == indexPath.item) {
             cell.bgImageView.image = nil;//empty_btn_highlight
        } else {
            cell.bgImageView.image = nil;//empty_btn
        }
        
        if (_isCycle) {
            //判断镜像
            if (selectedIndex < 6 && indexPath.item == self.menuImages.count-6+selectedIndex) {
                    cell.bgImageView.image = nil;//empty_btn_highlight
            } else if (selectedIndex >= self.menuImages.count-6 && indexPath.item == selectedIndex-(self.menuImages.count-6)) {
                    cell.bgImageView.image = nil;//empty_btn_highlight
            }
        }
    } else {
         cell.bgImageView.image = nil;//empty_btn
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return TYCircleCellSize;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if (_menuDelegate && [_menuDelegate respondsToSelector:@selector(selectMenuAtIndex:)]) {
        NSInteger itemIndex;
        if (_isCycle) {
            if (indexPath.item < 3) {
                itemIndex = indexPath.item + (self.menuImages.count - 9);
            } else if (indexPath.item > self.menuImages.count-4)  {
                itemIndex = indexPath.item-(self.menuImages.count - 4);
            } else {
                itemIndex = indexPath.item-3;
            }
        } else {
            itemIndex = indexPath.item;
        }
        [_menuDelegate selectMenuAtIndex:itemIndex];
    }
    
    if (_isDismissWhenSelected && self.selecteBlock) {
        self.selecteBlock();
    } else {
        selectedIndex = indexPath.item;
        TYCircleCell *selectedCell =
        (TYCircleCell *)[collectionView cellForItemAtIndexPath:indexPath];
        selectedCell.bgImageView.image = nil;//empty_btn_highlight
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!_isDismissWhenSelected) {
        TYCircleCell *selectedCell =
        (TYCircleCell *)[collectionView cellForItemAtIndexPath:indexPath];
        selectedCell.bgImageView.image = nil;//empty_btn
    }
}

#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (!_isCycle) {
        return;
    }
    static CGFloat lastContentOffsetY = FLT_MIN;
    if (lastContentOffsetY == FLT_MIN) {
        lastContentOffsetY = scrollView.contentOffset.y;
        return;
    }
    CGFloat itemHeight = _circleLayout.itemHeight;
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    if (contentOffsetY<itemHeight && contentOffsetY < lastContentOffsetY) {
        lastContentOffsetY = contentOffsetY + (self.menuImages.count - TYDefaultVisibleNum -1)*itemHeight;
        self.contentOffset = CGPointMake(0, (self.menuImages.count - TYDefaultVisibleNum-1)*itemHeight);
    }
    else if (contentOffsetY >(self.menuImages.count - TYDefaultVisibleNum-1)*itemHeight && contentOffsetY >lastContentOffsetY) {
        lastContentOffsetY = contentOffsetY - (self.menuImages.count - TYDefaultVisibleNum-2)*itemHeight;
        self.contentOffset = CGPointMake(0, lastContentOffsetY);
    } else {
        lastContentOffsetY = contentOffsetY;
    }
}


@end
