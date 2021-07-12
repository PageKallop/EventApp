//
//  EventManager.swift
//  EventApp
//
//  Created by Page Kallop on 6/24/21.
//

import Foundation

final class EventManager {
    var ar = [Array<Any>]()
    static let shared = EventManager()
    
    let urlConstant = URL(string: "https://api.seatgeek.com/2/performers?client_id=MjIzMzA2NDl8MTYyNDQ2MDY1NC4zMTk1Nzk0&q=")
    
    let searchURL = "https://api.seatgeek.com/2/performers?client_id=MjIzMzA2NDl8MTYyNDQ2MDY1NC4zMTk1Nzk0&q="
    
    private init() {}
    
    func getEvents(completion: @escaping (Result<[Performers], Error>) -> Void) {
        
        guard let url = urlConstant else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(EventData.self, from: data)
                    

                    completion(.success(result.performers))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    func search(with query: String, completion: @escaping (Result<[Performers], Error>) -> Void) {
        
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        let urlString = searchURL + query
        print(urlString)
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(EventData.self, from: data)

                    completion(.success(result.performers))
                   
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
