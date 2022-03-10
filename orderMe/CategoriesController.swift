//
//  CategoriesController.swift
//  orderMe
//
//  Created by Bay-QA on 03.04.16.
//  Copyright © 2016 Bay-QA. All rights reserved.
//

import UIKit

class CategoriesController: UIViewController {
    
    @IBOutlet weak var placeImage: UIImageView! // image of Place
    @IBOutlet weak var sumLabel: UILabel!    // sum in the bucket
    
    @IBOutlet weak var bucketButton: UIButton!  // go to Bucket
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    let bucket = Bucket.sharedInstance
    
    var menu: Menu?   // menu from previous ViewController ( PlaceMainMenuController )
    var categoriesArray: [Category] = [] // Keys of dictionary menu
    
    
    override func viewDidLoad() {
        if let place = SingletonStore.sharedInstance.place {
            placeImage.image = place.image
        }
        self.navigationController?.isNavigationBarHidden = true
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.isNavigationBarHidden = true
        nameLabel.text = SingletonStore.sharedInstance.place?.name
        sumLabel.text = bucket.allSum.description
        if let categories = self.menu?.categories {
            self.categoriesArray = categories
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let cell = sender as? CategoryCell,
            let order = segue.destination as? DishesController,
            let categoryNameText = cell.categoryNameLabel.text
            else  { return }
        
        order.title = categoryNameText  // name of chosen category
        order.category = cell.category    // category
        
        var dishesInCategory : [Dish] = []
        guard let dishes = menu?.dishes else { return }
        for dish in dishes {
            if dish.category_id == cell.category.id {
                dishesInCategory.append(dish)
            }
        }
        
        order.categoryMenu = dishesInCategory
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



// Mark : UITableViewDataSource, UITableViewDelegate
extension CategoriesController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as? CategoryCell {
            cell.category = categoriesArray[indexPath.item]
            cell.categoryNameLabel.text = categoriesArray[indexPath.item].name
            return cell
        }
        return UICollectionViewCell()
    }
}

extension CategoriesController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 5.0
        let collectionViewWidth = collectionView.frame.width
        let effectiveWidth = (collectionViewWidth - (2 * spacing)) / 3
        return CGSize(width: effectiveWidth, height: effectiveWidth)
    }
}

