//
//  UIScrollView+WSRefresh.swift
//  WSRefresh-swift
//
//  Created by Wilson-Yuan on 15/7/5.
//  Copyright (c) 2015年 wilson-yuan. All rights reserved.
//

import Foundation
import UIKit

var refreshActionClosure: (() ->()) = {}
let REFRESH_HEADER_TAG = 10
let REFRESH_FOOTER_TAG = 11
let WS_SCREEN_WIDTH = UIScreen.mainScreen().bounds.width

extension UIScrollView: UIScrollViewDelegate {

    var refreshHeader: WSRefreshNormalHeader? {
        get {
            var refreshHeader = viewWithTag(REFRESH_HEADER_TAG)
            return refreshHeader as? WSRefreshNormalHeader
        }
    }
    
    var refreshFooter: WSRefreshFooter? {
        get {
            var refreshFooter = viewWithTag(REFRESH_FOOTER_TAG)
            return refreshFooter as? WSRefreshFooter
        }
    
    }
    
    func addWSRefreshViewHeader(refreshAction: ()->()) {
        self.alwaysBounceVertical = true
        if self.refreshHeader == nil {
            var headView = WSRefreshNormalHeader(action: refreshAction,frame: CGRectZero);
            headView.tag = REFRESH_HEADER_TAG
            addSubview(headView)
        }
    }
    
    func andWSRefreshViewFooter(refreshAction: () ->()) {
    
        self.alwaysBounceVertical = true
        if self.refreshFooter == nil {
            var footerView = WSRefreshFooter(action: refreshAction, frame: CGRectZero);
            footerView.tag = REFRESH_FOOTER_TAG
            addSubview(footerView)
        }

    }
    
    func endHeaderRefreshing() {
        self.refreshHeader!.setState(.Default)
    }
    
    
    
    
}



/*!
WSRefreshViewState

- Default:
- Refreshing:
- Ended:
*/
enum WSRefreshViewState: Int {
    case Default
    case Pulling
    case Refreshing
    case WillRefresh
    case Ended
}



//Footer & header superClass
class WSRefreshComponent: UIView {
    
    var refreshAction: ((Void) ->(Void)) = {} //正在刷新回调 注: 如果不赋值则会出错
    var pullingPercent: CGFloat = 0 //拖拽百分比
    //refresh view height
    var viewHeight: CGFloat {
        set {
            self.frame = CGRectMake(0, -newValue, WS_SCREEN_WIDTH, newValue);
        }
        get {
            return self.frame.height
        }
    };
    
    var scrollOriginalInset = UIEdgeInsetsZero
    
    
    var scrollView = UIScrollView()
    var scrollPanGesture: UIPanGestureRecognizer?
    
    var state: WSRefreshViewState = .Default
    var autoChangeAlpha: Bool = false
    
    //MARK: -Method
    convenience init(action: ((Void) ->(Void)), frame: CGRect)  {
        self.init(frame: frame)
        self.refreshAction = action
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepare()
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    func prepare() {
        autoresizingMask = .FlexibleWidth
//        self.backgroundColor = UIColor.cyanColor()
    }
    
    /*!
    layout
    */
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setState(state: WSRefreshViewState) {
        self.state = state
    }
    
    /*!
    setHeader frame
    
    :param: newSuperview superView
    */
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        
        //
        if newSuperview != nil && newSuperview is UIScrollView {
            
//            self.removeObservers
            var sFrame = self.frame
            
            sFrame.size.width = newSuperview!.frame.width
            sFrame.origin.x = 0
            //get scrllerview
            scrollView = newSuperview as! UIScrollView
            
            scrollView.alwaysBounceVertical = true
            
            //get originalinset
            scrollOriginalInset = scrollView.contentInset
            
            //add observe
            self.addObservers()
            
        }
        
    }
    let WSREFRESH_KEY_PATH_CONTENT_OFFSET = "contentOffset"
    let WSREFRESH_KEY_PATH_CONTENT_INSET = "contentInset"
    let WSREFRESH_KEY_PATH_CONTENT_SIZE = "contentSize"
    let WSREFRESH_KEY_PATH_PAN_STATE = "state"
    
    
    func addObservers() {
        let observingOption: NSKeyValueObservingOptions = .New | .Old
        scrollView.addObserver(self, forKeyPath: WSREFRESH_KEY_PATH_CONTENT_OFFSET, options: observingOption, context: nil)
        
        scrollView.addObserver(self, forKeyPath: WSREFRESH_KEY_PATH_CONTENT_SIZE, options: observingOption, context: nil)
        
        scrollPanGesture = scrollView.panGestureRecognizer
        scrollPanGesture!.addObserver(self, forKeyPath: WSREFRESH_KEY_PATH_PAN_STATE, options: observingOption, context: nil)
    }
    
    func removeObservers() {
        self.removeObserver(self, forKeyPath: WSREFRESH_KEY_PATH_CONTENT_OFFSET)
        self.removeObserver(self, forKeyPath: WSREFRESH_KEY_PATH_CONTENT_SIZE, context: nil)
        self.removeObserver(self, forKeyPath: WSREFRESH_KEY_PATH_PAN_STATE, context: nil)
        scrollPanGesture = nil
    }
    
    //MARK: Observe
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        
        if userInteractionEnabled == false || hidden == true {
            return
        }
        
        if keyPath == WSREFRESH_KEY_PATH_CONTENT_OFFSET {
            self.scrollViewContentOffsetDidChange(change)
        } else if keyPath == WSREFRESH_KEY_PATH_CONTENT_SIZE {
            self.scrollViewContentSizeDidChange(change)
        } else if keyPath == WSREFRESH_KEY_PATH_CONTENT_INSET {
            self.scrollViewContentInsetDidChange(change)
        } else if keyPath == WSREFRESH_KEY_PATH_PAN_STATE {
            self.scrollViewPanGestureStateDidChange(change)
        }
        
    }
    
    //MARK: subClass method
    func scrollViewContentOffsetDidChange(change: NSDictionary) {
    
    }
    
    func scrollViewContentSizeDidChange(change: NSDictionary) {
    
    }
    
    func scrollViewContentInsetDidChange(change: NSDictionary) {
    
    }
    
    func scrollViewPanGestureStateDidChange(change: NSDictionary) {
    
    }
    
    
    //MARK:
    
    func beginRefreshing() {
        UIView.animateWithDuration(WSRefresh_Fast_Animation_Duration, animations: { () -> Void in
            self.alpha = 1.0
        })
        
        self.pullingPercent = 1.0
        //只要正在刷新 就完全显示
        
        if ((self.window) != nil) {
            self.setState( .Refreshing)
        } else {
            // 刷新(预防从另一个控制器回到这个控制器的情况，回来要重新刷新一下)
            self.setState( .WillRefresh)
            
            self.setNeedsDisplay()
        }
        
    
    }
    
    func endingRefreshing() {
    
    }
    
    //是否正在刷新
    func isRefreshing() -> Bool {
        return false
    }
    
    func excuteRefreshingClosure() {
        self.refreshAction()
    }
    
    
}
