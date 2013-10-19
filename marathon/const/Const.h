//
//  Const.h
//  marathon
//
//  Created by Ryan on 13-10-11.
//  Copyright (c) 2013年 Ryan. All rights reserved.
//


////*******************************************
////*******************************************
////调试开关 //For test Only    Release版本一定要关闭本开关，切记切记！！！！！！！！！！！！！！      
//#define DEBUG_LEHE
//#define DEBUG_LOG
////*******************************************//
////*******************************************//

#ifdef DEBUG_LOG
#define DMLog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#else
#define DMLog(...) do { } while (0)
#endif

#define IS_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define isIOS7 (([[[UIDevice currentDevice] systemVersion] floatValue] > 6.9) ? 1 : 0)


#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define VIEW_HEIGHT SCREEN_HEIGHT - 20
#define VIEW_WIDTH_HORIZONTAL SCREEN_HEIGHT
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define VIEW_HEIGHT_HORIZONTAL SCREEN_WIDTH - 20
#define VIEW_WIDTH SCREEN_WIDTH

#define kAppID                       @""


//打开本应用的scheme
#define APPLICATION_SCHEME      @"marathon://"

//api url
#ifdef DEBUG_LEHE
    #define apiHost             @"http://192.168.1.102:8080/marathon/api_call.php?"   //For test Only
#else
    #define apiHost             @"http://www.hkebuyer.com/marathon/api_call.php?"
#endif

//本地cookies nsdictionary
#define kLocalCookieData                    @"kLocalCookieData"

#ifndef IOS_VERSION 
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue] 
#endif

#define kDocumentDir                        [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

//判断iOS版本
#define SYSTEM_VERSION_GREATER_THAN(v)      ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

#define kNetworkErrorMessage                @"网络不给力，请稍候重试"

//获取谷歌地图
#define kRequestGoogleMapPathInfo			1999
#define CONST_API_KEY_GOOGLE_MAPS @"ABQIAAAAIek-1Ui-iryUSW96I8YEgBQ8UR9XpWZhOV60ykFWMshnxN1aChS17ZAJAErAtY2bU1IZVb3aV1hdqg"

//正在获取位置
#define kDefaultLocationDesc                @"当前位置"

#pragma mark - notifaction
#define kEventMyCollectionChanged           @"kEventMyCollectionChanged"

#define kDefaultLat                         39.913968913551543
#define kDefaultLon                         116.478278804781269
#define kDefaultLatitudeDelta               0.03
#define kDefaultLongitudeDelta              0.03
#define kInvalidLocation                    1000.000

//GPS
#define kGPSInterval                        5

#define kScreenWidth                        320
#define kScreenHeight                       SCREEN_HEIGHT
#define kLeftInterval                       10

// downfile manager
#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

#define MOST_FILE_CAPACITY 300
#define FILE_CLEAN_THRESHOLD 50
#define DOWNLOAD_FOLDER [DOCUMENTS_FOLDER stringByAppendingPathComponent:@"appexpert_download"]
#define DOWNLOAD_TEMP_FOLDER [DOWNLOAD_FOLDER stringByAppendingPathComponent:@"temp"]

//photo file manager
#define PHOTO_FOLDER [DOCUMENTS_FOLDER stringByAppendingPathComponent:@"photo"]

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]


#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#pragma mark - 获取全局基本参数
#define kCode \
[(AppDelegate *)[[UIApplication sharedApplication] delegate] code]

#define kDeviceToken \
[(AppDelegate *)[[UIApplication sharedApplication] delegate] gDeviceToken]

#define kAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#pragma mark - 全局参数宏定义
#define KRANDOM(x) (rand()%x)

#define HEI_(xx) [UIFont boldSystemFontOfSize:xx]

#define PLACEHOLDER_COLOR	RGBCOLOR(150, 150, 150)
//基础页面的背景色值
#define BASE_PAGE_BG_COLOR      RGBACOLOR(102, 102, 102, 1.0)
//基础咖啡色字体色值
#define BASE_COFFEE_TEXT_COLOR  RGBCOLOR(120, 85, 60)
//浅咖色字体色值
#define LIGHT_GRAY_TEXT_COLOR RGBCOLOR(174, 174, 174)
//桔红色字体色值
#define BASE_ORANGE_TEXT_COLOR  RGBCOLOR(240, 100, 60)

