//
//  JokeView.swift
//  NetworkTestI
//
//  Created by Dr Cpt Blackbeard on 7/19/23.
//

import SwiftUI

struct JokeView: View {
    @StateObject var jokesVM = JokesViewModel()
    
    var body: some View {
        VStack {
            Text("Hello JokeView!")
                .font(.title)
            ForEach(jokesVM.randomJokes) { joke in
                VStack(alignment: .leading, spacing: 10) {
                    Text("Setup: \(joke.setup)")
                        .font(.title2)
                    Text("Punchline: \(joke.punchline)")
                        .font(.title3)
                }
            }
        }
    }
}

struct JokeView_Previews: PreviewProvider {
    static var previews: some View {
        JokeView()
    }
}
