//
//  HSMemberHomeViewController.m
//  LiveForest
//
//  Created by 余超 on 16/8/11.
//  Copyright © 2016年 LiveForest. All rights reserved.
//

#import "HSMemberHomeViewController.h"
#import "ChatViewController.h"
#import "RedPacketChatViewController.h"
#import "ChatDemoHelper.h"
#import "AppDelegate.h"

#import "HSCoach.h"
#import "HSUserModel.h"

#import "UserProfileManager.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+HSSetImage.h"

#import <BmobSDK/Bmob.h>

#import "ConversationListController.h"

#import "BBBadgeBarButtonItem.h"
#import "MJRefresh.h"
#import "JSBadgeView.h"
#import "YCBadgeView.h"

#import "HSLoginLogic.h"

@interface HSMemberHomeViewController ()<UITableViewDelegate, UITableViewDataSource, ChatViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (nonatomic, strong) NSMutableArray<__kindof HSCoach *> *array;
//@property (nonatomic, strong) NSMutableArray<__kindof EaseUserModel *> *dataArray;
@property (nonatomic, strong) NSMutableArray<__kindof EaseUserModel *> *coachsEUM;

@property (nonatomic, strong) NSMutableArray *coachIDs;
//@property (nonatomic, strong) NSArray *coachAvatars;
//@property (nonatomic, strong) NSArray *coachNickNames;
@property (nonatomic, strong) BBBadgeBarButtonItem *rightBarButtonItem;

@property (nonatomic, strong) NSMutableArray<__kindof HSCoach *> *coachs;

@end

@implementation HSMemberHomeViewController

#pragma mark - Data Source

- (void)getCoachsSuccess:(void (^)(NSArray *array))success failure:(void (^)(NSError *error))failure {
        BmobQuery *bq = [[BmobQuery alloc]initWithClassName:@"Coach"];
        [bq findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            if (error) {
                if (failure) {
                    failure(error);
                }
                HSLog(@"%s,%@",__func__, error.localizedDescription);
            } else {
                if (success) {
                    success(array);
                }
            }
        }];
}

//- (void)getCoachs:(void (^)())block {
//    self.coachs = @[].mutableCopy;
//    self.coachIDs = @[].mutableCopy;
//    
//    BmobQuery *bq = [[BmobQuery alloc]initWithClassName:@"Coach"];
//    [bq findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
//        if (error) {
//            HSLog(@"%s,%@",__func__, error.localizedDescription);
//        } else {
//            HSCoach *coach;
//            for (BmobObject *obj in array) {
//                coach = [HSCoach new];
//                coach.coachID = [obj objectForKey:@"coachID"];
//                coach.name = [obj objectForKey:@"nickName"];
//                coach.avatarUrlStr = [obj objectForKey:@"avatar"];
//                [self.coachs addObject:coach];
//                [self.coachIDs addObject:coach.coachID];
//            }
//            HSLog(@"教练数 = %ld, %s", self.coachs.count, __func__);
//        }
//        
//        if (block) {
//            block();
//        }
//    }];
//}

//- (void)getCoachIDs:(void (^)())block {
//    self.coachIDs = @[].mutableCopy;
//    
//    BmobQuery *bq = [[BmobQuery alloc]initWithClassName:@"Coach"];
//    [bq findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
//        if (error) {
//            HSLog(@"%s,%@",__func__, error.localizedDescription);
//        } else {
//            for (BmobObject *obj in array) {
//                NSString *coachID = [obj objectForKey:@"coachID"];
//                [self.coachIDs addObject:coachID];
//            }
//        }
//        
//        if (block) {
//            block();
//        }
//    }];
//}

#pragma mark - Actions

