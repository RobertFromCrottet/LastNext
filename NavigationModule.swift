//
//  NavigationModule.swift
//  Horizon
//
//  Created by Robert on 28/03/2025.
//
//  ⛺️ Avec mon chum câblé, quelque part à l’ouest du Pecos

import Foundation
import SwiftUI
import SwiftData
import MapKit

func destinationView(
    for destination: Destination,
    path: Binding<NavigationPath>,
    allPoints: [MyPoint] = [],
    allUsers: [MyUser] = [],
    allDocuments: [MyDocument] = [],
    allHardwares: [MyHardware] = []
    
) -> AnyView {
    
    switch destination {

    // MARK: - Accueil & Navigation
    case .home:
        return AnyView(HomeView(path: path))

    case .navigation:
        return AnyView(myNavigationView(id: UUID(), path: path))

    // MARK: - Carte
    case .map(let id):
        return AnyView(MapView(id: id, path: path))
    
    case .mapAt(let id, let lat, let lon):
        let coord = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        return AnyView(MapView(id: id, path: path, fromPoint: true, initialCoordinate: coord))

    // MARK: - Réglages
    case .settings:
        return AnyView(SettingsView(id: UUID(), path: path))

    // MARK: - Points
   case .newPoint:
        return AnyView(AddPointView( path: path))
//        return AnyView(UsersDetailView(id: UUID(), path: path, user: user, goToNavigation: { Destination.navigation(id: UUID()) }))
        
        
    case .pointsList(let id):
        return AnyView(PointsListView(id: id, path: path))
        
    case .pointDetail(let id):
        if let point = allPoints.first(where: { $0.id == id }) {
            return AnyView(PointDetailView(id: UUID(), path: path, point: point))
        }else {
            return AnyView(
                VStack {
                    Text("point introuvable")
                        .foregroundColor(.red)
                    Text("ID recherché : \(id.uuidString)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            )
        }
    // MARK: - Utilisateurs
    case .newUser:
        return AnyView(AddUserView( path: path))
    case .userDetail(let id):
        print("🔎 destinationView → Recherche utilisateur avec id = \(id)")
        for user in allUsers {
            print("👤 Utilisateur : \(user.name) — id: \(user.id)")
        }

//        if let user = allUsers.first(where: { $0.id == id }) {
////            return AnyView(UsersDetailView(id: id, path: path, user: user, goToNavigation: Destination))
//            goToNavigation: { .navigation(id: $0) }
//        }
        if let user = allUsers.first(where: { $0.id == id }) {
            return AnyView(
                UsersDetailView(
                    id: id,
                    path: path,
                    user: user,
                    goToNavigation: { Destination.navigation(id: UUID()) } // 
                )
            )
        }
        else {
            return AnyView(
                VStack {
                    Text("Utilisateur introuvable")
                        .foregroundColor(.red)
                    Text("ID recherché : \(id.uuidString)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            )
        }
   case .usersList:
        return AnyView(UsersListView(id: UUID(), path: path))
        
        // MARK: - Hardware
    case .newHardware :
        return AnyView(AddHardwareView ( id: UUID(), path: path))

    case .hardwareList:
        return AnyView(HardwaresListView(id: UUID(), path: path))
        
    
    // MARK: - Documents / Scans
    case .scan:
        return AnyView(ScanDocumentView())

    case .scanGallery:
        return AnyView(ScanGalleryView())

    case .scanHome:
        return AnyView(ScanHomeView(path: path))

    case .ocr:
        return AnyView(OCRView())
        
        // MARK: - StreetView
    case .mapNav:
        return AnyView(MapNavigationView(id: UUID(), path: path))
        
    case .navigationStreet:
        return AnyView(NavigationStreetView())
        
   
        
    } //switch
    
} //anyview
