//
//  RealmService.swift
//  Statistics for Rick Masters
//
//  Created by Алексей on 20.05.2025.
//

import UIKit
import RealmSwift
import RxSwift

@available(iOS 13.0, *)
protocol RealmServiceProtocol: AnyObject {
    func save<T:Object>(of type: T.Type, models: [T])
    func fetchAll<T:Object>(of type: T.Type, sortDescriptors: [RealmSwift.SortDescriptor]?, limit: Int?) -> Observable<[T]>
    func observe<T:Object>(of type: T.Type) -> Observable<[T]>
}

@available(iOS 13.0, *)
public final class RealmService: RealmServiceProtocol {
    public init() {
        let realm = try! Realm()
        print(realm.configuration.fileURL ?? "Empty", "\n")
    }
    
    // MARK: – Create
    public func save<T:Object>(of type: T.Type, models: [T]) {
        let boxed = UnsafeModelBox(models: models)
        
        DispatchQueue.global(qos: .background).async {
            autoreleasepool {
                do {
                    let realm = try Realm()
                    try realm.write {
                        realm.add(boxed.models, update: .all)
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: – Read
    @available(iOS 13.0, *)
    public func fetchAll<T:Object>(of type: T.Type, sortDescriptors: [RealmSwift.SortDescriptor]?, limit: Int?) -> Observable<[T]> {
        
        let observable = Observable<[T]>.create { observer in
            let observerWrapper = ObserverWrapper(observer: observer)
            
            DispatchQueue.global(qos: .background).async {
                autoreleasepool {
                    do {
                        let realm = try Realm(configuration: .defaultConfiguration)
                        var results = realm.objects(T.self)
                        
                        if let sortDescriptors = sortDescriptors {
                            results = results.sorted(by: sortDescriptors)
                        }
                        
                        let output: [T] = {
                            guard let limit = limit else { return Array(results) }
                            return Array(results.prefix(limit))
                        }()
                        
                        let refs = output.map { ThreadSafeReference(to: $0) }
                        
                        do {
                            let realm = try Realm(configuration: .defaultConfiguration)
                            let resolved = refs.compactMap { realm.resolve($0) }
                            observerWrapper.observer.onNext(resolved)
                            observerWrapper.observer.onCompleted()
                        } catch let error {
                            observerWrapper.observer.onError(error)
                        }
                    } catch let error {
                        observerWrapper.observer.onError(error)
                    }
                }
            }
            return Disposables.create()
        }
        return observable
    }
    
    public func observe<T:Object>(of type: T.Type) -> Observable<[T]> {
            let observable = Observable<[T]>.create { observer in
                do {
                    let realm = try! Realm()
                    let results = realm.objects(T.self)
                    
                    let token = results.observe { changes in
                        switch changes {
                        case .initial(let initial):
                            observer.onNext(Array(initial))
                        case .update(let update, deletions: _, insertions: _, modifications: _):
                            observer.onNext(Array(update))
                        case .error(let error):
                            observer.onError(error)
                        }
                    }
                    
                    return Disposables.create {
                        token.invalidate()
                    }
                }
                
            }
            return observable
    }
}