- (void)messageBtnClick {
    ConversationListController *vc = [[ConversationListController alloc]initWithNibName:nil bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    vc.title = @"消息列表";
    
    [ChatDemoHelper shareHelper].conversationListVC = vc;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 环信

- (void)setupHuanXin {
    AppDelegate *ad = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (ad.isNewUser) {
        [self registerHuanXin];
    } else {
        [self loginHuanXin];
    }
}

- (void)convertCoach {
    self.coachsEUM = @[].mutableCopy;
    
    for (HSCoach *coach in self.coachs) {
        EaseUserModel *model = [[EaseUserModel alloc] initWithBuddy:coach.coachID];
        if (model) {
            //            model.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
            //            model.nickname = [[UserProfileManager sharedInstance] getNickNameWithUsername:buddy];
            
            model.avatarURLPath = coach.avatarUrlStr;
            model.nickname = coach.name;
            
            //            NSString *firstLetter = [EaseChineseToPinyin pinyinFromChineseString:[[UserProfileManager sharedInstance] getNickNameWithUsername:buddy]];
            //            NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
            
            //            NSMutableArray *array = [sortedArray objectAtIndex:section];
            [self.coachsEUM addObject:model];
        }
    }
}


//- (BOOL)zhuce {
//    EMError *error = [[EMClient sharedClient] registerWithUsername:@"18362970828" password:@"6666"];
//    error = [[EMClient sharedClient] registerWithUsername:@"18362970827" password:@"6666"];
//    if (error==nil) {
//        HSLog(@"环信注册成功");
//        return YES;
//    }
//    NSLog(@"%u", error.code);
//
//    return NO;
//    
//}

//- (void)zhuceUsers {
//    NSArray *userIDs = @[@"143218500373424379",@"143218818152976768",@"143218904849046767",@"143219285182631527",@"143219306263861610",@"143219754636142425",@"143219762483207841",@"143219807435799191",@"143219816402170975",@"143219824563819481",@"143219825405243543",@"143219996717772241",@"143219999455186047",@"143222085162428619",@"143222481224591618",@"143226885187423268",@"143227287422024267",@"143228713669015862",@"143230083893647623",@"143244112479237761",@"143290367458994653",@"143300530430773192",@"143308932103211735",@"143309024663040478",@"143313660133711943",@"143315336794496784",@"143347402630791432",@"143348695661406719",@"143409079875389305",@"143410417881463073",@"143470767109063978",@"143471161608337254",@"143471587350154174",@"143472661116965310",@"143481641635848568",@"143485765171676942",@"143485866592540067",@"143485958972957685",@"143486207117079905",@"143486268663307840",@"143486349724596885",@"143488375573773091",@"143488436399127533",@"143489213825932665",@"143490225314845367",@"143493941572763477",@"143494406135825727",@"143494416985183055",@"143494430466994780",@"143495175659574634",@"143502841358429690",@"143502849525547693",@"143503169726744588",@"143503406590215613",@"143504814042158151",@"143506894920218927",@"143512610719103436",@"143512899387798242",@"143513424283419978",@"143516045471083985",@"143520122298955929",@"143522050719996799",@"143522093603674073",@"143529171331291102",@"143531052052073278",@"143531630831427513",@"143545569666672528",@"143548588828998746",@"143565021355042738",@"143565069460276990",@"143576612425225167",@"143576626279730219",@"143576629915357158",@"143576689408615489",@"143577016643922438",@"143579726664421402",@"143581210402115219",@"143599725442753494",@"143615663876911721",@"143617904448434836",@"143623816033176042",@"143627258349762434",@"143628973214693614",@"143633231789489031",@"143634464589371215",@"143649524741959417",@"143677540679753246",@"143693880710419516",@"143945674969611292",@"143955087787918239",@"143961774533034421",@"143971058340498320",@"143972095546285622",@"143973400615157447",@"143973403784490615",@"143973405114971964",@"143973417012558561",@"143973468704272802",@"143978211464650818",@"143978225921637422",@"143978779745662512",@"143979273705890341",@"143980251718174115",@"143980300562453152",@"143981557119821467",@"143986345377449871",@"143992091387618511",@"143992259582977098",@"143994180123199638",@"143994307391385736",@"143994652679012114",@"144040523555385571",@"144057212947398955",@"144069332529113359",@"144072620808737563",@"144077991144985758",@"144093685485541229",@"144159010265644401",@"144163314871795266",@"144163319817881974",@"144163356347189638",@"144163446363245658",@"144179124048756698",@"144220996846731488",@"144222730548973976",@"144222810481477129",@"144222816224934129",@"144222875767869852",@"144222876565346900",@"144222921560251041",@"144223059652038382",@"144223063732747586",@"144223083310041522",@"144223112108361208",@"144223181328836803",@"144223784500778272",@"144223956051596647",@"144224073123227137",@"144224731238855296",@"144227568529214314",@"144228368705150572",@"144228975006915620",@"144229813136684517",@"144230322863543652",@"144230811151629989",@"144231274591322886",@"144233729009993876",@"144238792166811655",@"144259064450607640",@"144299945656570422",@"144341831012726147",@"144345033886841712",@"144349700250433572",@"144350890964059429",@"144359034067838235",@"144359037503934830",@"144514598691592160",@"144522597972722745",@"144522625300654334",@"144524194811911357",@"144524262566343394",@"144524484374494214",@"144531241982155895",@"144531246891648738",@"144531608000187610",@"144532279751106197",@"144532389408043387",@"144532440797565752",@"144532495206405772",@"144532537693466119",@"144532644504632913",@"144532725121525482",@"144532890927196732",@"144532897763075728",@"144532914212073116",@"144532941358711664",@"144532957507821519",@"144532973921274648",@"144532982319187539",@"144532997426679978",@"144533005491232937",@"144533026707852665",@"144533036002745232",@"144533044721624955",@"144533057409402838",@"144534410469661386",@"144540053069463416",@"144540607117943387",@"144540616044097659",@"144540629706076222",@"144540655109148873",@"144540680956198406",@"144540693408655364",@"144540714786017279",@"144540792914447223",@"144540830302663403",@"144540881344587994",@"144540907903860476",@"144540941679717650",@"144541084362947820",@"144541723111565659",@"144542818151069831",@"144543318971669676",@"144550352873694906",@"144552665389543207",@"144570687138691958",@"144593743624936358",@"144617981964228931",@"144645275464369760",@"144673843146593931",@"144688860654117730",@"144696461439624247"];
//    
//    NSArray *nickNames = @[@"LF主页君",@"Nicole",@"奔跑者",@"帅气的小伙",@"北极光",@"夕阳无限好",@"熊孩子.吴",@"樱花",@"邀月熊",@"微光",@"微光",@"西巴",@"罗鸿",@"子意捏捏捏",@"Eric-癫少",@"赛文",@"M-wpm-M ",@"布暮司瑞",@"卓然而然",@"Sherry",@"Shmily K",@"赵牵牵牵牵手L1hSS",@"阿斯兰",@"星宇2341H",@"新新新宇新宇 ",@"白沙村_村HU民",@"爱吃桃子",@"GAMEKYUSxi",@"Mrz",@"dntil",@"吳小吳",@"微光",@"帅气的小伙",@"",@"阿斯兰",@"子意捏捏捏",@"曲小窗",@"",@"",@"",@"吳小吳",@"Shmily K",@"王下邀月熊",@"",@"偏执带气候",@"mrzhu",@"梧桐",@"抵达之谜",@"卡卡",@"韩美美",@"",@"熊孩子.吴",@"Jaspr是差不多先生",@"卓然而然",@"Leo",@"",@"oDMCo",@"罗鸿",@"剑神下凡",@"爱萝莉真是太好了",@"近彼岸l",@"载满回忆方法",@"",@"",@"nicole",@"长高这件小事",@"新兰and快青",@"「不知不觉」",@"",@"vivi",@"",@"咸鱼遇到不粘锅",@"SONIA",@"邱邱",@"和士茗",@"",@"乔利",@"",@"无笑容",@"刘冬冬LEO",@"王飞",@"桃子",@"wenwen",@"小苹果",@"咸鱼遇到不粘锅",@"❤Lily~",@"徐滔_forgame",@"wangfei",@"",@"爱吃桃子",@"吳小吳",@"阿斯兰",@"微光",@"舒婷欧巴",@"Surprise",@"爱吃桃子",@"喂喂",@"〔J.A.S.P.R〕",@"丁文江",@"",@"",@"熊孩子.吴",@"子意捏捏捏",@"乔利",@"子意捏捏捏",@"和士茗",@"喂喂",@"佩恩長門",@"丁文江",@"Shmily K",@"〔J.A.S.P.R〕",@"dntil",@"秦明明",@"熊孩子.吴",@"卓然而然",@"桃子",@"贝尔月",@"羊咩咩",@"",@"mrzhu",@"西巴",@"邱邱",@"【哥，我们回家】",@"Di Wu",@"实在想不到叫什么",@"微光93167",@"",@"Way-0228",@"Dirk",@"Dirk",@"没人性",@"我想吐个槽啊",@"Damoooon",@"Lumia_Saki",@"",@"Thomas",@"Cimen",@"moon",@"王飞",@"胡洋洋",@"苏肉",@"冲天钢炮",@"fourth",@"小镇电话",@"",@"cräsh",@"",@"见多识广老村长",@"书怡",@"",@"",@"ushio",@"耀眼的星星菇凉",@"Zohan",@"kujou",@"牧野流星2",@"牧野流星_3",@"九条",@"woku9597",@"lujin1326",@"dggbbaw",@"daibei8428",@"caoxingze",@"猫戴红花很长情",@"小卫星",@"✨小阳阳。 ",@"coco3207",@"hidedevil",@"贞固",@"snakelay",@"biblezms",@"hyxlinke",@"Nick Wu",@"口语要上26！",@"格那个瑞斯",@"jianqun1314520",@"3095026",@"kahn520",@"william3230",@"fire0304",@"caihui0801",@"scar0332",@"CROSS_Z",@"chenweil",@"beyond1596",@"77353233",@"BENNODA",@"jinx",@"ducksun5555",@"qwe4330",@"cjwxiaoxin",@"最后的个性",@"alexzw003513",@"chhchh1234",@"q67471884",@"fgswm789",@"jackuqwb",@"hkjhkj87",@"67675768",@"qiyexey",@"tyhju",@"",@"李兆颖",@"",@"",@"俞健",@"木西西君",@"",@"张章",@"小学生克星小明",@"秦力",@"郭棋林",@"国际米饭"];
//    
//    EMError *error;
//    int i = 0;
//    for (NSString *userID in userIDs) {
//        error = [[EMClient sharedClient] registerWithUsername:userID password:@"6666"];
//        i++;
//        if (error==nil) {
//            HSLog(@"环信注册成功");
//        } else {
//            HSLog(@"环信注册失败, %@, %@", userID, error.errorDescription);
//        }
//    }
//
//    
//    
////    @"/Users/YuChao/LiveForest-iOS-V2/LiveForest/id和昵称原版副本.txt"
////    NSString *path = [[NSBundle mainBundle] pathForResource:@"id和昵称原版副本" ofType:@"txt"];
////    NSError *error2;
////    NSMutableArray *aas = @[].mutableCopy;
////    NSArray *a = [NSArray arrayWithContentsOfFile:path];
////    NSString *s = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error2];
////    a = [s componentsSeparatedByString:@"\n"];
////    for (NSString *line in a) {
////        NSArray *aa = [line componentsSeparatedByString:@","];
////        [aas addObject:aa];
////    }
//    
//    
//    
//    
////    Path: /{org_name}/{app_name}/users
////    HTTP Method: POST
////    URL Params: 无
////    Request Headers: {“Content-Type”:”application/json”,”Authorization”:”Bearer ${token}”}
////    Request Body: [{“username”:”${用户名1}”,”password”:”${密码}”},…,{“username”:”${用户名2}”,”password”:”${密码}”}]
////    Response Body: 详情参见示例返回值，返回的 JSON 数据中会包含除上述属性之外的一些其他信息，均可以忽略。
////    可能的错误码：400（用户已存在、用户名或密码为空、用户名不合法[见用户名规则]）、401（未授权[无token、token错误、token过期]）、5xx。详见：服务器端 REST API 常见错误码
//    
////    curl 示例：
////    
////    curl -X POST -H "Authorization: Bearer YWMtP_8IisA-EeK-a5cNq4Jt3QAAAT7fI10IbPuKdRxUTjA9CNiZMnQIgk0LEUE" -i  "https://a1.easemob.com/easemob-demo/chatdemoui/users" -d '[{"username":"u1", "password":"p1"}, {"username":"u2", "password":"p2"}]'
//    
//    //    529258668 # liveforest
//
////    NSURL *url = [NSURL URLWithString:@"https://a1.easemob.com/529258668/liveforest/users"];
////    
////    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
////    request.HTTPMethod = @"POST";
////    
////    NSDictionary *dic1 = @{@"username":@"张飞", @"password":@"666", @"nickname":@"张翼德"};
////    NSDictionary *dic2 = @{@"username":@"刘备", @"password":@"666", @"nickname":@"刘玄德"};
////    NSArray *array = @[dic1, dic2];
////    NSData *data = [array mj_JSONData];
////    request.HTTPBody = data;
////    
////    [request addValue:@"Bearer " forHTTPHeaderField:@"Authorization"];
////    
////    NSURLSession *session = [NSURLSession sharedSession];
////    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
////        HSLog(@"%@", error.description);
////    }];
////    [task resume];
//    
//}

//- (void)zhuceSingleUser {
////    Path: /{org_name}/{app_name}/users
////    HTTP Method: POST
////    URL Params: 无
////    Request Headers: {“Content-Type”:”application/json”}
////    Request Body: {“username”:”${用户名}”,”password”:”${密码}”, “nickname”:”${昵称值}”}
////    注：创建用户时，username 和 password 是必须的，nickname 是可选的，这个 nickname 用于 iOS 推送。如果要在创建用户时设置 nickname，请求 body 是：{“username”:”jliu”,”password”:”123456”, “nickname”:”建国”} 这种形式，下面的示例不包含 nickname
//    
////    curl -X POST -i "https://a1.easemob.com/easemob-demo/chatdemoui/users" -d '{"username":"jliu","password":"123456"}'
//    
//    NSURL *url = [NSURL URLWithString:@"https://a1.easemob.com/529258668/liveforest/users"];
//    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
//    request.HTTPMethod = @"POST";
//    
//    NSDictionary *dic = @{@"username":@"张飞", @"password":@"666", @"nickname":@"张翼德"};
//    NSData *data = [dic mj_JSONData];
//    request.HTTPBody = data;
//    
////    [request addValue:@"Bearer " forHTTPHeaderField:@"Authorization"];
//    
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        HSLog(@"%@", error.description);
//        
////        NSDictionary *dic = [data dic]
//        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//        HSLog(@"%@", jsonDict);
//
//    }];
//    [task resume];
//
//}

- (void)modifyName {
    [[UserProfileManager sharedInstance] updateUserProfileInBackground:@{kPARSE_HXUSER_NICKNAME:@"啦啦啦啦啦"} completion:^(BOOL success, NSError *error){
        
    }];

}

/// 用户是否已经登录环信
- (BOOL)isHuanXinLogin {
    if ([[EMClient sharedClient] isLoggedIn]) {
        return YES;
    }
    return NO;
}

- (void)registerHuanXin {
    [self registerHuanXinWithName:[HSUserModel currentUser].user_id password:@"6666"];
}

- (void)registerHuanXinWithName:(NSString *)name password:(NSString *)password {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = [[EMClient sharedClient] registerWithUsername:name password:password];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                HSLog(@"环信注册成功");
                [self loginHuanXin];
            }else{
                switch (error.code) {
                    case EMErrorServerNotReachable:
                        TTAlertNoTitle(NSLocalizedString(@"error.connectServerFail", @"Connect to the server failed!"));
                        break;
                    case EMErrorUserAlreadyExist:
                        TTAlertNoTitle(NSLocalizedString(@"register.repeat", @"You registered user already exists!"));
                        break;
                    case EMErrorNetworkUnavailable:
                        TTAlertNoTitle(NSLocalizedString(@"error.connectNetworkFail", @"No network connection!"));
                        break;
                    case EMErrorServerTimeout:
                        TTAlertNoTitle(NSLocalizedString(@"error.connectServerTimeout", @"Connect to the server timed out!"));
                        break;
                    default:
                        TTAlertNoTitle(NSLocalizedString(@"register.fail", @"Registration failed"));
                        break;
                }
            }
        });
    });
}

