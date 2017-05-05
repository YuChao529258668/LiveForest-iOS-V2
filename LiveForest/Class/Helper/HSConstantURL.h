//
//  HSConstantURL.h
//  LiveForest
//
//  Created by 微光 on 15/4/21.
//  Copyright (c) 2015年 HOTeam. All rights reserved.
//

#ifndef LiveForest_HSConstantURL_h
#define LiveForest_HSConstantURL_h

//所有请求前缀
//#define requestPrefixURL  "http://121.41.104.156:10086" //旧的，12.1之前的版本
//#define requestPrefixURL  "http://115.28.253.106:10085" //开发时候用测试
//#define requestPrefixURL  "http://115.28.253.106:10086"   //线上请求测试前缀
//#define requestPrefixURL "http://114.215.103.95:10086" // 注意，HSHttpRequestTool.m文件里还有一个urlPrefix要修改
//#define requestPrefixURL "http://139.224.41.10:10086" // 注意，HSHttpRequestTool.m文件里还有一个urlPrefix要修改
#define requestPrefixURL "http://10.25.28.106:10086" // 注意，HSHttpRequestTool.m文件里还有一个urlPrefix要修改
//static NSString *urlPrefix = @"10.25.28.106:10086";   // 注意，HSConstantURL.h文件里还有一个要修改

//请求七牛前缀
//#define requestQiNiuPrefixURL  ""  //请求七牛前缀

#define QiNiuImageUrl "http://7sbpfh.com1.z0.glb.clouddn.com/@"
#define QiNiuImageYaSuo "?imageView2/1/w/200/h/200"
#define QiNiuImageYaSuoTransition "?imageView2/1/w/200/h/200/format/jpg/interlace/1"
#define QiNiuImageBlur "?imageMogr2/blur/50x5"

//注册相关
#define  doPhoneVerifyURL  "/User/Register/doPhoneVerify"   //手机号校验
#define  doVerificationCodeSendURL "/User/Register/doVerificationCodeSend" //发送验证码
#define  doVerificationCodeCheckURL "/User/Register/doVerificationCodeCheck" //校验验证码
#define  doRegisterURL  "/User/Register/doRegister" //注册信息

//分享相关
//创建分享
#define  getQiniuUpToken "/Infra/Storage/Qiniu/getQiniuUpToken"   //七牛url
#define  doShareCreate  "/Social/Share/doShareCreateWithAt"//
#define  getMPShareListURL  "/Social/Share/getMPShareList" //获取官方分享列表
#define  doShareLikeURL  "/Social/Share/doShareLike"  //点赞
#define  getUserShareLikeStateURL  "/Social/Share/getUserShareLikeState"  //获取用户对分享点赞的状态
//#define  getFollowingShareListURL   "/Social/Share/getFollowingShareList"  //获取推荐分享列表
#define  getRecommendShareListURL   "/Social/Share/getRecommendShareList"   //获取推荐分享列表
#define  getShareListURL   "/Social/Share/getShareList"  //获取个人分享列表
#define  doShareCommentURL   "/Social/Share/doShareComment"  //分享评论
#define  getShareCommentURL  "/Social/Share/getShareComment"  //获取评论信息
#define  doShareDeleteURL "/Social/Share/doShareDelete" //删除分享
#define  getShareInfoURL "/Social/Share/getShareInfo" //获取分享详情

#pragma mark 活动相关
//创建活动
#define  doActivityCreateByUserURL  "/Social/Activity/doActivityCreateByUser"  
#define  getMPActivityListURL  "/Social/Activity/getMPActivityList" //获取官方活动列表
#define  getMixActivityListURL   "/Social/Activity/getMixActivityList"  //获取推荐活动列表
#define  doActivityAttendURL   "/Social/Activity/doActivityAttend"  //参加活动
#define  doActivityAttendCancelURL   "/Social/Activity/doActivityAttendCancel"  //活动取消
#define  getDisplayPicActivityListURL   "/Social/Activity/getDisplayPicActivityList" //获取官方晒图活动列表
#define  getDisplayPicActivityInfoURL   "/Social/Activity/getDisplayPicActivityInfo" //返回官方主题晒图活动详情
/*
 群组相关
 */
//获取请求群组
#define getGroupListURL  "/Social/Group/getGroupList"


