import Foundation

extension URL {

    init?(imagePath: String?) {
        guard let imagePath else { return nil }
        let imageBase = "https://image.tmdb.org/t/p/w500"
        self.init(string: "\(imageBase)\(imagePath)")
    }

}