//- (void)handleHSRegisterSuccessNotification {
//    HSUserModel *user = [HSUserModel currentUser];
//    NSString *userID = user.user_id;
//    
//    [self registerHuanXinWithName:userID password:@"6666"];
//}

//- (void)getFriendList {
//    EMError *error = nil;
//    NSArray *userlist = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
//    
//    //按首字母分组
//    for (NSString *buddy in userlist) {
//        EaseUserModel *model = [[EaseUserModel alloc] initWithBuddy:buddy];
//        if (model) {
//            model.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
//            model.nickname = [[UserProfileManager sharedInstance] getNickNameWithUsername:buddy];
//            
////            NSString *firstLetter = [EaseChineseToPinyin pinyinFromChineseString:[[UserProfileManager sharedInstance] getNickNameWithUsername:buddy]];
////            NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
//            
////            NSMutableArray *array = [sortedArray objectAtIndex:section];
//            [self.dataArray addObject:model];
//        }
//    }
//    
//    if (!error) {
//        HSLog(@"获取环信好友列表成功 -- %@",userlist);
//    }
//    
//}




//- (void)loginHuanXin01 {
//    
//    if ([self isCoachLogin]) {
//        // 教练的环信id是18362970827
//        [self loginWithUsername:@"18362970827" password:@"6666"];
//    } else if ([[HSUserModel currentUser].user_phone isEqualToString:@"13605160303"]) {
//        [self loginWithUsername:@"0" password:@"6666"];
//    } else {
//        [self loginWithUsername:@"1" password:@"6666"];
//        return;
//        
//        // 从bmob获取一个没登录的环信账号
//        BmobQuery   *bquery = [BmobQuery queryWithClassName:@"LoginList"];
//        [bquery whereKey:@"isLogin" notEqualTo:@"1"];
//        [bquery whereKey:@"isVip" notEqualTo:@"1"];
//        
//        [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
//            BmobObject *obj = array.lastObject;
//            [obj setObject:@"1" forKey:@"isLogin"];
//            [obj updateInBackground];
//            
//            [[NSUserDefaults standardUserDefaults] setObject:[obj objectForKey:@"objectId"] forKey:@"bmobID"];
//            NSString *name = [obj objectForKey:@"name"];
//            [self loginWithUsername:name password:@"6666"];
//        }];
//    }
//}

