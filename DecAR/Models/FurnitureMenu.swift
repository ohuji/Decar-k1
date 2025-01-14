//
//  FurnitureMenu.swift
//  DecAR
//
//  Created by iosdev on 19.11.2022.
//

import SwiftUI

//strores selected furniture
class SelectedFurniture: Codable {
    var modelName: String
    var id = UUID().uuidString
    
    init(_ modelName: String) {
        self.modelName = modelName
    }
}

//to store category
struct Category: Identifiable {
    let id = UUID()
    let categoryName: String
}

//ios 16+ version to remove list default background color
struct ClearListBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content.scrollContentBackground(.hidden)
        } else {
            content
        }
    }
}

//creates new modifier to clear list default background color
extension View {
    func clearListBackground() -> some View {
        modifier(ClearListBackgroundModifier())
    }
}

struct FurnitureMenu: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    @Binding var isPresented: Bool
    
    @State private var currentId = 0
    @State var currentObject: SelectedFurniture = SelectedFurniture("stool")
    
    let categorized = [Category(categoryName: "Beds"), Category(categoryName: "Carpets"), Category(categoryName: "Chairs"), Category(categoryName: "Couches"), Category(categoryName: "Desks"), Category(categoryName: "Flowers"), Category(categoryName: "Lamps"), Category(categoryName: "Mirrors"), Category(categoryName: "Paintings"), Category(categoryName: "Pianos"), Category(categoryName: "Plants"), Category(categoryName: "Sculptures"), Category(categoryName: "Sets"), Category(categoryName: "Shelves"), Category(categoryName: "Sofas"), Category(categoryName: "Stands"), Category(categoryName: "Stools"), Category(categoryName: "TV Stand"), Category(categoryName: "Tables"), Category(categoryName: "Tableset"), Category(categoryName: "Televisions"), Category(categoryName: "Vases"), Category(categoryName: "Wardrobes")]
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Furniture.furnitureName , ascending: true)],
        animation: .default)
    private var furnitures: FetchedResults<Furniture>
    
    var body: some View {
        //for ios15 and under to clear list default background color
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        
        return NavigationView {
            VStack(alignment: .leading) {
                Button(action: {
                    isPresented = false
                }) {
                    Image(systemName: "arrow.backward")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color("DetailColor"))
                    .frame(width: 32, height: 32)
                }
                .padding(.leading, 30)
                .padding(.top, 10)
                    List {
                        ForEach(categorized) { category in
                            Section(category.categoryName){
                                ForEach(furnitures) { furniture in
                                    if((category.categoryName)  == String?(furniture.category ?? "Chairs")!) {
                                        Button(furniture.furnitureName!, action: {
                                            currentObject = SelectedFurniture( furniture.modelName!)
                                            
                                            let appFurniture = UserDefaults.standard
                                            appFurniture.set(furniture.modelName, forKey: "AppCurrentObject")
                                            
                                            isPresented = false
                                        })
                                        .foregroundColor(.black)
                                    }
                                }
                                .listRowBackground(Color("SecondaryColor"))
                            }
                            .foregroundColor(Color("DetailColor"))
                        }
                    }
                    .clearListBackground()
            }
            .background(Color("PrimaryColor"))
            .listStyle(.sidebar)
            .edgesIgnoringSafeArea(.all)
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
        
    }
}
