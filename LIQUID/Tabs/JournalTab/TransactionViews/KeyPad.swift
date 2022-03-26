//
//  KeyPad.swift
//  LIQUID
//
//  Created by Alberto Dominguez Fernandez on 3/23/22.
//

import SwiftUI


struct KeyPad: View {
    @Binding var string: String
    
    var body: some View {
        VStack {
            KeyPadRow(keys: ["1", "2", "3"])
            KeyPadRow(keys: ["4", "5", "6"])
            KeyPadRow(keys: ["7", "8", "9"])
            KeyPadRow(keys: ["Clear", "0", "Delete"])
        }.environment(\.keyPadButtonAction, self.keyWasPressed(_:))
    }
    
    private func keyWasPressed(_ key: String) {
        switch key {
        case "Clear": string = ""
        case "Delete":
            string.removeLast()
            if string.isEmpty { string = "0" }
        case _ where string == "0": string = key
        default: string += key
        }
    }
}

struct KeyPadRow: View {
    var keys: [String]
    
    var body: some View {
        HStack {
            ForEach(keys, id: \.self) { key in
                KeyPadButton(key: key)
            }
        }
    }
}

struct KeyPadButton: View {
    var key: String
    
    var body: some View {
        Button(action: { self.action(self.key) }) {
            
            if (key == "Delete") {
                Image(systemName: "delete.left.fill")
                    .frame(width: UIScreen.main.bounds.size.width * 0.28, height: UIScreen.main.bounds.size.height * 0.07)
                    .background(Color.white.opacity(0.9))
                    .foregroundColor(Color.black)
            } else {
                Text(key)
                    .frame(width: UIScreen.main.bounds.size.width * 0.28, height: UIScreen.main.bounds.size.height * 0.07)
                    .background(Color.white.opacity(0.9))
                    .foregroundColor(Color.black)
            }
            
        }.frame(width: UIScreen.main.bounds.size.width * 0.28, height: UIScreen.main.bounds.size.height * 0.07)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    enum ActionKey: EnvironmentKey {
        static var defaultValue: (String) -> Void { { _ in } }
    }
    
    @Environment(\.keyPadButtonAction) var action: (String) -> Void
}

extension EnvironmentValues {
    var keyPadButtonAction: (String) -> Void {
        get { self[KeyPadButton.ActionKey.self] }
        set { self[KeyPadButton.ActionKey.self] = newValue }
    }
}

struct KeyPad_Previews: PreviewProvider {
    @State static var Key = "8"
    static var previews: some View {
        KeyPad(string: $Key)
    }
}
