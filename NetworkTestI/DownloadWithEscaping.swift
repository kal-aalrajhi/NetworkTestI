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
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in

            guard let data = data else {
                print("No data.")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("Unknown response type.")
                return
            }
            
            guard response.statusCode >= 200 && response.statusCode < 300 else {
                print("Response code should be a success case (2xx), but it's \(response.statusCode)")
                return
            }
            
            guard error == nil else {
                print("Error found: \(String(describing: error))")
                return
            }

            guard let newPost = try? JSONDecoder().decode(PostModel.self, from: data) else {
                print("Unable to decode data into PostModel, please check that properties in data model match API property values.")
                return
            }

            DispatchQueue.main.async { [weak self] in
                self?.posts.append(newPost)
            }
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