//绿色字体色值
#define BASE_GREEN_TEXT_COLOR  RGBCOLOR(0, 153, 0)
//副标题的浅灰字体色值
#define BASE_LIGHTGREY_TEXT_COLOR  RGBCOLOR(136, 136, 136)

typedef struct
{
	double lat;
	double lon;
} GPoint;

typedef enum kStartStatus {
    kStartStatusStop = 0,
	kStartStatusStart,
	kStartStatusPause
} START_STATUS;

typedef enum kUPLOAD_TYPE {
    kUploadNormal = 0,
	kUploadTypeBlock,
	kUploadTypePhoto,
	kUploadTypeRecord
} UPLOAD_TYPE;

#pragma mark - Notification
#define kLoginSuccessNotification               @"LoginSuccessNotification"

#pragma mark - PersistenceHelper
#define INVITECODE                              @"invite_code"


#pragma mark - 拼接网络请求串
#define kLoginURL(xx_code,xx_token) \
[NSString stringWithFormat:@"%@&m=login&code=%@&token=%@",apiHost,xx_code,xx_token]

#define kUpLoadLocation(xx_lat,xx_lon) \
[NSString stringWithFormat:@"%@&m=upload_location&code=%@&lat=%f&lon=%f",apiHost,kCode,xx_lat,xx_lon]

#define kGetLocation \
[NSString stringWithFormat:@"%@&m=getlocation",apiHost]

//基础URL
#define kBaseURL \
[NSString stringWithFormat:@"%@uuid=%@&via=%@&cver=%@&version=%@&app=%@&pid=%@&sdk=%@&token=%@",apiHost,kUDID,kVia,kClientVersion,kServerVersion,kApp,kPid,kBuildForSDK,kToken]


//获取 论坛列表/帖子详情
#define GetForumTable(xx_appid,xx_pkg_name,xx_pkg_version,xx_qtype,xx_hid,xx_page,xx_pagesize) \
[NSString stringWithFormat:@"%@&m=forum&act=0&appid=%@&pkg=%@&vername=%@&qtype=%@&hid=%@&p=%d&pagesize=%d", kBaseURL,xx_appid,xx_pkg_name,xx_pkg_version,xx_qtype,xx_hid,xx_page,xx_pagesize]

//获取XMPP配置
#define GetXmppConfig  [NSString stringWithFormat:@"%@&m=xmpp_config", kBaseURL]

//获取XMPP 游戏Room 信息
#define GetXmppGameRoomInfo(xx_appid,xx_pkg_name,xx_pkg_version,xx_online) \
[NSString stringWithFormat:@"%@&m=chat&chattype=1&appid=%@&pkg=%@&vername=%@&online=%@", kBaseURL,xx_appid,xx_pkg_name,xx_pkg_version,xx_online]

//获取XMPP 游戏群Room 信息
#define GetXmppGroupRoomInfo(xx_gid,xx_online) \
[NSString stringWithFormat:@"%@&m=chat&chattype=2&online=%@&gid=%@", kBaseURL,xx_online,xx_gid]

//修改XMPP Room 昵称
#define ChangeXmppRoomNickName(xx_nickname) \
[NSString stringWithFormat:@"%@&m=edituname&uname=%@", kBaseURL,xx_nickname]

//登录/退出聊天室
#define XmppRoomConnectStatus(xx_chattype,xx_appid,xx_pkg_name,xx_pkg_version,xx_online) \
[NSString stringWithFormat:@"%@&m=chat&chattype=%@&appid=%@&pkg=%@&vername=%@&online=%@", kBaseURL,xx_chattype,xx_appid,xx_pkg_name,xx_pkg_version,xx_online]

//获取某游戏攻略URL
#define MakeGameRaidersURL(xx_pkg_name,xx_pkg_version,xx_pkg_vercode) \
[NSString stringWithFormat:@"%@&m=strategy&pkg=%@&vername=%@&ver=%@", kBaseURL,xx_pkg_name,xx_pkg_version,xx_pkg_vercode]

