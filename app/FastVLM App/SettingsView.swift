//
//  SettingsView.swift
//  FastVLM App
//
//  Created by Claude on 2025/09/17.
//

import SwiftUI

struct SettingsView: View {
    @State private var comedySettings = ComedySettings.shared
    @State private var tempPrompt: String = ""
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("コメディAIのプロンプト")
                            .font(.headline)

                        Text("画像の説明からコメディの回答を生成する際に使用されるプロンプトです。")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        TextEditor(text: $tempPrompt)
                            .frame(minHeight: 120)
                            .padding(8)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                    }
                } header: {
                    Text("コメディAI設定")
                }

                Section {
                    Button("デフォルトに戻す") {
                        comedySettings.resetToDefault()
                        tempPrompt = comedySettings.comedyPrompt
                    }
                    .foregroundStyle(.red)
                } footer: {
                    Text("設定を変更後、「保存」ボタンをタップして設定を適用してください。")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("設定")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("キャンセル") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        comedySettings.comedyPrompt = tempPrompt
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(tempPrompt.isEmpty)
                }
            }
            .onAppear {
                tempPrompt = comedySettings.comedyPrompt
            }
        }
    }
}

#Preview {
    SettingsView()
}