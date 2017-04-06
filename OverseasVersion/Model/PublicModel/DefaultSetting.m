//
//  DefaultSetting.m
//  GTriches
//
//  Created by devair on 14/12/28.
//  Copyright (c) 2014年 eric. All rights reserved.
//

#import "DefaultSetting.h"

@implementation DefaultSetting

/**
 @property (assign, nonatomic) NSInteger uid;//保存最近登录用户uid
 @property (strong, nonatomic) NSString      *access_token;      //应用识别码
*/

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:[NSNumber numberWithInteger:_uid] forKey:@"uid"];
    [aCoder encodeObject:_mobile forKey:@"mobile"];
    [aCoder encodeObject:_access_token forKey:@"access_token"];
    [aCoder encodeObject:[NSNumber numberWithLongLong:_access_tokenTimeStamp] forKey:@"access_tokenTimeStamp"];
    [aCoder encodeObject:[NSNumber numberWithBool:_isTouchID] forKey:@"isTouchID"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self == [super init]) {
        self.uid = [[aDecoder decodeObjectForKey:@"uid"]integerValue];
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
        self.access_token = [aDecoder decodeObjectForKey:@"access_token"];
        self.access_tokenTimeStamp = [[aDecoder decodeObjectForKey:@"access_tokenTimeStamp"] longLongValue];
        self.isTouchID = [[aDecoder decodeObjectForKey:@"isTouchID"] boolValue];
    }
    return self;
}
- (void)clearData {
    self.uid = 0;
}
//初始化数据，默认只调用一次
- (void)dataWithInit {
    self.uid = 0;
    self.access_token = @"";
    self.mobile =@"";
    self.isTouchID = false;
}

/**-------   don't change following content   -------*/

+ (instancetype)defaultSettingWithFile {
    DefaultSetting *setting = [[DefaultSetting alloc]init];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    filePath = [filePath stringByAppendingPathComponent:DefaultSettingFile];
    
    if ([fileManager fileExistsAtPath:filePath]) { //文件已存在
        //反归档
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
        setting = [unarchiver decodeObjectForKey:@"root"];
        [unarchiver finishDecoding];
    } else {//文件不存在，创建并保存
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
        [setting dataWithInit];
        [DefaultSetting saveSetting:setting];
    }
    return setting;
}

+ (void)saveSetting:(DefaultSetting *)setting {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    filePath = [filePath stringByAppendingPathComponent:DefaultSettingFile];
    if ([fileManager fileExistsAtPath:filePath]) { //文件已存在
        //归档
        NSMutableData *data = [NSMutableData data];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
        [archiver encodeObject:setting forKey:@"root"];
        [archiver finishEncoding];
        [data writeToFile:filePath atomically:YES];
    } else {
        NSLog(@"------>defaultSetting couldn't save, the file not exist<------");
    }
}

@end
