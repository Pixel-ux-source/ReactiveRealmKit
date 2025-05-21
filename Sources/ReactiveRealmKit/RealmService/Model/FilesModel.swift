//
//  FilesModel.swift
//  Statistics for Rick Masters
//
//  Created by Алексей on 20.05.2025.
//

import Foundation
import RealmSwift

@objcMembers
public final class FilesModel: Object {
    var id = RealmProperty<Int32?>()
    dynamic var url: String?
    dynamic var type: String?
    
    public override class func primaryKey() -> String? {
        "id"
    }
}
