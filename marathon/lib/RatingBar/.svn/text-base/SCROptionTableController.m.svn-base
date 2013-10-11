//
//  SCROptionTableController.m
//  TouchCustoms
//
//  Created by Aleks Nesterow-Rutkowski on 10/26/10.
//	aleks@screencustoms.com
//

#import "SCROptionTableController.h"

#import "SCRColorScheme.h"
#import "SCRLog.h"
#import "SCRMemoryManagement.h"

#define kPurpleColor	RGB(50, 79, 133)

@implementation SCROptionTableController

@synthesize optionBasket = _optionBasket;

- (void)dealloc
{
	SCR_RELEASE_SAFELY(_optionBasket);
	
	[super dealloc];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.optionBasket.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *result = nil;
	
	static NSString *CellIdentifier = @"option-cell";
	result = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (!result)
	{
		result = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
										 reuseIdentifier:CellIdentifier] autorelease];
		
	}
	
	result.textLabel.text = [self.optionBasket.itemNames objectAtIndex:indexPath.row];
	
	if ([self.optionBasket.selectedIndexes containsIndex:indexPath.row])
	{
		result.accessoryType = UITableViewCellAccessoryCheckmark;
		result.textLabel.textColor = kPurpleColor;
	}
	else
	{
		result.accessoryType = UITableViewCellAccessoryNone;
		result.textLabel.textColor = [UIColor blackColor];
	}
	
	return result;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	switch (self.optionBasket.selectType)
	{
		case SCROptionSingleSelect:
		{
			[self.optionBasket selectNoItems];
			
			NSArray *visibleRowIndexPathList = [tableView indexPathsForVisibleRows];
			
			for (NSIndexPath *visibleRowIndexPath in visibleRowIndexPathList)
			{
				UITableViewCell *cell = [tableView cellForRowAtIndexPath:visibleRowIndexPath];
				cell.accessoryType = UITableViewCellAccessoryNone;
				cell.textLabel.textColor = [UIColor blackColor];
			}
			
			break;
		}
		case SCROptionMultipleSelect:
		{
			break;
		}
	}
	
	[self.optionBasket toggleItem:indexPath.row];
	
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	
	if (UITableViewCellAccessoryCheckmark == cell.accessoryType)
	{
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.textLabel.textColor = [UIColor blackColor];
	}
	else
	{
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		cell.textLabel.textColor = kPurpleColor;
	}
}

@end
