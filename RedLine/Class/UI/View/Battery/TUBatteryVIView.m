//
//  TUBatteryVIView.m
//  RedLine
//
//  Created by LXJ on 16/3/28.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "TUBatteryVIView.h"
#import "BEMSimpleLineGraphView.h"
#import "UIColor+GGColor.h"
#import "TUSystemInfoManager.h"
#import "UIView+Category.h"

#define LOAD_NIB(name) [[[NSBundle mainBundle] loadNibNamed:name owner:nil options:nil] lastObject]

@interface TUBatteryVIView ()<BEMSimpleLineGraphDelegate,BEMSimpleLineGraphDataSource>

@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *voltageGraphView;
@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *currentGraphView;

@property (strong, nonatomic)NSMutableArray *voltageArray;//电压valueArray
@property (strong, nonatomic)NSMutableArray *currentArray;//电流valueArray
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *currentTopConstraint; //currentLabel距离顶端的约束


@end

@implementation TUBatteryVIView

+ (BEMSimpleLineGraphView *)showGraphView {
    return LOAD_NIB(@"TUBatteryVIView");
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor clearColor];
    self.voltageArray = [NSMutableArray array];
    self.currentArray = [NSMutableArray array];
    
    self.voltageGraphView.delegate = self;
    self.currentGraphView.delegate = self;
    self.voltageGraphView.dataSource = self;
    self.currentGraphView.dataSource = self;
    
    [self setup];
}

- (void)setup {
    //  68c1fa  7386c5
    // Create a gradient to apply to the bottom portion of the graph
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = {
        0.41, 0.76, 0.98, 1.0,
        0.45, 0.53, 0.77, 1.0,
    };
    
    // Apply the gradient to the bottom portion of the graph
    self.voltageGraphView.gradientBottom = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
    
    // Enable and disable various graph properties and axis displays
    self.voltageGraphView.enableTouchReport = YES;
    self.voltageGraphView.enablePopUpReport = YES;
    self.voltageGraphView.enableYAxisLabel = YES;
    self.voltageGraphView.autoScaleYAxis = YES;
    self.voltageGraphView.alwaysDisplayDots = NO;
    self.voltageGraphView.enableReferenceXAxisLines = YES;
    self.voltageGraphView.enableReferenceYAxisLines = YES;
    self.voltageGraphView.enableReferenceAxisFrame = YES;
    
    // Set the graph's animation style to draw, fade, or none
    self.voltageGraphView.animationGraphStyle = BEMLineAnimationExpand;
    
    // Dash the y reference lines
//    self.voltageGraphView.lineDashPatternForReferenceYAxisLines = @[@(2),@(2)];
    
    // Show the y axis values with this format string
    self.voltageGraphView.formatStringForValues = @"%.2f";
    self.voltageGraphView.enableBezierCurve = YES;
    self.voltageGraphView.colorBottom = [UIColor colorWithARGB:0xff7386c5];
    self.voltageGraphView.colorTop = [UIColor clearColor];

    self.currentGraphView.gradientBottom = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
    
    // Enable and disable various graph properties and axis displays
    self.currentGraphView.enableTouchReport = YES;
    self.currentGraphView.enablePopUpReport = YES;
    self.currentGraphView.enableYAxisLabel = YES;
    self.currentGraphView.autoScaleYAxis = YES;
    self.currentGraphView.alwaysDisplayDots = NO;
    self.currentGraphView.enableReferenceXAxisLines = YES;
    self.currentGraphView.enableReferenceYAxisLines = YES;
    self.currentGraphView.enableReferenceAxisFrame = YES;

    // Set the graph's animation style to draw, fade, or none
    self.currentGraphView.animationGraphStyle = BEMLineAnimationExpand;
    
    // Dash the y reference lines
    self.currentGraphView.lineDashPatternForReferenceYAxisLines = @[@(2),@(2)];
    
    // Show the y axis values with this format string
    self.currentGraphView.formatStringForValues = @"%.2f";
    
    self.currentGraphView.enableBezierCurve = YES;
    
    self.currentGraphView.colorBottom = [UIColor colorWithARGB:0xff7386c5];
    self.currentGraphView.colorTop = [UIColor clearColor];

}

- (float)getRandomFloat {
    float i1 = (float)(arc4random() % 100) / 100 ;
    return i1;
}

#pragma updateUI
- (void)updeteDataWithVoltageArray:(NSMutableArray *)voltageArray currentArray:(NSMutableArray *)currentArray voltage:(float)voltage current:(float)current{
    
    self.voltageLabel.text = [NSString stringWithFormat:@"当前电压:%.3fV",voltage];
    
    if ([TUSystemInfoManager manager].batteryInfo.batteryState == UIDeviceBatteryStateUnplugged) {
        self.voltageLabel.hidden = YES;
        self.voltageGraphView.hidden = YES;
        self.currentTopConstraint.constant = 8;
        self.currentLabel.text = [NSString stringWithFormat:@"输出电流:%.3fA",current];
    } else {
        self.voltageLabel.hidden = NO;
        self.voltageGraphView.hidden = NO;
        self.currentTopConstraint.constant = 132;
        self.currentLabel.text = [NSString stringWithFormat:@"当前电流:%.3fA",current];
    }
    
    self.voltageArray = voltageArray;
    self.currentArray = currentArray;

    [self.voltageGraphView reloadGraph];
    [self.currentGraphView reloadGraph];
    
    self.averageCurrent = self.currentGraphView.averageLine.yValue;
}

#pragma mark - SimpleLineGraph Data Source

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    if (graph == self.voltageGraphView) {
        return (int)self.voltageArray.count;
    } else {
        return (int)self.currentArray.count;
    }
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    if (graph == self.voltageGraphView) {
        return [[self.voltageArray objectAtIndex:index] doubleValue];
    } else {
        return [[self.currentArray objectAtIndex:index] doubleValue];
    }
}

@end
