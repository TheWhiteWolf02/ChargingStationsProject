import Foundation
import Combine

protocol chargingStationsAPIProtocol {
    func fetchChargingStationsInfo() -> AnyPublisher<[PointOfInterest], Error>
}

class ChargingStationsAPI: chargingStationsAPIProtocol {
    private let key: String = "1e2cb9c6-a0e9-3er2"
    private let urlSession: URLSession
    
    private var apiEndpoint: URL {
        let baseURLString = "https://example.com/"
        let apiPath = "v3/poi?"
        let queryItems = [
            URLQueryItem(name: "latitude", value: "52.526"),
            URLQueryItem(name: "longitude", value: "13.415"),
            URLQueryItem(name: "distance", value: "5"),
            URLQueryItem(name: "distanceunit", value: "km"),
            URLQueryItem(name: "key", value: key)
        ]
        var components = URLComponents(string: baseURLString)!
        components.path += apiPath
        components.queryItems = queryItems
        return components.url!
    }
    
    init(session: URLSession = .shared) {
        urlSession = session
    }
    
    func fetchChargingStationsInfo() -> AnyPublisher<[PointOfInterest], Error> {
        let urlRequest = URLRequest(url: apiEndpoint)
        
        return urlSession.dataTaskPublisher(for: urlRequest)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("[Error] [API] bad server response")
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: [PointOfInterest].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
