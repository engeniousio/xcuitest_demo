//
//  MakeOrderVC.swift
//  iOrder
//
//  Created by Bay-QA on 02.04.16.
//  Copyright © 2016 Bay-QA. All rights reserved.
//

import UIKit

class DishesController: UIViewController, BucketCellProtocolAddDelete, InfoDishProtocol {
    
    @IBOutlet weak var orderTableView: UITableView!

    @IBOutlet weak var bucketSumLabel: UILabel!
    
    @IBOutlet weak var placeImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var categoryMenu: [Dish]?

    let bucket = Bucket.sharedInstance
    var category: Category?
    
    override func viewDidLoad() {
        if let place = SingletonStore.sharedInstance.place {
            placeImageView.image = place.image
        }
        
        self.orderTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        nameLabel.text = SingletonStore.sharedInstance.place?.name
        bucketSumLabel.text = bucket.allSum.description
        orderTableView.reloadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func getNumberofItems(_ myCell: UITableViewCell){
        if let cell = myCell as? DishCell {
            cell.itemsCount = 0
            for d in bucket.myBucket.keys {
                if d.id == cell.dish.id {
                    cell.itemsCount = bucket.myBucket[d]!
                    break
                }
            }
        }
    }
    
    func addDish(_ dish: Dish) {
       // bucket.allSum += dish.price!  // TODO delete "!"
        bucketSumLabel.text = bucket.allSum.description
    }
    func deleteDish(_ dish: Dish) {
      //  bucket.allSum -= dish.price!   // TODO delete "!"
        bucketSumLabel.text = bucket.allSum.description
    }
    
    func showInfoDish(_ d: Dish) {
        let alertController = UIAlertController(title: "Information", message: d.dishDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    @IBAction func backButton(_ sender: AnyObject) {
       self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func gesture(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
}


// MARK: UITableViewDelegate, UITableViewDataSource

extension DishesController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let menu = categoryMenu else { return 0 }
        return menu.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let menu = categoryMenu,
            let cell = tableView.dequeueReusableCell(withIdentifier: "dishCell", for: indexPath) as? DishCell else { return UITableViewCell() }
        
        let name = menu[indexPath.row].name
        cell.dishName.text = name
        cell.dish = menu[indexPath.row]
        cell.priceLabel.text = menu[indexPath.row].price?.description
        getNumberofItems(cell)  // TODO count in more elegant way
        cell.numberOfItemsLabel.text = cell.itemsCount.description
        cell.cellDelegate = self
        cell.infoD = self
        cell.accessibilityIdentifier = name
        
        return cell
        
    }
}
