//
//  IWCitySelectorViewController.h
//  Ihors-weather
//
//  Created by Admin on 5/13/14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IWYahooWeatherAdapter.h"

@interface IWCitySelectorViewController : UITableViewController<IWYahooWeatherAdapterDelegate>


@property (strong, nonatomic) NSString *regionWOEID;
@end
