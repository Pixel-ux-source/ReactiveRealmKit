//
//  StatisticsDataService.swift
//  Statistics for Rick Masters
//
//  Created by Алексей on 21.05.2025.
//

import UIKit
import RealmSwift
import RxSwift

final public class StatisticsDataService: DataServiceProtocol {
    // MARK: – Typealias
    typealias Model = StatisticsModel
    
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

    
    // MARK: – Load Data
    public func loadData(predicate: NSPredicate? = nil, sortDescriptors: [RealmSwift.SortDescriptor]? = nil, limit: Int? = nil) -> RxSwift.Observable<[StatisticsModel]> {
        loadDataStatistics(predicate: predicate, sortDescriptors: sortDescriptors, limit: limit)
    }
    
    private func loadDataStatistics(predicate: NSPredicate?, sortDescriptors: [RealmSwift.SortDescriptor]?, limit: Int?) -> RxSwift.Observable<[StatisticsModel]> {
        let data = realmService.fetchAll(of: StatisticsModel.self, predicate: predicate, sortDescriptors: sortDescriptors, limit: limit)
        
        if !data.isEmpty {
            return Observable.just(data)
        } else {
            return refreshDataStatistics()
        }
    }
    
    // MARK: – Refresh Data
    public func refreshData() -> RxSwift.Observable<[StatisticsModel]> {
        refreshDataStatistics()
    }
    
    private func refreshDataStatistics() -> RxSwift.Observable<[StatisticsModel]> {
        let data = networkService.getRequest(of: StatisticsResponse.self, apiKey: apiKey)
            .map { $0.map() }
            .do { [weak self] object in
                guard let self else { return }
                self.realmService.save(of: StatisticsModel.self, models: object)
            }
        
        return data
    }
    
    // MARK: – Observe Data
    public func observeData() -> RxSwift.Observable<[StatisticsModel]> {
        observeDataStatistics()
    }
    
    private func observeDataStatistics() -> RxSwift.Observable<[StatisticsModel]> {
        return realmService.observe(of: StatisticsModel.self)
    }
    
}
