//
//  RecentOrdersModel.swift
//  Lucas Robert
//
//  Created by Connor Meehan on 4/13/17.
//  Copyright © 2017 CBM Web Development. All rights reserved.
//

import Foundation

protocol RecentOrdersProtocol: class{
    func recentItemsDownloaded(orderID: NSArray, orderDate: NSArray, orderStatus: NSArray, itemNames: NSArray, itemID: NSArray)
}


class RecentOrdersModel: NSObject{
    weak var delegate: RecentOrdersProtocol!
    var defaults = UserDefaults.standard
    let requestURL = "http:wpdev.lucasrobertdesigns.com/mobile/orders.php"
    
    func downloadItems(){
        let url = URL(string: self.requestURL)
        var request = URLRequest(url: url!)
        request.httpMethod = "post"
        
        var parameters = "action=" + "summary-recent"
        parameters += "&user_id=" + defaults.string(forKey: "USER ID")!
        
        request.httpBody = parameters.data(using: .utf8)
        DispatchQueue.global(qos: .background).async{
            let task = URLSession.shared.dataTask(with: request){
                data, response, error in
                if error != nil{
                    print("Error: \(String(describing: error))")
                    return
                }
                
                // Parse the response data
                self.parseJSON(data: data!)
            }
            task.resume()
        }
    }
    
    func parseJSON(data: Data){
        var jsonResults : NSArray = NSArray()
        do{
            jsonResults = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSArray
        }catch let error{
            print("JSON Error: \(error)")
        }
        let orderID : NSMutableArray = NSMutableArray()
        let orderDate : NSMutableArray = NSMutableArray()
        let orderStatus : NSMutableArray = NSMutableArray()
        let orderItems : NSMutableArray = NSMutableArray()
        let orderItemIDs : NSMutableArray = NSMutableArray()
        
        for i in 0..<(jsonResults.count){
            let jsonElement = jsonResults[i] as! NSDictionary
            orderID.add(jsonElement["ID"] as! String)
            orderDate.add(jsonElement["ORDER_DATE"] as! String)
            orderStatus.add(jsonElement["ORDER_STATUS"] as! String)
            orderItems.add(jsonElement["ITEM_NAMES"] as! NSArray)
            orderItemIDs.add(jsonElement["ITEM_IDs"] as! NSArray)
        }
        
        DispatchQueue.main.async{
            self.delegate?.recentItemsDownloaded(orderID: orderID, orderDate: orderDate, orderStatus: orderStatus, itemNames: orderItems, itemID: orderItemIDs)
        }
    }
    
}
