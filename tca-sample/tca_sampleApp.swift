//
//  tca_sampleApp.swift
//  tca-sample
//
//  Created by Satoshi Komatsu on 2023/05/15.
//

import SwiftUI
import ComposableArchitecture

@main
struct tca_sampleApp: App {
    var body: some Scene {
        WindowGroup {
            FeatureView(
                store: Store(initialState: Feature.State()) {
                    Feature()
                }
            )
        }
    }
}
