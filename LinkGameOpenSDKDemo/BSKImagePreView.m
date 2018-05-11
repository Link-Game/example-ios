//
//  BSKImagePreViewCell.m
//  仿AppStore
//
//  Created by 刘万林 on 2018/2/9.
//  Copyright © 2018年 刘万林. All rights reserved.
//

#import "BSKImagePreView.h"

@interface BSKImagePreView()<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView * scrollView;
@property (strong, nonatomic) UIImageView * imageView;
@end


@implementation BSKImagePreView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initialize:self.frame];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize:frame];
    }
    return self;
}


-(void)initialize:(CGRect )frame{
    CGRect bounds = frame;
    bounds.origin.x = 0;
    bounds.origin.y = 0;
    self.scrollView = [[UIScrollView alloc] initWithFrame:bounds];
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self addSubview:self.scrollView];
    self.scrollView.delegate = self;
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.alwaysBounceHorizontal = YES;
    self.scrollView.backgroundColor = [UIColor lightGrayColor];
    self.imageView = [[UIImageView alloc] initWithFrame:bounds];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.scrollView addSubview:self.imageView];
}

-(void)setImage:(UIImage *)image
{
    _image = image;
    if ([image isKindOfClass:[UIImage class]]) {
        UIImage * uiimage = image;
        self.scrollView.zoomScale = 1;
        self.imageView.image = uiimage;
        [self resizeImageView];
        [self setMinimumAndMaximumZoomScale];
    }
}

-(void)resetViewScale{
    self.scrollView.zoomScale = 1;
    [self resizeImageView];
}


#pragma mark - ● Private Method

-(void)setMinimumAndMaximumZoomScale{
    CGSize imageSize = self.imageView.image.size;
    
    if (imageSize.width<self.scrollView.bounds.size.width&&imageSize.height<self.scrollView.bounds.size.height) {
        self.scrollView.minimumZoomScale = 0.5;
        self.scrollView.maximumZoomScale = self.scrollView.bounds.size.width/imageSize.width;
    }else{
            if (imageSize.width/self.scrollView.bounds.size.width>imageSize.height/self.scrollView.bounds.size.height) {
                self.scrollView.minimumZoomScale = 0.5;
                self.scrollView.maximumZoomScale = imageSize.width/self.scrollView.bounds.size.width;
            }else{
                self.scrollView.minimumZoomScale = 0.5;
                self.scrollView.maximumZoomScale = imageSize.height/self.scrollView.bounds.size.height;
            }
    }
}
-(void)resizeImageView{
    CGRect f = self.imageView.frame;
    f.origin = CGPointZero;
    self.imageView.frame = f;
    
    CGSize imageSize = self.imageView.image.size;
    CGFloat ratio = imageSize.width/imageSize.height;
    CGRect imageViewBounds = CGRectMake(0, 0, 0, 0);
    if (imageSize.width<self.scrollView.bounds.size.width&&imageSize.height<self.scrollView.bounds.size.height) {
        imageViewBounds.size = imageSize;
    }else{
            if (imageSize.width/self.scrollView.bounds.size.width>imageSize.height/self.scrollView.bounds.size.height) {
                imageViewBounds.size.width = self.scrollView.bounds.size.width;
                
                imageViewBounds.size.height = ceil(self.scrollView.bounds.size.width/ratio);
            }else{
                imageViewBounds.size.height = self.scrollView.bounds.size.height;
                imageViewBounds.size.width = ceil(self.scrollView.bounds.size.height*ratio);
            }
    }
    
    self.imageView.bounds = imageViewBounds;
    self.imageView.center = CGPointMake(self.scrollView.bounds.size.width/2, self.scrollView.bounds.size.height/2);
    self.scrollView.contentSize = imageViewBounds.size;
}

#pragma mark - ● UIScrollViewDelegate

-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGFloat offsetX = (_scrollView.bounds.size.width > _scrollView.contentSize.width) ? ((_scrollView.bounds.size.width - _scrollView.contentSize.width) * 0.5) : 0.0;
    CGFloat offsetY = (_scrollView.bounds.size.height > _scrollView.contentSize.height) ? ((_scrollView.bounds.size.height - _scrollView.contentSize.height) * 0.5) : 0.0;
    self.imageView.center = CGPointMake(_scrollView.contentSize.width * 0.5 + offsetX, _scrollView.contentSize.height * 0.5 + offsetY);
//    self.imageView.center = center;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

@end
