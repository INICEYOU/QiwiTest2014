//
//  INYDetailViewController.h
//  QIWItest2014
//
//  Created by Nice on 09/09/2014.
//  Copyright (c) 2014 INICEYOU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface INYDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) NSString *detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
