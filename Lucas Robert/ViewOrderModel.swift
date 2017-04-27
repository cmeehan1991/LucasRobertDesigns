//
//  ViewOrderModel.swift
//  Lucas Robert
//
//  Created by Connor Meehan on 4/13/17.
//  Copyright © 2017 CBM Web Development. All rights reserved.
//

import Foundation


protocol ViewOrderProtocol: class{
    func itemDownloaded(orderStatus: String, itemID: NSArray, itemName: NSArray, itemImageURL: NSArray, itemQty: NSArray, itemSKU: NSArray)
}

class ViewOrderModel: NSObject{
    weak var delegate : ViewOrderProtocol!
    let url = "http://wpdev.lucasrobertdesigns.com/mobile/orders.php"
    func downloadItem(orderID: String){
        let url = URL(string: self.url)
        var request = URLRequest(url: url!)
        request.httpMethod = "post"
        
        var parameters = "action=" + "view-order"
        parameters += "&order_id=" + orderID
        
        request.httpBody = parameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request){
            data, response, error in
            if error != nil{
                print("Error: \(String(describing: error))")
                return
            }
            self.parseJSON(data: data!)
        }
        task.resume()
    }
    
    func parseJSON(data: Data){
        var jsonResults : NSArray = NSArray()
        do{
            jsonResults = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSArray
        }catch let error{
            print("JSON Error: \(error)")
            return
        }
        
        var orderStatus : String = String()
        let itemID : NSMutableArray = NSMutableArray()
        let itemName : NSMutableArray = NSMutableArray()
        let itemImageURL : NSMutableArray = NSMutableArray()
        let itemQty : NSMutableArray = NSMutableArray()
        let itemSku : NSMutableArray = NSMutableArray()
        
        for i in 0..<(jsonResults.count){
            let element = jsonResults[i] as! NSDictionary
            
            orderStatus = element["STATUS"] as! String
            itemID.add(element["ITEM_ID"] as! NSArray)
            
            let itemNames = element["ITEM_NAME"] as! NSArray
            for name in 0..<(itemNames.count){
                itemName.add(itemNames[name] as! String)
            }
            
            let itemImages = element["ITEM_IMAGE_URL"] as! NSArray
            for image in 0..<(itemImages.count){
                itemImageURL.add(itemImages[image] as! String)
            }
            
            let itemQtys = element["ITEM_QTY"] as! NSArray
            for qty in 0..<(itemQtys.count){
                itemQty.add(itemQtys[qty] as! String)
            }
            
            let itemSkus = element["ITEM_SKU"] as! NSArray
            for sku in 0..<(itemSkus.count){
                itemSku.add(itemSkus[sku] as! String)
            }
        }
        
        DispatchQueue.main.async{
            self.delegate.itemDownloaded(orderStatus: orderStatus, itemID: itemID, itemName: itemName, itemImageURL: itemImageURL, itemQty: itemQty, itemSKU: itemSku)
        }
    }
}
