# Image Library Demo
 
A demo project to search and display images in list using flickr API. It has capability to download and cache the images.
 
## Requirements
- iOS 13.0+
- Xcode 12.0
 
 
## Structure Details
- Based on VIPER architecture explained as below
 
1. View - Responsibility of view is to send user actions to the presenter and show whatever the presenter asks it to.
2. Interactor - It has the business logic for the app specified by a use case.
3. Presenter - Contains the view logic for preparing content for display and for reacting to user interactions.
4. Entity - Basic model for objects used by interaction.
5. Router - Contains logic for routing of screens.
 
- Inside APIManager we are using WebServiceProtocol to call flickr API, which is being confirmed by HomeInteractor. 
- Inside ImageCache we have DownloadManager which is created with a singleton instance and a NSCache instance to cache the images that have been downloaded.
- Inherited the Operation class to DownloadOperation to implement the functionality as required.
- Implemented smart lazy loading for images in UICollectionView, which gets the 30 images in a single API call. Once It reached to the bottom it calls the next 30 images.
- Using NSCache to cache the downloaded images with their URL key. 
- Prioritise the downloading based on the visibility of cells.
 
First, we need to download the image and save that image with the URL key in NSCache. Next time, if the system tries to find out the same image with the URL key in the cache then no need to download it from the server. And we can use an existing one from cache.
 
 
## Scope of Improvement
We are using NSCache objects to temporarily store objects with transient data that are expensive to create. Reusing these objects can provide performance benefits, because their values do not have to be recalculated. However, the objects are not critical to the application and can be discarded if memory is tight. If discarded, their values will have to be recomputed again when needed.
 
To improve, we can create our own cache system as below
- using LRU (Least Recently Used) cache instead of NSCache 
- adding persistence
