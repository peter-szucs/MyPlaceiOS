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
    @StateObject var viewModel: FilterViewModel
    @Binding var filters: MapFilters
    
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
                            FilterViewFriendCellView(viewModel: viewModel, user: friend, selectedUsers: $viewModel.filters.selectedFriends)
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
                            TagCell(selectedTags: $viewModel.filters.selectedTags, tag: tag)
                        }
                    }
                }.tag(1)
                
                VStack(alignment: .leading) {
                    SearchBarView(searchString: $viewModel.searchString)
                        .padding(.vertical, 4)
                    Text("Selected Country")
                        .font(.title3)
                        .padding(.horizontal, 8)
                        .padding(.top, 4)
                    HStack {
                        Text(viewModel.filters.selectedCountry.isEmpty ? "" : viewModel.countryFlag(countryCode: viewModel.filters.selectedCountry))
                            .padding(.leading, 16)
                            .padding([.vertical, .trailing], 8)
                        Text(viewModel.filters.selectedCountry.isEmpty ? "-" : NSLocale.getCountryName(from: viewModel.filters.selectedCountry))
                            .padding(.trailing, 16)
                            .padding(.vertical, 8)
                    }
                    .background(viewModel.filters.selectedCountry.isEmpty ? Color.clear : Color("TagSelected"))
                    .clipShape(Capsule())
                    .onTapGesture {
                        if !viewModel.filters.selectedCountry.isEmpty {
                            viewModel.filters.selectedCountry = ""
                        }
                    }
                    .padding(.horizontal)
                    Divider()
                    
                    List {
                        ForEach(NSLocale.locales().filter({ viewModel.searchString.isEmpty ? true : $0.countryName.contains(viewModel.searchString)}), id:\.countryCode) { locale in
                            FilterCountryCellView(selectedCountry: $viewModel.filters.selectedCountry, countryCode: locale.countryCode, countryName: locale.countryName, countryFlag: viewModel.countryFlag(countryCode: locale.countryCode))
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    viewModel.addOrRemoveCountryToFilter(countryCode: locale.countryCode)
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
                    
                    userInfo.currentMapFilters = viewModel.filters
                    filters = viewModel.filters
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
        FilterView(viewModel: FilterViewModel(filters: MapFilters(selectedFriends: [], selectedTags: [1,2], selectedCountry: "SE")), filters: .constant(MapFilters()))
    }
}
