//
//  NetworkService.swift
//  Statistics for Rick Masters
//
//  Created by Алексей on 20.05.2025.
//

import UIKit
import RxSwift

protocol NetworkProtocol: AnyObject {
    func getRequest<T: Decodable>(of type: T.Type, apiKey: String) -> Observable<T>
}

public final class NetworkService: NetworkProtocol {
    public init() {}
    
    public func getRequest<T: Decodable>(of type: T.Type, apiKey: String) -> Observable<T> {
        guard let url = URL(string: apiKey) else {
            return Observable.error(NSError(domain: "InvalidUrl", code: -1))
        }
        
        let observable = Observable<T>.create { observer in
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    observer.on(.error(error))
                    return
                }
                
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    observer.onError(NSError(domain: "No Response", code: -1))
                    return
                }
                print("Request success: \(response.statusCode)")

                guard let data = data else {
                    observer.onError(NSError(domain: "No Data", code: -1))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let models = try decoder.decode(type, from: data)
                    observer.onNext(models)
                    observer.onCompleted()
                } catch let error as NSError {
                    observer.onError(error)
                }
                
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
        return observable
    }
}
