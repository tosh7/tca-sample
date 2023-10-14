//
//  Feature.swift
//  tca-sample
//
//  Created by Satoshi Komatsu on 2023/05/25.
//

import Foundation
import ComposableArchitecture

struct Feature: Reducer {
    // This is for DI
    // just like an api client
    @Dependency(\.numberFact) var numberFact

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

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
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
                    .numberFactResponse(TaskResult { try await self.numberFact.fetch(count) })
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
