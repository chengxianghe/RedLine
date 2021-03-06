//
//  TUBatteryHeaderView.m
//  RedLine
//
//  Created by LXJ on 16/3/26.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "TUBatteryHeaderView.h"
#import "UIView+Category.h"
#import "TUSystemInfoManager.h"

@interface TUBatteryHeaderView ()

@property (strong, nonatomic) UILabel *stateLabel;

@end

@implementation TUBatteryHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addSubview:self.stateLabel];
}

#pragma mark - setter & getter
- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.width - 175) / 2, 0, 175, 30)];
        _stateLabel.textColor = [UIColor whiteColor];
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.font = [UIFont systemFontOfSize:12];
        
        [_stateLabel.layer setMasksToBounds:YES];
        [_stateLabel.layer setCornerRadius:_stateLabel.bounds.size.height / 2.0]; //设置矩形四个圆角半径
        [_stateLabel.layer setBorderWidth:1]; //边框宽度
        [_stateLabel.layer setBorderColor:[UIColor colorWithWhite:1.f alpha:0.7f].CGColor];//边框颜色
    }
    return _stateLabel;
}

- (void)updateHeaderUI {
    if ([TUSystemInfoManager manager].batteryInfo.batteryState == UIDeviceBatteryStateUnplugged) {
        _stateLabel.text = kTULocalString(@"unProtectMethod");
    } else {
        _stateLabel.text = kTULocalString(@"protectMethod");
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
