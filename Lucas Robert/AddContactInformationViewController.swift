//
//  AddContactInformationViewController.swift
//  Lucas Robert
//
//  Created by Connor Meehan on 3/23/17.
//  Copyright © 2017 CBM Web Development. All rights reserved.
//

import UIKit

class AddContactInformationViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, BillingAddressProtocol, ShippingInformationProtocol{
    
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var streetAddressTextField: UITextField!
    @IBOutlet weak var suiteTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var statePickerView: UIPickerView!
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var telephoneTextField: UITextField!
    @IBOutlet weak var faxTextField: UITextField!
    
    let shippingInformationModel = ShippingInformationModel()
    let billingAddressModel = BillingAddressModel()
    
    var type: String = String(), companyName: String = String(), firstName: String = String(), lastName: String = String(), streetAddress: String = String(), suite: String = String(), city: String = String(), state: String = String(), zip: String = String(), primaryPhone: String = String(), fax: String = String()
    
    var stateAbbrArray = ["AL","AK","AS","AZ","AR","CA","CO","CT","DE","DC","FL","GA","GU","HI","ID","IL","IA","KS","KY","LA","ME","MD","MH","MA","MI","FM","MN","MS","MS","MO","MT","NE","NV","NH","NJ","NM","NY","NC","ND","MP","OH","OK","OR","PW","PA","PR","RI","SC","SD","TN","TX","UT","VT","VA","VI","WA","WV","WI","WY"]
 
    func shippingInformationDownloaded(companyName: String, firstName: String, lastName: String, streetAddress: String, suite: String, city: String, state: String, zip: String, primaryPhone: String, fax: String) {
        // Do nothing
    }
    
    func billingAddressDownloaded(companyName: String, firstName: String, lastName: String, streetAddress: String, suite: String, city: String, state: String, zip: String, primaryPhone: String, fax: String) {
        // Do nothing
    }
    
    func shippingInformationUpdated(updated: Bool) {
        print("Updated: \(updated)")
        if(type.lowercased() == "shipping" && updated == true){
            print("Yes")
            let alert = UIAlertController(title: "Shipping Address Updated", message: "Your shipping address has been successfully updated.", preferredStyle: .actionSheet)
            self.present(alert, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                alert.dismiss(animated: true){
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func billingAddressUploaded(isUpdated: Bool) {
        if(type.lowercased() == "billing" && isUpdated == true){
            let alert = UIAlertController(title: "Billing Address Updated", message: "Your billing address has been successfully updated.", preferredStyle: .actionSheet)
            self.present(alert, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                alert.dismiss(animated: true){
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    @IBAction func saveInformationButtonTouched(){
        view.endEditing(true)
        print(type)
        self.companyName = companyNameTextField.text!
        self.firstName = firstNameTextField.text!
        self.lastName = lastNameTextField.text!
        self.streetAddress = streetAddressTextField.text!
        self.suite = suiteTextField.text!
        self.city = cityTextField.text!
        self.state = stateAbbrArray[statePickerView.selectedRow(inComponent: 0)]
        self.zip = zipCodeTextField.text!
        self.primaryPhone = telephoneTextField.text!
        self.fax = faxTextField.text!

        switch(type){
        case "billing":
            billingAddressModel.uploadBillingInformation(companyName: self.companyName, firstName: self.firstName, lastName: self.lastName, streetAddress: self.streetAddress, suite: self.suite, city: self.city, state: self.state, zip: self.zip, primaryPhone: self.primaryPhone, fax: self.fax)
            break
        case "shipping":
            shippingInformationModel.uploadShippingInformation(companyName: self.companyName, firstName: self.firstName, lastName: self.lastName, streetAddress: self.streetAddress, suite: self.suite, city: self.city, state: self.state, zip: self.zip, primaryPhone: self.primaryPhone, fax: self.fax)
            break
        default: break
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stateAbbrArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stateAbbrArray[row]
    }
    
    override func loadView() {
        super.loadView()
        self.statePickerView.delegate = self
        self.statePickerView.dataSource = self
        
        self.companyNameTextField.text = self.companyName
        self.firstNameTextField.text = self.firstName
        self.lastNameTextField.text = self.lastName
        self.streetAddressTextField.text = self.streetAddress
        self.suiteTextField.text = self.suite
        self.cityTextField.text = self.city
        self.statePickerView.selectRow(stateAbbrArray.index(of: self.state)!, inComponent: 0, animated: true)
        self.zipCodeTextField.text = self.zip
        self.telephoneTextField.text = self.primaryPhone
        self.faxTextField.text = self.fax
        
        self.shippingInformationModel.delegate = self
        self.billingAddressModel.delegate = self
        
    }
}
