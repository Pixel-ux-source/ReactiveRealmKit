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
    public var id = RealmProperty<Int32?>()
    public dynamic var sex: String?
    public dynamic var username: String?
    public var isOnline = RealmProperty<Bool?>()
    public var age = RealmProperty<Int32?>()
    public var files = List<FilesModel>()
    
    public override class func primaryKey() -> String? {
        "id"
    }
}

