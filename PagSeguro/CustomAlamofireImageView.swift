//
//  CustomAlamofireImageView.swift
//  HackerRank
//
//  Created by André Assis on 07/11/18.
//  Copyright © 2018 André Assis. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class CustomAlamofireImageView: UIImageView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
        }
    }
    
    func loadImageFor(url urlString: String) {
        if let url = URL(string: urlString) {
            self.af_setImage(withURL: url, placeholderImage: nil, imageTransition: UIImageView.ImageTransition.crossDissolve(0.2), runImageTransitionIfCached: false)
        }
    }
    
}
