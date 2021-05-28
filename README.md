# MyPlaceiOS

Examination project.

Written in SwiftU


### Breakdown of structure
The Centralized type of State holder is called UserInfo and resides in the Repository folder.
In there most of the functions regarding the user and the app state in regard to the user.
It also contains listeners for new friendrequests as well as info about the users friends, preloading etc.

In the same folder the FirebaseRepository can be found which holds all functions regarding fetching from Firebase.

The Core folder contains all Model related files. As well as some reusable Views, static data and extensions.

The Cache system is inside the Models folder. There will be four different types of caches. The one being used in the app right now is within the Cache folder.
It's a LRU Cache that for now is used to hold profile images, but it can be used for any type of objects.

The Screens folder holds all Views and ViewModels for each screen, grouped by screen name.

Tests resides in the MyPlaceTests folder. Only Unit tests has been done so far in this project.

The app is localized for Swedish and English languages.

## App Images
![map](https://user-images.githubusercontent.com/55179291/119975944-c2e9fe00-bfb6-11eb-8f9c-7340636ac221.png)
![startscreen](https://user-images.githubusercontent.com/55179291/119976007-d1d0b080-bfb6-11eb-8460-d5afc161dcd7.png)
![addplace](https://user-images.githubusercontent.com/55179291/119975958-c7161b80-bfb6-11eb-8782-23884ba94644.png)
![menu](https://user-images.githubusercontent.com/55179291/119975966-c8474880-bfb6-11eb-8a5f-828d2c37ab9b.png)

Map screen, First startup screen, adding place, menu

![friendslist](https://user-images.githubusercontent.com/55179291/119975976-caa9a280-bfb6-11eb-87f0-19574d7b29ec.png)
![filters-friends](https://user-images.githubusercontent.com/55179291/119975981-cbdacf80-bfb6-11eb-8be5-64de02343c95.png)
![filters-tags](https://user-images.githubusercontent.com/55179291/119975986-cd0bfc80-bfb6-11eb-93a8-1e6848979a5c.png)
![filters-tags-selected](https://user-images.githubusercontent.com/55179291/119975991-ced5c000-bfb6-11eb-8c94-66a53dd2e16c.png)

friendslist, filters - friends, tags, selectedtags

![filters-country](https://user-images.githubusercontent.com/55179291/119976000-d006ed00-bfb6-11eb-8d52-0b5ef3f1455b.png)
![filtered-map](https://user-images.githubusercontent.com/55179291/119976014-d39a7400-bfb6-11eb-8e42-c6bfe025a302.png)

filters-country, filtered map with pins
