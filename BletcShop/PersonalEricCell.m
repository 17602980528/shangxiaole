//
//  PersonalEricCell.m
//  BletcShop
//
//  Created by apple on 2017/6/27.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "PersonalEricCell.h"
#import "Myitem.h"
@implementation PersonalEricCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(PersonalEricCell *)cellForTableView:(UITableView *)tableView
{
    static NSString *inde = @"PersonalCell";
    PersonalEricCell *cell = [tableView dequeueReusableCellWithIdentifier:inde];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PersonalEricCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setCellItem:(Myitem *)cellItem
{
    _cellItem = cellItem;
    self.titleLable.text = cellItem.title;
    self.headImg.image = [UIImage imageNamed:self.cellItem.img];
}
@end
