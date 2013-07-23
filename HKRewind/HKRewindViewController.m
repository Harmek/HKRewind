//
//  HKRewindViewController.m
//  HKRewind
//
//  Copyright (c) 2012-2013, Panos Baroudjian.
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.


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

    self.hudView = [[HKRewindHUDView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width * .5 - 100,
                                                                     self.view.bounds.size.height * .5 - 100,
                                                                     200,
                                                                     200)];
    [self.view addSubview:self.hudView];
    self.hudView.textLabel.text = @"Rewind";
    self.hudView.detailLabel.text = @"...";
    HKRewindGestureRecognizer *recognizer = [[HKRewindGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognized:)];
//    recognizer.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:recognizer];

    self.centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [self.view addSubview:self.centerView];
    self.centerView.backgroundColor = [UIColor redColor];
}

- (void)gestureRecognized:(HKRewindGestureRecognizer *)recognizer
{
    switch (recognizer.state) {
        case UIGestureRecognizerStateChanged:
            [self.hudView addProgression:recognizer.rotationDelta];
//            self.centerView.center = recognizer.center;
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
