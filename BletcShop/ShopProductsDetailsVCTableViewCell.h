//
//  ShopProductsDetailsVCTableViewCell.h
//  BletcShop
//
//  Created by apple on 2017/7/4.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopProductsDetailsVCTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *productPrice;
@property (weak, nonatomic) IBOutlet UILabel *productMoreDes;
@property (weak, nonatomic) IBOutlet UILabel *cardCanUse;
@property (weak, nonatomic) IBOutlet UILabel *couponCanuse;

@end
