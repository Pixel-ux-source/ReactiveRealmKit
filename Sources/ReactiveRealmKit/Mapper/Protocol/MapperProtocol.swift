//
//  MapperProtocol.swift
//  Statistics for Rick Masters
//
//  Created by Алексей on 20.05.2025.
//

import Foundation
import RealmSwift

protocol MapperProtocol {
    associatedtype ModelType: Object
    func map() -> [ModelType]
}
