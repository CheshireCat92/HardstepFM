//
//  Notification.h
//  Practice
//
//  Created by Alex Rodshtein on 12.08.13.
//  Copyright (c) 2013 Alex Rodshtein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


#define DEFAULT_VIEWTAG			2000

#define DEFAULT_DELAY			0.9
#define DEFAULT_DURATION		0.35
#define DEFAULT_STARTSCALE		0.8
#define DEFAULT_MIDDLESCALE		1.1
#define DEFAULT_ENDSCALE		1.2
#define DEFAULT_FONTNAME		@"Helvetica-Bold"
#define DEFAULT_FONTSIZE		15.0f
#define DEFAULT_TEXTCOLOR		whiteColor
#define DEFAULT_TEXTALIGNMENT	UITextAlignmentCenter
#define DEFAULT_VTEXTOFFSET		10.0f
#define DEFAULT_HTEXTOFFSET		10.0f
#define DEFAULT_RADIUS			8.0f
#define DEFAULT_BORDERWIDTH		1.0f
#define DEFAULT_MESSAGEWIDTH	160.0f

@interface Notification : UIViewController
{
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

+ (void) showMessage:(NSString *)message;

+ (NSInteger) getVersion;

+ (CGAffineTransform) rotateNotification;

@end
