//
//  MovieApp_SwiftUI_CombineApp.swift
//  MovieApp_SwiftUI+Combine
//
//  Created by Salman_Macbook on 24/02/25.
//

import SwiftUI

@main
struct MovieApp_SwiftUI_CombineApp: App {
    let persistenceController = DataController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView(httpClient: HTTPClient())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
