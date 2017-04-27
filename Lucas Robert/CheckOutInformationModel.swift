//
//  ShippingToModel.swift
//  Lucas Robert
//
//  Created by Connor Meehan on 4/20/17.
//  Copyright © 2017 CBM Web Development. All rights reserved.
//

import Foundation

protocol CheckOutInformationProtocol: class{
    func itemsDownloaded(shippingName: String, shippingAddress: String, billingAddress: String, billingName: String, itemName: NSArray, itemSKU: NSArray, itemImageURL: NSArray, itemQuantity: NSArray, itemSubtotal: NSArray)
}

class CheckOutInformationModel: NSObject{
    let url = URL(string: "http://wpdev.lucasrobertdesigns.com/mobile/cart.php")
    weak var delegate: CheckOutInformationProtocol!
    
    /*
     * We are downloading a lot of information here.
     * We will be retrieving the user's billing and shipping address(es).
     * and the order information.
     *
     * @params cartItemKey String - this is the key id for the user's cart.
     */
    func downloadItems(userID: String, cartItemKey: String){
        var request = URLRequest(url: url!)
        request.httpMethod = "post"
        
        var parameters = "action=" + "get_checkout_information"
        parameters += "&cart_item_key=" + cartItemKey
        parameters += "&user_id=" + userID
        
        request.httpBody = parameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request){
            data, response, error in
            if error != nil{
                print("Task error: \((String(describing: error)))")
                return
            }
            self.parseJSON(data: data!)
        }
        task.resume()
    }
    
    func parseJSON(data: Data){
        var jsonResponse: NSDictionary = NSDictionary()
        do{
            jsonResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
        }catch let error{
            print("JSON Error: \(String(describing:error))")
        }
        
        let shippingName = jsonResponse["SHIPPING_NAME"] as? String
        let shippingAddress = jsonResponse["SHIPPING_ADDRESS"] as? String
        let billingName = jsonResponse["BILLING_NAME"] as? String
        let billingAddress = jsonResponse["BILLING_ADDRESS"] as? String
        let itemName = jsonResponse["ITEM_NAME"] as! NSArray
        let itemSku = jsonResponse["ITEM_SKU"] as! NSArray
        let itemImageURL = jsonResponse["ITEM_IMAGE_URL"] as! NSArray
        let itemQuantity = jsonResponse["ITEM_QUANTITY"] as! NSArray
        let itemSubtotal = jsonResponse["ITEM_SUBTOTAL"] as! NSArray
        
        let itemNames: NSMutableArray = NSMutableArray()
        let itemSkus: NSMutableArray = NSMutableArray()
        let itemImageURLs: NSMutableArray = NSMutableArray()
        let itemQuantities: NSMutableArray = NSMutableArray()
        let itemSubtotals: NSMutableArray = NSMutableArray()
        
        
        for i in 0..<(itemName.count){
         itemNames.add(itemName[i] as! String)
        }
        
        for i in 0..<(itemSku.count){
           itemSkus.add(itemSku[i] as! String)
        }
        
        for i in 0..<(itemImageURL.count){
            itemImageURLs.add(itemImageURL[i] as! String)
        }
        
        for i in 0..<(itemQuantity.count){
            itemQuantities.add(itemQuantity[i] as! String)
        }
        
        for i in 0..<(itemSubtotal.count){
            itemSubtotals.add(itemSubtotal[i] as! String)
        }
        
        DispatchQueue.main.async {
            self.delegate.itemsDownloaded(shippingName: shippingName!, shippingAddress: shippingAddress!, billingAddress: billingAddress!, billingName: billingName!, itemName: itemNames, itemSKU: itemSkus, itemImageURL: itemImageURLs, itemQuantity: itemQuantities, itemSubtotal: itemSubtotals)
        }
    }
}
