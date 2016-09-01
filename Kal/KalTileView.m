/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalTileView.h"
#import "KalDate.h"
#import "KalPrivate.h"

extern const CGSize kTileSize;

@implementation KalTileView

@synthesize date;

- (id)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = NO;
    origin = frame.origin;
    [self setIsAccessibilityElement:YES];
    [self setAccessibilityTraits:UIAccessibilityTraitButton];
    [self resetState];
  }
  return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGFloat fontSize = 18.f;
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    UIColor *shadowColor = nil;
    UIColor *textColor = nil;
	
	if (self.belongsToAdjacentMonth) {
		textColor = [UIColor grayColor];
	}
	else {
		if ([[self.date NSDate] compare:[NSDate date]] == NSOrderedAscending) {
			[[UIColor whiteColor] setFill];
			CGContextFillRect(ctx, CGRectMake(0.f, 0.f, kTileSize.width-1, kTileSize.height-1));
		}
		
		if ([self isToday] ) {
			textColor = [UIColor blackColor];
		}
		else {
			textColor = [UIColor grayColor];
		}
	}
	
    if (flags.marked)
    {
        UIImage *image = [UIImage imageNamed:@"Kal.bundle/kal_tile_selected.png"
                                    inBundle:[NSBundle bundleForClass:[self class]]
               compatibleWithTraitCollection:nil];
        [[image stretchableImageWithLeftCapWidth:2 topCapHeight:0] drawInRect:CGRectMake(-2, -2, kTileSize.width+3, kTileSize.height+3)];
    }
    NSUInteger n = [self.date day];
    NSString *dayText = [NSString stringWithFormat:@"%lu", (unsigned long)n];
    const char *day = [dayText cStringUsingEncoding:NSUTF8StringEncoding];
    CGSize textSize = [dayText sizeWithAttributes:@{NSFontAttributeName: font}];

    CGFloat textX, textY;
    textX = roundf(0.5f * (kTileSize.width - textSize.width));
    textY = roundf(0.5f * (kTileSize.height - textSize.height));

    if (shadowColor) {
        [shadowColor setFill];
        textY += 1.f;
    }
  
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont fontWithName:font.fontName
                                                                     size:fontSize],
                                 NSForegroundColorAttributeName:textColor
                                 };
    NSString *text = [NSString stringWithUTF8String:day];
    [text drawAtPoint:CGPointMake(textX, textY) withAttributes:attributes];
}

- (void)resetState
{
  // realign to the grid
  CGRect frame = self.frame;
  frame.origin = origin;
  frame.size = kTileSize;
  self.frame = frame;
  
  date = nil;
  flags.type = KalTileTypeRegular;
  flags.highlighted = NO;
  flags.selected = NO;
  flags.marked = NO;
}

- (void)setDate:(KalDate *)aDate
{
  if (date == aDate)
    return;

  date = aDate;

  [self setNeedsDisplay];
}

- (BOOL)isSelected { return flags.selected; }

- (void)setSelected:(BOOL)selected
{
  if (flags.selected == selected)
    return;

  // workaround since I cannot draw outside of the frame in drawRect:
//  if (![self isToday])
  {
    CGRect rect = self.frame;
//    if (selected) {
//      rect.origin.x--;
//      rect.origin.y--;
//      rect.size.width++;
//      rect.size.height++;
//    } else {
//      rect.origin.x++;
//      rect.origin.y++;
//      rect.size.width--;
//      rect.size.height--;
//    }
    self.frame = rect;
  }
  
  flags.selected = selected;
  [self setNeedsDisplay];
}

- (BOOL)isHighlighted { return flags.highlighted; }

- (void)setHighlighted:(BOOL)highlighted
{
  if (flags.highlighted == highlighted)
    return;
  
  flags.highlighted = highlighted;
  [self setNeedsDisplay];
}

- (BOOL)isMarked { return flags.marked; }

- (void)setMarked:(BOOL)marked
{
  if (flags.marked == marked)
    return;
  
  flags.marked = marked;
  [self setNeedsDisplay];
}

- (KalTileType)type { return flags.type; }

- (void)setType:(KalTileType)tileType
{
  if (flags.type == tileType)
    return;
  
  // workaround since I cannot draw outside of the frame in drawRect:
  CGRect rect = self.frame;
//  if (tileType == KalTileTypeToday) {
//    rect.origin.x--;
//    rect.size.width++;
//    rect.size.height++;
//  } else if (flags.type == KalTileTypeToday) {
//    rect.origin.x++;
//    rect.size.width--;
//    rect.size.height--;
//  }
  self.frame = rect;
  
  flags.type = tileType;
  [self setNeedsDisplay];
}

- (BOOL)isToday { return flags.type == KalTileTypeToday; }

- (BOOL)belongsToAdjacentMonth { return flags.type == KalTileTypeAdjacent; }


@end
