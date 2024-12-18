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
  final String imageUrl;
  final String firstName;
  final String lastName;
  final String transactionName;
  final double amount;

  ParentTransaction({
    required this.imageUrl,
    required this.firstName,
    required this.lastName,
    required this.transactionName,
    required this.amount,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoadingParentTransactions = true;

  List<ParentTransaction> _parentTransactions = [];

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
              'Open collections',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 340,
              child: collectionsProvider.isLoading
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
              child: _isLoadingParentTransactions
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      clipBehavior: Clip.none,
                      scrollDirection: Axis.horizontal,
                      itemCount: _parentTransactions.length,
                      itemBuilder: (context, index) {
                        final transaction = _parentTransactions[index];
                        return ParentTransactionCard(
                          imageUrl: transaction.imageUrl,
                          firstName: transaction.firstName,
                          lastName: transaction.lastName,
                          transactionName: transaction.transactionName,
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

final parentTransactions = [
  ParentTransaction(
    imageUrl:
        'https://fastly.picsum.photos/id/791/5000/3333.jpg?hmac=cPzd2JG5KPMTn-WdscexEPbtbi5aISCGHKWkIlx5-eE',
    firstName: 'Tomasz',
    lastName: 'Adamek',
    transactionName: 'New desks',
    amount: -50,
  ),
  ParentTransaction(
    imageUrl:
        'https://fastly.picsum.photos/id/791/5000/3333.jpg?hmac=cPzd2JG5KPMTn-WdscexEPbtbi5aISCGHKWkIlx5-eE',
    firstName: 'Mariusz',
    lastName: 'Pudzianowski',
    transactionName: 'Football tournament',
    amount: 100,
  ),
  ParentTransaction(
    imageUrl:
        'https://fastly.picsum.photos/id/791/5000/3333.jpg?hmac=cPzd2JG5KPMTn-WdscexEPbtbi5aISCGHKWkIlx5-eE',
    firstName: 'Michał',
    lastName: 'Orliński',
    transactionName: 'Trip to cinema',
    amount: -25,
  ),
  ParentTransaction(
    imageUrl:
        'https://fastly.picsum.photos/id/791/5000/3333.jpg?hmac=cPzd2JG5KPMTn-WdscexEPbtbi5aISCGHKWkIlx5-eE',
    firstName: 'Anna',
    lastName: 'Kowalska',
    transactionName: 'Swimming lessons',
    amount: 75,
  ),
  ParentTransaction(
    imageUrl:
        'https://fastly.picsum.photos/id/791/5000/3333.jpg?hmac=cPzd2JG5KPMTn-WdscexEPbtbi5aISCGHKWkIlx5-eE',
    firstName: 'Piotr',
    lastName: 'Nowicki',
    transactionName: 'Art supplies',
    amount: -30,
  ),
  ParentTransaction(
    imageUrl:
        'https://fastly.picsum.photos/id/791/5000/3333.jpg?hmac=cPzd2JG5KPMTn-WdscexEPbtbi5aISCGHKWkIlx5-eE',
    firstName: 'Barbara',
    lastName: 'Wojcik',
    transactionName: 'Theater tickets',
    amount: 120,
  ),
  ParentTransaction(
    imageUrl:
        'https://fastly.picsum.photos/id/791/5000/3333.jpg?hmac=cPzd2JG5KPMTn-WdscexEPbtbi5aISCGHKWkIlx5-eE',
    firstName: 'Krzysztof',
    lastName: 'Zieliński',
    transactionName: 'Zoo excursion',
    amount: -45,
  ),
  ParentTransaction(
    imageUrl:
        'https://fastly.picsum.photos/id/791/5000/3333.jpg?hmac=cPzd2JG5KPMTn-WdscexEPbtbi5aISCGHKWkIlx5-eE',
    firstName: 'Monika',
    lastName: 'Lewandowska',
    transactionName: 'Science fair',
    amount: 60,
  ),
  ParentTransaction(
    imageUrl:
        'https://fastly.picsum.photos/id/791/5000/3333.jpg?hmac=cPzd2JG5KPMTn-WdscexEPbtbi5aISCGHKWkIlx5-eE',
    firstName: 'Adam',
    lastName: 'Malinowski',
    transactionName: 'Museum entry',
    amount: -35,
  ),
];
