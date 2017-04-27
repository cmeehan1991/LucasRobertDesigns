//
//  BillingInformationModel.swift
//  Lucas Robert
//
//  Created by Connor Meehan on 4/20/17.
//  Copyright © 2017 CBM Web Development. All rights reserved.
//

import Foundation

protocol ProcessOrderProtocol: class{
    func orderCompleted(orderStatus: Bool, orderID: String)
}

class ProcessOrderModel: NSObject{
    let url = URL(string: "http://wpdev.lucasrobertdesigns.com/mobile/cart.php")
    weak var delegate: ProcessOrderProtocol!
    
    func processOrder(userID: String, paymentMethod: String){
        var request = URLRequest(url: self.url!)
        request.httpMethod = "post"
        
        var parameters = "action=" + "submit_order"
        parameters += "&user_id=" + userID
        parameters += "&payment_method=" + paymentMethod
        
        request.httpBody = parameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request){
            data, response, error in
            if error != nil{
                print("Task error: \(String(describing: error))")
                return
            }
            self.parseJSON(data: data!)
        }
    }
    
    func parseJSON(data: Data){
        var response: NSDictionary = NSDictionary()
        do{
            response = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
        }catch let error{
            print ("JSON Error: \(String(describing: error))")
        }
        DispatchQueue.main.async {
            self.delegate.orderCompleted(orderStatus: response["ORDER_SUBMITTED"] as! Bool, orderID: response["ORDER_ID"] as! String)
        }
    }
}
