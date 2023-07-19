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
        Text("Hello JokeView!")
    }
}

struct JokeView_Previews: PreviewProvider {
    static var previews: some View {
        JokeView()
    }
}
