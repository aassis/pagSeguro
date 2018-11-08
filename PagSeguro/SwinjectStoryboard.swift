//
//  SwinjectStoryboard.swift
//  HackerRank
//
//  Created by André Assis on 07/11/18.
//  Copyright © 2018 André Assis. All rights reserved.
//

import SwinjectStoryboard

extension SwinjectStoryboard {
    
    public static func setup() {
        defaultContainer.register(APIClient.self) { r -> APIClient in
            return APIClient()
        }.inObjectScope(.container)
        
        defaultContainer.storyboardInitCompleted(ViewController.self) { (r, c) in
            c.client = r.resolve(APIClient.self)
        }
        
        defaultContainer.storyboardInitCompleted(BeerDetailViewController.self) { (r, c) in
            c.client = r.resolve(APIClient.self)
        }
        
        defaultContainer.storyboardInitCompleted(UINavigationController.self) { (r, c) in
            //just to silence warnings
        }
    }
    
}
