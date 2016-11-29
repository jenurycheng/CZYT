//
//  MJPhotoBrowser.m
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.

#import <QuartzCore/QuartzCore.h>
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
//#import "SDWebImageManager+MJ.h"
#import "UIImageView+WebCache.h"
#import "MJPhotoView.h"
#import "MJPhotoToolbar.h"
#import <Photos/Photos.h>

#define kPadding 10
#define kPhotoViewTagOffset 1000
#define kPhotoViewIndex(photoView) ([photoView tag] - kPhotoViewTagOffset)

#define PreCachePath    @"ImageCache/"

@interface MJPhotoBrowser () <MJPhotoViewDelegate>
{
    // 滚动的view
	UIScrollView *_photoScrollView;
    // 所有的图片view
	NSMutableSet *_visiblePhotoViews;
    NSMutableSet *_reusablePhotoViews;
    // 工具条
    MJPhotoToolbar *_toolbar;
    
    UIView *_bottomBar;
    UIButton *_uploadBtn;
    
    // 一开始的状态栏
    BOOL _statusBarHiddenInited;
    
    NSString *_prePath;
}
@end

@implementation MJPhotoBrowser

- (id)init
{
    self = [super init];
    self.showPushBtn = YES;
    _prePath = PreCachePath;
    _imageCachePath = [MJPhotoBrowser getCachePath];
    return self;
}

+ (NSString *)getCachePath
{
    return [NSTemporaryDirectory() stringByAppendingString:PreCachePath];
}

#pragma mark - Lifecycle
- (void)loadView
{
    _statusBarHiddenInited = [UIApplication sharedApplication].isStatusBarHidden;
    // 隐藏状态栏
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    self.view = [[UIView alloc] init];
    self.view.frame = [UIScreen mainScreen].bounds;
	self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1.创建UIScrollView
    [self createScrollView];
    
    // 2.创建工具条
    [self createToolbar];
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.view];
    [window.rootViewController addChildViewController:self];

    if (_currentPhotoIndex == 0) {
        [self showPhotos];
    }
}

#pragma mark - 私有方法
#pragma mark 创建工具条
- (void)createToolbar
{
    CGFloat barHeight = 64;
    CGFloat barY = 22; //self.view.frame.size.height - barHeight;
    _toolbar = [[MJPhotoToolbar alloc] init];
    _toolbar.frame = CGRectMake(0, barY, self.view.frame.size.width, barHeight);
    _toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _toolbar.photos = _photos;
    [self.view addSubview:_toolbar];
    
    _bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - barHeight-30, self.view.frame.size.width, barHeight)];
//    _bottomBar.backgroundColor = [UIColor blackColor];
//    _bottomBar.alpha = 1;
    [self.view addSubview:_bottomBar];
    
    _uploadBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, barHeight, barHeight)];
    _uploadBtn.center = CGPointMake(_bottomBar.frame.size.width-barHeight/2 - 10, _bottomBar.frame.size.height/2);
