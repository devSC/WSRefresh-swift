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

extension UIScrollView {
    //MARK: Inset
    var ws_insetTop: CGFloat {
        set {
            var inset = contentInset
            inset.top = newValue
            contentInset = inset
        }
        
        get {
            return contentInset.top
        }
    }
    
    var ws_insetBottom: CGFloat {
        set {
            var inset = contentInset
            inset.bottom = newValue
            contentInset = inset
        }
        get {
            return contentInset.bottom
        }
    }
    
    var ws_insetLeft: CGFloat {
        set {
            var inset = contentInset
            inset.left = newValue
            contentInset = inset
        }
        get {
            return contentInset.left
        }

    }
    
    var ws_insetRight: CGFloat {
        set {
            var inset = contentInset
            inset.right = newValue
            contentInset = inset
        }
        get {
            return contentInset.right
        }
    }
    
    //MARK: Offset
    
    var ws_offsetX: CGFloat {
        set {
            var offset = contentOffset
            offset.x = newValue
            contentOffset = offset
        }
        get {
            return contentOffset.x
        }
    }
    
    var ws_offsetY: CGFloat {
        set {
            var offset = contentOffset
            offset.y = newValue
            contentOffset = offset
        }
        get {
            return contentOffset.y
        }
    }
    
    //MARK: ContentSize
    var ws_contentWidth: CGFloat {
        set {
            var size = contentSize
            size.width = newValue
            contentSize = size
        }
        
        get {
            return contentSize.width
        }
    }
    
    var ws_contentHeight: CGFloat {
        set {
            var size = contentSize
            size.height = newValue
            contentSize = size
        }
        
        get {
            return contentSize.height
        }
    }
}














