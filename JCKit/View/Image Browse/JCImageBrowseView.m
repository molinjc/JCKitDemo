//
//  JCImageBrowseView.m
//
//  Created by molin.JC on 2017/5/3.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCImageBrowseView.h"
#import "UIImage+JCImage.h"
#import "UIView+JCView.h"
@interface JCImageBrowseItem () <NSCopying>
@property (nonatomic, readonly) UIImage *thumbImage;
@end

@implementation JCImageBrowseItem

- (UIImage *)thumbImage {
    if ([_thumbView isKindOfClass:[UIImageView class]]) {
        return ((UIImageView *)_thumbView).image;
    }
    return _image ? _image : nil;
}

- (id)copyWithZone:(NSZone *)zone {
    JCImageBrowseItem *item = [self.class new];
    return item;
}

@end



#pragma mark -

@interface JCImageBrowseCell : UIScrollView <UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) JCImageBrowseItem *item;
@property (nonatomic, assign) NSInteger page;

/** 用于加载网络图片的画笔与进度值 */
@property (nonatomic, assign) BOOL showProgress;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@end

@implementation JCImageBrowseCell

- (instancetype)init {
    if (self = [super init]) {
        self.delegate = self;
        self.bouncesZoom = YES;
        self.maximumZoomScale = 3;
        self.multipleTouchEnabled = YES;
        self.alwaysBounceVertical = NO;
        self.showsVerticalScrollIndicator = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.frame = [UIScreen mainScreen].bounds;
        
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
        [self _initProgress];
    }
    return self;
}

- (void)_initProgress {
    _progressLayer = [CAShapeLayer layer];
    
    CGRect rect = _progressLayer.frame;
    rect.size = CGSizeMake(40, 40);
    _progressLayer.frame = rect;
    
    _progressLayer.cornerRadius = 20;
    _progressLayer.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.500].CGColor;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(_progressLayer.bounds, 7, 7) cornerRadius:(40 / 2 - 7)];
    _progressLayer.path = path.CGPath;
    _progressLayer.fillColor = [UIColor clearColor].CGColor;
    _progressLayer.strokeColor = [UIColor whiteColor].CGColor;
    _progressLayer.lineWidth = 4;
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.strokeStart = 0;
    _progressLayer.strokeEnd = 0;
    _progressLayer.hidden = YES;
    [self.layer addSublayer:_progressLayer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGPoint center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    CGRect frame = _progressLayer.frame;
    frame.origin.x = center.x - frame.size.width * 0.5;
    frame.origin.y = center.y - frame.size.height * 0.5;
    _progressLayer.frame = frame;
}

- (void)setItem:(JCImageBrowseItem *)item {
    _item = item;
    if (!item) {
        _imageView.image = nil;
        return;
    }
    
    if (item.imageURL) {
//        @weakify(self);
//        [_imageView sd_setImageWithURL:item.imageURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            @strongify(self);
//            [self _resizeImageViewSize];
//        }];
    }else if (item.thumbImage) {
        _imageView.image = item.thumbImage;
    }
    
    [self _resizeImageViewSize];
}

/** 调整图片大小 */
- (void)_resizeImageViewSize {
    _imageView.origin = CGPointZero;
    _imageView.width = self.width;
    UIImage *image = _imageView.image;
    
    if (image.size.height / image.size.width > self.height / self.width) {
        _imageView.height = floor(image.size.height / (image.size.width / self.width));
    }else {
        CGFloat height = image.size.height / (image.size.width / self.width);
        if (height < 1 || isnan(height)) { height = self.height;}
        height = floor(height);
        _imageView.height = height;
        _imageView.centerY = self.height / 2;
    }
    
    if (_imageView.height > self.height && _imageView.height - self.height <= 1) {
        _imageView.height = self.height;
    }
    
    self.contentSize = CGSizeMake(self.width, MAX(_imageView.height, self.height));
    [self scrollRectToVisible:self.bounds animated:NO];
    
    if (_imageView.height <= self.height) {
        self.alwaysBounceVertical = NO;
    } else {
        self.alwaysBounceVertical = YES;
    }
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    UIView *subView = _imageView;
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}

@end



#pragma mark -

