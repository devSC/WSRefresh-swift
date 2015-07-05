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
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

