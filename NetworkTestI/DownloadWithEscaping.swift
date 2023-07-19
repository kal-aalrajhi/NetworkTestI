//
//  DownloadWithEscaping.swift
//  NetworkTestI
//
//  Created by Dr Cpt Blackbeard on 7/19/23.
//

import SwiftUI

// MODEL (M of MVVM)
struct PostModel: Identifiable, Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

// VIEW MODEL (VM of MVVM)
class DownloadWithEscapingViewModel: ObservableObject {

    @Published var posts: [PostModel] = []
    
    init() {
        getPosts()
    }
    
    func getPosts() {
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1") else {
            print("Unable to retrieve URL")
            return
        }
        
        /// URLSession.shared.dataTask(with: url) - we download whats at that URL
        /// {(data, response, error) in ...} - once downloaded, this closure will run with some data, a response, and an error
        /// data - will be data; response - will be 200, 400, etc...; error - will be nil or some message
        /// Before we do anything, we want to check to see if those parameters have values and do stuff with it
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Data tasks go on a background thread by default
            
            /// >>>>> CHECKS FOR DOWNLOADED DATA <<<<<
            // Are we even able to retrieve the data?
            guard let data = data else {
                print("No data.")
                return
            }
            
            // The response should come back as a valid HTTPURLResponse type
            guard let response = response as? HTTPURLResponse else {
                print("Unknown response type.")
                return
            }
            
            // We have a valid code, but is NOT a success code (200-299 are success cases)
            guard response.statusCode >= 200 && response.statusCode < 300 else {
                print("Response code should be a success case (2xx), but it's \(response.statusCode)")
                return
            }
            
            guard error == nil else {
                print("Error found: \(String(describing: error))")
                return
            }
            
            print("SUCCESSFULLY DOWNLOADED DATA!")
            print("PURE DATA: \(data)")
            let jsonString = String(data: data, encoding: .utf8)
            print("JSON (pre-decoding): \(String(describing: jsonString))")
            /// >>>>> END CHECKS FOR DOWNLOADED DATA <<<<<
            
            /// >>>>> BEGIN DATA DECODE <<<<<
            // Can we get the data to fit our data Model?
            guard let newPost = try? JSONDecoder().decode(PostModel.self, from: data) else {
                print("Unable to decode data into PostModel, please check that properties in data model match API property values.")
                return
            }
            print("SUCCESSFULLY DECODED!")
            print("JSON (decoded): \(newPost)")
            /// >>>>> END DATA DECODE <<<<<<
            
            // Now we have the data stored in our data Model, we can use it!
            // If we wanna display our data in a view, we gotta put our data task on the main thread instead of the the background thread.
            // DispatchQueue is used to ensure that the code inside the block is executed on the main queue, and therefore, it's safe to update UI elements like your randomJokes array that's being observed for changes in your app's user interface
            DispatchQueue.main.async { [weak self] in
                self?.posts.append(newPost)
            }
        }.resume() // resume starts the URLSession data task
    }
    
}

// VIEW (V of MVVM)
struct DownloadWithEscaping: View {
    
    @StateObject var vm = DownloadWithEscapingViewModel()
    
    var body: some View {
        List {
            ForEach(vm.posts) { post in
                VStack {
                    Text(post.title)
                        .font(.headline)
                    Text(post.body)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

struct DownloadWithEscaping_Previews: PreviewProvider {
    static var previews: some View {
        DownloadWithEscaping()
    }
}
