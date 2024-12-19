import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_money/auth/auth_service.dart';
import 'package:school_money/components/auth/auth_button.dart';
import 'package:school_money/constants/app_colors.dart';
import 'package:school_money/feature/collections/collections_provider.dart';
import 'package:school_money/feature/collections/model/collectionDetails/collection_details.dart';
import 'package:school_money/feature/collections/model/payment/payment.dart';
import 'package:school_money/feature/collections/ui/creator_payment_collection_dialog.dart';
import 'package:school_money/feature/collections/ui/payment_collection_dialog.dart';

class CollectionsDetailsScreen extends StatefulWidget {
  final String collectionId;
  const CollectionsDetailsScreen({super.key, required this.collectionId});

  @override
  _CollectionsDetailsScreenState createState() =>
      _CollectionsDetailsScreenState();
}

class _CollectionsDetailsScreenState extends State<CollectionsDetailsScreen> {
  String? _userId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<CollectionsProvider>()
          .getCollectionDetails(widget.collectionId);
    });
    _getUserDetails();
  }

  void _getUserDetails() async {
    var userDetails = await AuthService().getUserDetails();
    if (userDetails!.id.isNotEmpty) {
      _userId = userDetails.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final collectionsProvider = context.watch<CollectionsProvider>();

    // Handle loading state
    if (collectionsProvider.isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.accent,
          ),
        ),
      );
    }

    final CollectionDetails? collection = collectionsProvider.collectionDetails;
    if (collection == null) {
      return Scaffold(
        body: Center(
          child: Text(
            'Collection not found',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.secondary,
            ),
          ),
        ),
      );
    }

    final progress = (collection.currentAmount / collection.targetAmount);
    final progressPercent = (progress * 100).round();

    return Scaffold(
      body: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 700),
        child: Row(
          children: [
            // Left side: Collection Details
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 350,
                        width: double.infinity,
                        child: collection.logo != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  collection.logo!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: AppColors.gray,
                                      child: Center(
                                        child: Icon(
                                          Icons.collections_bookmark_outlined,
                                          size: 50,
                                          color: AppColors.secondary,
                                        ),
                                      ),
                                    );
                                  },
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      color: AppColors.gray,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.accent,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  color: AppColors.gray,
                                  child: Center(
                                    child: Icon(
                                      Icons.collections_bookmark_outlined,
                                      size: 50,
                                      color: AppColors.secondary,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            collection.title,
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondary,
                            ),
                          ),
                          Text(
                            '${getDateFormat(collection.startDate)} - ${getDateFormat(collection.endDate)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        collection.collectionClass.name,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: AppColors.gray,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        collection.description,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w200,
                          color: AppColors.secondary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            '${collection.currentAmount.toStringAsFixed(2)} zł',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondary,
                            ),
                          ),
                          Text(
                            ' out of ${collection.targetAmount.toStringAsFixed(2)} zł',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.gray,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Stack(
                        children: [
                          Container(
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppColors.gray,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: progress.clamp(0, 1),
                            child: Container(
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      if (progress < 0.1)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '$progressPercent%',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.secondary,
                            ),
                          ),
                        )
                      else
                        FractionallySizedBox(
                          widthFactor: progress.clamp(0, 1),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '$progressPercent%',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.secondary,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Creator',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.secondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: AppColors.gray,
                                backgroundImage: collection.creator.avatar !=
                                        null
                                    ? NetworkImage(collection.creator.avatar!)
                                    : null,
                                child: collection.creator.avatar == null
                                    ? Icon(Icons.person,
                                        color: AppColors.secondary)
                                    : null,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${collection.creator.firstName} ${collection.creator.lastName}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w200,
                                  color: AppColors.secondary,
                                ),
                              ),
                            ],
                          ),
                          if (!collection.isBlocked &&
                              collection.endDate.isAfter(DateTime.now()))
                            Column(
                              children: [
                                ConstrainedBox(
                                  constraints:
                                      const BoxConstraints(maxWidth: 200),
                                  child: AuthButton(
                                    text: 'Pay',
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            PaymentCollectionDialog(
                                          children: collection.children,
                                          collectionId: collection.id,
                                          onPay: (paymentDetails) async {
                                            try {
                                              await context
                                                  .read<CollectionsProvider>()
                                                  .createAPayment(
                                                      paymentDetails);
                                            } catch (e) {
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(e.toString()),
                                                    backgroundColor:
                                                        AppColors.red,
                                                  ),
                                                );
                                              }
                                            } finally {
                                              if (context.mounted) {
                                                Navigator.of(context).pop();

                                                await context
                                                    .read<CollectionsProvider>()
                                                    .getCollectionDetails(
                                                        widget.collectionId);
                                              }
                                            }
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 16),
                                if (collection.creator.id == _userId) ...[
                                  ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(maxWidth: 200),
                                    child: AuthButton(
                                      text: 'Withdraw',
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              CreatorPaymentCollectionDialog(
                                            children: collection.children,
                                            collectionId: collection.id,
                                            onPay: (paymentDetails) async {
                                              try {
                                                await context
                                                    .read<CollectionsProvider>()
                                                    .createAPayment(
                                                        paymentDetails);
                                              } catch (e) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(e.toString()),
                                                    backgroundColor:
                                                        AppColors.red,
                                                  ),
                                                );
                                              } finally {
                                                if (context.mounted) {
                                                  Navigator.of(context).pop();

                                                  await context
                                                      .read<
                                                          CollectionsProvider>()
                                                      .getCollectionDetails(
                                                          widget.collectionId);
                                                }
                                              }
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(maxWidth: 200),
                                    child: AuthButton(
                                      variant: ButtonVariant.alternative,
                                      text: 'Edit',
                                      onPressed: () async {
                                        final result = showDialog(
                                          context: context,
                                          builder: (context) => EditCollectionDialog()
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Vertical Divider
            VerticalDivider(
              color: AppColors.gray.withOpacity(0.3),
              width: 1,
              thickness: 1,
            ),

            // Right side: Payments
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transactions (${collection.payments.length})',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.separated(
                        itemCount: collection.payments.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final payment = collection.payments[index];
                          return _buildPaymentTile(
                              payment,
                              collection.isBlocked ||
                                  collection.endDate.isBefore(DateTime.now()));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentTile(Payment payment, bool isClosed) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.gray.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.gray,
                      backgroundImage: payment.parent.avatar != null
                          ? NetworkImage(payment.parent.avatar!)
                          : null,
                      child: payment.parent.avatar == null
                          ? Icon(Icons.person, color: AppColors.secondary)
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${payment.parent.firstName} ${payment.parent.lastName}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.secondary,
                            ),
                          ),
                          Text(
                            '${payment.amount.toStringAsFixed(2)} zł',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.accent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.monetization_on_outlined,
                color: AppColors.accent,
                size: 30,
              ),

              if (payment.child != null)
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${payment.child!.firstName} ${payment.child!.lastName}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.gray,
                      backgroundImage: payment.child?.avatar != null
                          ? NetworkImage(payment.child!.avatar!)
                          : null,
                      child: payment.child?.avatar == null
                          ? Icon(Icons.person, color: AppColors.secondary)
                          : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            payment.description,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.gray,
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          if (payment.withdrawable && !isClosed)
            SizedBox(
              height: 40,
              width: 100,
              child: AuthButton(
                text: 'Withdraw',
                onPressed: () async {
                  try {
                    await context
                        .read<CollectionsProvider>()
                        .withdrawPayment(payment.id);

                    if (mounted) {
                      await context
                          .read<CollectionsProvider>()
                          .getCollectionDetails(widget.collectionId);
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                        backgroundColor: AppColors.red,
                      ),
                    );
                  }
                },
              ),
            ),
        ],
      ),
    );
  }

  String getDateFormat(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
