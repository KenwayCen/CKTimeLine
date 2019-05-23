//
//  CKTimeline.h
//  CKTimeLineCovert
//
//  Created by Kenway-Pro on 2019/3/28.
//  Copyright © 2019 Kenway. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CKTimeline : NSObject

/**
 将时间戳转换为一个特定的字符串表示

 @param input 时间戳：number或者string
 @return 表示时间的一个字符串
 */
- (NSString *)timelineConvert:(id)input;
@end

NS_ASSUME_NONNULL_END
