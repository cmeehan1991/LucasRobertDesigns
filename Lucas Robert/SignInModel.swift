//
//  SignInModel.swift
//  Lucas Robert
//
//  Created by Connor Meehan on 4/19/17.
//  Copyright © 2017 CBM Web Development. All rights reserved.
//

import Foundation

protocol SignInProtocol: class{
    func itemsDownloaded(error: String, displayName: String, email: String, roles: NSArray, userID: String)
}

class SignInModel: NSObject{
    let url = URL(string: "http://wpdev.lucasrobertdesigns.com/mobile/users.php")
    weak var delegate: SignInProtocol!
    
    func downloadItems(username: String, password: String){
        var request = URLRequest(url: url!)
        request.httpMethod = "post"
        
        var parameters = "action=" + "log in"
        parameters += "&username=" + username
        parameters += "&password=" + password
        
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
        var jsonResponse : NSDictionary = NSDictionary()
        do{
            jsonResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
        }catch let error{
            print("JSON Error: \(String(describing: error))")
        }
        DispatchQueue.main.async {
            self.delegate.itemsDownloaded(error: jsonResponse["ERROR"] as! String, displayName: jsonResponse["DISPLAY_NAME"] as! String, email: jsonResponse["EMAIL"] as! String, roles: jsonResponse["ROLES"] as! NSArray, userID: jsonResponse["USER_ID"] as! String)
        }
        
    }
}
