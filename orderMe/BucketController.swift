//
//  BucketController.swift
//  iOrder
//
//  Created by Bay-QA on 05.04.16.
//  Copyright © 2016 Bay-QA. All rights reserved.
//

import UIKit
import Foundation

class BucketController: UIViewController, UITextViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sumLabel: UILabel!
    @IBOutlet weak var commentTextView: UITextView!
    
    @IBOutlet weak var deleteAllButton: UIButton!
    @IBOutlet weak var makeAnOrderButton: UIButton!
    
    @IBOutlet weak var headerView: UIView!
    
    private let buttonCornerRadius: CGFloat = 4.0
    fileprivate let headerViewHeightWithSafeArea: CGFloat = 100.0
    
    var dishesInBucket: [Dish]?
    var amountOfDishesInBucket: [Int]?
    
    var myOrder: Order?
    
    override func viewDidLoad() {
        sumLabel.text = Bucket.sharedInstance.allSum.description
        makeBucket()
        tableView.dataSource = self
        commentTextView.delegate = self
        
        self.commentTextView.accessibilityIdentifier = "commentTextInBucket"
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.setupAppearance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    fileprivate func setupAppearance() {
        let color = UIColor.darkGray
        
        self.deleteAllButton.layer.cornerRadius = buttonCornerRadius
        self.deleteAllButton.layer.borderWidth = 1
        self.deleteAllButton.layer.borderColor = color.cgColor
        self.deleteAllButton.clipsToBounds = true
        self.deleteAllButton.backgroundColor = UIColor.white
        self.deleteAllButton.tintColor = color
        
        self.makeAnOrderButton.layer.cornerRadius = buttonCornerRadius
        self.makeAnOrderButton.clipsToBounds = true
        self.makeAnOrderButton.layer.insertSublayer(self.makeAnOrderButton.themeGradient(), at: 0)
        self.makeAnOrderButton.tintColor = UIColor.white
        
        self.commentTextView.layer.cornerRadius = buttonCornerRadius
        self.commentTextView.clipsToBounds = true
        self.commentTextView.layer.borderWidth = 1
        self.commentTextView.layer.borderColor = UIColor.darkGray.cgColor
        
        if UIDevice().hasSafeArea {
            headerView.bottomAnchor.constraint(equalTo: view.topAnchor, constant: headerViewHeightWithSafeArea).isActive = true
        }
        self.headerView.layer.insertSublayer(self.headerView.themeGradient(), at: 0)
        self.headerView.clipsToBounds = true

    }
    
    // transfer from current Bucket array of dishes and array of amounts of same dishes
    private func makeBucket() {
        let bucket = Bucket.sharedInstance.myBucket
        let dishes = bucket.keys
        dishesInBucket = Array(dishes)
        let amount = bucket.values
        amountOfDishesInBucket = Array(amount)
    }
    
    // delete everything in the Bucket and on the current ViewController
    @IBAction func deleteAll() {
        Bucket.sharedInstance.myBucket = [:]
        Bucket.sharedInstance.allSum = 0
        dishesInBucket = []
        amountOfDishesInBucket = []
        sumLabel.text = "0"
        commentTextView.text = ""
        tableView.reloadData()
    }
    
    
    @IBAction func makeAnOrder() {
        
        // if the user did not scan the QR code yet, program forces him to do that before ordering
        if SingletonStore.sharedInstance.tableID == -1 {
            let alertController = UIAlertController(title: "Choose a table", message: "Scan the QR code, please and the program will detect the number of your table", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                self.navigationController?.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "simulatorTable") as! SimulatorTableId, animated: true)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion:nil)
        }
            
        else { // user scanned QR code
            if Bucket.sharedInstance.myBucket.isEmpty { // user did not select any dishes
                showAlertWithOkButton(title: "Empty order", message: "You did not choose any dishes, try again")
            }
            else if SingletonStore.sharedInstance.user == nil {
                showAlertWithLoginFacebookOption()
            }
            else { // make a request Order
                makeRequestOrder()
            }
        }
    }
    
    func showAlertWithLoginFacebookOption() {
        let alertController = UIAlertController(title: "You did not login", message: "You need to login for reservations", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let toFacebookAction = UIAlertAction(title: "Login", style: .default) { _ in
            if let LoginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginViewController {
                LoginVC.cameFromReserveOrOrderProcess = true
                LoginVC.modalPresentationStyle = .fullScreen
                self.present(LoginVC, animated: true)
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(toFacebookAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    func makeRequestOrder() {
        guard let place = SingletonStore.sharedInstance.place else { return }
        
        var extraComments = ""
        
        if let comments = commentTextView.text {
            if comments != "Your comments: " {
                extraComments = comments
            }
        }
        
        let order = Order(id: -1, place: place, idTable: SingletonStore.sharedInstance.tableID, bucket: Bucket.sharedInstance.myBucket, comments: extraComments, created: Date(), sum: Bucket.sharedInstance.allSum)
        
        NetworkClient.makeOrder(order: order) { (id, error) in
            if error != nil {
                self.errorAlert(error)
                return
            }
            order.id = id
            self.myOrder = order
            self.succesAlert()
            SingletonStore.sharedInstance.newOrder?.addNewOrder(order: order)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    @IBAction func backButton(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func gesture(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
}

// Mark : UITableViewDataSource

extension BucketController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Bucket.sharedInstance.myBucket.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: BucketCell.identifier, for: indexPath) as? BucketCell {
            cell.dishNameLabel.text = dishesInBucket?[(indexPath as NSIndexPath).row].name
            cell.amountLabel.text = amountOfDishesInBucket?[(indexPath as NSIndexPath).row].description
            
            guard let priceOfOneDish = dishesInBucket?[(indexPath as NSIndexPath).row].price,
                let amountOfDish = amountOfDishesInBucket?[(indexPath as NSIndexPath).row]
                else {
                    return UITableViewCell()
            }
            let price = priceOfOneDish * Double(amountOfDish)
            cell.priceLabel.text = price.description
            cell.dish = dishesInBucket?[(indexPath as NSIndexPath).row]
            
            cell.bucketCellDelegateAddDelete = self
            cell.backgroundColor = UIColor.lightGray.withAlphaComponent(0)
            return cell
        }
        return UITableViewCell()
    }
}

// Mark : BucketCellProtocolAddDelete

extension BucketController: BucketCellProtocolAddDelete {
    func addDish(_ dish: Dish) {
        let newPrice = Bucket.sharedInstance.allSum
        sumLabel.text = "$\(newPrice.description)"
    }
    
    func deleteDish(_ dish: Dish) {
        let newPrice = Bucket.sharedInstance.allSum
        sumLabel.text = "$\(newPrice.description)"
    }
}

// MARK: Alerts after request
extension BucketController {
    func succesAlert() {
        deleteAll()
        showAlertWithOkButton(title: "Success!", message: "Your order was successfully sent to the kitchen")
    }
    
    func errorAlert(_ error: NSError?) {
        if let error = error {
            showAlertWithOkButton(title: "Oooops", message: "Some problem with connection. Try again. \(error.domain)")
        }
    }
}

// general Alert with OK button
extension BucketController {
    func showAlertWithOkButton(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: Hide keyboard when tap somewhere on view
extension BucketController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BucketController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
