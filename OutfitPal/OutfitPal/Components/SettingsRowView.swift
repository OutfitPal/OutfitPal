//
//  SettingsRowView.swift
//  OutfitPal
//
//  Created by Maxwell Kumbong on 1/2/25.
//

import SwiftUI

struct SettingsRowView: View {
    let imageName: String
    let tintColor: Color
    let title: String

    
    var body: some View {
        HStack{
            Image(systemName: imageName)
                .font(.title)
                .imageScale(.small)
                .foregroundColor(tintColor)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.black)
        }
    }
}

#Preview {
    SettingsRowView(imageName: "gear", tintColor: Color(.systemGray), title: "Version")
}
