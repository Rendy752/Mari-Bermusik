import 'package:flutter/material.dart';

class EntryField extends StatefulWidget {
  final String title;
  final TextEditingController controller;

  const EntryField({Key? key, required this.title, required this.controller})
      : super(key: key);

  @override
  EntryFieldState createState() => EntryFieldState();
}

enum Instrument { guitar, piano, drums, violin, flute, clarinet }

class EntryFieldState extends State<EntryField> {
  bool _obscureText = true;
  Instrument? _selectedInstrument;

  Instrument? stringToInstrument(String instrumentString) {
    for (Instrument instrument in Instrument.values) {
      if (instrument.toString().split('.').last == instrumentString) {
        return instrument;
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _selectedInstrument = stringToInstrument(widget.controller.text);
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.title == 'Instrument') {
      return Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: DropdownButtonFormField<Instrument>(
          value: _selectedInstrument,
          items: Instrument.values.map((Instrument instrument) {
            return DropdownMenuItem<Instrument>(
              value: instrument,
              child: Text(
                instrument.toString().split('.').last.toUpperCase(),
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            );
          }).toList(),
          onChanged: (Instrument? newValue) {
            setState(() {
              _selectedInstrument = newValue;
              widget.controller.text = newValue.toString().split('.').last;
            });
          },
          decoration: InputDecoration(
            labelText: widget.title,
            labelStyle: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
            prefixIcon: Icon(
              Icons.music_note,
              color: Colors.grey[600],
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(color: Colors.blue[400]!),
            ),
          ),
          dropdownColor: Colors.white,
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: TextField(
          controller: widget.controller,
          cursorColor: Colors.blue[400],
          style: const TextStyle(
            color: Colors.black87,
          ),
          obscureText: widget.title == 'Password' ? _obscureText : false,
          maxLines: (widget.title == 'Description' || widget.title == 'Content')
              ? null
              : 1,
          keyboardType:
              (widget.title == 'Description' || widget.title == 'Content')
                  ? TextInputType.multiline
                  : TextInputType.text,
          textInputAction:
              (widget.title == 'Description' || widget.title == 'Content')
                  ? TextInputAction.newline
                  : TextInputAction.next,
          decoration: InputDecoration(
            prefixIcon: Icon(
              widget.title == 'Email'
                  ? Icons.email
                  : widget.title == 'Password'
                      ? Icons.lock
                      : Icons.text_fields,
              color: Colors.grey[600],
            ),
            suffixIcon: widget.title == 'Password'
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: _togglePasswordVisibility,
                  )
                : null,
            labelText: widget.title,
            labelStyle: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
            hintText: 'Enter your ${widget.title}',
            hintStyle: TextStyle(
              color: Colors.grey[400],
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(color: Colors.blue[400]!),
            ),
            filled: true,
            fillColor: Colors.grey[200],
          ),
        ),
      );
    }
  }
}
