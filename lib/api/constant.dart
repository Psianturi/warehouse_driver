

class ApiConstants {

  //Dummy API
  static String baseUrl = 'http://192.168.22.23:9696/api/v1';
  // static String loginUser = '/users';
  // username: 'kminchelle',
  // password: '0lelplR',
  static String scanAssignDriver = '/driver/scan_assign_driver';
  static String updateLocation = '/driver/update_location_driver/1';  //PUT
  static String getLocation = '/driver/get_location_driver/1';  //GET
  // static String imageUrl = 'http://192.168.22.23:6565/api/v1/public/data_upload/product/';
  static String loginEndPoint = '/auth/login';
  static String getInfo = '/transaction/report/invoiced/quarry_id/1/06-21-2023/06-21-2023';

  static String logoutEndPoint = '/auth/logout';
  static String registerEndPoint = '/auth/register';
  static String showEndpoint = '64212264be98bb0f475f4f4f';
  // static String imageEndpoint = '/product/428b97b1-5c24-436b-b102-19cf29b2c7c71679384658.jpg';
  // static String listProductsEndPoint = '/product/';
  static String addToCartEndPoint = '/product/chart/daily?startDate=1990-01-01&endDate=2023-04-04' ;
}
