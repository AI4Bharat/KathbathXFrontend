import 'package:flutter/material.dart';
import 'package:kathbath_lite/providers/checkbox_provider.dart';
import 'package:provider/provider.dart';

class CheckboxListWidget extends StatelessWidget {
  const CheckboxListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CheckboxProvider>(
      builder: (context, provider, child) {
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3,
          ),
          itemCount: provider.items.length,
          itemBuilder: (context, index) {
            final item = provider.items[index];
            return GestureDetector(
              onTap: () {
                provider.toggleItem(index);
              },
              child: Container(
                margin: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  color:
                      item.isChecked ? Colors.green[800] : Colors.transparent,
                  border: Border.all(
                    color: Colors.green[800]!,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      item.text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: item.isChecked ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
