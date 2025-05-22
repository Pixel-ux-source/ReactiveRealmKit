//
//  RealmService.swift
//  Statistics for Rick Masters
//
//  Created by Алексей on 20.05.2025.
//

import UIKit
import RealmSwift
import RxSwift

protocol RealmServiceProtocol: AnyObject {
    func save<T:Object>(of type: T.Type, models: [T])
    func fetchAll<T:Object>(of type: T.Type, predicate: NSPredicate?, sortDescriptors: [RealmSwift.SortDescriptor]?, limit: Int?) -> [T]
    func observe<T:Object>(of type: T.Type) -> Observable<[T]>
}

public final class RealmService: RealmServiceProtocol {
    public init() {
        let realm = try! Realm()
        print(realm.configuration.fileURL ?? "Empty", "\n")
    }
    
    // MARK: – Create
    public func save<T:Object>(of type: T.Type, models: [T]) {
        let references = models.map(ThreadSafeReference.init)
        DispatchQueue.global(qos: .background).async {
            autoreleasepool { [] in
                do {
                    let realm = try! Realm()
                    
                    let resolvedModel = references.compactMap { ref in
                        realm.resolve(ref)
                    }
                    
                    try realm.write {
                        realm.add(resolvedModel, update: .all)
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: – Read
    public func fetchAll<T:Object>(of type: T.Type, predicate: NSPredicate?, sortDescriptors: [RealmSwift.SortDescriptor]?, limit: Int?) -> [T] {
        let realm = try! Realm()
        var results = realm.objects(T.self)

        guard let predicate = predicate else { return Array(results) }
        results = results.filter(predicate)
        
        guard let sortDescriptors = sortDescriptors else { return Array(results) }
        results = results.sorted(by: sortDescriptors)
        
        guard let limit = limit else { return Array(results) }
        return Array(results.prefix(limit))
    }
    
    public func observe<T:Object>(of type: T.Type) -> Observable<[T]> {
        let realm = try! Realm()
        let results = realm.objects(T.self)
        let observable = Observable<[T]>.create { observer in
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
        return observable
    }
}
