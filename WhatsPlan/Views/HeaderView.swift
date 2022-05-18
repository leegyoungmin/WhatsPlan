//
//  HeaderView.swift
//  WhatsPlan
//
//  Created by 이경민 on 2022/05/17.
//

import SwiftUI

struct HeaderView: View {
    let userSelectedTab:BottomTab
    @Binding var isShowAddView:Bool
    @Binding var listEditMode:Bool
    var body: some View {
        HStack(alignment:.center,spacing:10){
            Text(userSelectedTab.rawValue)
                .font(.system(.largeTitle, design: .rounded))
                .fontWeight(.heavy)
                .padding(.leading,4)
                .foregroundColor(.accentColor)
            
            Spacer()
            
            if userSelectedTab == .today{
                
                Button {
                    withAnimation {
                        listEditMode.toggle()
                    }
                } label: {
                    Text(listEditMode ? "완료":"편집")
                }
                .environment(\.locale, Locale(identifier: "ko_KR"))
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(.accentColor)
                .padding(.horizontal,10)
                .padding(.vertical,3)
                .background(
                    Capsule()
                        .stroke(Color.accentColor,lineWidth: 2)
                )
                .padding(.trailing,10)
                
                Button {
                    withAnimation {
                        isShowAddView = true
                    }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .font(.system(.title, design: .rounded))
                }
            }
            
            
        }
        .padding()
        .foregroundColor(.accentColor)
        .background(Color.black)
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(userSelectedTab: .today, isShowAddView: .constant(false), listEditMode: .constant(false))
            .previewLayout(.sizeThatFits)
    }
}
