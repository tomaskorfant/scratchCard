//
//  ScratchCard.swift
//  O2ScratchCard
//
//  Created by Tomas Korfant on 25/03/2024.
//

import Foundation
import SwiftData

@Model
final class ScratchCard: ObservableObject {

    private(set)var state: CodeState
    var code: String?

    init() {
        self.state = .unscratched
    }

    func scratched() throws {
        guard state == .unscratched else {
            throw AppError.invalidStateTransition
        }
        code = UUID().uuidString
        state = .scratched
    }

    func activate(with response: ApiResponse) throws {
        guard state == .scratched else {
            throw AppError.invalidStateTransition
        }
        guard let iosValue = response.ios, (Decimal(string: iosValue) ?? 0) > 6.1 else {
            throw AppError.activationUnable
        }
        state = .activated
    }

    func reset() {
        state = .unscratched
        code = nil
    }
}

extension ScratchCard {
    enum CodeState: String, Codable {
        case unscratched, scratched, activated
    }
}
