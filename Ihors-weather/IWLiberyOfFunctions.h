//
//  LiberyOfFunctions.h
//  IntelSplitDemo
//
//  Created by Admin on 09.07.13.
//
//

#import <Foundation/Foundation.h>

@interface IWLiberyOfFunctions : NSObject
//search
+(BOOL)searchWords:(NSArray *)words inString:(NSString *)string;
+(NSArray *)divadeStringIntoWords:(NSString *)string;
@end
