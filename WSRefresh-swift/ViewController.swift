//
//  ViewController.swift
//  WSRefresh-swift
//
//  Created by Wilson-Yuan on 15/7/5.
//  Copyright (c) 2015年 wilson-yuan. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var dataArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.addRandomDataToArray()
        self.addRandomDataToArray()

        
        self.tableView.reloadData()
        
//        self.tableView.addWSRefreshViewHeader { () -> (Void) in
//            
//            self.addRandomDataToArray()
//            
//            let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC))) // 1
//
//            
//            dispatch_after(popTime, dispatch_get_main_queue(), { () -> Void in
//                self.tableView.endHeaderRefreshing()
//                self.tableView.reloadData()
//            })
//        }
        
        self.tableView.addWSRefreshViewFooter { () -> () in
          
            
        };
    }

    func addRandomDataToArray() {
        for var i = 0; i < 10; i++ {
            dataArray.append("测试数据: \(arc4random() / 10000)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        configureCell(cell, forRowAtIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, forRowAtIndexPath: NSIndexPath) {
        cell.textLabel?.text = "\(dataArray[forRowAtIndexPath.row]) CurrentRow: \(forRowAtIndexPath.row)"
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.backgroundColor = randomColor()
    }
}

func randomValue() ->CGFloat {
    var randomValue = arc4random() % 255
    return CGFloat(CGFloat(randomValue) / 255.0)
}
func randomColor() ->UIColor {
    return UIColor(red: randomValue(), green: randomValue(), blue: randomValue(), alpha: randomValue())
}



class CollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var dataArray = [String]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.addWSRefreshViewHeader({ () -> () in
            
            self.addRandomDataToArray()
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), { () -> Void in
                
                self.collectionView?.reloadData()
                self.collectionView?.endHeaderRefreshing()
            })
        })
        
        

    }
    
    
    func addRandomDataToArray() {
        for var i = 0; i < 10; i++ {
            dataArray.append("测试数据: \(arc4random() / 10000)")
        }
    }

    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! UICollectionViewCell
        configureCell(cell, forItemAtIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UICollectionViewCell, forItemAtIndexPath: NSIndexPath) {
        cell.backgroundColor = randomColor()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var width = UIScreen.mainScreen().bounds.width / 3 - 1;
        return CGSize(width: width, height: width)
    }

}

