//
//  SCRFooterLabel.h
//  TouchCustoms
//
//  Created by Aleks Nesterow-Rutkowski on 3/12/10.
//	aleks@screencustoms.com
//	
//	Purpose
//	UILabel that is intended to be inserted as a UITableView footer.
//	Tweaked to has the same shadow, font color and style.
//

@interface SCRFooterLabel : UILabel {

}

/** 
  * You can still instantiate the label with other init* methods.
  * This method is optional, but you're encouraged to you use it.
  * 
  * Note, that in case you're going with another init method,
  * you will need to set label's width to the width of the parent 
  * UITableView manually (usually 320 px), otherwise, heightForCurrentText
  * method will return wrong value.
  */
- (id)initWithText:(NSString *)footerText;

/**
  * Call this in tableView:heightForFooterInSection: method.
  */
- (CGFloat)heightForCurrentText;

@end
