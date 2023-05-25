//
//  FeatureTest.swift
//  tca-sampleTests
//
//  Created by Satoshi Komatsu on 2023/05/25.
//

import XCTest
import ComposableArchitecture

@testable import tca_sample

final class FeatureTest: XCTestCase {

    @MainActor
    func testFeature() async {
        let store = TestStore(initialState: Feature.State()) {
            Feature()
        } withDependencies: {
            $0.numberFact.fetch = { "\($0) is a good number Brant" }
        }

        await store.send(.incrementButtonTapped) {
            $0.count = 1
        }
        await store.send(.decrementButtonTapped) {
            $0.count = 0
        }

        await store.send(.numberFactButtonTapped)

        await store.receive(.numberFactResponse(.success("0 is a good number Brant"))) {
            $0.numberFactAlert = "0 is a good number Brant"
        }

        await store.send(.factAlertDismissed) {
            $0.numberFactAlert = nil
        }
    }
}
