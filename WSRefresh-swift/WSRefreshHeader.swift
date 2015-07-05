//
//  WSRefreshHeader.swift
//  WSRefresh-swift
//
//  Created by Wilson-Yuan on 15/7/5.
//  Copyright (c) 2015年 wilson-yuan. All rights reserved.
//

import Foundation
import UIKit

let WSREFRESH_HEADER_LAST_UPDATE_TIME_KEY = "WSREFRHER_HEADER_LAST_UPDATE_TIME_KEY"
let WSREFRESH_HEADER_HEIGHT: CGFloat = 64.0
let WSRefresh_Fast_Animation_Duration = 0.25
let WSRefresh_Slow_Animation_Duration = 0.4

class WSRefrshHeader: WSRefreshComponent {
    
    /** 这个key用来存储上一次下拉刷新成功的时间 */
    var lastUpdatedTimeKey = WSREFRESH_HEADER_LAST_UPDATE_TIME_KEY
    
    /** 上一次下拉刷新成功的时间 */

    var lastUpdatedTime: NSDate? {
        get{
            return NSUserDefaults.standardUserDefaults().objectForKey(lastUpdatedTimeKey) as? NSDate
        }
    }
    
    override func prepare() {
        super.prepare()
        
//        lastUpdatedTimeKey = WSREFRESH_HEADER_LAST_UPDATE_TIME_KEY
        self.viewHeight = WSREFRESH_HEADER_HEIGHT
        
    }

    //placeSubView
    override func setState(state: WSRefreshViewState) {
        
        if state == .Default {
            if self.state == .Refreshing { return }
            //save time
            NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: lastUpdatedTimeKey)
            NSUserDefaults.standardUserDefaults().synchronize()
            
            //回复inset 和 offset
            UIView.animateWithDuration(WSRefresh_Slow_Animation_Duration, animations: { () -> Void in
                self.scrollView.contentInset.top -= self.viewHeight
                
                //adjust alpha
                if self.autoChangeAlpha == true {
                    self.alpha = 0.0
                }
                
            }, completion: { (completion) -> Void in
                self.excuteRefreshingClosure()
            })
            
        } else if state == .Refreshing {
            UIView.animateWithDuration(WSRefresh_Fast_Animation_Duration, animations: { () -> Void in
                var top = self.scrollOriginalInset.top + self.viewHeight
                self.scrollView.contentInset.top = top
                
                //设置滚动区域
                self.scrollView.contentOffset.y = -top
                
            }, completion: { (complection) -> Void in
                self.excuteRefreshingClosure()
            })
        }
        
        super.setState(state)
    }
    
    override func endingRefreshing() {
        if self.scrollView is UICollectionView {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), { () -> Void in
//                
//            });
        }
        
        super.endingRefreshing()
    }
    override func excuteRefreshingClosure() {
        super.excuteRefreshingClosure()
    }
    
    
    override func scrollViewContentOffsetDidChange(change: NSDictionary) {
        super.scrollViewContentOffsetDidChange(change)
        
        if state == .Refreshing {
            return
        }
        //跳转到下一个控制器时, contentInset可能会变
        scrollOriginalInset = scrollView.contentInset
        
        //current scrollview contentOffset
        var offsetY = scrollView.contentOffset.y
        
        //默认的top y
        var originalOffsetY =  -scrollOriginalInset.top
        
        //向下滑动
        if offsetY >= originalOffsetY {
            return
        }
        
        var normalOffsetY = originalOffsetY - viewHeight
        
        var pullingPercent = (originalOffsetY - offsetY) / viewHeight
        
        if scrollView.dragging == true {
            self.pullingPercent = pullingPercent
            
            if state == .Default && offsetY < normalOffsetY {
                //即将刷新
                self.setState(.Pulling)
                
            } else if state == .Pulling && offsetY >= normalOffsetY {
                self.setState(.Default)   
            }
        } else if state == .Pulling { //开始刷新
            self.beginRefreshing()
        } else if pullingPercent < 1 {
            self.pullingPercent = pullingPercent
        }
    }
    
}

class WSRefreshStateHeader: WSRefrshHeader {
    var lastUpdatedTimeLabel = UILabel()
    var stateLabel = UILabel()
    var stateTitles:[Int : String] = [:]
//    var stateTitles = NSMutableDictionary()

    
    
    func setTitleWithState(title: String, state: WSRefreshViewState) {
//        stateTitles.updateValue(title, forKey: state)
        
        
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
}
class WSRefreshNormal: WSRefreshStateHeader {
    var arrowView = UIImageView(image: UIImage(named: "arrow"))
    var loadingView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    override func layoutSubviews() {
        super.layoutSubviews()

        var imageSize = arrowView.image?.size
        let arrwoCenterX = frame.size.width / 2
        
//        if
//arrowView.frame = CGRectMake(<#x: CGFloat#>, <#y: CGFloat#>, <#width: CGFloat#>, <#height: CGFloat#>)
        
        
    }
    
}

