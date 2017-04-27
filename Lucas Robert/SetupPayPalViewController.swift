//
//  SetupPayPalViewController.swift
//  Lucas Robert
//
//  Created by Connor Meehan on 4/24/17.
//  Copyright © 2017 CBM Web Development. All rights reserved.
//

import UIKit

class SetupPayPalViewController: UIViewController, PayPalFuturePaymentDelegate{

    @IBOutlet weak var paymentIsActive: UILabel!
    @IBOutlet weak var authorizeFuturePayment: UIButton!
    @IBOutlet weak var setAsDefaultMethod: UIButton!
    
    var environemt: String = PayPalEnvironmentNoNetwork {
        willSet(newEnvironment){
            if(newEnvironment != environemt){
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    
    var payPalConfig = PayPalConfiguration()
    
    let defaults = UserDefaults.standard
    
    @IBAction func authorizeFuturePaymentsAction(_ sender: AnyObject){
        let futurePaymentViewController = PayPalFuturePaymentViewController(configuration: payPalConfig, delegate: self)
        present(futurePaymentViewController!, animated: true, completion: nil)
        self.defaults.set(true, forKey: "PAYPAL_AUTHORIZED_FUTURE_PAYMENTS")
    }
    
    @IBAction func makeDefaultMethod(){
        self.defaults.set("paypal", forKey: "PREFERRED_PAYMENT_METHOD")
        self.paymentIsActive.text = "Default Payment Method"
        self.paymentIsActive.textColor = UIColor.green
        let alert = UIAlertController(title: "Default Payment Updated", message: "Your default payment method is now paypal.", preferredStyle: .actionSheet)
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func payPalFuturePaymentViewController(_ futurePaymentViewController: PayPalFuturePaymentViewController, didAuthorizeFuturePayment futurePaymentAuthorization: [AnyHashable : Any]) {
        futurePaymentViewController.dismiss(animated: true, completion: {() -> Void in
            let alert = UIAlertController(title: "Future Payment Success", message: "PayPal Future Payment option has been activated.", preferredStyle: .actionSheet)
            self.present(alert, animated: true, completion: {()-> Void in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                    alert.dismiss(animated: true, completion: nil)
                }
            })
        })
    }
    
    func payPalFuturePaymentDidCancel(_ futurePaymentViewController: PayPalFuturePaymentViewController) {
        futurePaymentViewController.dismiss(animated: true, completion: {() -> Void in
            let alert = UIAlertController(title: "Future Payment Cancelled", message: "PayPal Future Payment option cancelled", preferredStyle: .actionSheet)
            self.present(alert, animated: true, completion: {()-> Void in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                    alert.dismiss(animated: true, completion: nil)
                }
            })
            self.defaults.set(true, forKey: "PAYPAL_AUTHORIZED_FUTURE_PAYMENTS")
        })
    }
    
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        payPalConfig.acceptCreditCards = true
        payPalConfig.merchantName = "Lucas Robert Designs"
        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
        
        payPalConfig.payPalShippingAddressOption = .payPal
        
        if(self.defaults.string(forKey: "PREFERRED_PAYMENT_METHOD") == "paypal"){
            self.paymentIsActive.text = "Default Payment Method"
            self.paymentIsActive.textColor = UIColor.green
        }else{
            self.paymentIsActive.text = "Set as Default?"
            self.paymentIsActive.textColor = UIColor.red
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        PayPalMobile.preconnect(withEnvironment: environemt)
    }
}
