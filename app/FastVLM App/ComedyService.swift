//
//  ComedyService.swift
//  FastVLM App
//
//  Created by Tatsuya Ogawa on 2025/09/16.
//

import Foundation
import FoundationModels

@Observable
class ComedyService {
    private var session: LanguageModelSession?

    init() {
        setupSession()
    }

    private func setupSession() {
        session = LanguageModelSession(
            instructions: "あなたは優秀な大喜利師です。与えられた画像の説明から面白い大喜利の回答を作ってください。日本語で回答し、ユーモアとウィットに富んだ内容にしてください。短くて覚えやすいフレーズを心がけてください。"
        )
    }

    func generateComedy(from imageDescription: String) async throws -> String {
        guard let session = session else {
            throw ComedyError.sessionNotInitialized
        }

        let prompt = "この画像の説明を元に大喜利をしてください：\(imageDescription)"

        do {
            let response = try await session.respond(to: prompt)
            return response.content
        } catch LanguageModelSession.GenerationError.exceededContextWindowSize {
            setupSession()
            throw ComedyError.contextWindowExceeded
        } catch {
            throw ComedyError.failedToGenerate(error.localizedDescription)
        }
    }

    func clearConversation() {
        setupSession()
    }

    var isAvailable: Bool {
        return SystemLanguageModel.default.availability == .available
    }

    var unavailabilityReason: String? {
        switch SystemLanguageModel.default.availability {
        case .available:
            return nil
        case .unavailable(let reason):
            switch reason {
            case .appleIntelligenceNotEnabled:
                return "Apple Intelligenceが有効になっていません。設定で有効にしてください。"
            case .deviceNotEligible:
                return "このデバイスはApple Intelligenceに対応していません。"
            case .modelNotReady:
                return "言語モデルの準備ができていません。しばらく待ってからお試しください。"
            @unknown default:
                return "不明なエラーが発生しました。"
            }
        }
    }
}

enum ComedyError: LocalizedError {
    case sessionNotInitialized
    case failedToGenerate(String)
    case contextWindowExceeded
    case serviceUnavailable(String)

    var errorDescription: String? {
        switch self {
        case .sessionNotInitialized:
            return "大喜利セッションが初期化されていません"
        case .failedToGenerate(let message):
            return "大喜利の生成に失敗しました: \(message)"
        case .contextWindowExceeded:
            return "会話が長すぎます。新しいセッションを開始しました。"
        case .serviceUnavailable(let reason):
            return "大喜利サービスが利用できません: \(reason)"
        }
    }
}