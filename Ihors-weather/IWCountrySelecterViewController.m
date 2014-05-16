//
//  IWCountrySelecterViewController.m
//  Ihors-weather
//
//  Created by Admin on 5/13/14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import "IWCountrySelecterViewController.h"
#import "IWRegionSelectorViewController.h"

@interface IWCountrySelecterViewController ()
{
	NSDictionary *namesAndCodesOfCountries;
	NSArray *countries;
	NSArray *filteredCountries;
	NSString *selectedCountryName;
	IBOutlet UISearchBar *countrySearchBar;
	IBOutlet UITableView *countryTableView;
}
@end

@implementation IWCountrySelecterViewController

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

	[self prepareArraysForTableView];

}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
	//NSURLConnection
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [filteredCountries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Configure the cell...
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"countryNameCell"];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"countryNameCell"];
	}
	cell.textLabel.text = [filteredCountries objectAtIndex:indexPath.row];
	return cell;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{


}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	selectedCountryName =  [[[tableView cellForRowAtIndexPath:indexPath] textLabel]text];
	return indexPath;
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	// Get the new view controller using [segue destinationViewController].
	// Pass the selected object to the new view controller.
	IWRegionSelectorViewController *iwRegionSelectorViewController = (IWRegionSelectorViewController *)[segue destinationViewController];
	iwRegionSelectorViewController.countryName = selectedCountryName;
	iwRegionSelectorViewController.countryCode = [namesAndCodesOfCountries objectForKey:iwRegionSelectorViewController.countryName];

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
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	if([searchText length] == 0)
	{
		filteredCountries = countries;
		[countryTableView reloadData];
		return;
	}
	NSMutableSet *countriesSet = [[NSMutableSet alloc] init];


	NSArray *words = [IWLiberyOfFunctions divadeStringIntoWords:searchText];


	//for(int i = 0; i<[countries count]; ++i)
	for(NSString *c in countries)
	{


		if(![IWLiberyOfFunctions searchWords:words inString:c])
		{
			[countriesSet addObject:c];
		}

	}
	filteredCountries= [[countriesSet allObjects] sortedArrayUsingComparator:^NSComparisonResult (id a,id b){ return [a caseInsensitiveCompare:b]; }];;
	[countryTableView reloadData];
}

#pragma mark - Arrays

-(void)prepareArraysForTableView
{
	NSMutableDictionary *namesByCode = [NSMutableDictionary dictionary];
	for (NSString *code in [NSLocale ISOCountryCodes])
	{
		NSString *identifier = [NSLocale localeIdentifierFromComponents:@{NSLocaleCountryCode: code}];
		NSString *countryName = [[NSLocale currentLocale] displayNameForKey:NSLocaleIdentifier value:identifier];
		if (countryName)
			[namesByCode setObject:code forKey:countryName];
	}
	namesAndCodesOfCountries = [namesByCode copy];
	countries = [[namesAndCodesOfCountries allKeys] sortedArrayUsingComparator:^NSComparisonResult (id a,id b){ return [a caseInsensitiveCompare:b]; }];
	filteredCountries = [countries copy];
}
@end
