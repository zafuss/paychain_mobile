import 'package:flutter/material.dart';

class BottomSheetExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bottom Sheet Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
              ),
              isScrollControlled: true, // Cho phép kiểm soát chiều cao
              builder: (context) => FractionallySizedBox(
                heightFactor: 0.5, // Chiếm 50% chiều cao màn hình
                widthFactor: 1,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'This is a modal bottom sheet',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Đóng bottom sheet
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          child: const Text('Show Bottom Sheet'),
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: BottomSheetExample()));
