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
    
    private func updateObject(){
        do{
            try viewContext.save()
        } catch {
            let nsError = error as NSError?
            print("Error in update Object \(nsError)")
        }
    }
    var body: some View {
        HStack{
            RoundedRectangle(cornerRadius: 3)
                .foregroundColor(.accentColor)
                .frame(width:10)

            Spacer()
            
            Toggle(isOn: $item.done) {
                VStack(alignment:.leading){
                    Text(item.name ?? "")
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.heavy)
                    Text(changeDateToString(item.time))
                }
            }
            .toggleStyle(CheckBoxStyle())
            .onChange(of: item.done) { newValue in
                updateObject()
            }
        }
        .foregroundColor(.accentColor)
    }
}

struct CheckBoxStyle:ToggleStyle{
    func makeBody(configuration: Configuration) -> some View {
        return
        HStack{
            configuration.label
            
            Spacer()
            
            Image(systemName: configuration.isOn ? "checkmark.circle.fill":"circle")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(.accentColor)
                .font(.system(size: 20, weight: .bold, design: .default))
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }

    }
}
