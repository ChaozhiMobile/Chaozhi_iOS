//
//  AlbumModel.h
//  TalkfunSDKDemo
//
//  Created by moruiwei on 16/5/17.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlbumModel : NSObject
@property (nonatomic,copy)NSString *access_token;
@property (nonatomic,copy)NSString *duration;
@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *img_small;
@property (nonatomic,copy)NSString *title;


@property (nonatomic,assign) BOOL rotated;
@end
