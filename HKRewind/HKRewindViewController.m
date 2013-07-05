//
//  HKRewindViewController.m
//  HKRewind
//
//  Created by Panos Baroudjian on 7/3/13.
//  Copyright (c) 2013 Panos Baroudjian. All rights reserved.
//

#import "HKRewindViewController.h"
#import "HKRewindGestureRecognizer.h"

@interface HKRewindViewController ()

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

    HKRewindGestureRecognizer *recognizer = [[HKRewindGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognized:)];
    recognizer.triggerType = HKRewindTriggerTypeDistance;
    [self.view addGestureRecognizer:recognizer];
}

- (void)gestureRecognized:(HKRewindGestureRecognizer *)recognizer
{
//    NSLog(@"%@", recognizer);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
