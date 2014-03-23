//
//  MDScratchSampleViewController.m
//  blured-touch
//
//  Created by Andrew Kopanev on 1/21/14.
//
//

#import "MDScratchSampleViewController.h"
#import "MDScratchImageView.h"

@interface MDScratchSampleViewController () <MDScratchImageViewDelegate>
@end

@implementation MDScratchSampleViewController {
	__weak MDScratchImageView *_scratchView;
}

- (void)viewDidLoad {
	[super viewDidLoad];
    
	UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
	scrollView.contentInset = UIEdgeInsetsMake([[UIApplication sharedApplication] statusBarFrame].size.height, 0.0f, 0.0f, 0.0f);
	scrollView.canCancelContentTouches = NO;
	scrollView.delaysContentTouches = NO;
	[self.view addSubview:scrollView];
    
	UIImage *sharpImage = [UIImage imageNamed:@"paint01-01.png"];
	UIImage *bluredImage = [UIImage imageNamed:@"paint01-01blur.png"];
    
	CGFloat step = 10.0f;
	CGFloat currentY = step;
	CGFloat width = MIN(floorf(scrollView.bounds.size.width * 0.6f), sharpImage.size.width);
	CGFloat height = sharpImage.size.height * (width / sharpImage.size.width);
    
	//the covered image
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(floorf(scrollView.bounds.size.width * 0.5f - width * 0.5f), currentY, width, height)];
	imageView.image = sharpImage;
	[scrollView addSubview:imageView];
    
	//the overlay thats scratched away
	MDScratchImageView *scratchImageView = [[MDScratchImageView alloc] initWithFrame:imageView.frame];
	_scratchView = scratchImageView;
	scratchImageView.delegate = self;
	scratchImageView.userInteractionEnabled = NO;
	scratchImageView.image = bluredImage;
	[scrollView addSubview:scratchImageView];
	currentY = CGRectGetMaxY(scratchImageView.frame) + step;
    
	UIButton *buttonEllipse = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[buttonEllipse setTitle:@"Reveal Elipse" forState:UIControlStateNormal];
	buttonEllipse.frame = CGRectMake(10, currentY, 300, 44);
	[buttonEllipse addTarget:self action:@selector(revealEllipse) forControlEvents:UIControlEventTouchUpInside];
	[scrollView addSubview:buttonEllipse];
	currentY = CGRectGetMaxY(buttonEllipse.frame) + step;
    
	UIButton *buttonSquare = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[buttonSquare setTitle:@"Reveal Square" forState:UIControlStateNormal];
	buttonSquare.frame = CGRectMake(10, currentY, 300, 44);
	[buttonSquare addTarget:self action:@selector(revealSquare) forControlEvents:UIControlEventTouchUpInside];
	[scrollView addSubview:buttonSquare];
    
	scrollView.contentSize = CGSizeMake(scrollView.bounds.size.width, currentY);
}

#pragma mark - MDScratchImageViewDelegate

- (void)mdScratchImageView:(MDScratchImageView *)scratchImageView didChangeMaskingProgress:(CGFloat)maskingProgress {
	NSLog(@"%s %p progress == %.2f", __PRETTY_FUNCTION__, scratchImageView, maskingProgress);
}

#pragma mark actions

static CGPoint pt = { .x = 0, .y = 0 };

- (void)revealEllipse {
	static int r = 30;
    
	[_scratchView revealEllipseAtPoint:pt radius:r];
    
	pt.x += r * 2;
	if (pt.x >= _scratchView.image.size.width) {
		pt.y += r * 2;
		pt.x = 0;
	}
}

- (void)revealSquare {
	static int l = 60;
    
	[_scratchView revealSquareAtPoint:pt length:l];
    
	pt.x += l;
	if (pt.x >= _scratchView.image.size.width) {
		pt.y += l;
		pt.x = 0;
	}
}

@end
