//
//  ViewController.swift
//  WSRefresh-swift
//
//  Created by Wilson-Yuan on 15/7/5.
//  Copyright (c) 2015年 wilson-yuan. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.addWSRefreshViewHeader { () -> (Void) in
            println("Start Refreshing")
//            let delayInSeconds = 1.0
//            let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * NSEC_PER_SEC)) // 1
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), { () -> Void in
                self.tableView.endHeaderRefreshing()
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

class CollectionVC: UICollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.addWSRefreshViewHeader({ () -> () in
            println("Start Refreshing")
            //            let delayInSeconds = 1.0
            //            let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * NSEC_PER_SEC)) // 1
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), { () -> Void in
                self.collectionView?.endHeaderRefreshing()
            })
        })
    }
}

