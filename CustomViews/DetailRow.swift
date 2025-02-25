//
//  DetailRow.swift
//  MovieApp_SwiftUI+Combine
//
//  Created by Salman_Macbook on 24/02/25.
//

import Foundation
import SwiftUI

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text("\(title):")
                .fontWeight(.semibold)
                .frame(width: 80, alignment: .leading)
            
            Text(value)
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .font(.body)
    }
}
