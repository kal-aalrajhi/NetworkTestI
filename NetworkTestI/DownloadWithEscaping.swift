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
        // Assign URL
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1") else {
            print("Unable to retrieve URL")
            return
        }
        // Attempt to download data from URL
        downloadData(fromURL: url) { returnedData in
            if let data = returnedData {
                // Make our data PostModel specific
                guard let newPost = try? JSONDecoder().decode(PostModel.self, from: data) else {
                    print("Unable to decode data into PostModel, please check that properties in data model match API property values.")
                    return
                }
                // Append data to array
                DispatchQueue.main.async { [weak self] in
                    self?.posts.append(newPost)
                }
            } else {
                print("No data returned")
            }
        }
    }

    // Generic helper function for downloading anytype of data
    // URLSessions returns data async, we gotta wait for a return. This is why we use @escaping
    // Our completionHandler of type @escaping will return data of type Data
    func downloadData(fromURL url: URL, completionHandler: @escaping (_ data: Data?) -> ()) {

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300,
                error == nil
            // Failure case
            else {
                    print("Error downloading data.")
                    completionHandler(nil)
                    return
                }
            // Success
            completionHandler(data)
        }.resume()
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
