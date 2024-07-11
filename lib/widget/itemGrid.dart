import 'package:flutter/material.dart';
import 'package:pos/widget/Optiondialog.dart';

class ItemGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: 16, // Number of items
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => OptionDialog(),
              );
            },
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.redAccent[100],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Container(
                child: Center(
                  child: Text('ITEM NAME'),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
