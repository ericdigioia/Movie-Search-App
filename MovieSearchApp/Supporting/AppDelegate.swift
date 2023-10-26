//
//  AppDelegate.swift
//  MovieSearchApp
//  Minimum iOS version: 13.0
//
//  Created by Louis Eric Di Gioia
//
//
//  Task: Movie Search App
//
//  Create a simple movie search app that allows users to search for movies and view their details. The app should meet the following requirements:
//
//  1. Use an API (such as OMDB) to fetch movie data.
//  2. Allow the user to search for movies by title.
//  3. Display a list of search results with the movie title, year, and poster image.
//  4. Allow the user to tap on a movie to view more details, such as the plot, director, cast, rating, and runtime.
//  5. Use Swift's Codable protocol to parse the JSON data returned by the API.
//  6. Implement error handling to handle any possible errors while fetching or parsing data.
//  7. Implement basic UI design and layout using Auto Layout constraints.

// Please follow these instructions for submitting your solution:
//
// 1. Create a GitHub Repository:
//    * Create a new public repository on GitHub to host your project.
// 2. Project Setup:
//    * Ensure that your project is in a clean and working state.
//    * Remove any derived data, build artifacts, or unnecessary files.
// 3. Code Quality:
//    * Ensure that your code follows standard coding conventions and best practices.
//    * Maintain clean code with meaningful variable and function names, comments, and appropriate separation of concerns.
//    * Apply modular design principles and consider code extensibility and reusability.
// 4. Push the Project to GitHub:
//    * Push your entire project to the created GitHub repository.
//    * Include the documentation, demo screenshots/videos, and any additional notes or instructions in the repository.
// 5. Optional Bonus:
//    * If you would like to go the extra mile, you can include unit tests or UI tests to demonstrate your testing abilities.
//    * Persist the list of favorites using any preferred persistence method (Realm, CoreData, etc.)
//    * Allow the user to add movies to a list of favorites.
// 6. Submission:
//    * Email us the link to your GitHub repository.
//    * Ensure that the repository is publicly accessible so that we can review your code and documentation.

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "MovieSearchApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

