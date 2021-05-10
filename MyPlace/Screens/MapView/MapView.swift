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
                .ignoresSafeArea(.all, edges: .top)
            
            
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
                .frame(maxWidth: .infinity, alignment: .leading)
                .ignoresSafeArea(.all, edges: .all)
                .background(Color("MainBW"))
            }
            VStack {
                Spacer()
                NavigationLink(
                    destination: AddPlaceView(place: viewModel.newPlace),
                    isActive: $viewModel.goToAddPlace,
                    label: {
                        
                    })
                Button(action: {
//                    viewModel.convertCoordinateToAddress(location: viewModel.centerCoordinate)
//                    viewModel.addPlace(coordinate: viewModel.centerCoordinate)
                    viewModel.goToAddPlace = true
                }, label: {
                    Image(systemName: "plus")
                        .font(.largeTitle)
                        .padding(25)
                        .background(Color("MainOrange"))
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(color: Color("AddPlaceButtonShadowColor"), radius: 2, y: 1)
                })
                .padding(.bottom, 10)
            }
        }
//        .onTapGesture(count: 2) {
//            print("!!! double tapped")
//        }
        .navigationBarHidden(true)
        .navigationBarTitle(LocalizedStringKey("Map_title"))
        
        .onAppear(perform: {
            locationManager.delegate = viewModel
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        })
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
