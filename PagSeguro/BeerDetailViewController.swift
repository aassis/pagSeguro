//
//  BeerDetailViewController.swift
//  HackerRank
//
//  Created by André Assis on 07/11/18.
//  Copyright © 2018 André Assis. All rights reserved.
//

import UIKit
import RxSwift

class BeerDetailViewController: UIViewController {
    
    @IBOutlet weak var viewLoading: UIView!
    @IBOutlet weak var viewError: UIView!
    
    @IBOutlet weak var imgBeer: CustomAlamofireImageView!
    @IBOutlet weak var labelTagline: UILabel!
    @IBOutlet weak var labelAlcohol: UILabel!
    @IBOutlet weak var labelBitterness: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    var client: APIClient!
    
    private var beerId: Int!
    private var hasError: Bool = false
    private var isLoading: Bool = false
    
    private var disposeBag = DisposeBag()
    
    class func instantiateWithBeerId(_ beerId: Int) -> BeerDetailViewController {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "beerDetailVc") as! BeerDetailViewController
        vc.beerId = beerId
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.bringSubviewToFront(viewLoading)

        loadData()
    }
    
    @IBAction private func loadData() {
        if !isLoading {
            isLoading = true
            hasError = false
            viewError.isHidden = true
            
            client.loadBeerDetail(beerId).subscribe(onNext: { [weak self] (beers) in
                if let s = self {
                    if let beer = beers.first {
                        s.isLoading = false
                        
                        s.title = beer.name
                        
                        if let imgUrl = beer.imgUrl {
                            s.imgBeer.loadImageFor(url: imgUrl)
                        }
                        
                        s.labelTagline.text = beer.tagline
                        
                        if let abv = beer.abv {
                            s.labelAlcohol.text = String(format: "%2.f", abv)
                        } else {
                            s.labelBitterness.text = "Teor alcoólico não informado"
                        }
                        
                        if let ibu = beer.ibu {
                            s.labelBitterness.text = String(format: "IBU: %.0f", ibu)
                        } else {
                            s.labelBitterness.text = "IBU não informado"
                        }
                        
                        s.labelDescription.text = beer.description
                        s.viewLoading.isHidden = true
                    }
                }
            }, onError: { [weak self] (error) in
                if let s = self {
                    s.isLoading = false
                    s.viewError.isHidden = false
                }
            }).disposed(by: disposeBag)
        }
    }

}
