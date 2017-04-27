//
//  PaymentInformationViewController.swift
//  Lucas Robert
//
//  Created by Connor Meehan on 4/20/17.
//  Copyright © 2017 CBM Web Development. All rights reserved.
//

import UIKit

class PaymentInformationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var paymentTypeTableView: UITableView!
    
    let defaults = UserDefaults.standard
    let acceptedPayments = ["Cash on Delivery", "PayPal", "Check"]
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return acceptedPayments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = paymentTypeTableView.dequeueReusableCell(withIdentifier: "PaymentTypeCellViewController") as! PaymentTypeCellViewController
        print(acceptedPayments[indexPath.row])
        cell.paymentTypeLabel.text = acceptedPayments[indexPath.row]
        if(acceptedPayments[indexPath.row] != "Cash on Delivery" || acceptedPayments[indexPath.row] != "Check"){
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch(indexPath.row){
        case 0:
            let setAsDefaultAlert = UIAlertController(title: "Set as default?", message: "Would you like to set your default payment method as Cash on Delivery? Choosing this option may cause your orders to be delayed.", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Yes", style: .default, handler: {(alert: UIAlertAction!) in self.defaults.set("cash", forKey: "PREFERRED_PAYMENT_METHOD")})
            let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
            setAsDefaultAlert.addAction(yesAction)
            setAsDefaultAlert.addAction(noAction)
            self.present(setAsDefaultAlert, animated: true)
            break
        case 1:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SetupPayPalViewController") as! SetupPayPalViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
            break
        case 2:
            let setAsDefaultAlert = UIAlertController(title: "Set as default payment method?", message: "Would you like to set your default payment method as Check? Choosing this option may cause your orders to be delayed.", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Yes", style: .default, handler: {(alert: UIAlertAction!) in self.defaults.set("check", forKey: "PREFERRED_PAYMENT_METHOD")})
            let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
            setAsDefaultAlert.addAction(yesAction)
            setAsDefaultAlert.addAction(noAction)
            self.present(setAsDefaultAlert, animated: true)
            
            break
        default:
            break
        }
        
        self.paymentTypeTableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func loadView() {
        super.loadView()
        self.paymentTypeTableView.delegate = self
        self.paymentTypeTableView.dataSource = self
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
}
