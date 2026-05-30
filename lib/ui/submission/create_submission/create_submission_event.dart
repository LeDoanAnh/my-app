import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

abstract class SubmissionEvent {}

class SubmitCreateSubmission extends SubmissionEvent {
  final String title;
  final String description;
  final int workflowId;
  final int creatorId;
  final String startDate;
  final String endDate;
  final List<Map<String, dynamic>> selectedItems;
  final Map<String, TextEditingController> contentControllers;
  final List<PlatformFile> attachments;

  SubmitCreateSubmission({
    required this.title,
    required this.description,
    required this.workflowId,
    required this.creatorId,
    required this.startDate,
    required this.endDate,
    required this.selectedItems,
    required this.contentControllers,
    required this.attachments,
  });
}

class GetDepartmentList extends SubmissionEvent {}
