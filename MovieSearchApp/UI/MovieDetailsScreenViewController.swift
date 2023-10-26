//
//  MovieDetailsScreenViewController.swift
//  MovieSearchApp
//
//  Created by Louis Eric Di Gioia
//

import UIKit
import CoreData

class MovieDetailsScreenViewController: UIViewController {
    // properties
    let movie: Movie
    // UI components
    var favoriteButton = UIBarButtonItem() // favorite button
    var scrollView = UIScrollView() // scrollView to fill entire safe area
    var contentView = UIView() // all content that goes inside the scrollView
    var titleLabel = UILabel()
    var yearRatedRuntimeLabel = UILabel()
    var posterView = UIImageView()
    var ratingsHStack = UIStackView()
    var genreHStack = UIStackView()
    var imdbRatingLabel = UILabel()
    var plotLabel = UILabel()
    var directorsWritersActorsAwardsVStack = UIStackView()
    var productionBoxOfficeHStack = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movie Details"
        view.backgroundColor = .systemBackground
        setupScrollView()
        setupContentView()
        setupFavoriteButton()
        setupPosterView()
        setupTitleLabel()
        setupYearRatedRuntimeLabel()
        setupRatingsHStack()
        setupGenreHStack()
        setupIMDBRatingLabel()
        setupPlotLabel()
        setupDirectorsWritersActorsVStack()
        setupProductionBoxOfficeHStack()
    }
    
    init(movie: Movie) {
        self.movie = movie
        posterView.load(url: movie.poster) // async load poster image from URL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        // auto layout constraints
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func setupContentView() {
        contentView.addSubview(posterView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(yearRatedRuntimeLabel)
        contentView.addSubview(ratingsHStack)
        contentView.addSubview(genreHStack)
        contentView.addSubview(imdbRatingLabel)
        contentView.addSubview(plotLabel)
        contentView.addSubview(directorsWritersActorsAwardsVStack)
        contentView.addSubview(productionBoxOfficeHStack)
        // auto layout constraints
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)
        ])
    }
    
    func setupFavoriteButton() {
        if checkFavoritesForMovie(movie: movie) {
            favoriteButton.image = UIImage(systemName: "star.fill")
        } else {
            favoriteButton.image = UIImage(systemName: "star")
        }
        favoriteButton.style = .plain
        favoriteButton.target = self
        favoriteButton.action = #selector(handleFavoriteButtonTap)
        navigationItem.rightBarButtonItem = favoriteButton
    }
    
    func setupPosterView() {
        posterView.contentMode = .scaleAspectFit
        posterView.backgroundColor = .secondaryLabel
        posterView.layer.borderWidth = 2
        posterView.layer.borderColor = UIColor.secondaryLabel.cgColor
        // auto layout constraints
        posterView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            posterView.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            posterView.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor, constant: 10),
            posterView.heightAnchor.constraint(equalTo: self.view.layoutMarginsGuide.heightAnchor, multiplier: 1/3),
            posterView.widthAnchor.constraint(equalTo: self.posterView.heightAnchor, multiplier: 2/3)
        ])
    }
    
    func setupTitleLabel() {
        titleLabel.text = movie.title
        titleLabel.font = UIFont.systemFont(ofSize: 25)
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontSizeToFitWidth = true
        // auto layout constraints
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: self.posterView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.yearRatedRuntimeLabel.topAnchor)
        ])
    }
    
    func setupYearRatedRuntimeLabel() {
        yearRatedRuntimeLabel.text = "\(movie.year)\(movie.rated == nil ? "" : "・\(movie.rated!)")\(movie.runtime == nil ? "" : "・\(movie.runtime!)")"
        yearRatedRuntimeLabel.textColor = .secondaryLabel
        yearRatedRuntimeLabel.numberOfLines = 1
        yearRatedRuntimeLabel.adjustsFontSizeToFitWidth = true
        // auto layout constraints
        yearRatedRuntimeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            yearRatedRuntimeLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 5),
            yearRatedRuntimeLabel.leadingAnchor.constraint(equalTo: self.posterView.trailingAnchor, constant: 10),
            yearRatedRuntimeLabel.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor),
            yearRatedRuntimeLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.ratingsHStack.topAnchor)
        ])
    }
    
    func setupRatingsHStack() {
        ratingsHStack.axis = .horizontal
        ratingsHStack.spacing = 10
        var singleRatingLabel: UILabel
        // create a new UILabel for each rating and add it to the H stack
        if let ratings = movie.ratings {
            for rating in ratings {
                singleRatingLabel = UILabel()
                singleRatingLabel.numberOfLines = 4
                singleRatingLabel.textAlignment = .center
                singleRatingLabel.textColor = .systemYellow
                singleRatingLabel.adjustsFontSizeToFitWidth = true
                singleRatingLabel.layer.borderWidth = 1
                singleRatingLabel.layer.borderColor = UIColor.systemYellow.cgColor
                singleRatingLabel.layer.cornerRadius = 5
                singleRatingLabel.text = "\(rating.source ?? "error")\n\(rating.value ?? "error")"
                ratingsHStack.addArrangedSubview(singleRatingLabel)
            }
        }
        // auto layout constraints
        ratingsHStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ratingsHStack.topAnchor.constraint(greaterThanOrEqualTo: self.yearRatedRuntimeLabel.bottomAnchor, constant: 5),
            ratingsHStack.leadingAnchor.constraint(equalTo: self.posterView.trailingAnchor, constant: 10),
            ratingsHStack.trailingAnchor.constraint(lessThanOrEqualTo: self.contentView.layoutMarginsGuide.trailingAnchor),
            ratingsHStack.bottomAnchor.constraint(equalTo: self.posterView.bottomAnchor)
        ])
    }
    
    func setupGenreHStack() {
        genreHStack.axis = .horizontal
        genreHStack.spacing = 5
        let genreArray = movie.genre?.components(separatedBy: ", ") ?? []
        var genreLabel: UILabel
        for genre in genreArray {
            genreLabel = UILabel()
            genreLabel.text = " \(genre) "
            genreLabel.numberOfLines = 1
            genreLabel.textColor = .secondaryLabel
            genreLabel.adjustsFontSizeToFitWidth = true
            genreLabel.layer.borderWidth = 1
            genreLabel.layer.borderColor = UIColor.secondaryLabel.cgColor
            genreLabel.layer.cornerRadius = 8
            genreHStack.addArrangedSubview(genreLabel)
        }
        // auto layout constraints
        genreHStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            genreHStack.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            genreHStack.topAnchor.constraint(equalTo: self.posterView.bottomAnchor, constant: 10),
            genreHStack.trailingAnchor.constraint(lessThanOrEqualTo: self.contentView.layoutMarginsGuide.trailingAnchor)
        ])
    }
    
    func setupIMDBRatingLabel() {
        if let imdbRating = movie.imdbRating, let imdbVotes = movie.imdbVotes {
            imdbRatingLabel.text = "IMDB\n\(imdbRating)★ (\(imdbVotes) votes)"
            imdbRatingLabel.numberOfLines = 2
            imdbRatingLabel.textAlignment = .center
            imdbRatingLabel.adjustsFontSizeToFitWidth = true
            imdbRatingLabel.textColor = .systemYellow
        }
        // auto layout constraints
        imdbRatingLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imdbRatingLabel.topAnchor.constraint(equalTo: self.posterView.bottomAnchor, constant: 10),
            imdbRatingLabel.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor),
            imdbRatingLabel.widthAnchor.constraint(lessThanOrEqualTo: self.ratingsHStack.widthAnchor, multiplier: 1/2),
            imdbRatingLabel.bottomAnchor.constraint(equalTo: self.genreHStack.bottomAnchor)
        ])
    }
    
    func setupPlotLabel() {
        plotLabel.text = movie.plot
        plotLabel.numberOfLines = 0
        // auto layout constraints
        plotLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            plotLabel.topAnchor.constraint(equalTo: self.genreHStack.bottomAnchor, constant: 10),
            plotLabel.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            plotLabel.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor),
            plotLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.contentView.layoutMarginsGuide.bottomAnchor)
        ])
    }
    
    func setupDirectorsWritersActorsVStack() {
        directorsWritersActorsAwardsVStack.axis = .vertical
        directorsWritersActorsAwardsVStack.spacing = 10
        // add director(s) if any
        if let directors = movie.director {
            let directorsLabel = UILabel()
            directorsLabel.text = "Director(s): \(directors)"
            directorsLabel.numberOfLines = 0
            let divider = UIView()
            divider.backgroundColor = .secondaryLabel
            divider.heightAnchor.constraint(equalToConstant: 2).isActive = true
            directorsWritersActorsAwardsVStack.addArrangedSubview(divider)
            directorsWritersActorsAwardsVStack.addArrangedSubview(directorsLabel)
        }
        // add writer(s) if any
        if let writers = movie.writers {
            let writersLabel = UILabel()
            writersLabel.text = "Writer(s): \(writers)"
            writersLabel.numberOfLines = 0
            let divider = UIView()
            divider.backgroundColor = .secondaryLabel
            divider.heightAnchor.constraint(equalToConstant: 2).isActive = true
            directorsWritersActorsAwardsVStack.addArrangedSubview(divider)
            directorsWritersActorsAwardsVStack.addArrangedSubview(writersLabel)
        }
        // add actor(s) if any
        if let actors = movie.actors {
            let actorsLabel = UILabel()
            actorsLabel.text = "Star(s): \(actors)" // changed "actor" to "star" to accommodate VA etc.
            actorsLabel.numberOfLines = 0
            let divider = UIView()
            divider.backgroundColor = .secondaryLabel
            divider.heightAnchor.constraint(equalToConstant: 2).isActive = true
            directorsWritersActorsAwardsVStack.addArrangedSubview(divider)
            directorsWritersActorsAwardsVStack.addArrangedSubview(actorsLabel)
        }
        // add awards if any
        if let awards = movie.awards {
            let awardsLabel = UILabel()
            awardsLabel.text = "Awards: \(awards)"
            awardsLabel.numberOfLines = 0
            let divider = UIView()
            divider.backgroundColor = .secondaryLabel
            divider.heightAnchor.constraint(equalToConstant: 2).isActive = true
            directorsWritersActorsAwardsVStack.addArrangedSubview(divider)
            directorsWritersActorsAwardsVStack.addArrangedSubview(awardsLabel)
        }
        // auto layout constraints
        directorsWritersActorsAwardsVStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            directorsWritersActorsAwardsVStack.topAnchor.constraint(equalTo: self.plotLabel.bottomAnchor, constant: 10),
            directorsWritersActorsAwardsVStack.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            directorsWritersActorsAwardsVStack.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor)
        ])
    }
    
    func setupProductionBoxOfficeHStack() {
        productionBoxOfficeHStack.axis = .horizontal
        productionBoxOfficeHStack.spacing = 10
        if let production = movie.production {
            let productionLabel = UILabel()
            productionLabel.text = "Production\n\(production)"
            productionLabel.numberOfLines = 2
            productionLabel.textAlignment = .center
            productionLabel.adjustsFontSizeToFitWidth = true
            productionLabel.layer.borderWidth = 1
            if production != "N/A" {
                productionLabel.layer.borderColor = UIColor.systemGreen.cgColor
                productionLabel.textColor = .systemGreen
            } else {
                productionLabel.layer.borderColor = UIColor.secondaryLabel.cgColor
                productionLabel.textColor = .secondaryLabel
            }
            productionLabel.layer.cornerRadius = 3
            productionBoxOfficeHStack.addArrangedSubview(productionLabel)
        }
        if let boxOffice = movie.boxOffice {
            let boxOfficeLabel = UILabel()
            boxOfficeLabel.text = "Box Office\n\(boxOffice)"
            boxOfficeLabel.numberOfLines = 2
            boxOfficeLabel.textAlignment = .center
            boxOfficeLabel.adjustsFontSizeToFitWidth = true
            boxOfficeLabel.layer.borderWidth = 1
            if boxOffice != "N/A" {
                boxOfficeLabel.layer.borderColor = UIColor.systemGreen.cgColor
                boxOfficeLabel.textColor = .systemGreen
            } else {
                boxOfficeLabel.layer.borderColor = UIColor.secondaryLabel.cgColor
                boxOfficeLabel.textColor = .secondaryLabel
            }
            boxOfficeLabel.layer.cornerRadius = 3
            productionBoxOfficeHStack.addArrangedSubview(boxOfficeLabel)
        }
        // auto layout constraints
        productionBoxOfficeHStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            productionBoxOfficeHStack.topAnchor.constraint(equalTo: self.directorsWritersActorsAwardsVStack.bottomAnchor, constant: 10),
            productionBoxOfficeHStack.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            productionBoxOfficeHStack.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor),
            productionBoxOfficeHStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }

}