//    _uploadBtn.center = CGPointMake(_bottomBar.frame.size.width/2, _bottomBar.frame.size.height/2);
//    [_uploadBtn setTitle:@"同步" forState:UIControlStateNormal];
    [_uploadBtn setImage:[UIImage imageNamed:@"image_upload_none"] forState:UIControlStateNormal];
    [_uploadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bottomBar addSubview:_uploadBtn];
    [_uploadBtn setSelected:NO];
    [_uploadBtn addTarget:self action:@selector(uploadBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    _uploadBtn.hidden = !self.showPushBtn;
    
//    _uploadBtn.hidden = !self.showPushBtn;
    
    [self updateTollbarState];
}

- (void)uploadBtnClicked
{
    [_uploadBtn setSelected:!_uploadBtn.selected];
    if (_uploadBtn.selected) {
//        [_uploadBtn setTitle:@"取消同步" forState:UIControlStateNormal];
        [_uploadBtn setImage:[UIImage imageNamed:@"image_upload"] forState:UIControlStateNormal];
        [self uploadImageToGimi:[_photos objectAtIndex:_currentPhotoIndex]];
    }else
    {
//        [_uploadBtn setTitle:@"同步" forState:UIControlStateNormal];
        [_uploadBtn setImage:[UIImage imageNamed:@"image_upload_none"] forState:UIControlStateNormal];
//        [[ServerCommand instance] back];
    }
}

#pragma mark 创建UIScrollView
- (void)createScrollView
{
    CGRect frame = self.view.bounds;
    frame.origin.x -= kPadding;
    frame.size.width += (2 * kPadding);
	_photoScrollView = [[UIScrollView alloc] initWithFrame:frame];
	_photoScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_photoScrollView.pagingEnabled = YES;
	_photoScrollView.delegate = self;
	_photoScrollView.showsHorizontalScrollIndicator = NO;
	_photoScrollView.showsVerticalScrollIndicator = NO;
	_photoScrollView.backgroundColor = [UIColor clearColor];
    _photoScrollView.contentSize = CGSizeMake(frame.size.width * _photos.count, 0);
	[self.view addSubview:_photoScrollView];
    _photoScrollView.contentOffset = CGPointMake(_currentPhotoIndex * frame.size.width, 0);
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    if (photos.count > 1) {
        _visiblePhotoViews = [NSMutableSet set];
        _reusablePhotoViews = [NSMutableSet set];
    }
    
    for (int i = 0; i<_photos.count; i++) {
        MJPhoto *photo = _photos[i];
        photo.index = i;
        photo.firstShow = i == _currentPhotoIndex;
    }
}

#pragma mark 设置选中的图片
- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex
{
    _currentPhotoIndex = currentPhotoIndex;
    
    for (int i = 0; i<_photos.count; i++) {
        MJPhoto *photo = _photos[i];
        photo.firstShow = i == currentPhotoIndex;
    }
    
    if ([self isViewLoaded]) {
        _photoScrollView.contentOffset = CGPointMake(_currentPhotoIndex * _photoScrollView.frame.size.width, 0);
        
        // 显示所有的相片
        [self showPhotos];
    }
}

#pragma mark - MJPhotoView代理
- (void)photoViewSingleTap:(MJPhotoView *)photoView
{
    [UIApplication sharedApplication].statusBarHidden = _statusBarHiddenInited;
    self.view.backgroundColor = [UIColor clearColor];
    
    // 移除工具条
    [_toolbar removeFromSuperview];
    
    if(_uploadBtn.selected)
    {
//        [[ServerCommand instance] back];
    }
}

- (void)photoViewDidEndZoom:(MJPhotoView *)photoView
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)photoViewImageFinishLoad:(MJPhotoView *)photoView
{
    _toolbar.currentPhotoIndex = _currentPhotoIndex;
}

#pragma mark 显示照片
- (void)showPhotos
{
    // 只有一张图片
    if (_photos.count == 1) {
        [self showPhotoViewAtIndex:0];
        return;
    }
    
    CGRect visibleBounds = _photoScrollView.bounds;
	int firstIndex = (int)floorf((CGRectGetMinX(visibleBounds)+kPadding*2) / CGRectGetWidth(visibleBounds));
	int lastIndex  = (int)floorf((CGRectGetMaxX(visibleBounds)-kPadding*2-1) / CGRectGetWidth(visibleBounds));
    if (firstIndex < 0) firstIndex = 0;
    if (firstIndex >= _photos.count) firstIndex = _photos.count - 1;
    if (lastIndex < 0) lastIndex = 0;
    if (lastIndex >= _photos.count) lastIndex = _photos.count - 1;
	
	// 回收不再显示的ImageView
    NSInteger photoViewIndex;
	for (MJPhotoView *photoView in _visiblePhotoViews) {
        photoViewIndex = kPhotoViewIndex(photoView);
		if (photoViewIndex < firstIndex || photoViewIndex > lastIndex) {
			[_reusablePhotoViews addObject:photoView];
			[photoView removeFromSuperview];
		}
	}
    
	[_visiblePhotoViews minusSet:_reusablePhotoViews];
    while (_reusablePhotoViews.count > 2) {
        [_reusablePhotoViews removeObject:[_reusablePhotoViews anyObject]];
    }
	
	for (NSUInteger index = firstIndex; index <= lastIndex; index++) {
		if (![self isShowingPhotoViewAtIndex:index]) {
			[self showPhotoViewAtIndex:index];
		}
	}
}

#pragma mark 显示一个图片view
- (void)showPhotoViewAtIndex:(int)index
{
    MJPhotoView *photoView = [self dequeueReusablePhotoView];
    if (!photoView) { // 添加新的图片view
        photoView = [[MJPhotoView alloc] init];
        photoView.photoViewDelegate = self;
    }
    
    // 调整当期页的frame
    CGRect bounds = _photoScrollView.bounds;
    CGRect photoViewFrame = bounds;
    photoViewFrame.size.width -= (2 * kPadding);
    photoViewFrame.origin.x = (bounds.size.width * index) + kPadding;
    photoView.tag = kPhotoViewTagOffset + index;
    
    MJPhoto *photo = _photos[index];
    photoView.frame = photoViewFrame;
    photoView.photo = photo;
    
    [_visiblePhotoViews addObject:photoView];
    [_photoScrollView addSubview:photoView];
    
    [self loadImageNearIndex:index];
}

