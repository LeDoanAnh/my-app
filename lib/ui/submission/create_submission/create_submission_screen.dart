import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:my_app/core/theme/app_colors.dart';

import 'package:my_app/domain/entities/asset_entity.dart';
import 'package:my_app/domain/entities/location_entity.dart';
import 'package:my_app/domain/entities/department_entity.dart';
import 'package:my_app/ui/item_widget/app_confirmation_dialog.dart';

import 'package:my_app/ui/location_asset/location_asset_list/asset_location_list_bloc.dart';
import 'package:my_app/ui/location_asset/location_asset_list/asset_location_list_event.dart';
import 'package:my_app/ui/location_asset/location_asset_list/asset_location_list_state.dart';
import 'package:my_app/ui/submission/create_submission/create_submission_bloc.dart';
import 'package:my_app/ui/submission/create_submission/create_submission_event.dart';
import 'package:my_app/ui/submission/create_submission/create_submission_state.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Model nội bộ
// ─────────────────────────────────────────────────────────────────────────────
class _PickedAsset {
  final AssetEntity entity;
  String qty;
  DateTime dateGet;
  DateTime? dateReturn;
  String type;

  _PickedAsset({
    required this.entity,
    required this.qty,
    required this.dateGet,
    this.dateReturn,
    required this.type,
  });
}

class _PickedLocation {
  final LocationEntity entity;
  List<Map<String, dynamic>> slots;

  _PickedLocation({required this.entity, required this.slots});
}

class _DeptUIState {
  bool isExpanded;
  int activeTab; // 0 = vật tư, 1 = địa điểm
  bool includedInFlow;
  int stepOrder;
  final TextEditingController noteCtrl;
  // assetId → picked
  final Map<int, _PickedAsset> pickedAssets;
  // locationId → picked
  final Map<int, _PickedLocation> pickedLocations;

  _DeptUIState({
    this.isExpanded = false,
    this.activeTab = 0,
    this.includedInFlow = false,
    this.stepOrder = 0,
    required this.noteCtrl,
  })  : pickedAssets = {},
        pickedLocations = {};

  int get totalPicked => pickedAssets.length + pickedLocations.length;

  void dispose() => noteCtrl.dispose();
}

// ─────────────────────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────────────────────
class CreateSubmissionScreen extends StatefulWidget {
  final int? userId;
  const CreateSubmissionScreen({super.key, this.userId});

  @override
  State<CreateSubmissionScreen> createState() => _CreateSubmissionScreenState();
}

