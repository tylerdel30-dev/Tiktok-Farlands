import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = FeedViewModel()
    @Environment(\.openURL) private var openURL

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [.black, .purple.opacity(0.6), .blue.opacity(0.7)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                if viewModel.isAuthenticated == false {
                    LoginView(
                        beginLogin: {
                            Task {
                                await viewModel.beginTikTokLogin()
                            }
                        },
                        errorMessage: viewModel.errorMessage
                    )
                } else {
                    if viewModel.isLoading {
                        ProgressView("Loading feed...")
                            .tint(.white)
                            .foregroundStyle(.white)
                    } else if viewModel.videos.isEmpty {
                        ContentUnavailableView(
                            "No videos found",
                            systemImage: "video.slash",
                            description: Text("Feed allows only #tiktokfarlands #farlands #ishoweyes")
                        )
                        .foregroundStyle(.white)
                    } else {
                        TabView {
                            ForEach(viewModel.videos) { video in
                                VideoCardView(video: video) {
                                    if let permalink = video.permalink {
                                        openURL(permalink)
                                    }
                                }
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .always))
                    }
                }
            }
            .navigationTitle(AppConfig.appName)
            .navigationBarTitleDisplayMode(.inline)
            .task {
                if viewModel.isAuthenticated {
                    await viewModel.refreshFeed()
                }
            }
            .refreshable {
                if viewModel.isAuthenticated {
                    await viewModel.refreshFeed()
                }
            }
            .toolbar {
                if viewModel.isAuthenticated {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Logout") {
                            viewModel.logout()
                        }
                        .tint(.white)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
