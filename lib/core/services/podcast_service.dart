import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcast_search/podcast_search.dart';

final podcastServiceProvider = Provider((ref) => PodcastService());

class PodcastService {
  Future<SearchResult> fetchPodcast({String genre = '', int limit =10}) async {
    final search = Search();
    final results =
        await search.charts(country: Country.nigeria, limit: limit, genre: genre);
    return results;
  }

  Future<Podcast> getPodcastDetails(String feedUrl) async {
    final podcast = await Podcast.loadFeed(url: feedUrl);
    return podcast;
  }
}
