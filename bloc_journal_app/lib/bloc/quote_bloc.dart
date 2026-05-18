import 'package:flutter_bloc/flutter_bloc.dart';
import 'quote_event.dart';
import 'quote_state.dart';
import '../models/quote.dart';
import '../services/api_service.dart';

class QuoteBloc extends Bloc<QuoteEvent, QuoteState> {
  final ApiService _apiService = ApiService();
  
  List<Quote> _availableQuotes = [];
  List<Quote> _savedQuotes = [];

  QuoteBloc() : super(QuoteInitialState()) {
    on<FetchQuotesEvent>(_onFetchQuotes);
    on<SaveQuoteEvent>(_onSaveQuote);
    on<UpdateQuoteEvent>(_onUpdateQuote);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<DeleteQuoteEvent>(_onDeleteQuote);
    on<UpdatePersonalNoteEvent>(_onUpdatePersonalNote);
  }

  Future<void> _onFetchQuotes(
    FetchQuotesEvent event,
    Emitter<QuoteState> emit,
  ) async {
    emit(QuotesLoadingState());
    
    try {
      _availableQuotes = await _apiService.fetchQuotes(limit: 15);
      emit(QuotesLoadedState(
        availableQuotes: _availableQuotes,
        savedQuotes: _savedQuotes,
      ));
    } catch (e) {
      emit(QuoteErrorState(e.toString()));
    }
  }

  Future<void> _onSaveQuote(
    SaveQuoteEvent event,
    Emitter<QuoteState> emit,
  ) async {
    emit(SavingState());
    
    final newQuote = Quote(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: event.quote.text,
      author: event.quote.author,
      savedDate: DateTime.now(),
      personalNote: event.personalNote,
    );
    
    _savedQuotes.insert(0, newQuote);
    
    emit(QuotesLoadedState(
      availableQuotes: _availableQuotes,
      savedQuotes: _savedQuotes,
    ));
    emit(OperationSuccessState('Added to your journal! ✨'));
  }

  Future<void> _onUpdateQuote(
    UpdateQuoteEvent event,
    Emitter<QuoteState> emit,
  ) async {
    final index = _savedQuotes.indexWhere((q) => q.id == event.quote.id);
    if (index != -1) {
      _savedQuotes[index] = event.quote;
      
      emit(QuotesLoadedState(
        availableQuotes: _availableQuotes,
        savedQuotes: _savedQuotes,
      ));
      emit(OperationSuccessState('Quote updated!'));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<QuoteState> emit,
  ) async {
    final index = _savedQuotes.indexWhere((q) => q.id == event.quoteId);
    if (index != -1) {
      final updatedQuote = _savedQuotes[index].copyWith(
        isFavorite: !_savedQuotes[index].isFavorite,
      );
      _savedQuotes[index] = updatedQuote;
      
      emit(QuotesLoadedState(
        availableQuotes: _availableQuotes,
        savedQuotes: _savedQuotes,
      ));
    }
  }

  Future<void> _onDeleteQuote(
    DeleteQuoteEvent event,
    Emitter<QuoteState> emit,
  ) async {
    _savedQuotes.removeWhere((quote) => quote.id == event.quoteId);
    
    emit(QuotesLoadedState(
      availableQuotes: _availableQuotes,
      savedQuotes: _savedQuotes,
    ));
    emit(OperationSuccessState('Quote deleted'));
  }

  Future<void> _onUpdatePersonalNote(
    UpdatePersonalNoteEvent event,
    Emitter<QuoteState> emit,
  ) async {
    final index = _savedQuotes.indexWhere((q) => q.id == event.quoteId);
    if (index != -1) {
      final updatedQuote = _savedQuotes[index].copyWith(
        personalNote: event.newNote,
      );
      _savedQuotes[index] = updatedQuote;
      
      emit(QuotesLoadedState(
        availableQuotes: _availableQuotes,
        savedQuotes: _savedQuotes,
      ));
      emit(OperationSuccessState('Note updated!'));
    }
  }
}