- (void)loginHuanXin {
//    [HSUserModel currentUser].user_id
    HSUserModel *currentUser = [HSUserModel currentUser];
    NSString *name = currentUser.user_phone;
    if (!name || name.length == 0) {
        name = currentUser.user_id;
    }
    [self loginWithUsername:name password:@"6666"];
}

//点击登陆后的操作
- (void)loginWithUsername:(NSString *)username password:(NSString *)password
{
//    [self showHudInView:self.view hint:NSLocalizedString(@"login.ongoing", @"Is Login...")];
    
//    HSLog(@"%d", [EMClient sharedClient].isLoggedIn);
    HSLog(@"环信登录 username = %@, %s", username, __func__);
    
    //异步登陆账号
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = [[EMClient sharedClient] loginWithUsername:username password:password];
        dispatch_async(dispatch_get_main_queue(), ^{
//            [weakself hideHud];
            
            if (!error) {
                HSLog(@"环信登录成功");
//                [self modifyName];

//                HSLog(@"%d", [EMClient sharedClient].isLoggedIn);

//                [self getFriendList]; // yc
//                [self makeCoach]; // yc
//                [self updateBmobLoginList:YES];
                
                //设置是否自动登录
//                [[EMClient sharedClient].options setIsAutoLogin:YES];
                
                //获取数据库中数据
                [MBProgressHUD showHUDAddedTo:weakself.view animated:YES];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[EMClient sharedClient] dataMigrationTo3];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[ChatDemoHelper shareHelper] asyncGroupFromServer];
                        [[ChatDemoHelper shareHelper] asyncConversationFromDB];
                        [[ChatDemoHelper shareHelper] asyncPushOptions];
                        [MBProgressHUD hideAllHUDsForView:weakself.view animated:YES];
                        //发送自动登陆状态通知
                        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@([[EMClient sharedClient] isLoggedIn])];
                        
                        //保存最近一次登录用户名
                        [weakself saveLastLoginUsername];
                    });
                });
            } else {
                HSLog(@"环信：%@, name = %@, %s", error.errorDescription, username, __func__);

                switch (error.code)
                {
                        //                    case EMErrorNotFound:
                        //                        TTAlertNoTitle(error.errorDescription);
                        //                        break;
                    case EMErrorNetworkUnavailable:
                        TTAlertNoTitle(NSLocalizedString(@"error.connectNetworkFail", @"No network connection!"));
                        break;
                    case EMErrorServerNotReachable:
                        TTAlertNoTitle(NSLocalizedString(@"error.connectServerFail", @"Connect to the server failed!"));
                        break;
                    case EMErrorUserAuthenticationFailed:
                        TTAlertNoTitle(error.errorDescription);
                        break;
                    case EMErrorServerTimeout:
                        TTAlertNoTitle(NSLocalizedString(@"error.connectServerTimeout", @"Connect to the server timed out!"));
                        break;
                    default:
//                        TTAlertNoTitle(NSLocalizedString(@"login.fail", @"Login failure"));
//                        NSString *info = [NSString allo]init @"环信：%@ %s", error.errorDescription
                    {
                        if (error.code == EMErrorUserNotFound) {
                            [self registerHuanXin];
                        } else {
                            NSString *info = [NSString stringWithFormat: @"环信：%@", error.errorDescription];
                            TTAlertNoTitle(info);
                        }

                    }
                        break;
                }
            }
        });
    });
}

