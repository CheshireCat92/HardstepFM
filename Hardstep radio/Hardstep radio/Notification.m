//
//  Notification.m
//  Practice
//
//  Created by Alex Rodshtein on 12.08.13.
//  Copyright (c) 2013 Alex Rodshtein. All rights reserved.
//

#import "Notification.h"

@interface Notification ()

@end

@implementation Notification

static NSTimeInterval	FHdurationIO3;
static NSTimeInterval	FHdelayIO3;
static CGFloat			FHmScaleIO3;
static CGFloat			FHeScaleIO3;

+ (void) showMessage:(NSString *)message
{
	[self showMessage:message withDuration:DEFAULT_DURATION andDelay:DEFAULT_DELAY];
}

+ (void) showMessage:(NSString *)message withDuration:(NSTimeInterval)duration andDelay:(NSTimeInterval)delay {
	[self showMessage:message textAlignment:DEFAULT_TEXTALIGNMENT withDuration:duration andDelay:delay backgroundColor:nil borderColor:nil shadowColor:nil massageOffsetSize:CGSizeMake(DEFAULT_HTEXTOFFSET, DEFAULT_VTEXTOFFSET) borderWidth:DEFAULT_BORDERWIDTH shadowRadius:DEFAULT_RADIUS cornerRadius:DEFAULT_RADIUS startScale:DEFAULT_STARTSCALE middleScale:DEFAULT_MIDDLESCALE endScale:DEFAULT_ENDSCALE];
}

+ (void) showMessage:(NSString *)message
	   textAlignment:(UITextAlignment)textAlignment
		withDuration:(NSTimeInterval)duration
			andDelay:(NSTimeInterval)delay
	 backgroundColor:(UIColor *)backgroundColor
		 borderColor:(UIColor *)borderColor
		 shadowColor:(UIColor *)shadowColor
   massageOffsetSize:(CGSize)offsetSize
		 borderWidth:(CGFloat)borderWidth
		shadowRadius:(CGFloat)shadowRadius
		cornerRadius:(CGFloat)cornerRadius
		  startScale:(CGFloat)sScale
		 middleScale:(CGFloat)mScale
			endScale:(CGFloat)eScale;
{
	//Message label
	if ([[[UIApplication sharedApplication] keyWindow] viewWithTag:DEFAULT_VIEWTAG] != nil)
    {
		return;
	}
    
	UILabel *messageLabel = [[UILabel alloc] init];
	messageLabel.textAlignment = textAlignment;
	messageLabel.numberOfLines = 0;
	messageLabel.lineBreakMode = UILineBreakModeWordWrap;
	messageLabel.text = message;
	messageLabel.font = [UIFont fontWithName:DEFAULT_FONTNAME size:DEFAULT_FONTSIZE];
	messageLabel.textColor = [UIColor DEFAULT_TEXTCOLOR];
	messageLabel.backgroundColor = [UIColor clearColor];
	
    //Message size and rect
	CGSize messageSize = [message sizeWithFont:messageLabel.font
							 constrainedToSize:CGSizeMake(DEFAULT_MESSAGEWIDTH, 9999.0f)
								 lineBreakMode:UILineBreakModeWordWrap];
	CGRect messageRect = CGRectMake(offsetSize.width + borderWidth,
									offsetSize.height + borderWidth,
									messageSize.width,
									messageSize.height);
	messageLabel.frame = messageRect;
	messageSize.width += offsetSize.width*2.0f + borderWidth;
	messageSize.height += offsetSize.height*2.0f + borderWidth;
	messageRect = CGRectMake(0.0f, 0.0f, messageSize.width, messageSize.height);
	
    //Message view
	UIView *content = [[UIView alloc] init];
	content.frame = messageRect;
	if (backgroundColor != nil)
    {
		content.backgroundColor = backgroundColor;
	}
    else
    {
		content.backgroundColor = [UIColor colorWithRed:(60.0f/255.0f) green:(60.0f/255.0f) blue:(60.0f/255.0f) alpha:1.0f];
	}
    
	content.alpha = 0.8f;
	content.layer.cornerRadius = cornerRadius;
	content.layer.shadowRadius = shadowRadius;
	content.layer.masksToBounds = NO;
	content.layer.shadowOffset = CGSizeMake(0.0f, shadowRadius/2.0f);
	content.layer.shadowOpacity = 1.0f;
	if (shadowColor != nil)
    {
		content.layer.shadowColor = [shadowColor CGColor];
	}
	content.layer.borderWidth = borderWidth;
	if (borderColor != nil)
    {
		content.layer.borderColor = [borderColor CGColor];
	}
    else
    {
		content.layer.borderColor = [[UIColor colorWithRed:(128.0f/255.0f) green:(128.0f/255.0f) blue:(128.0f/255.0f) alpha:1.0f] CGColor];
	}
	content.layer.shadowPath = [UIBezierPath bezierPathWithRect:messageRect].CGPath;
	
    //Root view
	UIView *rootView = [[UIView alloc] init];
	rootView.tag = DEFAULT_VIEWTAG;
	rootView.frame = messageRect;
	
    //Compose views
	messageLabel.center = CGPointMake(messageSize.width/2.0f, messageSize.height/2.0f);
	[content addSubview:messageLabel];
	[rootView addSubview:content];
	
	//Animation
	rootView.alpha = 0.0f;
	rootView.center = [[UIApplication sharedApplication] keyWindow].center;
	if (sScale <= 0.0f)
    {
		sScale = 0.01f;
	}
	if (mScale <= 0.0f)
    {
		mScale = 0.01f;
	}
	if (eScale <= 0.0f)
    {
		eScale = 0.01f;
	}
	
	CGAffineTransform matrix = [self rotateNotification];
	rootView.transform = CGAffineTransformScale(matrix, sScale, sScale);
	[[[UIApplication sharedApplication] keyWindow] addSubview:rootView];
	
    FHdelayIO3 = delay;
    FHdurationIO3 = duration;
    FHmScaleIO3 = mScale;
    FHeScaleIO3 = eScale;
    [self FHNotificationIOS3Animation:@"FHNotificationAnimation_0" finished:nil context:nil];
    
}

