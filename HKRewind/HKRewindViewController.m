//
//  HKRewindViewController.m
//  HKRewind
//
//  Created by Panos Baroudjian on 7/3/13.
//  Copyright (c) 2013 Panos Baroudjian. All rights reserved.
//

#import "HKRewindViewController.h"
#import "HKRewindGestureRecognizer.h"
#import "HKRewindHUDView.h"

@interface HKRewindViewController ()

@property (nonatomic, strong) HKRewindHUDView *hudView;
@property (nonatomic, strong) UIView *centerView;

@end

@implementation HKRewindViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.hudView = [[HKRewindHUDView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    [self.view addSubview:self.hudView];
    self.hudView.textLabel.text = @"Rewind";
    self.hudView.detailLabel.text = @"...";
    HKRewindGestureRecognizer *recognizer = [[HKRewindGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognized:)];
    recognizer.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:recognizer];

    self.centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [self.view addSubview:self.centerView];
    self.centerView.backgroundColor = [UIColor redColor];
}

- (void)gestureRecognized:(HKRewindGestureRecognizer *)recognizer
{
//    NSLog(@"%@", recognizer);
    switch (recognizer.state) {
        case UIGestureRecognizerStateChanged:
            [self.hudView addProgression:recognizer.rotationDelta];
            self.centerView.frame = CGRectMake(recognizer.center.x, recognizer.center.y, 25, 25);
            break;

        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
