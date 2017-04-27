//
//  ViewController.swift
//  Lucas Robert
//
//  Created by Connor Meehan on 1/13/17.
//  Copyright © 2017 CBM Web Development. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, RecentOrdersProtocol, CurrentOrdersProtocol{
    
    @IBOutlet weak var recentOrdersTable: UITableView!
    @IBOutlet weak var currentOrdersTable: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let recentOrdersModel = RecentOrdersModel()
    let currentOrdersModel = CurrentOrdersModel()
    let ordersStoryBoard : UIStoryboard = UIStoryboard(name:"Orders", bundle: nil)
    var itemOrderDateRecent : NSMutableArray = NSMutableArray(), itemTitlesRecent: NSMutableArray = NSMutableArray(), itemIDsRecent : NSMutableArray = NSMutableArray(), orderNumbersRecent : NSMutableArray = NSMutableArray(), orderStatusRecent : NSMutableArray = NSMutableArray(), itemOrderDateCurrent : NSMutableArray = NSMutableArray(), itemTitlesCurrent: NSMutableArray = NSMutableArray(), itemIDsCurrent : NSMutableArray = NSMutableArray(), orderNumbersCurrent : NSMutableArray = NSMutableArray(), orderStatusCurrent : NSMutableArray = NSMutableArray()
    
    
    /*
     * Get the current orders (anything not completed or cancelled)
     * then reload the currentOrdersTable data.
     *
     */
    func currentItemsDownloaded(orderID: NSArray, orderDate: NSArray, orderStatus: NSArray, itemNames: NSArray, itemID: NSArray) {
        self.itemTitlesCurrent = itemNames as! NSMutableArray
        self.itemIDsCurrent = itemID as! NSMutableArray
        self.orderStatusCurrent = orderStatus as! NSMutableArray
        self.orderNumbersCurrent = orderID as! NSMutableArray
        self.itemOrderDateCurrent = orderDate as! NSMutableArray
        
        self.currentOrdersTable.reloadData()
        self.loadingIndicator.stopAnimating()
        self.loadingIndicator.isHidden = true
        self.scrollView.isHidden = false
    }
    /*
     * Get the recent orders then reload the recentOrdersTable data.
     * This includes anything completed or cancelled.
     *
     */
    func recentItemsDownloaded(orderID: NSArray, orderDate: NSArray, orderStatus: NSArray, itemNames: NSArray, itemID: NSArray) {
        // Set the data for the recent orders table
        self.itemTitlesRecent = itemNames as! NSMutableArray
        self.itemIDsRecent = itemID as! NSMutableArray
        self.orderStatusRecent = orderStatus as! NSMutableArray
        self.orderNumbersRecent = orderID as! NSMutableArray
        self.itemOrderDateRecent = orderDate as! NSMutableArray
        
        self.recentOrdersTable.reloadData()
    }
    
    // Set the number of sections in each table to be 1.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /*
     * Set the number of rows in each table.
     * This method will get called twice - when the view loads and when the data loads.
     * The number of rows will be based off of the number of orders.
     *
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView.tag == 0){
            return self.orderNumbersCurrent.count
        }else{
            return self.orderNumbersRecent.count
        }
    }
    
    /*
     * Set the tableview cell data
     * Current Orders: 0
     * Recent Orders: 1
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView.tag == 0){
            let cell = currentOrdersTable.dequeueReusableCell(withIdentifier: "CurrentOrdersCell") as! CurrentOrdersTableViewCellController
            cell.itemNames.text = (self.itemTitlesCurrent[indexPath.row] as! NSArray).componentsJoined(by: ", ")
            cell.orderNumber.text = "Order: \(self.orderNumbersCurrent[indexPath.row] as! String)"
            cell.orderDate.text = self.itemOrderDateCurrent[indexPath.row] as? String
            cell.orderStatus.text = (self.orderStatusCurrent[indexPath.row] as? String)?.capitalized
            return cell
        }else{
            let cell = recentOrdersTable.dequeueReusableCell(withIdentifier: "RecentOrdersCell") as! RecentOrdersTableViewCellController
            cell.itemNames.text = (self.itemTitlesRecent[indexPath.row] as! NSArray).componentsJoined(by: ", ")
            cell.orderNumber.text = "Order: \(self.orderNumbersRecent[indexPath.row] as! String)"
            cell.orderDate.text = self.itemOrderDateRecent[indexPath.row] as? String
            cell.orderStatus.text = (self.orderStatusRecent[indexPath.row] as? String)?.capitalized
            switch(self.orderStatusRecent[indexPath.row] as! String){
            case "cancelled":
                cell.orderStatus.textColor = UIColor.red
                break
            case "completed":
                cell.orderStatus.textColor = UIColor.green
                break
            default:break
            }
            return cell
        }
    }
    /*
     * This method will push to the view order storyboard
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ordersViewController = ordersStoryBoard.instantiateViewController(withIdentifier: "ViewOrderViewController") as! ViewOrderViewController
        
        switch(tableView.tag){
        case 0:
            ordersViewController.orderID = self.orderNumbersCurrent[indexPath.row] as! String
            ordersViewController.orderDate = self.itemOrderDateCurrent[indexPath.row] as! String
            self.navigationController?.pushViewController(ordersViewController, animated: true)
            break
        case 1:
            ordersViewController.orderID = self.orderNumbersRecent[indexPath.row] as! String
            ordersViewController.orderDate = self.itemOrderDateRecent[indexPath.row] as! String
            self.navigationController?.pushViewController(ordersViewController, animated: true)
            break
        default:break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /*
     * This method shows the navigation drawer when the hamburger icon is tapped.
     *
     */
    @IBAction func showMenuButtonTapped(_ sender: Any) {
        NavigationDrawerViewController.load()
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
    /*
     * This method takes the user to their cart for review and ordering
     */
    @IBAction func viewCartButtonTouched(){
        let cartStoryBoard : UIStoryboard = UIStoryboard(name: "Cart", bundle: nil)
        let vc = cartStoryBoard.instantiateViewController(withIdentifier: "ReviewOrderViewController") as! ReviewOrderViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func loadView(){
        super.loadView()
        self.scrollView.isHidden = true
        self.loadingIndicator.startAnimating()
        
        self.recentOrdersModel.delegate = self
        self.recentOrdersModel.downloadItems()
        self.currentOrdersModel.delegate = self
        self.currentOrdersModel.downloadItems()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.recentOrdersTable.delegate = self
        self.recentOrdersTable.dataSource = self
        self.currentOrdersTable.dataSource = self
        self.currentOrdersTable.delegate = self
    }
    
}

