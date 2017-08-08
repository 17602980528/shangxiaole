//
//  BuyOilDetailInfoVC.m
//  BletcShop
//
//  Created by Bletc on 2017/8/8.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "BuyOilDetailInfoVC.h"

@interface BuyOilDetailInfoVC ()
{
    UITapGestureRecognizer *old_tap;
}
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *ali_tap;
@end

@implementation BuyOilDetailInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    LEFTBACK
    self.navigationItem.title = @"购买详情";
    old_tap = _ali_tap;

}
- (IBAction)chosePayment:(UITapGestureRecognizer *)sender {
    
    if (sender !=old_tap) {
        
        UIImageView *imgV = [sender.view viewWithTag:999];
        imgV.image = [UIImage imageNamed:@"选中sex.png"];
        
        UIImageView *imgV_old = [old_tap.view viewWithTag:999];
        imgV_old.image = [UIImage imageNamed:@"默认sex.png"];
        
        old_tap = sender;
    }
    
}



@end
