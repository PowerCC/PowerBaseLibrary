//
//  CommonResultModel.h
//  BaiHe
//
//  Created by PowerCC on 15/1/13.
//  Copyright (c) 2015年 itotemstudio. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CommonData : JSONModel

@property (nonatomic, copy) NSString<Optional> *other;
@property (nonatomic, copy) NSString<Optional> *apver;
@property (nonatomic, strong) NSObject<Optional> *result;

@end



@interface CommonJsonModel : JSONModel

/**
 *  请求返回code
 */
@property (nonatomic, copy) NSString<Optional> *code;

/**
 *  请求返回msg
 */
@property (nonatomic, copy) NSString<Optional> *msg;

/**
 *  接口返回的结果data
 */
@property (nonatomic, strong) CommonData<Optional> *data;


@end



@interface CommonResultModel : NSObject

/**
 *  请求返回原始字典
 */
@property (nonatomic, strong) NSDictionary *resultDic;

/**
 *  请求返回JSON模型
 */
@property (nonatomic, strong) CommonJsonModel *jsonModel;

/**
 *  是否为空数据
 */
@property (nonatomic, assign) BOOL emptyData;

/**
 *  错误信息
 */
@property (nonatomic, strong) NSError *errorInfo;


- (id)initWithEmpty:(BOOL)emptyData;

- (id)initWithError:(NSError *)errorInfo;

@end



@interface CommonDownloadModel : CommonResultModel

/**
 *  请求响应
 */
@property (nonatomic, strong) NSURLResponse *response;

/**
 *  对象
 */
@property (nonatomic, strong) NSObject *obj;

@end

