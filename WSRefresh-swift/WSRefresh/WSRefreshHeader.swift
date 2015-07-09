//
//  WSRefreshHeader.swift
//  WSRefresh-swift
//
//  Created by Wilson-Yuan on 15/7/5.
//  Copyright (c) 2015年 wilson-yuan. All rights reserved.
//

import Foundation
import UIKit

func rgbColor(r: CGFloat, g: CGFloat, b: CGFloat) ->UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1)
}



class WSRefrshHeader: WSRefreshComponent {
    
    /** 这个key用来存储上一次下拉刷新成功的时间 */
    var lastUpdatedTimeKey = WSRefresh_Header_Last_Update_Time_Key
    
    
    /** 上一次下拉刷新成功的时间 */

    var lastUpdatedTime: NSDate? {
        get{
            return NSUserDefaults.standardUserDefaults().objectForKey(lastUpdatedTimeKey) as? NSDate
        }
    }
    func setLastUpdatedTime(timeKey: String) {
        lastUpdatedTimeKey = timeKey
        
    }
    
    override func prepare() {
        super.prepare()
        
//        lastUpdatedTimeKey = WSREFRESH_HEADER_LAST_UPDATE_TIME_KEY
        self.viewHeight = WSRefresh_Header_Height
        
    }

    //placeSubView
    override func setState(state: WSRefreshViewState) {
        
        if state == .Default {
            if self.state == .Refreshing {
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
                    self.pullingPercent = 0.0
                })
            }
           
            
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
            let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC))) // 1
            dispatch_after(popTime, dispatch_get_main_queue(), { () -> Void in
              super.endingRefreshing()
            });
        } else {
            super.endingRefreshing()
        }
        
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

        if offsetY >= originalOffsetY {
            return
        }
        
        var normalOffsetY = originalOffsetY - self.ws_h

        var pullingPercent = (originalOffsetY - offsetY) / self.ws_h
        
        if scrollView.dragging == true {
            
            self.pullingPercent = pullingPercent
            
            if state == .Default && offsetY < normalOffsetY { //Will Refresh
                self.setState(.Pulling)
            } else if state == .Pulling && offsetY >= normalOffsetY { //Set To Default
                self.setState(.Default)
            }
        } else if state == .Pulling { //Start refresh
            self.beginRefreshing()
        } else if pullingPercent < 1 {
            self.pullingPercent = pullingPercent
        }
    }
    
}

class WSRefreshStateHeader: WSRefrshHeader {
    var lastUpdatedTimeLabel: UILabel?
    var stateLabel: UILabel?
    
//    var lastUpdatedTimeLabel! = UILabel()
//    var stateLabel! = UILabel()
    
    
    var stateTitles = Dictionary<Int, String>()
    
//    var stateTitles = NSMutableDictionary()

    
    
    func setTitleWithState(title: String, state: WSRefreshViewState) {

        switch state {
            
        case .Default:
            stateTitles[1] = title

        case .Pulling:
            stateTitles[2] = title

        case .Refreshing:
            stateTitles[3] = title
        case .WillRefresh:
            stateTitles[4] = title
        case .NoMoreData:
            stateTitles[5] = title
            
        }
        
        self.stateLabel?.text = title
    }
    
    override func prepare() {
        super.prepare()
        
        //初始化文字
        self.setTitleWithState(WSRefresh_Header_DefaultText, state: .Default)
        self.setTitleWithState(WSRefresh_Header_PullingText, state: .Pulling)
        self.setTitleWithState(WSRefresh_Header_RefreshingText, state: .Refreshing)
        
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if stateLabel == nil {
            stateLabel = UILabel()
            stateLabel!.textAlignment = .Center
            stateLabel!.font = UIFont.boldSystemFontOfSize(14)
            stateLabel!.textColor = rgbColor(90, 90, 90)
            stateLabel!.autoresizingMask = .FlexibleWidth
            stateLabel!.backgroundColor = UIColor.clearColor()
            stateLabel?.text = stateTitles[1]

            addSubview(stateLabel!)
        }
        
        if lastUpdatedTimeLabel == nil {
            lastUpdatedTimeLabel = UILabel()
            
            lastUpdatedTimeLabel!.textAlignment = .Center
            lastUpdatedTimeLabel!.font = UIFont.boldSystemFontOfSize(14)
            lastUpdatedTimeLabel!.textColor = rgbColor(90, 90, 90)
            lastUpdatedTimeLabel!.autoresizingMask = .FlexibleWidth
            lastUpdatedTimeLabel!.backgroundColor = UIColor.clearColor()
            addSubview(lastUpdatedTimeLabel!)
            
            self.setState(.Default)
        }

        
        
        
        if stateLabel!.hidden == true {
            return
        }
        
        if lastUpdatedTimeLabel!.hidden == true {
            //状态
            stateLabel!.frame = bounds
        } else {
            //状态
            stateLabel!.ws_x = 0
            stateLabel!.ws_y = 0
            stateLabel!.ws_w = self.ws_w
            stateLabel!.ws_h = self.ws_h * 0.5
            
            //更新时间
            lastUpdatedTimeLabel!.ws_x = 0
            lastUpdatedTimeLabel!.ws_y = stateLabel!.ws_h
            lastUpdatedTimeLabel!.ws_w = self.ws_w
            lastUpdatedTimeLabel!.ws_h = self.ws_h - self.lastUpdatedTimeLabel!.ws_y
        }
        
    }
    
