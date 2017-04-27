//
//  ContactInformationViewController.swift
//  Lucas Robert
//
//  Created by Connor Meehan on 3/22/17.
//  Copyright © 2017 CBM Web Development. All rights reserved.
//

import UIKit

class AccountInformationTableViewController: UITableViewController, ShippingInformationProtocol, BillingAddressProtocol{
    @IBOutlet weak var shippingCompanyNameLabel: UILabel!
    @IBOutlet weak var shippingNameLabel: UILabel!
    @IBOutlet weak var shippingStreetLabel: UILabel!
    @IBOutlet weak var shippingSuiteLabel: UILabel!
    @IBOutlet weak var shippingCityStateZipLabel: UILabel!
    @IBOutlet weak var shippingTelephoneLabel: UILabel!
    @IBOutlet weak var shippingFaxLabel: UILabel!
    @IBOutlet weak var billingCompanyNameLabel: UILabel!
    @IBOutlet weak var billingNameLabel: UILabel!
    @IBOutlet weak var billingStreetLabel: UILabel!
    @IBOutlet weak var billingSuiteLabel: UILabel!
    @IBOutlet weak var billingCityStateZipLabel: UILabel!
    @IBOutlet weak var billingTelephoneLabel: UILabel!
    @IBOutlet weak var billingFaxLabel: UILabel!
    
    let shippingInformationModel = ShippingInformationModel()
    let billingAddressModel = BillingAddressModel()
    
    var companyNameShipping: String = String(), firstNameShipping: String = String(), lastNameShipping: String = String(), streeAddressShipping: String = String(), suiteShipping: String = String(), cityShipping: String = String(), stateShipping: String = String(), zipShipping: String = String(), primaryPhoneShipping: String = String(), faxShipping: String = String(), companyNameBilling: String = String(), firstNameBilling: String = String(), lastNameBilling: String = String(), streeAddressBilling: String = String(), suiteBilling: String = String(), cityBilling: String = String(), stateBilling: String = String(), zipBilling: String = String(), primaryPhoneBilling: String = String(), faxBilling: String = String()
    
    func shippingInformationUpdated(updated: Bool) {
        print(updated)
    }
    
    func billingAddressUploaded(isUpdated: Bool) {
        print(isUpdated)
    }
    
    func shippingInformationDownloaded(companyName: String, firstName: String, lastName: String, streetAddress: String, suite: String, city: String, state: String, zip: String, primaryPhone: String, fax: String) {
        self.companyNameShipping = companyName
        self.firstNameShipping = firstName
        self.lastNameShipping = lastName
        self.streeAddressShipping = streetAddress
        self.suiteShipping = suite
        self.cityShipping = city
        self.stateShipping = state
        self.zipShipping = zip
        self.primaryPhoneShipping = primaryPhone
        self.faxShipping = fax
        
        self.shippingCompanyNameLabel.text = self.companyNameShipping
        self.shippingNameLabel.text = self.firstNameShipping + " " + self.lastNameShipping
        self.shippingStreetLabel.text = self.streeAddressShipping
        self.shippingSuiteLabel.text = self.suiteShipping
        self.shippingCityStateZipLabel.text = self.cityShipping + ", " + self.stateShipping + " " + self.zipShipping
        self.shippingTelephoneLabel.text = self.primaryPhoneShipping
        self.shippingFaxLabel.text = self.faxShipping
    }
    
    
    func billingAddressDownloaded(companyName: String, firstName: String, lastName: String, streetAddress: String, suite: String, city: String, state: String, zip: String, primaryPhone: String, fax: String) {
        self.companyNameBilling = companyName
        self.firstNameBilling = firstName
        self.lastNameBilling = lastName
        self.streeAddressBilling = streetAddress
        self.suiteBilling = suite
        self.cityBilling = city
        self.stateBilling = state
        self.zipBilling = zip
        self.primaryPhoneBilling = primaryPhone
        self.faxBilling = fax
        
        self.billingCompanyNameLabel.text = self.companyNameShipping
        self.billingNameLabel.text = self.firstNameShipping + " " + self.lastNameShipping
        self.billingStreetLabel.text = self.streeAddressShipping
        self.billingSuiteLabel.text = self.suiteShipping
        self.billingCityStateZipLabel.text = self.cityShipping + ", " + self.stateShipping + " " + self.zipShipping
        self.billingTelephoneLabel.text = self.primaryPhoneShipping
        self.billingFaxLabel.text = self.faxShipping
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row{
        case 0:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddContactInformationViewController") as! AddContactInformationViewController
            vc.type = "shipping"
            vc.companyName = self.companyNameShipping
            vc.firstName = self.firstNameShipping
            vc.lastName = self.lastNameShipping
            vc.streetAddress = self.streeAddressShipping
            vc.suite = self.suiteShipping
            vc.city = self.cityShipping
            vc.state = self.stateShipping
            vc.zip = self.zipShipping
            vc.primaryPhone = self.primaryPhoneShipping
            vc.fax = self.faxShipping
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 1:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddContactInformationViewController") as! AddContactInformationViewController
            vc.type = "billing"
            vc.companyName = self.companyNameBilling
            vc.firstName = self.firstNameBilling
            vc.lastName = self.lastNameBilling
            vc.streetAddress = self.streeAddressBilling
            vc.suite = self.suiteBilling
            vc.city = self.cityBilling
            vc.state = self.stateBilling
            vc.zip = self.zipBilling
            vc.primaryPhone = self.primaryPhoneBilling
            vc.fax = self.faxShipping
            self.navigationController?.pushViewController(vc, animated: true)
            break
        default:break
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        shippingInformationModel.downloadShippingInformation()
        billingAddressModel.downloadBillingInformation()
        shippingInformationModel.delegate = self
        billingAddressModel.delegate = self
    }
    
    override func loadView() {
        super.loadView()
    }
}