//个人信息请求
#define  getPersonInfoURL  "/User/Person/getPersonInfo"
//头像修改请求地址
#define  updatePersonLogoURL  "/User/Person/updatePersonLogo"
//用户城市更新请求地址
#define  updatePersonCityURL  "/User/Person/updatePersonCity"
//用户生日更新请求地址
#define  updatePersonBirthdayURL  "/User/Person/updatePersonBirthday"
//用户昵称修改请求地址
#define  updatePersonNicknameURL  "/User/Person/updatePersonNickname"
//获取用户的收货地址
#define  getPersonAddressURL  "/User/Person/getPersonAddress"
//更新用户的收货地址
#define  updatePersonAddressURL  "/User/Person/updatePersonAddress"
//修改某个用户的性别
#define  updatePersonSexURL  "/User/Person/updatePersonSex"
//用户运动标签请求修改地址
#define  updatePersonSportsURL  "/User/Person/updatePersonSports"
// 修改某个用户的自定义运动标签地址
#define  updatePersonSportTagURL  "/User/Person/updatePersonSportTag"

//信息补全
#define   updateUserInfoURL  "/User/Person/updateUserInfo"
//注销
#define   doLogoutURL  "/User/Login/doLogout"  //注销个人信息
//关注某人
#define   doFollowingAttentionURL  "/Social/Following/doFollowingAttention"
//取消关注
#define   doFollowingCancelURL  "/Social/Following/doFollowingCancel"

//用户关注列表
#define   getFollowingListURL  "/Social/Following/getFollowingList"

//用户粉丝列表
#define   getFansListURL  "/Social/Fans/getFansList"

//用户好友列表
#define  getFriendsListURL "/Social/Following/getFriendsList"

//原生登陆
#define  doLoginURL "/User/Login/doLogin"
//第三方登陆
#define  doThirdLoginURL "/User/Login/doThirdLogin"
//第三方绑定
#define  doThirdBindURL "/User/Person/doThirdIdBind"
//根据用户第三方的openId判断用户是否存在
#define  doThirdIdCheckURL "/User/Login/doThirdIdCheck"
//微信微博用户绑定手机号
#define doUserPhoneBindURL "/User/Person/doUserPhoneBind"

//约伴模块
//创建约伴模块
#define doYueBanCreateByUserURL "/Social/YueBan/doYueBanCreateByUser"
//获取熟人的推荐列表
#define getYueBanListFromFriendsURL "/Social/YueBan/getYueBanListFromFriends"

//获取陌生人的推荐列表
#define getYueBanListFromStrangersURL "/Social/YueBan/getYueBanListFromStrangers"
//用户参与/拒绝约伴（应用内）

#define updataUserYueBanStateURL "/Social/YueBan/updataUserYueBanState"

//获取我的约伴列表
#define getMyYueBanDetailListURL "/Social/YueBan/getMyYueBanDetailList"
//用户停止广播某个约伴
#define doYueBanStopByUserURL "/Social/YueBan/doYueBanStopByUser"
//获取我参与的约伴的历史记录的列表
#define getMyAttendYueBanListURL "/Social/YueBan/getMyAttendYueBanList"
//获取某个约伴详情
#define getYueBanDetailURL "/Social/YueBan/getYueBanDetail"
//获取我参加的和我创建的约伴历史，创建的只返回停止了的
#define getMyYueBanRecordListURL "/Social/YueBan/getMyYueBanRecordList"

//获取我正在进行的游戏任务
#define getMyCurrentMultiGameInfoURL "/Game/MultiPlayer/getMyCurrentMultiGameInfo"
//获取当日任务目标与互动值
#define getTaskTargetAndInteractionValueURL "/Game/SinglePlayer/getTaskTargetAndInteractionValue"
//获取多人游戏邀请
#define getMyInvitationListURL "/Game/MultiPlayer/getMyInvitationList"
//获取游戏排行榜
#define getMyScoreRankURL  "/Game/MultiPlayer/getMyScoreRank"

/*
 二维码
 */
#define doQRcodeCreateURL "/Tool/QRcode/doQRcodeCreate" //生成二维码
#define doQRcodeScanURL "/Tool/QRcode/doQRcodeScan"  //扫描二维码



#endif
