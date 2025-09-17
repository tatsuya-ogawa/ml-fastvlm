//
//  ComedySettings.swift
//  FastVLM App
//
//  Created by Claude on 2025/09/17.
//

import Foundation

@Observable
class ComedySettings {
    static let shared = ComedySettings()

    private let userDefaults = UserDefaults.standard
    private let comedyPromptKey = "comedyPrompt"

    private let defaultPrompt = "あなたは優秀なコメディアンです。与えられた画像の説明から面白いコメディの回答を作ってください。日本語で回答し、ユーモアとウィットに富んだ内容にしてください。短くて覚えやすいフレーズを心がけてください。"

    var comedyPrompt: String {
        get {
            userDefaults.string(forKey: comedyPromptKey) ?? defaultPrompt
        }
        set {
            userDefaults.set(newValue, forKey: comedyPromptKey)
        }
    }

    private init() {}

    func resetToDefault() {
        comedyPrompt = defaultPrompt
    }
}