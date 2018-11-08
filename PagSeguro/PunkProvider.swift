//
//  PunkProvider.swift
//  HackerRank
//
//  Created by André Assis on 07/11/18.
//  Copyright © 2018 André Assis. All rights reserved.
//

import Moya

enum PunkProvider {
    case getBeers(_ page: Int?, beerPerPage: Int?)
    case getBeerDetail(_ beerId: Int)
}

extension PunkProvider: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.punkapi.com/v2")!
    }
    
    var path: String {
        switch self {
        case .getBeers:
            return "/beers"
        case .getBeerDetail(let beerId):
            return "/beers/\(beerId)"
        }
    }
    
    var method: Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getBeers(let page, let beerPerPage):
            if let p = page, let bpp = beerPerPage {
                var params = [String:Any]()
                params["page"] = p
                params["per_page"] = bpp
                
                return .requestParameters(parameters: params, encoding: URLEncoding.default)
            } else {
                return .requestPlain
            }
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}
