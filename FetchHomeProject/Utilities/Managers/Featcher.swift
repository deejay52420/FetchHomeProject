

import Foundation

protocol DataFetcher {
    func fetchData(from url: URL) throws -> Data
}
 
struct Fetcher: DataFetcher {
    func fetchData(from url: URL) throws -> Data {
        try Data(contentsOf: url)
    }
}
