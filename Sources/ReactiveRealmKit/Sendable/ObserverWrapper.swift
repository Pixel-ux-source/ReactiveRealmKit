//
//  ObserverWrapper.swift
//  Statistics for Rick Masters
//
//  Created by Алексей on 26.05.2025.
//

import Foundation
import RxSwift
import RealmSwift

struct ObserverWrapper<T: Object>: @unchecked Sendable {
    let observer: AnyObserver<[T]>
}
