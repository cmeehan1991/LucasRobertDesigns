//
//  Shop.swift
//  Lucas Robert
//
//  Created by Connor Meehan on 1/13/17.
//  Copyright © 2017 CBM Web Development. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ShopQueryProtocol{
    
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var filterButton: UIBarButtonItem!
    @IBOutlet weak var itemsTable: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var category : String = String()
    var itemNames : NSMutableArray = NSMutableArray()
    var itemImages : NSMutableArray = NSMutableArray()
    var itemIDs: NSMutableArray = NSMutableArray()
    var itemPrices : NSMutableArray = NSMutableArray()
    var itemType : NSMutableArray = NSMutableArray()
    let numberFormatter : NumberFormatter = NumberFormatter()
    var itemVariations : NSDictionary = NSDictionary()
    var offset : Int = Int()
    let pagingSpinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    let searchModel = ShopModel()
    
    
    func itemsDownloaded(itemImage: NSArray, itemNames: NSArray, itemPrices: NSArray, itemID: NSArray, itemType: NSArray) {

        self.itemNames.addObjects(from: itemNames as! [NSAttributedString])
        self.itemImages.addObjects(from: itemImage as! [UIImage])
        self.itemIDs.addObjects(from: itemID as! [Any])
        self.itemPrices.addObjects(from: itemPrices as! [Any])
        self.itemType.addObjects(from: itemType as! [String])
        DispatchQueue.main.async {
            self.itemsTable.reloadData()
            self.pagingSpinner.stopAnimating()
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.itemsTable.isHidden = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        DispatchQueue.global().suspend()
        DispatchQueue.main.suspend()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemIDs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "ShopCellViewController") as! ShopCellViewController
        myCell.itemTitleLabel.attributedText = self.itemNames[indexPath.row] as? NSAttributedString
        if self.itemPrices[indexPath.row] is String{
            myCell.itemPriceLabel.text = self.numberFormatter.string(from: NSNumber(value: Double((self.itemPrices[indexPath.row] as? String)!)!))
        }else{
            let values = (self.itemPrices[indexPath.row] as? Array<Double>)
            if(values?.min() == values?.max()){
                let priceRange = self.numberFormatter.string(from: NSNumber(value: (values?.min())!))
                myCell.itemPriceLabel.text = priceRange
            }else{
                let priceRange = self.numberFormatter.string(from: NSNumber(value: (values?.min())!))! + " - " + self.numberFormatter.string(from: NSNumber(value: (values?.max())!))!
                myCell.itemPriceLabel.text = priceRange
            }
        }
        myCell.imageView?.image = self.itemImages[indexPath.row] as? UIImage
        myCell.imageView?.contentMode = .scaleAspectFit
        return myCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewItemViewController") as! ViewItemViewController
        vc.itemID = String(describing: itemIDs[indexPath.row])
        vc.itemType = self.itemType[indexPath.row] as! String
        vc.itemName = itemNames[indexPath.row] as! NSAttributedString
        self.navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = self.itemNames.count - 8
        if(self.itemIDs.count % 10 == 0){
            if indexPath.row == lastElement{
                self.offset += 10
                pagingSpinner.startAnimating()
                pagingSpinner.hidesWhenStopped = true
                pagingSpinner.sizeThatFits(CGSize(width: 100, height: 100))
                itemsTable.tableFooterView = pagingSpinner
                DispatchQueue.global(qos:.background).async{
                    self.searchModel.downloadItems(category: self.category, offset: self.offset)
                }
            }
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
    
    override func loadView(){
        super.loadView()
        
        self.itemsTable.isHidden = true
        self.activityIndicator.startAnimating()
        
        searchModel.delegate = self
        searchModel.downloadItems(category: self.category, offset: self.offset)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = category.capitalized(with: NSLocale.current)
        
        self.itemsTable.delegate = self
        self.itemsTable.dataSource = self
        
        self.numberFormatter.numberStyle = NumberFormatter.Style.currency
    }
}
