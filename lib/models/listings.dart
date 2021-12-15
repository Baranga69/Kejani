class ListingData{
  final String name;
  final String address;
  final String amount;
  final String bedrooms;
  final String bathrooms;
  final String area;
  final String url;
  final String garage;
  final String description;
  final String listingId;
  final String listType;

  ListingData({
  required this.listingId,
  required this.name, 
  required this.listType, 
  required this.address, 
  required this.amount,
  required this.bedrooms, 
  required this.bathrooms, 
  required this.area,
  required this.url,
  required this.garage,
  required this.description});

}

//enum class for better filtering
enum ListingDets{ALL, PRICE, PRICE2, AREA, BEDROOMS, TYPE1, TYPE2}