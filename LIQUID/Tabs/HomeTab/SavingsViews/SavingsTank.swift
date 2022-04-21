//
//  SavingsTank.swift
//  LIQUID
//
//  Created by Alberto Dominguez Fernandez on 4/10/22.
//

import SwiftUI

struct SavingsTank: View {
    @State var transactionData = TransactionModel()
    @State var savings: Savings
    var body: some View {
        VStack {
            if savings.active == false {
                Text("Completed on \(transactionData.formatDate(date: savings.date))")
            }
            Text ("")
                .padding()
                .frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height * 0.6)
                .background (
                    GeometryReader { geometry in
                        ZStack (alignment: .center) {
                            ZStack(alignment: .bottom) {
                                
                                RoundedRectangle(cornerRadius: 40)
                                    .fill(.white)
                                Rectangle()
                                    .foregroundColor(Color("TiffanyBlue"))
                                    .frame(width: geometry.size.width, height: geometry.size.height * savings.completed/savings.amount)
                            }
                            RoundedRectangle(cornerRadius: 40)
                                .stroke(Color.gray, lineWidth: 10)
                            if savings.active == true {
                            Text("\(String(format: "%.1f", savings.completed/savings.amount*100))%")
                            } else {
                                Text("Saved \(transactionData.formatCurrency(amount: savings.completed))")
                            }
                            
                        }
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: 40))
            
            Text(savings.desc)
        }
    }
}

struct SavingsTank_Previews: PreviewProvider {
    @State static var saving = Savings(amount: 200000.0, completed: 150000.0, desc: "Savings", date: Date.now, saving: 2.0, active: false, previousAmountAdded: 25.30)
    static var previews: some View {
        SavingsTank(savings: saving)
    }
}
