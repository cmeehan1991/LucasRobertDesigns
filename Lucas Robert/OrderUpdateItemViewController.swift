//
//  OrderUpdateItemViewController.swift
//  Lucas Robert
//
//  Created by Connor Meehan on 4/14/17.
//  Copyright © 2017 CBM Web Development. All rights reserved.
//

import UIKit

class OrderUpdateItemViewController: UIViewController, OrderUpdateItemProtocol{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loaderView: UIActivityIndicatorView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemSkuLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var orderStatusLabel: UILabel!
    @IBOutlet weak var orderQuantityLabel: UILabel!
    
    var orderUpdateItemModel = OrderUpdateItemModel()
    var itemID : String = String(), orderID : String = String()
    var itemName: String = String(), itemImageURL : String = String(), itemSKU : String = String(), orderDate : String = String(), orderStatus : String = String(), orderQuantity : String = String()
    
    func itemDownloaded(itemName: String, itemImageURL: String, itemSKU: String, orderDate: String, orderStatus: String, orderQuantity: String) {
        self.itemName = itemName
        self.itemImageURL = itemImageURL
        self.itemSKU = itemSKU
        self.orderDate = orderDate
        self.orderStatus = orderStatus
        self.orderQuantity = orderQuantity
        
        // Get the data form the url 
        // then convert it to an image for the imageview
        let url = URL(string: self.itemImageURL)
        let imageData = try? Data(contentsOf: url!)
        DispatchQueue.main.async{
            self.itemImageView.image = UIImage(data: imageData!)
            self.itemImageView.contentMode = .scaleAspectFit
        }
        // Set the rest of the content
        self.itemNameLabel.text = self.itemName
        self.itemSkuLabel.text = self.itemSKU
        self.orderDateLabel.text = self.orderDate
        self.orderStatusLabel.text = self.orderStatus.capitalized
        self.orderQuantityLabel.text = self.orderQuantity
        
        self.loaderView.stopAnimating()
        self.scrollView.isHidden = false
    }
    
    @IBAction func stepperValueChanged(sender: UIStepper){
        self.orderQuantityLabel.text = Int(sender.value).description
        self.orderQuantity = Int(sender.value).description
    }
    
    @IBAction func updateOrder(){
        
    }
    
    @IBAction func cancelItem(){
        
    }
    
    override func loadView(){
        super.loadView()
        // Hide the item content and show the loader view while the information is downloading and being displayed.
        scrollView.isHidden = true
        loaderView.startAnimating()
        self.orderUpdateItemModel.delegate = self
        self.orderUpdateItemModel.downloadItem(itemID: itemID, orderID: orderID)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
