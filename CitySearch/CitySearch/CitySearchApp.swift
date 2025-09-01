//
//  CitySearchApp.swift
//  CitySearch
//
//  Created by Damian Modernell on 31/8/25.
//

import SwiftUI
import CitySearchFeature

@main
struct CitySearchApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationView {
                CitySearchTab()
            }
            .tabItem {
                Image(systemName: "map")
                Text("Explore")
            }
            
            NavigationView {
                AnotherFeature()
            }
            .tabItem {
                Image(systemName: "gearshape")
                Text("Settings")
            }
        }
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.95)
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

struct CitySearchTab: View {
    var body: some View {
        Group {
            if let citySearchView = try? CitySearchComposer.compose() {
                AnyView(citySearchView)
            } else {
                AnyView(AppErrorView(message: "Failed to load city search"))
            }
        }
        .navigationTitle("City Explorer")
        .navigationBarTitleDisplayMode(.automatic)
    }
}

struct AnotherFeature: View {
    var body: some View {
        VStack {
            Text("")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            
            Spacer()
        }
        .navigationTitle("Another feature")
    }
}

struct AppErrorView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 60))
                .foregroundColor(.orange)
            
            Text("Error")
                .font(.title)
                .fontWeight(.semibold)
            
            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}
