//
//  AppEnvironment.swift
//  Breadfast_posts
//
//  Created by Andrey on 01/03/2023.
//

import Foundation

/// Utility that allows to read project configuration values from code
enum AppEnvironment {
    private enum Keys: String {
        case token = "BP_API_TOKEN"
        case baseURL = "BP_BASE_URL"
    }
    
    static var apiToken: String {
        getString(for: .token)
    }
    
    static var baseURL: URL {
        guard
            let path = getUrlString(for: .baseURL),
            let pathURL = URL(string: path)
        else {
            fatalError("Environment. incorrect server path")
        }
        return pathURL
    }
}

//MARK: - Private
private extension AppEnvironment {
    private static let plist: [String: Any] = {
        Bundle.main.infoDictionary ?? [String: Any]()
    }()
    
    private static func boolValue(for key: Keys) -> Bool {
        guard let stringValue = plist[key.rawValue] as? String else {
            fatalError("Environment. incorrect bool representation for \(key.rawValue)")
        }
        return stringValue == "YES"
    }
    
    private static func getString(for key: Keys) -> String {
        guard let key = plist[key.rawValue] as? String else {
            fatalError("Environment. incorrect string representation for \(key.rawValue)")
        }
        return key
    }
    
    private static func getUrlString(for key: Keys) -> String? {
        (plist[key.rawValue] as? String)?.replacingOccurrences(of: "\\", with: "")
    }
}
