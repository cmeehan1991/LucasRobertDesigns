//
//  ViewItemModel.swift
//  Lucas Robert
//
//  Created by Connor Meehan on 3/18/17.
//  Copyright © 2017 CBM Web Development. All rights reserved.
//

import Foundation

protocol ViewItemProtocol: class {
    func itemsDownloaded(itemImages: NSArray, itemDescription: NSMutableAttributedString, itemPrice: String, itemLengths: Array<Double>, itemPrices: Array<Double>, variationID: NSArray)
}

class ViewItemModel: NSObject{
    
    weak var delegate: ViewItemProtocol!
    var itemType : String = String()
    let requestURL = URL(string:"http://wpdev.lucasrobertdesigns.com/mobile/shop.php")
    var data : Data = Data()
    
    func downloadItem(itemID: String, itemType: String){
        DispatchQueue.global(qos: .background).async {
            self.itemType = itemType // Set the item type - variable | simple
            
            // The URL request for which the query will be based on.
            // This will be a post request as we are posting data to the server.
            // We will then return the data in JSON format.
            var urlRequest = URLRequest(url: self.requestURL!)
            urlRequest.httpMethod = "post"
            
            // Posting the action, which is required for the PHP script to know which method to use.
            // Need to have the product ID and item type for the query.
            var parameters = "action=viewProducts"
            parameters += "&product_id=" + itemID
            parameters += "&product_type=" + itemType
            
            // Add the paraters to the request body
            urlRequest.httpBody = parameters.data(using: .utf8)
            
            // Perform the request and append the data to the variable data.
            // Then perform the JSON parsing.
            let task = URLSession.shared.dataTask(with: urlRequest){
                data, response, error in
                if error != nil{
                    print("Task Error: \(String(describing: error))")
                    return
                }
                self.data.append(data!)
                self.parseJSON()
            }
            task.resume()
        }
    }
    /*
     * This function will parse the JSON response from the server.
     * This is only called if there was not an error with the task in the downloadItem method.
     */
    func parseJSON(){
        var jsonResponse : NSDictionary = NSDictionary()
        do{
            jsonResponse = try JSONSerialization.jsonObject(with: self.data, options: .allowFragments) as! NSDictionary
        }catch let error{
            print("JSON Error: \(error)")
        }
        
        let itemImages: NSMutableArray = NSMutableArray() // An array of the UIImages of the item. There will always be at least one image.
        var itemDescriptions: NSMutableAttributedString = NSMutableAttributedString() // There is not always an item description, but there should be.
        var itemPrice: String = String() // This is only applicable with simple items.
        var itemLengths: Array = Array<Double>()
        var itemPrices: Array = Array<Double>()
        let variationID: NSMutableArray = NSMutableArray()
        
        // The query returns the image URLS.
        // This block will asyncronyously convert the URLs to UIImages and add them to the itemImages array.
        DispatchQueue.main.async{
            let images : Array<String> = jsonResponse["IMAGE_URLS"] as! Array
            for i in 0..<(images.count){
                let imageData = try! Data(contentsOf: URL(string: images[i])!)
                itemImages.add(UIImage(data: imageData)!)
            }
        }
        
        // Set the item description
        itemDescriptions = NSMutableAttributedString(string: jsonResponse["DESCRIPTION"] as! String)
        
        // If the item is of type variable then set the item variations.
        // Otherwise only add the price.
        if(itemType == "variable"){
            let lengths : NSArray = jsonResponse["VARIATION_LENGTHS"] as! NSArray
            let prices : NSArray = jsonResponse["VARIATION_PRICES"] as! NSArray
            let variationIDs: NSArray = jsonResponse["VARIATION_ID"] as! NSArray
            for i in 0..<(lengths.count){
                itemLengths.append((lengths[i] as! NSString).doubleValue)
            }
            for i in 0..<(prices.count){
                itemPrices.append((prices[i] as! NSString).doubleValue)
            }
            for i in 0..<(variationIDs.count){
                variationID.add(variationIDs[i] as! String)
            }
        }
        if (itemType == "simple"){
            itemPrice = String(jsonResponse["ITEM_PRICES"] as! NSString)
        }
        
        DispatchQueue.main.async{
            self.delegate.itemsDownloaded(itemImages: itemImages, itemDescription: itemDescriptions, itemPrice: itemPrice, itemLengths: itemLengths, itemPrices: itemPrices, variationID: variationID)
        }
        
    }
}
