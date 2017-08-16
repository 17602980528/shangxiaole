//
//  OilMapVC.m
//  BletcShop
//
//  Created by apple on 2017/8/7.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "OilMapVC.h"
#import "OilHomeListVC.h"//加油点列表
#import "OneKeyOilVC.h"//一键加油
#import "BuyOilCardVC.h"
#import "BuyOilCardVC.h"
#import "EricAnnotition.h"
#import "BaiduMapManager.h"
@interface OilMapVC ()<BMKMapViewDelegate>
{
    UIView *topViw;
    NSArray *locationArr;
    BOOL onlyOnce;
    CLLocationCoordinate2D userLoc;
    UIScrollView *_scrollView;
}
@end

@implementation OilMapVC
//加油点列表
-(void)goOilShopList{
    OilHomeListVC *oilHomeListVC=[[OilHomeListVC alloc]init];
    [self.navigationController pushViewController:oilHomeListVC animated:YES];
}
-(void)oneKeyOilBtnClicks:(UITapGestureRecognizer *)tap{
    OneKeyOilVC *vc=[[OneKeyOilVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)buyOilCardsBtnClick:(UITapGestureRecognizer *)tap{
    BuyOilCardVC *vc=[[BuyOilCardVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)mapRelationBtnClick:(UIButton *)sender{
    switch (sender.tag) {
        case 0:
        {
            [self.mapView setCenterCoordinate:userLoc];
            [self.mapView setZoomLevel:15];
        }
            break;
        case 1:
        {
            [self.mapView setZoomLevel:18];
        }
            break;
        case 2:
        {
            [self locService];
        }
            break;
        case 3:
        {
            [self.mapView setZoomLevel:13];
        }
            break;
            
        default:
            break;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"常用油品";
    LEFTBACK
    onlyOnce=NO;
    
    UIButton *rightItemButoon=[UIButton buttonWithType:UIButtonTypeCustom];
    rightItemButoon.frame=CGRectMake(0, 0, 20, 20);
    [rightItemButoon setImage:[UIImage imageNamed:@"陈列 icon"] forState:UIControlStateNormal];
    
    [rightItemButoon addTarget:self action:@selector(goOilShopList) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightItemButoon];
    
    locationArr=@[@{@"latitude":@"34.09497",@"lontitude":@"108.904071",@"shop":@"中国石化(子午大道加油站)",@"image":@"oil0.jpg",@"address":@"陕西省西安市长安区黄良乡人民政府西"},@{@"latitude":@"34.180636",@"lontitude":@"108.924194",@"shop":@"中国石化(南三环加油站)",@"image":@"oil1.jpg",@"address":@"欧亚学院西靖宁路"},@{@"latitude":@"34.367209",@"lontitude":@"108.922525",@"shop":@"中国石化加油站(北三环)",@"image":@"oil2.jpg",@"address":@"北三环与G5京昆高速交叉口"},@{@"latitude":@"34.284125",@"lontitude":@"109.08386",@"shop":@"中国石化加油站(西蓝路）",@"image":@"oil3.jpg",@"address":@"纺北路256号"},@{@"latitude":@"34.230131",@"lontitude":@"109.064391",@"shop":@"中国石化加油站(南殿南路)",@"image":@"oil4.jpg",@"address":@"东三环附近(南殿智慧树幼儿园南)"},@{@"latitude":@"34.331932",@"lontitude":@"109.11208",@"shop":@"中国石化加油站(孙蔚如将军故居东北)",@"image":@"oil5.jpg",@"address":@"镇豁口村卫生所东北(西韩公路口、108国道)"},@{@"latitude":@"34.067474",@"lontitude":@"108.429685",@"shop":@"中国石化(周至环山旅游路第三加油站)",@"image":@"oil2.jpg",@"address":@"关中环线与尚九路十字"},@{@"latitude":@"34.220641",@"lontitude":@"109.013946",@"shop":@"中国石化加油站(曲江新区第二小学东北)",@"image":@"oil5.jpg",@"address":@"雁翔路黄渠头路段路北,武警总队雁翔路小区附近 "},@{@"latitude":@"34.352389",@"lontitude":@"109.145612",@"shop":@"加油站(代杨路)",@"image":@"oil6.jpg",@"address":@"西临快速干道临潼收费站1公里"},@{@"latitude":@"34.047359",@"lontitude":@"109.077651",@"shop":@"加油站(刘秀传统农业示范园东)",@"image":@"oil4.jpg",@"address":@"西安市长安区107省道附近、青禅寺村西北方 "},@{@"latitude":@"34.329814",@"lontitude":@"108.871598",@"shop":@"加油站(荣华幼儿园西北)",@"image":@"oil5.jpg",@"address":@"邓六路233号附近 "},@{@"latitude":@"34.473138",@"lontitude":@"109.342972",@"shop":@"中国石化加油站(金李路)",@"image":@"oil3.jpg",@"address":@"陕西省西安市临潼区108国道46公里处,108国道南侧,金李路附近 "},@{@"latitude":@"34.417683",@"lontitude":@"109.257495",@"shop":@"新丰加油站",@"image":@"oil6.jpg",@"address":@"108国道东100米"},@{@"latitude":@"34.362238",@"lontitude":@"109.003011",@"shop":@"北辰大道加油站",@"image":@"oil7.jpg",@"address":@"北辰路与红旗路交汇向北250米路东 "},@{@"latitude":@"34.236141",@"lontitude":@"108.998067",@"shop":@"铁炉庙加油站",@"image":@"oil8.jpg",@"address":@"西影路铁炉庙二村"},@{@"latitude":@",34.43544",@"lontitude":@"109.27144",@"shop":@"加油站(临潼区机筑小学南)",@"image":@"oil11.jpg",@"address":@"西安市临潼区老街附近"},@{@"latitude":@",34.490515",@"lontitude":@"109.006323",@"shop":@"高陵区中联通化加油站",@"image":@"oil10.jpg",@"address":@"西安市高陵区泾高南路"},@{@"latitude":@"34.260118",@"lontitude":@"108.804476",@"shop":@"中国石化(恒瑞加油站)",@"image":@"oil8.jpg",@"address":@"108国道附近"},@{@"latitude":@"34.187762",@"lontitude":@"108.913801",@"shop":@"中国石化(雁协加油站)",@"image":@"oil6.jpg",@"address":@"雁环路子午大道与雁环路十字东南角 "},@{@"latitude":@"34.548428",@"lontitude":@"109.005421",@"shop":@"中国石化(张市加油站)",@"image":@"oil4.jpg",@"address":@"高泾路与高韩路路口"},@{@"latitude":@"34.083674",@"lontitude":@"109.10493",@"shop":@"中国石化(长虹加油站)",@"image":@"oil2.jpg",@"address":@"雁引路北留村(引镇粮站职工家属楼西北)"},@{@"latitude":@"34.378169",@"lontitude":@"108.966335",@"shop":@"中国石化(永通加油站)",@"image":@"oil11.jpg",@"address":@"西安市未央区G65W延西高速"},@{@"latitude":@"34.513916",@"lontitude":@"109.089073",@"shop":@"中国石化",@"image":@"oil9.jpg",@"address":@"西安市高陵县"},@{@"latitude":@"34.265162",@"lontitude":@"108.849537",@"shop":@"中国石化",@"image":@"oil7.jpg",@"address":@"西安市未央区"},@{@"latitude":@"34.121356",@"lontitude":@"109.074904",@"shop":@"加油站(留村)",@"image":@"oil1.jpg",@"address":@"陕西省西安市长安区雁引路近东戊店 "},@{@"latitude":@"34.305595",@"lontitude":@"108.819999",@"shop":@"纪元加油站",@"image":@"oil3.jpg",@"address":@"312国道(启航时代广场对面) "},@{@"latitude":@"34.106176",@"lontitude":@"109.018001",@"shop":@"中国石化杜曲石化加油站",@"image":@"oil5.jpg",@"address":@"杜曲东街"},@{@"latitude":@"34.22423",@"lontitude":@"108.879173",@"shop":@"中国石化西安宏宝加油站",@"image":@"oil11.jpg",@"address":@"丈八北路192号"},@{@"latitude":@"34.304131",@"lontitude":@"109.001429",@"shop":@"中国石化西安东元加油站",@"image":@"oil10.jpg",@"address":@"东元路88号附近"},@{@"latitude":@"34.40443",@"lontitude":@"109.11196",@"shop":@"加油站",@"image":@"oil9.jpg",@"address":@"陕西省西安市灞桥区210国道(宋家滩西方西韩街) "},@{@"latitude":@"34.313412",@"lontitude":@"108.848045",@"shop":@"加油站",@"image":@"oil8.jpg",@"address":@"建章路166号"},@{@"latitude":@"34.406466",@"lontitude":@"109.089932",@"shop":@"草临路加油站",@"image":@"oil7.jpg",@"address":@"陕西省西安市灞桥区325县道(罗百寨)"},@{@"latitude":@"34.092831",@"lontitude":@"108.610206",@"shop":@"中润加油站",@"image":@"oil1.jpg",@"address":@"甘亭镇尧西村东 "},@{@"latitude":@"34.069579",@"lontitude":@"109.248194",@"shop":@"丰源加油站",@"image":@"oil3.jpg",@"address":@"焦贷税务所对面"},@{@"latitude":@"34.26545",@"lontitude":@"108.835993",@"shop":@"加油站(红光路)",@"image":@"oil5.jpg",@"address":@"红光路与和平工业园二号路交汇向东30米"},@{@"latitude":@"34.160657",@"lontitude":@"108.467639",@"shop":@"加油站(尚村邮政支局西)",@"image":@"oil1.jpg",@"address":@"310国道"},@{@"latitude":@"34.513233",@"lontitude":@"109.088631",@"shop":@"中国石化(高陵聘欣加油站)",@"image":@"oil2.jpg",@"address":@"榆楚镇205县道耿家附近"},@{@"latitude":@"34.295649",@"lontitude":@"108.866912",@"shop":@"中石化未央服务区加油站(南)",@"image":@"oil6.jpg",@"address":@"陕西省西安市未央区西快速干道"},@{@"latitude":@"34.080731",@"lontitude":@"108.326964",@"shop":@"加油站(周至县楼观镇中心学校西南)",@"image":@"oil3.jpg",@"address":@"关中环线与太极路交汇处东50米路北"},@{@"latitude":@"34.186865",@"lontitude":@"108.953275",@"shop":@"加油站(启航029北)",@"image":@"oil4.jpg",@"address":@"西安市雁塔区长安南路57号"},@{@"latitude":@"34.220659",@"lontitude":@"109.013938",@"shop":@"中国石化西安雁翔路加油站",@"image":@"oil5.jpg",@"address":@"孟汗路附近"},@{@"latitude":@"34.621728",@"lontitude":@"109.395092",@"shop":@"中国石化新世纪加油站(北顺小学西)",@"image":@"oil8.jpg",@"address":@"西安市临潼区相桥镇08省道和107省道交叉口"},@{@"latitude":@"34.621777",@"lontitude":@"109.395337",@"shop":@"加油站(北顺小学西)",@"image":@"oil11.jpg",@"address":@"108省道和107省道的交叉口附近"},@{@"latitude":@"34.188895",@"lontitude":@"109.279067",@"shop":@"(洩湖服务区)加油站",@"image":@"oil1.jpg",@"address":@"沪陕高速十里铺村南方"},@{@"latitude":@"34.381925",@"lontitude":@"108.977338",@"shop":@"加油站(聚安盛都东北)",@"image":@"oil2.jpg",@"address":@"111县道(聚安盛都东北) "},@{@"latitude":@"34.267989",@"lontitude":@"108.831246",@"shop":@"加油站(聚家花园东北)",@"image":@"oil3.jpg",@"address":@"天台路与天台一路交汇向北60米"},@{@"latitude":@"34.32499",@"lontitude":@"109.118238",@"shop":@"中国石化加油站(铭枫健身俱乐部东南)",@"image":@"oil4.jpg",@"address":@"豁口立交与长平路交叉口东南100米"},@{@"latitude":@"34.268993",@"lontitude":@"109.126808",@"shop":@"(灞桥服务区)加油站",@"image":@"oil5.jpg",@"address":@"豁口立交与长平路交叉口东南100米"},@{@"latitude":@"34.28746",@"lontitude":@"108.863329",@"shop":@"加油站",@"image":@"oil6.jpg",@"address":@"枣园西路168号"},@{@"latitude":@"34.155278",@"lontitude":@"108.339495,34",@"shop":@"汇通加油站",@"image":@"oil7.jpg",@"address":@"310国道与220县道交叉处东方"},@{@"latitude":@"34.263476",@"lontitude":@"109.136891",@"shop":@"(灞桥服务区)加油站",@"image":@"oil8.jpg",@"address":@"灞桥服务区附近"},@{@"latitude":@"34.029471",@"lontitude":@"108.609236",@"shop":@"加油站(九华山别苑东)",@"image":@"oil9.jpg",@"address":@"户电路与关中环线交汇向东550米"},@{@"latitude":@"34.177551",@"lontitude":@"108.966378",@"shop":@"中国石化西安航天大道加油站",@"image":@"oil10.jpg",@"address":@"西安市长安区航天大道286号"},@{@"latitude":@"34.643298",@"lontitude":@"109.315976",@"shop":@"中国石化通程加油站(中共武屯镇委员会东)",@"image":@"oil11.jpg",@"address":@"武屯镇街东107省道十字西南角"},@{@"latitude":@"34.328073",@"lontitude":@"108.869906",@"shop":@"中国石化(尤西路店)",@"image":@"oil10.jpg",@"address":@"邓六路黄家庄"},@{@"latitude":@"34.16697",@"lontitude":@"108.816154",@"shop":@"中国石化(红达加油站)",@"image":@"oil9.jpg",@"address":@"祝村乡309县道五四村附近"},@{@"latitude":@"34.224704",@"lontitude":@"108.850495",@"shop":@"西三环一站加油站",@"image":@"oil8.jpg",@"address":@"陕西省西安市雁塔区西三环路与鱼斗路交汇向南400米"},@{@"latitude":@"34.332443",@"lontitude":@"108.855234",@"shop":@"中国石化(六村堡医院东)",@"image":@"oil7.jpg",@"address":@"西三环与焦家村十字向北200米路东"},@{@"latitude":@"34.369234",@"lontitude":@"108.987327",@"shop":@"中国石化(北三环加油第1站)",@"image":@"oil6.jpg",@"address":@"太华北路北三环桥下西南角"},@{@"latitude":@"34.307531",@"lontitude":@"109.075477",@"shop":@"中国石化(千家喜购物广场东)",@"image":@"oil5.jpg",@"address":@"东城大道中段"},@{@"latitude":@"34.338121",@"lontitude":@"109.083573",@"shop":@"加油站(古都希望小学东北)",@"image":@"oil4.jpg",@"address":@"读书村北1公里(古都希望中心小学东北)"},@{@"latitude":@"34.171934",@"lontitude":@"108.163116",@"shop":@"城信加油站",@"image":@"oil3.jpg",@"address":@"四屯乡上三屯村东三一零国道北侧"},@{@"latitude":@"34.114938",@"lontitude":@"108.732031",@"shop":@"中国石化(西安医专附属医院西)",@"image":@"oil2.jpg",@"address":@"105县道附近"},@{@"latitude":@"34.265483",@"lontitude":@"109.145762",@"shop":@"加油站(西安市灞桥区燎原小学东南)",@"image":@"oil1.jpg",@"address":@"101省道东50米"},@{@"latitude":@"34.306305",@"lontitude":@"109.071191",@"shop":@"中国石化加油站(柳亭路)",@"image":@"oil11.jpg",@"address":@"陕西省西安市灞桥区东城大道与柳亭路交汇处"},@{@"latitude":@"34.547954",@"lontitude":@"109.103128",@"shop":@"高交路加油站",@"image":@"oil10.jpg",@"address":@"陕西省西安市高陵县高陵区210国道附近(高交路十字北50米)"},@{@"latitude":@"34.294299",@"lontitude":@"108.827376",@"shop":@"加油站(白云寺南)",@"image":@"oil9.jpg",@"address":@"三桥镇疏导路51号中段"},@{@"latitude":@"34.200692",@"lontitude":@"108.6497",@"shop":@"诚信石化加油站",@"image":@"oil8.jpg",@"address":@"交警大队大王中队东侧"},@{@"latitude":@"34.224743",@"lontitude":@"108.522469",@"shop":@"中国石化兴户路加油站",@"image":@"oil7.jpg",@"address":@"大张路"},@{@"latitude":@"34.129487",@"lontitude":@"108.793261",@"shop":@"陕西华兴宝塔石化加油站",@"image":@"oil11.jpg",@"address":@"兴隆街道安丰村五组"},@{@"latitude":@"34.643285",@"lontitude":@"109.315747",@"shop":@"中国石化通程加油站(中共武屯镇委员会东)",@"image":@"oil1.jpg",@"address":@"武屯镇街东107省道十字西南角"},@{@"latitude":@"34.049836",@"lontitude":@"108.823703",@"shop":@"红星石化加油站(紫薇山庄东北)",@"image":@"oil2.jpg",@"address":@"滦镇210国道陈村路段,路东"},@{@"latitude":@"34.295169",@"lontitude":@"109.112007",@"shop":@"中国石化(西安备战路加油加气站)",@"image":@"oil8.jpg",@"address":@"祥云路中段"},@{@"latitude":@"34.245596",@"lontitude":@"108.777518",@"shop":@"宝姜石化加油站",@"image":@"oil7.jpg",@"address":@"108国道附近"},@{@"latitude":@"34.11976",@"lontitude":@"108.666651",@"shop":@"吴家寨村南侧 ",@"image":@"oil6.jpg",@"address":@"环城北路加油站"},@{@"latitude":@"34.25756",@"lontitude":@"109.055834",@"shop":@"东大石化加油站 ",@"image":@"oil5.jpg",@"address":@"陕西省西安市灞桥区"},@{@"latitude":@"34.620015",@"lontitude":@"109.230917",@"shop":@"加油城(北屯卫生所东南) ",@"image":@"oil11.jpg",@"address":@"迎宾大道南段"},@{@"latitude":@"34.219682",@"lontitude":@"108.729418",@"shop":@"宝姜石化加油站(马王国土资源所东) ",@"image":@"oil3.jpg",@"address":@"108国道附近"},@{@"latitude":@"34.265845",@"lontitude":@"108.854777",@"shop":@"实佳石化",@"image":@"oil11.jpg",@"address":@"红光路西段8号(石家花园西)"},@{@"latitude":@"34.157143",@"lontitude":@"108.301062",@"shop":@"中航石化",@"image":@"oil10.jpg",@"address":@"108国道"},@{@"latitude":@"34.375821",@"lontitude":@"108.976188",@"shop":@"东升石化",@"image":@"oil5.jpg",@"address":@"陕西省西安市未央区x111"},@{@"latitude":@"34.292841",@"lontitude":@"108.855847",@"shop":@"西安鑫宇石化",@"image":@"oil3.jpg",@"address":@"陕西省西安市未央区三桥路12号"},@{@"latitude":@"34.155169",@"lontitude":@"108.948342",@"shop":@"胜东石化",@"image":@"oil8.jpg",@"address":@"陕西省西安市长安区皂河路"},@{@"latitude":@"34.302098",@"lontitude":@"108.929579",@"shop":@"西深石化朱宏路加油站",@"image":@"oil7.jpg",@"address":@"西安未央区朱宏路11号"},@{@"latitude":@"34.164844",@"lontitude":@"109.411123",@"shop":@"中国石油化工股份有限公司石油分公司...",@"image":@"oil11.jpg",@"address":@"101省道"}];
    
    
    
    [self locService];
    
   // [self.mapView showsUserLocation];
    // 显示地图
    [self.view addSubview:self.mapView];
    //地图拉回到坐标所在位置
    
    
    topViw=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
    topViw.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:topViw];
    
    NSArray *oilKind=@[@"95#",@"92#",@"柴油"];
    
    for (int i=0; i<3; i++) {
        UIButton *oilKindButton=[UIButton buttonWithType:UIButtonTypeCustom];
        oilKindButton.tag=i;
        oilKindButton.frame=CGRectMake((SCREENWIDTH-300)/4+i%3*(100+(SCREENWIDTH-300)/4), 11, 100, 28);
        oilKindButton.titleLabel.font=[UIFont systemFontOfSize:14.0f];
        oilKindButton.layer.cornerRadius=14.0f;
        oilKindButton.clipsToBounds=YES;
        [oilKindButton setTitle:oilKind[i] forState:UIControlStateNormal];
        if (i==0) {
             [oilKindButton setBackgroundColor:RGB(192, 192, 192)];
            [oilKindButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            [oilKindButton setBackgroundColor:[UIColor whiteColor]];
            [oilKindButton setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        }
       
        [topViw addSubview:oilKindButton];
        [oilKindButton addTarget:self action:@selector(chooseOilKindBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    //一键加油
    UIView *oneKeyOil=[[UIView alloc ]initWithFrame:CGRectMake(SCREENWIDTH/2-156, SCREENHEIGHT-64-54, 136, 44)];
    oneKeyOil.backgroundColor=RGB(243, 73, 78);
    oneKeyOil.layer.cornerRadius=22.0f;
    oneKeyOil.clipsToBounds=YES;
    [self.view addSubview:oneKeyOil];
    
    UIImageView *letfImage=[[UIImageView alloc]initWithFrame:CGRectMake(25, 12, 20, 20)];
    letfImage.image=[UIImage imageNamed:@"一件加油icon"];
    letfImage.userInteractionEnabled=YES;
    [oneKeyOil addSubview:letfImage];
    
    UILabel *leftLab=[[UILabel alloc]initWithFrame:CGRectMake(letfImage.right+10, 15, oneKeyOil.width-letfImage.right-10, 14) ];
    leftLab.font=[UIFont systemFontOfSize:14];
    leftLab.text=@"一键加油";
    leftLab.userInteractionEnabled=YES;
    leftLab.textColor=[UIColor whiteColor];
    [oneKeyOil addSubview:leftLab];
    
    UITapGestureRecognizer *tap1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(oneKeyOilBtnClicks:)];
    
    [oneKeyOil addGestureRecognizer:tap1];
    
    
    //购买加油卡
    UIView *buyOilCard=[[UIView alloc ]initWithFrame:CGRectMake(SCREENWIDTH/2+20, SCREENHEIGHT-64-54, 136, 44)];
    buyOilCard.backgroundColor=RGB(243, 73, 78);
    buyOilCard.layer.cornerRadius=22.0f;
    buyOilCard.clipsToBounds=YES;
    [self.view addSubview:buyOilCard];
    
    UIImageView *rightImage=[[UIImageView alloc]initWithFrame:CGRectMake(18, 12, 20, 20)];
    rightImage.image=[UIImage imageNamed:@"购买加油卡icon"];
    rightImage.userInteractionEnabled=YES;
    [buyOilCard addSubview:rightImage];
    
    UILabel *rightLab=[[UILabel alloc]initWithFrame:CGRectMake(rightImage.right+10, 15, buyOilCard.width-rightImage.right-10, 14) ];
    rightLab.userInteractionEnabled=YES;
    rightLab.font=[UIFont systemFontOfSize:14];
    rightLab.text=@"购买加油卡";
    rightLab.textColor=[UIColor whiteColor];
    [buyOilCard addSubview:rightLab];
    
    
    UITapGestureRecognizer *tap2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buyOilCardsBtnClick:)];
    [buyOilCard addGestureRecognizer:tap2];
    
    
    NSArray *mapRelationImage=@[@"刷新",@"放大A",@"位置矫正",@"缩小"];
    
    for (int i=0; i<4; i++) {
        UIButton *mapRelationButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [mapRelationButton setImage:[UIImage imageNamed:mapRelationImage[i]] forState:UIControlStateNormal];
        mapRelationButton.frame=CGRectMake(13+i%2*(SCREENWIDTH-82+28),oneKeyOil.top-92+i/2*(28+15), 28, 28);
        mapRelationButton.tag=i;
        [self.view addSubview:mapRelationButton];
        [mapRelationButton addTarget:self action:@selector(mapRelationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
   
   
}
-(void)creatShopDetailView{
    //屏幕弹出部分
    UIWindow *window =[UIApplication sharedApplication].keyWindow;
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    _scrollView.backgroundColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:0.2];
    _scrollView.pagingEnabled=YES;
    _scrollView.showsVerticalScrollIndicator=NO;
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.contentSize=CGSizeMake(SCREENWIDTH*locationArr.count, SCREENHEIGHT);
    _scrollView.hidden=YES;
    [window addSubview:_scrollView];
    
    UITapGestureRecognizer *scrTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrTapClick:)];
    [_scrollView addGestureRecognizer:scrTap];
    
    
    for (int i=0; i<locationArr.count; i++) {
        UIView *whiteView=[[UIView alloc]initWithFrame:CGRectMake(25+i*SCREENWIDTH, 106, SCREENWIDTH-50, 422)];
        whiteView.tag=i;
        whiteView.backgroundColor=[UIColor whiteColor];
        whiteView.layer.cornerRadius=12.0f;
        whiteView.clipsToBounds=YES;
        [_scrollView addSubview:whiteView];
        
        UILabel *shopName=[[UILabel alloc]initWithFrame:CGRectMake(16, 0, whiteView.width-16, 44)];
        shopName.text=locationArr[i][@"shop"];
        shopName.font=[UIFont systemFontOfSize:15];
        shopName.textColor=RGB(51, 51, 51);
        [whiteView addSubview:shopName];
        
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, shopName.bottom, whiteView.width, 1)];
        line.backgroundColor=RGB(192, 192, 192);
        [whiteView addSubview:line];
        
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, line.bottom, whiteView.width, 270)];
        imageView.image=[UIImage imageNamed:locationArr[i][@"image"]];
        [whiteView addSubview:imageView];
        
        UIView *addressView=[[UIView alloc]initWithFrame:CGRectMake(0, imageView.bottom-44, imageView.width, 44)];
        addressView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.749];
        [whiteView addSubview:addressView];
        
        UIImageView *addtip=[[UIImageView alloc]initWithFrame:CGRectMake(16, 15, 14, 14)];
        addtip.image=[UIImage imageNamed:@"定位icon"];
        [addressView addSubview:addtip];
        
        UILabel *addtressLable=[[UILabel alloc]initWithFrame:CGRectMake(38, 0, addressView.width-38, 44)];
        addtressLable.font=[UIFont systemFontOfSize:13];
        addtressLable.textColor=[UIColor whiteColor];
        addtressLable.text=locationArr[i][@"address"];
        [addressView addSubview:addtressLable];
        
        NSArray *oilKindArr=@[@"95#",@"92#",@"柴油"];
        NSArray *oilPriceArr=@[@"6.24元／升",@"5.90元／升",@"5.50元／升"];
        for (int j=0; j<3; j++) {
            UILabel *oilKind=[[UILabel alloc]initWithFrame:CGRectMake(j*addressView.width/3, addressView.bottom, SCREENWIDTH/3, 32)];
            oilKind.textColor=RGB(51, 51, 51);
            oilKind.textAlignment=NSTextAlignmentCenter;
            oilKind.font=[UIFont systemFontOfSize:14];
            oilKind.text=oilKindArr[j];
            [whiteView addSubview:oilKind];
            
            UILabel *oilPriceLable=[[UILabel alloc]initWithFrame:CGRectMake(j*addressView.width/3, oilKind.bottom, SCREENWIDTH/3, 32)];
            oilPriceLable.font=[UIFont systemFontOfSize:14];
            oilPriceLable.text=oilPriceArr[j];
            oilPriceLable.textAlignment=NSTextAlignmentCenter;
            oilPriceLable.textColor=RGB(51, 51, 51);
            [whiteView addSubview:oilPriceLable];
        }
        UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0,whiteView.height-45 ,whiteView.width , 1)];
        line2.backgroundColor=RGB(192, 192, 192);
        [whiteView addSubview:line2];
        NSArray *buttonTitle=@[@"更换加油站",@"直接加油"];
        for (int k=0; k<2; k++) {
            UIButton *otherButton=[UIButton buttonWithType:UIButtonTypeCustom];
            otherButton.frame=CGRectMake(1+k*((whiteView.width-3)/2+1), line2.bottom, (whiteView.width-3)/2, 43);
            otherButton.titleLabel.font=[UIFont systemFontOfSize:14];
            [otherButton setTitle:buttonTitle[k] forState:UIControlStateNormal];
            if (k==0) {
                [otherButton setTitleColor:RGB(143, 143, 143) forState:UIControlStateNormal];
                UIView *seperateLine=[[UIView alloc]initWithFrame:CGRectMake(otherButton.right, line2.bottom, 1, 43)];
                seperateLine.backgroundColor=RGB(192, 192, 192);
                [whiteView addSubview:seperateLine];
            }else{
                [otherButton setTitleColor:RGB(243, 73, 78) forState:UIControlStateNormal];
            }
            otherButton.tag=k;
            [otherButton addTarget:self action:@selector(otherBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [whiteView addSubview:otherButton];
        }
    }
    
    //屏幕弹出部分
}
-(void)otherBtnClick:(UIButton *)sender{
    switch (sender.tag) {
        case 0:
        {
            //
            UIView *superView=[sender superview];
            if (superView.tag==locationArr.count-1) {
                [_scrollView setContentOffset:CGPointMake(0, 0)];
            }else{
                [_scrollView setContentOffset:CGPointMake((superView.tag+1)*SCREENWIDTH, 0)];
            }
            
        }
            break;
        case 1:
        {
            //
            _scrollView.hidden=YES;
            OneKeyOilVC *vc=[[OneKeyOilVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}
//_scollview
-(void)scrTapClick:(UITapGestureRecognizer *)tap{
    _scrollView.hidden=YES;
    [_scrollView setContentOffset:CGPointMake(0, 0)];
}
//
-(void)chooseOilKindBtnClick:(UIButton *)sender{
    for (UIButton *button in topViw.subviews) {
        if (button.tag==sender.tag) {
            button.backgroundColor=RGB(192, 192, 192);
            [button setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
        }else{
            button.backgroundColor=RGB(255, 255, 255);
            [button setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        }
    }
}

- (BMKLocationService *)locService {
    if (_locService == nil) {
        _locService = [[BMKLocationService alloc]init];
        _locService.distanceFilter = 200.f;
        _locService.delegate = self;
        [_locService setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        [_locService startUserLocationService];
        // 后台也定位 并且屏幕上方有蓝条提示
        //_locService.allowsBackgroundLocationUpdates = YES;
    }else{
        
        BaiduMapManager *manager = [BaiduMapManager shareBaiduMapManager];
        
        [manager startUserLocationService];
        
        manager.userLocationBlock = ^(BMKUserLocation *location) {
          
            [self didUpdateBMKUserLocation:location];
            
            
        };
        
//        [_locService startUserLocationService];
    }
    //启动LocationService
    NSLog(@"_locService==================%@",_locService);
    return _locService;
}
//实现相关delegate 处理位置信息更新
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    
    NSLog(@"userLocation=============%@",userLocation);

    
    CLLocationCoordinate2D locss = {userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
    userLoc=locss;
    [self.mapView setCenterCoordinate:locss];
    // 1.显示用户位置
    self.mapView.showsUserLocation = YES;//34.239566//108.873341//34.24356//108.874781//34.243414//108.875266// latitude = "34.239771";
    //longtitude = "108.876793";
    // 2.更新用户最新位置到地图上
    [self.mapView updateLocationData:userLocation];
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    appdelegate.userLocation = userLocation;
    // 3.设置中心 为 用户位置
    //CLLocationCoordinate2D loc = {_latitude, _longitude};
    CLLocationCoordinate2D center = locss;
    CLLocationDegrees latitude = 0.0;
    CLLocationDegrees longitude = 0.09;
    // 4.设置跨度 数值越小 越精确
    BMKCoordinateSpan span = BMKCoordinateSpanMake(latitude, longitude);
    // 5.设置区域 中心店 和 范围跨度
    BMKCoordinateRegion region = BMKCoordinateRegionMake(center, span);
    
    // 设置地图显示区域范围
    [self.mapView setRegion:region animated:YES];
    [self.mapView setZoomLevel:15];
}
#pragma mark - 地图功能-------------------------------------------
- (BMKMapView *)mapView {
    if (_mapView == nil) {
        _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
        _mapView.userTrackingMode=BMKUserTrackingModeFollowWithHeading;
    }
    return _mapView;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mapView viewWillAppear];
    self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    self.mapView.userInteractionEnabled=YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    _scrollView.hidden=YES;
    [_scrollView removeFromSuperview];
    [super viewWillAppear:animated];
    onlyOnce=YES;
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil; // 不用时，置nil
}
- (void)viewDidAppear:(BOOL)animated {
    if (onlyOnce==NO) {
        for (int i=0; i<locationArr.count; i++) {
            NSLog(@"latitude = %@,longitude = %@",[NSString stringWithFormat:@"%.2f",_latitude],[NSString stringWithFormat:@"%.2f",_longitude]);
            EricAnnotition* annotation = [[EricAnnotition alloc]init];
            CLLocationCoordinate2D coor; // 定义模型经纬度
            coor.latitude = [locationArr[i][@"latitude"] floatValue];//[NSString stringWithFormat:@"%@",@"34.239566"];
            _latitude=[locationArr[i][@"latitude"] floatValue];
            coor.longitude =[locationArr[i][@"lontitude"] floatValue];
            _longitude=[locationArr[i][@"lontitude"] floatValue];
            annotation.coordinate = coor;
            annotation.identify=i;
            //annotation.title = @"这里是北京";
            [_mapView addAnnotation:annotation];
        }

    }
    
     [self creatShopDetailView];
    
}
//  Override每当添加一个大头针就会调用这个方法(对大头针没有进行封装)
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {

    // 这里的BMKAnnotationView 就相当于是UITableViewCell一样 其实就是一个View我们也是通过复用的样子一样进行使用。 而传进来的annotation 就是一个模型，它里面装的全都是数据！
    if ([annotation isKindOfClass:[EricAnnotition class]]) {
        // 如果大头针类型 是我们自定义的百度的 而且是后加的大头针模型类 的话 才执行
        static NSString *const ID = @"myAnnotation";
        BMKPinAnnotationView *newAnnotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
        CLLocationCoordinate2D coor2 = {_latitude, _longitude};
        annotation.coordinate = coor2;
        if (newAnnotationView == nil) {
            newAnnotationView =  [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ID];
        }
        newAnnotationView.userInteractionEnabled=YES;
        newAnnotationView.enabled=YES;
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        //newAnnotationView.animatesDrop = YES; // 设置该标注点动画显示
        newAnnotationView.image = [UIImage imageNamed:@"油站图标"];
        
        
        EricAnnotition *annotition=annotation;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(0, 0,newAnnotationView.image.size.width, newAnnotationView.image.size.height);
        btn.tag=annotition.identify;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [newAnnotationView addSubview:btn];
        
        return newAnnotationView;
    }
    // 这里是说定位自己本身的那个大头针模型 返回nil 自动就变成蓝色点点
    return nil;
}
//点击你的location时调用
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    NSLog(@"123456789");
    if ([view.annotation isKindOfClass:[EricAnnotition class]]) {
        
        EricAnnotition *annotition=view.annotation;
        NSLog(@"%ld",(long)annotition.identify);
        
        
    }
}
//点大头时调用
-(void)btnAction:(UIButton *)sender{
    NSLog(@"%ld",sender.tag);
    [_scrollView setContentOffset:CGPointMake(sender.tag*SCREENWIDTH, 0)];
//    _scrollView.frame=CGRectMake((SCREENWIDTH-50)/2, (SCREENHEIGHT-50)/2, 50, 50);
    _scrollView.hidden=NO;
//    [UIView animateWithDuration:0.5 animations:^{
//        _scrollView.frame=CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
//    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
