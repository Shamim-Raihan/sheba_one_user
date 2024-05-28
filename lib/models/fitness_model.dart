class FitnessModel {
  String? id;
  String? name;
  String? gender;
  List<String>? category;
  String? tradeNo;
  String? contactNo;
  String? email;
  String? wallet;
  String? withdrawBalance;
  String? gymFee;
  String? yogaFee;
  String? wellnessFee;
  String? address;
  String? city;
  String? area;
  String? image;
  String? refferalCode;
  String? adminApproval;
  String? imagePath;

  FitnessModel({
    this.id,
    this.name,
    this.gender,
    this.category,
    this.tradeNo,
    this.contactNo,
    this.email,
    this.wallet,
    this.withdrawBalance,
    this.gymFee,
    this.yogaFee,
    this.wellnessFee,
    this.address,
    this.city,
    this.area,
    this.image,
    this.refferalCode,
    this.adminApproval,
    this.imagePath,
  });

  FitnessModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
    gender = json['gender'];
    category = List<String>.from(json['category'].map((dynamic x) => x));
    tradeNo = json['trade_no'];
    contactNo = json['contact_no'];
    email = json['email'];
    wallet = json['wallet'].toString();
    withdrawBalance = json['withdraw_balance'].toString();
    gymFee = json['gym_fee'].toString();
    yogaFee = json['yoga_fee'].toString();
    wellnessFee = json['wellness_fee'].toString();
    address = json['address'];
    city = json['city'];
    area = json['area'].toString();
    image = json['image'];
    refferalCode = json['refferal_code'];
    adminApproval = json['admin_approval'];
    imagePath = json['image_path'];
  }
}