import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/core/constant/colors.dart';
import 'package:untitled/core/service_locator.dart';
import 'package:untitled/core/utils/error_snackbar.dart';
import 'package:untitled/core/utils/success_snackbar.dart';
import 'package:untitled/features/finishing_companies/domin/entites/finishing_company_entity.dart';
import 'package:untitled/features/requests/domain/usecases/create_request_usecase.dart';
import 'package:untitled/features/requests/presentation/manager/create_request_cubit.dart';

class CreateRequestPage extends StatelessWidget {
  final int companyId;
  final List<FinishingWorkAreaEntity> workAreas;
  final List<FinishingServiceEntity> services;

  const CreateRequestPage({
    super.key,
    required this.companyId,
    this.workAreas = const [],
    this.services = const [],
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreateRequestCubit(getIt<CreateRequestUseCase>()),
      child: CreateRequestView(
        companyId: companyId,
        workAreas: workAreas,
        services: services,
      ),
    );
  }
}

class CreateRequestView extends StatefulWidget {
  final int companyId;
  final List<FinishingWorkAreaEntity> workAreas;
  final List<FinishingServiceEntity> services;

  const CreateRequestView({
    super.key,
    required this.companyId,
    required this.workAreas,
    required this.services,
  });

  @override
  State<CreateRequestView> createState() => _CreateRequestViewState();
}

class _CreateRequestViewState extends State<CreateRequestView> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _areaController = TextEditingController();
  final _roomsController = TextEditingController();
  final _floorController = TextEditingController();
  final _locationController = TextEditingController();
  String? _serviceType;
  int? _locationId;

  @override
  void initState() {
    super.initState();
    _serviceType = widget.services.isNotEmpty
        ? widget.services.first.serviceType
        : null;
    _locationId = widget.workAreas.isNotEmpty
        ? widget.workAreas.first.locationId
        : null;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _areaController.dispose();
    _roomsController.dispose();
    _floorController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false) || _serviceType == null) {
      return;
    }
    final locationId = _locationId ?? int.tryParse(_locationController.text);
    if (locationId == null) return;
    context.read<CreateRequestCubit>().createRequest({
      'company_id': widget.companyId,
      'location_id': locationId,
      'service_type': _serviceType,
      'description': _descriptionController.text.trim(),
      'area': _areaController.text.trim(),
      'rooms': int.parse(_roomsController.text.trim()),
      'floor': int.parse(_floorController.text.trim()),
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateRequestCubit, CreateRequestState>(
      listener: (context, state) {
        if (state is CreateRequestFailure) {
          showErrorSnackBar(context, state.message);
        } else if (state is CreateRequestSuccess) {
          showSuccessSnackBar(context, 'تم إرسال طلب الخدمة بنجاح');
          Navigator.of(context).pop(state.request);
        }
      },
      builder: (context, state) {
        final loading = state is CreateRequestLoading;
        return Scaffold(
          appBar: AppBar(title: const Text('طلب خدمة')),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                if (widget.services.isNotEmpty)
                  DropdownButtonFormField<String>(
                    value: _serviceType,
                    decoration: const InputDecoration(labelText: 'نوع الخدمة'),
                    items: widget.services
                        .map(
                          (service) => DropdownMenuItem(
                            value: service.serviceType,
                            child: Text(service.serviceType),
                          ),
                        )
                        .toList(),
                    onChanged: loading
                        ? null
                        : (value) => setState(() => _serviceType = value),
                    validator: (value) =>
                        value == null ? 'اختر نوع الخدمة' : null,
                  )
                else
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'نوع الخدمة'),
                    onChanged: (value) => _serviceType = value.trim(),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'أدخل نوع الخدمة'
                        : null,
                  ),
                if (widget.workAreas.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    value: _locationId,
                    decoration: const InputDecoration(labelText: 'موقع الخدمة'),
                    items: widget.workAreas
                        .map(
                          (area) => DropdownMenuItem(
                            value: area.locationId,
                            child: Text(_locationName(area)),
                          ),
                        )
                        .toList(),
                    onChanged: loading
                        ? null
                        : (value) => setState(() => _locationId = value),
                    validator: (value) => value == null ? 'اختر الموقع' : null,
                  ),
                ] else ...[
                  const SizedBox(height: 16),
                  _numberField(_locationController, 'معرف الموقع'),
                ],
                const SizedBox(height: 16),
                _numberField(_areaController, 'المساحة', allowDecimal: true),
                const SizedBox(height: 16),
                _numberField(_roomsController, 'عدد الغرف'),
                const SizedBox(height: 16),
                _numberField(_floorController, 'الطابق'),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'وصف الطلب',
                    alignLabelWithHint: true,
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'أدخل وصف الطلب'
                      : null,
                ),
                const SizedBox(height: 28),
                SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: loading ? null : _submit,
                    icon: loading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send_rounded),
                    label: Text(loading ? 'جاري الإرسال...' : 'إرسال الطلب'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor().primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _numberField(
    TextEditingController controller,
    String label, {
    bool allowDecimal = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: allowDecimal),
      decoration: InputDecoration(labelText: label),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return 'أدخل $label';
        return allowDecimal
            ? (double.tryParse(value.trim()) == null ? 'قيمة غير صحيحة' : null)
            : (int.tryParse(value.trim()) == null ? 'قيمة غير صحيحة' : null);
      },
    );
  }

  String _locationName(FinishingWorkAreaEntity workArea) {
    final location = workArea.location;
    return location == null
        ? 'موقع ${workArea.locationId}'
        : '${location.city} - ${location.neighborhood}';
  }
}
