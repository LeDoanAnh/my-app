import 'dart:convert' show jsonEncode;

import 'package:my_app/domain/entities/create_submission_params.dart';
import 'package:my_app/domain/repositories/submission_repository.dart';

class CreateSubmissionUseCase {
  final SubmissionRepository _repository;

  CreateSubmissionUseCase(this._repository);

  Future<Map<String, dynamic>> call(CreateSubmissionParams params) async {
    // key → group data gửi lên server
    final Map<String, Map<String, dynamic>> groupMap = {};
    int priorityCounter = 1;
    for (final rawItem in params.selectedItems) {
      if (rawItem is! Map) continue;
      if (rawItem['item']?.toString() == 'Duyệt hệ thống') continue;

      final String itemType = rawItem['type']?.toString() ?? 'fixed_asset';
      final dynamic entityObj = rawItem['entity'];
      final int? entityId = _extractEntityId(entityObj);
      if (itemType == 'opinion') {
        final int deptId = rawItem['dept_id'] is int
            ? rawItem['dept_id'] as int
            : int.tryParse(rawItem['dept_id']?.toString() ?? '') ?? 0;
        final String deptName =
            rawItem['dept']?.toString() ?? 'Phòng ban chung';
        final int priority =
        rawItem['priority'] is int ? rawItem['priority'] as int : priorityCounter;
        final String assetKey = 'dept_$deptId';

        groupMap.putIfAbsent(assetKey, () {
          priorityCounter++;
          return {
            'dept_name': deptName,
            'dept_id': deptId,
            'note': params.contentControllers[assetKey]?.text.trim() ?? '',
            'priority': priority,
            'items': <Map<String, dynamic>>[],
            'opinion_only': true,
          };
        });

        final note =
            params.contentControllers[assetKey]?.text.trim() ?? '';
        if (note.isNotEmpty) groupMap[assetKey]!['note'] = note;

        continue;
      }

      // ── LOCATION ──────────────────────────────────────────────────────────
      if (itemType == 'location') {

        final String startTime =
            rawItem['start_time']?.toString() ?? params.startDate;
        final String endTime =
            rawItem['end_time']?.toString() ?? params.endDate;

        final String locKey = 'loc_${entityId ?? 'x${priorityCounter}'}';

        if (!groupMap.containsKey(locKey)) {
          groupMap[locKey] = {
            'dept_name': rawItem['dept']?.toString() ?? 'Địa điểm',
            'dept_id': 0,
            'note': '',
            'priority': rawItem['priority'] is int
                ? rawItem['priority'] as int
                : priorityCounter,
            'items': <Map<String, dynamic>>[],
          };
          priorityCounter++;
        }

        (groupMap[locKey]!['items'] as List<Map<String, dynamic>>).add({
          'type': 'location',
          'entity_id': entityId,
          'quantity': 1,
          'time_info': rawItem['time']?.toString() ?? '',
          'name': rawItem['item']?.toString() ?? '',
          'start_time': startTime,
          'end_time': endTime,
        });

        continue;
      }


          {
        final int deptId = rawItem['dept_id'] is int
            ? rawItem['dept_id'] as int
            : int.tryParse(rawItem['dept_id']?.toString() ?? '') ?? 0;
        final String deptName =
            rawItem['dept']?.toString() ?? 'Phòng ban chung';
        final int priority = rawItem['priority'] is int
            ? rawItem['priority'] as int
            : priorityCounter;
        final String assetKey = 'dept_$deptId';

        if (!groupMap.containsKey(assetKey)) {
          groupMap[assetKey] = {
            'dept_name': deptName,
            'dept_id': deptId,
            'note': params.contentControllers[assetKey]?.text.trim() ?? '',
            'priority': priority,
            'items': <Map<String, dynamic>>[],
          };
          priorityCounter++;
        } else {
          final String note =
              params.contentControllers[assetKey]?.text.trim() ?? '';
          if (note.isNotEmpty) groupMap[assetKey]!['note'] = note;
        }

        (groupMap[assetKey]!['items'] as List<Map<String, dynamic>>).add({
          'type': itemType,
          'entity_id': entityId,
          'quantity': int.tryParse(rawItem['qty']?.toString() ?? '1') ?? 1,
          'time_info': rawItem['time']?.toString() ?? '',
          'name': rawItem['item']?.toString() ?? '',
        });
      }
    }

    if (groupMap.isEmpty) {
      throw Exception('Vui lòng thêm ít nhất một phòng ban vào luồng duyệt.');
    }

    final String departmentsJson = jsonEncode(groupMap.values.toList());

    return await _repository.createSubmission(
      title: params.title,
      workflowId: 1,
      startDate: params.startDate,
      endDate: params.endDate,
      creatorId: params.creatorId,
      description: params.description,
      departmentsJson: departmentsJson,
      attachments: params.attachments,
    );
  }

  int? _extractEntityId(dynamic entity) {
    if (entity == null) return null;
    try {
      return (entity as dynamic).id as int?;
    } catch (_) {}
    try {
      return (entity as dynamic).locationId as int?;
    } catch (_) {}
    try {
      return (entity as dynamic).assetId as int?;
    } catch (_) {}
    return null;
  }
}