//我收藏的某游戏攻略
#define MakeRaiderFavoriteURL(xx_pkg_name,xx_pkg_version,xx_pkg_vercode) \
[NSString stringWithFormat:@"%@&m=strategy_fav&pkg=%@&vername=%@&ver=%@", kBaseURL,xx_pkg_name,xx_pkg_version,xx_pkg_vercode]

//邀请好友 version 5.0
#define INVITE_FRIEND_MAKE_V5(xx_to,xx_category) \
[NSString stringWithFormat:@"%@&m=invite_friend&to=%@&category=%@", kBaseURL, xx_to,xx_category]

//shake_friends已经邀请的好友
#define APPEXPERT_INVITED_FRIENDS \
[NSString stringWithFormat:@"%@&m=shake_friends", kBaseURL]

//第三方授权信息发送
#define AppExpert_Authorize(xx_act,xx_authtype,xx_accesstoken,xx_openid,xx_expire_time,xx_share,xx_shareType,xx_appid,xx_gid) \
[NSString stringWithFormat:@"%@&m=authorize&act=%@&ptype=%@&access_token=%@&openid=%@&expire_time=%@&share=%@&share_type=%@&appid=%@&gid=%@" ,kBaseURL,xx_act,xx_authtype,xx_accesstoken,xx_openid,xx_expire_time,xx_share,xx_shareType,xx_appid,xx_gid]

//好友列表
#define Invite_FriendsList(xx_category,xx_token,xx_openid,xx_expire_time) \
[NSString stringWithFormat:@"%@&m=invite_list&category=%@&token=%@&openid=%@&expire_time=%@" ,kBaseURL,xx_category,xx_token,xx_openid,xx_expire_time]

//邀请过的人
#define kDictForInvited \
[[kAppDelegate settingResultHelper] invitedDict]

//上传本机号
#define UPLOAD_MYPHONE(xx_act,xx_phone,xx_name) \
[NSString stringWithFormat:@"%@&m=shake_user&act=%d&phone=%@&name=%@",kBaseURL,xx_act,xx_phone,xx_name]

//指定游戏的礼包
#define GIFT_PACKAGE(xx_pkg,xx_appid) \
[NSString stringWithFormat:@"%@&m=award&pkg=%@&appid=%@",kBaseURL,xx_pkg,xx_appid]

//正在玩的游戏礼包和热门礼包
#define GIFT_PLAYINGANDHOT \
[NSString stringWithFormat:@"%@&m=gifts&act=4&p=0",kBaseURL]

//游戏里的礼包
#define GIFT_INNERPACKAGE(xx_appid) \
[NSString stringWithFormat:@"%@&m=gifts&act=0&appid=%@",kBaseURL,xx_appid]

//领取礼包
#define GIFT_TAKE(xx_giftid) \
[NSString stringWithFormat:@"%@&m=gift&gift_id=%@",kBaseURL,xx_giftid]

//收藏的攻略
#define FAV_CHEATS \
[NSString stringWithFormat:@"%@&m=strategy_fav_all",kBaseURL]

//找回密码
#define PASSWORD_FIND \
[NSString stringWithFormat:@"http://wanyou.lehe.com/api2/modify_pwd.php"]

//网络连接
#define kRequestAutoLogin                   9000
#define kRequestLogin                       9001
#define kRequestUserLogout                  9002
#define kRequestGetMyInfo                   9003
#define kRequestForgetPassword              9004

#define kLoginConnectionErrorMessage		@"网络问题，请稍候重试"
#define kLoginErrorMessage					@"用户名或密码错误，请重试"
#define kGetShopErrorMessage				@"手机号码或固定电话号码错误，请重试"
#define kNeedCellPhoneMessage				@"请输入手机号码"
#define kNeedLinePhoneMessage				@"请输入固定电话号码"
#define kNeedPictureMessage                 @"确保至少一张照片上传成功"
#define kNeedAuthCodeMessage				@"请输入验证码"
#define kEndBeforeStartErrorMessage         @"有效期设置错误"
#define kTokenInvalidErrorMessage           @"登录信息已失效，请重新登录"
#define kTokenInvalidMessage                @"登录信息已失效，请注销后重新登录"

//定义通知
#define PRESENT_MOVE_TO_RIGHT               @"present_move_to_right"
#define PRESENT_BACK_FROM_RIGHT             @"presen_back_from_right"

