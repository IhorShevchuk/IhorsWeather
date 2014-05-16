//
//  LiberyOfFunctions.m
//  IntelSplitDemo
//
//  Created by Admin on 09.07.13.
//
//

#import "IWLiberyOfFunctions.h"

@implementation IWLiberyOfFunctions
{

}
#pragma mark - search alhorithm
+(BOOL)searchWords:(NSArray *)words inString:(NSString *)string
{
	bool notFound=NO;
	if(![words count])
		return YES;
	if([[words objectAtIndex:0] isEqualToString:@""])
		return YES;
	NSMutableString *str = [string mutableCopy];
//    if([[words objectAtIndex:[words count] - 1] isEqualToString:@""])
//        return YES;
	for(NSString *searchString in words)
	{
		if([searchString isEqualToString:@" "])
			break;
		if([searchString length]==0)
		{
			break;
			//notFound = YES;
			//continue;
		}
		if ([str rangeOfString:searchString options:NSCaseInsensitiveSearch].location == NSNotFound)
		{
			notFound = YES;
		}
		else
		{
			NSRange rOriginal = [str rangeOfString: searchString];
			if (NSNotFound != rOriginal.location)
			{
				str = [[str stringByReplacingCharactersInRange: rOriginal withString: @""] mutableCopy];
			}

		}

		//you can add more
		/*
		   if (<#condition#>) {
		   <#statements#>
		   }
		 */


	}

	return notFound;
}
+(NSArray *)divadeStringIntoWords:(NSString *)string
{
	NSMutableArray* words = [[NSMutableArray alloc]init];
	if([string rangeOfString:@" "].location!=NSNotFound)
	{
		words = [[string componentsSeparatedByString:@" "] mutableCopy];
	}
	if([words count] == 0)
		[words addObject:string];
	if([[words objectAtIndex:[words count] - 1] isEqualToString:@""])
	{
		[words removeObjectAtIndex:[words count] - 1];
	}
	return words;
}
@end
