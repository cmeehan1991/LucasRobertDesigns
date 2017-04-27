//
//  ProcessPaymentModel.swift
//  Lucas Robert
//
//  Created by Connor Meehan on 4/22/17.
//  Copyright © 2017 CBM Web Development. All rights reserved.
//

import Foundation

protocol ProcessPaymentProtocol: class{
    func paymentProcessed(processed: Bool)
}

class ProcessPaymentModel: NSObject{
    weak var delegate: ProcessOrderProtocol!
    let url = URL(string: "http://wpdev.lucasrobertdesigns.com/mobile/cart.php")
    
    func processPayment(orderID: String){
        
    }
}
