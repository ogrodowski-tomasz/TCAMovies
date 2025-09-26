import SwiftUI

struct MovieRowView: View {
    
    let movie: any MovieListItemRepresentable
    let onSelected: (any MovieListItemRepresentable) -> Void
    
    var side: CGFloat { 85 }
    
    var body: some View {
        HStack(alignment: .center) {
            MoviePosterView(imageURL: URL(imagePath: movie.posterPath))
            
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
        .onTapGesture {
            onSelected(movie)
        }
    }
}


#Preview {
    List {
        ForEach(0..<7, id: \.self) { _ in
            MovieRowView(movie: SingleMovieModel.stub) { _ in }
        }
    }.listStyle(.plain)
}
