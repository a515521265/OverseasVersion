

#import "UIView+Cutter.h"

@implementation UIView (Cutter)

- (UIImage*)viewCutter
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size,NO,[[UIScreen mainScreen] scale]);
     [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    
    UIImage*img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

@end
