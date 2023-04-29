//
//  ContentView.swift
//  iCalories
//
//  Created by Hannah on 28/4/2023.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var foods: FetchedResults<Food>

//    @SectionedFetchRequest(
//        sectionIdentifier: \.date!,
//        sortDescriptors: [SortDescriptor(\.date, order: .reverse)],
//        animation: .default)
//    var foodsByDate: SectionedFetchResults<Date, Food>
    
    @State private var showingAddView = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("\(Int(totalCaloriesToday())) Kcal (Today)")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                List {
                    ForEach(foods) { food in
                        NavigationLink(destination: EditFoodView(food: food)) {
                            HStack {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(food.name!).bold()
                                    Text("\(Int(food.calories)) calories").foregroundColor(.red)
                                }
                                Spacer()
                                Text(calcTimeSince(date: food.date!)).foregroundColor(.gray).italic()
                            }
                        }
                    }
                    .onDelete(perform: deleteFood)
                }
//                .listStyle(GroupedListStyle())
            }
            .navigationTitle("iCalories")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddView.toggle()
                    } label: {
                        Label("Add Food", systemImage: "plus.circle")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAddView) {
                AddFoodView()
            }
        }
        .navigationViewStyle(.stack) // check this out
    }
    
    private func deleteFood(offsets: IndexSet) {
        withAnimation {
            offsets.map { foods[$0] }.forEach(managedObjContext.delete)
            DataController().save(context: managedObjContext)
        }
    }
    
    private func totalCaloriesToday() -> Double {
        var caloriesToday: Double = 0
        for food in foods {
            if Calendar.current.isDateInToday(food.date!) {
                caloriesToday += food.calories
            }
        }
        return caloriesToday
    }
    
    private func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/mm"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