- (void)logoutHuanXin {
    [[EMClient sharedClient] logout:NO];
}

- (void)saveLastLoginUsername
{
    NSString *username = [[EMClient sharedClient] currentUsername];
    if (username && username.length > 0) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:username forKey:[NSString stringWithFormat:@"em_lastLogin_username"]];
        [ud synchronize];
    }
}

- (NSString*)lastLoginUsername
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *username = [ud objectForKey:[NSString stringWithFormat:@"em_lastLogin_username"]];
    if (username && username.length > 0) {
        return username;
    }
    return nil;
}

// 统计未读消息数
-(void)setupUnreadMessageCount
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    
    self.tabBarItem.badgeValue = unreadCount > 0? [NSString stringWithFormat:@"%i",(int)unreadCount]: nil;
    
    self.rightBarButtonItem.badgeValue = self.tabBarItem.badgeValue;
    
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadCount];
    
    [self setupUnreadMessageBageForCell:conversations];
}

- (void)setupUnreadMessageBageForCell:(NSArray *)conversations {
    NSMutableArray *models = @[].mutableCopy;
    
    //    参考 EaseConversationCell.h

    for (EMConversation *converstion in conversations) {
        EaseConversationModel *model = nil;
//        if (self.dataSource && [self.dataSource respondsToSelector:@selector(conversationListViewController:modelForConversation:)]) {
//            model = [self.dataSource conversationListViewController:self
//                                               modelForConversation:converstion];
//        }
//        else{
            model = [[EaseConversationModel alloc] initWithConversation:converstion];
//        }
        
        if (model) {
            [models addObject:model];
        }
    }
    
//    @property (strong, nonatomic, readonly) EMMessage *message;

//    id<IMessageModel> model = nil;
//    model = [[EaseMessageModel alloc] initWithMessage:message];
//    model.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
    
    //    HSLog(@"from = %@", message.from);
    //    HSLog(@"to = %@", message.to);
    
    // 修改环信聊天界面的头像和昵称

//    int i = 0;
    for (EaseConversationModel *_model in models) {
        NSString *userID = _model.conversation.latestMessage.from;
        NSUInteger index = [self.coachIDs indexOfObject:userID];
        
        NSIndexPath *ip = [NSIndexPath indexPathForRow:index inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:ip];
        
        if (_model.conversation.unreadMessagesCount == 0) {
            cell.accessoryView = nil;
        }
        else{
            NSString *badgeValue = [NSString stringWithFormat:@"%d", _model.conversation.unreadMessagesCount];
            YCBadgeView *badgeView = [YCBadgeView badgeViewWithValue:badgeValue];
            cell.accessoryView = badgeView;
        }
        
//        i ++;
    }
}

