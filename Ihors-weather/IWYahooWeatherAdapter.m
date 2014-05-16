//
//  IWYahooWeatherAdapter.m
//  Ihors-weather
//
//  Created by Admin on 5/15/14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import "IWYahooWeatherAdapter.h"


@interface IWYahooWeatherAdapter ()
{
	NSString *AppID;


	NSXMLParser *rssParser;
	NSMutableArray *articles;
	NSMutableDictionary *item;
	NSString *currentElement;
	NSMutableString *ElementValue;
	BOOL errorParsing;


	int itemsKind;
}
@end
@implementation IWYahooWeatherAdapter

static IWYahooWeatherAdapter *iwYahooWeatherAdapter = nil;

- (id)init
{
	if(iwYahooWeatherAdapter == nil)
	{
		iwYahooWeatherAdapter = [super init];
	}
	else
	{
		itemsKind = -1;
		return iwYahooWeatherAdapter;
	}

	if(iwYahooWeatherAdapter)
	{
		AppID = nil;
		itemsKind = -1;
	}

	return iwYahooWeatherAdapter;
}
- (id)initWithAppID:(NSString *)appID andDelegate:(id<IWYahooWeatherAdapterDelegate>)delegate
{
	iwYahooWeatherAdapter = [self init];
	if(iwYahooWeatherAdapter)
	{
		if(AppID == nil)
		{
			AppID = appID;
		}
		self.delegate = delegate;
	}
	return iwYahooWeatherAdapter;
}

-(void)loadListOfCountries;
{
	[self parseXMLFileAtURL: [NSString stringWithFormat:@"http://where.yahooapis.com/v1/countries?appid=%@",AppID]];
}
-(void)loadListOfRegionsForCountryCode:(NSString*)countryCode
{
	if([countryCode length] != 2)
	{
		NSLog(@"%@",countryCode);
		if([self.delegate respondsToSelector:@selector(errorWasHapened:andCode:)])
		{
			[self.delegate errorWasHapened:@"Error with country code. Please set corect country code" andCode:3];
		}
		return;
	}
	[self parseXMLFileAtURL: [NSString stringWithFormat:@"http://where.yahooapis.com/v1/states/%@?appid=%@",countryCode,AppID]];
}
-(void)loadListOfPlacesOfRegionWOEID:(NSString*)regionWOEID
{

	if([regionWOEID intValue]<1)
	{
		if([self.delegate respondsToSelector:@selector(errorWasHapened:andCode:)])
		{
			[self.delegate errorWasHapened:@"Error with regionWOEID. Please set corect regionWOEID" andCode:2];
		}
		return;
	}
	[self parseXMLFileAtURL: [NSString stringWithFormat:@"http://where.yahooapis.com/v1/place/%@/children?appid=%@",regionWOEID,AppID]];
}
-(void)loadWeatherForWOEID:(NSString*)woeid
{
	if([woeid intValue]<1)
	{
		if([self.delegate respondsToSelector:@selector(errorWasHapened:andCode:)])
		{
			[self.delegate errorWasHapened:@"Error with regionWOEID. Please set corect regionWOEID" andCode:2];
		}
		return;
	}
	[self parseXMLFileAtURL: [NSString stringWithFormat:@"http://weather.yahooapis.com/forecastrss?w=%@&u=c",woeid]];

}
- (void)parseXMLFileAtURL:(NSString *)URL
{
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
	                                [NSURL URLWithString:URL]];
	NSURLConnection *urlCon = [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:YES];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	articles = [[NSMutableArray alloc] init];
	errorParsing=NO;

	rssParser = [[NSXMLParser alloc] initWithData:data];
	[rssParser setDelegate:self];

	// You may need to turn some of these on depending on the type of XML file you are parsing
	[rssParser setShouldProcessNamespaces:NO];
	[rssParser setShouldReportNamespacePrefixes:NO];
	[rssParser setShouldResolveExternalEntities:NO];

	errorParsing = ![rssParser parse];

}
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {

	NSString *errorString = [NSString stringWithFormat:@"Error code %i", [parseError code]];
	if([self.delegate respondsToSelector:@selector(errorWasHapened:andCode:)])
	{
		[self.delegate errorWasHapened:[NSString stringWithFormat:@"Error parsing XML: %@", errorString] andCode:[parseError code]];
	}
	errorParsing = YES;
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	currentElement = [elementName copy];
	ElementValue = [[NSMutableString alloc] init];
	if ([elementName isEqualToString:@"place"]||[elementName isEqualToString:@"item"])
	{
		item = [[NSMutableDictionary alloc] init];
	}

	if([elementName isEqualToString:@"item"]&&(itemsKind == -1))
	{
		itemsKind = -2;

	}
	if([elementName isEqualToString:@"placeTypeName"]&&(itemsKind == -1))
	{
		itemsKind = [[attributeDict objectForKey:@"code"]integerValue];

	}

}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	[ElementValue appendString:string];
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if([elementName isEqualToString:@"description"])
	{
		//NSLog(@"%@",ElementValue);

	}

	if ([elementName isEqualToString:@"place"]||[elementName isEqualToString:@"item"])
	{
		[articles addObject:[item copy]];
	}
	else
	{
		[item setObject:ElementValue forKey:elementName];
	}

}
- (void)parserDidEndDocument:(NSXMLParser *)parser
{



	if (errorParsing == NO)
	{
		if([articles count])
		{
			switch (itemsKind) {
			case 12: // countries
			{
				if([self.delegate respondsToSelector:@selector(returnedListOfCountries:)])
				{
					[self.delegate returnedListOfCountries:articles];
				}
			}
			break;
			case 8: //regions,states etc.
			{
				if([self.delegate respondsToSelector:@selector(returnedListOfRegions:)])
				{
					[self.delegate returnedListOfRegions:articles];
				}
			}
			case 7: //cities
			{
				if([self.delegate respondsToSelector:@selector(returnedListOfPlaces:)])
				{
					[self.delegate returnedListOfPlaces:articles];
				}
			}
			break;
			case -2:
			{
				if([self.delegate respondsToSelector:@selector(returnedWeather:andTitle:)])
				{
					[self.delegate returnedWeather:[[articles objectAtIndex:0] objectForKey:@"description"] andTitle:[[articles objectAtIndex:0] objectForKey:@"title"]];
				}
			}
			default:
				if([self.delegate respondsToSelector:@selector(errorWasHapened:andCode:)])
				{
					[self.delegate errorWasHapened:@"Error occurred during XML processing" andCode:1];
				}
				break;
			}
            itemsKind =-1;

		}
		else
		{
			if([self.delegate respondsToSelector:@selector(errorWasHapened:andCode:)])
			{
				[self.delegate errorWasHapened:@"Error occurred during XML processing" andCode:1];
			}
		}
	}
	else
	{
		if([self.delegate respondsToSelector:@selector(errorWasHapened:andCode:)])
		{
			[self.delegate errorWasHapened:@"Error occurred during XML processing" andCode:1];
		}
	}

}
@end;
