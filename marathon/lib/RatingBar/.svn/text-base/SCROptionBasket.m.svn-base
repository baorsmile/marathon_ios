//
//  SCROptionBasket.m
//  TouchCustoms
//
//  Created by Aleks Nesterow-Rutkowski on 10/26/10.
//	aleks@screencustoms.com
//

#import "SCROptionBasket.h"

#import "SCRMemoryManagement.h"

@implementation SCROptionBasket (MustOverride)

- (NSArray *)items
{
	return nil;
}

- (NSArray *)itemNames
{
	return nil;
}

@end

@implementation SCROptionBasket (Protected)

- (void)postProcessCreatedIndexes
{
}

- (NSString *)selectedItemsDescription
{
	NSMutableString *result = [NSMutableString string];
	
	NSUInteger counter = 0;
	
	NSIndexSet *selectedItems = self.selectedIndexes;
	
	NSUInteger itemIndex = [selectedItems firstIndex];
	
	while (itemIndex != NSNotFound)
	{
		if (0 != counter)
		{
			[result appendString:@" "];
		}
		
		[result appendString:[[self itemNames] objectAtIndex:itemIndex]];
		
		itemIndex = [selectedItems indexGreaterThanIndex:itemIndex];
		counter++;
	}
	
	return result;
}

@end

#define kSelectedIndexesKey	@"selected-indexes"

@implementation SCROptionBasket

@synthesize selectType = _selectType;
@synthesize selectedIndexes = _selectedIndexes;

#pragma mark init / dealloc

- (id)init 
{
	if ((self = [super init]))
	{
		_selectedIndexes = [[NSMutableIndexSet alloc] init];
		[self postProcessCreatedIndexes];
	}
	
	return self;
}

- (id)initWithSelectType:(SCROptionSelectType)selectType
{
	if ((self = [self init]))
	{
		_selectType = selectType;
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [super init]))
	{
		id indexSet = [decoder decodeObjectForKey:kSelectedIndexesKey];
		
		if (indexSet)
		{
			_selectedIndexes = [[NSMutableIndexSet alloc] initWithIndexSet:indexSet];
		}
		else
		{
			_selectedIndexes = [[NSMutableIndexSet alloc] init];
			[self postProcessCreatedIndexes];
		}
	}
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:_selectedIndexes forKey:kSelectedIndexesKey];
}

- (void)dealloc
{
	SCR_RELEASE_SAFELY(_selectedIndexes);
	
	[super dealloc];
}

#pragma mark Item operations

- (void)selectAllItems
{
	[_selectedIndexes addIndexesInRange:NSMakeRange(0, [self items].count)];
}

- (void)selectNoItems
{
	[_selectedIndexes removeAllIndexes];
}

- (void)toggleItem:(NSUInteger)itemIndex
{	
	if ([_selectedIndexes containsIndex:itemIndex])
	{
		[_selectedIndexes removeIndex:itemIndex];
	}
	else
	{
		[_selectedIndexes addIndex:itemIndex];
	}
}

@end
