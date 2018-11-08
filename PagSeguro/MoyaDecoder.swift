//
//  MoyaDecoder.swift
//  HackerRank
//
//  Created by André Assis on 07/11/18.
//  Copyright © 2018 André Assis. All rights reserved.
//

import Moya
import Gloss
import Result
import Moya_Gloss
import RxSwift

enum APIMoyaError : Error {
    case generalError(s:String?)
    case jsonSerializationError(data:Data)
    case badCredentials
}

extension MoyaProvider {
    
    func moyaRequestArray<T:Gloss.JSONDecodable>(_ target:Target, type:T.Type) -> Observable<[T]> {
        return Observable.create({ o in
            let task = self.request(target, callbackQueue:nil, progress:nil) { result in
                switch result {
                case .success(let response):
                    do {
                        let model = try response.mapArray(T.self)
                        o.onNext(model)
                        o.onCompleted()
                    } catch {
                        o.onError(error)
                        o.onCompleted()
                    }
                    break;
                case .failure(let error):
                    o.onError(APIMoyaError.generalError(s: error.localizedDescription))
                    o.onCompleted()
                    break;
                }
            }
            return Disposables.create { task.cancel() }
        })
    }
    
    func moyaRequest<T:Gloss.JSONDecodable>(_ target:Target, type:T.Type) -> Observable<T> {
        return Observable.create({ o in
            
            let task = self.request(target, callbackQueue:nil, progress:nil) { result in
                switch result {
                case .success(let response):
                    do {
                        let model = try response.mapObject(T.self)
                        o.onNext(model)
                        o.onCompleted()
                    } catch {
                        o.onError(APIMoyaError.jsonSerializationError(data: response.data))
                        o.onCompleted()
                    }
                    break;
                case .failure(let error):
                    o.onError(APIMoyaError.generalError(s: error.localizedDescription))
                    o.onCompleted()
                    break;
                }
            }
            
            return Disposables.create { task.cancel() }
            
        })
    }
    
}
