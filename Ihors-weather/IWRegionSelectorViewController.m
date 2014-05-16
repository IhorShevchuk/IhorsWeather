//
//  IWRegionViewController.m
//  Ihors-weather
//
//  Created by Admin on 5/15/14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import "IWRegionSelectorViewController.h"
#import "IWCitySelectorViewController.h"
#import "IWYahooWeatherAdapter.h"

@interface IWRegionSelectorViewController ()
{
	NSDictionary *regions;
	NSArray *regionesNames;
	NSArray *filteredRegions;

	NSString *selectedWOEID;
	IBOutlet UITableView *regionsTableView;
	IBOutlet UISearchBar *regionsSearchBar;

}

@end

@implementation IWRegionSelectorViewController

- (id)initWithStyle:(UITableViewStyle)style
{
	self = [super initWithStyle:style];
	if (self)
	{
		// Custom initialization
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	// Uncomment the following line to preserve selection between presentations.
	// self.clearsSelectionOnViewWillAppear = NO;

	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	// self.navigationItem.rightBarButtonItem = self.editButtonItem;
	IWYahooWeatherAdapter *iwYahooWeatherAdapter = [[IWYahooWeatherAdapter alloc]initWithAppID:APPID andDelegate:self];
	filteredRegions = nil;
	[iwYahooWeatherAdapter loadListOfRegionsForCountryCode:self.countryCode];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [filteredRegions count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Configure the cell...
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"regionNameCell"];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"regionNameCell"];
	}
	cell.textLabel.text = [filteredRegions objectAtIndex:indexPath.row];
	return cell;
}

#pragma mark - Table view delegate
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

	selectedWOEID =[regions objectForKey:[[[tableView cellForRowAtIndexPath:indexPath] textLabel]text]];
	return indexPath;
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	// Get the new view controller using [segue destinationViewController].
	// Pass the selected object to the new view controller.
	IWCitySelectorViewController *iwCitySelectorViewController = (IWCitySelectorViewController *)[segue destinationViewController];
	iwCitySelectorViewController.regionWOEID = selectedWOEID;
}


#pragma mark - Searchbar delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
	searchBar.showsCancelButton = YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
	searchBar.text = @"";
	[searchBar resignFirstResponder];
	searchBar.showsCancelButton = NO;
	[self searchBar:searchBar textDidChange:@""];
	[regionsTableView reloadData];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	if([searchText length] == 0)
	{

		[regionsTableView reloadData];
		filteredRegions = regionesNames;
		return;
	}
	NSMutableSet *regionsSet = [[NSMutableSet alloc] init];


	NSArray *words = [IWLiberyOfFunctions divadeStringIntoWords:searchText];

	for(NSString *c in regionesNames)
	{


		if(![IWLiberyOfFunctions searchWords:words inString:c])
		{
			[regionsSet addObject:c];
		}

	}
	filteredRegions = [[regionsSet allObjects] sortedArrayUsingComparator:^NSComparisonResult (id a,id b){ return [a caseInsensitiveCompare:b]; }];;

	[regionsTableView reloadData];
}
#pragma mark - IWYahooWeatherAdapter delegate
- (void)returnedListOfRegions:(NSArray *)listOfRegions
{

	NSMutableDictionary *regionesMut = [[NSMutableDictionary alloc]initWithCapacity:[listOfRegions count]];
	for(NSDictionary *regionProperties in listOfRegions)
	{
		NSString *woeid=[regionProperties objectForKey:@"woeid"];
		NSString *name =[regionProperties objectForKey:@"name"];
		if((name != nil)&&(woeid != nil))
		{
			[regionesMut setObject:woeid forKey:name];
		}
	}

	regions = [regionesMut copy];
	regionesNames = [[regions allKeys] sortedArrayUsingComparator:^NSComparisonResult (id a,id b){ return [a caseInsensitiveCompare:b]; }];
	filteredRegions = [regionesNames copy];
	[regionsTableView reloadData];

}
@end
