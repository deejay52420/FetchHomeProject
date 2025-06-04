
import Foundation

enum APIError: Error, LocalizedError, Equatable {
    case noData
    case malformedData
    case invalidURL
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .noData:
            return "No data returned from the API."
        case .malformedData:
            return "The data returned from the API could not be decoded."
        case .invalidURL:
            return "The provided URL is invalid."
        case .unknown(let error):
            return "Error: \(error.localizedDescription)"
        }
    }
    
    static func ==(lhs: APIError, rhs: APIError) -> Bool {
        lhs.localizedDescription == rhs.localizedDescription
    }
}
