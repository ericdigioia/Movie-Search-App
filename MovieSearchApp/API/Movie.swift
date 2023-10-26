//
//  Movie.swift
//  MovieSearchApp
//
//  Created by Louis Eric Di Gioia
//

import Foundation

// Result: contains details for one movie
struct Movie: Codable {
    // core properties fetched in search
    var title: String
    var year: String
    var poster: URL
    // detail properties fetched on tap
    var plot: String?
    var rated: String?
    var released: String?
    var runtime: String?
    var genre: String?
    var director: String?
    var writers: String?
    var actors: String?
    var language: String?
    var country: String?
    var awards: String?
    var ratings: [MovieRating]?
    var metascore: String?
    var imdbRating: String?
    var imdbVotes: String?
    var imdbID: String?
    var dvd: String?
    var boxOffice: String?
    var production: String?
    var website: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case poster = "Poster"
        case plot = "Plot"
        case rated = "Rated"
        case released = "Released"
        case runtime = "Runtime"
        case genre = "Genre"
        case director = "Director"
        case writers = "Writers"
        case actors = "Actors"
        case language = "Language"
        case country = "Country"
        case awards = "Awards"
        case ratings = "Ratings"
        case metascore = "Metascore"
        case imdbRating = "imdbRating"
        case imdbVotes = "imdbVotes"
        case imdbID = "imdbID"
        case dvd = "DVD"
        case boxOffice = "BoxOffice"
        case production = "Production"
        case website = "Website"
    }
    
    init() { // init with placeholder data
        title = "N/A"
        year = "N/A"
        poster = URL(string: "https://placehold.jp/100x200.png")!
    }
    
}

struct MovieRating: Codable {
    var source: String?
    var value: String?
    
    enum CodingKeys: String, CodingKey {
        case source = "Source"
        case value = "Value"
    }
}
