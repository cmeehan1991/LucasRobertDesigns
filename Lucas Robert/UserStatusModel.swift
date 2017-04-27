//
//  UserStatusModel.swift
//  Lucas Robert
//
//  Created by Connor Meehan on 4/19/17.
//  Copyright © 2017 CBM Web Development. All rights reserved.
//

import Foundation

protocol UserStatusProtocol: class{
    func itemsDownloaded(status: Bool, userID: String)
}

class UserStatusModel: NSObject{
    weak var delegate: UserStatusProtocol!
    let url = URL(string: "http://wpdev.lucasrobertdesigns.com/mobile/users.php")
    
    func downloadItems(){
        var request = URLRequest(url: self.url!)
        request.httpMethod = "post"
        
        let parameters = "action=" + "check_user_status"
        
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
        var jsonResponse: NSDictionary = NSDictionary()
        do{
            jsonResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
        }catch let error{
            print("JSON Error: \(String(describing: error))")
        }
        DispatchQueue.main.sync {
            self.delegate.itemsDownloaded(status: jsonResponse["STATUS"] as! Bool, userID: jsonResponse["USER_ID"] as! String)
        }
    }
}
