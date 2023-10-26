//
//  CustomTableCell.swift
//  MovieSearchApp
//
//  Created by Louis Eric Di Gioia
//

import UIKit

class CustomTableCell: UITableViewCell {
    // properties
    static let ID = "CustomTableCell"
    // UI components
    var titleLabel = UILabel()
    var yearLabel = UILabel()
    var posterView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addAllSubviews()
        setupPosterView()
        setupTitleLabel()
        setupYearLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // to populate cell using API-fetched movie data
    func set(movie: Movie) {
        titleLabel.text = movie.title
        yearLabel.text = movie.year
        posterView.load(url: movie.poster) // async load poster image from URL
    }
    
    // to populate cell using Core Data movie basic info object
    func set(CDMovie: CDMovieBasicInfo) {
        titleLabel.text = CDMovie.titleUnwrapped
        yearLabel.text = CDMovie.yearUnwrapped
        posterView.load(url: CDMovie.posterURLUnwrapped)
    }
    
    func addAllSubviews() {
        self.addSubview(posterView)
        self.addSubview(titleLabel)
        self.addSubview(yearLabel)
    }
    
    func setupPosterView() {
        posterView.translatesAutoresizingMaskIntoConstraints = false
        posterView.contentMode = .scaleAspectFit
        posterView.backgroundColor = .secondaryLabel
        posterView.layer.borderWidth = 2
        posterView.layer.borderColor = UIColor.secondaryLabel.cgColor
        NSLayoutConstraint.activate([
            posterView.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            posterView.centerYAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.centerYAnchor),
            posterView.heightAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.heightAnchor),
            posterView.widthAnchor.constraint(equalTo: posterView.heightAnchor, multiplier: 2/3)
        ])
    }
    
    func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.sizeToFit()
        titleLabel.numberOfLines = 2
        titleLabel.adjustsFontSizeToFitWidth = true
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: posterView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: yearLabel.topAnchor)
        ])
    }
    
    func setupYearLabel() {
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        yearLabel.textColor = .secondaryLabel
        NSLayoutConstraint.activate([
            yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            yearLabel.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor),
            yearLabel.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor),
            yearLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.contentView.layoutMarginsGuide.bottomAnchor)
        ])
    }
    
}
