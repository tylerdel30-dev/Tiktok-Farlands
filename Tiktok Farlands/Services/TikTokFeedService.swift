import Foundation

enum FeedError: Error, LocalizedError {
    case badServerResponse

    var errorDescription: String? {
        switch self {
        case .badServerResponse:
            return "Failed to load videos from server."
        }
    }
}

private struct RecommendationDTO: Decodable {
    let creatorName: String
    let caption: String
    let tags: [String]
    let videoURL: String
    let permalink: String?
}

protocol FeedProviding {
    func loadVideos(session: AppSession?) async throws -> [Video]
}

final class TikTokFeedService: FeedProviding {
    private let urlSession: URLSession

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    func loadVideos(session: AppSession?) async throws -> [Video] {
        guard let session else {
            return []
        }

        var request = URLRequest(url: AppConfig.recommendationsEndpoint)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(session.accessToken)", forHTTPHeaderField: "Authorization")

        let payload = ["tags": Array(AppConfig.allowedTags)]
        request.httpBody = try JSONSerialization.data(withJSONObject: payload)

        do {
            let (data, response) = try await urlSession.data(for: request)
            guard let status = (response as? HTTPURLResponse)?.statusCode, (200 ... 299).contains(status) else {
                throw FeedError.badServerResponse
            }

            let decoded = try JSONDecoder().decode([RecommendationDTO].self, from: data)
            return decoded.compactMap { dto in
                guard let url = URL(string: dto.videoURL) else { return nil }
                let permalink = dto.permalink.flatMap(URL.init(string:))
                return Video(
                    creatorName: dto.creatorName,
                    caption: dto.caption,
                    tags: dto.tags,
                    videoURL: url,
                    permalink: permalink
                )
            }
            .filter { video in
                Set(video.tags.map { $0.lowercased() }).intersection(AppConfig.allowedTags).isEmpty == false
            }
        } catch {
            // Local fallback data so UI can still be tested while backend is in progress.
            return mockVideos().filter { video in
                Set(video.tags.map { $0.lowercased() }).intersection(AppConfig.allowedTags).isEmpty == false
            }
        }
    }

    private func mockVideos() -> [Video] {
        [
            Video(
                creatorName: "farlands_clips",
                caption: "Farlands route ideas and best seeds",
                tags: ["#farlands", "#gaming"],
                videoURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!,
                permalink: URL(string: "https://www.tiktok.com/tag/farlands")
            ),
            Video(
                creatorName: "eyes_updates",
                caption: "Latest reaction highlights",
                tags: ["#ishoweyes", "#clips"],
                videoURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4")!,
                permalink: URL(string: "https://www.tiktok.com/tag/ishoweyes")
            ),
            Video(
                creatorName: "tiktok_farlands",
                caption: "Community challenge clips",
                tags: ["#tiktokfarlands", "#challenge"],
                videoURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4")!,
                permalink: URL(string: "https://www.tiktok.com/tag/tiktokfarlands")
            )
        ]
    }
}
