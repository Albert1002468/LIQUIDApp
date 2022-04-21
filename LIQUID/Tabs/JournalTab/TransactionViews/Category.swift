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
            ForEach(typeIndex == 0 ? tempIncomeArray : tempExpenseArray, id:\.self) { category in
                HStack {
                    Text(category)
                    Spacer()
                    if (category == self.category) {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                            .font(Font.system(size: 16, weight: .semibold))
                    }
                }.contentShape(Rectangle())
                    .onTapGesture {
                        self.category = category
                        updateCategory()
                        dismiss()
                    }
                    .deleteDisabled((typeIndex == 0 && tempIncomeArray.count == 1) || (typeIndex == 1 && tempExpenseArray.count == 1))
            }.onDelete(perform: removeRows)
                .onMove(perform: onMove)
                .listRowBackground(Color.white.opacity(0.9))
        }
        .background(Image("Dark")
                        .resizable()
                       // .blur(radius: 10)
                       //.aspectRatio(contentMode: .fill)
                        .edgesIgnoringSafeArea(.all))
            .onDisappear(perform:  {
                updateCategory()
            }).toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.1)){
                            self.openAddNewCategory.toggle()
                        }
                    }) {
                        Image(systemName: "plus")
                    }.disabled(typeIndex == 1 && tempExpenseArray.count == 12)
                }
            }.onAppear(perform: {
                tempIncomeArray = transactionData.categoryIncomeArray
                tempExpenseArray = transactionData.categoryExpenseArray
            })
            .disabled(openAddNewCategory ? true : false)
            .addNewCategory(CategoryArray: typeIndex == 0 ? $tempIncomeArray : $tempExpenseArray, isShowing: $openAddNewCategory)
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
