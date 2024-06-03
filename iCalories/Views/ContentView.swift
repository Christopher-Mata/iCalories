//
//  ContentView.swift
//  iCalories
//
//  Created by Christopher Mata on 8/26/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    //TODO: add gradient background + date picker.
    
    // Env var
    @Environment(\.managedObjectContext) var managedObjContext
    
    // To get data from the DB
    // Will use a array of sort descriptors which will sort by date and will be reversed
    // and stored in a var
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var food:
        FetchedResults<Food>
    
    // State var
    @State private var showingAddView = false
    
    var body: some View {
        
        //Adds naviagtion Properties to this view
        NavigationView {
            
            //Header of the main menu
            VStack(alignment: .leading) {
                Text("\(Int(totalCaloriesToday())) kcal (Today)")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                
                //TODO: Add date picker code here +  UI elements aswell
                
                // Creating a list of every food item in DB
                List {
                    ForEach(food) { food in
                        NavigationLink(destination: EditFoodView(food: food)) {
                            HStack{
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(food.name!)
                                        .bold()
                                    
                                    Text("\(Int(food.calories))") + Text(" calories").foregroundColor(.red)
                                }
                                Spacer()
                                Text(calcTimeSince(date: food.date!))
                                    .foregroundColor(.gray)
                                    .italic()
                            }
                        }
                    }
                    .onDelete(perform: deleteFood)
                }
                .listStyle(.plain)
            }
            .navigationTitle("Coatlicue - Calories")
            
            // to add items to app and change Views
            .toolbar {
                
                // adds a toolbar
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddView.toggle()
                    } label: {
                        Label("Add Food", systemImage: "plus.circle")
                    }
                }
                
                // adds another toolbar to edit all the views at once
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAddView) {
                AddFoodView()
            }
        }
        
        // Ment for iPad due to it having a sidebar to make it not have one
        .navigationViewStyle(.stack)
    }
    
    // Func that deletes food
    private func deleteFood(offsets: IndexSet){
        withAnimation {
            offsets.map { food[$0] }.forEach(managedObjContext.delete)
            
            // Saves changes to DB
            DataController().save(context: managedObjContext)
        }
    }
    
    // Funct for calculationg total cals
    private func totalCaloriesToday() -> Double {
        var caloriesToday: Double = 0
        
        for item in food {
            if Calendar.current.isDateInToday(item.date!) {
                caloriesToday += item.calories
            }
        }
        
        return caloriesToday
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