#pragma mark - Helper

- (void)setUpMJRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(prepareCoach)];
    [self.tableView.mj_header beginRefreshing];
}

- (void)removeMJRefresh {
    [self.tableView.mj_header endRefreshing];
    self.tableView.mj_header = nil;
}

- (void)prepareCoach {
    __weak HSMemberHomeViewController *weakSelf = self;
    
    [self getCoachsSuccess:^(NSArray *array) {
        self.coachs = @[].mutableCopy;
        self.coachIDs = @[].mutableCopy;

        HSCoach *coach;
        for (BmobObject *obj in array) {
            coach = [HSCoach new];
            coach.coachID = [obj objectForKey:@"coachID"];
            coach.name = [obj objectForKey:@"nickName"];
            coach.avatarUrlStr = [obj objectForKey:@"avatar"];
            [self.coachs addObject:coach];
            [self.coachIDs addObject:coach.coachID];
        }
        
        [weakSelf convertCoach]; // yc

        [weakSelf removeMJRefresh];
        [weakSelf.tableView reloadData];
        [weakSelf setupUnreadMessageCount];

        if ([weakSelf isCoachLogin]) {
            [weakSelf setupNavigationBarItem];
        } else {
            weakSelf.navigationItem.rightBarButtonItem = nil;
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
//        [self.tableView.mj_header beginRefreshing];
    }];

//    [self getCoachs:^{
//        [weakSelf removeMJRefresh];
//        
//        if ([weakSelf isCoachLogin]) {
//            [weakSelf setupNavigationBarItem];
//        } else {
//            weakSelf.navigationItem.rightBarButtonItem = nil;
//        }
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [weakSelf convertCoach]; // yc
//            [weakSelf.tableView reloadData];
//            [weakSelf setupUnreadMessageCount];
//        });
//    }];
}

- (BOOL)isCoachLogin {
//    return [self.coachIDs containsObject:[HSUserModel currentUser].user_phone];
    
    NSString *phone = [HSUserModel currentUser].user_phone;
    
    for (HSCoach *coach in self.coachs) {
        if ([coach.coachID isEqualToString:phone]) {
            return YES;
        }
    }
    return NO;
    
    //    if ([UIScreen mainScreen].bounds.size.width > 375) {
    //        return YES;
    //    } else {
    //        return NO;
    //    }
}

- (void)setupNavigationBarItem {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btn addTarget:self action:@selector(messageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"消息" forState:UIControlStateNormal];
    
    BBBadgeBarButtonItem *item = [[BBBadgeBarButtonItem alloc]initWithCustomUIButton: btn];
    //    item.badgeValue = @"6";
    item.badgeOriginX = CGRectGetMaxX(btn.frame) * 0.9;
    item.badgeOriginY = 0;
    
    self.navigationItem.rightBarButtonItem = item;
    self.rightBarButtonItem = item;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)addNotification {
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleHSRegisterSuccessNotification) name:@"HSRegisterSuccess" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUnreadMessageCount) name:@"setupUnreadMessageCount" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutHuanXin) name:kLogoutNotification object:nil];
    
}

