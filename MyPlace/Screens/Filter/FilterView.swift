//
//  FilterView.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-20.
//

import SwiftUI

struct FilterView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var userInfo: UserInfo
    @StateObject private var viewModel = FilterViewModel()
    @GestureState private var isPressed = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                ForEach(viewModel.tabTitles.indices, id:\.self) { index in
                    Text(viewModel.tabTitles[index])
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: viewModel.equalWidth, height: 40)
                        .background(viewModel.tabSelection == index ? Color("MainDarkBlue") : Color("MainBlue"))
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation {
                                viewModel.tabSelection = index
                            }
                        }
                }
            }
            TabView(selection: $viewModel.tabSelection) {
                VStack {
                    List {
                        ForEach(userInfo.friendsList, id:\.info.uid) { friend in
                            FilterViewFriendCellView(user: friend, selectedUsers: $viewModel.friendsSelected)
                                .contentShape(Rectangle())
                                .gesture(TapGesture()
                                            .onEnded {
                                                print("tapped")
                                                viewModel.addFriendToFilter(friend: friend)
                                            }
                                )
                        }
                    }
                    .padding(.top)
                }.tag(0)
                
                VStack {
                    List {
                        ForEach(viewModel.tagsList, id:\.id) { tag in
                            TagCell(selectedTags: $viewModel.tagsSelected, tag: tag)
                        }
                    }
                }.tag(1)
                
                VStack {
                    SearchBarView(searchString: $viewModel.searchString)
                        .padding(.vertical, 4)
                    List {
                        ForEach(NSLocale.locales().filter({ viewModel.searchString.isEmpty ? true : $0.countryName.contains(viewModel.searchString)}), id:\.countryCode) { locale in
                            FilterCountryCellView(selectedCountries: $viewModel.countriesSelected, countryCode: locale.countryCode, countryName: locale.countryName, countryFlag: viewModel.countryFlag(countryCode: locale.countryCode))
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    self.viewModel.addCountryToFilter(countryCode: locale.countryCode)
                                }
                        }
                    }
                }.tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .hidden(viewModel.isLoading)
        }
        .navigationBarTitle(LocalizedStringKey("Map_filter_title"), displayMode: .inline)
        .toolbar(content: {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    // Dismiss, go to map and show pins after filter
                    
                    userInfo.currentMapFilters = MapFilters(selectedFriends: viewModel.friendsSelected, selectedTags: viewModel.tagsSelected, selectedCountries: viewModel.countriesSelected)
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text(LocalizedStringKey("Done"))
                })
                Button(action: {
                    // clear all filters
                    viewModel.clearAllFilters()
                }, label: {
                    Text(LocalizedStringKey("Clear"))
                })
                .disabled(viewModel.isAllFiltersEmpty())
            }
        })
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView()
    }
}
