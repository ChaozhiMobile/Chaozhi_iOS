//
//  NetworkSelectionViewController.h
//  Talkfun_demo
//
//  Created by moruiwei on 16/1/27.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import <UIKit/UIKit.h>
#define APPLICATION [UIApplication sharedApplication]
// name:block类型的别名
typedef void(^networkOperators)(NSDictionary *str);

//typedef void(^lineBlock)(NSInteger line);
@interface NetworkSelectionViewController : UIViewController
@property (nonatomic,assign ) BOOL           rotated;//屏幕方向
@property (nonatomic,strong ) NSMutableArray        * networkSelectionArray;//字典数据数组
//默认的当前网络的ip数据
@property(nonatomic,strong)NSMutableDictionary *network;

@property (nonatomic, strong) NSMutableArray *choiceArray;//模型数据
@property (weak, nonatomic  ) IBOutlet UIButton       *exit;
@property (nonatomic, strong) networkOperators    networkOperators ;



//保存用户选择的网络
@property (assign, nonatomic) NSInteger      selectedNumber;

- (void)networkSpeed:(id)obj;

@end
