//
//  DejalActivityView.m
//  Dejal Open Source
//

#import "DejalActivityView.h"
#import <QuartzCore/QuartzCore.h>


@interface DejalActivityView ()

@property (nonatomic, strong) UIView *originalView;
@property (nonatomic, strong) UIView *borderView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UILabel *activityLabel;

@end


// ----------------------------------------------------------------------------------------
// MARK: -
// ----------------------------------------------------------------------------------------


@implementation DejalActivityView

@synthesize originalView, borderView, activityIndicator, activityLabel, labelWidth;

static DejalActivityView *dejalActivityView = nil;

/*
 currentActivityView
 
 Returns the currently displayed activity view, or nil if there isn't one.
 
 Written by DJS 2009-07.
*/

+ (DejalActivityView *)currentActivityView;
{
    return dejalActivityView;
}

/*
 activityViewForView:
 
 Creates and adds an activity view centered within the specified view, using the label "Loading...".  Returns the activity view, already added as a subview of the specified view.
 
 Written by DJS 2009-07.
 Changed by DJS 2010-06 to add "new" prefix to the method name to make it clearer that this returns a retained object.
 Changed by DJS 2011-08 to remove the "new" prefix again.
*/

+ (DejalActivityView *)activityViewForView:(UIView *)addToView;
{
    return [self activityViewForView:addToView withLabel:NSLocalizedString(@"Loading...", @"Default DejalActivtyView label text") width:0];
}

/*
 activityViewForView:withLabel:
 
 Creates and adds an activity view centered within the specified view, using the specified label.  Returns the activity view, already added as a subview of the specified view.
 
 Written by DJS 2009-07.
 Changed by DJS 2010-06 to add "new" prefix to the method name to make it clearer that this returns a retained object.
 Changed by DJS 2011-08 to remove the "new" prefix again.
*/

+ (DejalActivityView *)activityViewForView:(UIView *)addToView withLabel:(NSString *)labelText;
{
    return [self activityViewForView:addToView withLabel:labelText width:0];
}

/*
 activityViewForView:withLabel:width:
 
 Creates and adds an activity view centered within the specified view, using the specified label and a fixed label width.  The fixed width is useful if you want to change the label text while the view is visible.  Returns the activity view, already added as a subview of the specified view.
 
 Written by DJS 2009-07.
 Changed by DJS 2010-06 to add "new" prefix to the method name to make it clearer that this returns a retained object.
 Changed by DJS 2011-08 to remove the "new" prefix again, and move the singleton stuff to here.
*/

+ (DejalActivityView *)activityViewForView:(UIView *)addToView withLabel:(NSString *)labelText width:(NSUInteger)aLabelWidth;
{
    // Immediately remove any existing activity view:
    if (dejalActivityView)
        [self removeView];
    
    // Remember the new view (so this is a singleton):
    dejalActivityView = [[self alloc] initForView:addToView withLabel:labelText width:aLabelWidth];
    
    return dejalActivityView;
}

/*
 initForView:withLabel:width:
 
 Designated initializer.  Configures the activity view using the specified label text and width, and adds as a subview of the specified view.
 
 Written by DJS 2009-07.
 Changed by DJS 2011-08 to move the singleton stuff to the calling class method, where it should be.
*/

- (DejalActivityView *)initForView:(UIView *)addToView withLabel:(NSString *)labelText width:(NSUInteger)aLabelWidth;
{
	if (!(self = [super initWithFrame:CGRectZero]))
		return nil;
	
    // Allow subclasses to change the view to which to add the activity view (e.g. to cover the keyboard):
    self.originalView = addToView;
    addToView = [self viewForView:addToView];
    
    // Configure this view (the background) and its subviews:
    [self setupBackground];
    self.labelWidth = aLabelWidth;
    self.borderView = [self makeBorderView];
    self.activityIndicator = [self makeActivityIndicator];
    self.activityLabel = [self makeActivityLabelWithText:labelText];
    
    // Assemble the subviews:
	[addToView addSubview:self];
    [self addSubview:self.borderView];
    [self.borderView addSubview:self.activityIndicator];
    [self.borderView addSubview:self.activityLabel];
    
	// Animate the view in, if appropriate:
	[self animateShow];
    
	return self;
}

- (void)dealloc;
{
    if ([dejalActivityView isEqual:self])
        dejalActivityView = nil;
}

/*
 removeView
 
 Immediately removes and releases the view without any animation.
 
 Written by DJS 2009-07.
 Changed by DJS 2009-09 to disable the network activity indicator if it was shown by this view.
*/

+ (void)removeView;
{
    if (!dejalActivityView)
        return;
    
    
    [dejalActivityView removeFromSuperview];
    
    // Remove the global reference:
    dejalActivityView = nil;
}