// handle Core Data stuff here
extension MovieDetailsScreenViewController {
    
    @objc func handleFavoriteButtonTap() {
        if checkFavoritesForMovie(movie: movie) {
            removeFromFavorites()
        } else {
            addToFavorites()
        }
    }
    
    func addToFavorites() {
        Task {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                print("addToFavorites: Error in getting appDelegate")
                return
            }
            let context = appDelegate.persistentContainer.viewContext // get Core Data context
            let favoritesListFetchRequest = NSFetchRequest<CDFavoritesList>(entityName: "CDFavoritesList")
            // attempt to fetch favorites list
            do {
                var favoritesList: CDFavoritesList
                if let fetchedFavorites: CDFavoritesList = try context.fetch(favoritesListFetchRequest).first {
                    favoritesList = fetchedFavorites
                } else {
                    print("addToFavorites: Could not find CDFavoritesList in container!")
                    favoritesList = CDFavoritesList(context: context)
                    print("addToFavorites: Created favorites list")
                }
                // create new Core Data movie basic info object
                let newCDMovie = CDMovieBasicInfo(context: context)
                newCDMovie.title = movie.title
                newCDMovie.year = movie.year
                newCDMovie.posterURL = movie.poster.absoluteString
                // add new object to favorites list
                favoritesList.addToMovies(newCDMovie)
                // attempt to save
                do {
                    try context.save()
                    // update nav bar favorite button icon
                    favoriteButton.image = UIImage(systemName: "star.fill")
                    return
                } catch let error as NSError {
                    print("addToFavorites: Error saving CDFavoritesList. \(error). \(error.userInfo).")
                }
            } catch let error as NSError {
                print("addToFavorites: Error fetching CDFavoritesList. \(error). \(error.userInfo).")
                return
            }
        }
    }
    
    func removeFromFavorites() {
        Task {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                print("removeFromFavorites: Error in getting appDelegate")
                return
            }
            let context = appDelegate.persistentContainer.viewContext // get Core Data context
            do {
                var favoritesList: CDFavoritesList
                let favoritesListFetchRequest = NSFetchRequest<CDFavoritesList>(entityName: "CDFavoritesList")
                if let fetchedFavorites: CDFavoritesList = try context.fetch(favoritesListFetchRequest).first {
                    favoritesList = fetchedFavorites
                } else {
                    print("removeFromFavorites: Could not find CDFavoritesList in container!")
                    favoritesList = CDFavoritesList(context: context)
                    print("removeFromFavorites: Created favorites list")
                }
                // retrieve object to be deleted
                guard let objectToDelete = favoritesList.getMovieFromFavorites(title: movie.title, year: movie.year) else {
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
                // update nav bar favorite button icon
                favoriteButton.image = UIImage(systemName: "star")
                return
            }
        }
    }
    
    // check if movie is in favorites list (blocking!)
    func checkFavoritesForMovie(movie: Movie) -> Bool{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("checkFavoritesForMovie: Error in getting appDelegate")
            return false
        }
        let context = appDelegate.persistentContainer.viewContext // get Core Data context
        let favoritesListFetchRequest = NSFetchRequest<CDFavoritesList>(entityName: "CDFavoritesList")
        // attempt to fetch favorites list
        do {
            var favoritesList: CDFavoritesList
            if let fetchedFavorites: CDFavoritesList = try context.fetch(favoritesListFetchRequest).first {
                favoritesList = fetchedFavorites
            } else {
                print("checkFavoritesForMovie: Could not find CDFavoritesList in container!")
                favoritesList = CDFavoritesList(context: context)
                print("checkFavoritesForMovie: Created favorites list")
            }
            // check if movie is in favorites list
            return favoritesList.containsMovie(title: movie.title, year: movie.year)
        } catch let error as NSError {
            print("checkFavoritesForMovie: Error fetching CDFavoritesList. \(error). \(error.userInfo).")
            return false
        }
    }
}
