//
//  IWYahooWeatherAdapterDelegate.h
//  Ihors-weather
//
//  Created by Admin on 5/15/14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

@class IWYahooWeatherAdapter;
@protocol IWYahooWeatherAdapterDelegate <NSObject>

@optional
- (void)returnedListOfCountries:(NSArray *)listOfCountries;
- (void)returnedListOfRegions:(NSArray *)listOfRegions;
- (void)returnedListOfPlaces:(NSArray *)listOfPlaces;
- (void)returnedWeather:(NSString*)htmlString andTitle:(NSString *)title;
- (void)errorWasHapened:(NSString *)errorMessage andCode:(int)errorCode;
@end
