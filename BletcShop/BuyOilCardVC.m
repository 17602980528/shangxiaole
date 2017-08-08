//
//  BuyOilCardVC.m
//  BletcShop
//
//  Created by Bletc on 2017/8/8.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "BuyOilCardVC.h"

#import "GasStationAddressCell.h"
#import "GasStaionContentCell.h"
#import "BuyOilDetailInfoVC.h"


@interface BuyOilCardVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tabview;

@end

@implementation BuyOilCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    LEFTBACK
    self.navigationItem.title = @"加油卡详情";

    _tabview.estimatedRowHeight = 100;
    _tabview.rowHeight = UITableViewAutomaticDimension;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        return 0.01;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section==0) {
        
        GasStationAddressCell*gasCell = [tableView dequeueReusableCellWithIdentifier:@"GasStationAddressCellID"];
        if (!gasCell) {
            gasCell = [[[NSBundle mainBundle]loadNibNamed:@"GasStationAddressCell" owner:self options:nil] firstObject];
        }
        gasCell.addressClickBlock = ^{
          
            NSLog(@"---addressClickBlock-----");
        };
        return gasCell;
    }else{
        
        GasStaionContentCell*gasContenCell = [tableView dequeueReusableCellWithIdentifier:@"GasStaionContentCellID"];
        if (!gasContenCell) {
            gasContenCell = [[[NSBundle mainBundle]loadNibNamed:@"GasStaionContentCell" owner:self options:nil] firstObject];
        }
        
        if (indexPath.section==1) {
            
            gasContenCell.titleLab.text = @"油企介绍";
            gasContenCell.contenLab.text = @"中国石油化工集团公司(英文缩写Sinopec Group)是1998年7月国家在原中国石油化工总公司基础上重组成立的特大型石油石化企业集团，是国家独资设立的国有公司、国家授权投资的机构和国家控股公司。公司注册资本2316亿元，董事长为法定代表人，总部设在北京。 公司对其全资企业、控股企业、参股企业的有关国有资产行使资产受益、重大决策和选择管理者等出资人的权力，对国有资产依法进行经营、管理和监督，并相应承担保值增值责任。公司控股的中国石油化工股份有限公司先后于2000年10月和2001年8月在境外、境内发行H股和A股，并分别在香港、纽约、伦敦和上海上市。 公司主营业务范围包括：实业投资及投资管理；石油、天然气的勘探、开采、储运（含管道运输）、销售和综合利用；煤炭生产、销售、储存、运输；石油炼制；成品油储存、运输、批发和零售；石油化工、天然气化工、煤化工及其他化工产品的生产、销售、储存、运输；新能源、地热等能源产品的生产、销售、储存、运输； 中国石油化工集团公司在2015年《财富》世界500强企业中排名第2位。";
            
            
            if (gasContenCell.moreBtn.selected) {
                gasContenCell.contenLab.numberOfLines = 0;
            }else{
                gasContenCell.contenLab.numberOfLines = 2;
                
            }
            gasContenCell.moreBtn.hidden = NO;
            gasContenCell.moreBnt_height.constant = 30;
            
            [gasContenCell.moreBtn addTarget:self action:@selector(shouSuoClick:) forControlEvents:UIControlEventTouchUpInside];
           
        
        }else{
            gasContenCell.contenLab.numberOfLines = 0;
            gasContenCell.moreBtn.hidden = YES;
            gasContenCell.moreBnt_height.constant = 11;

        }
        
        if (indexPath.section ==2) {
            gasContenCell.titleLab.text = @"优惠详情";
            gasContenCell.contenLab.text = @"优惠内容：持中石油vip加油卡用户可享受95＃98折折扣。";
        }
        
        if (indexPath.section ==3) {
            gasContenCell.titleLab.text = @"使用须知";
            gasContenCell.contenLab.text = @"1、加油卡仅限加油使用，不可购买非油品；\n2、加油卡余额不可提现、不可转让，不能透支、不计利息；\n3、充值时不开局发票，请使用加油卡时，在合作加油站按照加油实际支付金额开具发票（返利部分不开具发票）；\n4、该加油卡只能在商消乐与中石油合作的指定加油站使用；\n5、一张油卡仅限一个账户使用；\n6、单次充值须大于500元；\n7、根据国家相关法律法规，每张加油卡充值后余额不得超过4000元。";
        }
        if (indexPath.section ==4) {
            gasContenCell.titleLab.text = @"加油站列表";
            gasContenCell.contenLab.text = @"优中国石化（西三环一站加油站）、中国石化（红光路）、中国石化（宏宝加油站）、中国石化（聚家花园北）、中国石化（恒瑞加油站）、中国石化（枣园西路）、中国石化（枣园北路）、中国石化（建章路加油站）、中国石化（雁协加油站）、中国石化（红达加油站）、中国石化（南三环加油站）、中国石化（尤西路）、中国石化（六村堡医院东）、中国石化（长安南路）、中国石化（航天大道加油站）、中国石化（西安东元加油站）、中国石化（子午大道加油站）、中国石化（西安医专附属医院西加油站）、中国石化（永通加油站）、中国石化（北三环加油1站）、中国石化（咸宁东路）、中国石化（聚安盛都东北）、中国石化（方家寨加油站）、中国石化（环城北路）、中国石化（千家喜购物广场东）、中国石化（古都希望小学西南）、中国石化（留村）、中国石化（备战路加油加气站）、中国石化（灞桥服务区）、中国石化（赵庄小学西北）、中国石化（钓台路）、中国石化（罗百寨）、中国石化（宋家滩）、中国石化（华胥加油站）、中国石化（九华山别苑东）、中国石化（涝峪口加油站）、中国石化（张市加油站）、中国石化（焦岱街加油站）、中国石化（百果园路加油站）、中国石化（北屯卫生所东南）、中国石化（白云寺南加油站）、中国石化（宝姜石化）、中国石化（二环北路西段加油站）、中国石化（咸宁东路）";
        }
        
        return gasContenCell;
    }
}


-(void)shouSuoClick:(UIButton *)sender{

    
       sender.selected = !sender.selected;
    [self.tabview reloadData];
}
- (IBAction)buyClick:(UIButton *)sender {
    
    PUSH(BuyOilDetailInfoVC)
}
@end
