import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_money/admin/admin_provider.dart';
import 'package:school_money/admin/model/bank_account.dart';
import 'package:school_money/admin/model/collection.dart';
import 'package:school_money/admin/model/parent.dart';
import 'package:school_money/components/auth/auth_button.dart';
import 'package:school_money/constants/app_colors.dart';
import 'package:school_money/feature/children/model/child.dart';
import 'package:school_money/feature/classes/model/class.dart';

class AdminReportScreen extends StatefulWidget {
  const AdminReportScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AdminReportScreenState();
  }
}

class _AdminReportScreenState extends State<AdminReportScreen> {
  Future<List<dynamic>>? _availableEntitiesFuture;
  Future<List<dynamic>>? _availableOptionalEntitiesFuture;

  final buttonSettings = [
    {
      'text': 'Classes',
      'onPressedValue': 'classes',
    },
    {
      'text': 'Collections',
      'onPressedValue': 'collections',
    },
    {
      'text': 'Parents',
      'onPressedValue': 'parents',
    },
    {
      'text': 'Bank Accounts',
      'onPressedValue': 'bank-accounts',
    },
  ];
  final mainEntityToStringMap = {
    'classes': 'class',
    'collections': 'collection',
    'parents': 'parent',
    'bank-accounts': 'bank account',
  };
  final optionalFilterEntities = ['classes', 'collections'];
  final entityToOptionalStringMap = {
    'classes': 'collection',
    'collections': 'child',
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = Provider.of<AdminProvider>(context, listen: false);
    _updateAvailableEntitiesFuture(provider);
  }

  void _updateAvailableEntitiesFuture(AdminProvider provider) {
    setState(() {
      _availableEntitiesFuture = provider.getAvailableEntities();
      _availableOptionalEntitiesFuture =
          provider.getOptionalAvailableEntities();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<AdminProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.accent,
                ),
              );
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                Text(
                  'Select an entity to generate a report for',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: buttonSettings.map((buttonSetting) {
                      final text = buttonSetting['text'] as String;
                      final onPressedValue =
                          buttonSetting['onPressedValue'] as String;

                      return SizedBox(
                        width: 200,
                        child: AuthButton(
                          text: text,
                          onPressed: () {
                            provider.setReportEntity(onPressedValue);
                            _updateAvailableEntitiesFuture(provider);
                          },
                          variant: provider.getReportEntity() == onPressedValue
                              ? ButtonVariant.primary
                              : ButtonVariant.alternative,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                if (provider.getReportEntity().isNotEmpty)
                  Column(
                    children: [
                      const SizedBox(height: 32),
                      Text(
                        'Pick a ${mainEntityToStringMap[provider.getReportEntity()]}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      FutureBuilder<List<dynamic>>(
                        future: _availableEntitiesFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'Failed to load data',
                                style: TextStyle(
                                  color: AppColors.secondary,
                                ),
                              ),
                            );
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(
                              child: Text(
                                'No data available',
                                style: TextStyle(
                                  color: AppColors.secondary,
                                ),
                              ),
                            );
                          }

                          final items = _getDropdownItems(snapshot.data!);

                          return SizedBox(
                            width: 300,
                            child: DropdownButton<String>(
                              dropdownColor: AppColors.primary,
                              value: provider.getReportEntityId().isEmpty
                                  ? null
                                  : provider.getReportEntityId(),
                              hint: Text(
                                'No ${mainEntityToStringMap[provider.getReportEntity()]} selected',
                                style: TextStyle(
                                  color: AppColors.secondary,
                                ),
                              ),
                              isExpanded: true,
                              items: items,
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  provider.setReportEntityId(newValue);
                                  _updateAvailableEntitiesFuture(provider);
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                if (provider.getReportEntityId().isNotEmpty &&
                    optionalFilterEntities.contains(provider.getReportEntity()))
                  Column(
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        'Optionally select a ${entityToOptionalStringMap[provider.getReportEntity()]}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      FutureBuilder<List<dynamic>>(
                        future: _availableOptionalEntitiesFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Failed to load data',
                                  style: TextStyle(color: AppColors.secondary)),
                            );
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(
                              child: Text(
                                'No data available',
                                style: TextStyle(
                                  color: AppColors.secondary,
                                ),
                              ),
                            );
                          }

                          final items = _getDropdownItems(snapshot.data!);

                          return SizedBox(
                            width: 300,
                            child: DropdownButton<String>(
                              dropdownColor: AppColors.primary,
                              value:
                                  provider.getOptionalReportEntityId().isEmpty
                                      ? null
                                      : provider.getOptionalReportEntityId(),
                              hint: Text(
                                'No ${entityToOptionalStringMap[provider.getReportEntity()]} selected',
                                style: TextStyle(
                                  color: AppColors.secondary,
                                ),
                              ),
                              isExpanded: true,
                              items: items,
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  provider.setOptionalReportEntityId(newValue);
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                if (provider.getReportEntityId().isNotEmpty)
                  Column(
                    children: [
                      const SizedBox(height: 32),
                      SizedBox(
                        width: 150,
                        child: AuthButton(
                          text: 'Download report',
                          onPressed: provider.downloadFile,
                          variant: ButtonVariant.primary,
                        ),
                      ),
                    ],
                  )
              ],
            );
          },
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _getDropdownItems(List<dynamic> entities) {
    return entities.map((entity) {
      var id = '';
      var name = '';
      if (entity is Parent) {
        id = entity.id;
        name = '${entity.firstName} ${entity.lastName}';
      } else if (entity is Class) {
        id = entity.id;
        name = entity.name;
      } else if (entity is Collection) {
        id = entity.id;
        name = entity.title;
      } else if (entity is BankAccount) {
        id = entity.id;
        name = entity.accountNumber;
      } else if (entity is Child) {
        id = entity.id;
        name = '${entity.firstName} ${entity.lastName}';
      }

      return DropdownMenuItem<String>(
        value: id,
        child: Text(
          name,
          style: TextStyle(
            color: AppColors.secondary,
          ),
        ),
      );
    }).toList();
  }
}
