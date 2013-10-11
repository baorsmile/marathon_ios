//
//  SCROptionBasket.h
//  TouchCustoms
//
//  Created by Aleks Nesterow-Rutkowski on 10/26/10.
//	aleks@screencustoms.com
//	
//	Purpose
//	Contains a full list of elements and remembers the selected element or a series of elements.
//

typedef enum {
	SCROptionSingleSelect,
	SCROptionMultipleSelect
} SCROptionSelectType;

@interface SCROptionBasket : NSObject <NSCoding>
{
@private
	SCROptionSelectType _selectType;
	NSMutableIndexSet *_selectedIndexes;
}

@property (nonatomic, assign) SCROptionSelectType selectType;
@property (nonatomic, readonly) NSIndexSet *selectedIndexes;

- (id)initWithSelectType:(SCROptionSelectType)selectType;
/** If the item is already selected, it becomes deselected (removed from selectedItems). */
- (void)toggleItem:(NSUInteger)itemIndex;
- (void)selectAllItems;
- (void)selectNoItems;

@end

@interface SCROptionBasket (Protected)

- (void)postProcessCreatedIndexes;
- (NSString *)selectedItemsDescription;

@end

@interface SCROptionBasket (MustOverride)

- (NSArray *)items;
- (NSArray *)itemNames;

@end
