//
//  MapView.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-05.
//

import SwiftUI
import CoreLocation
import FirebaseAuth

struct MapView: View {
    
    @EnvironmentObject var userInfo: UserInfo
    @StateObject var viewModel = MapViewModel()
    @State var locationManager = CLLocationManager()
    
    var body: some View {
        
        ZStack {
            MapUIView(centerCoordinate: $viewModel.centerCoordinate, annotations: viewModel.annotations)
                .environmentObject(viewModel)
                .ignoresSafeArea(.all, edges: .all)
            
            
            Circle()
                .fill(Color.blue)
                .opacity(0.3)
                .frame(width: 26, height: 26)
            
            VStack {
                Spacer()
                VStack(alignment: .trailing) {
                    
                    Button(action: viewModel.focusLocation, label: {
                        Image(systemName: "location.fill")
                            .font(.title2)
                            .padding(10)
                            .background(Color.primary)
                            .clipShape(Circle())
                    })
                    
                    Button(action: viewModel.updateMapType, label: {
                        Image(systemName: viewModel.mapType == .standard ? "network" : "map")
                            .font(.title2)
                            .padding(10)
                            .background(Color.primary)
                            .clipShape(Circle())
                    })
                    
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()
                
                
                    HStack {
                        NavigationLink(
                            // MARK: TODO: Change to filter view
                            destination: MenuView(),
                            label: {
                                MapBottomMenuIcon(iconSystemName: "line.horizontal.3.decrease.circle", iconTitle: LocalizedStringKey("Map_filter_title"))
                            })
                        
                        Spacer()
                        
                        NavigationLink(
                            destination: MenuView(),
                            label: {
                                MapBottomMenuIcon(iconSystemName: "ellipsis.rectangle", iconTitle: LocalizedStringKey("Menu_title"))
                            })
                    }
                    .edgesIgnoringSafeArea(.bottom)
                    .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                    .padding(.bottom, 30)
                    .background(Color("BottomMapBackground"))
                    .cornerRadius(10)
                    .shadow(color: Color("BottomMapShadowBackground"), radius: 2, x: 0, y: -1)
                
                
            }
            VStack {
                Spacer()
                NavigationLink(
                    destination: AddPlaceView(place: viewModel.newPlace),
                    isActive: $viewModel.goToAddPlace,
                    label: {
                        
                    })
                Button(action: {
                    viewModel.addPlace(coordinate: viewModel.centerCoordinate)
                }, label: {
                    Image(systemName: "plus")
                        .font(.largeTitle)
                        .padding(25)
                        .background(Color("MainOrange"))
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(color: Color("AddPlaceButtonShadowColor"), radius: 2, y: 1)
                })
                .padding(.bottom, 40)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .background(Color.clear)
//        .onTapGesture(count: 2) {
//            print("!!! double tapped")
//        }
        .navigationBarHidden(viewModel.navBarHidden)
        .navigationBarTitle(LocalizedStringKey("Map_title"))
        
        .onAppear(perform: {
            locationManager.delegate = viewModel
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            userInfo.userLocation = viewModel.centerCoordinate
        })
        .onDisappear {
            viewModel.navBarHidden = false
            locationManager.stopUpdatingLocation()
        }
        .alert(isPresented: $viewModel.permissionDenied, content: {
            Alert(title: Text(LocalizedStringKey("CLPermissionDenied")), message: Text(LocalizedStringKey("CLPermDeniedMsg")), dismissButton: .default(Text(LocalizedStringKey("CLPermDeniedDismiss")), action: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
        })
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
