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
    public func loadData(sortDescriptors: [RealmSwift.SortDescriptor]? = nil, limit: Int? = nil) -> RxSwift.Observable<[UsersModel]> {
        loadDataUser(sortDescriptors: sortDescriptors, limit: limit)
    }
    
    private func loadDataUser(sortDescriptors: [RealmSwift.SortDescriptor]?, limit: Int?) -> Observable<[UsersModel]> {
        
        return realmService
            .fetchAll(of: UsersModel.self, sortDescriptors: sortDescriptors, limit: limit)
            .flatMap { [weak self] users -> Observable<[UsersModel]> in
                guard let self else { return .just([]) }
                return users.isEmpty ? self.refreshDataUser() : .just(users)
            }
            .do(onError: { error in
                    print(error.localizedDescription)
            })
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
