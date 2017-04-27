//
//  ShopQueryController.swift
//  Lucas Robert
//
//  Created by Connor Meehan on 1/23/17.
//  Copyright © 2017 CBM Web Development. All rights reserved.
//

import Foundation

protocol ShopQueryProtocol: class{
    func itemsDownloaded(itemImage: NSArray, itemNames: NSArray, itemPrices: NSArray, itemID: NSArray, itemType: NSArray)
}

class ShopModel: NSObject{
    // Properties
    weak var delegate: ShopQueryProtocol!
    var data: Data = Data()
    var page: Int = 1
    var ppp: Int = 10
    
    let requestURL = "http://wpdev.lucasrobertdesigns.com/mobile/shop.php"
    
    func downloadItems(category: String, offset: Int){
        DispatchQueue.global(qos: .background).async {
            let url = URL(string: self.requestURL)
            
            var request = URLRequest(url: url!)
            request.httpMethod = "post"
            
            var parameters = "action=get_products"
            parameters += "&product_category=" + category
            parameters += "&offset=" + String(describing: offset)
            
            request.httpBody = parameters.data(using: .utf8)
            
            let task = URLSession.shared.dataTask(with: request){
                data, response, error in
                if error != nil{
                    print("Error: \(String(describing: error))")
                    return
                }
                self.data.removeAll()
                self.data.append(data!)
                self.parseJSON()
            }
            task.resume()
        }
    }
    
    func parseJSON(){
        var jsonResults: NSArray = NSArray()
        do{
            jsonResults = try JSONSerialization.jsonObject(with: self.data, options: .allowFragments) as! NSArray
        }catch let error{
            print("JSON Error: \(error)")
        }
        let itemName: NSMutableArray = NSMutableArray()
        let itemID: NSMutableArray = NSMutableArray()
        let itemImage: NSMutableArray = NSMutableArray()
        let itemPrice: NSMutableArray = NSMutableArray()
        let itemType: NSMutableArray = NSMutableArray()
        
        for i in 0..<(jsonResults.count){
            let jsonElement = jsonResults[i] as! NSDictionary
            itemName.add(NSAttributedString(string: jsonElement["ITEM_NAME"] as! String))
            itemID.add(jsonElement["ITEM_ID"]!)
            itemType.add(jsonElement["ITEM_TYPE"]!)
            var imageData : Data = Data()
            imageData = try! Data(contentsOf:URL(string:jsonElement["ITEM_IMAGE_URL"] as! String)!)
            itemImage.add(UIImage(data: imageData)!)
            itemPrice.add(jsonElement["ITEM_PRICE"]!)
        }
        
        DispatchQueue.main.async{
            self.delegate?.itemsDownloaded(itemImage: itemImage, itemNames: itemName, itemPrices: itemPrice, itemID: itemID, itemType: itemType)
        }
        
    }
}
