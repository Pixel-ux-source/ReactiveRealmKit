//
//  StatisticsModel.swift
//  Statistics for Rick Masters
//
//  Created by Алексей on 20.05.2025.
//

import Foundation
import RealmSwift

@objcMembers
public final class StatisticsModel: Object {
    public var userId = RealmProperty<Int32?>()
    public dynamic var type: String?
    public var dates = List<Int32>()
    
    public override class func primaryKey() -> String? {
        "userId"
    }
}
