//
//  DataServiceProtocol.swift
//  Statistics for Rick Masters
//
//  Created by Алексей on 21.05.2025.
//

import Foundation
import RealmSwift
import RxSwift

protocol DataServiceProtocol: AnyObject {
    associatedtype Model: Object
    init(network: NetworkService, strorage: RealmService, apiKey: String)
    
    func loadData(sortDescriptors: [RealmSwift.SortDescriptor]?, limit: Int?) -> Observable<[Model]>
    
    func refreshData() -> Observable<[Model]>
    
    func observeData() -> Observable<[Model]>
}
