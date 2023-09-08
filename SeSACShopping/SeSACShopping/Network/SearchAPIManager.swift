//
//  NaverAPIManager.swift
//  SeSACShopping
//
//  Created by do hee kim on 2023/09/08.
//

import Foundation

protocol SearchAPIManagerProtocol: AnyObject {
    
    func fetchProduct(name query: String, completionHandler: @escaping (ProductData) -> Void)
    
}

final class SearchAPIManager: SearchAPIManagerProtocol {
    
    private let httpHeader = [
        "X-Naver-Client-Id": "Kdp7MQo9l90du4HHE9bu",
        "X-Naver-Client-Secret": "5krHokeuun"
    ]
    
    func fetchProduct(name query: String, completionHandler: @escaping (ProductData) -> Void) {
        
        guard var components = URLComponents(string: SearchEndpoint.shop.requestURL) else {
            print("urlComponents 생성에 실패했습니다.")
            return
        }
        let query = URLQueryItem(name: "query", value: query)
        let display = URLQueryItem(name: "display", value: "30")
        
        components.queryItems = [query, display]
        
        guard let url = components.url else {
            print("urlComponents 변환에 실패했습니다.")
            return
        }
        
        fetchData(from: url) { (productData: ProductData) in
            
            completionHandler(productData)
            
        }
        
    }
    
    private func fetchData<T: Codable>(from url: URL, completionHandler: @escaping (T) -> Void) {
        
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = httpHeader
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error {
                print("request를 실패했습니다.", error)
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...500).contains(response.statusCode) else {
                print("status code가 200~500을 벗어났습니다.")
                return
            }
            
            guard let data = data else {
                print("data가 비어있습니다.")
                return
            }
            
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                
                completionHandler(result)
                
            } catch {
                print("decoding을 실패했습니다.")
            }
        }.resume()
        
    }
    
}
