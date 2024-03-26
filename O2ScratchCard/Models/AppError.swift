//
//  AppError.swift
//  O2ScratchCard
//
//  Created by Tomas Korfant on 26/03/2024.
//

import Foundation
import SwiftUI

enum AppError: LocalizedError {
    case invalidStateTransition,
         activationUnable,
         error(Error)

    var errorDescription: String? {
        switch self {
        case .invalidStateTransition:
            return "Invalit state transtion"
        case .activationUnable:
            return "It is not possibleto activate card. Try it later!"
        case .error(let error):
            return error.localizedDescription
        }
    }
}

class ErrorHandling: ObservableObject {
    @Published var currentError: AppError?
    @Published var showAlert: Bool = false

    func handle(error: AppError) {
        currentError = error
        showAlert = true
    }
}

struct AppErrorsViewModifier: ViewModifier {
    @StateObject var errorHandling = ErrorHandling()

    func body(content: Content) -> some View {
        content
            .environmentObject(errorHandling)
            .background(
                EmptyView()
                    .alert(isPresented: $errorHandling.showAlert, error: errorHandling.currentError, actions: {})
            )
    }
}

extension View {
    func withErrorHandling() -> some View {
        modifier(AppErrorsViewModifier())
    }
}
