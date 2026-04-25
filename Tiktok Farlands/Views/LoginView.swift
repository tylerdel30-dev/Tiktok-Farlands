import SwiftUI

struct LoginView: View {
    let beginLogin: () -> Void
    let errorMessage: String?

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Text(AppConfig.appName)
                .font(.largeTitle.bold())
                .foregroundStyle(.white)

            Text("Login with TikTok to load your Farlands-only recommendations.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.white.opacity(0.85))
                .padding(.horizontal, 24)

            Button(action: beginLogin) {
                Text("Continue with TikTok")
                    .font(.headline)
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, 24)

            if let errorMessage, errorMessage.isEmpty == false {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundStyle(.red.opacity(0.95))
                    .padding(.horizontal, 24)
                    .multilineTextAlignment(.center)
            }

            Spacer()
        }
    }
}
