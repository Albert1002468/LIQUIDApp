//
//  AddNewCategory.swift
//  LIQUID
//
//  Created by Alberto Dominguez Fernandez on 3/12/22.
//

import SwiftUI

struct AddNewCategory<Presenting>: View where Presenting: View {
    @Binding var CategoryArray: [String]
    @Binding var isShowing: Bool
    @State var newItemName = ""
    let presenting: Presenting
    
    var body: some View {
        GeometryReader { (geometry: GeometryProxy) in
            ZStack {
                self.presenting
                    .disabled(isShowing)
                VStack (spacing: 0){
                    Text("Add Category")
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.top)
                    
                    TextField("Enter category name", text: $newItemName)
                        .padding()
                    
                    Divider()
                    
                    HStack (spacing: 0) {
                        Button(action: {
                            withAnimation (.easeInOut(duration: 0.1)) {
                                CategoryArray.append(newItemName)
                                self.isShowing.toggle()
                                newItemName = ""
                        }
                        }) {
                            Text("Add").fixedSize()
                        }.disabled(newItemName.isEmpty)
                            .padding()
                            .frame(maxWidth: .infinity)
                        
                        Divider()
                        
                        Button(action: {
                            withAnimation (.easeInOut(duration: 0.1)) {
                                self.isShowing.toggle()
                            }
                        }) {
                            Text("Dismiss").fixedSize()
                        }.padding()
                            .frame(maxWidth: .infinity)
                    }.fixedSize(horizontal: false, vertical: true)
                }.background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .frame(width: geometry.size.width * 0.8)
                    .opacity(self.isShowing ? 1 : 0)
            }
        }
    }
}

extension View {
    func addNewCategory(CategoryArray: Binding<[String]>, isShowing: Binding<Bool>) -> some View {
        AddNewCategory(CategoryArray: CategoryArray, isShowing: isShowing, presenting: self)
    }
}
/*
struct AddNewCategory_Previews: PreviewProvider {
    @State static var test = "Direct Deposit"
    
    
    static var previews: some View {
        NavigationView {
        Category(transactionData: TransactionModel(), typeIndex: 0, category: $test)
        }
    }
}
*/
