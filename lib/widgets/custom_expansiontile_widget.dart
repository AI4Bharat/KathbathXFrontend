import 'package:flutter/material.dart';

class CustomExpansionTile extends StatefulWidget {
  final int available;
  final int completed;
  final int skipped;
  final int submitted;
  final int verified;

  const CustomExpansionTile({
    required this.available,
    required this.completed,
    required this.skipped,
    required this.submitted,
    required this.verified,
  });

  @override
  _CustomExpansionTileState createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  bool _isExpanded = false;

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: _TaskProgressItem(
                label: 'Available',
                value: widget.available,
                colorIt: const Color.fromRGBO(13, 150, 185, 1),
              ),
            ),
            const SizedBox(width: 2),
            Expanded(
              child: _TaskProgressItem(
                label: 'Submitted',
                value: widget.submitted,
                colorIt: const Color.fromARGB(255, 112, 179, 40),
              ),
            ),
            const SizedBox(width: 2),
            Expanded(
              child: _TaskProgressItem(
                label: 'Skipped',
                value: widget.skipped,
                colorIt: const Color.fromARGB(255, 228, 130, 39),
              ),
            ),
            const SizedBox(width: 2),
            GestureDetector(
              onTap: _toggleExpansion,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isExpanded ? Colors.grey[400] : Colors.grey[300],
                  border: Border.all(
                    color: _isExpanded
                        ? Colors.transparent
                        : Colors.grey, // Border color changes on click
                    width: 2.0,
                  ),
                ),
                padding: const EdgeInsets.all(8.0), // Space around the icon
                child: Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: Colors.grey[800], // Icon color
                ),
              ),
            ),
          ],
        ),

        // Expanded Content
        if (_isExpanded)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildNameValueItem('Completed', widget.completed),
              _buildNameValueItem('Verified', widget.verified),
            ],
          ),
      ],
    );
  }

  Widget _buildNameValueItem(String name, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name),
          Text(value.toString()),
        ],
      ),
    );
  }
}

class _TaskProgressItem extends StatelessWidget {
  final String label;
  final int value;
  final Color colorIt;

  const _TaskProgressItem({
    required this.label,
    required this.value,
    required this.colorIt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 55,
      height: 55,
      padding: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        color: colorIt,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '$value',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 0.0),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
