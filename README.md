# DrinkKing
DrinkKing is an application that can easily **find** drink shops nearby based on what you want to drink

## Overview
We pop up this idea to make DrinkKing is beacuse we often want to get a **specific drink** (such as pineapple iced tea) or check whether there is any **promotion** event nearby, but find it hard to find on map.

By entering **keyword(Shop name, drink name, or drink category)** by the user, DrinkKing will find corresponding shops from database and pull places data from Google Map's Nearbysearch places API.Then, it will put the shops and details on the map by using Google Map's Map API.

When the user click on a shop on the map, it will show details of the shop such as address, menus, ratings and reviews, and recommended drinks based on reviews. Also, if there is any promotion of the drink shop from its Facebook Pages, it will list on the map too.

## Features
1. Find **shops** that serve **specific drink** nearby.
2. Check **promotions** posted on drink shop's facebook page
3. **Recommend** specific drink to user based on **reviews**

## Resources
- [Maps](https://developers.google.com/maps/documentation/embed/get-started)
- [Directions](https://developers.google.com/maps/documentation/directions/overview)
- [Places](https://developers.google.com/places/web-service/overview)

## Entities
- Map
- Shop
- Menu

## Database
We build two table in database,shops and reviews. Each shop contains many reviews
<br/>
The attributes of shops and reviews are:
- shops
  - id
  - placeid
  - name
  - address
  - latitude
  - longitude
  - phone_number
  - map_url
  - opening_now
  - rating
  - created_at
  - updated_at

- reviews
  - id
  - shop_id
  - shops
  - author
  - rating
  - relative_time
  - created_at
  - updated_at

![ERM](./assets/drink_king.png)