@interface JCImageBrowseView () <UIGestureRecognizerDelegate, UIScrollViewDelegate>
/** 存储JCImageBrowseCell */
@property (nonatomic, strong) NSMutableArray *cells;
/** 背景视图 */
@property (nonatomic, strong) UIImageView *backgroundView;
/** 模糊背景视图 */
@property (nonatomic, strong) UIImageView *blurBackgroundView;
/** 容器视图, 承载scrollView */
@property (nonatomic, strong) UIView *contentView;
/** 滚动视图, 横向滚动图片 */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 分页视图, 表示当前页 */
@property (nonatomic, strong) UIPageControl *pager;
/** 所选择的imageView的容器 */
@property (nonatomic, weak) UIView *fromView;
/** 当前显示最上层的容器view */
@property (nonatomic, weak) UIView *toContainerView;
/** 记录选中的imageView的位置 */
@property (nonatomic, assign) NSInteger fromItemIndex;
@end
@implementation JCImageBrowseView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        self.frame = [UIScreen mainScreen].bounds;
        self.clipsToBounds = YES;
        
        [self _addGestureRecognizer];
        [self _initSubviews];
    }
    return self;
}

- (instancetype)initWithImageBrowseItems:(NSArray <JCImageBrowseItem *> *)items {
    if (!items.count) { return nil; }
    if (self = [self init]) {
        _imageBrowseItems = items.copy;
        _scrollView.alwaysBounceHorizontal = items.count > 1;
        _scrollView.contentSize = CGSizeMake(_scrollView.width * _imageBrowseItems.count, _scrollView.height);
        _pager.numberOfPages = items.count;
        _cells = @[].mutableCopy;
    }
    return self;
}

/** 初始化子视图 */
- (void)_initSubviews {
    _backgroundView = UIImageView.new;
    _backgroundView.frame = self.bounds;
    _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _blurBackgroundView = UIImageView.new;
    _blurBackgroundView.frame = self.bounds;
    _blurBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _contentView = UIView.new;
    _contentView.frame = self.bounds;
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _scrollView = UIScrollView.new;
    _scrollView.frame = CGRectMake(-20 / 2, 0, self.width + 20, self.height);
    _scrollView.delegate = self;
    _scrollView.scrollsToTop = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.delaysContentTouches = NO;
    _scrollView.canCancelContentTouches = YES;
    
    _pager = [[UIPageControl alloc] init];
    _pager.hidesForSinglePage = YES;
    _pager.userInteractionEnabled = NO;
    _pager.width = self.width - 36;
    _pager.height = 10;
    _pager.center = CGPointMake(self.width / 2, self.height - 18);
    _pager.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    [self addSubview:_backgroundView];
    [self addSubview:_blurBackgroundView];
    [self addSubview:_contentView];
    [_contentView addSubview:_scrollView];
    [_contentView addSubview:_pager];
}

/** 添加手势 */
- (void)_addGestureRecognizer {    
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [self addGestureRecognizer:pinchGestureRecognizer];
}

/** 重新设置cell */
- (void)updateCellsForReuse {
    for (JCImageBrowseCell *cell in _cells) {
        if (cell.superview) {
            if (cell.x > _scrollView.contentOffset.x + _scrollView.width * 2|| cell.right < _scrollView.contentOffset.x - _scrollView.width) {
                [cell removeFromSuperview];
                cell.page = -1;
                cell.item = nil;
            }
        }
    }
}

/** 获取一个无用的cell, 作用相当于复用池 */
- (JCImageBrowseCell *)dequeueReusableCell {
    JCImageBrowseCell *cell = nil;
    for (cell in _cells) {
        if (!cell.superview) {
            return cell;
        }
    }
    
    cell = [JCImageBrowseCell new];
    cell.frame = self.bounds;
    cell.imageView.frame = cell.bounds;
    cell.page = -1;
    cell.item = nil;
    [_cells addObject:cell];
    return cell;
}

/** 获取page的cell */
- (JCImageBrowseCell *)cellForPage:(NSInteger)page {
    for (JCImageBrowseCell *cell in _cells) {
        if (cell.page == page) {
            return cell;
        }
    }
    return nil;
}
/** 当前页的 */
- (NSInteger)currentPage {
    NSInteger page = _scrollView.contentOffset.x / _scrollView.width + 0.5;
    if (page >= _imageBrowseItems.count) {
        page = (NSInteger)_imageBrowseItems.count - 1;
    }
    if (page < 0) { page = 0; }
    return page;
}

- (void)hidePager {
    [UIView animateWithDuration:0.3 delay:0.8 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut animations:^{
        _pager.alpha = 0;
    }completion:^(BOOL finish) {
    }];
}

#pragma mark - public

- (void)browseViewInit {
    UIView *view = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    UIImage *image = [view snapshotImage];
    _backgroundView.image = image;
    _blurBackgroundView.image = [image imageByBlurDark];
    
    self.pager.alpha = 0;
    self.pager.currentPage = 0;
    
    [_scrollView scrollRectToVisible:CGRectMake(_scrollView.width * _pager.currentPage, 0, _scrollView.width, _scrollView.height) animated:NO];
    [self scrollViewDidScroll:_scrollView];
}

