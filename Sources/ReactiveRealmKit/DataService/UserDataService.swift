//
//  DataBaseService.swift
//  Statistics for Rick Masters
//
//  Created by Алексей on 20.05.2025.
//

import UIKit
import RxSwift
import RealmSwift

public final class UserDataService: DataServiceProtocol {
    // MARK: – Typealias
    typealias Model = UsersModel
    
    // MARK: – Instance's
    private let networkService: NetworkService
    private let realmService: RealmService
    private let apiKey: String
    
    // MARK: – Initializate
    public init(network: NetworkService, strorage: RealmService, apiKey: String) {
        self.networkService = network
        self.realmService = strorage
        self.apiKey = apiKey
    }
    
    // MARK: – Load Data User
    public func loadData(predicate: NSPredicate? = nil, sortDescriptors: [RealmSwift.SortDescriptor]? = nil, limit: Int? = nil) -> RxSwift.Observable<[UsersModel]> {
        loadDataUser(predicate: predicate, sortDescriptors: sortDescriptors, limit: limit)
    }
    
    private func loadDataUser(predicate: NSPredicate?, sortDescriptors: [RealmSwift.SortDescriptor]?, limit: Int?) -> Observable<[UsersModel]> {
        let data = realmService.fetchAll(of: UsersModel.self, predicate: predicate, sortDescriptors: sortDescriptors, limit: limit)
        
        if !data.isEmpty {
            return Observable.just(data)
        } else {
            return refreshDataUser()
        }
    }
    
    // MARK: – Reftesh Data User
    public func refreshData() -> RxSwift.Observable<[UsersModel]> {
        refreshDataUser()
    }
    
    private func refreshDataUser() -> Observable<[UsersModel]> {
        let data = networkService.getRequest(of: UserResponse.self, apiKey: apiKey)
            .map { $0.map() }
            .do(onNext: { [weak self] object in
                guard let self else { return }
                self.realmService.save(of: UsersModel.self, models: object)
            })
        
        return data
    }
    
    // MARK: – Observe Data User
    public func observeData() -> RxSwift.Observable<[UsersModel]> {
        observeDataUser()
    }
    
    private func observeDataUser() -> Observable<[UsersModel]> {
        return realmService.observe(of: UsersModel.self)
    }
    
}