    override func setState(state: WSRefreshViewState) {
        super.setState(state)
        
        switch state {
        case .Default:
            stateLabel?.text = stateTitles[1]
        case .Pulling:
            stateLabel?.text = stateTitles[2]
        case .Refreshing:
            stateLabel?.text = stateTitles[3]
        case .WillRefresh:
            stateLabel?.text = stateTitles[4]

        case .NoMoreData:
            stateLabel?.text = stateTitles[5]
        }
        
//        lastUpdatedTimeKey = self.lastUpdatedTimeKey
        self.setLastUpdatedTime(self.lastUpdatedTimeKey)
        
    }
    
    override func setLastUpdatedTime(timeKey: String) {
        super.setLastUpdatedTime(timeKey)
        
        var lastUpdateTime = NSUserDefaults.standardUserDefaults().objectForKey(timeKey) as? NSDate
        /*
        // 如果有block
        if (self.lastUpdatedTimeText) {
        self.lastUpdatedTimeLabel.text = self.lastUpdatedTimeText(lastUpdatedTime);
        return;
        }
        */
        if lastUpdatedTime != nil {
            //获得年月日
            var calendar = NSCalendar.currentCalendar()
            let unitFlags: NSCalendarUnit = .CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitHour | .CalendarUnitMinute
            
            var cmp1: NSDateComponents = calendar.components(unitFlags, fromDate: lastUpdatedTime!)
            var cmp2: NSDateComponents  = calendar.components(unitFlags, fromDate: NSDate())
            
            //格式化日期
            var formatter = NSDateFormatter()
        
            if cmp1.day == cmp2.day {
                formatter.dateFormat = "今天 HH:mm"
            } else if (cmp1.year == cmp2.year) {
                formatter.dateFormat = "MM-dd HH:mm"
            } else {
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
            }
            
            var time = formatter.stringFromDate(lastUpdatedTime!)
            
            //显示日期
            lastUpdatedTimeLabel?.text = "最后更新: \(time)"
            
        } else {
            lastUpdatedTimeLabel?.text = "最后更新: 无记录"
        }
    }
}


//一般
class WSRefreshNormalHeader: WSRefreshStateHeader {
    var arrowView: UIImageView?
    var loadingView: UIActivityIndicatorView?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if arrowView == nil {
            
            arrowView = UIImageView(image: UIImage(named: "arrow"))
            addSubview(arrowView!)
        }
        if loadingView == nil {
            loadingView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            addSubview(loadingView!)
        }
        
        var imageSize = arrowView!.image?.size
        var arrwoCenterX = self.ws_w * 0.5
        if stateLabel!.hidden == false {
            arrwoCenterX -= 100
        }
        
        var arrowCenterY = self.ws_h * 0.5
        arrowView!.center = CGPoint(x: arrwoCenterX, y: arrowCenterY)

        
        //圈圈
        loadingView!.frame = arrowView!.frame

    }
    
    
    
    override func setState(state: WSRefreshViewState) {

        
        switch state {
        case .Default:
            if self.state == .Refreshing {
                arrowView?.transform = CGAffineTransformIdentity
                UIView.animateWithDuration(WSRefresh_Slow_Animation_Duration, animations: { () -> Void in
                    self.loadingView?.alpha = 0.0
                }, completion: { (completion) -> Void in
                    if self.state != .Default {
                        return
                    }
                    
                    self.loadingView?.alpha = 1.0
                    self.loadingView?.stopAnimating()
                    self.arrowView?.hidden = false
                })
            } else {
                loadingView?.stopAnimating()
                arrowView?.hidden = false
                
                UIView.animateWithDuration(WSRefresh_Fast_Animation_Duration, animations: { () -> Void in
                    self.arrowView?.transform = CGAffineTransformIdentity
                }, completion: { (completion) -> Void in
                    
                })
            }
        case .Pulling:
            loadingView?.stopAnimating()
            arrowView?.hidden = false
            
            UIView.animateWithDuration(WSRefresh_Fast_Animation_Duration, animations: { () -> Void in
                self.arrowView?.transform = CGAffineTransformMakeRotation(CGFloat(0.00001 - M_PI))
            })
            
        case .Refreshing:
            loadingView?.alpha = 1.0 //防止refreshing -> default的动画完毕动作没有被执行
            loadingView?.startAnimating()
            arrowView?.hidden = true
            
        case .NoMoreData, .WillRefresh:
            println("AnimationEnding")
        }
        super.setState(state)
    }
}

