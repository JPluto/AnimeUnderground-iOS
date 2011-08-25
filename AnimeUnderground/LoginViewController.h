//
//  LoginViewController.h
//  AnimeUnderground
//
//  Created by Francisco Soto Portillo on 25/08/11.
//  Copyright 2011 AUDev. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoginViewController : UIViewController {
    UITextField *usuario;
    UITextField *pass;
    UIButton *loginB;
    UIButton *registroB;
}

@property (nonatomic,retain) IBOutlet UITextField *usuario;
@property (nonatomic,retain) IBOutlet UITextField *pass;
@property (nonatomic,retain) IBOutlet UIButton *loginB;
@property (nonatomic,retain) IBOutlet UIButton *registroB;
-(IBAction) login;
-(IBAction) registrarse;
@end
