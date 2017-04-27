//
//  AccountNavigationTableViewController.swift
//  Lucas Robert
//
//  Created by Connor Meehan on 3/22/17.
//  Copyright © 2017 CBM Web Development. All rights reserved.
//

import UIKit

class AccountNavigationTableViewController: UITableViewController{
    
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch(indexPath.row){
        case 0:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentInformationViewController") as! PaymentInformationViewController
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 1:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserAccountInformationViewController") as! UserAccountInformationViewController
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 2:break
        default:break
        }
    }
    
    override func loadView() {
        super.loadView()
    }
}
