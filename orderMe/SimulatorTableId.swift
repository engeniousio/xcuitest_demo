//
//  SimulatorTableId.swift
//  orderMe
//
//  Created by Bay-QA on 13.04.16.
//  Copyright © 2016 Bay-QA. All rights reserved.
//

import UIKit


// due to unability to use camera for QR_CODE in simulator
class SimulatorTableId: UIViewController {

    @IBOutlet weak var tid: UITextField!
    
    override func viewDidLoad() {
        navigationController?.isNavigationBarHidden = false
        self.tid.accessibilityIdentifier = AI.TableIDScreen.tableNumberTextField
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    navigationController?.navigationBar.layer.insertSublayer(CALayer().setGradient(navigationController: navigationController!), at: 1)

        navigationController?.navigationBar.tintColor = .white
        tid.keyboardType = UIKeyboardType.numberPad
    }
    
    @IBAction func button(_ sender: AnyObject) {
        if let myTableId = Int(tid.text!) {
            let sTone = SingletonStore.sharedInstance
            sTone.tableID = myTableId
            self.navigationController?.popViewController(animated: true)
        }
    }

}