#pragma mark 加载index附近的图片
- (void)loadImageNearIndex:(int)index
{
    if (index > 0) {
        MJPhoto *photo = _photos[index - 1];
        //[SDWebImageManager downloadWithURL:photo.url];
        [[ [SDWebImageManager sharedManager] imageDownloader] downloadImageWithURL:photo.url options:nil progress:nil completed:nil];

        if (photo.assets != nil)
        {
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
            options.networkAccessAllowed = YES;
            options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
                /*
                 Progress callbacks may not be on the main thread. Since we're updating
                 the UI, dispatch to the main queue.
                 */
                
            };
            
            [[PHImageManager defaultManager] requestImageForAsset:photo.assets targetSize:CGSizeMake(2000, 2000) contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage *result, NSDictionary *info) {
                // Hide the progress view now the request has completed.
                
                // Check if the request was successful.
                if (!result) {
                    return;
                }
                photo.image = result;
            }];
        }
    }
    
    if (index < _photos.count - 1) {
        MJPhoto *photo = _photos[index + 1];
       // [SDWebImageManager downloadWithURL:photo.url];
         [[ [SDWebImageManager sharedManager] imageDownloader] downloadImageWithURL:photo.url options:nil progress:nil completed:nil];
        if (photo.assets != nil)
        {
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
            options.networkAccessAllowed = YES;
            options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
                /*
                 Progress callbacks may not be on the main thread. Since we're updating
                 the UI, dispatch to the main queue.
                 */
                
            };
            
            [[PHImageManager defaultManager] requestImageForAsset:photo.assets targetSize:CGSizeMake(2000, 2000) contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage *result, NSDictionary *info) {
                // Hide the progress view now the request has completed.
                
                // Check if the request was successful.
                if (!result) {
                    return;
                }
                photo.image = result;
            }];
        }
    }
}

#pragma mark index这页是否正在显示
- (BOOL)isShowingPhotoViewAtIndex:(NSUInteger)index {
	for (MJPhotoView *photoView in _visiblePhotoViews) {
		if (kPhotoViewIndex(photoView) == index) {
           return YES;
        }
    }
	return  NO;
}

#pragma mark 循环利用某个view
- (MJPhotoView *)dequeueReusablePhotoView
{
    MJPhotoView *photoView = [_reusablePhotoViews anyObject];
	if (photoView) {
		[_reusablePhotoViews removeObject:photoView];
	}
	return photoView;
}

#pragma mark 更新toolbar状态
- (void)updateTollbarState
{
    _currentPhotoIndex = _photoScrollView.contentOffset.x / _photoScrollView.frame.size.width;
    _toolbar.currentPhotoIndex = _currentPhotoIndex;
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self showPhotos];
    [self updateTollbarState];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_uploadBtn.selected == NO) {
        return;
    }
    [self uploadImageToGimi:[_photos objectAtIndex:_currentPhotoIndex]];
}

- (void)uploadImageToGimi:(MJPhoto *)photo
{
    UIImage *img = photo.image;
    if (!img) {
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        options.networkAccessAllowed = YES;
        options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
            /*
             Progress callbacks may not be on the main thread. Since we're updating
             the UI, dispatch to the main queue.
             */
            
        };
        
        [[PHImageManager defaultManager] requestImageForAsset:photo.assets targetSize:CGSizeMake(1000, 1000) contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage *result, NSDictionary *info) {
            // Hide the progress view now the request has completed.
            
            // Check if the request was successful.
            if (!result) {
                return;
            }
            [self sendImage:result];
        }];
    }
    [self sendImage:img];
}

- (void)sendImage:(UIImage *)img
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSDate *date = [NSDate date];
        NSTimeInterval time = [date timeIntervalSince1970];
        NSString *name = [NSString stringWithFormat:@"image-item-%lld.png", (long long)(time*1000)];
        NSString *path = _imageCachePath;
        
//        let prePath = Consts.pathNetCache
//        
//        if (!NSFileManager.defaultManager().fileExistsAtPath(prePath))
//        {
//            try? NSFileManager.defaultManager().createDirectoryAtPath(prePath, withIntermediateDirectories: true, attributes: nil)
//        }
        
        //        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSAllDomainsMask, YES) objectAtIndex:0];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        path = [path stringByAppendingPathComponent:name];
        
        NSData *imgData = UIImageJPEGRepresentation(img, 1);
        BOOL b = [imgData writeToFile:path atomically:YES];
        
    });
}

@end