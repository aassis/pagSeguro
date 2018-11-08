//
//  ViewController.swift
//  HackerRank
//
//  Created by André Assis on 07/11/18.
//  Copyright © 2018 André Assis. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collection: UICollectionView!
    
    var client: APIClient!
    
    private var beers: [BeerModel]?
    private var isLoading: Bool = false
    private var hasMore: Bool = false
    private var hasError: Bool = false
    private var currentPage: Int = 1
    private var beersPerPage: Int = 28
    
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Cervejas"
        
        collection.dataSource = self
        collection.delegate = self
        loadBeers()
    }
    
    private func loadBeers() {
        if !isLoading {
            isLoading = true
            hasError = false
            collection.reloadData()
            
            client.loadBeers(currentPage, beersPerPage: beersPerPage).subscribe(onNext: { [weak self] (beers) in
                if let s = self {
                    s.isLoading = false
                    if s.beers != nil {
                        s.beers?.append(contentsOf: beers)
                    } else {
                        s.beers = beers
                    }
                    
                    if beers.count < s.beersPerPage {
                        s.hasMore = false
                    } else {
                        s.hasMore = true
                        s.currentPage += 1
                    }
                    
                    s.collection.reloadData()
                }
                }, onError: { [weak self] (error) in
                    if let s = self {
                        s.hasError = true
                    }
            }).disposed(by: disposeBag)
        }
    }
    
    // MARK: - CollectionViewDelegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if (hasMore || hasError) {
            return 2
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return beers?.count ?? 1
        }
        
        return (hasMore || hasError) ? 1 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0,
            let beer = beers?.itemFor(index: indexPath),
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "beerCell", for: indexPath) as? BeerCollectionCell
        {
            cell.setupWithBeer(beer)
            return cell
            
        } else if hasError {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "error", for: indexPath)
        } else {
            if hasMore {
                loadBeers()
            }
            return collectionView.dequeueReusableCell(withReuseIdentifier: "loading", for: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if indexPath.section == 0,
            let beerId = beers?.itemFor(index: indexPath)?.id {
            let vc = BeerDetailViewController.instantiateWithBeerId(beerId)
            self.navigationController?.pushViewController(vc, animated: true)
        } else if hasError {
            loadBeers()
        }
    }
    
    // MARK: - CollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0, beers != nil {
            let width = collectionView.bounds.width / 4
            let height = width * 1.5
            return CGSize(width: width, height: height)
        } else {
            return CGSize(width: collectionView.bounds.size.width, height: 40.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }

}

class BeerCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: CustomAlamofireImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var abv: UILabel!
 
    func setupWithBeer(_ beer: BeerModel) {
        imgView.image = nil
        if let url = beer.imgUrl {
            imgView.loadImageFor(url: url)
        }
        
        name.text = beer.name
        abv.text = String(format: "Al: %.1f%%", beer.abv ?? 0.0)
    }
    
}
