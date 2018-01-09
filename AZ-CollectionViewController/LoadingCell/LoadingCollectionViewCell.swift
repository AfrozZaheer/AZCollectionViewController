//
//  LoadingCollectionViewCell.swift
//  AZ-CollectionViewController
//
//  Created by Afroz Zaheer on 09/01/2018.
//  Copyright © 2018 AfrozZaheer. All rights reserved.
//

import UIKit

class LoadingCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func prepareForReuse() {
        activityIndicator.startAnimating()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
