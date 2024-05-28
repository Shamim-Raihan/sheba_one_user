import 'package:shebaone/services/enums.dart';

class AppointmentSlotModel {
  String? id;
  String? appointmentStart;
  String? appointmentEnd;
  String? appointmentPatientName;
  String? doctorInfoId;
  String? appointmentStatus;
  AppointmentType? type;
  String? createdAt;
  String? updatedAt;

  AppointmentSlotModel(
      {this.id,
      this.appointmentStart,
      this.appointmentEnd,
      this.appointmentPatientName,
      this.doctorInfoId,
      this.appointmentStatus,
      this.type,
      this.createdAt,
      this.updatedAt});

  AppointmentSlotModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    appointmentStart = json['appointment_start'];
    appointmentEnd = json['appointment_end'];
    appointmentPatientName =
        json['appointment_patient_name'].toString() == 'null'
            ? ''
            : json['appointment_patient_name'].toString();
    doctorInfoId = json['doctor_info_id'].toString();
    appointmentStatus = json['appointment_status'];
    type = json['type'].toString() == 'null'
        ? AppointmentType.clinic
        : json['type'].toString() == 'Regular'
            ? AppointmentType.clinic
            : AppointmentType.online;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['appointment_start'] = appointmentStart;
    data['appointment_end'] = appointmentEnd;
    data['appointment_patient_name'] = appointmentPatientName;
    data['doctor_info_id'] = doctorInfoId;
    data['appointment_status'] = appointmentStatus;
    data['type'] = type == AppointmentType.clinic ? 'Regular' : 'Online';
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class HomeAppointmentSlotModel {
  String? id;
  String? appointmentDate;
  String? appointmentTime;
  String? appointmentDay;
  String? appointmentStatus;
  String? doctorId;

  HomeAppointmentSlotModel(
      {this.id,
      this.appointmentDate,
      this.appointmentTime,
      this.appointmentDay,
      this.appointmentStatus,
      this.doctorId});

  HomeAppointmentSlotModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    appointmentDate = json['appointment_date'];
    appointmentTime = json['appointment_time'];
    appointmentDay = json['appointment_day'].toString() == 'null'
        ? ''
        : json['appointment_day'].toString();
    appointmentStatus = json['appointment_status'];
    doctorId = json['doctor_id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['appointment_date'] = appointmentDate;
    data['appointment_time'] = appointmentTime;
    data['appointment_day'] = appointmentDay;
    data['appointment_status'] = appointmentStatus;
    data['doctor_id'] = doctorId;
    return data;
  }
}

class GenericAppointmentSlotModel {
  String? date;
  String? day;
  String? dmy;
  String? fullDay;
  String? startTime;
  AppointmentType? type;
  String? slotId;
  String? doctorId;
  String? status;

  GenericAppointmentSlotModel(
      {this.date,
      this.day,
      this.dmy,
      this.fullDay,
      this.startTime,
      this.type,
      this.slotId,
      this.doctorId,
      this.status});

  GenericAppointmentSlotModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    day = json['day'];
    dmy = json['dmy'];
    fullDay = json['full_day'];
    startTime = json['start_time'];
    type = json['type'] == 'Regular'
        ? AppointmentType.clinic
        : json['type'] == 'Online'
            ? AppointmentType.online
            : AppointmentType.home;
    slotId = json['slot_id'];
    doctorId = json['doctor_id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['day'] = day;
    data['dmy'] = dmy;
    data['full_day'] = fullDay;
    data['start_time'] = startTime;
    data['type'] = type == AppointmentType.clinic
        ? 'Regular'
        : type == AppointmentType.online
            ? 'Online'
            : 'Home';
    data['slot_id'] = slotId;
    data['doctor_id'] = doctorId;
    data['status'] = status;
    return data;
  }
}
