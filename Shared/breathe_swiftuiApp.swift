//
//  breathe_swiftuiApp.swift
//  Shared
//

import SwiftUI

@main
struct breathe_swiftuiApp: App {
    let persistenceController = PersistenceController.shared
    
    @Environment(\.managedObjectContext) private var viewContext
    
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Selection@*/.constant(1)/*@END_MENU_TOKEN@*/) {
                RoutinesView().tabItem {
                    Label("My Routines", systemImage: "heart.rectangle")
                    
                }.tag(1)
                GalleryView().tabItem {
                    Label("Gallery", systemImage: "rectangle.fill.on.rectangle.angled.fill").symbolRenderingMode(.hierarchical)
                }.tag(2)
            }
            
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
