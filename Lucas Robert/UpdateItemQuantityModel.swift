//
//  UpdateItemQuantityModel.swift
//  Lucas Robert
//
//  Created by Connor Meehan on 4/19/17.
//  Copyright © 2017 CBM Web Development. All rights reserved.
//

import Foundation

protocol UpdateItemQuantityProtocol: class{
    func itemUpdated(updated: Bool)
}

class UpdateItemQuantityModel: NSObject{
    let url = URL(string: "http://wpdev.lucasrobertdesigns.com/mobile/cart.php")
    weak var delegate: UpdateItemQuantityProtocol!
    
    func updateQuantity(cartItemKey: String, quantity: String){
        var request = URLRequest(url: url!)
        request.httpMethod = "post"
        
        var parameters = "action=" + "update-item-quantity"
        parameters += "&cart_item_key=" + cartItemKey
        parameters += "&quantity=" + quantity
        
        request.httpBody = parameters.data(using: .utf8)
        
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
    
    func parseJSON(data: Data){
        var response : NSDictionary = NSDictionary()
        do{
            response = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
        }catch let error{
            print("JSON Error: \(String(describing: error))")
        }
        DispatchQueue.main.async{
            self.delegate.itemUpdated(updated: response["QUANTITY_UPDATED"] as! Bool)
        }
    }
}
