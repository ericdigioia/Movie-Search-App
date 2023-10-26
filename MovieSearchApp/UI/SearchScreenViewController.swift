//
//  MainViewController.swift
//  MovieSearchApp
//
//  Created by Louis Eric Di Gioia
//

import UIKit

class SearchScreenViewController: UIViewController {
    // properties
    var response = SearchResponse() // API call decoded server response
    var searchDebounceTimer: Timer? // debounce timer to reduce spam API calls
    // UI components
    let movieResultsTable = UITableView()
    let searchController = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        view.backgroundColor = .systemBackground
        view.addSubview(movieResultsTable)
        setupSearchController()
        setupMovieResultsTable()
    }
    
    func setupSearchController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = false
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movie"
        searchController.searchBar.sizeToFit()
    }
    
    func setupMovieResultsTable() {
        // behavior
        movieResultsTable.dataSource = self
        movieResultsTable.delegate = self
        movieResultsTable.register(CustomTableCell.self, forCellReuseIdentifier: CustomTableCell.ID)
        movieResultsTable.rowHeight = 120
        movieResultsTable.allowsSelection = true
        // auto layout constraints
        movieResultsTable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieResultsTable.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            movieResultsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            movieResultsTable.leftAnchor.constraint(equalTo: view.leftAnchor),
            movieResultsTable.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
}

extension SearchScreenViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        // invalidate current timer if any
        searchDebounceTimer?.invalidate()
        // asynchronously call API function after 0.5s
        searchDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            Task { // fetch search results from server concurrently
                if let searchQuery = searchController.searchBar.text {
                    self.response = await searchMovies(searchQuery: searchQuery) ?? SearchResponse()
                    Task { @MainActor in // update UI on main thread
                        self.movieResultsTable.reloadData()
                    }
                }
            }
        }
    }
    
}

extension SearchScreenViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return response.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = movieResultsTable.dequeueReusableCell(withIdentifier: CustomTableCell.ID) as! CustomTableCell
        cell.set(movie: response.results[indexPath.row])
        return cell
    }
    
    // load at most 20 more results if possible from the server if the user wants to see more results (scrolls to the bottom)
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == response.results.count-1 {
            Task {
                if response.numPagesLoaded < response.totalPages {
                    response = await loadMoreResults(existingResponse: response, query: searchController.searchBar.text!, numPages: 1)
                    tableView.reloadData()
                }
            }
        }
    }
    
    // when a movie is tapped, open the details page for that movie
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieTitle = response.results[indexPath.row].title
        let movieYear = response.results[indexPath.row].year
        Task {
            if let movie = await fetchMovie(title: movieTitle, year: movieYear) {
//                print("Fetched movie: \(movie)")
                navigationController?.pushViewController(MovieDetailsScreenViewController(movie: movie), animated: true)
            }
        }
    }
}
