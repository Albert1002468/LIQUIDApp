//
//  SavingsTank.swift
//  LIQUID
//
//  Created by Alberto Dominguez Fernandez on 4/10/22.
//

import SwiftUI

struct SavingsTank: View {
    @State var percentage: Double
    @State var name: String
    var body: some View {
        
            VStack {
                Text ("")
                    .padding()
                    .frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height * 0.6)
                    .background (
                        GeometryReader { geometry in
                            ZStack (alignment: .center){
                                ZStack(alignment: .bottom) {
                                    Rectangle()
                                        .foregroundColor(Color("TiffanyBlue"))
                                        .frame(width: geometry.size.width, height: geometry.size.height * percentage)
                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                                        .foregroundColor(.white)
                                }
                                Text("\(String(format: "%.1f", percentage*100))%")
                                
                            }
                        }
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 40))
                
                Text(name)
            }
    }
}

struct SavingsTank_Previews: PreviewProvider {
    static var previews: some View {
        SavingsTank(percentage: 0.2, name: "Rainy Day Funds")
    }
}
