import SwiftUI

struct MovieRowView: View {
    
    let movie: SingleMovieModel
    
    var imagePath: URL? {
        URL(imagePath: movie.posterPath)
    }
    
    var side: CGFloat { 85 }
    
    var body: some View {
        HStack(alignment: .center) {
            AsyncImage(url: imagePath) { phase in
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
            
            VStack(alignment: .leading, spacing: 5) {
                Text(movie.title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                Text(movie.releaseDate)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                HStack(spacing: 3) {
                    Text("⭐️")
                    Text(movie.voteAverage ?? 0.0, format: .number)
                }
            }
            Spacer()
        }
        .background(Color.secondary.opacity(0.1))
    }
}


#Preview {
    List {
        ForEach(0..<7, id: \.self) { _ in
            MovieRowView(movie: .stub)
        }
    }.listStyle(.plain)
}
