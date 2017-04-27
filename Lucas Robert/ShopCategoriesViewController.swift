//
//  ShopCategoriesViewController.swift
//  Lucas Robert
//
//  Created by Connor Meehan on 3/17/17.
//  Copyright © 2017 CBM Web Development. All rights reserved.
//

import UIKit

class ShopCategoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    @IBOutlet weak var categoryCollectionView : UICollectionView!
    let categories = ["Necklaces","Bracelets","Earrings","Enhancers","Sets","Accessories"]
    let categoryImages = [UIImage(named:"LR 103"), UIImage(named: "LR 105"), UIImage(named: "LR 134"), UIImage(named:"enhancers"), UIImage(named:"LR 660 LR 662"), UIImage(named:"logo tag")]
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCategoryCellViewController", for: indexPath) as! ProductCategoryCellViewController
        cell.categoryImage.image = categoryImages[indexPath.item]
        cell.categoryLabel.text = categories[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch(indexPath.item){
        case 0:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShopViewController") as! ShopViewController
            vc.category = "necklaces"
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 1:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShopViewController") as! ShopViewController
            vc.category = "bracelet"
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 2:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShopViewController") as! ShopViewController
            vc.category = "earring"
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 3:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShopViewController") as! ShopViewController
            vc.category = "enhancer"
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 4:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShopViewController") as! ShopViewController
            vc.category = "sets"
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 5:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShopViewController") as! ShopViewController
            vc.category = "accessories"
            self.navigationController?.pushViewController(vc, animated: true)
            break
        default:break
        }
    }
    
    override func viewDidLoad() {
        self.categoryCollectionView.delegate = self
        self.categoryCollectionView.dataSource = self
    }
}
