//
//  IWWeatherViewController.h
//  Ihors-weather
//
//  Created by Admin on 5/16/14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IWYahooWeatherAdapterDelegate.h"
@interface IWWeatherViewController : UIViewController<UIWebViewDelegate,IWYahooWeatherAdapterDelegate>


@property (strong, nonatomic) NSString *woeid;
@end
