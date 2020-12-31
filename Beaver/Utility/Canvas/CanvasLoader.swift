//
//  CanvasLoader.swift
//  Beaver
//
//  Created by Joel Clark on 12/28/20.
//  Copyright © 2020 MyCo. All rights reserved.
//

import Foundation
import Apollo
import CoreData
import SwiftUI

// A class to call Canvas' GraphQL API
// Right now, it'll call Umich's Canvas API, with my info, looking for classes in Fall 2018
class CanvasLoader: NSObject, ObservableObject {
    // MARK: - Properties
    @Published var courses = [CanvasCourse]()
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter
    }()
    
    lazy var apollo = ApolloClient(
        networkTransport: RequestChainNetworkTransport(
            interceptorProvider: LegacyInterceptorProvider(store: CanvasLoader.defaultStore),
            endpointURL: URL(string: CanvasLoader.baseURL)!,
            additionalHeaders: ["Authorization": "Bearer \(CanvasLoader.access_token)"],
            autoPersistQueries: false,
            requestBodyCreator: ApolloRequestBodyCreator(),
            useGETForQueries: false,
            useGETForPersistedQueryRetry: false),
        store: CanvasLoader.defaultStore
    )
    
    var storeFetchedResultsController: NSFetchedResultsController<CanvasCourse>!

    // MARK: Static
    static let access_token = "1770~VcWaBnny5ouhJ1LCcNo8g9dE69kyfAbg6rpD5LMAm0rLOPKeXgwMU8sDtfNGNGUZ"
    static let baseURL = "https://umich.instructure.com/api/graphql"
    static let todaysDate = Date()
    static let shared = CanvasLoader()
    static let defaultStore = ApolloStore()
    
    // MARK: - Methods
    func loadCourses(context: NSManagedObjectContext, completion: ( () -> Void )? = nil) {
        setupFetchController(context)
        
        // Call Canvas API
        CanvasLoader.shared.apollo.fetch(query: BeaverQueryQuery()) { result in
            switch result {
            case .success(let graphQLResult):
                if let courseResult = graphQLResult.data?.allCourses {
                    for course in courseResult {
                        self.processCourse(course, context: context)
                    }
                    self.loadCourseArray()
                }
                
                guard let completion = completion else { return }
                completion()
            case .failure(let err):
                print(err)
            }
        }
    }
    
    private func setupFetchController(_ context: NSManagedObjectContext) {
        // TODO: remove date setting in production
        let calendar = Calendar.current
        let dateComponents = DateComponents(calendar: calendar,
                                            year: 2018,
                                            month: 10,
                                            day: 10)

        let date = calendar.date(from: dateComponents)! // 2018-10-10

        let fetchRequest = CanvasCourse.activeClasses(date)
        
        self.storeFetchedResultsController = NSFetchedResultsController<CanvasCourse>.init(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        self.storeFetchedResultsController.delegate = self
    }
    
    private func loadCourseArray() {
        // Store List
        do {
            try self.storeFetchedResultsController.performFetch()
            self.courses = self.storeFetchedResultsController.fetchedObjects ?? []
        } catch { fatalError() }
    }
    
    private func processCourse(_ queryCourse: BeaverQueryQuery.Data.AllCourse, context: NSManagedObjectContext) {
        guard let startDate = queryCourse.term?.startAt,
              let endDate = queryCourse.term?.endAt else { return }
        
        let fetch = CanvasCourse.makeFetch(for: queryCourse.id)
        
        if let course = try? context.fetch(fetch), course.count == 1 {
            // TODO: Make sure assignments are up to date
        } else {
            let course = CanvasCourse(
                context: context,
                id: queryCourse.id,
                name: queryCourse.name,
                startDate: dateFormatter.date(from: startDate)!,
                endDate: dateFormatter.date(from: endDate)!
            )
            
            processAssignments(canvasCourse: course, queryCourse: queryCourse)
        }
    }
    
    private func processAssignments(canvasCourse: CanvasCourse, queryCourse: BeaverQueryQuery.Data.AllCourse) {
        guard let queryAssignments = queryCourse.assignmentsConnection?.nodes else {
            return
        }
        
        for assignment in queryAssignments {
            guard let assignment = assignment else { return }
            let toDo = CanvasAssignment(
                context: canvasCourse.managedObjectContext!,
                id: assignment.id,
                title: assignment.name!,
                dueDate: dateFormatter.date(from: assignment.dueAt ?? "")
            )
            
            canvasCourse.addToAssignments(toDo)
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension CanvasLoader: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async {
            self.loadCourseArray()
        }
    }
}