/*
 viewForView:
 
 Returns the view to which to add the activity view.  By default returns the same view.  Subclasses may override this to change the view.
 
 Written by DJS 2009-07.
*/

- (UIView *)viewForView:(UIView *)view;
{
    return view;
}

/*
 enclosingFrame
 
 Returns the frame to use for the activity view.  Defaults to the superview's bounds.  Subclasses may override this to use something different, if desired.
 
 Written by DJS 2009-07.
*/

- (CGRect)enclosingFrame;
{
    return self.superview.bounds;
}

/*
 setupBackground
 
 Configure the background of the activity view.
 
 Written by DJS 2009-07.
*/

- (void)setupBackground;
{
	self.opaque = NO;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
   }

/*
 makeBorderView
 
 Returns a new view to contain the activity indicator and label.  By default this view is transparent.  Subclasses may override this method, optionally calling super, to use a different or customized view.
 
 Written by DJS 2009-07.
 Changed by DJS 2011-11 to simplify and make it easier to override.
*/

- (UIView *)makeBorderView;
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    
    view.opaque = NO;
    view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

/*
 makeActivityIndicator
 
 Returns a new activity indicator view.  Subclasses may override this method, optionally calling super, to use a different or customized view.
 
 Written by DJS 2009-07.
 Changed by DJS 2011-11 to simplify and make it easier to override.
*/

- (UIActivityIndicatorView *)makeActivityIndicator;
{
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
     [indicator startAnimating];
    
    return indicator;
}

/*
 makeActivityLabelWithText:
 
 Returns a new activity label.  Subclasses may override this method, optionally calling super, to use a different or customized view.
 
 Written by DJS 2009-07.
 Changed by DJS 2011-11 to simplify and make it easier to override.
 Changed by chrisledet 2013-01 to use NSTextAlignmentLeft instead of the deprecated UITextAlignmentLeft.
*/

- (UILabel *)makeActivityLabelWithText:(NSString *)labelText;
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.shadowColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.text = labelText;
    
    return label;
}

/*
 layoutSubviews
 
 Positions and sizes the various views that make up the activity view, including after rotation.
 
 Written by DJS 2009-07.
*/

- (void)layoutSubviews;
{
    self.frame = [self enclosingFrame];
    
    // If we're animating a transform, don't lay out now, as can't use the frame property when transforming:
    if (!CGAffineTransformIsIdentity(self.borderView.transform))
        return;
    
    CGSize textSize;
    if ([self.activityLabel.text respondsToSelector:@selector(sizeWithAttributes:)]) {
        textSize = [self.activityLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[UIFont systemFontSize]]}];
    }
    else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        textSize = [self.activityLabel.text sizeWithFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]];
#pragma clang diagnostic pop
    }

    // Use the fixed width if one is specified:
    if (self.labelWidth > 10)
        textSize.width = self.labelWidth;
    
    self.activityLabel.frame = CGRectMake(self.activityLabel.frame.origin.x, self.activityLabel.frame.origin.y, textSize.width+20, textSize.height+20);
    
    // Calculate the size and position for the border view: with the indicator to the left of the label, and centered in the receiver:
	CGRect borderFrame = CGRectZero;
    borderFrame.size.width =self.activityIndicator.frame.size.width + textSize.width + 70.0;
    borderFrame.size.height = self.activityIndicator.frame.size.height + 40.0;
    borderFrame.origin.x = floor(0.5 * (self.frame.size.width - borderFrame.size.width));
    borderFrame.origin.y = floor(0.5 * (self.frame.size.height - borderFrame.size.height - 20.0));
    self.borderView.frame = borderFrame;
	
    // Calculate the position of the indicator: vertically centered and at the left of the border view:
    CGRect indicatorFrame = self.activityIndicator.frame;
    indicatorFrame.origin.x = 30.0;
	indicatorFrame.origin.y = 0.5 * (borderFrame.size.height - indicatorFrame.size.height);
    self.activityIndicator.frame = indicatorFrame;
    
    // Calculate the position of the label: vertically centered and at the right of the border view:
	CGRect labelFrame = self.activityLabel.frame;
    labelFrame.origin.x = borderFrame.size.width - labelFrame.size.width;
	labelFrame.origin.y = floor(0.5 * (borderFrame.size.height - labelFrame.size.height));
    self.activityLabel.frame = labelFrame;
}

/*
 animateShow
 
 Animates the view into visibility.  Does nothing for the simple activity view.
 
 Written by DJS 2009-07.
*/

- (void)animateShow;
{
    // Does nothing by default
}

/*
 animateRemove
 
 Animates the view out of visibiltiy.  Does nothng for the simple activity view.
 
 Written by DJS 2009-07.
*/

- (void)animateRemove;
{
    // Does nothing by default
}

@end


// ----------------------------------------------------------------------------------------
// MARK: -
// ----------------------------------------------------------------------------------------

