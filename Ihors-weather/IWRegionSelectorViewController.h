//
//  IWRegionViewController.h
//  Ihors-weather
//
//  Created by Admin on 5/15/14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IWYahooWeatherAdapterDelegate.h"
@interface IWRegionSelectorViewController : UITableViewController<IWYahooWeatherAdapterDelegate>

@property (strong, nonatomic) NSString *countryName;
@property (strong, nonatomic) NSString *countryCode;
@end
