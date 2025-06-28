import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduledCall {
  final String calendlyEventUri;
  final String cancelUrl;
  final Timestamp createdAt;
  final String endTime;
  final String eventType;
  final String inviteeEmail;
  final String inviteeName;
  final String mentorUri;
  final String? noShow;
  final String? payment;
  final String? reconfirmation;
  final String rescheduleUrl;
  final bool rescheduled;
  final String startTime;
  final String status;
  final String timezone;

  ScheduledCall({
    required this.calendlyEventUri,
    required this.cancelUrl,
    required this.createdAt,
    required this.endTime,
    required this.eventType,
    required this.inviteeEmail,
    required this.inviteeName,
    required this.mentorUri,
    this.noShow,
    this.payment,
    this.reconfirmation,
    required this.rescheduleUrl,
    required this.rescheduled,
    required this.startTime,
    required this.status,
    required this.timezone,
  });

  factory ScheduledCall.fromFirestore(Map<String, dynamic> data) {
    return ScheduledCall(
      calendlyEventUri: data['calendlyEventUri'] as String,
      cancelUrl: data['cancel_url'] as String,
      createdAt: data['createdAt'] as Timestamp,
      endTime: data['endTime'] as String,
      eventType: data['eventType'] as String,
      inviteeEmail: data['inviteeEmail'] as String,
      inviteeName: data['inviteeName'] as String,
      mentorUri: data['mentorUri'] as String,
      noShow: data['no_show'] as String?,
      payment: data['payment'] as String?,
      reconfirmation: data['reconfirmation'] as String?,
      rescheduleUrl: data['reschedule_url'] as String,
      rescheduled: data['rescheduled'] as bool,
      startTime: data['startTime'] as String,
      status: data['status'] as String,
      timezone: data['timezone'] as String,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'calendlyEventUri': calendlyEventUri,
      'cancel_url': cancelUrl,
      'createdAt': createdAt,
      'endTime': endTime,
      'eventType': eventType,
      'inviteeEmail': inviteeEmail,
      'inviteeName': inviteeName,
      'mentorUri': mentorUri,
      'no_show': noShow,
      'payment': payment,
      'reconfirmation': reconfirmation,
      'reschedule_url': rescheduleUrl,
      'rescheduled': rescheduled,
      'startTime': startTime,
      'status': status,
      'timezone': timezone,
    };
  }
}
