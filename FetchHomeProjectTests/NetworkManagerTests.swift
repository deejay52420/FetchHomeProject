//
//  NetworkManagerTests.swift
//  FetchHomeProjectTests
//
//  Created by Derrick Turner on 6/2/25.
//

import XCTest
@testable import FetchHomeProject

final class NetworkManagerTests: XCTestCase {
    
    struct MockFetcher: DataFetcher {
        enum Scenario {
            case success, malformed, empty
        }
        
        let scenario: Scenario
        
        func fetchData(from url: URL) throws -> Data {
            switch scenario {
            case .success:
                let json = """
                        {
                            "recipes": [
                                {"cuisine": "British", "name": "Bakewell Tart", "photo_url_large": "https://some.url/large.jpg", "photo_url_small": "https://some.url/small.jpg", "uuid": "eed6005f-f8c8-451f-98d0-4088e2b40eb6", "source_url": "https://some.url/index.html", "youtube_url": "https://www.youtube.com/watch?v=some.id"
                                }
                            ]
                        }
                        """
                return Data(json.utf8)
            case .malformed:
                let json = "{invalid json}"
                return Data(json.utf8)
            case .empty:
                let json = """
                        {
                            "recipes": []
                        }
                        """
                return Data(json.utf8)
            }
        }
    }
        
        struct InvalidURLFetcher: DataFetcher {
            func fetchData(from url: URL) throws -> Data {
                throw APIError.invalidURL
            }
        }
        
        class MockImageCache: ImageCacher {
            func image(for url: URL) -> UIImage? {
                return cache[url]
            }
            
            func store(_ image: UIImage, for url: URL) {
                cache[url] = image
            }
            
            private var cache = [URL: UIImage]()
        }
        
        struct MockImageDataFetcher: DataFetcher {
            var imageData: Data?
            func fetchData(from url: URL) throws -> Data {
                if let imageData {
                    return imageData
                }
                throw NSError(domain: "MockImageDataError", code: 111, userInfo: nil)
            }
        }
        
        func test_fetchRecipes_Success() async throws {
            let manager = NetworkManager(fetcher: MockFetcher(scenario: .success))
            let recipes = try await manager.fetchRecipes()
            XCTAssertEqual(recipes.count, 1)
            XCTAssertEqual(recipes.first?.name, "Bakewell Tart")
        }
        
        func test_fetchRecipes_MalformedData() async {
            let manager = NetworkManager(fetcher: MockFetcher(scenario: .malformed))
            do {
                _ = try await manager.fetchRecipes()
            } catch {
                XCTAssertEqual(error as? APIError, .malformedData)
            }
        }
        
        func test_fetchRecipes_EmptyData() async {
            let manager = NetworkManager(fetcher: MockFetcher(scenario: .empty))
            do {
                _ = try await manager.fetchRecipes()
            } catch {
                XCTAssertEqual(error as? APIError, .noData)
            }
        }
        
        func test_fetchRecipes_InvalidURL() async {
            
            let manager = NetworkManager(fetcher: InvalidURLFetcher())
            do {
                _ = try await manager.fetchRecipes()
                XCTFail("Expected to throw APIError.invalidURL")
            } catch {
                XCTAssertEqual(error as? APIError, .invalidURL)
            }
        }
        
        func test_downloadImage_WithNilURL() async throws {
            let manager = NetworkManager(fetcher: MockFetcher(scenario: .success), imageCache: MockImageCache())
            let result = try await manager.downloadImage(fromURLString: nil)
            XCTAssertNil(result)
        }
        
        func test_downloadImage_WithEmptyURL() async throws {
            let manager = NetworkManager(fetcher: MockFetcher(scenario: .success), imageCache: MockImageCache())
            let result = try await manager.downloadImage(fromURLString: "")
            XCTAssertNil(result)
        }
        
        func test_downloadImage_WithCachedImage_ReturnsFromCache() async throws {
            let url = URL(string: "https://example.com/image.jpg")!
            let image = UIImage(systemName: "star")!
            let cache = MockImageCache()
            cache.store(image, for: url)
            let manager = NetworkManager(fetcher: MockFetcher(scenario: .success), imageCache: cache)
            
            let result = try await manager.downloadImage(fromURLString: url.absoluteString)
            XCTAssertEqual(result?.pngData(), image.pngData())
        }
        
        func test_downloadImage_FetchesAndCachesImage() async throws {
            let urlString = "https://example.com/image.jpg"
            let dummyImage = UIImage(systemName: "star")!
            let dummyData = dummyImage.pngData()
            
            let fetcher = MockImageDataFetcher(imageData: dummyData)
            let cache = MockImageCache()
            let manager = NetworkManager(fetcher: fetcher, imageCache: cache)
            
            let result = try await manager.downloadImage(fromURLString: urlString)
            XCTAssertNotNil(result)
            XCTAssertNotNil(cache.image(for: URL(string: urlString)!))
        }
        
        func test_downloadImage_InvalidData() async {
            let urlString = "https://example.com/image.jpg"
            let fetcher = MockImageDataFetcher(imageData: Data()) // invalid image data
            let cache = MockImageCache()
            let manager = NetworkManager(fetcher: fetcher, imageCache: cache)
            
            do {
                _ = try await manager.downloadImage(fromURLString: urlString)
            } catch {
                XCTAssertEqual((error as NSError).domain, "Invalid Image Data")
            }
        }
    }
    

