import 'package:flutter/material.dart';
import 'package:school_money/constants/app_colors.dart';

import '../../components/parent_transaction_card.dart';
import '../../components/school_trip_card.dart';
import '../../components/student_card.dart';

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
  bool _isLoadingStudents = true;
  bool _isLoadingSchoolTrips = true;
  bool _isLoadingParentTransactions = true;

  List<Student> _students = [];
  List<SchoolTrip> _schoolTrips = [];
  List<ParentTransaction> _parentTransactions = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {}

  @override
  Widget build(BuildContext context) {
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
              child: _isLoadingStudents
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      clipBehavior: Clip.none,
                      scrollDirection: Axis.horizontal,
                      itemCount: _students.length,
                      itemBuilder: (context, index) {
                        final student = _students[index];
                        return StudentCard(
                          imageUrl: student.imageUrl,
                          firstName: student.firstName,
                          lastName: student.lastName,
                          className: student.className,
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
              child: _isLoadingSchoolTrips
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      clipBehavior: Clip.none,
                      scrollDirection: Axis.horizontal,
                      itemCount: _schoolTrips.length,
                      itemBuilder: (context, index) {
                        final collection = _schoolTrips[index];
                        return SizedBox(
                          width: 300,
                          child: SchoolTripCard(
                            imageUrl: collection.imageUrl,
                            title: collection.title,
                            className: collection.className,
                            daysLeft: collection.daysLeft,
                            currentAmount: collection.currentAmount,
                            targetAmount: collection.targetAmount,
                            onTap: () {},
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

final students = [
  Student(
    imageUrl:
        'https://fastly.picsum.photos/id/791/5000/3333.jpg?hmac=cPzd2JG5KPMTn-WdscexEPbtbi5aISCGHKWkIlx5-eE',
    firstName: 'Igor',
    lastName: 'Joński',
    className: 'Kretole 3B',
  ),
  Student(
    imageUrl:
        'https://fastly.picsum.photos/id/791/5000/3333.jpg?hmac=cPzd2JG5KPMTn-WdscexEPbtbi5aISCGHKWkIlx5-eE',
    firstName: 'Bartek',
    lastName: 'Chadryś',
    className: 'Kretole 3B',
  ),
  Student(
    imageUrl:
        'https://fastly.picsum.photos/id/791/5000/3333.jpg?hmac=cPzd2JG5KPMTn-WdscexEPbtbi5aISCGHKWkIlx5-eE',
    firstName: 'Aleksander',
    lastName: 'Golus',
    className: 'Kretole 3B',
  ),
  Student(
    imageUrl:
        'https://fastly.picsum.photos/id/791/5000/3333.jpg?hmac=cPzd2JG5KPMTn-WdscexEPbtbi5aISCGHKWkIlx5-eE',
    firstName: 'Jakub',
    lastName: 'Miśko',
    className: 'Kretole 3B',
  ),
  Student(
    imageUrl:
        'https://fastly.picsum.photos/id/791/5000/3333.jpg?hmac=cPzd2JG5KPMTn-WdscexEPbtbi5aISCGHKWkIlx5-eE',
    firstName: 'Mateusz',
    lastName: 'Kłos',
    className: 'Kretole 3B',
  ),
  Student(
    imageUrl:
        'https://fastly.picsum.photos/id/791/5000/3333.jpg?hmac=cPzd2JG5KPMTn-WdscexEPbtbi5aISCGHKWkIlx5-eE',
    firstName: 'Adam',
    lastName: 'Nowak',
    className: 'Kretole 3B',
  ),
  Student(
    imageUrl:
        'https://fastly.picsum.photos/id/791/5000/3333.jpg?hmac=cPzd2JG5KPMTn-WdscexEPbtbi5aISCGHKWkIlx5-eE',
    firstName: 'Kamil',
    lastName: 'Bednarek',
    className: 'Kretole 3B',
  ),
  Student(
    imageUrl:
        'https://fastly.picsum.photos/id/791/5000/3333.jpg?hmac=cPzd2JG5KPMTn-WdscexEPbtbi5aISCGHKWkIlx5-eE',
    firstName: 'Dawid',
    lastName: 'Podsiadło',
    className: 'Kretole 3B',
  )
];

final schoolTrips = [
  SchoolTrip(
    imageUrl:
        'https://fastly.picsum.photos/id/585/2509/1673.jpg?hmac=qQp2RIQ9sW9hUKPCkC6DkTZa0X1i0Vl2xmoZgd4vois',
    title: 'Football tournament',
    className: 'Kretole 3B',
    daysLeft: 3,
    currentAmount: 360,
    targetAmount: 500,
  ),
  SchoolTrip(
    imageUrl:
        'https://fastly.picsum.photos/id/791/5000/3333.jpg?hmac=cPzd2JG5KPMTn-WdscexEPbtbi5aISCGHKWkIlx5-eE',
    title: 'Trip to cinema',
    className: 'Kretole 3B',
    daysLeft: 5,
    currentAmount: 100,
    targetAmount: 300,
  ),
  SchoolTrip(
    imageUrl:
        'https://fastly.picsum.photos/id/307/5000/3333.jpg?hmac=wQFGsFoqFNhjL7Vf3y12D-qiKGUAl-BuhTbFJthHH4I',
    title: 'New desks',
    className: 'Kretole 3B',
    daysLeft: 8,
    currentAmount: 500,
    targetAmount: 1000,
  ),
  SchoolTrip(
    imageUrl:
        'https://fastly.picsum.photos/id/433/4752/3168.jpg?hmac=Og-twcmaH_j-JNExl5FsJk1pFA7o3-F0qeOblQiJm4s',
    title: 'Zoo excursion',
    className: 'Kretole 3B',
    daysLeft: 12,
    currentAmount: 800,
    targetAmount: 1200,
  ),
  SchoolTrip(
    imageUrl:
        'https://fastly.picsum.photos/id/581/2509/1672.jpg?hmac=e05XaJshh2TI6526jtRRKWp99m8Q_fXaXWBIQrPtL5Q',
    title: 'Science fair',
    className: 'Kretole 3B',
    daysLeft: 15,
    currentAmount: 250,
    targetAmount: 600,
  ),
  SchoolTrip(
    imageUrl:
        'https://fastly.picsum.photos/id/372/4871/3247.jpg?hmac=h3V03AFlLClySyHtiq25tajQBxZZBqcRU8dzjQz5GwM',
    title: 'Swimming lessons',
    className: 'Kretole 3B',
    daysLeft: 7,
    currentAmount: 450,
    targetAmount: 900,
  ),
  SchoolTrip(
    imageUrl:
        'https://fastly.picsum.photos/id/453/2048/1365.jpg?hmac=A8uxtdn4Y600Z5b2ngnn9hCXAx8sUnOVzprtDnz6DK8',
    title: 'Concert with workshop',
    className: 'Kretole 3B',
    daysLeft: 10,
    currentAmount: 300,
    targetAmount: 800,
  ),
  SchoolTrip(
    imageUrl:
        'https://fastly.picsum.photos/id/363/4802/3202.jpg?hmac=JGswzT_8L2IXa3nz4ljN90IbYlZr_VMwWDmSccD0Vnw',
    title: 'History museum',
    className: 'Kretole 3B',
    daysLeft: 6,
    currentAmount: 280,
    targetAmount: 400,
  ),
  SchoolTrip(
    imageUrl:
        'https://fastly.picsum.photos/id/798/4592/3448.jpg?hmac=a-NblRRC-lhb5GShHTdTomW3vlf5HZKM_aRjWQaOmNg',
    title: 'Art supplies',
    className: 'Kretole 3B',
    daysLeft: 4,
    currentAmount: 150,
    targetAmount: 350,
  ),
];

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
