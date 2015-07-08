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
    
}


class WSRefreshAutoFooter: WSRefreshFooter {

//    var
}