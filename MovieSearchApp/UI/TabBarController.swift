//
//  TabBarController.swift
//  MovieSearchApp
//
//  Created by Louis Eric Di Gioia
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Create tab 1
        let searchScreenTab = UINavigationController(rootViewController: SearchScreenViewController())
        searchScreenTab.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass"))
        // Create tab 2
        let favoritesScreenTab = UINavigationController(rootViewController: FavoritesScreenViewController())
        favoritesScreenTab.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star"), selectedImage: UIImage(systemName: "star"))
        // Assign tabs to tab bar
        self.viewControllers = [searchScreenTab, favoritesScreenTab]
    }

}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        print("Selected tab \(viewController.title ?? "NO TITLE SET!")")
    }
}
