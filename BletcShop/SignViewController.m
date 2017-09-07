//
//  SignViewController.m
//  BletcShop
//
//  Created by Bletc on 2017/9/7.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "SignViewController.h"

@interface SignViewController ()
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UILabel *resultlab;

@end

@implementation SignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textField.text = [NSString getRandomCode];

}
- (IBAction)clickBtn:(UIButton *)sender {
    
    NSString *url = [NSString stringWithFormat:@"%@Extra/index/signTest",BASEURL];
    
    NSString *randCode =self.textField.text;
    NSString *timestap = [NSString getCurrentTimestamp];
    
    
    NSMutableDictionary*paramer = [NSMutableDictionary dictionary];
    [paramer setValue:randCode forKey:@"randCode"];
    [paramer setValue:timestap forKey:@"timestap"];
    [paramer setValue:[NSString getSecretStringWithRandCode:randCode andTimestamp:timestap] forKey:@"sign"];

    NSLog(@"==%@==%@",paramer,url);
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"=====%@",result);
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}



@end
