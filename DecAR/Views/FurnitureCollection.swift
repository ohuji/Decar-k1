//
//  FurnitureCollection.swift
//  DecAR
//
//  Created by iosdev on 23.11.2022.
//

import Foundation
import SwiftUI
import CoreData

let furnitureName = NSLocalizedString("furnitureName", comment: "furnitureName")
let furnitureAlertAddFurniture = NSLocalizedString("furnitureAlertAddFurniture", comment: "furnitureAlertAddFurniture")
let furnitureFurnitureName = NSLocalizedString("furnitureFurnitureName", comment: "furnitureFurnitureName")
let furnitureEnterFurnitureDetails = NSLocalizedString("furnitureEnterFurnitureDetails", comment: "furnitureEnterFurnitureDetails")
let furnitureSelectItem = NSLocalizedString("furnitureSelectItem", comment: "furnitureSelectItem")
let furnitureAddBtn = NSLocalizedString("listingsAddBtn", comment: "listingsAddBtn")
let furnitureCancelBtn = NSLocalizedString("listingsBtnCancel", comment: "listingsAddBtn")





struct FurnitureCollectionView: View {
    @State private var presentAlert = false
    @State private var furnitureName: String = ""
    //@State private var furnitureCategory: String = ""
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Furniture.furnitureName , ascending: true)],
        animation: .default)
    private var furnitures: FetchedResults<Furniture>

    var body: some View {
        NavigationView {
            List {
                ForEach(furnitures) { furniture in
                    NavigationLink {
                        Text("\(furnitureName) \(furniture.furnitureName!)")
                    } label: {
                        Text(furniture.furnitureName!)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                        Button(furnitureAddBtn) {
                        presentAlert = true
                    }
                    .alert(furnitureAlertAddFurniture, isPresented: $presentAlert, actions: {
                        TextField(furnitureFurnitureName, text: $furnitureName)

                        Button(furnitureAddBtn, action: {
                            let newFurniture = Furniture(context: viewContext)
                            newFurniture.furnitureName = furnitureName
                            do {
                                try viewContext.save()
                            } catch {
                                let nsError = error as NSError
                                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                            }
                        })
                        Button(furnitureCancelBtn, role: .cancel, action: {})
                    }, message: {
                        Text(furnitureEnterFurnitureDetails)
                    })
                    }
            }
            Text(furnitureSelectItem)
        }
    }

    // For checking simulator data location
    //print("app folder path is \(NSHomeDirectory())")
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { furnitures[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct FurnitureCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}