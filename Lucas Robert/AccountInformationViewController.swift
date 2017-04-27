//
//  AccountInformationViewController.swift
//  Lucas Robert
//
//  Created by Connor Meehan on 1/13/17.
//  Copyright © 2017 CBM Web Development. All rights reserved.
//

import UIKit

class AccountInformationViewController: UIViewController{
    /*
     * This method shows the navigation drawer when the hamburger icon is tapped.
     *
     */
    @IBAction func showMenuButtonTapped(_ sender: Any) {
        NavigationDrawerViewController.load()
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
    /*
     * This method takes the user to their cart for review and ordering
     */
    @IBAction func viewCartButtonTouched(){
        let cartStoryBoard : UIStoryboard = UIStoryboard(name: "Cart", bundle: nil)
        let vc = cartStoryBoard.instantiateViewController(withIdentifier: "ReviewOrderViewController") as! ReviewOrderViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "Account"
    }
}
