import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/quote_bloc.dart';
import '../bloc/quote_event.dart';
import '../models/quote.dart';
import 'add_edit_screen.dart';

class QuoteDetailScreen extends StatefulWidget {
  final Quote quote;
  
  const QuoteDetailScreen({super.key, required this.quote});

  @override
  State<QuoteDetailScreen> createState() => _QuoteDetailScreenState();
}

class _QuoteDetailScreenState extends State<QuoteDetailScreen> {
  late TextEditingController _noteController;
  bool _isEditingNote = false;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.quote.personalNote);
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moment Details'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddEditScreen(quote: widget.quote),
                ),
              ).then((_) => setState(() {}));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    '"${widget.quote.text}"',
                    style: const TextStyle(
                      fontSize: 22,
                      fontStyle: FontStyle.italic,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '— ${widget.quote.author}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 18, color: Colors.blueAccent),
                const SizedBox(width: 8),
                Text(
                  'Saved on ${_formatFullDate(widget.quote.savedDate)}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const Spacer(),
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    TextButton.icon(
                      onPressed: () {
                        context.read<QuoteBloc>().add(
                          ToggleFavoriteEvent(widget.quote.id),
                        );
                        setState(() {
                          widget.quote.isFavorite = !widget.quote.isFavorite;
                        });
                      },
                      icon: Icon(
                        widget.quote.isFavorite ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 20,
                      ),
                      label: Text(
                        widget.quote.isFavorite ? 'Favorited' : 'Mark as Favorite',
                        style: const TextStyle(color: Colors.amber),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.note, color: Colors.blueAccent),
                const SizedBox(width: 8),
                const Text(
                  'Personal Note',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _isEditingNote = !_isEditingNote;
                    });
                  },
                  icon: Icon(_isEditingNote ? Icons.close : Icons.edit),
                  label: Text(_isEditingNote ? 'Cancel' : 'Edit'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_isEditingNote)
              Column(
                children: [
                  TextField(
                    controller: _noteController,
                    decoration: InputDecoration(
                      hintText: 'Write your thoughts...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 4,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<QuoteBloc>().add(
                          UpdatePersonalNoteEvent(widget.quote.id, _noteController.text),
                        );
                        setState(() {
                          _isEditingNote = false;
                          widget.quote.personalNote = _noteController.text;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Note updated!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Save Note'),
                    ),
                  ),
                ],
              )
            else
              Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.quote.personalNote.isEmpty
                      ? 'No personal note yet. Tap edit to add one!'
                      : widget.quote.personalNote,
                  style: TextStyle(
                    fontSize: 14,
                    color: widget.quote.personalNote.isEmpty ? Colors.grey : Colors.black87,
                    fontStyle: widget.quote.personalNote.isEmpty ? FontStyle.italic : FontStyle.normal,
                  ),
                ),
              ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            Center(
              child: TextButton.icon(
                onPressed: () => _showDeleteDialog(context),
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                label: const Text(
                  'Delete from Journal',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatFullDate(DateTime date) {
    return '${date.day} ${_getMonthName(date.month)} ${date.year}';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Moment'),
        content: const Text('Are you sure you want to delete this moment from your journal?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<QuoteBloc>().add(DeleteQuoteEvent(widget.quote.id));
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to journal screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Moment deleted')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}