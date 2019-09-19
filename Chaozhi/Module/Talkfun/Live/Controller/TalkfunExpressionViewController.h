//
//  TalkfunExpressionViewController.h
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 2016/12/19.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TalkfunExpressionCloseButton;
@interface TalkfunExpressionViewController : UIViewController

@property (nonatomic,strong) NSMutableArray * dataSource;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,copy) void (^expressionBlock)(NSString *expressionName);
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewFlowLayout;
@property (weak, nonatomic) IBOutlet TalkfunExpressionCloseButton *deleteBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteBtnTopSpace;

@end
