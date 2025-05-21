//
//  Mapper.swift
//  Statistics for Rick Masters
//
//  Created by Алексей on 20.05.2025.
//

import Foundation

struct UserResponseMapper {
    static func map(from dto: UserResponse) -> [UsersModel] {
        guard let users = dto.users else { return [] }
        
        return users.map { model in
            let usersModel = UsersModel()
            usersModel.id.value = model.id
            usersModel.sex = model.sex
            usersModel.username = model.username
            usersModel.isOnline.value = model.isOnline
            usersModel.age.value = model.age
            
            if let dtoFiles = model.files {
                let files = dtoFiles.map { fileDto in
                    let filesModel = FilesModel()
                    filesModel.id.value = fileDto.id
                    filesModel.url = fileDto.url
                    filesModel.type = fileDto.type
                    
                    return filesModel
                }
                usersModel.files.append(objectsIn: files)
            }
            return usersModel
        }
    }
}

extension UserResponse: MapperProtocol {
    func map() -> [UsersModel] {
        UserResponseMapper.map(from: self)
    }
    
    typealias ModelType = UsersModel
}
