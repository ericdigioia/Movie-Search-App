//
//  CDFavoritesList+CoreDataProperties.swift
//  MovieSearchApp
//
//  Created by Louis Eric Di Gioia
//
//

import Foundation
import CoreData


extension CDFavoritesList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDFavoritesList> {
        return NSFetchRequest<CDFavoritesList>(entityName: "CDFavoritesList")
    }

    @NSManaged public var movies: NSSet?
    
    // return movies NSSet as a sorted Swift array
    public var moviesArray: [CDMovieBasicInfo] {
        let set = movies as? Set<CDMovieBasicInfo> ?? [] // cast NSSet to Set
        return set.sorted { // return sorted Set
            $0.titleUnwrapped < $1.titleUnwrapped
        }
    }
    
    // returns true if movie with matching title and year is in favorites
    public func containsMovie(title: String, year: String) -> Bool {
        if moviesArray.contains(where: {$0.titleUnwrapped == title && $0.yearUnwrapped == year}) {
            return true
        } else {
            return false
        }
    }
    
    // returns object matching title and year from list
    public func getMovieFromFavorites(title: String, year: String) -> CDMovieBasicInfo? {
        return moviesArray.filter { movie in
            if movie.titleUnwrapped == title && movie.yearUnwrapped == year {
                return true
            } else {
                return false
            }
        }.first
    }

}

// MARK: Generated accessors for movies
extension CDFavoritesList {

    @objc(addMoviesObject:)
    @NSManaged public func addToMovies(_ value: CDMovieBasicInfo)

    @objc(removeMoviesObject:)
    @NSManaged public func removeFromMovies(_ value: CDMovieBasicInfo)

    @objc(addMovies:)
    @NSManaged public func addToMovies(_ values: NSSet)

    @objc(removeMovies:)
    @NSManaged public func removeFromMovies(_ values: NSSet)

}

extension CDFavoritesList : Identifiable {

}
