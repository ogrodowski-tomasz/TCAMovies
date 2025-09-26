import SwiftUI

struct MoviePosterView: View {
    let imageURL: URL?
    var side: CGFloat { 85 }
    var body: some View {
        AsyncImage(url: imageURL) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
            default:
                Rectangle()
            }
        }
        .frame(width: side, height: side * 3/2)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    MoviePosterView(imageURL: SingleMovieModel.stub.imageURL(for: .poster))
}
