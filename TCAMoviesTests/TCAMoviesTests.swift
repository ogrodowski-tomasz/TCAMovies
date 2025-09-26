import ComposableArchitecture
import Foundation
import Testing
@testable import TCAMovies



struct TCAMoviesTests {
    
    let jsonDecoder = JSONDecoder()

    @Test func movieList_shouldFetchData() async throws {
        
        // EXPECTED DATA
        let nowPlayingData = try StaticDataClient.load(MovieEndpoint.nowPlaying)
        let nowPlayingResponse = try jsonDecoder.decode(MovieListResponse.self, from: nowPlayingData)
        let expectedNowPlayingMovies = Array(nowPlayingResponse.results.prefix(5))
        
        let topRatedData = try StaticDataClient.load(MovieEndpoint.topRated)
        let topRatedResponse = try jsonDecoder.decode(MovieListResponse.self, from: topRatedData)
        let expectedTopRatedMovies = Array(topRatedResponse.results.prefix(5))

        let popularData = try StaticDataClient.load(MovieEndpoint.popular)
        let popularResponse = try jsonDecoder.decode(MovieListResponse.self, from: popularData)
        let expectedPopularMovies = Array(popularResponse.results.prefix(5))

        let store = await TestStore(initialState: MovieListReducer.State(), reducer: MovieListReducer.init)
        await store.send(.onAppear)
        
        await store.receive(.topRatedFetched(topRatedResponse.results)) { state in
            state.topRated = expectedTopRatedMovies
        }
        
        await store.receive(.nowPlayingFetched(nowPlayingResponse.results)) { state in
            state.nowPlaying = expectedNowPlayingMovies
        }
        
        await store.receive(.popularFetched(popularResponse.results)) { state in
            state.popular = expectedPopularMovies
        }
    }
}
