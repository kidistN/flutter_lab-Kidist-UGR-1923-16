import 'package:equatable/equatable.dart';
import '../../models/quote.dart';

abstract class QuoteEvent extends Equatable {
  const QuoteEvent();

  @override
  List<Object?> get props => [];
}

// Load quotes from API
class FetchQuotesEvent extends QuoteEvent {}

// Save quote to journal
class SaveQuoteEvent extends QuoteEvent {
  final Quote quote;
  final String personalNote;

  const SaveQuoteEvent(this.quote, {this.personalNote = ''});

  @override
  List<Object?> get props => [quote, personalNote];
}

// Update quote (note or favorite)
class UpdateQuoteEvent extends QuoteEvent {
  final Quote quote;

  const UpdateQuoteEvent(this.quote);

  @override
  List<Object?> get props => [quote];
}

// Toggle favorite
class ToggleFavoriteEvent extends QuoteEvent {
  final String quoteId;

  const ToggleFavoriteEvent(this.quoteId);

  @override
  List<Object?> get props => [quoteId];
}

// Delete quote
class DeleteQuoteEvent extends QuoteEvent {
  final String quoteId;

  const DeleteQuoteEvent(this.quoteId);

  @override
  List<Object?> get props => [quoteId];
}

// Update personal note
class UpdatePersonalNoteEvent extends QuoteEvent {
  final String quoteId;
  final String newNote;

  const UpdatePersonalNoteEvent(this.quoteId, this.newNote);

  @override
  List<Object?> get props => [quoteId, newNote];
}