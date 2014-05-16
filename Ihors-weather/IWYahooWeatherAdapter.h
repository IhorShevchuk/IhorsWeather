//
//  IWYahooWeatherAdapter.h
//  Ihors-weather
//
//  Created by Admin on 5/15/14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IWYahooWeatherAdapterDelegate.h"

@interface IWYahooWeatherAdapter : NSObject<NSURLConnectionDelegate,NSXMLParserDelegate>

@property (nonatomic, weak) id<IWYahooWeatherAdapterDelegate> delegate;
-(id)init;
-(id)initWithAppID:(NSString *)appID andDelegate:(id<IWYahooWeatherAdapterDelegate>)delegate;
-(void)loadListOfCountries;
-(void)loadListOfRegionsForCountryCode:(NSString*)countryCode;
-(void)loadListOfPlacesOfRegionWOEID:(NSString*)regionWOEID;
-(void)loadWeatherForWOEID:(NSString*)woeid;
@end
