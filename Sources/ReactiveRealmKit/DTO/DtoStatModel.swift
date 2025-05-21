//
//  DtoStatModel.swift
//  Statistics for Rick Masters
//
//  Created by Алексей on 21.05.2025.
//

import Foundation

struct StatisticsResponse: Decodable {
    let statistics: [DtoStatisticsModel]?
}

struct DtoStatisticsModel: Decodable {
    let userId: Int32?
    let type: String?
    let dates: [Int32]?
}
