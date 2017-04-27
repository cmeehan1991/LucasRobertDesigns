//
//  BillingAddressModel.swift
//  Lucas Robert
//
//  Created by Connor Meehan on 4/21/17.
//  Copyright © 2017 CBM Web Development. All rights reserved.
//

import Foundation

protocol BillingAddressProtocol: class{
    func billingAddressDownloaded(companyName: String, firstName: String, lastName: String, streetAddress: String, suite: String, city: String, state: String, zip: String, primaryPhone: String, fax: String)
    
    func billingAddressUploaded(isUpdated: Bool)
}

class BillingAddressModel: NSObject{
    weak var delegate: BillingAddressProtocol!
    let url = URL(string: "http://wpdev.lucasrobertdesigns.com/mobile/users.php")
    let defaults = UserDefaults.standard
    
    func downloadBillingInformation(){
        // Set the URLRequest url and the method to post since we will be posting data to the server.
        var urlRequest = URLRequest(url: self.url!)
        urlRequest.httpMethod = "post"
        
        var parameters = "action=" + "get_billing_information"
        parameters += "&user_id=" + self.defaults.string(forKey: "USER_ID")!
        
        print(parameters)
        
        urlRequest.httpBody = parameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: urlRequest){
            data, response, error in
            if error != nil{
                print("Task Error: \(String(describing: error))")
                print("Response: \(String(describing: response))")
                return
            }
            self.parseBillingJSON(data: data!)
        }
        task.resume()
    }
    
    
    func uploadBillingInformation(companyName: String, firstName: String, lastName: String, streetAddress: String, suite: String, city: String, state: String, zip: String, primaryPhone: String, fax: String){
        DispatchQueue.global(qos: .background).async{
            var urlRequest = URLRequest(url: self.url!)
            urlRequest.httpMethod = "post"
            
            var parameters = "action=" + "updateBillingInformation"
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
            
            urlRequest.httpBody = parameters.data(using: .utf8)
            
            let task = URLSession.shared.dataTask(with: urlRequest){
                data, response, error in
                if error != nil{
                    print("Error: \(String(describing: error))")
                    print("Response: \(String(describing: response))")
                    return
                }
                self.parseBillingUpdateJSON(data: data!)
            }
            task.resume()
        }
    }
    
    func parseBillingUpdateJSON(data: Data){
        var jsonResults : NSDictionary = NSDictionary()
        do{
            jsonResults = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
        }catch let error{
            print("JSON Error: \(String(describing: error))")
        }
        print(jsonResults["UPDATED"] as! Bool)
        DispatchQueue.main.async{
            self.delegate?.billingAddressUploaded(isUpdated: jsonResults["UPDATED"] as! Bool)
        }
    }
    
    func parseBillingJSON(data: Data){
        var jsonResults : NSDictionary = NSDictionary()
        do{
            jsonResults = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
        }catch let error{
            print("JSON Error: \(error)")
        }
        print("Billing")
        print(jsonResults)
        DispatchQueue.main.async {
            self.delegate?.billingAddressDownloaded(companyName: jsonResults["COMPANY_NAME"] as! String, firstName: jsonResults["FIRST_NAME"] as! String, lastName: jsonResults["LAST_NAME"] as! String, streetAddress: jsonResults["STREET_ADDRESS"] as! String, suite: jsonResults["SUITE"] as! String, city: jsonResults["CITY"] as! String, state: jsonResults["STATE"] as! String, zip: jsonResults["POST_CODE"] as! String, primaryPhone: jsonResults["PRIMARY_PHONE"] as! String, fax: jsonResults["FAX"] as! String)
        }    }
    
}
