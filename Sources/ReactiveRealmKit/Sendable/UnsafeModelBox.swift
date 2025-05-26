//
//  File.swift
//  Statistics for Rick Masters
//
//  Created by Алексей on 26.05.2025.
//

import Foundation
import RxSwift
import RealmSwift

struct UnsafeModelBox<T: Object>: @unchecked Sendable {
    let models: [T]
}
