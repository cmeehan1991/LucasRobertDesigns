//
//  AccountInformationModel.swift
//  Lucas Robert
//
//  Created by Connor Meehan on 3/23/17.
//  Copyright © 2017 CBM Web Development. All rights reserved.
//

import Foundation

protocol ShippingInformationProtocol: class{
    func shippingInformationDownloaded (companyName: String, firstName: String, lastName: String, streetAddress: String, suite: String, city: String, state: String, zip: String, primaryPhone: String, fax: String)
    func shippingInformationUpdated(updated: Bool)
}

class ShippingInformationModel: NSObject{
    weak var delegate: ShippingInformationProtocol!
    let defaults = UserDefaults.standard
    let url = URL(string: "http://wpdev.lucasrobertdesigns.com/mobile/users.php")
    
    func downloadShippingInformation(){
        DispatchQueue.global(qos: .background).async{
            // Set the URLRequest url and the method to post since we will be posting data to the server.
            var urlRequest = URLRequest(url: self.url!)
            urlRequest.httpMethod = "post"
            
            var parameters = "action=" + "get_shipping_information"
            parameters += "&user_id=" + self.defaults.string(forKey: "USER_ID")!
            
            urlRequest.httpBody = parameters.data(using: .utf8)
            
            let task = URLSession.shared.dataTask(with: urlRequest){
                data, response, error in
                if error != nil{
                    print("Task Error: \(String(describing: error))")
                    print("Response: \(String(describing: response))")
                    return
                }
                self.parseShippingJSON(data: data!)
            }
            task.resume()
        }
    }
    
        
    func uploadShippingInformation(companyName: String, firstName: String, lastName: String, streetAddress: String, suite: String, city: String, state: String, zip: String, primaryPhone: String, fax: String){
        DispatchQueue.global(qos: .background).async{
            var urlRequest = URLRequest(url: self.url!)
            urlRequest.httpMethod = "post"
            
            var parameters = "action=" + "updateShippingInformation"
            parameters += "&user_id=" + self.defaults.string(forKey: "USER ID")!
            parameters += "&company_name=" + companyName
            parameters += "&first_name=" + firstName
            parameters += "&last_name=" + lastName
            parameters += "&street_address=" + streetAddress
            parameters += "&suite=" + suite
            parameters += "&city=" + city
            parameters += "&state=" + state
            parameters += "&zip=" + zip
            parameters += "&phone=" + primaryPhone
            parameters += "&fax=" + fax
            
            print(parameters)
            
            urlRequest.httpBody = parameters.data(using: .utf8)
            
            let task = URLSession.shared.dataTask(with: urlRequest){
                data, response, error in
                if error != nil{
                    print("Error: \(String(describing: error))")
                    print("Response: \(String(describing: response))")
                    return
                }
                self.parseShippingUploadJSON(data: data!)
            }
            task.resume()
        }

    }
    
    func parseShippingUploadJSON(data: Data){
        var jsonResults : NSDictionary = NSDictionary()
        do{
            jsonResults = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
        }catch let error{
            print("JSON Error: \(String(describing: error))")
        }
        print("Updated: \(jsonResults["UPDATED"])")
        DispatchQueue.main.async{
            self.delegate?.shippingInformationUpdated(updated: jsonResults["UPDATED"] as! Bool)
        }

    }
    
    func parseShippingJSON(data: Data){
        var jsonResults : NSDictionary = NSDictionary()
        do{
            jsonResults = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
        }catch let error{
            print("JSON Error: \(error)")
        }
        print("Shipping")
        print(jsonResults)
        DispatchQueue.main.async {
            self.delegate?.shippingInformationDownloaded(companyName: jsonResults["COMPANY_NAME"] as! String, firstName: jsonResults["FIRST_NAME"] as! String, lastName: jsonResults["LAST_NAME"] as! String, streetAddress: jsonResults["STREET_ADDRESS"] as! String, suite: jsonResults["SUITE"] as! String, city: jsonResults["CITY"] as! String, state: jsonResults["STATE"] as! String, zip: jsonResults["POST_CODE"] as! String, primaryPhone: jsonResults["PRIMARY_PHONE"] as! String, fax: jsonResults["FAX"] as! String)
        }
    }
}
