//
//  GalleryView.swift
//  breathe-swiftui
//

import SwiftUI
import CoreData

struct GalleryView: View {
    
    class Theme {
        static func navigationBarColors(background : UIColor?,
                                        titleColor : UIColor? = nil, tintColor : UIColor? = nil ){
            let navigationAppearance = UINavigationBarAppearance()
            navigationAppearance.configureWithOpaqueBackground()
            navigationAppearance.backgroundColor =  UIColor(Color("gradientTopColor"))
            //            navigationAppearance.backgroundEffect = UIBlurEffect(style: .systemMaterial) // or dark
            navigationAppearance.shadowImage = UIImage()
            navigationAppearance.shadowColor = .clear
            
            navigationAppearance.titleTextAttributes = [.foregroundColor: titleColor ?? .black]
            navigationAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor ?? .black]
            
            UINavigationBar.appearance().standardAppearance = navigationAppearance
            UINavigationBar.appearance().compactAppearance = navigationAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationAppearance
            
            UINavigationBar.appearance().tintColor = tintColor ?? titleColor ?? .black
        }
    }
    
    init(){
        UITableView.appearance().backgroundColor = .clear
        Theme.navigationBarColors(background: UIColor(Color("gradientTopColor")), titleColor: .white)
    }
    
    let colorOptions = [Color.blue, Color.purple, Color.orange, Color.indigo, Color.mint]
    
    var body: some View {
        NavigationView {
            ZStack{
                BackgroundView().ignoresSafeArea()
                ScrollView{
                    VStack{
                        TitleSubtitle(
                            title: "Calming Routines",
                            subtitle: "Unwind, find your peace",
                            icon: "moon.stars.fill"
                        )
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(alignment: .top, spacing: 20){
                                RoutineCard(
                                    cardWidth: 200,
                                    routineTitle: "Calm Breathing",
                                    routineDescription: "a sixty second breath routine to start your day",
                                    routineTintColor: colorOptions.randomElement()!)
                                RoutineCard(
                                    cardWidth: 200,
                                    routineTitle: "Relaxing Breath",
                                    routineDescription: "a 4-7-8 breathing technique for relaxation",
                                    routineTintColor: colorOptions.randomElement()!)
                                RoutineCard(
                                    cardWidth: 200,
                                    routineTitle: "Relaxing Breath",
                                    routineDescription: "a 4-7-8 breathing technique for relaxation",
                                    routineTintColor: colorOptions.randomElement()!)
                                RoutineCard(
                                    cardWidth: 200,
                                    routineTitle: "Relaxing Breath",
                                    routineDescription: "a 4-7-8 breathing technique for relaxation",
                                    routineTintColor: colorOptions.randomElement()!)
                            }
                            .padding(.leading, 15)
                            .padding(.bottom, 20)
                            
                        }
                        TitleSubtitle(
                            title: "Energizing Breath",
                            subtitle: "Get your blood flowing with these routines",
                            icon: "flame.fill"
                        )
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(alignment: .top, spacing: 20){
                                RoutineCard(
                                    cardWidth: 200,
                                    routineTitle: "Calm Breathing",
                                    routineDescription: "a sixty second breath routine to start your day",
                                    routineTintColor: colorOptions.randomElement()!)
                                RoutineCard(
                                    cardWidth: 200,
                                    routineTitle: "Relaxing Breath",
                                    routineDescription: "a 4-7-8 breathing technique for relaxation",
                                    routineTintColor: colorOptions.randomElement()!)
                                RoutineCard(
                                    cardWidth: 200,
                                    routineTitle: "Relaxing Breath",
                                    routineDescription: "a 4-7-8 breathing technique for relaxation",
                                    routineTintColor: colorOptions.randomElement()!)
                                RoutineCard(
                                    cardWidth: 200,
                                    routineTitle: "Relaxing Breath",
                                    routineDescription: "a 4-7-8 breathing technique for relaxation",
                                    routineTintColor: colorOptions.randomElement()!)
                            }
                            .padding(.leading, 15)
                            .padding(.bottom, 20)
                        }
                        TitleSubtitle(
                            title: "Popular Routines",
                            subtitle: "Get your blood flowing with these routines",
                            icon: "star.fill"
                        )
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(alignment: .top, spacing: 20){
                                RoutineCard(
                                    cardWidth: 200,
                                    routineTitle: "Calm Breathing",
                                    routineDescription: "a sixty second breath routine to start your day",
                                    routineTintColor: colorOptions.randomElement()!)
                                RoutineCard(
                                    cardWidth: 200,
                                    routineTitle: "Relaxing Breath",
                                    routineDescription: "a 4-7-8 breathing technique for relaxation",
                                    routineTintColor: colorOptions.randomElement()!)
                                RoutineCard(
                                    cardWidth: 200,
                                    routineTitle: "Relaxing Breath",
                                    routineDescription: "a 4-7-8 breathing technique for relaxation",
                                    routineTintColor: colorOptions.randomElement()!)
                                RoutineCard(
                                    cardWidth: 200,
                                    routineTitle: "Relaxing Breath",
                                    routineDescription: "a 4-7-8 breathing technique for relaxation",
                                    routineTintColor: colorOptions.randomElement()!)
                            }
                            .padding(.leading, 15)
                        }
                    }.padding(.top,20)
                    
                    
                }
            }.navigationTitle("Find a new routine")
        }
    }
}

struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView()
            .preferredColorScheme(.dark)
    }
}

struct TitleSubtitle: View {
    
    var title: String
    var subtitle: String?
    var icon: String?
    
    var body: some View {
        Group{
            HStack{
                if (icon != nil){
                    Image(systemName: icon!)
                }
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.leading, 20)
            if (subtitle != nil){
                HStack{
                    Text(subtitle!)
                        .font(.callout)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .padding(.leading, 20)
                .padding(.top, -10)
            }
        }
    }
}
