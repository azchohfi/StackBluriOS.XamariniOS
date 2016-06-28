using System;

using ObjCRuntime;
using Foundation;
using UIKit;

namespace StackBluriOS.XamariniOS
{
    // @interface StackBlur (UIImage)
    [Category]
    [BaseType(typeof(UIImage))]
    interface UIImage_StackBlur
    {
        // -(UIImage *)stackBlur:(NSUInteger)radius;
        [Export("stackBlur:")]
        UIImage StackBlur(nuint radius);

        // -(UIImage *)normalize;
        [Export("normalize")]
        UIImage Normalize();
    }
}
