//
//  DtoModel.swift
//  Statistics for Rick Masters
//
//  Created by Алексей on 20.05.2025.
//

import Foundation

// MARK: – Главная модель
public struct UserResponse: Decodable {
    let users: [DtoUsersModel]?
}

struct DtoUsersModel: Decodable {
    let id: Int32?
    let sex: String?
    let username: String?
    let isOnline: Bool?
    let age: Int32?
    let files: [DtoFilesModel]?
}

struct DtoFilesModel: Decodable {
    let id: Int32?
    let url: String?
    let type: String?
}

