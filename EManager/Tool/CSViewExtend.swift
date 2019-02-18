//
//  CSViewExtend.swift
//  SP2P
//
//  Created by apple on 2017/11/24.
//  Copyright © 2017年 sls001. All rights reserved.
//

import UIKit
public let ScreenW = UIScreen.main.bounds.width
public let ScreenH = UIScreen.main.bounds.height
extension UIView {
    
    /*! x */
    public var x : CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    /*! y */
    public var y : CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var f = self.frame
            f.origin.y = newValue
            self.frame = f
        }
    }
    /*! width */
    public var w : CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            var f = self.frame
            f.size.width = newValue
            self.frame = f
        }
    }
    /*! height */
    public var h : CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            var f = self.frame
            f.size.height = newValue
            self.frame = f
        }
    }
    /*! origin */
    public var origin : CGPoint {
        get {
            return self.frame.origin
        }
        set {
            var f = self.frame
            f.origin = newValue
            self.frame = f
        }
    }
    /*! size */
    public var size : CGSize {
        get {
            return self.frame.size
        }
        set {
            var f = self.frame
            f.size = newValue
            self.frame = f
        }
    }
    /*! centerX */
    public var centerX : CGFloat {
        get {
            return self.center.x
        }
        set {
            var c = self.center
            c.x = newValue
            self.center = c
        }
    }
    /*! centerY */
    public var centerY : CGFloat {
        get {
            return self.center.y
        }
        set {
            var c = self.center
            c.y = newValue
            self.center = c
        }
    }
    /*! cBottom */
    public var cBtm : CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        set {
            var f = self.frame
            f.origin.y = cBtm - frame.size.height;
            self.frame = f
        }
    }
    
    /*! cRight */
    public var cRgt : CGFloat {
        get {
            return self.frame.size.width + self.frame.origin.x
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue - self.w;
            self.frame = frame
        }
    }
    
    /*! hexadecimal color 十六进制颜色 */
    public func RGBA16(value: Int, Alpha: CGFloat) -> (UIColor) {
        return UIColor(red: ((CGFloat)((value & 0xFF0000) >> 16)) / 255.0,
                       green: ((CGFloat)((value & 0xFF00) >> 8)) / 255.0,
                       blue: ((CGFloat)(value & 0xFF)) / 255.0,
                       alpha: Alpha)
    }
    
    func s(size : CGFloat) -> CGFloat {
        return (UIScreen.main.bounds.size.width / 375.0) * size
    }
    
    public func roundingCorners( corner:CGFloat) {
        let maskPath = UIBezierPath.init(roundedRect: self.bounds,
                                         byRoundingCorners: [UIRectCorner.topLeft, UIRectCorner.topRight],
                                         cornerRadii: CGSize(width: corner, height: corner))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
}

//func imgRotatioin(_ img:UIImage,_ orientation:UIImage.Orientation) ->UIImage{
//    let rotate:Double = 0.0
//    let rect = CGRect(x: 0, y: 0, width: 0, height: 0)
//    let translateX:Float = 0
//    let translateY:Float = 0
//    let scaleX = 1.0
//    let scaleY = 1.0

//    switch (orientation) {
//                    case .left:
//                                  rotate = M_PI_2
//                                  rect = CGRect((0,0,, image.size.width);)
//                                  translateX=0;
//                                  translateY= -rect.size.width;
//                                  scaleY =rect.size.width/rect.size.height;
//                                  scaleX =rect.size.height/rect.size.width;
//                                break
//
//                    case UIImageOrientationRight:
//
//                                  rotate =3 *M_PI_2;
//
//                                  rect =CGRectMake(0,0,image.size.height, image.size.width);
//
//                                  translateX= -rect.size.height;
//
//                                  translateY=0;
//
//                                  scaleY =rect.size.width/rect.size.height;
//
//                                  scaleX =rect.size.height/rect.size.width;
//
//                                break;
//
//                    case UIImageOrientationDown:
//
//                                  rotate =M_PI;
//
//                                  rect =CGRectMake(0,0,image.size.width, image.size.height);
//
//                                  translateX= -rect.size.width;
//
//                                  translateY= -rect.size.height;
//
//                                break;
//
//                    default:
//
//                                  rotate =0.0;
//
//                                  rect =CGRectMake(0,0,image.size.width, image.size.height);
//
//                                  translateX=0;
//
//                                  translateY=0;
//
//                                break;
//
//                }
//}
/*
     switch (orientation) {
 
                         case UIImageOrientationLeft:
 
                                             rotate =M_PI_2;
 
                                             rect =CGRectMake(0,0,image.size.height, image.size.width);
 
                                             translateX=0;
 
                                             translateY= -rect.size.width;
 
                                             scaleY =rect.size.width/rect.size.height;
 
                                             scaleX =rect.size.height/rect.size.width;
 
                                         break;
 
                         case UIImageOrientationRight:
 
                                             rotate =3 *M_PI_2;
 
                                             rect =CGRectMake(0,0,image.size.height, image.size.width);
 
                                             translateX= -rect.size.height;
 
                                             translateY=0;
 
                                             scaleY =rect.size.width/rect.size.height;
 
                                             scaleX =rect.size.height/rect.size.width;
 
                                         break;
 
                         case UIImageOrientationDown:
 
                                             rotate =M_PI;
 
                                             rect =CGRectMake(0,0,image.size.width, image.size.height);
 
                                             translateX= -rect.size.width;
 
                                             translateY= -rect.size.height;
 
                                         break;
 
                         default:
 
                                             rotate =0.0;
 
                                             rect =CGRectMake(0,0,image.size.width, image.size.height);
 
                                             translateX=0;
 
                                             translateY=0;
 
                                         break;
 
                 }
 
                 
 
             UIGraphicsBeginImageContext(rect.size);
 
         CGContextRef context =UIGraphicsGetCurrentContext();
 
             //做CTM变换
 
                 CGContextTranslateCTM(context, 0.0, rect.size.height);
 
                 CGContextScaleCTM(context, 1.0, -1.0);
 
                 CGContextRotateCTM(context, rotate);
 
                 CGContextTranslateCTM(context, translateX,translateY);
 
                 
 
                 CGContextScaleCTM(context, scaleX,scaleY);
 
             //绘制图片
 
                 CGContextDrawImage(context, CGRectMake(0,0,rect.size.width, rect.size.height), image.CGImage);
 
                 
 
         UIImage *newPic =UIGraphicsGetImageFromCurrentImageContext();
 
                 
 
                 return newPic;
 
 }
 */
