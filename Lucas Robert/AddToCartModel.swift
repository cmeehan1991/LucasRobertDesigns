//
//  AddToCartoModel.swift
//  Lucas Robert
//
//  Created by Connor Meehan on 4/16/17.
//  Copyright © 2017 CBM Web Development. All rights reserved.
//

import Foundation

protocol ConfirmItemsAddedProtocol: class{
    func itemsAdded(itemAdded: Bool)
}


class AddToCartModel: NSObject{
    
    weak var delegate : ConfirmItemsAddedProtocol!
    let requestURL = "http://wpdev.lucasrobertdesigns.com/mobile/cart.php"
    /*
     * This method will add an item to the user's cart.
     *
     * @params productID: String, quantity: String, variationID: String, variation: String
     */
    func addItem(productID: String, quantity: String, variationID: String){
        let url = URL(string: requestURL)
        var request = URLRequest(url: url!)
        request.httpMethod = "post"
        
        var parameters = "action=" + "add-to-cart"
        parameters += "&product_id=" + productID
        parameters += "&quantity=" + quantity
        parameters += "&variation_id=" + variationID
        
        print(parameters)
        
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
    
    /*
     * This method will receive the data response from the query and parse it.
     * The data returned will be a boolean value of either true or false,
     * signifying whether or not the iten was successfully added to the user's cart.
     *
     * @params data: Data - The data returned by the addItem method's task.
     */
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
            self.delegate.itemsAdded(itemAdded: jsonResponse["ITEM_ADDED"] as! Bool)
        }
    }
}
