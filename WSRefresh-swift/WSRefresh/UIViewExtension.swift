//
//  UIViewExtension.swift
//  WSRefresh-swift
//
//  Created by YSC on 15/7/6.
//  Copyright (c) 2015年 wilson-yuan. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    var ws_x: CGFloat {
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
        
        get {
            return self.frame.origin.x
        }
    }
    
    var ws_y: CGFloat {
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin.y
        }
    }
    
    var ws_w: CGFloat {
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
        get {
            return self.frame.width
        }
    }
    var ws_h: CGFloat {
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
        get {
            return self.frame.height
        }
    }
    var ws_size: CGSize {
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
        get {
            return self.frame.size
        }
    }
    
    var ws_origin: CGPoint  {
        set {
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin
        }
    }
}