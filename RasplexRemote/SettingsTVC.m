//
//  SettingsTVC.m
//  RaspmsRemote
//
//  Created by Daniele Rossetti on 15/11/13.
//  Copyright (c) 2013 Daniele Rossetti. All rights reserved.
//

#import "SettingsTVC.h"
#include <NMSSH/NMSSH.h>

@interface SettingsTVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *hostTextField;
@property (weak, nonatomic) IBOutlet UITextField *portTextField;
@property (weak, nonatomic) IBOutlet UITextField *vpsHostTextField;
@property (weak, nonatomic) IBOutlet UISwitch *pmsSwitch;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *pmsLoading;
@property (weak, nonatomic) IBOutlet UISwitch *transmissionSwitch;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *transmissionLoading;
@property (strong, nonatomic) NMSSHSession *session;
@property (nonatomic) BOOL online;
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *reloadButton;


@end


@implementation SettingsTVC

- (void)viewDidLoad{
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    dispatch_queue_t myQueue = dispatch_queue_create("my-queue", NULL);
    dispatch_async(myQueue, ^{
        self.session = [NMSSHSession connectToHost:@"vps.danielerossetti.com"
                                      withUsername:@"root"];
        if (self.session.isConnected) {
            [self.session authenticateByPassword:@"L0nd0n1989"];
            
            if (self.session.isAuthorized) {
                NSLog(@"Authentication succeeded");
                self.online = YES;
                [self fetchInfo];
            }else{
                [[[UIAlertView alloc] initWithTitle:@"Errore" message:@"Errore login" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
            }
        }else{
            [[[UIAlertView alloc] initWithTitle:@"Errore" message:@"Errore di connessione" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        }
    });
}
- (void)dismissKeyboard{
    [self.view endEditing:YES];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

- (IBAction)pmsSwitched:(UISwitch *)sender {
    NSError *error = nil;
    NSString *response;
    BOOL setOn = sender.isOn;
    self.pmsSwitch.hidden = YES;
    [self.pmsLoading startAnimating];
    if (setOn){
        response = [self.session.channel execute:@"service pmsmediaserver start" error:&error];
    }  else{
        response = [self.session.channel execute:@"service pmsmediaserver stop" error:&error];
    }
    if (error || (setOn && [response rangeOfString:@"start"].location == NSNotFound)
        || (!setOn && [response rangeOfString:@"stop"].location == NSNotFound)){
        [[[UIAlertView alloc] initWithTitle:@"Errore" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        self.pmsSwitch.on = !self.pmsSwitch.isOn;
    }
    self.pmsSwitch.hidden = NO;
    [self.pmsLoading stopAnimating];
}

- (IBAction)transmissionSwitched:(UISwitch *)sender {
    NSError *error = nil;
    NSString *response;
    BOOL setOn = sender.isOn;
    self.transmissionSwitch.hidden = YES;
    [self.transmissionLoading startAnimating];
    if (setOn){
        response = [self.session.channel execute:@"service transmission-daemon start" error:&error];
    }  else{
        response = [self.session.channel execute:@"service transmission-daemon stop" error:&error];
    }
    if (error || (setOn && [response rangeOfString:@"start"].location == NSNotFound)
        || (!setOn && [response rangeOfString:@"stop"].location == NSNotFound)){
        [[[UIAlertView alloc] initWithTitle:@"Errore" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        self.transmissionSwitch.on = !self.transmissionSwitch.isOn;
    }
    self.transmissionSwitch.hidden = NO;
    [self.transmissionLoading stopAnimating];
    
}
- (IBAction)reload:(UIButton *)sender {
    sender.enabled = NO;
    self.transmissionSwitch.hidden = YES;
    self.pmsSwitch.hidden = YES;
    [self.transmissionLoading startAnimating];
    [self.pmsLoading startAnimating];
    dispatch_queue_t myQueue = dispatch_queue_create("my-queue", NULL);
    dispatch_async(myQueue, ^{
        [self fetchInfo];
    });
}

- (void) fetchInfo{
    [self fetchpmsInfo];
    [self fetchTransmissionInfo];
}

- (void) fetchTransmissionInfo{
    NSError *error = nil;
    NSString *response = [self.session.channel execute:@"service transmission-daemon status" error:&error];
    [self.transmissionLoading stopAnimating];
    if (!error) {
        if ([response rangeOfString:@"running"].location != NSNotFound){
            self.transmissionSwitch.on = YES;
        }else{
            self.transmissionSwitch.on = NO;
        }
        self.transmissionSwitch.hidden = NO;
    }else{
        [[[UIAlertView alloc] initWithTitle:@"Errore" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        self.transmissionSwitch.hidden = YES;
    }
    
    
}

- (void) fetchpmsInfo{
    NSError *error = nil;
    NSString *response = [self.session.channel execute:@"service pmsmediaserver status" error:&error];
    [self.pmsLoading stopAnimating];
    if (!error) {
        if ([response rangeOfString:@"running"].location != NSNotFound){
            self.pmsSwitch.on = YES;
        }else{
            self.pmsSwitch.on = NO;
        }
        self.pmsSwitch.hidden = NO;
        
    }else{
        [[[UIAlertView alloc] initWithTitle:@"Errore" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        self.transmissionSwitch.hidden = YES;
    }
}



@end
