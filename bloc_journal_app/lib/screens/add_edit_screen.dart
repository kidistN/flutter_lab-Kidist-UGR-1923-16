import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/quote_bloc.dart';
import '../bloc/quote_event.dart';
import '../models/quote.dart';

class AddEditScreen extends StatefulWidget {
  final Quote? quote;
  
  const AddEditScreen({super.key, this.quote});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _quoteController;
  late TextEditingController _authorController;
  late TextEditingController _noteController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.quote != null;
    _quoteController = TextEditingController(text: widget.quote?.text ?? '');
    _authorController = TextEditingController(text: widget.quote?.author ?? '');
    _noteController = TextEditingController(text: widget.quote?.personalNote ?? '');
  }

  @override
  void dispose() {
    _quoteController.dispose();
    _authorController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Moment' : 'Add Your Own Moment'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _quoteController,
                decoration: InputDecoration(
                  labelText: 'Your Quote/Moment',
                  hintText: 'What moment touched your heart?',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.format_quote),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a quote';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _authorController,
                decoration: InputDecoration(
                  labelText: 'Author/Source',
                  hintText: 'Who said this?',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an author';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(
                  labelText: 'Personal Note (Optional)',
                  hintText: 'Why does this moment matter to you?',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.note_add),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveQuote,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _isEditing ? 'Update Moment' : 'Save to Journal',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveQuote() {
    if (!_formKey.currentState!.validate()) return;
    
    final bloc = context.read<QuoteBloc>();
    
    if (_isEditing && widget.quote != null) {
      final updatedQuote = widget.quote!.copyWith(
        text: _quoteController.text,
        author: _authorController.text,
        personalNote: _noteController.text,
      );
      bloc.add(UpdateQuoteEvent(updatedQuote));
      Navigator.pop(context);
    } else {
      final newQuote = Quote(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: _quoteController.text,
        author: _authorController.text,
        savedDate: DateTime.now(),
        personalNote: _noteController.text,
      );
      bloc.add(SaveQuoteEvent(newQuote, personalNote: _noteController.text));
      Navigator.pop(context);
    }
  }
}