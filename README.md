# InfiniteScrollUITableViewFromAPI
### Infinitely scrolling UITableView using SeatGeek's API, created by Khalen Stensby

This application is a simple two view application that will consume SeatGeek's API
and in particular, the /events/ endpoint. 

### How to Open and Functionality
1.  Simply download the code here and open the project in xCode. 
1.  Select the appropriate phone version for the simulator (testing done with iPhone 11)
and press Play.
1.  Allow the application to access your location.
1.  User functionality includes:
  -  User can scroll through events nearby by scrolling down.
  -  User can open the details view of the event by clicking it.
  -  User can favorite the event inside of the details view.
  -  User can search events by name or type in the search bar.
  -  Search bar filters events live as the user is typing.
  -  User can scroll through filtered events as well by scrolling while a search filter applied.

### Testing
1.  With the application open, you have already given your location and loaded 10 events near you
2.  Open the first event and favorite it.
3.  Open the third event and favorite it.
4.  Filter events by typing the name of the first favorited event.
5.  Open the favorited event.
6.  Unfavorite the event.
7.  Scroll down to load more of the filtered event.
8.  Clear the search bar.
9.  Open the third favorited event.
10.  Unfavorite the event.
11.  Favorite the second event.
12.  Close and reopen the app to see that the second event is still favorited.
13.  All functionality tested.
