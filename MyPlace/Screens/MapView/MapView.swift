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
                .edgesIgnoringSafeArea(.all)
            
            Circle()
                .fill(Color.blue)
                .opacity(0.3)
                .frame(width: 26, height: 26)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                VStack(alignment: .trailing) {
                    
                    Button(action: viewModel.focusLocation, label: {
                        Image(systemName: "location.fill")
                            .font(.title2)
                            .padding(10)
                            .background(Color("MainDarkBlue"))
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    })
                    
                    Button(action: viewModel.updateMapType, label: {
                        Image(systemName: viewModel.mapType == .standard ? "network" : "map")
                            .font(.title2)
                            .padding(10)
                            .background(Color("MainDarkBlue"))
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    })
                    
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()
                
                
                HStack {
                    NavigationLink(
                        destination: FilterView(viewModel: FilterViewModel(filters: userInfo.currentMapFilters, cache: userInfo.lruFriendsImagesCache), filters: $viewModel.recievedFilters),
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
                .edgesIgnoringSafeArea(.all)
                .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                .padding(.bottom, 30)
                .background(Color("BottomMapBackground"))
                .cornerRadius(10)
                .shadow(color: Color("BottomMapShadowBackground"), radius: 2, x: 0, y: -1)
                
                
            }
            .edgesIgnoringSafeArea(.all)
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
            .edgesIgnoringSafeArea(.all)
            if !userInfo.monitor.isConnected {
                withAnimation {
                    VStack {
                        NetworkToast()
                        Spacer()
                    }.transition(.move(edge: .top)).animation(.spring())
                }
            }
        }
        .background(Color.clear)
        .navigationBarHidden(viewModel.navBarHidden)
        .onAppear(perform: {
            locationManager.delegate = viewModel
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            userInfo.userLocation = viewModel.centerCoordinate
//            viewModel.setupMapWithFilters(filters: userInfo.currentMapFilters)
            viewModel.friendsList = userInfo.friendsList
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
                locationManager.stopUpdatingLocation()
                print("DispatchQueue stopped updating Location")
            }
            print("!!! MapView onAppear")
        })
        .onDisappear {
            viewModel.navBarHidden = false
//            locationManager.stopUpdatingLocation()
        }
        .alert(isPresented: $viewModel.permissionDenied, content: {
            Alert(title: Text(LocalizedStringKey("CLPermissionDenied")), message: Text(LocalizedStringKey("CLPermDeniedMsg")), dismissButton: .default(Text(LocalizedStringKey("CLPermDeniedDismiss")), action: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
        })
    }
}

//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView()
//    }
//}
