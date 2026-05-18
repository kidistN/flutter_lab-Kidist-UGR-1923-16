import 'package:equatable/equatable.dart';
import '../models/quote.dart';

abstract class QuoteState extends Equatable {
  const QuoteState();

  @override
  List<Object?> get props => [];
}

// Initial state
class QuoteInitialState extends QuoteState {}

// Loading states
class QuotesLoadingState extends QuoteState {}

// Loaded state
class QuotesLoadedState extends QuoteState {
  final List<Quote> availableQuotes;
  final List<Quote> savedQuotes;

  const QuotesLoadedState({
    required this.availableQuotes,
    required this.savedQuotes,
  });

  @override
  List<Object?> get props => [availableQuotes, savedQuotes];
}

// Error state
class QuoteErrorState extends QuoteState {
  final String message;

  const QuoteErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
