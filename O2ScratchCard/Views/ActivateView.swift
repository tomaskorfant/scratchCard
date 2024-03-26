//
//  ActivateView.swift
//  O2ScratchCard
//
//  Created by Tomas Korfant on 26/03/2024.
//

import SwiftUI
import SwiftData
import Combine

struct ActivateView: View {

    @EnvironmentObject var errorHandling: ErrorHandling
    let card: ScratchCard
    @State private(set) var loading: Bool = false
    @State private var cancelllable: Cancellable?

    var body: some View {
        VStack {
            if card.state == .activated {
                Text("Card has been activated")
                    .foregroundStyle(Color.green)
            } else if loading {
                ProgressView()
            } else {
                Button(action: activate, label: {
                    Label("Activate card", systemImage: "snow")
                })
                .buttonStyle(.bordered)
                .tint(Color.green)
            }
        }
        .padding()
    }

    func activate() {
        guard let code = card.code,
              var url = URL(string: "https://api.o2.sk/version")
        else { return }

        loading = true
        url.append(queryItems: [URLQueryItem(name: "code", value: code)])

        cancelllable = URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .decode(type: ApiResponse.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .delay(for: 2, scheduler: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    errorHandling.handle(error: .error(error))
                }
                loading = false
            } receiveValue: { response in
                do {
                    try card.activate(with: response)
                } catch {
                    errorHandling.handle(error: .error(error))
                }
                loading = false
            }
    }
}

#Preview {
    ActivateView(card: .init())
        .modelContainer(for: ScratchCard.self, inMemory: true)
}
