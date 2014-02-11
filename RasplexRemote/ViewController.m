//
//  ViewController.m
//  RasplexRemote
//
//  Created by Daniele Rossetti on 14/11/13.
//  Copyright (c) 2013 Daniele Rossetti. All rights reserved.
//

#import "ViewController.h"
#import "JsonRPCClient.h"
#import "UIViewController+CWStatusBarNotification.h"
#import "JsonRPCClientDelegate.h"
#import "IonIcons.h"
#import "SettingsTVC.h"
@interface ViewController ()<NSURLSessionDelegate,JsonRPCClientDelegate>
@property(nonatomic,strong) JsonRPCClient* client;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *fastForwardButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *rewindButton;
@property (weak, nonatomic) IBOutlet UIButton *bigStepBackButton;
@property (weak, nonatomic) IBOutlet UIButton *stepBackButton;
@property (weak, nonatomic) IBOutlet UIButton *stepForwardButton;
@property (weak, nonatomic) IBOutlet UIButton *bigStepForwardButton;
@property (weak, nonatomic) IBOutlet UIButton *upButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *downButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@end

@implementation ViewController

-(void)viewDidLoad{
    [self updateUI];
}

- (void) updateUI{
    self.view.tintColor = [UIColor orangeColor];
    self.statusBarNotificationLabel.textColor = [UIColor whiteColor];
    self.statusBarNotificationLabel.backgroundColor = self.view.tintColor;
    [self setIonIcon:icon_play forButton:self.playButton];
    [self setIonIcon:icon_ios7_fastforward forButton:self.fastForwardButton];
    [self setIonIcon:icon_stop forButton:self.stopButton];
    [self setIonIcon:icon_ios7_rewind forButton:self.rewindButton];
    [self setIonIcon:icon_skip_backward forButton:self.bigStepBackButton];
    [self setIonIcon:icon_ios7_skipbackward forButton:self.stepBackButton];
    [self setIonIcon:icon_ios7_skipforward forButton:self.stepForwardButton];
    [self setIonIcon:icon_skip_forward forButton:self.bigStepForwardButton];
    [self setIonIcon:icon_arrow_up_c forButton:self.upButton];
    [self setIonIcon:icon_arrow_right_c forButton:self.rightButton];
    [self setIonIcon:icon_arrow_left_c forButton:self.leftButton];
    [self setIonIcon:icon_arrow_down_c forButton:self.downButton];
    [self setIonIcon:icon_ios7_arrow_back forButton:self.backButton];
    [self setIonIcon:icon_navicon_round forButton:self.menuButton];
    [self setIonIcon:icon_ionic forButton:self.okButton];
    
}
-(void) setIonIcon:(NSString*)ionicon forButton:(UIButton*)button{
    [button setImage:[IonIcons imageWithIcon:ionicon size:40.0f color:self.view.tintColor]
                     forState:UIControlStateNormal];
}
- (JsonRPCClient*) client{
    if (!_client) _client = [[JsonRPCClient alloc] initWithDelegate:self];
    return _client;
}
- (void) messageFail{
    self.statusBarNotificationLabel.backgroundColor = [UIColor redColor];
    [self showStatusBarNotification:@"Error" forDuration:1.0f];
}

- (IBAction)okPressed {
    [self.client ok];
}
- (IBAction)rightPressed {
    [self.client right];
}
- (IBAction)downPressed {
    [self.client down];
}
- (IBAction)upPressed {
    [self.client up];
}
- (IBAction)leftPressed {
    [self.client left];
}
- (IBAction)backPressed {
    [self.client back];
}
- (IBAction)volumeChanged:(UISlider*)sender {
    [self.client setVolume:round(sender.value)];
}
- (IBAction)biStepForwardPressed {
    [self.client bigStepForward];
}
- (IBAction)stepForwardPressed {
    [self.client stepForward];
}
- (IBAction)stepBackwardPressed {
    [self.client stepBack];
}
- (IBAction)bigStepBackwardPressed {
    [self.client bigStepBack];
}
- (IBAction)stopPressed {
    [self.client stop];
}
- (IBAction)fastForwardPressed {
    [self.client fastForward];
}
- (IBAction)rewindPressed {
    [self.client rewind];
}
- (IBAction)toggleMenuPressed {
    [self.client toggleMenu];
}

- (IBAction)playPressed:(id)sender {
    [self.client play];
}



@end
