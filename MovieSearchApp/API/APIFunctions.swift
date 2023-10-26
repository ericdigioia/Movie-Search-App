//
//  APIFunctions.swift
//  MovieSearchApp
//
//  Created by Louis Eric Di Gioia
//

import Foundation

// search for movies by title and (optionally) year and page number of results
func searchMovies(searchQuery: String, year: String? = nil, pageNum: Int = 1) async -> SearchResponse? {
    // make search query conform to URL/API format
    let apiFriendlyQuery = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "+")
    // if year is included in search
    if let year = year {
        if !CharacterSet(charactersIn: year).isSubset(of: CharacterSet(charactersIn: "0123456789")) {
            print("Invalid year")
            return nil
        }
    }
    // create API request string (default page number is 1)
    let apiRequestString = "https://www.omdbapi.com/?apikey=887374ab&s=\(apiFriendlyQuery)&type=movie\(year != nil ? "&year=\(year!)" : "")&page=\(pageNum)"
    guard let url = URL(string: apiRequestString) else { print("Invalid URL"); return nil }
    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        do {
            let response: SearchResponse = try JSONDecoder().decode(SearchResponse.self, from: data)
            return response
        } catch DecodingError.dataCorrupted(let context) {
            print(context)
        } catch DecodingError.keyNotFound(let key, let context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch DecodingError.valueNotFound(let value, let context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch DecodingError.typeMismatch(let type, let context) {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        }
    } catch {
        print("Invalid data")
    }
    return nil
}

// add more pages of search results to an existing API response, returns the resulting modified response object
func loadMoreResults(existingResponse: SearchResponse, query: String, numPages: Int) async -> SearchResponse {
    var combinedResponse = existingResponse
    // each new request loads 10 more movies
    for pageCounter in (combinedResponse.numPagesLoaded+1)...(combinedResponse.numPagesLoaded+1+numPages) {
        guard (combinedResponse.numPagesLoaded) < combinedResponse.totalPages else {
            // if requested page number exceeds valid total page numbers for query, return
//            print("reached final page of search results")
//            print("\(query): Loaded page \(combinedResponse.numPagesLoaded)/\(combinedResponse.totalPages)")
            return combinedResponse
        }
        // get 10 more results and put them in newResponse
        if let newResponse = await searchMovies(searchQuery: query, pageNum: pageCounter) {
            // combine newResponse with combinedResponse
            combinedResponse.addMoreResults(newResponse.results, numNewPages: 1)
//            print("added new page of results to response")
//            print("\(query): Loaded page \(combinedResponse.numPagesLoaded)/\(combinedResponse.totalPages)")
        }
    }
    return combinedResponse
}

// fetch specific movie matching title and year
func fetchMovie(title: String, year: String) async -> Movie? {
    // make title conform to URL/API format
    let fixedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "+")
    // create API request string
    let apiRequestString = "https://www.omdbapi.com/?apikey=887374ab&t=\(fixedTitle)&type=movie&year=\(year)&plot=full"
    guard let url = URL(string: apiRequestString) else { print("Invalid URL"); return nil }
    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        do {
            let movie: Movie = try JSONDecoder().decode(Movie.self, from: data)
            return movie
        } catch DecodingError.dataCorrupted(let context) {
            print(context)
        } catch DecodingError.keyNotFound(let key, let context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch DecodingError.valueNotFound(let value, let context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch DecodingError.typeMismatch(let type, let context) {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        }
    } catch {
        print("Invalid data")
    }
    return nil
}