- (void)removeNotification {
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"HSRegisterSuccess" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"setupUnreadMessageCount" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLogoutNotification object:nil];
}

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addNotification];
    
//    [self prepareCoach];
    [self setUpMJRefresh];
    
    //    [self zhuceUsers];
    
    //    [self modifyName];
    
    //    [self setupNavigationBarItem];
    
    
    //    [self addNotification];
    //    [self loginHuanXin];
    //    [self loginWithUsername:@"18362970828" password:@"6666"];
    
//    [self setupHuanXin];
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [self setupHuanXin];
    //    });
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [UIView new];
    
    //    self.title = @"教练";
    self.navigationItem.title = @"教练";
    
}

+ (instancetype)viewController {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Member" bundle:nil];
    HSMemberHomeViewController *vc = [sb instantiateViewControllerWithIdentifier:@"HSMemberHomeViewController"];
    return vc;
}

- (void)dealloc {
    [self removeNotification];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self isHuanXinLogin] == NO) {
        [self setupHuanXin];
    }
    
    [self setupUnreadMessageCount];
}


//- (void)handleUIApplicationWillResignActiveNotification {
//    [self logoutHuanXin];
//    [self updateBmobLoginList:NO];
//}
//
//- (void)handleUIApplicationWillEnterForegroundNotification {
//    [self loginHuanXin];
////    [self updateBmobLoginList:YES];
//}
//
//- (void)updateBmobLoginList: (BOOL)isLogin {
//    //
////    if (![self isLoginHuanXin]) {
////        return;
////    }
//    
//    NSString *value = isLogin? @"1":@"0";
//    
//    NSString *bmobID =  [[NSUserDefaults standardUserDefaults] objectForKey:@"bmobID"];
//    
//    BmobObject *obj1 = [BmobObject objectWithoutDataWithClassName:@"LoginList" objectId:bmobID];
//    [obj1 setObject:value forKey:@"isLogin"];
//    //异步更新数据
//    //    [obj1 updateInBackground];
//    [obj1 updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
//        
//    }];
//}
//
//- (BOOL)isLoginHuanXin {
//    if ([EMClient sharedClient].isLoggedIn) {
//        return YES;
//    }
//    return NO;
//}
//- (void)addNotification {
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleUIApplicationWillResignActiveNotification) name:UIApplicationWillResignActiveNotification object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleUIApplicationWillEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
//}
//
//- (void)removeNotification {
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
//}

