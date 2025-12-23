//
//  CodableResponseObject.swift
//  GAZT
//
//  Created by iSlam on 10/11/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import Foundation
internal import RxSwift
internal import Alamofire
internal import MOLH

public class cerqel_CodableResponseObject<T: Decodable>: Decodable, cerqel_CodableResponseProtocol {
    fileprivate(set) var success: Bool?
    fileprivate(set) var item: cerqel_CodableResponseObjectData<T>?

    var error: BaseError?
    var errors: [String: BaseError]?
//    fileprivate(set) var data:Any?
    var keyResult: String = "result"

    private enum CodingKeys: String, CodingKey {
        case success
        case result
        case message
        case errorCode
        case isActive
    }

    
//    fileprivate let objectType = T.self
    var action: cerqel_APIAction = cerqel_BasicActionDynamicForm.none

    init(action: cerqel_APIAction,keyResult:String = "result") {
        self.action = action
        self.keyResult = keyResult
        
    }
    
    required public init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            success = try values.decode(Bool.self, forKey: .success)
        } catch {
            success = false
        }
        do {
            item = try values.decodeIfPresent(cerqel_CodableResponseObjectData<T>.self, forKey: .result)
        } catch DecodingError.typeMismatch(_, let error){
            
            print(error)
            print(error.underlyingError)
            print("☢️ Item typemismatch error ignored")

            // ignore if not found
            // other types : .dataCorrupted, .keyNotFound, .typeMismatch and .valueNotFound.
        } catch let err{
            if let err = err as? DecodingError {
                print("☢️☢️☢️  ITEM Decoding Error : \(err) ☢️☢️☢️")
            }
        }
        
        
        

        if let message = try? values.decode(String.self, forKey: .message) {
            self.error = BaseError.other(title: message)
        }
    }

    func parse<T: Decodable>(_ data: Data) -> Observable<T> {
        return Observable.create { observer in
            
            do{
                if let dictionary = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary{
                    
                    print("printinggg \(dictionary)")
                    print("printinggg \(dictionary.value(forKey: "detail"))")
                
                }
            }catch{
                
            }
            
            // HANDLE IF RESPONSE.STATUS == FALSE, THROW ERROR
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                observer.onNext(result)
            } catch let error{
                print("Decoding error : \(error)")
                if let error = error as? BaseError {
                    observer.onError(error)
                } else {
                    observer.onError(BaseError.decodeResponse)
                }
                return Disposables.create()
            }
            
//            observer.onNext(result)
            return Disposables.create()
        }
    }
}

public class cerqel_CodableResponseObjectData<T: Decodable>: Decodable {
    fileprivate(set) public var data: T?
    fileprivate(set) public var arrData : [T]? = []
    var totalCount: Int = 0

    private enum CodingKeys: String, CodingKey {
        case data
        case totalCount
    }

    required public init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            data = try values.decodeIfPresent(T.self, forKey: .data)
        } catch DecodingError.typeMismatch(_, let error){
            
            print(error)
            print(error.underlyingError)
            print("☢️ Item typemismatch error ignored")

            // ignore if not found
            // other types : .dataCorrupted, .keyNotFound, .typeMismatch and .valueNotFound.
        } catch let err{
            if let err = err as? DecodingError {
                print("☢️☢️☢️  ITEM Decoding Error : \(err) ☢️☢️☢️")
            }
        }
        
        
        do {
            arrData = try values.decodeIfPresent([T].self, forKey: .data)
            totalCount = try values.decodeIfPresent(Int.self, forKey: .totalCount) ?? 0
        } catch DecodingError.typeMismatch(_, let err){
            // ignore if not found
            print("⛔️ Items typemismatch error ignored \(err)")
        } catch let err{
            print("⛔️⛔️⛔️  ITEMS Decoding Error : \(err) ⛔️⛔️⛔️")
        }
    }
}
