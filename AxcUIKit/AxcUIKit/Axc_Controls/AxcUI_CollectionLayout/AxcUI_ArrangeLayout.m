//
//  AxcUI_ArrangeLayout.m
//  AxcUIKit
//
//  Created by Axc on 2017/8/26.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import "AxcUI_ArrangeLayout.h"

@interface AxcUI_ArrangeLayout(){
    //在居中对齐的时候需要知道这行所有cell的宽度总和
    CGFloat _sumWidth ;
}
@end

@implementation AxcUI_ArrangeLayout

-(instancetype)init{
    self = [super init];
    if (self){
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.minimumLineSpacing = 5;
        self.minimumInteritemSpacing = 5;
        self.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        _axcUI_betweenOfCell = 5.0;
        _axcUI_layoutAlignStyle = AxcArrangeLayoutAlignStyleAlignLeft;
    }
    return self;
}
-(void)setAxcUI_betweenOfCell:(CGFloat)axcUI_betweenOfCell{
    _axcUI_betweenOfCell = axcUI_betweenOfCell;
    self.minimumInteritemSpacing = axcUI_betweenOfCell;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray * layoutAttributes_t = [super layoutAttributesForElementsInRect:rect];
    NSArray * layoutAttributes = [[NSArray alloc]initWithArray:layoutAttributes_t copyItems:YES];
    //用来临时存放一行的Cell数组
    NSMutableArray * layoutAttributesTemp = [[NSMutableArray alloc]init];
    for (NSUInteger index = 0; index < layoutAttributes.count ; index++) {
        
        UICollectionViewLayoutAttributes *currentAttr = layoutAttributes[index]; // 当前cell的位置信息
        UICollectionViewLayoutAttributes *previousAttr = index == 0 ? nil : layoutAttributes[index-1]; // 上一个cell 的位置信
        UICollectionViewLayoutAttributes *nextAttr = index + 1 == layoutAttributes.count ?
        nil : layoutAttributes[index+1];//下一个cell 位置信息
        
        //加入临时数组
        [layoutAttributesTemp addObject:currentAttr];
        _sumWidth += currentAttr.frame.size.width;
        
        CGFloat previousY = previousAttr == nil ? 0 : CGRectGetMaxY(previousAttr.frame);
        CGFloat currentY = CGRectGetMaxY(currentAttr.frame);
        CGFloat nextY = nextAttr == nil ? 0 : CGRectGetMaxY(nextAttr.frame);
        //如果当前cell是单独一行
        if (currentY != previousY && currentY != nextY){
            if ([currentAttr.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
                [layoutAttributesTemp removeAllObjects];
                _sumWidth = 0.0;
            }else if ([currentAttr.representedElementKind isEqualToString:UICollectionElementKindSectionFooter]){
                [layoutAttributesTemp removeAllObjects];
                _sumWidth = 0.0;
            }else{
                [self setCellFrameWith:layoutAttributesTemp];
            }
        }
        //如果下一个cell在本行，这开始调整Frame位置
        else if( currentY != nextY) {
            [self setCellFrameWith:layoutAttributesTemp];
        }
    }
    return layoutAttributes;
}

- (void)setCellFrameWith:(NSMutableArray*)layoutAttributes{
    CGFloat nowWidth = 0.0;
    switch (_axcUI_layoutAlignStyle) {
        case AxcArrangeLayoutAlignStyleAlignLeft:
            nowWidth = self.sectionInset.left;
            for (UICollectionViewLayoutAttributes * attributes in layoutAttributes) {
                CGRect nowFrame = attributes.frame;
                nowFrame.origin.x = nowWidth;
                attributes.frame = nowFrame;
                nowWidth += nowFrame.size.width + self.axcUI_betweenOfCell;
            }
            _sumWidth = 0.0;
            [layoutAttributes removeAllObjects];
            break;
        case AxcArrangeLayoutAlignStyleAlignCenter:
            nowWidth = (self.collectionView.frame.size.width - _sumWidth - ((layoutAttributes.count - 1) * _axcUI_betweenOfCell)) / 2;
            for (UICollectionViewLayoutAttributes * attributes in layoutAttributes) {
                CGRect nowFrame = attributes.frame;
                nowFrame.origin.x = nowWidth;
                attributes.frame = nowFrame;
                nowWidth += nowFrame.size.width + self.axcUI_betweenOfCell;
            }
            _sumWidth = 0.0;
            [layoutAttributes removeAllObjects];
            break;
            
        case AxcArrangeLayoutAlignStyleAlignRight:
            nowWidth = self.collectionView.frame.size.width - self.sectionInset.right;
            for (NSInteger index = layoutAttributes.count - 1 ; index >= 0 ; index-- ) {
                UICollectionViewLayoutAttributes * attributes = layoutAttributes[index];
                CGRect nowFrame = attributes.frame;
                nowFrame.origin.x = nowWidth - nowFrame.size.width;
                attributes.frame = nowFrame;
                nowWidth = nowWidth - nowFrame.size.width - _axcUI_betweenOfCell;
            }
            _sumWidth = 0.0;
            [layoutAttributes removeAllObjects];
            break;
            
    }
}

@end
