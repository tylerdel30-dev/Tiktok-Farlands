import Foundation

struct Video: Identifiable, Hashable {
    let id: UUID
    let creatorName: String
    let caption: String
    let tags: [String]
    let videoURL: URL
    let permalink: URL?

    init(
        id: UUID = UUID(),
        creatorName: String,
        caption: String,
        tags: [String],
        videoURL: URL,
        permalink: URL? = nil
    ) {
        self.id = id
        self.creatorName = creatorName
        self.caption = caption
        self.tags = tags
        self.videoURL = videoURL
        self.permalink = permalink
    }
}
