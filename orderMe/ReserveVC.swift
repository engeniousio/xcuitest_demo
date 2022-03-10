//
//  DateVC.swift
//  iOrder
//
//  Created by Bay-QA on 30.03.16.
//  Copyright © 2016 Bay-QA. All rights reserved.
//

import UIKit

class ReserveVC: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var numberOfPeopleField: UITextField!
    
    @IBOutlet weak var pickDateLabel: UILabel!
    
    @IBOutlet weak var bookButton: UIButton!
    
    var chosenDate: String?
    var reserve: Reserve?
    
    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = true
        if let place = SingletonStore.sharedInstance.place {
            headerImageView.image = place.image
        }
        
        self.phoneField.delegate = self
        self.phoneField.keyboardType = UIKeyboardType.numberPad
        self.numberOfPeopleField.delegate = self
        self.numberOfPeopleField.keyboardType = UIKeyboardType.numberPad
       
        setPickerData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        self.setupAppearance()
    }
    
    private func setupAppearance() {
        if #available(iOS 13.4, *) {
            self.datePicker.preferredDatePickerStyle = .wheels
        }
        self.pickDateLabel.textColor = Constants.secondaryThemeColor
        self.bookButton.layer.insertSublayer(bookButton.themeGradient(), at: 0)
        self.bookButton.layer.cornerRadius = Constants.cornerRadius
        self.bookButton.clipsToBounds = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func bookTable(_ sender: AnyObject) {
        
        guard let place = SingletonStore.sharedInstance.place else { return }
        
        if phoneField.text == "" {
            showAlertWithOkButton(title: "We need your phone number", message: "Write your phone number, please.")
            return
        }
        if numberOfPeopleField.text == "" {
            guard let name = place.name else { return }
            showAlertWithOkButton(title: "We need the number of people", message: "How many of you are going to visit \(String(describing: name))?")
            return
        }
        if SingletonStore.sharedInstance.user == nil {
            showAlertWithLoginFacebookOption()
            return
        }
        guard let phoneNumber = phoneField.text,
              let numberPeople = Int(numberOfPeopleField.text!) else {
                return
        }
        let date = datePicker.date
        if date < Date() {
            showAlertWithOkButton(title: "Error", message: "Incorrect date")
            return
        }

        let myReserve = Reserve(id: 0, place: place, date: date, created: Date(), phoneNumber: phoneNumber, numberOfPeople: numberPeople)
        bookButton.isEnabled = false
        NetworkClient.makeReservation(reserve: myReserve) { (id, error) in
            self.bookButton.isEnabled = true
            if error != nil {
                self.errorAlert()
                return
            } else if self.numberOfPeopleField.text == "0" {
                self.incorrectNumberOfPeople()
                return
            }
            myReserve.id = id
            self.reserve = myReserve
            self.successAlert()
            self.phoneField.text = ""
            self.numberOfPeopleField.text = ""
            SingletonStore.sharedInstance.newReservation?.addNewReservation(reserve: myReserve)
        }

    }
    
    func showAlertWithLoginFacebookOption() {
        let alertController = UIAlertController(title: "You did not login", message: "You need to login for making orders", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action:UIAlertAction!) in
            
        }
        let toFacebookAction = UIAlertAction(title: "Login", style: .default) { (action: UIAlertAction) in
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    @IBAction func backButton(_ sender: AnyObject) {
      _ =  self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func gesture(_ sender: AnyObject) {
      _ =   self.navigationController?.popViewController(animated: true)
    }
    
    func setPickerData() {
        let todaysDate = Date()
        datePicker.minimumDate = todaysDate
        
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .minute, value: 5, to: Date())
        datePicker.setDate(date!, animated: false)
    }
}

// Alerts after request 
extension ReserveVC {
    func errorAlert(){
        showAlertWithOkButton(title: "Ooops", message: "Some problems with connection. Try again")
    }
    
    func incorrectNumberOfPeople() {
        showAlertWithOkButton(title: "Oh, nooo", message: "Incorrect number of visitors. Please, enter valid data")
    }
    
    func successAlert() {
        showAlertWithOkButton(title: "Success!", message: "Your table was successfully booked")
    }
}

// general Alert with OK button
extension ReserveVC {
    func showAlertWithOkButton(title : String, message : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler : nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion:nil)
    }
}

extension ReserveVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
