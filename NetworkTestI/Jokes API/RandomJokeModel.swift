//
//  RandomJokeModel.swift
//  NetworkTestI
//
//  Created by Dr Cpt Blackbeard on 7/19/23.
//
// API Docs: https://github.com/15Dkatz/official_joke_api
import Foundation

// Step 1) Define the data structure

struct Joke: Identifiable, Codable {
    let id: Int
    let type: String
    let setup: String
    let punchline: String
}
