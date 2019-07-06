
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define SYSTEM_VERSION   [[UIDevice currentDevice].systemVersion floatValue]
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define isIPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define PERFORM_IN_MAIN_QUEUE(method) if ([NSThread currentThread].isMainThread) {method}else{dispatch_async(dispatch_get_main_queue(), ^{method});}

#define UIColorFromRGB(r,g,b) [UIColor colorWithRed:(float)r/255.0 green:(float)g/255.0 blue:(float)b/255.0 alpha:1.0]

#define UIColorFromRGBHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

typedef void(^ClickEventBlock)(NSString *title  );

@interface TalkfunMultifunctionTool : NSObject
+ (UIColor *)colorWithHexString: (NSString *)color alpha:(CGFloat)alpha;

+(NSString*)getLiveDuration:(id)obj;

/**选项的名字 */
@property (nonatomic, strong) ClickEventBlock clickEventBlock;

//选择 选择结果
- (void)presentViewController:(UIViewController*)ViewController content:(NSString*)content   actionWithTitle:(NSString*)title;

//简单提示
- (void)presentViewController:(UIViewController*)ViewController content:(NSString*)content  ;
//申请摄像头与麦克风的权限
+(void)applyCamera:(void (^)(BOOL granted))callback;

//学员权限变更提示
- (void)addto:(UIView*)view toast:(NSString *)string position:(CGPoint)position  ;


- (void)immediate:(UIView*)view toast:(NSString *)string position:(CGPoint)position;

//断网提醒
+ (UIView *)networkUnusualView:(NSString*)content  frame:(CGRect)Frame;


//判断聊天权限
+ (NSInteger)getChatEnable:(id)obj;


//停止定时器
- (void)stopTime;

+ (NSString*)dictionaryToJson:(NSDictionary *)dict;
@end
