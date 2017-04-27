//
//  CartViewController.swift
//  Lucas Robert
//
//  Created by Connor Meehan on 4/14/17.
//  Copyright © 2017 CBM Web Development. All rights reserved.
//

import UIKit

class ReviewOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, ReviewOrderProtocol, RemoveCartItemProtocol, UpdateItemQuantityProtocol{
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var itemsTable: UITableView!
    @IBOutlet weak var itemCountLabel: UILabel!
    @IBOutlet weak var subtotalLabel: UILabel!
    
    
    var reviewOrderModel = ReviewOrderModel()
    let removeCartItemModel = RemoveCartItemModel()
    let updateItemQuantityModel = UpdateItemQuantityModel()
    
    var cartItemKey: NSArray = NSArray(), productID: NSArray = NSArray(), variationID: NSArray = NSArray(), quantity: NSArray = NSArray(), lineSubtotal: NSArray = NSArray(), lineTax: NSArray = NSArray(), itemName: NSArray = NSArray(), itemimageURL: NSArray = NSArray()
    let currencyFormatter = NumberFormatter()
    let quantities = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    var confirmation : UIAlertController = UIAlertController()
    var updatingItemsAlert : UIAlertController = UIAlertController(title: "Updating Cart", message: nil, preferredStyle: .actionSheet)
    
    func itemUpdated(updated: Bool) {
        if updated == true{
            self.updatingItemsAlert.dismiss(animated: true)
            updatingItemsAlert.message = "Retrieving the updated cart items."
            self.present(updatingItemsAlert, animated: true)
            self.reviewOrderModel.downloadItems()
        }else{
            
        }
    }
    
    func itemRemoved(removed: Bool) {
        confirmation.dismiss(animated: true)
        if(removed == true){
            self.reviewOrderModel.downloadItems()
            let itemRemovedConfirmation = UIAlertController(title:"Item Removed" , message: "The Item was successfully removed from your cart", preferredStyle: .actionSheet)
            self.present(itemRemovedConfirmation, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                itemRemovedConfirmation.dismiss(animated: true)
            }
        }else{
            let itemRemovedConfirmation = UIAlertController(title: "Error", message: "The Item was not removed from your cart. Please try again.", preferredStyle: .actionSheet)
            let defaultAction = UIAlertAction(title: "OK", style: .default)
            itemRemovedConfirmation.addAction(defaultAction)
            self.present(itemRemovedConfirmation, animated: true)
            
        }
    }
    
    /*
     * This function will remove the item when the Delete Item button is touched.
     * It will first confirm with the user if they want to remove the item.
     * Once the user confirms it will proceed to remove the item if necessary.
     */
    @IBAction func removeItemTouched(sender: UIButton){
        confirmation = UIAlertController(title: "Remove Item", message: "Are you sure that you want to remove this item from your cart?", preferredStyle: .actionSheet)
        let confirmAction = UIAlertAction(title: "Yes", style: .default){ (action) in
            let buttonPosition = sender.convert(CGPoint(), to: self.itemsTable)
            let indexPath = self.itemsTable.indexPathForRow(at: buttonPosition)!
            let index : Int = indexPath[1]
            self.removeCartItemModel.delegate = self
            self.removeCartItemModel.removeItem(cartItemKey: self.cartItemKey[index] as! String)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        confirmation.addAction(confirmAction)
        confirmation.addAction(cancelAction)
        self.present(confirmation, animated: true, completion: nil)
        
    }
    
    @IBAction func checkOutButtonTouched(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CheckOutViewController") as! CheckOutViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func itemsDownloaded( cartItemKey: NSArray, productID: NSArray, variationID: NSArray, quantity: NSArray, lineSubtotal: NSArray, lineTax: NSArray, itemName: NSArray, itemImageURL: NSArray) {
        self.cartItemKey = cartItemKey
        self.productID = productID
        self.variationID = variationID
        self.quantity = quantity
        self.lineSubtotal = lineSubtotal
        self.lineTax = lineTax
        self.itemName = itemName
        self.itemimageURL = itemImageURL
        
        self.itemsTable.reloadData()
        
        
        self.loader.stopAnimating()
        self.loader.isHidden = true
        self.scrollView.isHidden = false
        self.updatingItemsAlert.dismiss(animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productID.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = itemsTable.dequeueReusableCell(withIdentifier: "CartCellViewController") as! CartCellViewController
        
        // Load the image first because that will take the longest
        let imageURL = URL(string: itemimageURL[indexPath.row] as! String)
        let imageData = try? Data(contentsOf: imageURL!)
        DispatchQueue.main.async{
            cell.itemImage.image = UIImage(data: imageData!)
            cell.itemImage.contentMode = .scaleAspectFit
        }
        
        cell.itemName.attributedText = self.itemName[indexPath.row] as? NSAttributedString
        let price: Double = Double(self.lineSubtotal[indexPath.row] as! String)!
        cell.itemPrice.text = self.currencyFormatter.string(from: NSNumber(value: price))
        
        cell.itemQuantity.delegate = self
        cell.itemQuantity.dataSource = self
        cell.itemQuantity.selectRow(quantities.index(of: self.quantity[indexPath.row] as! String)!, inComponent: 0, animated: true)
        
        return cell
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return quantities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return quantities[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let pickerPosition = pickerView.convert(CGPoint(), to: self.itemsTable)
        let indexPath = self.itemsTable.indexPathForRow(at: pickerPosition)!
        let index : Int = indexPath[1]
                
        self.updateItemQuantityModel.delegate = self
        self.updateItemQuantityModel.updateQuantity(cartItemKey: cartItemKey[index] as! String, quantity: quantities[row])
        self.updatingItemsAlert.message = "Updating the item quantity."
        self.present(self.updatingItemsAlert, animated: true)
    }
    
    override func loadView() {
        super.loadView()
        
        // Hide the main content and show the loader while the cart data is loading
        self.loader.startAnimating()
        self.scrollView.isHidden = true
        
        // Initialize the tableview
        self.itemsTable.delegate = self
        self.itemsTable.dataSource = self
        
        // Download the cart information from the database
        self.reviewOrderModel.delegate = self
        self.reviewOrderModel.downloadItems()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currencyFormatter.numberStyle = .currency
        self.currencyFormatter.maximumFractionDigits = 2
        self.currencyFormatter.minimumFractionDigits = 2
        
        // Set the back navigation button to only be the arrow (i.e. - no text)
        self.navigationItem.backBarButtonItem?.title = ""
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
}
