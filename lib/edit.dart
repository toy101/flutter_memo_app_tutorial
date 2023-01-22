import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Edit extends StatelessWidget {
  String _current;
  Function _onChanged;

  Edit(this._current, this._onChanged);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit"),
        actions: [
          TextButton(
            onPressed: () => FocusScope.of(context).requestFocus(FocusNode()),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white
            ),
            child: const Icon(Icons.check),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: TextEditingController(text: _current),
          maxLines: 99,
          style: const TextStyle(color: Colors.black54),
          onChanged: (text) {
            _current = text;
            _onChanged(_current);
          },
        ),
      ),
    );
  }
  
}