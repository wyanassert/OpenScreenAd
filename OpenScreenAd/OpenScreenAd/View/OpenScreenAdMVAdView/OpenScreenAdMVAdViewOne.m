//
//  OpenScreenAdMVAdViewOne.m
//  Pods
//
//  Created by wyan assert on 2017/4/21.
//
//

#import "OpenScreenAdMVAdViewOne.h"
#import "OpenScreenAdParameters.h"
#import <MVSDK/MVSDK.h>
#import "Masonry.h"
#import "OpenScreenAdGoView.h"
#import "UIImageView+OSA_RenderCornerRadius.h"

@interface OpenScreenAdMVAdViewOne ()

@property (nonatomic, strong) UIImageView   *bannerImageView;
@property (nonatomic, strong) UIImageView   *avatarImageView;
@property (nonatomic, strong) UILabel       *displayAppNameLabel;
@property (nonatomic, strong) UILabel       *displayAppDesclabel;
@property (nonatomic, strong) UILabel       *adLabel;
@property (nonatomic, strong) OpenScreenAdGoView *goView;

@property (nonatomic, strong) NSArray<UIColor *> *gradientColors;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@property (nonatomic, strong) MVCampaign    *campaign;

@end

@implementation OpenScreenAdMVAdViewOne

@synthesize gradientColors = _gradientColors;

#pragma mark - OpenScreenAdMVAdViewProtocol
- (instancetype)initWithMVCampaign:(MVCampaign *)campaign {
    if(self = [super init]) {
        _campaign = campaign;
        [self configureView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.gradientLayer.frame = frame;
}

- (void)setGradientColors:(NSArray<UIColor *> *)gradientColors {
    _gradientColors = gradientColors;
    
    if(self.gradientLayer.superlayer) {
        [self.gradientLayer removeFromSuperlayer];
        self.gradientLayer = nil;
        self.gradientLayer.frame = self.frame;
        [self configureView];
    }
}


#pragma mark - Public


#pragma mark - Private
- (void)configureView {
    [self.layer addSublayer:self.gradientLayer];
    
    [self addSubview:self.bannerImageView];
    [self.bannerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(OSA_SCREENAPPLYHEIGHT(104));
        make.centerX.equalTo(self);
        make.height.mas_equalTo(OSA_SCREENAPPLYHEIGHT(166));
        make.width.mas_equalTo(OSA_SCREENAPPLYHEIGHT(320));
    }];
    
    [self addSubview:self.adLabel];
    [self.adLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(OSA_SCREENAPPLYSPACE(9));
        make.top.equalTo(self).offset(OSA_SCREENAPPLYHEIGHT(30));
        make.width.mas_equalTo(OSA_SCREENAPPLYHEIGHT(87));
        make.height.mas_equalTo(OSA_SCREENAPPLYHEIGHT(17));
    }];
    
    [self addSubview:self.avatarImageView];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bannerImageView.mas_bottom).offset(OSA_SCREENAPPLYHEIGHT(30));
        make.centerX.equalTo(self);
        make.height.width.mas_equalTo(OSA_SCREENAPPLYHEIGHT(50));
    }];
    
    [self addSubview:self.displayAppNameLabel];
    [self.displayAppNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView.mas_bottom).offset(OSA_SCREENAPPLYHEIGHT(18));
        make.centerX.equalTo(self);
        make.left.equalTo(self).offset(OSA_SCREENAPPLYSPACE(23));
        make.height.mas_equalTo(OSA_SCREENAPPLYHEIGHT(27));
    }];
    
    [self addSubview:self.displayAppDesclabel];
    [self.displayAppDesclabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.displayAppNameLabel.mas_bottom).offset(OSA_SCREENAPPLYHEIGHT(9));
        make.centerX.equalTo(self);
        make.left.equalTo(self).offset(OSA_SCREENAPPLYSPACE(23));
        make.height.mas_equalTo(OSA_SCREENAPPLYHEIGHT(34));
    }];
    
    [self addSubview:self.goView];
    [self.goView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(OSA_SCREENAPPLYHEIGHT(60));
    }];
    [self.goView startFlashAnimation];
}


