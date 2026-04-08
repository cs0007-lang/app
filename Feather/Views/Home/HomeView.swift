//
//  HomeView.swift
//  AppMaster
//

import SwiftUI
import AltSourceKit
import NimbleViews
import NukeUI

// MARK: - View
struct HomeView: View {
    @StateObject var viewModel = SourcesViewModel.shared

    @FetchRequest(
        entity: AltSource.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \AltSource.name, ascending: true)],
        animation: .snappy
    ) private var _sources: FetchedResults<AltSource>

    private var _allRepos: [ASRepository] {
        viewModel.sources.values.compactMap { $0 }
    }

    private var _allApps: [ASRepository.App] {
        _allRepos.flatMap { $0.apps ?? [] }
    }

    private var _featuredApps: [ASRepository.App] {
        Array(_allApps.prefix(10))
    }

    private var _bestApps: [ASRepository.App] {
        Array(_allApps.dropFirst(5).prefix(5))
    }

    var body: some View {
        NBNavigationView(.localized("Home")) {
            Group {
                if viewModel.sources.isEmpty && !_sources.isEmpty {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if _allApps.isEmpty {
                    _emptyState()
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 28) {
                            if !_featuredApps.isEmpty {
                                _featuredSection()
                            }
                            if !_bestApps.isEmpty {
                                _bestAppsSection()
                            }
                            if !_featuredApps.isEmpty {
                                _recentlyUpdatedSection()
                            }
                        }
                        .padding(.vertical, 12)
                    }
                }
            }
        }
        .task {
            await viewModel.fetchSources(_sources)
        }
    }

    // MARK: - Featured Section
    @ViewBuilder
    private func _featuredSection() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(.localized("Featured"))
                .font(.title2).bold()
                .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(_featuredApps, id: \.bundleIdentifier) { app in
                        if let source = _sourceFor(app) {
                            NavigationLink(destination: SourceAppsDetailView(app: app, source: source)) {
                                _featuredCard(app: app, source: source)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }

    @ViewBuilder
    private func _featuredCard(app: ASRepository.App, source: ASRepository) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            LazyImage(url: app.iconURL) { state in
                if let img = state.image {
                    img.resizable().scaledToFill()
                } else {
                    Color(.systemGray5)
                }
            }
            .frame(width: 260, height: 160)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .clipped()

            HStack(spacing: 10) {
                LazyImage(url: app.iconURL) { state in
                    if let img = state.image {
                        img.resizable().scaledToFill().appIconStyle(size: 36)
                    } else {
                        RoundedRectangle(cornerRadius: 9).fill(Color(.systemGray5)).frame(width: 36, height: 36)
                    }
                }
                VStack(alignment: .leading, spacing: 1) {
                    Text(app.currentName).font(.subheadline).bold().lineLimit(1)
                    Text(app.currentDescription ?? app.subtitle ?? "").font(.caption).foregroundStyle(.secondary).lineLimit(1)
                }
                Spacer()
                DownloadButtonView(app: app)
            }
            .padding(.horizontal, 2)
        }
        .frame(width: 260)
    }

    // MARK: - Best Apps
    @ViewBuilder
    private func _bestAppsSection() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(.localized("Best"))
                .font(.title2).bold()
                .padding(.horizontal, 20)

            VStack(spacing: 0) {
                ForEach(Array(_bestApps.enumerated()), id: \.offset) { index, app in
                    if let source = _sourceFor(app) {
                        NavigationLink(destination: SourceAppsDetailView(app: app, source: source)) {
                            HStack(spacing: 14) {
                                Text("\(index + 1)")
                                    .font(.title3).bold()
                                    .foregroundStyle(.secondary)
                                    .frame(width: 20)
                                LazyImage(url: app.iconURL) { state in
                                    if let img = state.image {
                                        img.resizable().scaledToFill().appIconStyle(size: 50)
                                    } else {
                                        RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray5)).frame(width: 50, height: 50)
                                    }
                                }
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(app.currentName).font(.subheadline).bold().foregroundStyle(.primary)
                                    Text(app.currentDescription ?? app.subtitle ?? "").font(.caption).foregroundStyle(.secondary).lineLimit(1)
                                }
                                Spacer()
                                DownloadButtonView(app: app)
                            }
                            .padding(.horizontal, 20).padding(.vertical, 10)
                        }
                        .buttonStyle(.plain)
                        if index < _bestApps.count - 1 {
                            Divider().padding(.leading, 84)
                        }
                    }
                }
            }
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .padding(.horizontal, 16)
        }
    }

    // MARK: - Recently Updated
    @ViewBuilder
    private func _recentlyUpdatedSection() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(.localized("Recently Updated"))
                .font(.title2).bold()
                .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 18) {
                    ForEach(_featuredApps, id: \.bundleIdentifier) { app in
                        if let source = _sourceFor(app) {
                            NavigationLink(destination: SourceAppsDetailView(app: app, source: source)) {
                                VStack(spacing: 6) {
                                    LazyImage(url: app.iconURL) { state in
                                        if let img = state.image {
                                            img.resizable().scaledToFill().appIconStyle(size: 64)
                                        } else {
                                            RoundedRectangle(cornerRadius: 14).fill(Color(.systemGray5)).frame(width: 64, height: 64)
                                        }
                                    }
                                    Text(app.currentName).font(.caption2).bold().lineLimit(1).frame(width: 64)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }

    // MARK: - Empty State
    @ViewBuilder
    private func _emptyState() -> some View {
        VStack(spacing: 16) {
            Image(systemName: "storefront")
                .font(.system(size: 60)).foregroundStyle(.secondary)
            Text(.localized("No Content")).font(.title2).bold()
            Text(.localized("Get started by adding your first repository."))
                .font(.subheadline).foregroundStyle(.secondary).multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }

    // MARK: - Helpers
    private func _sourceFor(_ app: ASRepository.App) -> ASRepository? {
        _allRepos.first { $0.apps?.contains(where: { $0.bundleIdentifier == app.bundleIdentifier }) == true }
    }
}
