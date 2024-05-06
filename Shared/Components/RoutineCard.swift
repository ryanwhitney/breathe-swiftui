//
//  RoutineCard.swift
//  breathe-swiftui
//

import SwiftUI

struct RoutineCard: View {
    
    
    @Environment(\.managedObjectContext) var viewContext
    @State private var showingDeleteAlert = false
    
    @State var viewState = CGSize.zero
    @State var dragAmount = CGSize.zero
    @State var hasMoved = false
    @State var cardOpacity: Double = 1
    @State var buttonOpacity: Double = 0
    @State var buttonSize: Double = 0.5
    
    var cardWidth: CGFloat? = .infinity
    
    var routine: Routine?
    var routineTitle: String
    var routineDescription: String
    var routineTintColor: Color
    
    var body: some View {
        Group{
            VStack(alignment: .leading){
                Text(routineTitle)
                    .font(.title3)
                    .foregroundColor(routineTintColor)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth:.infinity, alignment: .leading)
                    .padding([.leading, .top, .trailing], 20)
                    .padding(.bottom, -3)
                    .fixedSize(horizontal: false, vertical: true)
                
                //                            .foregroundColor(.secondary)
                //                            .background(.ultraThinMaterial)
                Text(routineDescription)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .fontWeight(.regular)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth:.infinity, alignment: .leading)
                    .padding([.leading, .trailing, .bottom], 20)
                    .padding(.top, 0)
                
                    .fixedSize(horizontal: false, vertical: true)
                //                            .foregroundColor(.secondary)
                //                            .background(.ultraThinMaterial)
                
            }
        }
        .foregroundColor(.secondary)
        .frame(maxWidth: cardWidth, minHeight: 135, alignment: .top)
        .background(.thickMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous)
            .stroke(Color.clear, lineWidth: 1)
        )
        //                    .shadow(radius: 10)
        .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 10, x: 0, y: 5)
        .opacity(cardOpacity)
        
    }
    
    
}

struct RoutineCard_Previews: PreviewProvider {
    
    
    static var previews: some View {
        RoutineCard(
            routineTitle: "Calm Breathing",
            routineDescription: "a sixty second breath routine to start your day",
            routineTintColor: .purple)
    }
}
