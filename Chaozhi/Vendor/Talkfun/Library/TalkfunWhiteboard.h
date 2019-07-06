//
//  TalkfunWhiteboardV2.h
//  CloudLive
//
//  Created by LuoLiuyou on 16/8/18.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//观看端 才设置 ,直播端不用设置

typedef enum: NSUInteger{
    TalkfunWhiteboarModelEdit = 0,            //编辑模式可以涂鸦涂鸦
    TalkfunWhiteboarModelScroll = 1,         ///滚动模式不可涂鸦
}TalkfunWhiteboarModel;



typedef enum: NSUInteger{
    TalkfunDrawTypeStroke,//画笔
    TalkfunDrawTypeCircle,//圆形
    TalkfunDrawTypeRectangle,//矩形
    TalkfunDrawTypeStraightLine,//直线
    TalkfunDrawTypeDottedLine,//虚线
    TalkfunDrawTypeBoxDelete,//框删除
    TalkfunDrawTypeArrow,//箭头
    TalkfunDrawTypeText//文本
}TalkfunDrawType;
//画笔颜色
typedef enum: NSUInteger{
    
    TalkfunDrawBlackColor,  //黑
    TalkfunDrawRedColor,    //红
    TalkfunDrawYellowColor, //黄
    TalkfunDrawGreenColor,  //绿
    TalkfunDrawBlueColor,   //蓝
    TalkfunDrawBrownColor ,  //棕
    TalkfunDrawWhiteColor  , //白
    TalkfunDrawWhiteCyanColor  , //青色
    TalkfunDrawWhitePurpleColor  //紫色
}TalkfunDrawColor;

//画笔大小
typedef enum: NSUInteger{
    TalkfunDrawLineWidthSmall = 2,          //小
    TalkfunDrawLineWidthMiddle = 4,         //中
    TalkfunDrawLineWidthBig = 6,           //大
    TalkfunDrawLineWidthLarge = 8,
    TalkfunDrawLineWidthHuge = 10            // 特大
    
}TalkfunDrawLineWidth;

//文字大小
typedef enum: NSUInteger{
    
    TalkfunDrawTextSizeSmall = 20,          //小
    TalkfunDrawTextSizeMiddle = 25,         //中
    TalkfunDrawTextSizeBig = 30,           //大
    TalkfunDrawTextSizeHuge = 35           //特大
}TalkfunDrawTextSize;




@protocol TalkfunWhiteboardDelegate <NSObject>
@optional

//- (void)whiteboardDidTouched;

//偏移量     是否显示slide    画板内容大小
- (void)witeboardDocument:(CGFloat)contentOffset  contentHeight:( CGFloat )contentHeight contentSlider:(BOOL)show;
//
//是否还能 撤退;
- (void)whiteboardDidUndo:(BOOL)canUndo;
//是否还能 前进
- (void)whiteboardDidRedo:(BOOL)canRedo;
//请求当前页数 是否有 笔画数据
- (void)requestDrawingBoardData:(NSDictionary*)dict  callback:(void (^)(NSArray *result))callback;


//观看端:叫代理 对象从本地获取 图片, 然后通过 返回
- (UIImage*)getImageWithUrl:(NSString*)URL;

//画板当前页的白板与ppt的frame
- (void)whiteboardPageFrame:(CGRect)frame;
@end


@interface TalkfunWhiteboard : UIView

//是否支持滚动ppt
//@property (nonatomic,assign)  BOOL scroll ;
@property (nonatomic,assign)  TalkfunWhiteboarModel whiteboarModel;

//是否设置涂鸦  默认 为 NO
@property (nonatomic,assign) BOOL graffiti;


/** 代理对象 */
@property (nonatomic, weak) id<TalkfunWhiteboardDelegate> delegate;



//whiteboardBackgroundColor 要用RGB色值
//[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1];

/** 新建画板的背景色 */
@property(nonatomic,strong)UIColor *whiteboardBackgroundColor;
//画板类型
@property (nonatomic, assign) TalkfunDrawType drawType;



//@property (nonatomic, assign) TalkfunWhiteboarModel WhiteboarModel;

//画笔颜色
@property (nonatomic, assign) TalkfunDrawColor lineColor;
//画笔宽度
@property (nonatomic, assign) TalkfunDrawLineWidth lineWidth;

//文字大小
@property (nonatomic, assign) TalkfunDrawTextSize  textSize;

//当前页码
@property (readonly,nonatomic) NSInteger currentPage;
//当前子页码
@property (readonly,nonatomic) NSInteger currentSubPage;
//总页数
@property (readonly,nonatomic) NSInteger totalPage;

//当前索引
@property (readonly,nonatomic) NSInteger currentIndex;

//当前子页索引
@property (readonly,nonatomic) NSInteger currentSubIndex;



+ (id)shared;
//外面传入rgb颜色
- (void)setLineRgbColor:(UIColor*)rgbColor;

/**上一页*/
- (void)movePrevious:(void (^)(NSDictionary *result))callback;

/**下一页*/
- (void)moveNext:(void (^)(NSDictionary *result))callback;

/**移动到某个索引*/
- (void)moveToIndex:(NSInteger)index callback:(void (^)(NSDictionary *result))callback;




/**插入白板,根据当前的索引,再添加在后面  */
-(void)insertWhiteboard;

/**添加白板, 白板永远在前面,文档在后面 */
-(void)addWhiteboard;
//
/**撤退*/
- (void)undo;
/**前进*/
- (void)redo;

//是否能够撤退*/
- (BOOL)canUndo;
/**是否能够前进*/
- (BOOL)canRedo;

/**使用偏移量进行文档预览*/
- (void)previewDocumentWithContentOffset:(CGFloat)offset;

/**移动文档偏移量*/
- (void)moveDocumentToContentOffset:(CGFloat)offset;


//传入指令  执行操作
- (void)execute:(NSDictionary *)command;

//清空当前页涂鸦
-(void)clearDraw;
//清除所有页码的涂鸦
-(void)ClearData;

/**销毁*/
- (void)shutdown;
@end
