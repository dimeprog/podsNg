import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podsonly/core/services/podcast_service.dart';

final podcastCategoryItemProvider = FutureProvider.family((ref, String genre) {
  final podcastService = ref.read(podcastServiceProvider);
  return podcastService.fetchPodcast(genre: genre);
});

class GenreParams extends Equatable {
  final String genre;
  final int limit;
   const GenreParams({required this.genre, required this.limit});

  @override
  List<Object?> get props => [genre, limit];
}

final genreProvider = FutureProvider.family((ref, GenreParams params) {
  final podcastService = ref.read(podcastServiceProvider);
  return podcastService.fetchPodcast(genre: params.genre, limit: params.limit);
});
