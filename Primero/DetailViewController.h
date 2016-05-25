//
//  DetailViewController.h
//  Primero
//
//  Created by Innovación y Desarrollo on 25-05-16.
//  Copyright © 2016 Innovación y Desarrollo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

