//
//  ContentView.swift
//  O2ScratchCard
//
//  Created by Tomas Korfant on 25/03/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {

    @EnvironmentObject private var errorHandling: ErrorHandling
    @Environment(\.modelContext) private var modelContext
    let card: ScratchCard

    var body: some View {
        NavigationStack {
            VStack {
                    Spacer()

                    Label("Status of card", systemImage: "globe")
                        .foregroundStyle(Color.red)

                    Text(card.state.rawValue.uppercased())
                        .foregroundStyle(card.state.color)
                        .padding(.bottom, 20)

                    Text(card.code ?? "")
                        .foregroundStyle(card.state.color)
                        .padding(.bottom, 40)

                    NavigationLink {
                        ScratchView(card: card)
                    } label: {
                        Label("Scratch", systemImage: "hammer")
                    }
                    .buttonStyle(.bordered)
                    .tint(.blue)
                    .disabled(card.state != .unscratched)

                    NavigationLink {
                        ActivateView(card: card)
                    } label: {
                        Label("Activate", systemImage: "snow")
                    }
                    .buttonStyle(.bordered)
                    .tint(.green)
                    .disabled(card.state != .scratched)

                    Spacer()

                    Button(role: .destructive, action: reset, label: {
                        Label("Reset", systemImage: "trash")
                    })
                    .controlSize(.mini)
            }
            .padding()
        }
    }

    func reset() {
        card.reset()
    }
}

extension ScratchCard.CodeState {
    var color: SwiftUI.Color {
        switch self {
        case .unscratched:
            return .gray
        case .scratched:
            return .blue
        case .activated:
            return .green
        }
    }
}

#Preview {
    ContentView(card: .init())
        .modelContainer(for: ScratchCard.self, inMemory: true)
}
