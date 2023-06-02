//
//  SignIn.swift
//  tca-sample
//
//  Created by Satoshi Komatsu on 2023/06/03.
//

import Foundation
import ComposableArchitecture

struct SignIn: ReducerProtocol {

    struct State: Equatable {}

    struct Action: Equatable {}

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        .none

    }

}
