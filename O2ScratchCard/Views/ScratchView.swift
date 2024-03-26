//
//  ScratchView.swift
//  O2ScratchCard
//
//  Created by Tomas Korfant on 25/03/2024.
//

import SwiftUI
import SwiftData
import Combine

struct ScratchView: View {
    
    @EnvironmentObject var errorHandling: ErrorHandling
    let card: ScratchCard
    @State private(set) var task: Task<Void, Never>?
    @State private(set) var loading: Bool = false

    var body: some View {
        VStack {
            if let code = card.code {
                Text("CARD CODE: \n\(code)")
                    .foregroundStyle(Color.blue)
            } else if loading {
                ProgressView()
            } else {
                Button(action: scratch, label: {
                    Label("Scratch card", systemImage: "hammer")
                })
                .buttonStyle(.bordered)
                .tint(.blue)
            }
        }
        .padding()
        .onDisappear {
            task?.cancel()
        }
    }
    
    func scratch() {
        guard card.code == nil else { return }
        loading = true

        task = Task {
            do {
                try await Task.sleep(nanoseconds: 2_000_000_000)
                try self.card.scratched()
            } catch {
                errorHandling.handle(error: .error(error))
            }
            loading = false
        }
    }
}

#Preview {
    ScratchView(card: .init())
        .modelContainer(for: ScratchCard.self, inMemory: true)
}
