//
//  CDMovieBasicInfo+CoreDataProperties.swift
//  MovieSearchApp
//
//  Created by Louis Eric Di Gioia
//
//

import Foundation
import CoreData


extension CDMovieBasicInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDMovieBasicInfo> {
        return NSFetchRequest<CDMovieBasicInfo>(entityName: "CDMovieBasicInfo")
    }

    @NSManaged public var posterURL: String?
    @NSManaged public var title: String?
    @NSManaged public var year: String?
    @NSManaged public var owner: CDFavoritesList?
    
    // unwrap various properties for convenience
    public var posterURLUnwrapped: URL {
        return URL(string: posterURL ?? "https://placehold.jp/100x200.png")!
    }
    
    public var titleUnwrapped: String {
        return title ?? "no title"
    }
    
    public var yearUnwrapped: String {
        return year ?? "no year"
    }
    
    public var ownerUnwrapped: CDFavoritesList {
        return owner ?? CDFavoritesList()
    }

}

extension CDMovieBasicInfo : Identifiable {

}
