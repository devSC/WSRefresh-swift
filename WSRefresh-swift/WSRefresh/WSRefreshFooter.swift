//
//  WSRefreshFooter.swift
//  WSRefresh-swift
//
//  Created by Wilson-Yuan on 15/7/5.
//  Copyright (c) 2015年 wilson-yuan. All rights reserved.
//

import Foundation
import UIKit

class WSRefreshFooter: WSRefreshComponent {
    
    override func prepare() {
        super.prepare()
        
        self.ws_h = WSRefresh_Footer_Height
    }
    
    
    func noticeNoMoreData() {
        self.setState(.NoMoreData)
    }
    
    func resetNoMoreData() {
        self.setState(.Default)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}


class WSRefreshAutoFooter: WSRefreshFooter {

    /*!
    @brief  isAutoMaticallyRefresh
    */
    
    var autoMaticallyRefresh: Bool = true
    
 /// default = 1.0
    var appearencePercentTriggerAutoRefresh: CGFloat = 1.0
    
    
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        
        if newSuperview != nil {
            self.scrollView.ws_insetBottom += self.ws_h
            
            //Reset frame
            self.scrollViewContentSizeDidChange([:])
            
        } else {//Remove
            scrollView.ws_insetBottom -= self.ws_h
        }
    }

    //MARK: SuperClass
    override func prepare() {
        super.prepare()
    }
    
    override func scrollViewContentSizeDidChange(change: NSDictionary) {
        super.scrollViewContentSizeDidChange(change)
        
        self.ws_y = scrollView.ws_contentHeight
    }

    
    override func scrollViewContentOffsetDidChange(change: NSDictionary) {
        super.scrollViewContentOffsetDidChange(change)
        
        if self.state != .Default || !autoMaticallyRefresh || self.ws_h == 0 {return}
        
        //the scrollview content over a screen
        if scrollView.ws_insetTop + scrollView.ws_contentHeight > scrollView.ws_h {
            
            if scrollView.ws_offsetY > scrollView.ws_contentHeight - scrollView.ws_h + self.ws_h * self.appearencePercentTriggerAutoRefresh + scrollView.ws_insetBottom - self.ws_h {
                
                var old = change["old"] as? NSValue
                var new = change["new"] as? NSValue
                var oldP = old?.CGPointValue()
                var newP = new?.CGPointValue()
                if newP?.y > oldP?.y {
                    self.beginRefreshing()
                }
                
            }
        }
    }
    
    override func scrollViewPanGestureStateDidChange(change: NSDictionary) {
        super.scrollViewPanGestureStateDidChange(change)
        
        if self.state == .Default && scrollView.panGestureRecognizer.state == .Ended {
            if scrollView.ws_insetTop + scrollView.ws_contentHeight <= scrollView.ws_h { //不够一个屏幕
                
                if scrollView.ws_offsetY > -scrollView.ws_insetTop { //To top
                    self.beginRefreshing()
                }
            
            } else { //超出一个屏幕
                if scrollView.ws_offsetY > scrollView.ws_contentHeight + scrollView.ws_insetBottom - scrollView.ws_h {
                    self.beginRefreshing()
                }
            }
        }
    }
    
    override func setState(state: WSRefreshViewState) {
        super.setState(state)
        
        if state == .Refreshing {
            let popTime = dispatch_time(DISPATCH_TIME_NOW, (Int64)(0.5 * Double(NSEC_PER_SEC)))
            dispatch_after(popTime, dispatch_get_main_queue(), { () -> Void in
                self.excuteRefreshingClosure()
            })
        }
    }
    
    func setFooterHidden(hidden: Bool) {
        var lastHiddenState = self.hidden
        
        self.hidden = hidden
        
        if !lastHiddenState && hidden  {
            self.setState(.Default)
            scrollView.ws_insetBottom -= self.ws_h
        } else if lastHiddenState && !hidden {
            scrollView.ws_insetBottom += self.ws_h
        }
        self.scrollViewContentSizeDidChange([:])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

}

class WSRefreshAutoStateFooter: WSRefreshAutoFooter {
    
    ///
    var stateLabel: UILabel?
    
    var stateTitles = [Int : String]()
    var refreshingTitleHidden = false
    
    func setStateLabelTitle(title: String, state: WSRefreshViewState) {
        if !title.isEmpty {
            switch state {
            case .Default:
                stateTitles[1] = title
            case .NoMoreData:
                stateTitles[2] = title
            case .Pulling, .Refreshing, .WillRefresh:
                stateTitles[3] = title

            }
            self.stateLabel?.text = title
        }
    }
    
    func stateLabelTapped() {
        if self.state == .Default {
            self.beginRefreshing()
        }
    }
    
    
    override func prepare() {
        super.prepare()
        
        setStateLabelTitle(WSRefresh_AutoFooter_DefaultText, state: .Default)
        setStateLabelTitle(WSRefresh_AutoFooter_NoMoreDataText, state: .NoMoreData)
        setStateLabelTitle(WSRefresh_AutoFooter_RefreshingText, state: .Refreshing)
        
        stateLabel?.userInteractionEnabled = true
        let gesture = UIGestureRecognizer(target: self, action: "stateLabelTapped")
        stateLabel?.addGestureRecognizer(gesture)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if stateLabel == nil {
            stateLabel = UILabel(frame: self.bounds)
            stateLabel?.font = UIFont.boldSystemFontOfSize(14);
            stateLabel?.backgroundColor = UIColor.clearColor()
            stateLabel?.textColor = rgbColor(90, 90, 90);
            stateLabel?.autoresizingMask = .FlexibleWidth
            stateLabel?.textAlignment = .Center;
            stateLabel?.text = WSRefresh_AutoFooter_DefaultText
            addSubview(stateLabel!)
        }
    }
    
    override func setState(state: WSRefreshViewState) {
        super.setState(state)
        
        if refreshingTitleHidden && state == .Refreshing {
            stateLabel?.text = nil
        } else {
            switch state {
            case .Default:
                stateLabel?.text = stateTitles[1]
            case .Pulling, .Refreshing, .WillRefresh:
                stateLabel?.text = stateTitles[3]
            case .NoMoreData:
                stateLabel?.text = stateTitles[2]
            }
        }
    }
    
}

class WSRefreshAutoNormalFooter: WSRefreshAutoStateFooter {

    var indicatorViewStyle: UIActivityIndicatorViewStyle?
    private var loadingView: UIActivityIndicatorView?
    
    
    //MARK - Super View Method
    override func prepare() {
        super.prepare()
        indicatorViewStyle = .Gray
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var loadingCenterX = self.ws_w / 2
        if !refreshingTitleHidden {
            loadingCenterX -= 100
        }
        
        var loadingCenterY = self.ws_h * 0.5
        if loadingView == nil {
            loadingView = UIActivityIndicatorView()
            loadingView?.center = CGPoint(x: loadingCenterX, y: loadingCenterY)
            loadingView?.activityIndicatorViewStyle = indicatorViewStyle!
            addSubview(loadingView!)
        }
    }
    
    
    override func setState(state: WSRefreshViewState) {
        super.setState(state)
        
        if state == .NoMoreData || state == .Default {
            loadingView?.stopAnimating()
        } else if state == .Refreshing {
            loadingView?.startAnimating()
        }
    }
}







