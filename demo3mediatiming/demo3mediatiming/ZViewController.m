//
//  ZViewController.m
//  demo3mediatiming
//
//  Created by Sun on 14-3-5.
//  Copyright (c) 2014年 z. All rights reserved.
//

#import "ZViewController.h"
static int count = 0;
@interface ZViewController ()
@property (nonatomic) CFTimeInterval lastTimeStamp;
@property (strong, nonatomic) IBOutlet UIView *animationView;
@property (strong, nonatomic) IBOutlet UIButton *startAnimation;
- (IBAction)start:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *container;
@property (strong, nonatomic) IBOutlet UITextField *speed;
@property (strong, nonatomic) IBOutlet UITextField *duration;
@property (strong, nonatomic) IBOutlet UITextField *offset;
@property (strong, nonatomic) IBOutlet UITextField *autoreverse;
@property (strong, nonatomic) IBOutlet UITextField *beginTime;
@property (strong, nonatomic) IBOutlet UITextField *repeatDuration;
@property (strong, nonatomic) IBOutlet UITextField *fillMode;
@end

@implementation ZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1/60.0 target:self selector:@selector(draw:) userInfo:nil repeats:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)];
    [self.view addGestureRecognizer:tap];

}

- (void)endEdit {
    [self.view endEditing:YES];
}

- (void)draw:(CADisplayLink *)sender {
    CFTimeInterval t = sender.timestamp;
    CFTimeInterval inter;
    if (self.lastTimeStamp == 0) {
        self.lastTimeStamp = t;
        inter = 0;
    }else {
        inter = sender.timestamp - self.lastTimeStamp;
    }
    sender.paused = YES;
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(inter*80, 0, 2.5, 40)];
    v.layer.backgroundColor = [(CALayer *)self.animationView.layer.presentationLayer backgroundColor];
    [self.container addSubview:v];
    sender.paused = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)start:(id)sender {

    CGRect frame = self.container.frame;

    UIView *c = [[UIView alloc] initWithFrame:frame];
    [self.view addSubview:c];
    [self.container removeFromSuperview];
    self.container = c;
    CADisplayLink* link = [CADisplayLink displayLinkWithTarget:self
                                                      selector:@selector(draw:)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    self.lastTimeStamp = 0;
    CABasicAnimation *changeColor =
    [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    changeColor.fromValue = (id)[UIColor yellowColor].CGColor;
    changeColor.toValue   = (id)[UIColor blueColor].CGColor;

    NSString *text = self.duration.text;
    CGFloat duration = [text floatValue];
    if (duration == 0) {
        duration = 2;
    }
    changeColor.duration = duration;
    text = self.beginTime.text;
    CGFloat beginTime = [text floatValue];
    if (beginTime == 0) {
        beginTime = 0;
    }else {
        changeColor.beginTime = CACurrentMediaTime() + beginTime;
    }

    text = self.offset.text;
    CGFloat offset = [text floatValue];
    if (offset == 0) {
        offset = 0;
    }else {
        changeColor.timeOffset = offset;
    }

    text = self.repeatDuration.text;
    CGFloat repeatDuration = [text intValue];
    if (repeatDuration == 0) {
        repeatDuration = 0;
    }else {
        changeColor.repeatDuration = repeatDuration;
    }

    text = self.fillMode.text;
    int fillMode = [text intValue];
    switch (fillMode) {
        case 0:
            changeColor.fillMode = kCAFillModeForwards;
            break;
        case 1:
            changeColor.fillMode = kCAFillModeBackwards;
        default:
            break;
    }

    text = self.autoreverse.text;
    BOOL autoreverse = [text boolValue];
    changeColor.autoreverses = autoreverse;

    text = self.speed.text;
    CGFloat speed = [text floatValue];
    if (speed == 0) {
        speed = 1;
    }else {
        changeColor.speed = speed;
    }

    changeColor.removedOnCompletion = NO;

    [self.animationView.layer addAnimation:changeColor
                                    forKey:@"Change color"];
}
@end

