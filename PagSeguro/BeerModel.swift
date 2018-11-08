//
//  BeerModel.swift
//  HackerRank
//
//  Created by André Assis on 07/11/18.
//  Copyright © 2018 André Assis. All rights reserved.
//

import Gloss

class BeerModel: Gloss.JSONDecodable {
    
    let id: Int?
    let imgUrl: String?
    let name: String?
    let tagline: String?
    let abv: CGFloat?
    let ibu: CGFloat?
    let description: String?
    
    required init?(json: JSON) {
        self.id = "id" <~~ json
        self.imgUrl = "image_url" <~~ json
        self.name = "name" <~~ json
        self.tagline = "tagline" <~~ json
        self.abv = "abv" <~~ json
        self.ibu = "ibu" <~~ json
        self.description = "description" <~~ json
    }
    
}
