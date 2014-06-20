//
//  ODSSectionView.m
//  ODSAccordionView
//
//  Created by Johannes Seitz on 17/06/14.
//  Copyright (c) 2014 Johannes W. Seitz. All rights reserved.
//

#import "ODSAccordionSectionView.h"
#import "ODSAccordionSectionStyle.h"
#import "ODSArrowIcon.h"

#define MARGIN 8

@implementation ODSAccordionSectionView {
    ODSAccordionSectionStyle *_sectionStyle;
    CGFloat _sectionViewAlpha;
    ODSArrowIcon *_arrowIcon;
}

-(instancetype)initWithTitle:(NSString *)sectionTitle
                     andView:(UIView *)sectionView
                sectionStyle:(ODSAccordionSectionStyle *)sectionStyle {
    self = [super init];
    if (self) {
        _sectionStyle = sectionStyle;
        _sectionView = sectionView;
        self.backgroundColor = _sectionStyle.backgroundColour;
        [self setClipsToBounds:YES];
        [self makeHeader:sectionTitle];
        [self addArrowIcon];
        [self addSubview: sectionView];
        [self layoutIfNeeded];
        [self collapseSectionAnimated:NO];
    }
    return self;
}

-(void)makeHeader:(NSString *)sectionTitle {
    _header = [UIButton buttonWithType:UIButtonTypeCustom];
    [_header setTitle:sectionTitle forState:UIControlStateNormal];
    [_header setTitleColor:_sectionStyle.headerTitleLabelTextColour forState:UIControlStateNormal];

    _header.backgroundColor = _sectionStyle.headerBackgroundColour;
    _header.titleLabel.font = _sectionStyle.headerTitleLabelFont;
    [_header addTarget:self action:@selector(toggleButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:_header];
}

-(void)addArrowIcon {
    _arrowIcon = [[ODSArrowIcon alloc] initWithFrame:CGRectMake(0, 0, 30, 5)];
    [_arrowIcon setHidden:!_sectionStyle.arrowVisible];
    _arrowIcon.color = _sectionStyle.arrowColour;
    [self addSubview:_arrowIcon];
}

-(void)collapseSectionAnimated:(BOOL)animated {
    _expanded = NO;
    self.height = self.collapsedHeight;
    _sectionViewAlpha = 0.0;
    [self sectionViewAlphaChanged:animated];
    [_arrowIcon pointDownAnimated:YES];
}

-(void)expandSectionAnimated:(BOOL)animated {
    _expanded = YES;
    self.height = self.expandedHeight;
    _sectionViewAlpha = 1.0;
    [self sectionViewAlphaChanged:animated];
    [_arrowIcon pointUpAnimated:YES];
}

-(void)sectionViewAlphaChanged:(BOOL)animated {
    if (animated){
        [UIView animateWithDuration:0.5 animations:^{ _sectionView.alpha = _sectionViewAlpha; }];
    } else {
        _sectionView.alpha = _sectionViewAlpha;
    }
}

-(void)toggleButtonPressed:(id)sectionPressed {
    if (_expanded){
        [self collapseSectionAnimated:YES];
    } else {
        [self expandSectionAnimated:YES];
    }
    [self setNeedsLayout];
}

-(CGFloat)headerHeight {
    if (_sectionStyle.headerHeight != 0){
        return _sectionStyle.headerHeight;
    } else {
        CGFloat defaultHeaderHeight = 30;
        return defaultHeaderHeight;
    }
}

-(void)layoutSubviews {
    [super layoutSubviews];
    _header.frame = CGRectMake(0, 0, self.width, self.headerHeight);
    CGSize arrowSize = _arrowIcon.frame.size;
    if (_sectionStyle.headerStyle == ODSAccordionHeaderStyleLabelLeft){
        [_header setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_header setTitleEdgeInsets:UIEdgeInsetsMake(0, MARGIN, 0, 0)];
        _arrowIcon.frame = CGRectMake(self.width - MARGIN - arrowSize.width, self.headerHeight / 2 - arrowSize.height / 2 ,
                                      arrowSize.width, arrowSize.height);
    } else if (_sectionStyle.headerStyle == ODSAccordionHeaderStyleLabelRight){
        [_header setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [_header setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, MARGIN)];
        _arrowIcon.frame = CGRectMake(MARGIN, self.headerHeight / 2 - arrowSize.height / 2,
                                      arrowSize.width, arrowSize.height);
    } else if (_sectionStyle.headerStyle == ODSAccordionHeaderStyleLabelCentered) {
        [_header setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [_header setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        _arrowIcon.frame = CGRectMake(_header.center.x - (_arrowIcon.frame.size.width / 2) + 3, // FIXME: button is smaller than frame
                                      _header.frame.size.height - _arrowIcon.frame.size.height - MARGIN,
                                      _arrowIcon.frame.size.width, _arrowIcon.frame.size.height);
    }
    _sectionView.frame = CGRectMake(0, self.headerHeight, self.width, _sectionView.frame.size.height);
}

-(CGFloat)expandedHeight {
    return _sectionView.frame.size.height  + self.headerHeight;
}

-(CGFloat)collapsedHeight {
    return self.headerHeight;
}

-(CGFloat)width {
    return self.frame.size.width;
}

@end
