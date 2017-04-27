//
//  ViewOrderViewController.swift
//  Lucas Robert
//
//  Created by Connor Meehan on 4/13/17.
//  Copyright © 2017 CBM Web Development. All rights reserved.
//

import UIKit

class ViewOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ViewOrderProtocol{
    @IBOutlet weak var orderItemsTable: UITableView!
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var orderStatusLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var actionButton: UIBarButtonItem!
    
    let viewOrderModel = ViewOrderModel()
    
    var orderID : String = String()
    var orderDate : String = String()
    var orderStatus : String = String()
    var itemID : NSArray = NSArray()
    var itemName : NSArray = NSArray()
    var itemImageURL : NSArray = NSArray();
    var itemQty : NSArray = NSArray()
    var itemSKU: NSArray = NSArray()
    
    func itemDownloaded(orderStatus: String, itemID: NSArray, itemName: NSArray, itemImageURL: NSArray, itemQty: NSArray, itemSKU: NSArray) {
        self.itemID = itemID
        self.itemName = itemName as! NSMutableArray
        self.itemImageURL = itemImageURL as! NSMutableArray
        self.itemQty = itemQty as! NSMutableArray
        self.itemSKU = itemSKU as! NSMutableArray
        self.orderStatus = orderStatus
        
        self.orderItemsTable.reloadData()
        
        orderNumberLabel.text = orderID
        orderDateLabel.text = orderDate
        orderStatusLabel.text = self.orderStatus.capitalized
        
        scrollView.isHidden = false
        loadingIndicator.isHidden = true
        loadingIndicator.stopAnimating()
    }
    
    @IBAction func actionButtonTapped(){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive){action in
            
        }
        alert.addAction(cancelAction)
        
        let submitAction = UIAlertAction(title: "Place Order Again", style: .default){ action in
            // Do something to place the order again
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(submitAction)
        
        self.present(alert, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemID.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = orderItemsTable.dequeueReusableCell(withIdentifier: "OrderItemCell") as! OrderItemsCellViewController
        
        let imageURL = URL(string:itemImageURL[indexPath.row] as! String)
        let data = try? Data(contentsOf: imageURL!)
        DispatchQueue.main.async {
            cell.itemImageView.image = UIImage(data: data!)
            cell.itemImageView.contentMode = .scaleAspectFit
        }
        
        cell.itemNameLabel.text = itemName[indexPath.row] as? String
        cell.itemQtyLabel.text = "Qty: \(itemQty[indexPath.row])"
        cell.itemSkuLabel.text = "SKU: \(itemSKU[indexPath.row])"

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderUpdateItemViewController") as! OrderUpdateItemViewController
        let theItemID : Array<Int> = self.itemID[indexPath.row] as! Array<Int>
        vc.itemID = (theItemID[0] as NSNumber).stringValue
        vc.orderID = orderID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func loadView(){
        super.loadView()
        self.viewOrderModel.delegate = self
        self.viewOrderModel.downloadItem(orderID: orderID)
        
        self.scrollView.isHidden = true
        self.loadingIndicator.startAnimating()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.orderItemsTable.delegate = self
        self.orderItemsTable.dataSource = self
    }
}
