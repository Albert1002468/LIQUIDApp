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
    @Binding var categoryIndex: Int
    @Environment(\.dismiss) private var dismiss
    @State var tempIncomeArray: [String] = []
    @State var tempExpenseArray:  [String] = []
    @State var openAddNewCategory = false
    var body: some View {
        ZStack {
            Color.blue
                .opacity(0.1)
                .ignoresSafeArea()
            List {
                if (typeIndex == 0) {
                    ForEach(0..<tempIncomeArray.count, id:\.self) { category in
                        HStack {
                            Text(tempIncomeArray[category])
                            Spacer()
                            if (category == self.categoryIndex) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                                    .font(Font.system(size: 16, weight: .semibold))
                            }
                        }.onTapGesture {
                            self.categoryIndex = category
                            updateCategory()
                            dismiss()
                        }
                    }.onDelete(perform: removeRows)
                        .onMove(perform: onMove)
                } else {
                    ForEach(0..<tempExpenseArray.count, id:\.self) { category in
                        HStack {
                            Text(tempExpenseArray[category])
                            Spacer()
                            if (category == self.categoryIndex) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                                    .font(Font.system(size: 16, weight: .semibold))
                            }
                        }.onTapGesture {
                            self.categoryIndex = category
                            updateCategory()
                            dismiss()
                        }
                    }.onDelete(perform: removeRows)
                        .onMove(perform: onMove)
                    
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        updateCategory()
                        dismiss()
                    }) {
                        HStack (spacing: 5){
                            Image(systemName: "chevron.left")
                                .font(Font.system(.body).bold())
                            Text("Back")
                        }
                    }.disabled(tempIncomeArray.count == 0 || tempExpenseArray.count == 0)
                }
                
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
    @State static var test = 0
    static var previews: some View {
        NavigationView {
            Category(transactionData: TransactionModel(), typeIndex: 0, categoryIndex: $test)
        }
    }
}
