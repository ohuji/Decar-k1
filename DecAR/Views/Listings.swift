//
//  Listings.swift
//  DecAR
//
//  Created by iosdev on 20.11.2022.
//

import Foundation
import SwiftUI
import CoreData

//Localization variables
let listingsClientName = NSLocalizedString("LISTINGS_CLIENT_NAME", comment: "listingsClientName")
let listingsClientAddress = NSLocalizedString("LISTINGS_CLIENT_ADDRESS", comment: "listingsClientAddress")
let listingsAddBtn = NSLocalizedString("LISTINGS_ADD_BTN", comment: "listingsAddBtn")
let listingsAlertAddListing = NSLocalizedString("LISTINGS_ALERT_ADD_LISTING", comment: "listingsAlertAddListing")
let listingsClientName2 = NSLocalizedString("LISTINGS_CLIENT_NAME_2", comment: "listingsClientName2")
let listingsClientAddress2 = NSLocalizedString("LISTINGS_CLIENT_ADDRESS_2", comment: "listingsClientAddress2")
let listingsBtnCancel = NSLocalizedString("LISTINGS_CANCEL_BTN", comment: "listingsBtnCancel")
let listingsDetails = NSLocalizedString("LISTINGS_DETAILS", comment: "listingsDetails")
let listingsSelectItem = NSLocalizedString("LISTINGS_SELECT_ITEM", comment: "listingsSelectItem")

struct ListingsView: View {
    @State private var presentAlert = false
    @State private var clientName: String = ""
    @State private var clientAddress: String = ""
    
    @Environment(\.managedObjectContext) private var viewContext

    //Get furniture
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Listing.clientName!, ascending: true)],
        animation: .default)
    private var listings: FetchedResults<Listing>
    
    //Use init to add background colors via UIKit for views
    init() {
        UINavigationBar.appearance().backgroundColor = UIColor(named: "PrimaryColor")
        UITableView.appearance().backgroundColor = UIColor(named: "PrimaryColor")
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(listings) { listing in
                    NavigationLink {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(listingsClientName) \(listing.clientName!)")
                                    .foregroundColor(Color.accentColor)
                                Text("\(listingsClientAddress) \(listing.clientAddress!)")
                                    .foregroundColor(Color.accentColor)
                                Spacer()
                            }
                            Spacer()
                        }
                        .background(Color("PrimaryColor"))
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                    } label: {
                        Text(listing.clientName!)
                    }
                }
                .onDelete(perform: deleteItems)
                .listRowBackground(Color("SecondaryColor"))
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                        Button(listingsAddBtn) {
                        presentAlert = true
                    }
                        .popover(isPresented: self.$presentAlert, arrowEdge: .bottom) {
                            VStack() {
                                Text(listingsAlertAddListing)
                                    .bold()
                                    .padding(.bottom, 100)
                                    .padding(.top, 100)
                                    .foregroundColor(Color.accentColor)
                                    .font(.system(size: 40))
                                Text(listingsClientName2)
                                    .foregroundColor(Color.accentColor)
                                    .padding(.leading, 10)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                TextField(listingsClientName2, text: $clientName)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding(10)
                                Text(listingsClientAddress2)
                                    .foregroundColor(Color.accentColor)
                                    .padding(.leading, 10)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                TextField(listingsClientAddress2, text: $clientAddress)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding(10)
                                    .padding(.bottom, 50)
                                
                                HStack() {
                                    Button(listingsAddBtn, action: {
                                        let newListing = Listing(context: viewContext)
                                        newListing.clientName = clientName
                                        newListing.clientAddress = clientAddress
                                        do {
                                            try viewContext.save()
                                            self.presentAlert = false
                                        } catch {
                                            let nsError = error as NSError
                                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                                        }
                                    })
                                    .padding(15)
                                    .background(Color.green)
                                    .foregroundColor(Color.white)
                                    .clipShape(Capsule())
                                    
                                    Button(listingsBtnCancel, action: {
                                        self.presentAlert = false
                                    })
                                    .padding(15)
                                    .background(Color.red)
                                    .foregroundColor(Color.white)
                                    .clipShape(Capsule())
                                }
                                Spacer()
                            }
                            .background(Color("PrimaryColor"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
            }
                     
            Text(listingsSelectItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { listings[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ListingsView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(currentObject: .constant(SelectedFurniture("stool"))).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
