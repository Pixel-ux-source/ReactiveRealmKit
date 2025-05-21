//
//  Model.swift
//  Statistics for Rick Masters
//
//  Created by Алексей on 20.05.2025.
//

import Foundation
import RealmSwift

@objcMembers
public final class UsersModel: Object {
    var id = RealmProperty<Int32?>()
    dynamic var sex: String?
    dynamic var username: String?
    var isOnline = RealmProperty<Bool?>()
    var age = RealmProperty<Int32?>()
    var files = List<FilesModel>()
    
    public override class func primaryKey() -> String? {
        "id"
    }
}

