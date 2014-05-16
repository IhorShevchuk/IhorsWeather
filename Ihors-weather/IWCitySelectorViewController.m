//
//  IWCitySelectorViewController.m
//  Ihors-weather
//
//  Created by Admin on 5/13/14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import "IWCitySelectorViewController.h"
#import "IWWeatherViewController.h"
#import "IWYahooWeatherAdapter.h"

@interface IWCitySelectorViewController ()
{
	NSDictionary *cities;
	NSArray *citiesName;
	NSArray *filteredCities;

	NSString *selectedWOEID;

	IBOutlet UITableView *cityTableView;
	IBOutlet UISearchBar *citySearchBar;
}
@end

@implementation IWCitySelectorViewController

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
	[iwYahooWeatherAdapter loadListOfPlacesOfRegionWOEID:self.regionWOEID];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{       // Return the number of sections.
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	// Return the number of rows in the section.
	return [filteredCities count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Configure the cell...
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cityNameCell"];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cityNameCell"];
	}
	cell.textLabel.text = [filteredCities objectAtIndex:indexPath.row];
	return cell;
}
#pragma mark - Table view delegate
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	selectedWOEID =[cities objectForKey:[[[tableView cellForRowAtIndexPath:indexPath] textLabel]text]];
	return indexPath;
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	// Get the new view controller using [segue destinationViewController].
	// Pass the selected object to the new view controller.
	IWWeatherViewController *iwWeatherViewController = (IWWeatherViewController *)[segue destinationViewController];
	iwWeatherViewController.woeid = selectedWOEID;
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
	[cityTableView reloadData];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	if([searchText length] == 0)
	{

		[cityTableView reloadData];
		filteredCities = citiesName;
		return;
	}
	NSMutableSet *citiesSet = [[NSMutableSet alloc] init];


	NSArray *words = [IWLiberyOfFunctions divadeStringIntoWords:searchText];

	for(NSString *c in citiesName)
	{


		if(![IWLiberyOfFunctions searchWords:words inString:c])
		{
			[citiesSet addObject:c];
		}

	}
	filteredCities = [[citiesSet allObjects] sortedArrayUsingComparator:^NSComparisonResult (id a,id b){ return [a caseInsensitiveCompare:b]; }];;

	[cityTableView reloadData];
}

#pragma mark - IWYahooWeatherAdapter delegate
- (void)returnedListOfPlaces:(NSArray *)listOfPlaces
{
	NSMutableDictionary *citiesMut = [[NSMutableDictionary alloc]initWithCapacity:[listOfPlaces count]];
	for(NSDictionary *regionProperties in listOfPlaces)
	{
		NSString *woeid=[regionProperties objectForKey:@"woeid"];
		NSString *name =[regionProperties objectForKey:@"name"];
		if((name != nil)&&(woeid != nil))
		{
			[citiesMut setObject:woeid forKey:name];
		}
	}

	cities = [citiesMut copy];
	citiesName = [[cities allKeys] sortedArrayUsingComparator:^NSComparisonResult (id a,id b){ return [a caseInsensitiveCompare:b]; }];
	filteredCities = [citiesName copy];
	[cityTableView reloadData];

}
@end
