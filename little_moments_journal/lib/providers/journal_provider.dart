import 'package:flutter/material.dart';
import '../models/quote.dart';
import '../services/api_service.dart';

class JournalProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Quote> _savedQuotes = [];
  List<Quote> _availableQuotes = [];
  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;

  // Getters
  List<Quote> get savedQuotes => _savedQuotes;
  List<Quote> get availableQuotes => _availableQuotes;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;
  
  List<Quote> get favoriteQuotes {
    return _savedQuotes.where((quote) => quote.isFavorite).toList();
  }

  // READ - Fetch quotes from API
  Future<void> fetchQuotes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _availableQuotes = await _apiService.fetchRandomQuotes(count: 15);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _availableQuotes = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // CREATE - Save quote to journal
  Future<bool> saveQuote(Quote quote, {String personalNote = ''}) async {
    _isSaving = true;
    notifyListeners();

    try {
      // Check if already saved
      if (_savedQuotes.any((q) => q.id == quote.id)) {
        _errorMessage = 'This quote is already in your journal';
        notifyListeners();
        return false;
      }

      final newQuote = quote.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        savedDate: DateTime.now(),
        personalNote: personalNote,
      );
      
      _savedQuotes.insert(0, newQuote);
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  // UPDATE - Update personal note or favorite status
  Future<bool> updateQuote(Quote updatedQuote) async {
    _isSaving = true;
    notifyListeners();

    try {
      final index = _savedQuotes.indexWhere((q) => q.id == updatedQuote.id);
      if (index != -1) {
        _savedQuotes[index] = updatedQuote;
        _errorMessage = null;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  // UPDATE - Toggle favorite
  Future<void> toggleFavorite(String quoteId) async {
    final index = _savedQuotes.indexWhere((q) => q.id == quoteId);
    if (index != -1) {
      final updatedQuote = _savedQuotes[index].copyWith(
        isFavorite: !_savedQuotes[index].isFavorite,
      );
      await updateQuote(updatedQuote);
    }
  }

  // UPDATE - Update personal note only
  Future<void> updatePersonalNote(String quoteId, String newNote) async {
    final index = _savedQuotes.indexWhere((q) => q.id == quoteId);
    if (index != -1) {
      final updatedQuote = _savedQuotes[index].copyWith(
        personalNote: newNote,
      );
      await updateQuote(updatedQuote);
    }
  }

  // DELETE - Remove quote from journal
  Future<bool> deleteQuote(String quoteId) async {
    _isSaving = true;
    notifyListeners();

    try {
      _savedQuotes.removeWhere((quote) => quote.id == quoteId);
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Load saved quotes from local storage (bonus)
  void loadSavedQuotes(List<Quote> quotes) {
    _savedQuotes = quotes;
    notifyListeners();
  }
}
