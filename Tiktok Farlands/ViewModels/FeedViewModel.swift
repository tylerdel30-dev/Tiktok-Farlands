import Foundation

@MainActor
final class FeedViewModel: ObservableObject {
    @Published var videos: [Video] = []
    @Published var isLoading = false
    @Published var isAuthenticated = false
    @Published var errorMessage: String?

    private let feedService: FeedProviding
    private let authService: TikTokAuthenticating
    private let loginCoordinator: TikTokLoginCoordinator
    private let sessionStore: SessionStoring
    private var session: AppSession?

    init(
        feedService: FeedProviding = TikTokFeedService(),
        authService: TikTokAuthenticating = TikTokAuthService(),
        loginCoordinator: TikTokLoginCoordinator = TikTokLoginCoordinator(),
        sessionStore: SessionStoring = SessionStore()
    ) {
        self.feedService = feedService
        self.authService = authService
        self.loginCoordinator = loginCoordinator
        self.sessionStore = sessionStore
        self.session = sessionStore.load()
        self.isAuthenticated = self.session != nil
    }

    func refreshFeed() async {
        isLoading = true
        errorMessage = nil

        do {
            videos = try await feedService.loadVideos(session: session)
        } catch {
            videos = []
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func beginTikTokLogin() async {
        do {
            let loginState = UUID().uuidString
            let authURL = try authService.makeAuthorizationURL(state: loginState)
            let callbackURL = try await loginCoordinator.authenticate(
                with: authURL,
                callbackScheme: AppConfig.redirectScheme
            )
            let newSession = try await authService.handleCallbackURL(callbackURL, expectedState: loginState)
            sessionStore.save(newSession)
            session = newSession
            isAuthenticated = true
            errorMessage = nil
            await refreshFeed()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func logout() {
        sessionStore.clear()
        session = nil
        isAuthenticated = false
        videos = []
    }
}