//上传device token
#define UPLOAD_DEVICETOKEN(xx_devicetoken) \
[NSString stringWithFormat:@"%@&m=device_token&device_token=%@", kBaseURL,xx_devicetoken]

//邮箱登录接口/注册接口
#define Login_Email(xx_email,xx_password) \
[NSString stringWithFormat:@"%@&m=login&email=%@&password=%@" ,kBaseURL,xx_email,xx_password]

//第三方登录接口
#define Login_Third(xx_ptype,xx_accesstoken,xx_openid,xx_expire_time) \
[NSString stringWithFormat:@"%@&m=login_3rd&ptype=%@&access_token=%@&openid=%@&expire_time=%@" ,kBaseURL,xx_ptype,xx_accesstoken,xx_openid,xx_expire_time]

//自动登陆
#define Auto_Login \
[NSString stringWithFormat:@"%@&m=login&auto=1",kBaseURL]

//搜索游戏
#define SEARCH_GAME(xx_pageNum,xx_name) \
[NSString stringWithFormat:@"%@&m=game_search&p=%d&kw=%@",kBaseURL,xx_pageNum,xx_name]

//搜索页面推荐游戏
#define RECOMMEND_GAMES \
[NSString stringWithFormat:@"%@&m=game_search_kw",kBaseURL]

//添加我在玩的游戏
#define USER_ADD_GAME(xx_game_appid) \
[NSString stringWithFormat:@"%@&m=atten_app&act=1&appid=%@",kBaseURL,xx_game_appid]

//删除我在玩的游戏
#define USER_DELETE_GAME(xx_game_appid) \
[NSString stringWithFormat:@"%@&m=atten_app&act=2&appid=%@",kBaseURL,xx_game_appid]

//大家都在找 游戏
#define GET_HOT_GAME(xx_type,xx_page) \
[NSString stringWithFormat:@"%@&m=game_recommend&type=%@&p=%d&kw=",kBaseURL,xx_type,xx_page]

// 列出该好友可参加游戏群
#define INVITE_GROUP_LIST(xx_fid) \
[NSString stringWithFormat:@"%@&m=group_invite&opt=ls_group&fid=%@",kBaseURL,xx_fid]

// 邀请好友参加游戏群
#define INVITE_FRIEND_2_GROUP(xx_gids,xx_fid) \
[NSString stringWithFormat:@"%@&m=group_invite&opt=invite_groups&gid=%@&fid=%@",kBaseURL,xx_gids,xx_fid]

// 列出该游戏群可邀请的好友
#define INVITE_FRIENDS_LIST(xx_gid) \
[NSString stringWithFormat:@"%@&m=group_invite&opt=ls_friend&gid=%@",kBaseURL,xx_gid]

// 邀请好友参加游戏群
#define INVITE_FRIEND_2_ONE_GROUP(xx_gid,xx_fids) \
[NSString stringWithFormat:@"%@&m=group_invite&opt=invite_users&gid=%@&fid=%@",kBaseURL,xx_gid,xx_fids]

//我的游戏群列表
#define MY_GROUP_LIST \
[NSString stringWithFormat:@"%@&m=group_my",kBaseURL]

//别人的游戏群列表
#define USER_GROUP_LIST(xx_uid) \
[NSString stringWithFormat:@"%@&m=group_my&account_id=%@",kBaseURL,xx_uid]

//加入游戏群
#define JOIN_GROUP(xx_gid) \
[NSString stringWithFormat:@"%@&m=group_join&gid=%@",kBaseURL,xx_gid]

//退出游戏群
#define QUIT_GROUP(xx_gid) \
[NSString stringWithFormat:@"%@&m=group_quit&gid=%@",kBaseURL,xx_gid]

//解散游戏群
#define DEL_GROUP(xx_gid) \
[NSString stringWithFormat:@"%@&m=group_rm&gid=%@",kBaseURL,xx_gid]

//游戏群消息推送
#define GROUP_CHAT_PUSH(xx_gid,xx_push) \
[NSString stringWithFormat:@"%@&m=chat_push&push_type=2&gid=%@&push_on=%@",kBaseURL,xx_gid,xx_push]

