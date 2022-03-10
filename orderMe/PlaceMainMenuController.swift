//
//  TwoButtons.swift
//  iOrder
//
//  Created by Bay-QA on 29.03.16.
//  Copyright © 2016 Bay-QA. All rights reserved.
//

import UIKit
import MapKit

enum CallWaiterReason: Int {
    case bringMenu = 1, bringTheBill, cleanTable, shisha, other, cancel
}


class PlaceMainMenuController: UIViewController {
    
    let instance = SingletonStore.sharedInstance
    var place: Place?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!
    
    // photos in rows in static table
    var photosOfAction: [String] = []
    
    // menu, that will be downloaded async later
    var menu: Menu? = nil
    
    override func viewDidLoad() {
        self.title = place?.name
        
        // icons of main buttons
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        if let image = place?.image {
            placeImage.image = image
        }
        else {
            self.downloadImage(place?.imagePath)
        }
        
        // async loading Menu For next Viewcontroller
        self.loadMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        //self.prefersStatusBarHidden
        self.headerLabel.text = place?.name
        self.collectionView.reloadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // downloading an image (only if app did not downloaded it in the previous VC )
    fileprivate func downloadImage(_ urlOpt: String?) {
        guard let url = urlOpt else { return }
        NetworkClient.downloadImage(url: url) { (imageOpt, error) in
            if error != nil {
                return
            }
            guard let image = imageOpt else {
                return
            }
            
            //DispatchQueue.main.async {
            self.place?.image = imageOpt
            self.placeImage.image = image
            //}
        }
    }
    
    // ask about reason
    fileprivate func callAWaiter() {
        
        let alertController = UIAlertController(title: "The waiter is on his way", message: "How can he help you?", preferredStyle: .alert)
        
        let menuAction = UIAlertAction(title: "Bring a menu", style: .default) { _ in
            self.callWaiterRequest(.bringMenu)
        }
        let checkAction = UIAlertAction(title: "Bring the bill", style: .default) { _ in
            self.callWaiterRequest(.bringTheBill)
        }
        let cleanAction = UIAlertAction(title: "Clean the table", style: .default) { _ in
            self.callWaiterRequest(.cleanTable)
        }
        let shishaAction = UIAlertAction(title: "Call a hookah man", style: .default) { _ in
            self.callWaiterRequest(.shisha)
        }
        let otherAction = UIAlertAction(title: "Other", style: .default) { _ in
            self.callWaiterRequest(.other)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(menuAction)
        alertController.addAction(checkAction)
        alertController.addAction(cleanAction)
        alertController.addAction(shishaAction)
        alertController.addAction(otherAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Send request with specific reason of calling waiter
    func callWaiterRequest(_ reason: CallWaiterReason) {
        
        let placeId = place?.id
        let date = Date()
        let idTable = SingletonStore.sharedInstance.tableID
        
        NetworkClient.callAWaiter(placeId: placeId!, idTable: idTable, date: date, reason: reason.rawValue) { (success, error) in
            if error != nil {
                self.showAlert(title: "Ooops", message: "Some problems with connection")
            }
            else {
                self.showAlert(title: "Got it!", message: "The waiter is on his way")
                NetworkClient.analytics(action: .waiterCalled, info: "\(reason.rawValue)")
                NetworkClient.analytics(action: .waiterCalled, info: "\(reason.rawValue)")
            }
        }
    }
    
    // general AlertController with OK action
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func backButton(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func gest(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func openMapForPlace() {
        guard let lat1  = place?.latitude ,
            let lng1  = place?.longitude  else {
                return
        }
        
        guard let latitute: CLLocationDegrees =  Double(lat1),
            let longitute: CLLocationDegrees =  Double(lng1) else {
                return
        }
        
        let regionDistance: CLLocationDistance = 1000
        let coordinates = CLLocationCoordinate2DMake(latitute, longitute)
        let regionSpan = MKCoordinateRegion.init(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        if let name = self.place?.name {
            mapItem.name = "\(name)"
        }
        mapItem.openInMaps(launchOptions: options)
    }
    
    func loadMenu(){ // async downloading menu for newxt VC
        guard let id = place?.id else { return }
        NetworkClient.getMenu(placeId: id) { (menu, error) in
            if error != nil {
                self.showAlert(title: "Network problem", message: "Please check your internet connection.")
            }
            
            self.menu = menu
            // TODO: make delegate to pass the menu even if user is already on the next ViewController
        }
    }
}

// MARK: UICollectionViewDataSource

extension PlaceMainMenuController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PlaceCellDataStore.caseCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActionCell",for: indexPath) as? ActionCell, let place = place else {
            return UICollectionViewCell()
        }
            
        let store = PlaceCellDataStore.element(by: indexPath.row, for: place)
        cell.actionName.text = store.data.text
        cell.accessibilityIdentifier = store.data.text
        cell.actionPhoto.image = store.data.image
        
        
        if indexPath.row == 0, instance.tableID != -1 {
            cell.actionName.text = "Table #" + instance.tableID.description
        }
        return cell
    }
}

// MARK: UICollectionViewDelegate

extension PlaceMainMenuController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch PlaceCellDataStore.element(by: indexPath.item, for: place!) {
        case .detectTable:  // Detecting table ID -  if app runs on simulator go to SimulatorTableId,
            // else go to GetTableIdVc (QRcode scanner)
            
            // TODO:
            if true /* Platform.isSimulator */ {
                self.navigationController?.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "simulatorTable") as! SimulatorTableId, animated: true)
            } else {
//                self.navigationController?.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "getTable") as! GetTableIdVC, animated: true)
            }
            
        case .menu: // open CategoriesController for chosing menu
            if let categoriesControler = self.storyboard!.instantiateViewController(withIdentifier: "CatVC") as? CategoriesController {
                categoriesControler.menu = self.menu
                self.navigationController?.pushViewController(categoriesControler, animated: true)
            }
            
        case .reservation: // open ReserveVC for reserving table
            self.navigationController?.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "reserveVC") as! ReserveVC, animated: true)
            
        case .callAWaiter:
            if instance.tableID != -1 {
                callAWaiter()
            }
            else {
                let alertController = UIAlertController(title: "Pick the table, please", message: "Capture QR code on your table, please", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction!) in
                    self.navigationController?.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "getTable") as! GetTableIdVC, animated: true)
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion:nil)
            }
            
        case .phone(let pl):
            guard let placeName = place?.name else { return }
            let phoneNumber = pl.phone ?? ""
            let alertController = UIAlertController(title: "Call \(placeName)", message: "Call \(phoneNumber)?", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Call", style: .default) { (action: UIAlertAction!) in
                
                if let phoneCallURL: URL = URL(string: "tel://\(phoneNumber)") {
                    let application: UIApplication = UIApplication.shared
                    if (application.canOpenURL(phoneCallURL)) {
                        application.openURL(phoneCallURL);
                    }
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
        case .address(_):
            self.openMapForPlace()
        }
        
    }
    
}

extension PlaceMainMenuController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 5.0
        let collectionViewWidth = collectionView.frame.width
        let effectiveWidth = (collectionViewWidth - (2 * spacing)) / 3
        return CGSize(width: effectiveWidth, height: effectiveWidth)
    }
}





