import 'package:flutter/material.dart';
import '../../Screens/AddTransactionScreen.dart';

class NewBottomBar extends StatefulWidget {
  const NewBottomBar({Key? key}) : super(key: key);

  @override
  State<NewBottomBar> createState() => _NewBottomBarState();
}

class _NewBottomBarState extends State<NewBottomBar>
    with SingleTickerProviderStateMixin {
  final GlobalKey _buttonKey = GlobalKey();
  bool _showPopup = false;

  void _openPopup() {
    setState(() => _showPopup = true);
  }

  void _closePopup() {
    setState(() => _showPopup = false);
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Your main bottom bar
        Container(
          height: 60,
          color: Theme.of(context).colorScheme.surface,
          child: Center(child: Text('Bottom Navigation Items Here')),
        ),

        // Add Button
        Positioned(
          bottom: 20,
          child: GestureDetector(
            key: _buttonKey,
            onTap: _openPopup,
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ),

        // Popup Animation
        if (_showPopup)
          Positioned.fill(
            child: GestureDetector(
              onTap: _closePopup,
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      height: 400,
                      child: AddTransactionScreen(

                        // onBackPressed: _closePopup,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