//个人聊天消息推送
#define USER_CHAT_PUSH(xx_fid,xx_push) \
[NSString stringWithFormat:@"%@&m=chat_push&push_type=3&fid=%@&push_on=%@",kBaseURL,xx_fid,xx_push]

//搜索游戏群
#define SEARCH_GROUP(xx_pageNum,xx_name) \
[NSString stringWithFormat:@"%@&m=group_search&p=%d&kw=%@",kBaseURL,xx_pageNum,xx_name]

//指定游戏的游戏群列表
#define GAME_GROUP(xx_pageNum,xx_pkg) \
[NSString stringWithFormat:@"%@&m=group_ls&p=%d&pkg=%@",kBaseURL,xx_pageNum,xx_pkg]

//我的好友列表
#define MY_FRIENDS_LIST \
[NSString stringWithFormat:@"%@&m=friends&act=0",kBaseURL]

//添加好友
#define ADD_FRIEND_WITH_WANYOUID(xx_id) \
[NSString stringWithFormat:@"%@&m=friends&act=1&fid=%@",kBaseURL,xx_id]

//删除好友
#define DEL_FRIEND_WITH_WANYOUID(xx_id) \
[NSString stringWithFormat:@"%@&m=friends&act=2&fid=%@",kBaseURL,xx_id]

//邀请微博好友
#define ADD_WEIBO_FRIEND(xx_id) \
[NSString stringWithFormat:@"%@&m=invite&ptype=weibo&to=%@",kBaseURL,xx_id]

//新加入微博的好友
#define NEW_TO_WEIBO_FRIENDS_LIST \
[NSString stringWithFormat:@"%@&m=friends&act=6",kBaseURL]

//查看个人profile
#define USER_PROFILE(xx_fid) \
[NSString stringWithFormat:@"%@&m=profile&act=0&fid=%@",kBaseURL,xx_fid]

//查看游戏群profile
#define GROUP_PROFILE(xx_gid) \
[NSString stringWithFormat:@"%@&m=group_info&act=0&gid=%@",kBaseURL,xx_gid]

//请求加我为好友
#define REQUEST_BE_MY_FRIENDS_LIST \
[NSString stringWithFormat:@"%@&m=friends&act=4",kBaseURL]

//游戏名片信息
#define GET_GAME_CARD(xx_game_appid) \
[NSString stringWithFormat:@"%@&m=app_detail&appid=%@",kBaseURL,xx_game_appid]

//赞游戏
#define SUPPORT_GAME(xx_game_appid) \
[NSString stringWithFormat:@"%@&m=love_app&act=1&appid=%@",kBaseURL,xx_game_appid]

//游戏聊天室推送消息设置
#define PUSH_SETTING_GAME(xx_game_appid,xx_push_setting,xx_source_type) \
[NSString stringWithFormat:@"%@&m=chat_push&appid=%@&push_on=%d&push_type=%@",kBaseURL,xx_game_appid,xx_push_setting,xx_source_type]

//游戏成员
#define GET_GAME_MEMBERS(xx_game_appid,xx_page,xx_pagesize) \
[NSString stringWithFormat:@"%@&m=app_users&appid=%@&p=%d&pagesize=%d",kBaseURL,xx_game_appid,xx_page,xx_pagesize]

//游戏群成员
#define GET_GROUP_MEMBERS(xx_group_id,xx_page) \
[NSString stringWithFormat:@"%@&m=group_user&gid=%@&p=%d",kBaseURL,xx_group_id,xx_page]

//风云榜
#define GET_GAME_BILLBOARD(xx_game_appid,xx_page,xx_pagesize) \
[NSString stringWithFormat:@"%@&m=app_users_morror&appid=%@&p=%d&pagesize=%d",kBaseURL,xx_game_appid,xx_page,xx_pagesize]

//推送消息用户响应回调
#define PUSH_MSG_REMIND(xx_push_msg_type) \
[NSString stringWithFormat:@"%@&m=remind&type=%@",kBaseURL,xx_push_msg_type]

//用户退出
#define Logout_Make() \
[NSString stringWithFormat:@"%@&m=logout",kBaseURL]

//动态参数
#define COMMON_TYPES_MAKE \
[NSString stringWithFormat:@"%@&m=common_types",kBaseURL]
