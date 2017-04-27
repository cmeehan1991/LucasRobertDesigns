//
//  UserSignOffModel.swift
//  Lucas Robert
//
//  Created by Connor Meehan on 4/19/17.
//  Copyright © 2017 CBM Web Development. All rights reserved.
//

import Foundation

class UserLogOutModel: NSObject{
    let url = URL(string: "http://wpdev.lucasrobertdesigns.com/mobile/users.php")
    
    func userLogOut(){
        var request = URLRequest(url: self.url!)
        request.httpMethod = "post"
        
        let parameters = "action=" + "userLogOut"
        
        request.httpBody = parameters.data(using: .utf8)
        DispatchQueue.global(qos: .background).async{
            let task = URLSession.shared.dataTask(with:request){
                data, response, error in
                if error != nil{
                    print("Task Error: \(String(describing: error))")
                    return
                }
            }
            task.resume()
        }
    }
}
