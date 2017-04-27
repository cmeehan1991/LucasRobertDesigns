//
//  CheckOutViewController.swift
//  Lucas Robert
//
//  Created by Connor Meehan on 4/19/17.
//  Copyright © 2017 CBM Web Development. All rights reserved.
//

import UIKit

class CheckOutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PayPalPaymentDelegate, CheckOutInformationProtocol, ProcessPaymentProtocol, ProcessOrderProtocol{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var shippingTable: UITableView!
    @IBOutlet weak var billingTable: UITableView!
    @IBOutlet weak var orderTable: UITableView!
    @IBOutlet weak var itemSubtotalLabel: UILabel!
    @IBOutlet weak var shippingAndHandlingLabel: UILabel!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var estimatedTaxLabel: UILabel!
    @IBOutlet weak var orderTotalLabel: UILabel!
    
    let defaults = UserDefaults.standard
    let currencyStyle: NumberFormatter = NumberFormatter()
    var paymentMethod: String = String()
    var processPaymentModel = ProcessPaymentModel()
    var processOrderModel = ProcessOrderModel()
    var orderID: String = String()
    var orderStatus: Bool = Bool()
    var total : NSDecimalNumber = NSDecimalNumber()
    var cartItemKey: String = String(), itemImageURL: NSMutableArray = NSMutableArray(), items : NSMutableArray = NSMutableArray(), itemNames : NSMutableArray = NSMutableArray(), itemSubtotal: Array<String> = Array<String>(), itemQuantity : Array<String> = Array<String>(), itemPrice : NSMutableArray = NSMutableArray(), itemSku : NSMutableArray = NSMutableArray(), shippingName: String = String(), shippingAddress: String = String(), billingName: String = String(), billingAddress: String = String()
    var checkOutInformationModel = CheckOutInformationModel()
    
