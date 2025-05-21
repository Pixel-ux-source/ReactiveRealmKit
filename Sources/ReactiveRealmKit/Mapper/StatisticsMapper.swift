//
//  StatisticsMapper.swift
//  Statistics for Rick Masters
//
//  Created by Алексей on 21.05.2025.
//

import Foundation

struct StatisticsMapper {
    static func map(from dto: StatisticsResponse) -> [StatisticsModel] {
        guard let modelDto = dto.statistics else { return [] }
        return modelDto.map { model in
            let statModel = StatisticsModel()
            statModel.userId.value = model.userId
            statModel.type = model.type
            
            if let modelDates = model.dates {
                modelDates.forEach { date in
                    statModel.dates.append(date)
                }
            }
            return statModel
        }
    }
}

extension StatisticsResponse: MapperProtocol {
    func map() -> [StatisticsModel] {
        StatisticsMapper.map(from: self)
    }
    
    typealias ModelType = StatisticsModel
}
