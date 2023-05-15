//
//  ContentView.swift
//  tca-sample
//
//  Created by Satoshi Komatsu on 2023/05/15.
//

import SwiftUI
import ComposableArchitecture

struct Feature: ReducerProtocol {
    struct State: Equatable {
        var count = 0
        var numberFactAlert: String?
    }

    enum Action: Equatable {
        case factAlertDismissed
        case decrementButtonTapped
        case incrementButtonTapped
        case numberFactButtonTapped
        case numberFactResponse(TaskResult<String>)
    }

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .factAlertDismissed:
            state.numberFactAlert = nil
            return .none
        case .decrementButtonTapped:
            state.count -= 1
            return .none
        case .incrementButtonTapped:
            state.count += 1
            return .none
        case .numberFactButtonTapped:
            return .run { [count = state.count] send in
                await send(
                    .numberFactResponse(
                        TaskResult {
                            String(
                                decoding: try await URLSession.shared
                                    .data(from: URL(string: "http://numbersapi.com/\(count)/trivia")!).0,
                                as: UTF8.self
                            )
                        }
                    )
                )
            }

        case let .numberFactResponse(.success(fact)):
            state.numberFactAlert = fact
            return .none

        case .numberFactResponse(.failure):
            state.numberFactAlert = "Could not load a number fact :("
            return .none
        }
    }
}

struct FeatureView: View {
    let store: StoreOf<Feature>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                HStack {
                    Button("-") { viewStore.send(.decrementButtonTapped) }
                    Text("\(viewStore.count)")
                    Button("+") { viewStore.send(.incrementButtonTapped) }
                }

                Button("Number fact") { viewStore.send(.numberFactButtonTapped) }
            }
            .alert(
                item: viewStore.binding(
                    get: { $0.numberFactAlert.map(FactAlert.init(title:)) },
                    send: .factAlertDismissed
                ),
                content: { Alert(title: Text($0.title)) }
            )
        }
    }
}

struct FactAlert: Identifiable {
    var id: String { self.title }
    var title: String
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        FeatureView()
//    }
//}
