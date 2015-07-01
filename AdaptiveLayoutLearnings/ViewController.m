//
//  ViewController.m
//  AdaptiveLayoutLearnings
//
//  Created by Angelo Lobo on 6/30/15.
//  Copyright (c) 2015 Angelo Lobo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

//Declare variables for constraints
@property (nonatomic, strong) NSArray *constraint_H1, *constraint_H2, *constraint_V1, *constraint_V2;
@property (nonatomic, strong) NSMutableDictionary *viewsDictionary;
@property (nonatomic, strong) UIView *topView, *bottomView, *landscapeView, *largeView;
@end

@implementation ViewController

@synthesize constraint_V1;
@synthesize constraint_V2;
@synthesize constraint_H1;
@synthesize constraint_H2;
@synthesize viewsDictionary;
@synthesize topView, bottomView, landscapeView, largeView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.25f alpha:1.0f];
    
    [self setupViews];
}

-(void)setupViews{
    NSLog(@"Setting up views....");
    
    topView = [UIView new];
    topView.backgroundColor = [UIColor colorWithRed:0.95 green:0.47 blue:0.48 alpha:1.0];
    topView.translatesAutoresizingMaskIntoConstraints = NO;
    
    bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor colorWithRed:1.00 green:0.83 blue:0.58 alpha:1.0];
    bottomView.translatesAutoresizingMaskIntoConstraints = NO;
    
    landscapeView = [UIView new];
    landscapeView.backgroundColor = [UIColor colorWithRed:0.40 green:0.40 blue:1.00 alpha:1.0];
    landscapeView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:topView];
    [self.view addSubview:bottomView];
    [self.view addSubview:landscapeView];
    
    NSDictionary *dictionaryOfViews = @{@"top":topView,
                                      @"bottom":bottomView,
                                      @"landscape":landscapeView
                                      };
    
    viewsDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionaryOfViews];
    
    NSLog(@"Checking horizontal size class....");
    
    constraint_V1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[top(bottom)]-10-[bottom]-10-|" options:0 metrics:nil views:viewsDictionary];
    //constraint_V1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[top]-10-[bottom(top)]-10-|" options:0 metrics:nil views:viewsDictionary];
    //constraint_V1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[top(<=100)]-10-[bottom]-10-|" options:0 metrics:nil views:viewsDictionary];
    
    //Compact size class
    if (self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) {
        NSLog(@"Compact size class!");
        constraint_H1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[top]-10-|" options:NSLayoutFormatAlignAllLeading metrics:nil views:viewsDictionary];
        constraint_H2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[bottom]-10-|" options:NSLayoutFormatAlignAllLeading metrics:nil views:viewsDictionary];
    }
    else if(self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular){
        NSLog(@"Regular size class");
        
        largeView = [UIView new];
        largeView.backgroundColor = [UIColor darkGrayColor];
        largeView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.view addSubview:largeView];
        
        viewsDictionary[@"largeView"] = largeView;
        
        constraint_V2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[largeView]-10-|" options:0 metrics:nil views:viewsDictionary];
        [self.view addConstraints:constraint_V2];
        
        constraint_H1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[largeView(<=200)]-10-[top]-10-|" options:0 metrics:nil views:viewsDictionary];
        constraint_H2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[bottom(top)]-10-|" options:NSLayoutFormatAlignAllLeading metrics:nil views:viewsDictionary];
        //constraint_H2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[largeView]-10-[bottom]-10-|" options:0 metrics:nil views:viewsDictionary];
    }
    
    [self.view addConstraints:constraint_V1];
    [self.view addConstraints:constraint_H1];
    [self.view addConstraints:constraint_H2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    NSLog(@"viewWillTransitionToSize.......");
    
    [self.view removeConstraints:constraint_H1];
    [self.view removeConstraints:constraint_H2];
    [self.view removeConstraints:constraint_V2];
    
    if ( UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]) ){
        NSLog(@"Landscape orientation");

        if (self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) {
            NSLog(@"Compact size class!");
            
            NSArray *constraint_V3 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[landscape]-10-|" options:0 metrics:nil views:viewsDictionary];
            [self.view addConstraints:constraint_V3];
            
            constraint_H1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[top]-[landscape]-10-|" options:0 metrics:nil views:viewsDictionary];
            constraint_H2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[bottom(top)]-[landscape(<=300)]-10-|" options:0 metrics:nil views:viewsDictionary];
        }
        else if(self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular){
            NSLog(@"Regular size class");
            
            constraint_V2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[largeView]-10-|" options:0 metrics:nil views:viewsDictionary];
            NSArray *constraint_V3 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[landscape]-10-|" options:0 metrics:nil views:viewsDictionary];
            [self.view addConstraints:constraint_V2];
            [self.view addConstraints:constraint_V3];
            
            constraint_H1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[largeView(<=200)]-10-[top]-[landscape]-10-|" options:0 metrics:nil views:viewsDictionary];
            constraint_H2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[bottom(top)]-[landscape(<=200)]-10-|" options:0 metrics:nil views:viewsDictionary];
            //constraint_H2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[largeView]-10-[bottom]-10-|" options:0 metrics:nil views:viewsDictionary];
        }

    }
    else if (UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation])){
        NSLog(@"Portrait orientation");
        
        if (self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) {
            NSLog(@"Compact size class!");
            constraint_H1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[top]-10-|" options:NSLayoutFormatAlignAllLeading metrics:nil views:viewsDictionary];
            constraint_H2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[bottom]-10-|" options:NSLayoutFormatAlignAllLeading metrics:nil views:viewsDictionary];
        }
        else if(self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular){
            NSLog(@"Regular size class");
            
            constraint_V2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[largeView]-10-|" options:0 metrics:nil views:viewsDictionary];
            [self.view addConstraints:constraint_V2];
            
            constraint_H1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[largeView(<=200)]-10-[top]-10-|" options:0 metrics:nil views:viewsDictionary];
            constraint_H2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[bottom(top)]-10-|" options:NSLayoutFormatAlignAllLeading metrics:nil views:viewsDictionary];
            //constraint_H2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[largeView]-10-[bottom]-10-|" options:0 metrics:nil views:viewsDictionary];
        }
    }
    
    [self.view addConstraints:constraint_H1];
    [self.view addConstraints:constraint_H2];
}

@end