/** 显示在window上 */
- (void)showAtPresentWindow {
    [self browseViewInit];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)presentFromImageView:(UIView *)fromView toContainer:(UIView *)toContainer animated:(BOOL)animated completion:(void (^)(void))completion {
    if (!toContainer) { return; }
    
    _fromView = fromView;
    _toContainerView = toContainer;
    
    NSInteger page = 0;
    for (NSUInteger i = 0; i < _imageBrowseItems.count; i++) {
        if (fromView == ((JCImageBrowseItem *)_imageBrowseItems[i]).thumbView) {
            page = (int)i; break;
        }
    }
    
    _fromItemIndex = page;
    _backgroundView.image = [_toContainerView snapshotImageAfterScreenUpdates:NO];
    _blurBackgroundView.image = [_backgroundView.image imageByBlurDark];
    _blurBackgroundView.alpha = 0;
    
    self.pager.alpha = 0;
    self.pager.currentPage = page;
    
    [_scrollView scrollRectToVisible:CGRectMake(_scrollView.width * _pager.currentPage, 0, _scrollView.width, _scrollView.height) animated:NO];
    [self scrollViewDidScroll:_scrollView];
    
    [_toContainerView addSubview:self];
    
    [UIView setAnimationsEnabled:YES];
    
    JCImageBrowseCell *cell = [self cellForPage:self.currentPage];
    
    CGRect fromFrame = [_fromView convertRect:_fromView.bounds toView:cell];
    CGRect originFrame = cell.imageView.frame;
    cell.imageView.frame = fromFrame;
    
    float oneTime = animated ? 0.25 : 0;
    [UIView animateWithDuration:oneTime delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
        cell.imageView.frame = originFrame;
        self.pager.alpha = 1;
        _blurBackgroundView.alpha = 1;
    }completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

- (void)dismissAnimated:(BOOL)animated completion:(void (^)(void))completion {
    NSInteger currentPage = self.currentPage;
    JCImageBrowseCell *cell = [self cellForPage:currentPage];
    JCImageBrowseItem *item = _imageBrowseItems[currentPage];
    
    UIView *fromView = nil;
    if (_fromItemIndex == currentPage) {
        fromView = _fromView;
    }else {
        fromView = item.thumbView;
    }
    
    CGRect fromFrame = [fromView convertRect:fromView.bounds toView:cell];
    
    float oneTime = animated ? 0.25 : 0;
    [UIView animateWithDuration:oneTime delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
        cell.imageView.frame = fromFrame;
        self.pager.alpha = 0;
        _blurBackgroundView.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (completion) {
            completion();
        }
    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateCellsForReuse];
    
    CGFloat floatPage = _scrollView.contentOffset.x / _scrollView.width;
    NSInteger page = _scrollView.contentOffset.x / _scrollView.width + 0.5;
    
    for (NSInteger i = page - 1; i <= page + 1; i++) {
        if (i >= 0 && i < _imageBrowseItems.count) {
            JCImageBrowseCell *cell = [self cellForPage:i];
            if (!cell) {
                JCImageBrowseCell *cell = [self dequeueReusableCell];
                cell.page = i;
                cell.x = (self.width + 20) * i + 20 / 2;
                cell.item = self.imageBrowseItems[i];
                [self.scrollView addSubview:cell];
            } else {
                if (!cell.item) {
                    cell.item = self.imageBrowseItems[i];
                }
            }
        }
    }

    NSInteger intPage = floatPage + 0.5;
    intPage = intPage < 0 ? 0 : intPage >= _imageBrowseItems.count ? (int)_imageBrowseItems.count - 1 : intPage;
    _pager.currentPage = intPage;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        _pager.alpha = 1;
    }completion:^(BOOL finish) {
    }];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self hidePager];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self hidePager];
}

#pragma mark - GestureRecognizer

- (void)dismiss {
    [self dismissAnimated:YES completion:nil];
}

- (void)doubleTap:(UITapGestureRecognizer *)sender {
    JCImageBrowseCell *cell = [self cellForPage:self.currentPage];
    if (cell) {
        if (cell.zoomScale > 1) {
            [cell setZoomScale:1 animated:YES];
        } else {
            CGPoint touchPoint = [sender locationInView:cell.imageView];
            CGFloat newZoomScale = cell.maximumZoomScale;
            CGFloat xsize = self.width / newZoomScale;
            CGFloat ysize = self.height / newZoomScale;
            [cell zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
        }
    }
}

- (void)pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer {
    UIView *view = pinchGestureRecognizer.view;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
}

@end
