# Google Map API Client
Project to gather useful information from Google Map API.
It is easy for you to gather the nearest drink shop from you

## Resources
- [Maps](https://developers.google.com/maps/documentation/embed/get-started)
- [Directions](https://developers.google.com/maps/documentation/directions/overview)
- [Places](https://developers.google.com/places/web-service/overview)

## Elements
- Maps
- Directions
  - start location
  - end location
  - distance
  - duration
  - travel_mode
- Places
  - name
  - address
  - location
  - opening now
  - rating

## Entities
objects expected to use in the project:
- Map
- direction (ex: how to go and how long it will take to go to the direction)
- Shop (ex: shop name, location, and rating)

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
