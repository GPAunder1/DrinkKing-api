# DrinkKing Web API
Web API that lists drink shops, get shop menu, and extracts recommend drink from reviews

## Routes
### Route check
`GET /`

### List shops
`GET /shops?keyword={keyword}`


### Store shops
`POST /shops/{keyword}`

### Extract shop
`GET /extractions/{shopid}`

### Get shop menu
`GET /menus?keyword={keyword}&searchby={shop/drink}`