class _CreateSubmissionScreenState extends State<CreateSubmissionScreen> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _searchCtrl = TextEditingController();
  DateTimeRange? _programDateRange;
  final List<PlatformFile> _attachments = [];
  String _searchQuery = '';

  final Map<String, _DeptUIState> _deptStates = {};
  final Map<String, String> _deptNames = {};
  int _stepCounter = 0;

  // Cache danh sách departments từ SubmissionBloc để dùng khi build groups
  List<DepartmentEntity> _allDepts = [];

  @override
  void initState() {
    super.initState();
    // Lấy assets + locations
    context.read<AssetLocationListBloc>().add(GetAssetLocationList());
    // Lấy tất cả phòng ban
    context.read<SubmissionBloc>().add(GetDepartmentList());
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _searchCtrl.dispose();
    for (final s in _deptStates.values) s.dispose();
    super.dispose();
  }

  // ── Build groups: ALL departments luôn hiển thị ───────────────────────────
  List<_DeptGroup> _buildGroups(
      List<AssetEntity> assets,
      List<LocationEntity> locations,
      ) {
    final Map<String, _DeptGroup> map = {};

    // 1. Khởi tạo TẤT CẢ phòng ban trước (kể cả không có asset/location)
    for (final dept in _allDepts) {
      final key = 'dept_${dept.id}';
      map[key] = _DeptGroup(
        key: key,
        deptId: dept.id,
        name: dept.deptName ?? 'Phòng ban',
        assets: [],
        locations: [],
      );
    }

    // 2. Gắn assets vào đúng phòng
    for (final a in assets) {
      final key = 'dept_${a.department?.id ?? 0}';
      map.putIfAbsent(
        key,
            () => _DeptGroup(
          key: key,
          deptId: a.department?.id,
          name: a.department?.deptName ?? 'Phòng ban chung',
          assets: [],
          locations: [],
        ),
      );
      map[key]!.assets.add(a);
    }

    // 3. Gắn locations vào đúng phòng
    for (final l in locations) {
      final deptId = l.departmentId;
      final key = deptId != null ? 'dept_$deptId' : 'locations_only';
      map.putIfAbsent(
        key,
            () => _DeptGroup(
          key: key,
          deptId: deptId,
          name: l.department?.deptName ?? 'Địa điểm',
          assets: [],
          locations: [],
        ),
      );
      map[key]!.locations.add(l);
    }

    // 4. Đảm bảo mỗi group có _DeptUIState
    for (final g in map.values) {
      _deptStates.putIfAbsent(
        g.key,
            () => _DeptUIState(noteCtrl: TextEditingController()),
      );
      _deptNames[g.key] = g.name;
    }

    return map.values.toList()
      ..sort((a, b) => (a.deptId ?? 9999).compareTo(b.deptId ?? 9999));
  }

  // ── Toggle flow ──────────────────────────────────────────────────────────
  void _toggleFlow(String key) {
    final s = _deptStates[key]!;
    setState(() {
      if (s.includedInFlow) {
        final removedOrder = s.stepOrder;
        s.includedInFlow = false;
        s.stepOrder = 0;
        for (final other in _deptStates.values) {
          if (other.includedInFlow && other.stepOrder > removedOrder) {
            other.stepOrder--;
          }
        }
        _stepCounter--;
      } else {
        _stepCounter++;
        s.includedInFlow = true;
        s.stepOrder = _stepCounter;
      }
    });
  }

  void _autoInclude(String key) {
    if (!_deptStates[key]!.includedInFlow) _toggleFlow(key);
  }

  // ── Toggle asset: bỏ chọn nếu đã có, mở dialog nếu chưa ─────────────────
  void _toggleAsset(AssetEntity asset, String deptKey) {
    final s = _deptStates[deptKey]!;
    if (s.pickedAssets.containsKey(asset.id)) {
      setState(() => s.pickedAssets.remove(asset.id));
    } else {
      _showAssetDialog(asset, deptKey);
    }
  }

  // ── Toggle location ──────────────────────────────────────────────────────
  void _toggleLocation(LocationEntity loc, String deptKey) {
    final s = _deptStates[deptKey]!;
    if (s.pickedLocations.containsKey(loc.id)) {
      setState(() => s.pickedLocations.remove(loc.id));
    } else {
      _showLocationDialog(loc, deptKey);
    }
  }

  // ── Dialog chi tiết asset ────────────────────────────────────────────────
  void _showAssetDialog(AssetEntity asset, String deptKey) {
    final s = _deptStates[deptKey]!;
    final existing = s.pickedAssets[asset.id];
    final qtyCtrl = TextEditingController(text: existing?.qty ?? '1');
    final init = _programDateRange?.start ?? DateTime.now();
    DateTime dateGet = existing?.dateGet ?? init;
    DateTime dateReturn =
        existing?.dateReturn ?? (_programDateRange?.end ?? DateTime.now());
    final isConsumable = asset.unit == 'thùng' || asset.unit == 'chai';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSt) => AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Mượn ${asset.assetName}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: qtyCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: isConsumable
                      ? 'Số lượng (thùng/chai)'
                      : 'Số lượng (cái)',
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                    'Ngày lấy: ${DateFormat('dd/MM/yyyy').format(dateGet)}'),
                subtitle: const Text(
                  'Có thể lấy trước tờ trình 2 ngày',
                  style: TextStyle(fontSize: 10, color: Colors.orange),
                ),
                trailing: const Icon(Icons.calendar_today, size: 18),
                onTap: () async {
                  final first = init.subtract(const Duration(days: 2));
                  final d = await showDatePicker(
                    context: ctx,
                    initialDate: dateGet.isBefore(first) ? first : dateGet,
                    firstDate: first,
                    lastDate: DateTime(2030),
                  );
                  if (d != null) setSt(() => dateGet = d);
                },
              ),
              if (!isConsumable)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                      'Ngày trả: ${DateFormat('dd/MM/yyyy').format(dateReturn)}'),
                  subtitle: const Text(
                    'Cho phép trả muộn tối đa 2 ngày',
                    style: TextStyle(fontSize: 10, color: Colors.blueAccent),
                  ),
                  trailing: const Icon(Icons.history, size: 18),
                  onTap: () async {
                    final last = (_programDateRange?.end ?? DateTime.now())
                        .add(const Duration(days: 2));
                    final d = await showDatePicker(
                      context: ctx,
                      initialDate:
                      dateReturn.isAfter(last) ? last : dateReturn,
                      firstDate: dateGet,
                      lastDate: last,
                    );
                    if (d != null) setSt(() => dateReturn = d);
                  },
                ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Hủy')),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  s.pickedAssets[asset.id!] = _PickedAsset(
                    entity: asset,
                    qty: qtyCtrl.text,
                    dateGet: dateGet,
                    dateReturn: isConsumable ? null : dateReturn,
                    type: isConsumable ? 'consumable' : 'fixed_asset',
                  );
                  _autoInclude(deptKey);
                });
                Navigator.pop(ctx);
              },
              child: const Text('Xác nhận'),
            ),
          ],
        ),
      ),
    );
  }

  // ── Dialog chi tiết location ─────────────────────────────────────────────
  void _showLocationDialog(LocationEntity loc, String deptKey) {
    final s = _deptStates[deptKey]!;
    final existing = s.pickedLocations[loc.id];
    final List<Map<String, dynamic>> slots =
    existing?.slots.isNotEmpty == true
        ? List.from(
        existing!.slots.map((e) => Map<String, dynamic>.from(e)))
        : [
      {
        'date': _programDateRange?.start ?? DateTime.now(),
        'startTime': const TimeOfDay(hour: 17, minute: 0),
        'endTime': const TimeOfDay(hour: 21, minute: 0),
      }
    ];

    String fmtTime(TimeOfDay t) =>
        '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSt) => AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Lịch mượn ${loc.locationName}'),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...slots.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final slot = slots[idx];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  final d = await showDatePicker(
                                    context: ctx,
                                    initialDate: slot['date'],
                                    firstDate: DateTime.now()
                                        .subtract(const Duration(days: 1)),
                                    lastDate: DateTime(2030),
                                  );
                                  if (d != null) setSt(() => slot['date'] = d);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(children: [
                                    const Icon(Icons.calendar_today,
                                        size: 14, color: Colors.blueGrey),
                                    const SizedBox(width: 6),
                                    Text(
                                        DateFormat('dd/MM/yyyy')
                                            .format(slot['date']),
                                        style:
                                        const TextStyle(fontSize: 13)),
                                  ]),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: const Icon(Icons.remove_circle_outline,
                                  color: Colors.red, size: 20),
                              onPressed: slots.length > 1
                                  ? () => setSt(() => slots.removeAt(idx))
                                  : null,
                            ),
                          ]),
                          const SizedBox(height: 8),
                          Row(children: [
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  final t = await showTimePicker(
                                    context: ctx,
                                    initialTime:
                                    slot['startTime'] as TimeOfDay,
                                    builder: (context, child) => MediaQuery(
                                      data: MediaQuery.of(context).copyWith(
                                          alwaysUse24HourFormat: true),
                                      child: child!,
                                    ),
                                  );
                                  if (t != null)
                                    setSt(() => slot['startTime'] = t);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(children: [
                                    const Icon(Icons.access_time,
                                        size: 14, color: Colors.blueGrey),
                                    const SizedBox(width: 6),
                                    Text(
                                        fmtTime(slot['startTime']
                                        as TimeOfDay),
                                        style:
                                        const TextStyle(fontSize: 13)),
                                  ]),
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6),
                              child: Text('–',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.blueGrey)),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  final t = await showTimePicker(
                                    context: ctx,
                                    initialTime:
                                    slot['endTime'] as TimeOfDay,
                                    builder: (context, child) => MediaQuery(
                                      data: MediaQuery.of(context).copyWith(
                                          alwaysUse24HourFormat: true),
                                      child: child!,
                                    ),
                                  );
                                  if (t != null)
                                    setSt(() => slot['endTime'] = t);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(children: [
                                    const Icon(Icons.access_time_filled,
                                        size: 14, color: Colors.blueGrey),
                                    const SizedBox(width: 6),
                                    Text(
                                        fmtTime(
                                            slot['endTime'] as TimeOfDay),
                                        style:
                                        const TextStyle(fontSize: 13)),
                                  ]),
                                ),
                              ),
                            ),
                          ]),
                        ],
                      ),
                    );
                  }),
                  TextButton.icon(
                    onPressed: () => setSt(() => slots.add({
                      'date':
                      _programDateRange?.start ?? DateTime.now(),
                      'startTime': const TimeOfDay(hour: 17, minute: 0),
                      'endTime': const TimeOfDay(hour: 21, minute: 0),
                    })),
                    icon: const Icon(Icons.add),
                    label: const Text('Thêm ngày'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Hủy')),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  final formattedSlots = slots.map((sl) {
                    final d = sl['date'] as DateTime;
                    final st = sl['startTime'] as TimeOfDay;
                    final et = sl['endTime'] as TimeOfDay;
                    return {
                      'date': d,
                      'startTime': st,
                      'endTime': et,
                      'display':
                      '${DateFormat('dd/MM').format(d)} ${fmtTime(st)}–${fmtTime(et)}',
                    };
                  }).toList();
                  s.pickedLocations[loc.id!] = _PickedLocation(
                    entity: loc,
                    slots: formattedSlots,
                  );
                  _autoInclude(deptKey);
                });
                Navigator.pop(ctx);
              },
              child: const Text('Xác nhận'),
            ),
          ],
        ),
      ),
    );
  }

  // ── File picker ──────────────────────────────────────────────────────────
  Future<void> _pickFiles() async {
    final result = await FilePicker.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'xlsx', 'jpg', 'png'],
    );
    if (result != null) setState(() => _attachments.addAll(result.files));
  }

  // ── Submit ───────────────────────────────────────────────────────────────
  void _submit() {
    if (_titleCtrl.text.trim().isEmpty) {
      _snack('Vui lòng nhập tên tờ trình!');
      return;
    }
    if (_programDateRange == null) {
      _snack('Vui lòng chọn ngày diễn ra!');
      return;
    }
    final hasStep = _deptStates.values.any((s) => s.includedInFlow);
    if (!hasStep) {
      _snack('Vui lòng thêm ít nhất một phòng ban vào luồng duyệt!');
      return;
    }

    final List<Map<String, dynamic>> selectedItems = [];
    final Map<String, TextEditingController> contentControllers = {};

    for (final entry in _deptStates.entries) {
      final s = entry.value;
      if (!s.includedInFlow) continue;
      final key = entry.key;
      contentControllers[key] = s.noteCtrl;

      for (final picked in s.pickedAssets.values) {
        final asset = picked.entity;
        selectedItems.add({
          'dept': asset.department?.deptName ?? key,
          'dept_id': asset.department?.id,
          'item': asset.assetName,
          'qty': picked.qty,
          'time': picked.type == 'consumable'
              ? 'Lấy: ${DateFormat('dd/MM').format(picked.dateGet)}'
              : 'Lấy: ${DateFormat('dd/MM').format(picked.dateGet)} - Trả: ${DateFormat('dd/MM').format(picked.dateReturn!)}',
          'priority': s.stepOrder,
          'entity': asset,
          'type': picked.type,
        });
      }

      for (final picked in s.pickedLocations.values) {
        final loc = picked.entity;
        final timeStr =
        picked.slots.map((e) => e['display'] as String).join(', ');
        selectedItems.add({
          'dept': loc.locationName ?? key,
          'dept_id': null,
          'item': loc.locationName,
          'qty': '1',
          'time': timeStr,
          'priority': s.stepOrder,
          'entity': loc,
          'type': 'location',
        });
      }

      // Phòng chỉ xin ý kiến (không chọn gì)
      if (s.pickedAssets.isEmpty && s.pickedLocations.isEmpty) {
        selectedItems.add({
          'dept': _deptNames[key] ?? key,
          'dept_id': null,
          'item': 'Xin ý kiến',
          'qty': '0',
          'time': '',
          'priority': s.stepOrder,
          'entity': null,
          'type': 'opinion',
        });
      }
    }

    context.read<SubmissionBloc>().add(SubmitCreateSubmission(
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      workflowId: 0,
      creatorId: widget.userId ?? 1,
      startDate: DateFormat('yyyy-MM-dd HH:mm:ss')
          .format(_programDateRange!.start),
      endDate: DateFormat('yyyy-MM-dd HH:mm:ss')
          .format(_programDateRange!.end),
      selectedItems: selectedItems,
      contentControllers: contentControllers,
      attachments: _attachments,
    ));
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  // ── BUILD ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fieldBg,
      appBar: AppBar(
        title: const Text(
          'Soạn tờ trình',
          style: TextStyle(
              color: AppColors.textDark, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<SubmissionBloc, SubmissionState>(
            listener: (_, state) {
              if (state is SubmissionDeptLoaded) {
                setState(() => _allDepts = state.departments);
              } else if (state is SubmissionSubmitSuccess) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => AppConfirmationDialog(
                    icon: Icons.check_circle_rounded,
                    confirmColor: AppColors.success,
                    title: 'Tạo tờ trình thành công!',
                    content: state.message,
                    confirmText: 'Thoát',
                    cancelText: 'Tạo mới',
                    showCancel: true,
                    onConfirm: () {
                      // Thoát → quay về màn trước
                      if (context.mounted) Navigator.pop(context);
                    },
                    onCancel: () {
                      // Ở lại → reset toàn bộ form
                      _resetForm();
                    },
                  ),
                );
              } else if (state is SubmissionDeptError) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ));
              }
            },
          ),
          BlocListener<AssetLocationListBloc, AssetLocationListState>(
            listener: (_, state) {
              if (state is AssetLocationListError) _snack(state.message);
            },
          ),
        ],
        child: BlocBuilder<AssetLocationListBloc, AssetLocationListState>(
          builder: (context, assetState) {
            if (assetState is AssetLocationListLoading ||
                _allDepts.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            final groups = assetState is AssetLocationListLoaded
                ? _buildGroups(assetState.assets, assetState.locations)
                : _buildGroups([], []);

            final filtered = groups
                .where((g) =>
            _searchQuery.isEmpty ||
                g.name
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()))
                .toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── 1. Thông tin chung ────────────────────────────────
                  _sectionLabel('1', 'THÔNG TIN CHUNG'),
                  const SizedBox(height: 12),
                  _buildField(_titleCtrl, 'Tên tờ trình...'),
                  const SizedBox(height: 10),
                  _buildField(_descCtrl, 'Nội dung chi tiết tờ trình...',
                      maxLines: 4),
                  const SizedBox(height: 10),
                  _buildDatePicker(),
                  const SizedBox(height: 24),

                  // ── 2. Phòng ban phối hợp ─────────────────────────────
                  _sectionLabel('2', 'PHÒNG BAN PHỐI HỢP'),
                  const SizedBox(height: 12),
                  _buildDeptSearchBar(),
                  const SizedBox(height: 10),
                  ...filtered.map((g) => _buildDeptCard(g)),
                  const SizedBox(height: 24),

                  // ── 3. Các bước duyệt ─────────────────────────────────
                  _sectionLabel('3', 'CÁC BƯỚC DUYỆT'),
                  const SizedBox(height: 12),
                  _buildStepsSummary(),
                  const SizedBox(height: 24),

                  // ── 4. Tệp đính kèm ───────────────────────────────────
                  _sectionLabel('4', 'TỆP ĐÍNH KÈM'),
                  const SizedBox(height: 12),
                  _buildAttachments(),
                  const SizedBox(height: 24),

                  // ── Submit ────────────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text(
                        'GỬI TỜ TRÌNH',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ── Section label ─────────────────────────────────────────────────────────
  Widget _sectionLabel(String num, String title) => Row(children: [
    CircleAvatar(
      radius: 10,
      backgroundColor: AppColors.primary,
      child: Text(num,
          style: const TextStyle(color: Colors.white, fontSize: 10)),
    ),
    const SizedBox(width: 8),
    Text(title,
        style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: Colors.blueGrey,
            letterSpacing: 0.4)),
  ]);

  Widget _buildField(TextEditingController ctrl, String hint,
      {int maxLines = 1}) =>
      TextField(
        controller: ctrl,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(14),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none),
        ),
      );

  Widget _buildDatePicker() => InkWell(
    onTap: () async {
      final picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      );
      if (picked != null) setState(() => _programDateRange = picked);
    },
    borderRadius: BorderRadius.circular(14),
    child: Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14)),
      child: Row(children: [
        Icon(Icons.calendar_today, size: 16, color: AppColors.primary),
        const SizedBox(width: 10),
        Text(
          _programDateRange == null
              ? 'Ngày diễn ra chương trình'
              : '${DateFormat('dd/MM/yyyy').format(_programDateRange!.start)}  →  ${DateFormat('dd/MM/yyyy').format(_programDateRange!.end)}',
          style: TextStyle(
            fontSize: 13,
            color: _programDateRange == null
                ? Colors.grey
                : AppColors.textDark,
          ),
        ),
      ]),
    ),
  );

  Widget _buildDeptSearchBar() => TextField(
    controller: _searchCtrl,
    onChanged: (v) => setState(() => _searchQuery = v),
    decoration: InputDecoration(
      hintText: 'Tìm phòng ban phối hợp...',
      hintStyle: const TextStyle(fontSize: 13),
      prefixIcon: const Icon(Icons.search_rounded, size: 20),
      suffixIcon: _searchQuery.isNotEmpty
          ? IconButton(
        icon: const Icon(Icons.clear_rounded, size: 18),
        onPressed: () {
          _searchCtrl.clear();
          setState(() => _searchQuery = '');
        },
      )
          : null,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 12),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none),
    ),
  );

  // ── Accordion phòng ban ───────────────────────────────────────────────────
  Widget _buildDeptCard(_DeptGroup g) {
    final s = _deptStates[g.key]!;
    final hasAssets = g.assets.isNotEmpty;
    final hasLocs = g.locations.isNotEmpty;

    // Chỉ có tab Vật tư và Địa điểm — KHÔNG có tab Ý kiến
    final tabs = <_TabDef>[];
    if (hasAssets) tabs.add(_TabDef(icon: Icons.handyman_rounded, label: 'Vật tư'));
    if (hasLocs) tabs.add(_TabDef(icon: Icons.pin_drop_rounded, label: 'Địa điểm'));

    if (s.activeTab >= tabs.length && tabs.isNotEmpty) {
      s.activeTab = 0;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: s.includedInFlow
              ? AppColors.primary.withOpacity(0.6)
              : Colors.grey.shade200,
          width: s.includedInFlow ? 1.5 : 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────────────
          InkWell(
            onTap: () => setState(() => s.isExpanded = !s.isExpanded),
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 12),
              child: Row(children: [
                // Step badge
                if (s.includedInFlow)
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text('B${s.stepOrder}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(g.name,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Wrap(spacing: 4, children: [
                        if (hasAssets)
                          _chip(
                              'Vật tư',
                              Icons.handyman_rounded,
                              const Color(0xFF0F6E56),
                              const Color(0xFFE1F5EE)),
                        if (hasLocs)
                          _chip(
                              'Địa điểm',
                              Icons.pin_drop_rounded,
                              const Color(0xFF185FA5),
                              const Color(0xFFE6F1FB)),
                        // Nếu không có asset lẫn location → hiện chip "Xin ý kiến"
                        if (!hasAssets && !hasLocs)
                          _chip(
                              'Xin ý kiến',
                              Icons.chat_bubble_outline_rounded,
                              const Color(0xFF854F0B),
                              const Color(0xFFFAEEDA)),
                        if (s.totalPicked > 0)
                          _chip(
                              '${s.totalPicked} đã chọn',
                              Icons.check_circle_rounded,
                              const Color(0xFF27500A),
                              const Color(0xFFEAF3DE)),
                      ]),
                    ],
                  ),
                ),
                Icon(
                  s.isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey,
                ),
              ]),
            ),
          ),

          // ── Body (expanded) ──────────────────────────────────────────────
          if (s.isExpanded) ...[
            Divider(height: 1, color: Colors.grey.shade100),

            // Tab bar — chỉ hiện khi có ít nhất 1 tab (asset hoặc location)
            if (tabs.length >= 2)
              Container(
                color: Colors.grey.shade50,
                child: Row(
                  children: tabs.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final tab = entry.value;
                    final selected = s.activeTab == idx;
                    return Expanded(
                      child: InkWell(
                        onTap: () =>
                            setState(() => s.activeTab = idx),
                        child: Container(
                          padding:
                          const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: selected
                                    ? AppColors.primary
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(tab.icon,
                                  size: 14,
                                  color: selected
                                      ? AppColors.primary
                                      : Colors.grey),
                              const SizedBox(width: 4),
                              Text(tab.label,
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: selected
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                      color: selected
                                          ? AppColors.primary
                                          : Colors.grey)),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nội dung tab
                  if (tabs.isEmpty)
                  // Phòng ban chỉ có "xin ý kiến" — không có gì để chọn
                    _buildOpinionOnlyHint()
                  else if (tabs.length == 1)
                  // Chỉ có 1 loại → hiện thẳng không cần tab bar
                    tabs[0].label == 'Vật tư'
                        ? _buildAssetPane(g, s)
                        : _buildLocPane(g, s)
                  else
                  // Có cả 2 tab
                    s.activeTab == 0
                        ? _buildAssetPane(g, s)
                        : _buildLocPane(g, s),

                  const SizedBox(height: 10),
                  // Nút thêm/bỏ luồng duyệt
                  _buildFlowButton(g.key, s),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── Hint khi phòng chỉ xin ý kiến ────────────────────────────────────────
  Widget _buildOpinionOnlyHint() => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
    decoration: BoxDecoration(
      color: const Color(0xFFFAEEDA),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(children: [
      const Icon(Icons.chat_bubble_outline_rounded,
          size: 16, color: Color(0xFF854F0B)),
      const SizedBox(width: 8),
      const Expanded(
        child: Text(
          'Thêm phòng này vào luồng để xin ý kiến (không mượn vật tư hay địa điểm)',
          style: TextStyle(fontSize: 12, color: Color(0xFF854F0B)),
        ),
      ),
    ]),
  );

  // ── Pane vật tư — dùng checkbox trực tiếp ────────────────────────────────
  Widget _buildAssetPane(_DeptGroup g, _DeptUIState s) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: g.assets.length,
      separatorBuilder: (_, __) => const SizedBox(height: 6),
      itemBuilder: (_, i) {
        final asset = g.assets[i];
        final picked = s.pickedAssets[asset.id];
        final isPicked = picked != null;
        final isConsumable = asset.unit == 'thùng' || asset.unit == 'chai';

        return InkWell(
          onTap: () => _toggleAsset(asset, g.key),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: isPicked
                  ? const Color(0xFFEAF3DE)
                  : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isPicked
                    ? const Color(0xFF97C459)
                    : Colors.grey.shade200,
              ),
            ),
            child: Row(children: [
              // Checkbox
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: isPicked
                      ? const Color(0xFF3B6D11)
                      : Colors.white,
                  border: Border.all(
                    color: isPicked
                        ? const Color(0xFF3B6D11)
                        : Colors.grey.shade400,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: isPicked
                    ? const Icon(Icons.check_rounded,
                    size: 14, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 10),
              Icon(
                isConsumable
                    ? Icons.water_drop_rounded
                    : Icons.handyman_rounded,
                size: 15,
                color: isPicked
                    ? const Color(0xFF3B6D11)
                    : const Color(0xFF1D9E75),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      asset.assetName ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isPicked
                            ? const Color(0xFF27500A)
                            : AppColors.textDark,
                      ),
                    ),
                    // Hiện thông tin đã chọn (qty, ngày)
                    if (isPicked) ...[
                      const SizedBox(height: 2),
                      Text(
                        'SL: ${picked.qty}  •  Lấy: ${DateFormat('dd/MM').format(picked.dateGet)}'
                            '${picked.dateReturn != null ? '  •  Trả: ${DateFormat('dd/MM').format(picked.dateReturn!)}' : ''}',
                        style: const TextStyle(
                            fontSize: 10, color: Color(0xFF3B6D11)),
                      ),
                    ],
                  ],
                ),
              ),
              // Nút edit khi đã chọn
              if (isPicked)
                GestureDetector(
                  onTap: () => _showAssetDialog(asset, g.key),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    child: const Icon(Icons.edit_rounded,
                        size: 14, color: Color(0xFF3B6D11)),
                  ),
                ),
            ]),
          ),
        );
      },
    );
  }

  // ── Pane địa điểm — dùng checkbox trực tiếp ──────────────────────────────
  Widget _buildLocPane(_DeptGroup g, _DeptUIState s) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: g.locations.length,
      separatorBuilder: (_, __) => const SizedBox(height: 6),
      itemBuilder: (_, i) {
        final loc = g.locations[i];
        final picked = s.pickedLocations[loc.id];
        final isPicked = picked != null;

        return InkWell(
          onTap: () => _toggleLocation(loc, g.key),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: isPicked
                  ? const Color(0xFFE6F1FB)
                  : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isPicked
                    ? const Color(0xFF85B7EB)
                    : Colors.grey.shade200,
              ),
            ),
            child: Row(children: [
              // Checkbox
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: isPicked
                      ? const Color(0xFF185FA5)
                      : Colors.white,
                  border: Border.all(
                    color: isPicked
                        ? const Color(0xFF185FA5)
                        : Colors.grey.shade400,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: isPicked
                    ? const Icon(Icons.check_rounded,
                    size: 14, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 10),
              const Icon(Icons.pin_drop_rounded,
                  size: 15, color: Color(0xFF378ADD)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.locationName ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isPicked
                            ? const Color(0xFF0C447C)
                            : AppColors.textDark,
                      ),
                    ),
                    // Hiện danh sách slots
                    if (isPicked && picked.slots.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        picked.slots
                            .map((e) => e['display'] as String)
                            .join(' | '),
                        style: const TextStyle(
                            fontSize: 10, color: Color(0xFF185FA5)),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ],
                ),
              ),
              // Nút edit khi đã chọn
              if (isPicked)
                GestureDetector(
                  onTap: () => _showLocationDialog(loc, g.key),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    child: const Icon(Icons.edit_rounded,
                        size: 14, color: Color(0xFF185FA5)),
                  ),
                ),
            ]),
          ),
        );
      },
    );
  }

  // ── Nút thêm/bỏ luồng ────────────────────────────────────────────────────
  Widget _buildFlowButton(String key, _DeptUIState s) {
    if (s.includedInFlow) {
      return OutlinedButton.icon(
        onPressed: () => _toggleFlow(key),
        icon: const Icon(Icons.remove_circle_outline_rounded,
            size: 16, color: Colors.red),
        label: Text('Bỏ khỏi luồng duyệt (Bước ${s.stepOrder})',
            style: const TextStyle(fontSize: 12, color: Colors.red)),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.red),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(vertical: 8),
          minimumSize: const Size(double.infinity, 0),
        ),
      );
    }
    return OutlinedButton.icon(
      onPressed: () => _toggleFlow(key),
      icon: Icon(Icons.add_circle_outline_rounded,
          size: 16, color: AppColors.primary),
      label: const Text('Thêm vào luồng duyệt',
          style: TextStyle(fontSize: 12)),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: BorderSide(color: AppColors.primary.withOpacity(0.5)),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 8),
        minimumSize: const Size(double.infinity, 0),
      ),
    );
  }

  // ── Tóm tắt các bước duyệt ───────────────────────────────────────────────
  Widget _buildStepsSummary() {
    final steps = _deptStates.entries
        .where((e) => e.value.includedInFlow)
        .toList()
      ..sort((a, b) => a.value.stepOrder.compareTo(b.value.stepOrder));

    if (steps.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border:
          Border.all(color: Colors.grey.shade200),
        ),
        child: const Text(
          'Chưa có bước nào — hãy thêm phòng ban ở trên',
          style: TextStyle(fontSize: 12, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Column(
      children: steps.map((entry) {
        final s = entry.value;
        final realName = _deptNames[entry.key] ?? entry.key;
        final assetCount = s.pickedAssets.length;
        final locCount = s.pickedLocations.length;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                child: Row(children: [
                  CircleAvatar(
                    radius: 13,
                    backgroundColor:
                    AppColors.primary.withOpacity(0.12),
                    child: Text('${s.stepOrder}',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(realName,
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Wrap(spacing: 4, children: [
                          if (assetCount > 0)
                            _chip(
                                '$assetCount vật tư',
                                Icons.handyman_rounded,
                                const Color(0xFF0F6E56),
                                const Color(0xFFE1F5EE)),
                          if (locCount > 0)
                            _chip(
                                '$locCount địa điểm',
                                Icons.pin_drop_rounded,
                                const Color(0xFF185FA5),
                                const Color(0xFFE6F1FB)),
                          if (assetCount == 0 && locCount == 0)
                            _chip(
                                'Xin ý kiến',
                                Icons.chat_bubble_outline_rounded,
                                const Color(0xFF854F0B),
                                const Color(0xFFFAEEDA)),
                        ]),
                      ],
                    ),
                  ),
                ]),
              ),
              Padding(
                padding:
                const EdgeInsets.fromLTRB(14, 0, 14, 12),
                child: _buildNoteField(s, realName),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNoteField(_DeptUIState s, String deptName) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(children: [
        Icon(Icons.edit_note_rounded,
            size: 14, color: Colors.blueGrey.shade400),
        const SizedBox(width: 4),
        Text('Ghi chú gửi phòng này',
            style: TextStyle(
                fontSize: 11, color: Colors.blueGrey.shade400)),
      ]),
      const SizedBox(height: 6),
      TextField(
        controller: s.noteCtrl,
        maxLines: 3,
        decoration: InputDecoration(
          hintText: 'Nhập yêu cầu, lưu ý cụ thể cho $deptName...',
          hintStyle: const TextStyle(fontSize: 12),
          filled: true,
          fillColor: AppColors.fieldBg,
          contentPadding: const EdgeInsets.all(12),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
        ),
      ),
    ],
  );

  Widget _buildAttachments() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border:
      Border.all(color: AppColors.primary.withOpacity(0.2)),
    ),
    child: Column(children: [
      if (_attachments.isEmpty)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text('Chưa có tệp nào được chọn',
              style: TextStyle(
                  color: Colors.grey.shade500, fontSize: 13)),
        ),
      ..._attachments.map((file) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: AppColors.fieldBg,
            borderRadius: BorderRadius.circular(10)),
        child: Row(children: [
          Icon(Icons.insert_drive_file_rounded,
              size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(file.name,
                style: const TextStyle(fontSize: 12),
                overflow: TextOverflow.ellipsis),
          ),
          InkWell(
            onTap: () =>
                setState(() => _attachments.remove(file)),
            child: const Icon(Icons.cancel_rounded,
                size: 18, color: Colors.red),
          ),
        ]),
      )),
      TextButton.icon(
        onPressed: _pickFiles,
        icon: const Icon(Icons.attach_file_rounded, size: 16),
        label: const Text('Chọn tệp đính kèm',
            style: TextStyle(fontSize: 13)),
        style:
        TextButton.styleFrom(foregroundColor: AppColors.primary),
      ),
    ]),
  );

  Widget _chip(String label, IconData icon, Color fg, Color bg) =>
      Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
            color: bg, borderRadius: BorderRadius.circular(999)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 10, color: fg),
          const SizedBox(width: 3),
          Text(label,
              style: TextStyle(
                  fontSize: 10,
                  color: fg,
                  fontWeight: FontWeight.w500)),
        ]),
      );
  void _resetForm() {
    setState(() {
      _titleCtrl.clear();
      _descCtrl.clear();
      _searchCtrl.clear();
      _programDateRange = null;
      _attachments.clear();
      _searchQuery = '';
      _stepCounter = 0;

      // Reset toàn bộ dept states
      for (final s in _deptStates.values) {
        s.dispose();
      }
      _deptStates.clear();
      _deptNames.clear();

      // Rebuild lại dept states từ _allDepts (giữ nguyên danh sách phòng ban)
      // _buildGroups sẽ tự tạo lại khi rebuild widget
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Data classes
// ─────────────────────────────────────────────────────────────────────────────
class _DeptGroup {
  final String key;
  final int? deptId;
  final String name;
  final List<AssetEntity> assets;
  final List<LocationEntity> locations;

  _DeptGroup({
    required this.key,
    this.deptId,
    required this.name,
    required this.assets,
    required this.locations,
  });
}

class _TabDef {
  final IconData icon;
  final String label;
  _TabDef({required this.icon, required this.label});
}