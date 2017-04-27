//
//  OrderUpdateItemModel.swift
//  Lucas Robert
//
//  Created by Connor Meehan on 4/14/17.
//  Copyright © 2017 CBM Web Development. All rights reserved.
//

import Foundation

protocol OrderUpdateItemProtocol: class{
    func itemDownloaded(itemName: String, itemImageURL: String, itemSKU: String, orderDate: String, orderStatus: String, orderQuantity: String)
}

class OrderUpdateItemModel: NSObject{
    weak var delegate: OrderUpdateItemProtocol!
    let url = "http://wpdev.lucasrobertdesigns.com/mobile/orders.php"
    
    func downloadItem(itemID: String, orderID: String){
        let url = URL(string: self.url)
        var requestURL = URLRequest(url: url!)
        requestURL.httpMethod = "post"
        
        var parameters = "action=" + "order-get-item"
        parameters += "&item_id=" + itemID
        parameters += "&order_id=" + orderID
        
        requestURL.httpBody = parameters.data(using: .utf8)
        
        DispatchQueue.global(qos: .background).async {
            let task = URLSession.shared.dataTask(with: requestURL){
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
        var jsonResponse : NSDictionary = NSDictionary()
        do{
            jsonResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
        }catch let error{
            print("JSON Error: \(error)")
            return
        }
        print(jsonResponse)
        DispatchQueue.main.async{
            self.delegate.itemDownloaded(itemName: jsonResponse["ITEM_NAME"] as! String, itemImageURL: jsonResponse["ITEM_IMAGE_URL"] as! String, itemSKU: jsonResponse["ITEM_SKU"] as! String, orderDate: jsonResponse["ORDER_DATE"] as! String, orderStatus: jsonResponse["ORDER_STATUS"] as! String, orderQuantity: jsonResponse["ORDER_QUANTITY"] as! String)
        }
        
        
    }
}
