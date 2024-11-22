import 'package:flutter/material.dart';

class EditBoxWidget extends StatefulWidget {
  final Function(String) onTextSubmitted; // Callback function
  final String buttonType;

  const EditBoxWidget(
      {super.key, required this.onTextSubmitted, required this.buttonType});

  @override
  // ignore: library_private_types_in_public_api
  _EditableTextBoxState createState() => _EditableTextBoxState();
}

class _EditableTextBoxState extends State<EditBoxWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: () {
                    if (widget.buttonType == 'next') {
                      return 'Start typing...';
                    } else if (widget.buttonType == 'search') {
                      return 'Search something...';
                    } else {
                      return 'Start Typing...';
                    }
                  }(),
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Colors.grey[200],
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 10.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
                onPressed: () {
                  widget.onTextSubmitted(_controller.text);
                  _controller.clear();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  textStyle: const TextStyle(fontSize: 20.0),
                ),
                child: () {
                  if (widget.buttonType == 'next') {
                    return Image.asset(
                      'assets/icons/ic_next_enabled.png',
                      height: 40.0,
                      width: 40.0,
                    );
                  } else if (widget.buttonType == 'add') {
                    return const Text('+');
                  } else if (widget.buttonType == 'search') {
                    return const Icon(
                      Icons.search,
                      size: 30.0,
                    );
                  } else {
                    return Image.asset(
                      'assets/icons/ic_next_enabled.png',
                      height: 40.0,
                      width: 40.0,
                    );
                  }
                }()),
          ],
        ));
  }
}
