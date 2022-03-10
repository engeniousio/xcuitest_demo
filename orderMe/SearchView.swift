//
//  Search.swift
//  orderMe
//
//  Created by Bay-QA on 2/6/18.
//  Copyright © 2018 Bay-QA. All rights reserved.
//

import UIKit

protocol SearchViewDelegate: class {
    func updateSearchResults(for searchField: UITextField, text: String)
    func userDidPressQRButton()
}

class SearchView: UIView {
    
    lazy var searchField: UITextField = .init(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
    lazy var qrCodeButton: UIButton = .init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    private var stackView: UIStackView!
    
    weak var searchResultsUpdater: SearchViewDelegate?
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        UIView().endEditing(true)
        searchField.resignFirstResponder()
        return false
    }

    override func layoutSubviews() {
        searchField.borderStyle = .none
        searchField.font = UIFont.systemFont(ofSize: 18)
        searchField.backgroundColor = UIColor.white
        searchField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        searchField.layer.sublayerTransform = CATransform3DMakeTranslation(12, 0, 0)

        qrCodeButton.setImage(#imageLiteral(resourceName: "qrcode4"), for: .normal)
        qrCodeButton.backgroundColor = .white
        qrCodeButton.imageView?.contentMode = .scaleAspectFit
        qrCodeButton.layer.shadowRadius = 5.0
        qrCodeButton.layer.shadowOpacity = 0.2
        qrCodeButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        qrCodeButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        qrCodeButton.heightAnchor.constraint(equalToConstant: 40).isActive = true

        layer.insertSublayer(themeGradient(), at: 0)
        stackView = UIStackView(arrangedSubviews: [searchField, qrCodeButton])
        stackView.frame = frame
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing = 15
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 18.0, bottom: 0, right: 18.0)
        stackView.isLayoutMarginsRelativeArrangement = true

        addSubview(stackView)
        qrCodeButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)

        searchField.delegate = self
        searchField.accessibilityIdentifier = "SearchField"

        searchField.layer.cornerRadius = searchField.bounds.height / 4
        qrCodeButton.layer.cornerRadius = qrCodeButton.bounds.height / 4
    }
    
    @objc private func buttonPressed() {
        searchResultsUpdater?.userDidPressQRButton()
    }
}

extension SearchView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchResultsUpdater?.updateSearchResults(for: textField, text: textField.text ?? "")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText = (textField.text ?? "") as NSString
        let textAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        
        searchResultsUpdater?.updateSearchResults(for: textField, text: textAfterUpdate)
        return true
    }
}
