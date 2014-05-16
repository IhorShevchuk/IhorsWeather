//
//  IWWeatherViewController.m
//  Ihors-weather
//
//  Created by Admin on 5/16/14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import "IWWeatherViewController.h"
#import "IWYahooWeatherAdapter.h"

@interface IWWeatherViewController ()
{

	IBOutlet UIWebView *weatherWebView;
	IBOutlet UITableView *weatherTableView;
}
@end

@implementation IWWeatherViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self)
	{
		// Custom initialization
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view.

	IWYahooWeatherAdapter *iwYahooWeatherAdapter = [[IWYahooWeatherAdapter alloc]initWithAppID:@"pI6c76jV34GJKzisWHae.pPJ.VYaS_MxgSBDD0Fykj1UPhZ1LlUhn9YRXrg30dg4oZqfRQ--" andDelegate:self];
	[iwYahooWeatherAdapter loadWeatherForWOEID:self.woeid];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}
- (void)returnedWeather:(NSString*)htmlString andTitle:(NSString *)title
{
	NSString *htmlStr = [NSString stringWithFormat:@"<html><body><h3>%@</h3>%@</body></html>",title,htmlString];
	[weatherWebView loadHTMLString:htmlStr baseURL:nil];
}
@end
