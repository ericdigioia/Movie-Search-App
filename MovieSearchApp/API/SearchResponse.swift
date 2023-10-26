//
//  SearchResponse.swift
//  MovieSearchApp
//
//  Created by Louis Eric Di Gioia
//

import Foundation

// Response: contains array of results
struct SearchResponse: Codable {
    var results: [Movie]
    var totalResults: Int
    var response: Bool
    var error: String
    // properties not decoded from API JSON response
    var totalPages: Int { // number of valid pages of results to request from server (each page is 10 results)
        return (totalResults / 10 ) + 1
    }
    var numPagesLoaded: Int = 1
    
    enum CodingKeys: String, CodingKey {
        case results = "Search"
        case totalResults = "totalResults"
        case response = "Response"
        case error = "Error"
    }
    
    init() { // init with placeholder data
        self.results = []
        self.totalResults = 0
        self.response = false
        self.error = ""
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let decodedResults = try? container.decode([Movie].self, forKey: .results) {
            self.results = decodedResults
        } else {
            self.results = []
        }
        if let decodedTotalResults = try? container.decode(String.self, forKey: .totalResults) {
            self.totalResults = Int(decodedTotalResults) ?? 0
        } else {
            self.totalResults = 0
        }
        if let decodedResponse = try? container.decode(Bool.self, forKey: .response) {
            self.response = decodedResponse
        } else {
            self.response = false
        }
        if let decodedError = try? container.decode(String.self, forKey: .error) {
            self.error = decodedError
        } else {
            self.error = ""
        }
    }
    
    // append more search results to the response's movie array
    mutating func addMoreResults(_ newMovies: [Movie], numNewPages: Int) {
        self.results.append(contentsOf: newMovies)
        self.numPagesLoaded += numNewPages
    }
}