#pragma mark - Getter
- (UIImageView *)bannerImageView {
    if(!_bannerImageView) {
        _bannerImageView = [[UIImageView alloc] init];
        [self.campaign loadImageUrlAsyncWithBlock:^(UIImage *image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _bannerImageView.image = image;
                [_bannerImageView OSA_renderImageWithRadius:OSA_SCREENAPPLYHEIGHT(12)];
            });
        }];
        _bannerImageView.layer.allowsEdgeAntialiasing = YES;
        _bannerImageView.layer.cornerRadius = OSA_SCREENAPPLYHEIGHT(12);
        _bannerImageView.layer.shadowColor = OSA_UIColorFromRGB(18, 17, 96).CGColor;
        _bannerImageView.layer.shadowOpacity = 0.3;
        _bannerImageView.layer.shadowRadius = OSA_SCREENAPPLYHEIGHT(4);
        _bannerImageView.layer.shadowOffset = CGSizeMake(OSA_SCREENAPPLYHEIGHT(7), OSA_SCREENAPPLYHEIGHT(7));
    }
    return _bannerImageView;
}

- (UIImageView *)avatarImageView {
    if(!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        [self.campaign loadIconUrlAsyncWithBlock:^(UIImage *image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _avatarImageView.image = image;
            });
        }];
        _avatarImageView.layer.cornerRadius = OSA_SCREENAPPLYHEIGHT(12);
        _avatarImageView.layer.masksToBounds = YES;
    }
    return _avatarImageView;
}

- (UILabel *)displayAppNameLabel {
    if(!_displayAppNameLabel) {
        _displayAppNameLabel = [[UILabel alloc] init];
        _displayAppNameLabel.font = [OpenScreenAdParameters getFontHeavy:OSA_SCREENAPPLYHEIGHT(22)];
        _displayAppNameLabel.textColor = [UIColor whiteColor];
        _displayAppNameLabel.text = self.campaign.appName;
        _displayAppNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _displayAppNameLabel;
}

- (UILabel *)displayAppDesclabel {
    if(!_displayAppDesclabel) {
        _displayAppDesclabel = [[UILabel alloc] init];
        _displayAppDesclabel.font = [OpenScreenAdParameters getFontRegular:OSA_SCREENAPPLYHEIGHT(14)];
        _displayAppDesclabel.textColor = [UIColor whiteColor];
        _displayAppDesclabel.text = self.campaign.appDesc;
        _displayAppDesclabel.numberOfLines = 2;
        _displayAppDesclabel.textAlignment = NSTextAlignmentCenter;
    }
    return _displayAppDesclabel;
}

- (UILabel *)adLabel {
    if(!_adLabel) {
        _adLabel = [[UILabel alloc] init];
        _adLabel.font = [OpenScreenAdParameters getFontRegular:OSA_SCREENAPPLYHEIGHT(12)];
        _adLabel.textColor = [UIColor whiteColor];
        _adLabel.text = @"Sponsored";
        _adLabel.alpha = 0.4;
    }
    return _adLabel;
}

- (OpenScreenAdGoView *)goView {
    if(!_goView) {
        _goView = [[OpenScreenAdGoView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - OSA_SCREENAPPLYHEIGHT(60), OSA_SCREEN_WIDTH, OSA_SCREENAPPLYHEIGHT(60))];
    }
    return _goView;
}

- (CAGradientLayer *)gradientLayer {
    if(!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = [UIScreen mainScreen].bounds;
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(0, 1);
        
        NSMutableArray *colors = [NSMutableArray arrayWithCapacity:self.gradientColors.count];
        for (UIColor *color in self.gradientColors) {
            [colors addObject:(id)color.CGColor];
        }
        _gradientLayer.colors = [colors copy];
        NSMutableArray<NSNumber *> *locations = [NSMutableArray arrayWithArray:@[@0, @1]];
        for(NSUInteger i = 0; i < colors.count - 2 ; i++) {
            NSNumber *num = @((i + 1) / ((CGFloat)(colors.count - 1)));
            [locations insertObject:num atIndex:(i + 1)];
        }
        _gradientLayer.locations = [locations copy];
    }
    return _gradientLayer;
}

- (NSArray<UIColor *> *)gradientColors {
    if(!_gradientColors.count) {
        return @[OSA_UIColorFromRGB(56, 208, 205),
                 OSA_UIColorFromRGB(8, 127, 255)];
    } else {
        return _gradientColors;
    }
}

@end
