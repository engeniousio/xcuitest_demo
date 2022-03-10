//
//  ReservesController.swift
//  orderMe
//
//  Created by Bay-QA on 6/2/16.
//  Copyright © 2016 Bay-QA. All rights reserved.
//

import UIKit

enum Reservation: Int {
    case past = 0
    case current
    
    var count: Int {
        return 2
    }
    
    var text: String {
        switch self {
        case .past: return "Past reservations"
        case .current: return "Current reservations"
        }
    }
}

class ReservesController: UIViewController, RepeatQuestionProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var reservLegendView: UIView!
    
    var pastReserves: [Reserve] = []
    var futureReserves: [Reserve] = []
    let reservationViewHeight: CGFloat = 80.0
    var segmentedView: ReservationView!
    
    var selectedReservation: Reservation = .current {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        if SingletonStore.sharedInstance.user != nil {
            self.loadData()
            SingletonStore.sharedInstance.newReservation = self
        }
        self.setupSegmentedView()
        self.setupLegendView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if SingletonStore.sharedInstance.user == nil {
            showAlertWithLoginFacebookOption()
        }
    }
    
    func loadData() {
        NetworkClient.getReservations { (reservations, error) in
            if error != nil {
                return
            }
            guard let reservs = reservations else { return }
            
            for reserve in reservs {
                guard let dateOfReserve = reserve.date else { return }
                if dateOfReserve > Date() {
                    self.futureReserves.append(reserve)
                } else {
                    self.pastReserves.append(reserve)
                }
            }
            self.tableView.reloadData()
        }
    }
    
    fileprivate func setupSegmentedView() {
        segmentedView = ReservationView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: reservationViewHeight))
        self.view.addSubview(segmentedView)
        segmentedView.segmentedControl.selectedSegmentIndex = selectedReservation.rawValue
        segmentedView.delegate = self
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        self.tableView.contentInset = UIEdgeInsets(top: reservationViewHeight - statusBarHeight + 35, left: 0, bottom: 0, right: 0)
    }
    
    fileprivate func setupLegendView() {
        reservLegendView.frame = CGRect(x: 0, y: segmentedView.frame.height, width: view.frame.width, height: 35)
        view.addSubview(reservLegendView)
    }

    func confirmationAlert(_ reserve: Reserve) {
        guard let name = reserve.place?.name else { return }
        let alertController = UIAlertController(title: "Cancel", message: "Are you sure that you want to cancel your reservation in \(name)?" , preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes, cancel", style: .default) { _ in
            guard let id = reserve.id else { return }
            NetworkClient.deleteReservation(id: id, completion: { (success, error) in
                if error != nil {
                    self.notOkAlert()
                }
                self.okAlert()
                var i = 0
                for futureReserve in self.futureReserves {
                    guard let reserveId = reserve.id,
                        let futureReserveId = futureReserve.id else {
                            return
                    }
                    if reserveId == futureReserveId {
                        self.futureReserves.remove(at: i)
                        self.tableView.reloadData()
                        break
                    }
                    i += 1
                }
                
            })
            
        }
        let cancelAction = UIAlertAction(title: "I don't want to cancel", style: .default)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    
    
    func okAlert(){
        showAlert(title: "Cancelation", message: "Thank you! Your reservation was canceled")
    }
    
    func notOkAlert() {
        showAlert(title: "Ooops", message: "Some problems with connection")
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    func showAlertWithLoginFacebookOption() {
        let alertController = UIAlertController(title: "You did not login", message: "You need to login for viewing your orders", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in
            self.tabBarController?.selectedIndex = 1
        }
        let toFacebookAction = UIAlertAction(title: "Login", style: .default) { _ in
            self.navigationController?.popToRootViewController(animated: true)
            if let LoginViewController = self.storyboard?.instantiateViewController(withIdentifier: "RootNaviVC") as? UINavigationController {
                LoginViewController.modalPresentationStyle = .fullScreen
                self.present(LoginViewController, animated: true) {
                    SingletonStore.sharedInstance.user = nil
                }
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(toFacebookAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}


// Mark : UITableViewDataSource
extension ReservesController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.selectedReservation {
            case .current: return futureReserves.count
            case .past: return pastReserves.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reservation: Reserve!
        
        switch self.selectedReservation {
            case .current: reservation = futureReserves[indexPath.row]
            case .past:    reservation = pastReserves[indexPath.row]
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FutureReservationCell.identifier, for: indexPath) as? FutureReservationCell,
            reservation.date != nil else { return UITableViewCell() }
        
        cell.configureCell(with: reservation)
        cell.repquestion = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch selectedReservation {
        case .current:  return true
        case .past:     return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            confirmationAlert((tableView.cellForRow(at: indexPath) as! FutureReservationCell).reserve)
        default:
            ()
        }
    }
}

//MARK: NewReservationProtocol
extension ReservesController: NewReservationProtocol {
    func addNewReservation(reserve: Reserve) {
        self.futureReserves.append(reserve)
        self.tableView.reloadData()
    }
}

extension ReservesController: ReservationViewDelegate {
    func segmentViewDidChange(to segment: Int) {
        if let newReservation = Reservation.init(rawValue: segment) {
            self.selectedReservation = newReservation
        }
    }
    
    
}


