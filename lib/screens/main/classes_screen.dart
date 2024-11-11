import 'package:flutter/material.dart';
import 'package:school_money/components/main/search_text_field.dart';
import 'package:school_money/constants/app_colors.dart';
import 'package:school_money/components/main/class_card.dart';

class ClassesScreen extends StatefulWidget {
  const ClassesScreen({super.key});

  @override
  ClassesScreenState createState() => ClassesScreenState();
}

class ClassesScreenState extends State<ClassesScreen> {
  List<Map<String, dynamic>> items = List.generate(
    20,
    (index) => {
      'title': 'Class $index',
      'subtitle': 'Class subtitle $index',
      'numberOfUsers': index + 1,
    },
  );

  List<Map<String, dynamic>> filteredItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = items;
  }

  void filterItems(String query) {
    setState(() {
      filteredItems = items
          .where((item) =>
              item['title'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 48),
        child: Column(
          children: [
            SizedBox(
              width: 400,
              child: SearchTextField(
                hintText: 'Search classes',
                onChanged: filterItems,
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double screenWidth = constraints.maxWidth;
                  int crossAxisCount = 4;

                  if (screenWidth < 700) {
                    crossAxisCount = 1;
                  } else if (screenWidth < 1000) {
                    crossAxisCount = 2;
                  } else if (screenWidth < 1300) {
                    crossAxisCount = 3;
                  }

                  if (filteredItems.isEmpty) {
                    return Center(
                      child: Text(
                        'No classes found',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondary,
                        ),
                      ),
                    );
                  } else {
                    return GridView.builder(
                      itemCount: filteredItems.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 24,
                        mainAxisExtent: 200,
                      ),
                      itemBuilder: (context, index) {
                        return ClassCard(
                          title: filteredItems[index]['title'],
                          subtitle: filteredItems[index]['subtitle'],
                          numberOfUsers: filteredItems[index]['numberOfUsers'],
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
