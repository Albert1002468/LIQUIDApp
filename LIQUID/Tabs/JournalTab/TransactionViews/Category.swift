//
//  Category.swift
//  LIQUID
//
//  Created by Alberto Dominguez Fernandez on 3/11/22.
//

import SwiftUI

struct Category: View {
    @ObservedObject var transactionData: TransactionModel
    @State var typeIndex: Int
    @Binding var category: String
    @Environment(\.dismiss) private var dismiss
    @State var tempIncomeArray: [String] = []
    @State var tempExpenseArray:  [String] = []
    @State var openAddNewCategory = false
    var body: some View {
        List {
            if (typeIndex == 0) {
                ForEach(tempIncomeArray, id:\.self) { category in
                    HStack {
                        Text(category)
                        Spacer()
                        if (category == self.category) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                                .font(Font.system(size: 16, weight: .semibold))
                        }
                    }.onTapGesture {
                        self.category = category
                        updateCategory()
                        dismiss()
                    }
                    .deleteDisabled(tempIncomeArray.count == 1)
                }.onDelete(perform: removeRows)
                    .onMove(perform: onMove)
            } else {
                ForEach(tempExpenseArray, id:\.self) { category in
                    HStack {
                        Text(category)
                        Spacer()
                        if (category == self.category) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                                .font(Font.system(size: 16, weight: .semibold))
                        }
                    }.onTapGesture {
                        self.category = category
                        updateCategory()
                        dismiss()
                    }
                    .deleteDisabled(tempExpenseArray.count == 1)
                }.onDelete(perform: removeRows)
                    .onMove(perform: onMove)
                
            }
        }
        //.navigationBarBackButtonHidden(true)
        .onDisappear(perform:  {
            updateCategory()
        })
        .toolbar {
            /*   ToolbarItem(placement: .navigationBarLeading) {
             Button(action: {
             updateCategory()
             dismiss()
             }) {
             HStack (spacing: 5){
             Image(systemName: "chevron.left")
             Text("Back")
             }
             }.disabled(tempIncomeArray.count == 0 || tempExpenseArray.count == 0)
             }*/
            
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    self.openAddNewCategory.toggle()
                }) {
                    Image(systemName: "plus")
                }.disabled(tempExpenseArray.count == 8)
                    .sheet(isPresented: $openAddNewCategory, content: {
                        if (typeIndex == 0) {
                            AddNewCategory(CategoryArray: $tempIncomeArray)
                        } else {
                            AddNewCategory(CategoryArray: $tempExpenseArray)
                        }
                    } )
            }
        }
        .onAppear(perform: {
            tempIncomeArray = transactionData.categoryIncomeArray
            tempExpenseArray = transactionData.categoryExpenseArray
            
        })
    }
    
    func updateCategory() {
        transactionData.categoryIncomeArray = tempIncomeArray
        transactionData.categoryExpenseArray = tempExpenseArray
    }
    
    func removeRows(at offsets: IndexSet) {
        if (typeIndex == 0) {
            tempIncomeArray.remove(atOffsets: offsets)
        } else {
            tempExpenseArray.remove(atOffsets: offsets)
        }
    }
    
    func onMove(source: IndexSet, destination: Int) {
        if (typeIndex == 0) {
            tempIncomeArray.move(fromOffsets: source, toOffset: destination)
        } else {
            tempExpenseArray.move(fromOffsets: source, toOffset: destination)
        }
    }
}

struct Category_Previews: PreviewProvider {
    @State static var test = "Direct Deposit"
    static var previews: some View {
        NavigationView {
            Category(transactionData: TransactionModel(), typeIndex: 0, category: $test)
        }
    }
}
