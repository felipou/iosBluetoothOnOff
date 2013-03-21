//
//  ViewController.m
//  BluetoothManager
//
//  Created by Felipe Machado on 21/03/13.
//  Copyright (c) 2013 Felipe Machado. All rights reserved.
//

#import "ViewController.h"
#import "BluetoothManager.h"

@interface ViewController ()

@property (strong, nonatomic) BluetoothManager *bluetoothManager;
@property (weak, nonatomic) IBOutlet UIButton *onoffButton;
@property (weak, nonatomic) IBOutlet UILabel *onoffLabel;
@property (weak, nonatomic) IBOutlet UISwitch *onlaunchSwitch;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.bluetoothManager = [BluetoothManager sharedInstance];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    //[nc addObserver:self selector:@selector(bluetoothAvailableChange:) name:@"BluetoothConnectionStatusChangedNotification" object:nil];
    //[nc addObserver:self selector:@selector(deviceDisconnection:) name:@"BluetoothDeviceDisconnectSuccessNotification" object:nil];
    //[nc addObserver:self selector:@selector(deviceConnection:) name:@"BluetoothDeviceConnectSuccessNotification" object:nil];
    
    [nc addObserver:self selector:@selector(bluetoothStateChange:) name:@"BluetoothPowerChangedNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillAppear:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateBluetoothState) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(updateBluetoothState) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(updateBluetoothState) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:3.5 target:self selector:@selector(updateBluetoothState) userInfo:nil repeats:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self updateBluetoothState];
    
    BOOL switchOnLaunch = [[NSUserDefaults standardUserDefaults] boolForKey:@"switchOnLaunch"];
    
    if (switchOnLaunch) {
        [self toggleBluetoothState];
    }
    
    [self.onlaunchSwitch setOn:switchOnLaunch animated:NO];
}

- (void)updateBluetoothState {
    if([self.bluetoothManager enabled]) {
        [self.onoffButton setImage:[UIImage imageNamed:@"button-blue.png"] forState:UIControlStateNormal];
        self.onoffLabel.text = @"ON";
    } else {
        [self.onoffButton setImage:[UIImage imageNamed:@"button-red.png"] forState:UIControlStateNormal];
        self.onoffLabel.text = @"OFF";
    }
}

/*
-(void)connectedDevice {
    Class BluetoothDevice = objc_getClass("BluetoothDevice");
    NSArray *devices = [self.btCont connectedDevices];
    if ([devices count] != 0) {
        device = [devices objectAtIndex:0];
        NSLog(@"Device is:%@",device );
        [connectedDeviceLabel setText:[device name]];
    }
}

-(void)deviceConnection:(NSNotification *)notification {
    NSLog(@"Got a device Connect notification");
    [self connectedDevice];
}

-(void)deviceDisconnection:(NSNotification *)notification {
    NSLog(@"Got a device disconnect notification");
    //[connectedDeviceLabel setText:@"No Device Connected"];
}

-(void)bluetoothAvailableChange:(NSNotification *)notification {
    //NSLog(@"Got an availability change");
    //[self showBTStatus];
}
 */

-(void)bluetoothStateChange:(NSNotification *)notification {
    [self updateBluetoothState];
}

- (void)toggleBluetoothState {
    BOOL isEnabled = [self.bluetoothManager enabled];
    
    [self.bluetoothManager setPowered:!isEnabled];
    [self.bluetoothManager setEnabled:!isEnabled];
}

- (IBAction)onoffButtonPressed:(id)sender {
    [self toggleBluetoothState];
}

- (IBAction)switchChanged:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:self.onlaunchSwitch.on forKey:@"switchOnLaunch"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