+ (void) FHNotificationIOS3Animation:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	UIView *rootView = [[[UIApplication sharedApplication] keyWindow] viewWithTag:DEFAULT_VIEWTAG];
	if ([animationID isEqualToString:@"FHNotificationAnimation_0"]) {
		[UIView beginAnimations:@"FHNotificationAnimation_1" context:nil];
		[UIView setAnimationDuration:FHdurationIO3*0.66];
		[UIView setAnimationDelay:0.0];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		rootView.alpha = 0.66f;
		CGAffineTransform matrix = [self rotateNotification];
		rootView.transform = CGAffineTransformScale(matrix, FHmScaleIO3, FHmScaleIO3);
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(FHNotificationIOS3Animation:finished:context:)];
		[UIView commitAnimations];
		return;
	}
	if ([animationID isEqualToString:@"FHNotificationAnimation_1"]) {
		[UIView beginAnimations:@"FHNotificationAnimation_2" context:nil];
		[UIView setAnimationDuration:FHdurationIO3*0.33];
		[UIView setAnimationDelay:0.0];
		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
		rootView.alpha = 1.0f;
		rootView.transform = [self rotateNotification];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(FHNotificationIOS3Animation:finished:context:)];
		[UIView commitAnimations];
		return;
	}
	if ([animationID isEqualToString:@"FHNotificationAnimation_2"]) {
		[UIView beginAnimations:@"FHNotificationAnimation_3" context:nil];
		[UIView setAnimationDuration:FHdurationIO3];
		[UIView setAnimationDelay:FHdelayIO3];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
		rootView.alpha = 0.0f;
		CGAffineTransform matrix = [self rotateNotification];
		rootView.transform = CGAffineTransformScale(matrix, FHeScaleIO3, FHeScaleIO3);
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(FHNotificationIOS3Animation:finished:context:)];
		[UIView commitAnimations];
		return;
	}
	if ([animationID isEqualToString:@"FHNotificationAnimation_3"]) {
		[rootView removeFromSuperview];
	}
}


+ (NSInteger) getVersion {
	NSInteger i = 0;
	NSInteger v = 0;
	NSArray *versionArray = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
	NSEnumerator *enumerator = [versionArray objectEnumerator];
	id obj;
	while (obj = [enumerator nextObject]) {
		NSInteger multi = powf(100.0f, (2-i));
		v += multi*[obj intValue];
		i++;
	}
	return v;
}

+ (CGAffineTransform) rotateNotification
{
	switch ([UIApplication sharedApplication].statusBarOrientation)
    {
		case UIDeviceOrientationLandscapeLeft:
			return CGAffineTransformMakeRotation(M_PI_2);
			break;
		case UIDeviceOrientationLandscapeRight:
			return CGAffineTransformMakeRotation(-M_PI_2);
			break;
		case UIDeviceOrientationPortrait:
			return CGAffineTransformIdentity;
			break;
		case UIDeviceOrientationPortraitUpsideDown:
			return CGAffineTransformMakeRotation(M_PI);
			break;
		default:
			return CGAffineTransformIdentity;
			break;
	}
	return CGAffineTransformIdentity;
}

@end
