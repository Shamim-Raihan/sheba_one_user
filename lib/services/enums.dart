///FOR MENU BAR
enum MenuItemEnum { home, services, prescription, orders, profile, none }

///FOR PAYMENT TYPE
enum PaymentMethod { cod, mobileBanking, online }

///FOR DOCTOR CATEGORY
enum DoctorByEnum { city, organ, speciality }

///FOR FITNESS CATEGORY
enum FitnessByEnum { city, category, gender }

///FOR DOCTOR CATEGORY GENERIC AND ONLINE
enum DoctorViewAll { generic, online }

///FOR FITNESS CATEGORY GENERIC AND ONLINE
enum FitnessViewAll { generic, online }

///FOR DOCTOR APPOINTMENT
enum AppointmentType { clinic, home, online }

///FOR DOCTOR APPOINTMENT
enum FitnessAppointmentType { gym, yoga, wellness }

///FOR DOCTOR ONLINE APPOINTMENT
enum OnlinePackageType { audio, video }

///FOR SSL SDK
enum SdkType { TESTBOX, LIVE }

///FOR ORDER
enum OrderType { healthcare, medicine, lab, doctor, fitness }

///FOR NORMAL SEARCH
enum SearchType { healthcare, medicine }

///FOR NORMAL SEARCH
enum ModuleSearch { none, healthcare, medicine, doctor, fitness, lab }

///FOR LIVE SEARCH
enum LiveSearchType { none, healthcare, medicine, prescription }

///FOR CART TYPE FOR NORMAL ORDER PLACE
enum CartType { none, healthcare, lab }

///FOR PRICE TYPE FOR Filter
enum PriceType { two_50, five_100, five_100Plus }

///FOR DOCTOR GENDER TYPE FOR Filter
enum DoctorGender { male, female }

///FOR FITNESS GENDER TYPE FOR Filter
enum FitnessGender { male, female, both }

///FOR Call status
enum CallStatus {
  none,
  accepted,
  incoming,
  running,
  ended,
}

///FOR Delivery status
enum DeliveryStatus {
  none,
  accepted,
  pickedUp,
  delivered,
  cancelled,
}
