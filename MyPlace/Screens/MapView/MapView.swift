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
            MapUIView()
                .environmentObject(viewModel)
                .ignoresSafeArea(.all, edges: .top)
            
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
                    Text("Filter")
                        .padding(EdgeInsets(top: 20,
                                            leading: 30,
                                            bottom: 20,
                                            trailing: 10))
                    Spacer()
                    NavigationLink(
                        destination: MenuView(),
                        label: {
                            VStack(alignment: .center, spacing: 6) {
                                Image(systemName: "ellipsis.rectangle")
                                    .scaleEffect(2)
                                    .foregroundColor(.secondary)
                                Text(LocalizedStringKey("Menu_title"))
                                    .font(.footnote)
                            }
                            .padding(EdgeInsets(top: 20,
                                                leading: 0,
                                                bottom: 0,
                                                trailing: 30))
                            
                        })
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .ignoresSafeArea(.all, edges: .all)
                .background(Color("MainBW"))
            }
            VStack {
                Spacer()
                Button(action: {}, label: {
                    Image(systemName: "plus")
                        .font(.title)
                        .padding(25)
                        .background(Color("MainOrange"))
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(color: .gray, radius: 2, y: 1)
                })
            }
        }
        .navigationBarHidden(true)
        .navigationBarTitle(LocalizedStringKey("Map_title"))
        
        .onAppear(perform: {
            locationManager.delegate = viewModel
            locationManager.requestWhenInUseAuthorization()
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
