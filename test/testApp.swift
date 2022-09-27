//
//  testApp.swift
//  test
//
//  Created by Leevi on 16.9.2022.
//

import SwiftUI

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    var releaseVersionNumberPretty: String {
        return "v\(releaseVersionNumber ?? "1.0.0")"
    }
}

@main
struct testApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
