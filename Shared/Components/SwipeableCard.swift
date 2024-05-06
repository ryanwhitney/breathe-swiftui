//
//  SwipeableCard.swift
//  breathe-swiftui
//

import SwiftUI

struct SwipeableCard: View {
    
    
    @Environment(\.managedObjectContext) var viewContext
    @State private var showingDeleteAlert = false
    
    @State var viewState = CGSize.zero
    @State var dragAmount = CGSize.zero
    @State var hasMoved = false
    @State var cardOpacity: Double = 1
    @State var buttonOpacity: Double = 0
    @State var buttonSize: Double = 0.5
    
    var routine: Routine?
    var routineTitle: String
    var routineDescription: String
    var routineTintColor: Color
    
    var body: some View {
        ZStack{
            HStack{
                Spacer()
                Button {
                    showingDeleteAlert = true
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(Color(.white))
                        .imageScale(.large)
                        .frame(width: 44, height: 44)
                }
                .frame(width: 44, height: 44, alignment: .trailing)
                .background(Color(red:0.8,green:0.2,blue:0.2))
                .cornerRadius(100)
                .padding(.trailing, 30)
                .opacity(buttonOpacity)
                .scaleEffect(buttonSize)
            }
            .confirmationDialog(
                Text("Are you sure you want to delete \(routineTitle)?"),
                isPresented: $showingDeleteAlert,
                titleVisibility: .visible
            ) {
                Button("Delete", role: .destructive) {
                    withAnimation {
                        deleteItem(routine: routine!)
                    }
                }
            }
            
            Group{
                VStack(alignment: .leading){
                    Text(routineTitle)
                        .font(.title)
                        .foregroundColor(routineTintColor)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth:.infinity, alignment: .leading)
                        .padding([.leading, .top, .trailing], 20)
                        .padding(.bottom, -3)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(routineDescription)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .fontWeight(.regular)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth:.infinity, alignment: .leading)
                        .padding([.leading, .trailing, .bottom], 20)
                        .padding(.top, 0)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity)
            .background(.thickMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.clear, lineWidth: 1)
            )
            .padding([.leading, .trailing], 20)
            //                    .shadow(radius: 10)
            .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 10, x: 0, y: 5)
            .opacity(cardOpacity)
            .offset(x: viewState.width)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if !hasMoved {
                            viewState = value.translation
                        } else{
                            viewState.width = value.translation.width-80
                        }
                        buttonSize = (viewState.width * -0.007)
                        buttonOpacity = (viewState.width * -0.01)
                        //convert viewState.width to a shrinking opacity percentage
                        cardOpacity = CGFloat((-1 - (viewState.width * 0.002)) * -1)
                    }
                    .onEnded { value in
                        withAnimation(.spring()) {
                            if viewState.width < -80{
                                viewState.width = -80
                                hasMoved = true
                                buttonSize = 1
                            } else {
                                viewState = .zero
                                hasMoved = false
                                cardOpacity = 1
                            }
                        }
                    }
            )
            
        }
    }
    
    private func deleteItem(routine: Routine) {
        withAnimation {
            viewContext.delete(routine)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                print("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
}

struct SwipeableCard_Previews: PreviewProvider {
    
    
    static var previews: some View {
        SwipeableCard(
            routineTitle: "Calm Breathing",
            routineDescription: "a sixty second breath routine to start your day",
            routineTintColor: .purple)
    }
}
