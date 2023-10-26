//
//  FavoritesScreenViewController.swift
//  MovieSearchApp
//
//  Created by Louis Eric Di Gioia
//

import UIKit
import CoreData

class FavoritesScreenViewController: UIViewController {
    // properties
    var favoritesList: CDFavoritesList?
    // UI components
    let favoritesTable = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
        view.backgroundColor = .systemBackground
        view.addSubview(favoritesTable)
        setupFavoritesTable()
        fetchFavoritesList()
    }
    
    // refresh favorites table
    override func viewWillAppear(_ animated: Bool) {
        favoritesTable.reloadData()
    }
    
    func setupFavoritesTable() {
        // behavior
        favoritesTable.dataSource = self
        favoritesTable.delegate = self
        favoritesTable.register(CustomTableCell.self, forCellReuseIdentifier: CustomTableCell.ID)
        favoritesTable.rowHeight = 120
        favoritesTable.allowsSelection = true
        // auto layout constraints
        favoritesTable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            favoritesTable.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            favoritesTable.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            favoritesTable.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            favoritesTable.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
    }

}

// handle UITableView stuff
extension FavoritesScreenViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesList?.moviesArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoritesTable.dequeueReusableCell(withIdentifier: CustomTableCell.ID) as! CustomTableCell
        if let favoritesList = favoritesList {
            cell.set(CDMovie: favoritesList.moviesArray[indexPath.row])
        }
        return cell
    }
    
    // when a movie is tapped, open the details page for that movie
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let favoritesList = favoritesList {
            let movieTitle = favoritesList.moviesArray[indexPath.row].titleUnwrapped
            let movieYear = favoritesList.moviesArray[indexPath.row].yearUnwrapped
            Task {
                if let movie = await fetchMovie(title: movieTitle, year: movieYear) {
//                    print("Fetched movie: \(movie)")
                    navigationController?.pushViewController(MovieDetailsScreenViewController(movie: movie), animated: true)
                }
            }
        }
    }
    
    // enable row editing for deletion
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // swipe to delete movie
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            removeFromFavorites(atIndex: indexPath.row)
        }
    }
}

// handle Core Data stuff
extension FavoritesScreenViewController {
    
    func fetchFavoritesList() {
        Task {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                print("fetchFavoritesList: Error in getting appDelegate")
                return
            }
            let context = appDelegate.persistentContainer.viewContext // get Core Data context
            let favoritesListFetchRequest = NSFetchRequest<CDFavoritesList>(entityName: "CDFavoritesList")
            // attempt to fetch favorites list
            do {
                if let fetchedFavorites: CDFavoritesList = try context.fetch(favoritesListFetchRequest).first {
                    favoritesList = fetchedFavorites
                } else {
                    print("fetchFavoritesList: Could not find CDFavoritesList in container!")
                    favoritesList = CDFavoritesList(context: context)
                    print("fetchFavoritesList: Created favorites list")
                }
                favoritesTable.reloadData() // refresh the list view
                return
            } catch let error as NSError {
                print("fetchFavoritesList: Error fetching CDFavoritesList. \(error). \(error.userInfo).")
                return
            }
        }
    }
    
    func removeFromFavorites(atIndex index: Int) {
        Task {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                print("removeFromFavorites: Error in getting appDelegate")
                return
            }
            let context = appDelegate.persistentContainer.viewContext // get Core Data context
            // retrieve object to be deleted
            guard let objectToDelete = favoritesList?.moviesArray[index] else {
                print("removeFromFavorites: Error in finding object to delete")
                return
            }
            // delete object from Core Data container
            context.delete(objectToDelete)
            do {
                try context.save()
            } catch let error as NSError {
                print("removeFromFavorites: Error saving updated data. \(error). \(error.userInfo).")
            }
            favoritesTable.reloadData() // refresh the list view
            return
        }
    }
    
    
}
