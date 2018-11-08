//
//  GeneralLoadingCell.swift
//  HackerRank
//
//  Created by André Assis on 07/11/18.
//  Copyright © 2018 André Assis. All rights reserved.
//

import UIKit

class GeneralLoadingCell: UICollectionViewCell {
    
    @IBOutlet weak var loadingIcon: UIActivityIndicatorView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        loadingIcon.startAnimating()
    }
    
}