#pragma mark - ChatViewControllerDelegate

- (NSString *)nickNameForUserID:(NSString *)userID {
    HSUserModel *currentUser = [HSUserModel currentUser];
    
    if ([currentUser.user_id isEqualToString:userID]) {
        return currentUser.user_nickname;
    }
    
    for (HSCoach *coach in self.coachs) {
        if ([coach.coachID isEqualToString:userID]) {
            return coach.name;
        }
    }
    
    return @"";
}

- (NSString *)avatarURLForUserID:(NSString *)userID {
//    HSLog(@"avatarURLForUserID, %s", __func__);
    
    HSUserModel *currentUser = [HSUserModel currentUser];
    
    if ([currentUser.user_id isEqualToString:userID]) {
        return currentUser.user_logo_img_path;
    }
    
    for (HSCoach *coach in self.coachs) {
        if ([coach.coachID isEqualToString:userID]) {
            return coach.avatarUrlStr;
        }
    }
    
    return @"";

}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.array.count;
    return self.coachs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    UIImageView *iv = [cell viewWithTag:1];
    [iv hs_setAvatarWithURLStr:self.coachs[indexPath.row].avatarUrlStr];
    UILabel *label = [cell viewWithTag:2];
    label.text = self.coachs[indexPath.row].name;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EaseUserModel *model = [self.coachsEUM objectAtIndex:indexPath.row];
    NSString *loginUsername = [[EMClient sharedClient] currentUsername];
    if (loginUsername && loginUsername.length > 0) {
        if ([loginUsername isEqualToString:model.buddy]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"friend.notChatSelf", @"can't talk to yourself") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
            [alertView show];
            
            return;
        }
    }
#ifdef REDPACKET_AVALABLE
    RedPacketChatViewController *chatController = [[RedPacketChatViewController alloc]
#else
   ChatViewController *chatController = [[ChatViewController alloc]
#endif
             initWithConversationChatter:model.buddy conversationType:EMConversationTypeChat];
   chatController.title = model.nickname.length > 0 ? model.nickname : model.buddy;
   chatController.hidesBottomBarWhenPushed = YES;
   chatController.ycDelegate = self;
//   chatController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
   [self.navigationController pushViewController:chatController animated:YES];

}

                                                   
                                                   

@end
