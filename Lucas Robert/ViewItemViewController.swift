//
//  ViewItemViewController.swift
//  Lucas Robert
//
//  Created by Connor Meehan on 3/18/17.
//  Copyright © 2017 CBM Web Development. All rights reserved.
//

import UIKit

class ViewItemViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, ViewItemProtocol, ConfirmItemsAddedProtocol{
    
    @IBOutlet weak var primaryImageImageView: UIImageView!
    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityVariationPickerView: UIPickerView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var itemNameLabel : UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    let viewItemModel = ViewItemModel()
    let addToCartModel = AddToCartModel()
    var itemType : String = String()
    let numberFormatter : NumberFormatter = NumberFormatter()
    var isVariable :Bool = Bool()
    
    var itemID : String = String()
    var variationID: NSArray = NSArray()
    var primaryImage: UIImage = UIImage()
    var itemName : NSAttributedString = NSAttributedString()
    var itemPrice : String = String()
    var itemLengths : Array = Array<Double>()
    var itemPrices : Array = Array<Double>()
    var itemImages: NSMutableArray = NSMutableArray()
    var itemDescription: NSMutableAttributedString = NSMutableAttributedString()
    var selectedQuantity: Int = Int()
    
    var quantities = ["1","2","3","4","5","6","7","8","9","10"]
    
    var addingItemAlert : UIAlertController = UIAlertController()
    var itemAddedAlert : UIAlertController = UIAlertController()
    var addingItemSpinner: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func itemsAdded(itemAdded: Bool) {
        if itemAdded == true{
            self.addingItemAlert.dismiss(animated: true)
            self.itemAddedAlert.title = "Added Item to Cart"
            self.itemAddedAlert.message = "The Item Has Been Successfully Added to the Cart"
            present(self.itemAddedAlert, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                self.itemAddedAlert.dismiss(animated: true){
                self.navigationController?.popViewController(animated: true)
                }
            }
        }else{
            self.addingItemAlert.dismiss(animated:true){
                self.itemAddedAlert = UIAlertController(title: "Error", message: "There was an error adding the item to the cart.", preferredStyle: .alert)
                let confirmation = UIAlertAction(title: "OK", style: .default, handler: nil)
                self.itemAddedAlert.addAction(confirmation)
                self.present(self.itemAddedAlert, animated: true, completion: nil)
            }
        }
    }
    
    // Downlaod the items from the ViewItemProtocol
    func itemsDownloaded(itemImages: NSArray, itemDescription: NSMutableAttributedString, itemPrice: String, itemLengths: Array<Double>, itemPrices: Array<Double>, variationID: NSArray) {

        self.itemImages = itemImages as! NSMutableArray
        self.variationID = variationID
        self.itemDescription = itemDescription
        self.primaryImageImageView.image = itemImages[0] as? UIImage
        self.primaryImageImageView.contentMode = .scaleAspectFit
        
        self.itemNameLabel.attributedText = self.itemName
        self.descriptionTextView.attributedText = itemDescription
        // If the product is not variable then set the item price
        if(!isVariable){
            self.itemPrice = itemPrice
            priceLabel.text = numberFormatter.string(from: NSNumber(value: Double(itemPrice)!))
        }else{
            self.itemLengths = itemLengths
            self.itemPrices = itemPrices
            if(itemPrices.min() == itemPrices.max()){
                let priceRange = numberFormatter.string(from: NSNumber(value: (itemPrices.min())!))
                priceLabel.text = priceRange
            }else{
                let itemDisplayPrice = numberFormatter.string(from: NSNumber(value: itemPrices[0]))
                priceLabel.text = itemDisplayPrice
            }
        }
        DispatchQueue.main.async {
            self.imageCollection.reloadData()
            self.quantityVariationPickerView.reloadAllComponents()
            self.quantityVariationPickerView.delegate = self
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.scrollView.isHidden = false
        }
    }
    
    @IBAction func addToCartTouched(){
        addingItemAlert.title = "Adding Item to Cart"
        addingItemSpinner.startAnimating()
        addingItemSpinner.color = UIColor.black
        addingItemAlert.view.addSubview(addingItemSpinner)
        self.present(addingItemAlert, animated: true)
        if(self.itemType == "variable"){
            self.addToCartModel.addItem(productID: self.itemID, quantity: String(self.quantities[self.selectedQuantity]), variationID: variationID[quantityVariationPickerView.selectedRow(inComponent: 0)] as! String)
        }else{
            self.addToCartModel.addItem(productID: self.itemID, quantity: String(self.quantities[self.selectedQuantity]), variationID: "")
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemImageCell", for: indexPath) as! ItemImageCollectionViewController
        myCell.itemImages.image = itemImages[indexPath.item] as? UIImage
        return myCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.primaryImageImageView.image = itemImages[indexPath.item] as? UIImage
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if(isVariable){
            return 2
        }else{
            return 1
        }
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(isVariable){
            switch(component){
            case 0: return itemLengths.count
            case 1: return quantities.count
            default: return 0
            }
        }else{
            return quantities.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(isVariable){
            switch(component){
            case 0: return String(describing: itemLengths[row])
            case 1: return quantities[row]
            default: return nil
            }
        }else{
            return quantities[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(self.itemType == "variable"){
            switch(pickerView.tag){
            case 0:
                let selectedVariation = quantityVariationPickerView.selectedRow(inComponent: 0)
                 self.selectedQuantity = quantityVariationPickerView.selectedRow(inComponent: 1)
                let price = itemPrices[selectedVariation] * Double(quantities[selectedQuantity])!
                self.priceLabel.text = numberFormatter.string(from: NSNumber(value: (price)))
                break
            case 1:
                let selectedVariation = quantityVariationPickerView.selectedRow(inComponent: 0)
                let selectedQuantity = quantityVariationPickerView.selectedRow(inComponent: 1)
                let price = itemPrices[selectedVariation] * Double(quantities[selectedQuantity])!
                self.priceLabel.text = numberFormatter.string(from: NSNumber(value: (price)))
                break
            default: break
            }
        }else{
            let selectedQuantity = quantityVariationPickerView.selectedRow(inComponent: component)
            let price = Double(self.itemPrice)! * Double(quantities[selectedQuantity])!
            self.priceLabel.text = numberFormatter.string(from: NSNumber(value: (price)))
            
        }
        
    }
    
    /*
     * This method takes the user to their cart for review and ordering
     */
    @IBAction func viewCartButtonTouched(){
        let cartStoryBoard : UIStoryboard = UIStoryboard(name: "Cart", bundle: nil)
        let vc = cartStoryBoard.instantiateViewController(withIdentifier: "ReviewOrderViewController") as! ReviewOrderViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func loadView() {
        super.loadView()
        
        // Hide the main view while the item is loading and start the activity indicator
        self.scrollView.isHidden = true
        self.activityIndicator.startAnimating()
        
        viewItemModel.delegate = self
        viewItemModel.downloadItem(itemID: self.itemID, itemType: self.itemType)
        
        addToCartModel.delegate = self
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegate the collection and picker views
        self.imageCollection.delegate = self
        self.imageCollection.dataSource = self
        self.quantityVariationPickerView.delegate = self
        self.quantityVariationPickerView.dataSource = self
        
        // Set up the number formatter to be currency
        self.numberFormatter.numberStyle = NumberFormatter.Style.currency
        
        // Set the item type boolean
        if(itemType == "variable"){
            isVariable = true
        }
        
        
    }
}
