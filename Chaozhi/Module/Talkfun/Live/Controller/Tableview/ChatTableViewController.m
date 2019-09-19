#import "ChatTableViewController.h"
#import "ChatModel.h"
#import "MJExtension.h"
#import "TalkfunNewChatCell.h"

@interface ChatTableViewController ()

@end

@implementation ChatTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(broadcastInfo:) name:@"broadcastInfo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chat:) name:@"chat" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(flower:) name:@"flower" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearAll:) name:@"clearAll" object:nil];
}

- (void)clearAll:(NSNotification *)notification{
    [self.dataSource removeAllObjects];
    [self.tableView reloadData];
}

//送花接口被调用
- (void)flower:(NSNotification *)notification
{
    NSDictionary * params = notification.userInfo;
    [self.dataSource addObject:params[@"mess"]];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"chatMessageCome" object:nil];

    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

//抽奖 投票 踢人 广播 禁言
- (void)broadcastInfo:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"chatMessageCome" object:nil];
    NSDictionary * messageDict = notification.userInfo;
    NSString * vote_new        = messageDict[@"vote:new"];
    NSString * vote_pub        = messageDict[@"vote:pub"];
    NSString * lottery_stop    = messageDict[@"lottery:stop"];
    NSString * broadcast       = messageDict[@"broadcast"];
    NSString * chat_disable    = messageDict[@"chat:disable"];
    NSString * member_kick     = messageDict[@"member:kick"];
    
    [self.dataSource addObject:messageDict];
    
    NSString * allString = nil;
    if (vote_new) {
        allString = vote_new;
    }
    else if (vote_pub)
    {
        allString = vote_pub;
    }
    else if (lottery_stop)
    {
        allString = lottery_stop;
    }
    else if (broadcast)
    {
        allString = broadcast;
    }
    else if (chat_disable)
    {
        allString = chat_disable;
    }
    else if (member_kick)
    {
        allString = member_kick;
    }
    

    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (NSString *)getStringWithModel:(ChatModel *)model{
    
    NSString * vote_new     = model.vote_new;
    NSString * vote_pub     = model.vote_pub;
    NSString * lottery_stop = model.lottery_stop;
    NSString * broadcast    = model.broadcast;
    NSString * chat_disable = model.chat_disable;
    NSString * member_kick  = model.member_kick;
    
    NSString * allString = nil;
    if (vote_new) {
        allString = vote_new;
        allString = [allString stringByAppendingString:@"投票"];
    }
    else if (vote_pub)
    {
        allString = vote_pub;
        if (![model.isShow isEqualToString:@"0"]) {
            allString = [allString stringByAppendingString:@"查看结果"];
        }
    }
    else if (lottery_stop)
    {
        allString = lottery_stop;
    }
    else if (broadcast)
    {
        allString = broadcast;
    }
    else if (chat_disable)
    {
        allString = chat_disable;
    }
    else if (member_kick)
    {
        allString = member_kick;
    }else{
        if (model.amount) {
            NSInteger amount = [model.amount integerValue];
            
            NSMutableString * msg = [NSMutableString new];
            [msg appendString:@"送给老师："];
            for (int i = 0; i < amount; i ++) {
                [msg appendString:@"[rose]"];
            }
            return msg;
        }else if (model.msg){
            return model.msg;
        }
    }
    return allString;
}

//==================监听ask和chat回来的数据处理======================
- (void)chat:(NSNotification *)notification
{
    NSDictionary * params = notification.userInfo;
    [self.dataSource addObject:params[@"mess"]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"chatMessageCome" object:nil];

    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)recalculateCellHeight;
{
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TalkfunNewChatCell * cell = [tableView dequeueReusableCellWithIdentifier:@"liveChatCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"TalkfunNewChatCell" owner:nil options:nil][0];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary * params = self.dataSource[indexPath.row];

    [cell configCell:params];
    cell.btnBlock = self.btnBlock;
    
//    NSLog(@"当前加载 : %ld",indexPath.row);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSDictionary * params = self.dataSource[indexPath.row];
    ChatModel *model = [ChatModel mj_objectWithKeyValues:params];
    NSString * string = [self getStringWithModel:model];
    CGFloat width = CGRectGetWidth(self.tableView.frame)-55;
    if (model.msg || model.amount) {
        width += 7;
    }
    NSDictionary * info = [TalkfunUtils assembleAttributeString:string boundingSize:CGSizeMake(width, MAXFLOAT) fontSize:13 shadow:NO];
    NSString * rectStr = info[TextRect];
    CGRect rect = CGRectFromString(rectStr);
    CGFloat height = rect.size.height+15+16+8;
    return height;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
