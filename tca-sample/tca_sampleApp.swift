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
                store: Store(
                    initialState: Feature.State(),
                    reducer: Feature(
                        numberFact: { number in
                            let (data, _) = try await URLSession.shared
                                .data(from: .init(string: "http://numbersapi.com/\(number)")!)
                            return String(decoding: data, as: UTF8.self)
                        }
                    )
                )
            )
        }
    }
}
