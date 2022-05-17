//
//  TodayCellVieq.swift
//  WhatsPlan
//
//  Created by 이경민 on 2022/05/17.
//

import SwiftUI

struct TodayCellView: View {
    //MARK: - PROPERTIES
    @Environment(\.managedObjectContext) var viewContext
    @ObservedObject var item:Plan
    
    //MARK: - FUNCTIONS
    private func changeDateToString(_ date:Date?)->String{
        guard let date = date else {
            return ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM월 dd일"
        return dateFormatter.string(from: date)
    }
    var body: some View {
        HStack{
            RoundedRectangle(cornerRadius: 3)
                .foregroundColor(.white)
                .frame(width:10)
            Text(item.name ?? "")
            Spacer()
            Text(changeDateToString(item.time))
        }
        .foregroundColor(.white)
    }
}
