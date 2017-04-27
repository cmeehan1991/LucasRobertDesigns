//
//  NavigationDrawerViewController.swift
//  Lucas Robert
//
//  Created by Connor Meehan on 1/13/17.
//  Copyright © 2017 CBM Web Development. All rights reserved.
//

import UIKit

class NavigationDrawerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    let defaults = UserDefaults.standard
    let navItems = ["Home", "Shop", "Account", "Log Out"]
    var userLogOutModel = UserLogOutModel()
    
    @IBOutlet weak var navigationTable: UITableView!
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return navItems.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "navCell", for: indexPath) as! NavigationTableViewCell
        myCell.navigationItemLabel.text = navItems[indexPath.row]
        return myCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch(indexPath.row){
        case 0:
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let centerViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            let centerNavController = UINavigationController(rootViewController: centerViewController)
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.centerContainer!.centerViewController = centerNavController
            appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
            break
        case 1:
            let storyboard : UIStoryboard = UIStoryboard(name: "Shop", bundle: nil)
            let centerViewController = storyboard.instantiateViewController(withIdentifier: "ShopCategoryViewController") as! ShopCategoryViewController
            let centerNavController = UINavigationController(rootViewController: centerViewController)
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.centerContainer!.centerViewController = centerNavController
            appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
            break
        case 2:
            let storyboard : UIStoryboard = UIStoryboard(name: "Account", bundle: nil)
            let centerViewController = storyboard.instantiateViewController(withIdentifier: "AccountInformationViewController") as! AccountInformationViewController
            let centerNavController = UINavigationController(rootViewController: centerViewController)
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.centerContainer!.centerViewController = centerNavController
            appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
            break
        case 3:
            defaults.set(false, forKey: "IS_LOGGED_IN")
            self.userLogOutModel.userLogOut()
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let centerViewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
            let centerNavController = UINavigationController(rootViewController: centerViewController)
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.centerContainer!.centerViewController = centerNavController
            appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
            break
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setToolbarHidden(true, animated: false)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationTable.reloadData()
    }
}
