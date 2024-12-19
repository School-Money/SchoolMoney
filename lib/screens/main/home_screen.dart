import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_money/constants/app_colors.dart';
import '../../components/parent_transaction_card.dart';
import '../../components/student_card.dart';
import '../../feature/children/children_provider.dart';
import '../../feature/classes/ui/collection_card.dart';
import '../../feature/collections/collections_provider.dart';

class Student {
  final String imageUrl;
  final String firstName;
  final String lastName;
  final String className;

  Student({
    required this.imageUrl,
    required this.firstName,
    required this.lastName,
    required this.className,
  });
}

class SchoolTrip {
  final String imageUrl;
  final String title;
  final String className;
  final int daysLeft;
  final double currentAmount;
  final double targetAmount;

  SchoolTrip({
    required this.imageUrl,
    required this.title,
    required this.className,
    required this.daysLeft,
    required this.currentAmount,
    required this.targetAmount,
  });
}

class ParentTransaction {
  final String id;
  final TransactionCollection collection;
  final Parent parent;
  final double amount;
  final String description;
  final String createdAt;

  ParentTransaction({
    required this.id,
    required this.collection,
    required this.parent,
    required this.amount,
    required this.description,
    required this.createdAt,
  });

  factory ParentTransaction.fromJson(Map<String, dynamic> json) {
    return ParentTransaction(
      id: json['_id'] as String,
      collection: TransactionCollection.fromJson(json['collection']),
      parent: Parent.fromJson(json['parent']),
      amount: json['amount'] as double,
      description: json['description'] as String,
      createdAt: json['createdAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'collection': collection.toJson(),
      'parent': parent.toJson(),
      'amount': amount,
      'description': description,
      'createdAt': createdAt,
    };
  }
}

class TransactionCollection {
  final String id;
  final String classId;
  final String creator;
  final String title;
  final String description;
  final String? logo;
  final String startDate;
  final String endDate;
  final double targetAmount;
  final bool isBlocked;

  TransactionCollection({
    required this.id,
    required this.classId,
    required this.creator,
    required this.title,
    required this.description,
    this.logo,
    required this.startDate,
    required this.endDate,
    required this.targetAmount,
    required this.isBlocked,
  });

  factory TransactionCollection.fromJson(Map<String, dynamic> json) {
    return TransactionCollection(
      id: json['_id'] as String,
      classId: json['class'] as String,
      creator: json['creator'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      logo: json['logo'] as String?,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      targetAmount: json['targetAmount'] as double,
      isBlocked: json['isBlocked'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'class': classId,
      'creator': creator,
      'title': title,
      'description': description,
      'logo': logo,
      'startDate': startDate,
      'endDate': endDate,
      'targetAmount': targetAmount,
      'isBlocked': isBlocked,
    };
  }
}

class Parent {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? avatar;
  final String createdAt;

  Parent({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.avatar,
    required this.createdAt,
  });

  factory Parent.fromJson(Map<String, dynamic> json) {
    return Parent(
      id: json['_id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String?,
      createdAt: json['createdAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'avatar': avatar,
      'createdAt': createdAt,
    };
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    context.read<ChildrenProvider>().fetchChildren();
    context.read<CollectionsProvider>().getCollections();
    context.read<CollectionsProvider>().getParentTransactions();
  }

  @override
  Widget build(BuildContext context) {
    final collectionsProvider = context.watch<CollectionsProvider>();
    final childrenProvider = context.watch<ChildrenProvider>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Your children',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: childrenProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      clipBehavior: Clip.none,
                      scrollDirection: Axis.horizontal,
                      itemCount: childrenProvider.children.length,
                      itemBuilder: (context, index) {
                        final student = childrenProvider.children[index];
                        return StudentCard(
                          imageUrl: student.avatar,
                          firstName: student.firstName,
                          lastName: student.lastName,
                          className: student.className ?? '',
                          onTap: () {},
                        );
                      },
                    ),
            ),
            const SizedBox(height: 24),
            Text(
              'Collections',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 340,
              child: collectionsProvider.isLoading &&
                      collectionsProvider.collections.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      clipBehavior: Clip.none,
                      scrollDirection: Axis.horizontal,
                      itemCount: collectionsProvider.collections.length,
                      itemBuilder: (context, index) {
                        final collection =
                            collectionsProvider.collections[index];
                        return SizedBox(
                          width: 300,
                          child: CollectionCard(
                            imageUrl: collection.logo ?? '',
                            title: collection.title,
                            className: collection.collectionClass.name,
                            daysLeft: collection.endDate
                                .difference(DateTime.now())
                                .inDays,
                            isBlocked: collection.isBlocked,
                            currentAmount: collection.currentAmount,
                            targetAmount: collection.targetAmount,
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                '/collection-details',
                                arguments: collection.id,
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 24),
            Text(
              'Last expenses',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: collectionsProvider.isLoading &&
                      collectionsProvider.parentTransactions.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      clipBehavior: Clip.none,
                      scrollDirection: Axis.horizontal,
                      itemCount: collectionsProvider.parentTransactions.length,
                      itemBuilder: (context, index) {
                        final transaction =
                            collectionsProvider.parentTransactions[index];
                        return ParentTransactionCard(
                          imageUrl: transaction.collection.logo ?? '',
                          firstName: transaction.parent.firstName,
                          lastName: transaction.parent.lastName,
                          transactionName: transaction.collection.title,
                          amount: transaction.amount,
                          onTap: () {},
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
