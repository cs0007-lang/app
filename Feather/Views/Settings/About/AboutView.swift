//
//  AboutView.swift
//  AppMaster
//

import SwiftUI
import NimbleViews

// MARK: - View
struct AboutView: View {
    @State private var isLoading = true
    
    private let _telegramURL = "https://t.me/AppMasterIOS"
    private let _channelURL = "https://t.me/AppMasterIOS"
    
    var body: some View {
        NBList(.localized("About")) {
            Section {
                VStack(spacing: 12) {
                    FRAppIconView(size: 80)
                    
                    Text("AppMaster")
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(Color.accentColor)
                    
                    HStack(spacing: 4) {
                        Text(.localized("Version"))
                        Text(Bundle.main.version)
                    }
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
            }
            .listRowBackground(EmptyView())
            
            NBSection(.localized("Information")) {
                Button {
                    UIApplication.open(_telegramURL)
                } label: {
                    HStack {
                        Image(systemName: "paperplane.fill")
                            .foregroundStyle(.blue)
                        Text("Telegram")
                        Spacer()
                        Image(systemName: "arrow.up.right")
                            .foregroundStyle(.secondary.opacity(0.65))
                    }
                }
                
                Button {
                    UIApplication.open(_channelURL)
                } label: {
                    HStack {
                        Image(systemName: "megaphone.fill")
                            .foregroundStyle(.orange)
                        Text(.localized("GitHub Repository"))
                        Spacer()
                        Image(systemName: "arrow.up.right")
                            .foregroundStyle(.secondary.opacity(0.65))
                    }
                }
            }
            
            NBSection(.localized("Credits")) {
                HStack {
                    FRIconCellView(
                        title: "khcrysalis",
                        subtitle: "Original Feather developer",
                        iconUrl: URL(string: "https://github.com/khcrysalis.png")!,
                        size: 45,
                        isCircle: true
                    )
                    Image(systemName: "arrow.up.right")
                        .foregroundColor(.secondary.opacity(0.65))
                }
                .onTapGesture {
                    UIApplication.open("https://github.com/khcrysalis")
                }
            }
            
            NBSection(.localized("Sponsors")) {
                Text(.localized("💜 This couldn't of been done without my sponsors!"))
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 2)
            }
        }
    }
}
