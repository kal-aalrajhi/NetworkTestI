//
//  FetchData.swift
//  NetworkTestI
//
//  Created by Dr Cpt Blackbeard on 7/19/23.
// Comments

import Foundation

class JokesViewModel: ObservableObject {
    
    @Published var randomJokes: [Joke] = []
    
    init() {
        getRandomJokes()
    }
    
    func getRandomJokes() {
        /// 1) Get the URL
        guard let url = URL(string: "https://official-joke-api.appspot.com/jokes/random") else {
            print("Unable to retrive URL")
            return
        }
        
        /// 2) Download whats at that URL
        ///       a. check that there is actually data at endpoint
        ///       b. check that there is a valid HTTP URL Response code. If there is, then check that it's a 2xx status code.
        ///       c. check for any error messages
        downloadData(fromURL: url) { returnedData in
            if let data = returnedData {
                
        /// 3) Decode JSON data into newJoke data model so it can be used in our app
                guard let newJoke = try? JSONDecoder().decode(Joke.self, from: data) else {
                    print("Unable to decode data into Joke model, please check that properties in data model match API property values.")
                    return
                }
                print("Decoded JSON: \(newJoke)")
        
        /// 4) Ensure our data appears all at once in our UI
                DispatchQueue.main.async { [weak self] in
                    self?.randomJokes.append(newJoke)
                }
            }
        }
    }
    
    func downloadData(fromURL url: URL, completionHandler: @escaping (_ data: Data?) -> ()) {
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print("No data available.")
                completionHandler(nil)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("Uknown response type. Expected response should be of type HTTPURLResponse.")
                completionHandler(nil)
                return
            }
            
            guard response.statusCode >= 200 && response.statusCode < 300 else {
                print("Response code \(response.statusCode) returned.")
                completionHandler(nil)
                return
            }
            
            guard error == nil else {
                print("Error found: \(String(describing: error))")
                completionHandler(nil)
                return
            }
            
            // Success - return data
            completionHandler(data)
        }.resume() // resume starts the URLSession data task
    }
}
