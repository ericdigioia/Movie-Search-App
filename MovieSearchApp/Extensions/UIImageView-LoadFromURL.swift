//
//  UIImageView-LoadFromURL.swift
//  MovieSearchApp
//
//  Created by Louis Eric Di Gioia
//

import UIKit

// asynchronously load UIImageView contents from a URL (from HackingWithSwift)
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
