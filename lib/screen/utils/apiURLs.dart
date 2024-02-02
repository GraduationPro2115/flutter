class ApiURLs {
  
  //BASE_URL will connect your admin panel with application. App Api calls will go through this url
  static const String BASE_URL = "";
  
  //AUTH_KEY will give your graded access to call and connect with admin panel. You will find AUTH_KEY from your purchase lincence file. 
  // "Item Purchase Code" from your purchase licence past here. Also add in your Admin Panel
  static const String AUTH_KEY = "";

  static const String PRIVACY_POLICY_URL = ""; // Replace your privecy policy url here
  static const String TERMS_CONDITIONS_URL = ""; // Replace your terms and condtion url here

 
    
  //API BASE
    static const String API_URL = "${BASE_URL}/index.php/api/";
  ///IMAGE LINK
  static const String IMAGE_URL_CATEGORY = "${BASE_URL}/uploads/admin/category/";
  static const String IMAGE_URL_BUSINESS = "${BASE_URL}/uploads/business/";
  static const String IMAGE_URL_PROFILE = "${BASE_URL}/uploads/profile/crop/small/";

  static const String RESPONSE = "responce";
  static const String DATA = "data";
  static const String ERROR = "error";


  static const String CATEGORY_LIST = "${API_URL}get_categories";
  static const String BUSINESS_LIST = "${API_URL}get_business";
  static const String BUSINESS_SERVICES = "${API_URL}get_services";
  static const String GET_DOCTORS = "${API_URL}get_doctors";
  static const String BUSINESS_PHOTOS = "${API_URL}get_photos";
  static const String BUSINESS_REVIEWS = "${API_URL}get_reviews";
  static const String ADD_BUSINESS_REVIEWS = "${API_URL}add_business_review";
  static const String LOGIN = "${API_URL}login";
  static const String REGISTER = "${API_URL}signup";
  static const String FORGOT_PASSWORD = "${API_URL}forgot_password";
  static const String CHANGE_PASSWORD = "${API_URL}change_password";
  static const String UPDATE_PROFILE = "${API_URL}update_profile";
  static const String TIME_SLOT = "${API_URL}get_time_slot";
  static const String USERDATA = "${API_URL}get_userdata";
  static const String MYAPPOINTMENT = "${API_URL}my_appointments";
  static const String BOOKAPPOINTMENT_URL = "${API_URL}add_appointment";
  static const String TEMP_BOOKAPPOINTMENT_URL = "${API_URL}add_appointment_temp";
  static const String GET_LOCALITY = "${API_URL}get_locality";
  static const String CANCELAPPOINTMENTS = "${API_URL}cancel_appointment";
  static const String RECOMMONDED = "${API_URL}get_recommonded";
  static const String UPLOAD_IMAGE = "${API_URL}update_profile_image";
  static const String REGISTER_FCM_URL = "${API_URL}register_fcm";

  
}
