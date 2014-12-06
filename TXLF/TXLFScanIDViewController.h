//
//  TXLFScanIDViewController.h
//  TXLF
//
//  Created by George Nixon on 3/23/14.
//  Copyright (c) 2014 Texas Linux Fest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface TXLFScanIDViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) IBOutlet UIView* scanPreview;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;


-(IBAction)startStopReading:(id)sender;
-(BOOL)startReading;
-(void)stopReading;
@end