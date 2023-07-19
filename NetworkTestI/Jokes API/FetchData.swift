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
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else {
                print("No data available.")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("Uknown response type. Expected response should be of type HTTPURLResponse.")
                return
            }
            
            guard response.statusCode >= 200 && response.statusCode < 300 else {
                print("Response code \(response.statusCode) returned.")
                return
            }
            
            guard error == nil else {
                print("Error found: \(String(describing: error))")
                return
            }
            
            /// 3) Decode JSON data into data model so it can be used in our app
            guard let newJoke = try? JSONDecoder().decode(Joke.self, from: data) else {
                print("Unable to decode data into Joke model, please check that properties in data model match API property values.")
                return
            }
            
            print("Decoded JSON: \(newJoke)")
            
            /// 4) Ensure our data appears all at once in our UI
            ///     Note: Concurrency - Ensure the code below is executed on main thread in a non-blocking way (by default URLSession task goes on the background thread, which we want to override here)
            ///         This allows our array to store data and update it in the UI async. If we just ran self.randomJokes.append(newJoke) on its own, it would update random parts at random times.
            ///         Similar to Promise.all([]), which queues up all the responses and stores them at once.
            DispatchQueue.main.async { [weak self] in
                self?.randomJokes.append(newJoke)
            }
        }.resume() // resume starts the URLSession data task
    }
}
