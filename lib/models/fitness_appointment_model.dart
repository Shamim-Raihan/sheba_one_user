class FitnessAppointmentModel {
  String? id;
  String? doctorInfoId;
  String? appointmentSlotId;
  String? patientName;
  String? patientPhone;
  String? patientAddress;
  String? city;
  String? userId;
  String? registerId;
  String? status;
  String? fees;
  String? paymentType;
  String? paymentTransactionId;
  String? bankTransactionId;
  String? appointmentType;
  String? onlineType;
  String? reportUpload;
  String? doctorPrescription;
  String? textPrescription;
  String? patientProblem;
  String? roomId;
  String? callDuration;
  String? callStatus;
  String? createdAt;
  String? updatedAt;
  List<AppointmentSlot>? appointmentSlot;

  FitnessAppointmentModel(
      {this.id,
      this.doctorInfoId,
      this.appointmentSlotId,
      this.patientName,
      this.patientPhone,
      this.patientAddress,
      this.city,
      this.userId,
      this.registerId,
      this.status,
      this.fees,
      this.paymentType,
      this.paymentTransactionId,
      this.bankTransactionId,
      this.appointmentType,
      this.onlineType,
      this.reportUpload,
      this.doctorPrescription,
      this.textPrescription,
      this.patientProblem,
      this.roomId,
      this.callDuration,
      this.callStatus,
      this.createdAt,
      this.updatedAt,
      this.appointmentSlot});

  FitnessAppointmentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString() == 'null' ? '' : json['id'].toString();
    doctorInfoId = json['doctor_info_id'].toString() == 'null' ? '' : json['doctor_info_id'].toString();
    appointmentSlotId = json['appointment_slot_id'].toString() == 'null' ? '' : json['appointment_slot_id'].toString();
    patientName = json['patient_name'].toString() == 'null' ? '' : json['patient_name'].toString();
    patientPhone = json['patient_phone'].toString() == 'null' ? '' : json['patient_phone'].toString();
    patientAddress = json['patient_address'].toString() == 'null' ? '' : json['patient_address'].toString();
    city = json['city'].toString() == 'null' ? '' : json['city'].toString();
    userId = json['user_id'].toString() == 'null' ? '' : json['user_id'].toString();
    registerId = json['register_id'].toString() == 'null' ? '' : json['register_id'].toString();
    status = json['status'].toString() == 'null' ? '' : json['status'].toString();
    fees = json['fees'].toString() == 'null' ? '' : json['fees'].toString();
    paymentType = json['payment_type'].toString() == 'null' ? '' : json['payment_type'].toString();
    paymentTransactionId =
        json['payment_transaction_id'].toString() == 'null' ? '' : json['payment_transaction_id'].toString();
    bankTransactionId = json['bank_transaction_id'].toString() == 'null' ? '' : json['bank_transaction_id'].toString();
    appointmentType = json['appointment_type'].toString() == 'null' ? '' : json['appointment_type'].toString();
    onlineType = json['online_type'].toString() == 'null' ? '' : json['online_type'].toString();
    reportUpload = json['report_upload'].toString() == 'null' ? '' : json['report_upload'].toString();
    doctorPrescription =
        json['doctor_prescription'].toString() == 'null' ? '[]' : json['doctor_prescription'].toString();
    textPrescription = json['text_prescription'].toString() == 'null' ? '' : json['text_prescription'].toString();
    patientProblem = json['patient_problem'].toString() == 'null' ? '' : json['patient_problem'].toString();
    roomId = json['room_id'].toString() == 'null' ? '' : json['room_id'].toString();
    callDuration = json['call_duration'].toString() == 'null' ? '' : json['call_duration'].toString();
    callStatus = json['call_status'].toString() == 'null' ? '' : json['call_status'].toString();
    createdAt = json['created_at'].toString() == 'null' ? '' : json['created_at'].toString();
    updatedAt = json['updated_at'].toString() == 'null' ? '' : json['updated_at'].toString();
    if (json['appointment_slot'] != null) {
      appointmentSlot = <AppointmentSlot>[];
      json['appointment_slot'].forEach((v) {
        appointmentSlot!.add(AppointmentSlot.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['doctor_info_id'] = doctorInfoId;
    data['appointment_slot_id'] = appointmentSlotId;
    data['patient_name'] = patientName;
    data['patient_phone'] = patientPhone;
    data['patient_address'] = patientAddress;
    data['city'] = city;
    data['user_id'] = userId;
    data['register_id'] = registerId;
    data['status'] = status;
    data['fees'] = fees;
    data['payment_type'] = paymentType;
    data['payment_transaction_id'] = paymentTransactionId;
    data['bank_transaction_id'] = bankTransactionId;
    data['appointment_type'] = appointmentType;
    data['online_type'] = onlineType;
    data['report_upload'] = reportUpload;
    data['doctor_prescription'] = doctorPrescription;
    data['text_prescription'] = textPrescription;
    data['patient_problem'] = patientProblem;
    data['room_id'] = roomId;
    data['call_duration'] = callDuration;
    data['call_status'] = callStatus;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (appointmentSlot != null) {
      data['appointment_slot'] = appointmentSlot!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AppointmentSlot {
  String? id;
  String? appointmentStart;
  String? appointmentEnd;
  String? appointmentPatientName;
  String? doctorInfoId;
  String? appointmentStatus;
  String? type;
  String? createdAt;
  String? updatedAt;

  AppointmentSlot(
      {this.id,
      this.appointmentStart,
      this.appointmentEnd,
      this.appointmentPatientName,
      this.doctorInfoId,
      this.appointmentStatus,
      this.type,
      this.createdAt,
      this.updatedAt});

  AppointmentSlot.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString() == 'null' ? '' : json['id'].toString();
    appointmentStart = json['appointment_start'].toString() == 'null' ? '' : json['appointment_start'].toString();
    appointmentEnd = json['appointment_end'].toString() == 'null' ? '' : json['appointment_end'].toString();
    appointmentPatientName =
        json['appointment_patient_name'].toString() == 'null' ? '' : json['appointment_patient_name'].toString();
    doctorInfoId = json['doctor_info_id'].toString() == 'null' ? '' : json['doctor_info_id'].toString();
    appointmentStatus = json['appointment_status'].toString() == 'null' ? '' : json['appointment_status'].toString();
    type = json['type'].toString() == 'null' ? '' : json['type'].toString();
    createdAt = json['created_at'].toString() == 'null' ? '' : json['created_at'].toString();
    updatedAt = json['updated_at'].toString() == 'null' ? '' : json['updated_at'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['appointment_start'] = appointmentStart;
    data['appointment_end'] = appointmentEnd;
    data['appointment_patient_name'] = appointmentPatientName;
    data['doctor_info_id'] = doctorInfoId;
    data['appointment_status'] = appointmentStatus;
    data['type'] = type;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
