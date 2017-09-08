
//
//  AxcLineLayoutVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/9/8.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcLineLayoutVC.h"


@interface AxcLineLayoutVC ()


@property(nonatomic,strong)NSArray *dataArray;


@end

@implementation AxcLineLayoutVC

- (void)viewDidLoad {
    [super viewDidLoad];
 
    // 这个线性布局相信大家也发现一个Bug了，就是有滑动到有固定个数的Item时，Cell并没有按照动画来变形
    // 而是以变形前的状态进入大约50pt之后突然形变
    // 这是因为在Layout的 layoutAttributesForElementsInRect 函数中，获取到的Cell是复用复原后的cell
    // 在遍历动画item组中并不存在那个Cell，所以他的大小不会被设置
    // 之后彻底出现后，才会被遍历到然后进行设置动画属性，这个问题我在尝试和查看了多个Demo无法解决
    
    // 目前比较坑的解决方案是，将CollectionView的宽度边长，让他提前“进入”判断范围内，将闪烁在屏幕外完成
    // 谁有比较好的解决方案欢迎讨论啊啊啊。。这个问题普遍线性布局都存在
    
    AxcUI_SingleLineLayout *layout = [[AxcUI_SingleLineLayout alloc] init];
    
    layout.itemSize = CGSizeMake(300, 200);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = -30;
    
    
    self.collectionViewFlowLayout = layout;
}



@end
