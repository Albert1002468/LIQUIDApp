//
//  AddNewCategory.swift
//  LIQUID
//
//  Created by Alberto Dominguez Fernandez on 3/12/22.
//

import SwiftUI

struct AddNewCategory: View {
    @Binding var CategoryArray: [String]
    @Environment(\.dismiss) private var dismiss
    @State var newItemName = ""
    var body: some View {
        
        Form {
            TextField("Enter category name", text: $newItemName)
            Button(action: {
                CategoryArray.append(newItemName)
                dismiss()
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add new category")
                }
            }.disabled(newItemName.isEmpty)
        }
       // .navigationTitle("Add new Item")
        //.navigationBarTitleDisplayMode(.inline)
    }
}

struct AddNewCategory_Previews: PreviewProvider {
    @State static var testingString = ["Direct Deposit", "Check"]
    static var previews: some View {
        AddNewCategory(CategoryArray: $testingString)
    }
}
