//
//  PlaceCell.swift
//  iOrder
//
//  Created by Bay-QA on 29.03.16.
//  Copyright © 2016 Bay-QA. All rights reserved.
//

import UIKit

class PlaceCell: BaseCell {
    
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeAddressLabel: UILabel!
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak private var shadowView: UIView!
    
    var id: Int?
    var place: Place!
    var imagePath: String?
    var placePhoto: UIImage?
    
    private let cellCornerRadius: CGFloat = 5.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.shadowView.layer.shadowColor = UIColor.black.cgColor
        self.shadowView.layer.shadowOpacity = 0.15
        self.shadowView.layer.shadowRadius = 3.0
        self.shadowView.layer.shadowOffset = CGSize(width: 1, height: 6)

        self.shadowView.layer.cornerRadius = cellCornerRadius
        self.shadowView.layer.shouldRasterize = true
        self.shadowView.layer.rasterizationScale = UIScreen.main.scale
        self.shadowView.layer.masksToBounds = false
        
        if #available(iOS 11.0, *) {
            self.placeImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        }
        
        self.placeImage.layer.masksToBounds = true
        self.placeImage.layer.cornerRadius = cellCornerRadius
    }
    
    func configureCell(for place: Place) {
        self.place = place
        self.placeNameLabel.text = place.name
        self.id = place.id
        self.placeAddressLabel.text = place.address
        self.imagePath = place.imagePath

        if let image = place.image {
            self.placeImage.image = image
        } else {
            if let path = self.imagePath {
                self.downloadImage(path)
            }
        }
        
        if place.distance == -1 {
            self.distanceLabel.text = ""
        } else {
            if let description = place.distance?.description {
                self.distanceLabel.text = description + " km away"
            }
        }
        
        self.setupAccessibilityLabels()
    }

    private func downloadImage(_ url: String) {
        NetworkClient.downloadImage(url: url) { (imageOpt, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let image = imageOpt else {
                return
            }
            self.placePhoto = imageOpt
            self.place.image = imageOpt
            DispatchQueue.main.async {
                self.placeImage.image = image
            }
        }
    }
    
    override func prepareForReuse() {
        self.imageView?.image = nil
        self.distanceLabel.text = nil
        self.placeNameLabel.text = nil
        self.placeAddressLabel.text = nil
    }
    
    override func setupAccessibilityLabels() {
        self.placeNameLabel.accessibilityIdentifier = placeNameLabel.text
        self.placeAddressLabel.accessibilityIdentifier = placeAddressLabel.text
        self.placeImage.accessibilityIdentifier = "placeImage"
        self.distanceLabel.accessibilityIdentifier = distanceLabel.text
    }
}