    var environment: String = PayPalEnvironmentNoNetwork{
        willSet(newEnvironment){
            if newEnvironment != environment{
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    
    var payPalConfig = PayPalConfiguration()
    
    /*
     * This function is from the CheckOutInformationProtocol
     * With this we will populate the necessary data in order to fill the checkout page.
     * After the tables have reloaded their data then the view will appear.
     */
    func itemsDownloaded(shippingName: String, shippingAddress: String, billingAddress: String, billingName: String, itemName: NSArray, itemSKU: NSArray, itemImageURL: NSArray, itemQuantity: NSArray, itemSubtotal: NSArray){
        
        // Assign the values to local variables
        self.shippingName = shippingName
        self.shippingAddress = shippingAddress
        self.billingAddress = billingAddress
        self.billingName = billingName
        self.itemNames = itemName as! NSMutableArray
        self.itemSku = itemSKU as! NSMutableArray
        self.itemImageURL = itemImageURL as! NSMutableArray
        self.itemQuantity = itemQuantity as! Array<String>
        self.itemSubtotal = itemSubtotal as! Array<String>
        
        // Reload the tableviews after the variables have been assigned new data
        self.shippingTable.reloadData()
        self.billingTable.reloadData()
        self.orderTable.reloadData()
        
        // Update the order information section
        // Convert the item quantity array from string to integer
        let subttl: Array<Int> = self.itemSubtotal.flatMap{Int($0)!}
        var totalSub: Int = Int()
        for i in 0..<(subttl.count){
            totalSub += subttl[i]
        }
        
        self.itemSubtotalLabel.text = currencyStyle.string(from:NSNumber(value: totalSub))
        self.shippingAndHandlingLabel.text = currencyStyle.string(from:NSNumber(value: 12)) // Shipping needs to be updated to whatever the proper charge is.
        self.estimatedTaxLabel.text = currencyStyle.string(from:NSNumber(value: 0)) // Tax is not to be chared for any retailer sales
        self.subTotalLabel.text = currencyStyle.string(from: NSNumber(value: totalSub + 12)) // This label is the sum of the shipping and the order subtotal
        self.orderTotalLabel.text = currencyStyle.string(from: NSNumber( value: totalSub + 12 + 0)) // This label is the sum of the subtotal and the tax.
        
        // Hide the loading spinner and show the scrollview
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
        self.scrollView.isHidden = false
        self.scrollView.isScrollEnabled = true
    }
    
    func paymentProcessed(processed: Bool) {
        <#code#>
    }
    
    func orderCompleted(orderStatus: Bool, orderID: String) {
        self.orderStatus = orderStatus
        self.orderID = orderID
        
        self.processPaymentModel.delegate = self
        self.processPaymentModel.processPayment(orderID: self.orderID)
    }
    
    
    /* Process order and set up single payment
     * Process the order
     * If the payment type is paypale then process the paypal payment.
     * If the payment type is COD or check then process the order without payment.
     */
    @IBAction func placeOrder(){
        self.processOrderModel.delegate = self
        self.processOrderModel.processOrder(userID: self.defaults.string(forKey: "USER_ID")!, paymentMethod: self.defaults.string(forKey: "PREFERRED_PAYMENT_METHOD")!)
        if(self.defaults.string(forKey: "PREFERRED_PAYMENT_METHOD") == "paypal"){
            
            for i in 0..<(self.itemNames.count){
                let item = PayPalItem(name: itemNames[i] as! String, withQuantity: UInt(itemQuantity[i] )!, withPrice: NSDecimalNumber(string: String((Double(itemSubtotal[i])!/Double(itemQuantity[i])!))), withCurrency: "USD", withSku: itemSku[i] as? String)
                self.items.add(item)
            }
            
            let subtotal = PayPalItem.totalPrice(forItems: items as! [Any])
            
            let shipping = NSDecimalNumber(string: "12.00")
            let tax = NSDecimalNumber(string: "0.00")
            
            let total = subtotal.adding(shipping).adding(tax)
            
            let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
            let payment = PayPalPayment(amount: total, currencyCode: "USD", shortDescription: "Lucas Robert Designs", intent: .sale)
            
            payment.items = items as? [Any]
            payment.paymentDetails = paymentDetails
            
            if payment.processable {
                let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
                self.present(paymentViewController!, animated: true, completion: nil)
            }else{
                // Handle unprocessable payments here.
                // Exampls of that would be if the amount was negative or the shortDescription was empty.
                print("Payment not processable: \(String(describing: payment))")
            }
        }else{
        }
    }
    
    /*
     * Handle if the PayPal payment was cancelled
     */
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        print("PayPal Payment Cancelled")
        let paymentAction = UIAlertController(title: "Payment Cancelled", message: "The PayPal payment was cancelled", preferredStyle: .actionSheet)
        paymentViewController.dismiss(animated: true, completion: nil)
        self.present(paymentAction, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            paymentAction.dismiss(animated: true, completion: nil)
        }
        
    }
    
    /*
     * Handle if the payment was successful
     *
     */
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        print("Payment Success!")
        print(completedPayment.confirmation)
        let response = completedPayment.confirmation["response"] as! NSDictionary
        if (response["state"] as! String == "approved"){
            
        }
        paymentViewController.dismiss(animated: true, completion: nil)
        
        // If the payment was successfully process then we will process the order with woocommerce.
        
        
        let paymentAction = UIAlertController(title: "Order Submitted", message: "Your order has been submitted", preferredStyle: .actionSheet)
        self.present(paymentAction, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            paymentAction.dismiss(animated: true, completion: nil)
        }
    }
    
    /*
     * Set up the Shipping Address, Billing Information, and Order Items tables
     * tag 0: Shipping Address
     * tag 1: Billing Information
     * tag 2: Order Items
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView.tag == 0){
            return 1
        }else if (tableView.tag == 1){
            return 1
        }else if(tableView.tag == 2){
            return self.itemNames.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView.tag == 0){
            let cell = self.shippingTable.dequeueReusableCell(withIdentifier: "ShippingInformationCellViewController") as! ShippingInformationCellViewController
            cell.shippingToNameLabel.text = self.shippingName
            cell.shippingToAddressLabel.text = self.shippingAddress
            return cell
        }else if(tableView.tag == 1){
            let cell = self.billingTable.dequeueReusableCell(withIdentifier: "BillingInformationCellViewController") as! BillingInformationCellViewController
            cell.billingToNameLabel.text = self.billingName
            cell.billingToAddressLabel.text = self.billingAddress
            return cell
        }else if(tableView.tag == 2){
            let cell = orderTable.dequeueReusableCell(withIdentifier: "CartCellViewController") as! CartCellViewController
            // Load the image first because that will take the longest
            let imageURL = URL(string: itemImageURL[indexPath.row] as! String)
            let imageData = try? Data(contentsOf: imageURL!)
            DispatchQueue.main.async{
                cell.itemImage.image = UIImage(data: imageData!)
                cell.itemImage.contentMode = .scaleAspectFit
            }
            cell.itemName.attributedText = self.itemNames[indexPath.row] as? NSAttributedString
            cell.itemQuantityLabel.text = self.itemQuantity[indexPath.row]
            
            return cell
        }else{
            let cell: UITableViewCell = UITableViewCell()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch(tableView.tag){
        case 0:
            let storyBoard: UIStoryboard = UIStoryboard(name: "Account", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "AccountInformationTableViewController") as! AccountInformationTableViewController
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 1:
            let storyBoard: UIStoryboard = UIStoryboard(name: "Account", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "AccountInformationTableViewController") as! AccountInformationTableViewController
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 2: break
        default: break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        PayPalMobile.preconnect(withEnvironment: environment)
        
        self.scrollView.isHidden = true
        self.activityIndicator.startAnimating()
        
        
        self.billingTable.delegate = self
        self.billingTable.dataSource = self
        self.shippingTable.delegate = self
        self.shippingTable.dataSource = self
        self.orderTable.delegate = self
        self.orderTable.dataSource = self
        
        self.checkOutInformationModel.delegate = self
        self.checkOutInformationModel.downloadItems(userID: self.defaults.string(forKey: "USER_ID")!, cartItemKey: self.cartItemKey)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up payPalConfig
        payPalConfig.acceptCreditCards = false
        payPalConfig.merchantName = "Lucas Robert Designs"
        payPalConfig.merchantPrivacyPolicyURL = URL(string: "")
        payPalConfig.merchantUserAgreementURL = URL(string: "")
        
        // Set the language to English
        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
        
        // Set the NumberFormatter to style currency
        self.currencyStyle.numberStyle = .currency
        
        
    }
}
