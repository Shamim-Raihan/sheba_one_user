class ChargeModel {
  String? id;
  String? distance;
  String? charge;

  ChargeModel({this.id, this.distance, this.charge});

  ChargeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString() == 'null' ? '' : json['id'].toString();
    distance = json['distance'].toString() == 'null' ? '' : json['distance'].toString();
    charge = json['charge'].toString() == 'null' ? '' : json['charge'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['distance'] = distance;
    data['charge'] = charge;
    return data;
  }
}
