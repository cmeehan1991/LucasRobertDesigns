//
//  ReviewOrderModel.swift
//  Lucas Robert
//
//  Created by Connor Meehan on 4/18/17.
//  Copyright © 2017 CBM Web Development. All rights reserved.
//

import Foundation

protocol ReviewOrderProtocol: class{
    func itemsDownloaded(cartItemKey: NSArray, productID: NSArray, variationID: NSArray, quantity: NSArray, lineSubtotal: NSArray, lineTax: NSArray, itemName: NSArray, itemImageURL: NSArray)
}

class ReviewOrderModel: NSObject{
    let url = "http://wpdev.lucasrobertdesigns.com/mobile/cart.php"
    var delegate: ReviewOrderProtocol!
    
    func downloadItems(){
        let url = URL(string: self.url)
        var request = URLRequest(url: url!)
        request.httpMethod = "post"
        
        let parameters = "action=" + "getCart"
        
        request.httpBody = parameters.data(using: .utf8)
        
        DispatchQueue.global(qos: .background).async {
            let task = URLSession.shared.dataTask(with: request){
                data, response, error in
                if error != nil{
                    print("Task Error: \(String(describing: error))")
                    return
                }
                self.parseJSON(data: data!)
            }
            task.resume()
        }
    }
    func parseJSON(data: Data){
        var jsonResponse: NSArray = NSArray()
        do{
            jsonResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSArray
        }catch let error{
            print("JSON Error: \(String(describing: error))")
        }
        
        let cartItemKey: NSMutableArray = NSMutableArray()
        let productID : NSMutableArray = NSMutableArray()
        let variationID : NSMutableArray = NSMutableArray()
        let quantity : NSMutableArray = NSMutableArray()
        let lineSubtotal : NSMutableArray = NSMutableArray()
        let lineTax : NSMutableArray = NSMutableArray()
        let itemName : NSMutableArray = NSMutableArray()
        let itemImageURL : NSMutableArray = NSMutableArray()
        
        for i in 0..<(jsonResponse.count){
            let response = jsonResponse[i] as! NSDictionary
            
            cartItemKey.add(response["cart_item_key"] as! String)
            productID.add(response["product_id"] as! String)
            variationID.add(response["variation_id"] as! String)
            quantity.add(response["quantity"] as! String)
            lineSubtotal.add(response["line_subtotal"] as! String)
            lineTax.add(response["line_tax"] as! String)
            itemName.add(NSAttributedString(string: response["name"] as! String))
            itemImageURL.add(response["item_image_url"] as! String)
        }
        
        DispatchQueue.main.async {
            self.delegate.itemsDownloaded(cartItemKey: cartItemKey, productID: productID, variationID: variationID, quantity: quantity, lineSubtotal: lineSubtotal, lineTax: lineTax, itemName: itemName, itemImageURL: itemImageURL)
        }
    }
}
