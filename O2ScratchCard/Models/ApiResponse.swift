//
//  ApiResponse.swift
//  O2ScratchCard
//
//  Created by Tomas Korfant on 26/03/2024.
//

import Foundation

// {"ios":"6.28", "iosTM":"1.22", "iosRA":"1.1401", "iosRA_2":"1.2000.1", "android":"179907", "androidTM":"22970", "androidRA":"161395"}

struct ApiResponse: Codable {
    
    let ios: String?
    let iosTM: String?
    let iosRA: String?
    let iosRA_2: String?
    let android: String?
    let androidTM: String?
    let androidRA: String?

}
