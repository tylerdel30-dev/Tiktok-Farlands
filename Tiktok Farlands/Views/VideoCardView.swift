import AVKit
import SwiftUI

struct VideoCardView: View {
    let video: Video
    let openSource: () -> Void
    @State private var player: AVPlayer?

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Group {
                if let player {
                    VideoPlayer(player: player)
                        .onAppear { player.play() }
                        .onDisappear { player.pause() }
                } else {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.black.opacity(0.85))
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 24))

            VStack(alignment: .leading, spacing: 8) {
                Text("@\(video.creatorName)")
                    .font(.headline)
                    .foregroundStyle(.white)

                Text(video.caption)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.95))

                Text(video.tags.joined(separator: " "))
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.75))

                Button(action: openSource) {
                    Label("Open on TikTok", systemImage: "play.rectangle.fill")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(.black)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(.white)
                        .clipShape(Capsule())
                }
            }
            .padding(18)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 520)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
        .padding(.horizontal, 12)
        .task {
            player = AVPlayer(url: video.videoURL)
        }
    }
}
