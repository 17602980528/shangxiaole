//
//  CardBusinessTableViewCell.m
//  BletcShop
//
//  Created by apple on 2017/6/28.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "CardBusinessTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation CardBusinessTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.cardImageView.layer.cornerRadius=5.0f;
    self.cardImageView.clipsToBounds=YES;
    self.imgView.layer.cornerRadius=3.0f;
    self.imgView.clipsToBounds=YES;
    self.tradeLable.layer.cornerRadius=2.0f;
    self.tradeLable.clipsToBounds=YES;
    self.bgView.layer.cornerRadius=5.0f;
    self.bgView.clipsToBounds=YES;
}
+(instancetype)creatCellWithTableView:(UITableView*)tableView
{
    CardBusinessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierEric];
    
//    if (!cell) {
//        cell = [[CardBusinessTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CardBusinessTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(void)setModel:(CardMarketModel *)model{
    
    _model = model;
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HEADIMAGE,_model.headimage]] placeholderImage:[UIImage imageNamed:@"user.png"]];
    
    self.nickNamelab.text = _model.nickname;
    self.timeLab.text = _model.datetime;
    self.shopLab.text = _model.store;
    
    NSString *type;
    if ([_model.method isEqualToString:@"transfer"]) {
        type = @"转让";
        self.descripLab.text = [NSString stringWithFormat:@"现有%@%@元%@%@一张(%.1f折卡),%.1f折%@,需要的朋友尽快下手",_model.store,_model.card_remain,_model.card_level,_model.card_type,[_model.rule floatValue]*0.1,[_model.rate floatValue]*0.1,type];
        self.headDescripLab.text=[NSString stringWithFormat:@"【%@】",type];
    }else{
        type = @"分享";
        self.descripLab.text = [NSString stringWithFormat:@"现有%@%@元%@%@一张(%g折卡),需要的朋友尽快下手,手续费仅(%@%%)",_model.store,_model.card_remain,_model.card_level,_model.card_type,[_model.rule floatValue]*0.1,_model.rate];
        self.headDescripLab.text=[NSString stringWithFormat:@"【%@】",type];
        
    }
    self.addresslab.text = [NSString stringWithFormat:@"来自%@",_model.address];
    self.pricelab.text = [NSString stringWithFormat:@"¥%@",_model.card_remain];
    self.tradeLable.text=[NSString stringWithFormat:@" %@ ",_model.trade];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
