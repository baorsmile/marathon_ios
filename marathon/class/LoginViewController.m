//
//  LoginViewController.m
//  marathon
//
//  Created by Ryan on 13-10-11.
//  Copyright (c) 2013年 Ryan. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property (nonatomic, strong) UITextField *codeField;

@end

@implementation LoginViewController
@synthesize codeField;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = BASE_PAGE_BG_COLOR;

    UIImageView *backView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backView.contentMode = UIViewContentModeScaleAspectFill;
    backView.image = [UIImage imageNamed:@"login_bg"];
    [self.view addSubview:backView];
    
    UIImageView *passView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 160, 229, 75)];
    passView.image = [UIImage imageNamed:@"password"];
    [self.view addSubview:passView];
    
    self.codeField = [[UITextField alloc] initWithFrame:passView.bounds];
    codeField.backgroundColor = [UIColor clearColor];
    codeField.textAlignment = NSTextAlignmentCenter;
    codeField.textColor = [UIColor whiteColor];
    codeField.delegate = self;
    codeField.font = HEI_(26);
    codeField.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:codeField];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(264, 174, 46, 46);
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"code"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submit_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Method
- (void)submit_click:(id)sender{
    NSString *code = codeField.text;
    NSString *loginStr = kLoginURL(code);
    
    [[MMProgressHUD sharedHUD] setOverlayMode:MMProgressHUDWindowOverlayModeGradient];
    [MMProgressHUD setDisplayStyle:MMProgressHUDDisplayStylePlain];
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleExpand];
    
    [MMProgressHUD showWithTitle:nil status:@"登录中..."];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:loginStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject == nil || [[responseObject objectForKey:@"result"] intValue] == 0 ) {
            // 操作错误
            
            return;
        }
        
        NSDictionary *dataDic = [responseObject objectForKey:@"data"];
        if (dataDic && [dataDic count] > 0) {
            [codeField resignFirstResponder];
            [MMProgressHUD dismissWithSuccess:@"登录成功"];
            if (delegate && [delegate respondsToSelector:@selector(loginSuccess)]) {
                [delegate loginSuccess];
            }
            
            [PersistenceHelper setData:code forKey:INVITECODE];
            kAppDelegate.code = code;
        }else{
            [MMProgressHUD dismissWithError:@"登录失败"];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // 网络连接失败
        [MMProgressHUD dismissWithError:@"网络出错"];
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self submit_click:nil];
    return YES;
}
@end
