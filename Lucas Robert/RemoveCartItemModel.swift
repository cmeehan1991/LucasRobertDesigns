//
//  RemoveCartItemModel.swift
//  Lucas Robert
///Users/cmeehan/Documents/iOS Projects/Lucas Robert/Lucas Robert
//  Created by Connor Meehan on 4/19/17.
//  Copyright © 2017 CBM Web Development. All rights reserved.
//

import Foundation

protocol RemoveCartItemProtocol: class{
    func itemRemoved(removed: Bool)
}

class RemoveCartItemModel: NSObject{
    let url = URL(string: "http://wpdev.lucasrobertdesigns.com/mobile/cart.php")
    weak var delegate: RemoveCartItemProtocol!
    
    func removeItem(cartItemKey: String){
        var request = URLRequest(url: self.url!)
        request.httpMethod = "post"
        
        var parameters = "action=" + "remove-item"
        parameters += "&cart_item_key=" + cartItemKey
        
        request.httpBody = parameters.data(using: .utf8)
        DispatchQueue.global(qos: .background).async{
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
        var jsoneResponse: NSDictionary = NSDictionary()
        do{
            jsoneResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
        }catch let error{
            print("JSON Error: \(String(describing: error))")
        }
        DispatchQueue.main.async {
            self.delegate.itemRemoved(removed: jsoneResponse["ITEM_REMOVED"] as! Bool)
        }
    }
}
