import 'package:shebaone/services/enums.dart';

class FitnessAppointmentSlotModel {
  String? id;
  String? appointmentStart;
  String? appointmentEnd;
  String? appointmentPatientName;
  String? doctorInfoId;
  String? appointmentStatus;
  FitnessAppointmentType? type;
  String? createdAt;
  String? updatedAt;

  FitnessAppointmentSlotModel(
      {this.id,
      this.appointmentStart,
      this.appointmentEnd,
      this.appointmentPatientName,
      this.doctorInfoId,
      this.appointmentStatus,
      this.type,
      this.createdAt,
      this.updatedAt});

  FitnessAppointmentSlotModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    appointmentStart = json['appointment_start'];
    appointmentEnd = json['appointment_end'];
    appointmentPatientName =
        json['appointment_patient_name'].toString() == 'null'
            ? ''
            : json['appointment_patient_name'].toString();
    doctorInfoId = json['fitness_info_id'].toString();
    appointmentStatus = json['appointment_status'];
    type = json['type'].toString() == 'Wellness'
        ? FitnessAppointmentType.wellness
        : json['type'].toString() == 'Yoga'
            ? FitnessAppointmentType.yoga
            : FitnessAppointmentType.gym;
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
    data['type'] = type == FitnessAppointmentType.wellness
        ? 'Wellness'
        : type == FitnessAppointmentType.yoga
            ? 'Yoga'
            : 'Gym';
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}


class GenericAppointmentSlotModel {
  String? date;
  String? day;
  String? dmy;
  String? fullDay;
  String? startTime;
  FitnessAppointmentType? type;
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
    type = json['type'].toString() == 'Wellness'
        ? FitnessAppointmentType.wellness
        : json['type'].toString() == 'Yoga'
        ? FitnessAppointmentType.yoga
        : FitnessAppointmentType.gym;
    slotId = json['slot_id'];
    doctorId = json['fitness_id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['day'] = day;
    data['dmy'] = dmy;
    data['full_day'] = fullDay;
    data['start_time'] = startTime;
    data['type'] = type == FitnessAppointmentType.wellness
        ? 'Wellness'
        : type == FitnessAppointmentType.yoga
        ? 'Yoga'
        : 'Gym';
    data['slot_id'] = slotId;
    data['fitness_id'] = doctorId;
    data['status'] = status;
    return data;
  }
}