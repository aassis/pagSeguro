//
//  APIClient.swift
//  HackerRank
//
//  Created by André Assis on 07/11/18.
//  Copyright © 2018 André Assis. All rights reserved.
//

import Foundation
import RxSwift
import Moya

class APIClient {
    
    let punkProvider: MoyaProvider<PunkProvider>
    
    init() {
        punkProvider = MoyaProvider.init()
    }
    
    func loadBeers(_ page: Int?, beersPerPage: Int?) -> Observable<[BeerModel]> {
        return punkProvider.moyaRequestArray(PunkProvider.getBeers(page, beerPerPage: beersPerPage), type: BeerModel.self)
    }
    
    func loadBeerDetail(_ beerId: Int) -> Observable<[BeerModel]> {
        return punkProvider.moyaRequestArray(PunkProvider.getBeerDetail(beerId), type: BeerModel.self)
    }
    
}
