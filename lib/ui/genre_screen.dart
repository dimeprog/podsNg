import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:podsonly/ui/podcast_details.dart';
import 'providers/podcast_provider.dart';


class GenreScreen extends ConsumerWidget {
  final String genre;
  const GenreScreen({super.key, required this.genre});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final param = GenreParams(genre: genre, limit: 50);
    final genreAsync = ref.watch(genreProvider(param));
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(genre,
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  )),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          )),
      body: genreAsync.when(
          data: (genreData) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
              ),
              itemCount: genreData.items.length,
              itemBuilder: (context, index) {
                final item = genreData.items[index];
                return PodcastCard(
                  item: item,
                );
              },
            );
          },
          error: (e, _) => Container(),
          loading: () => const Center(
                child: CircularProgressIndicator.adaptive(),
              )),
    );
  }
}

class PodcastCard extends StatelessWidget {
  final Item item;
  const PodcastCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => PodcastDetails(item: item)),
        );
      },
      child: Container(
        color: Colors.grey[300],
        height: 200,
        width: 200,
        margin: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.network(
                item.artworkUrl600 ?? '',
                fit: BoxFit.cover,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        constraints:
                            BoxConstraints.loose(const Size.fromWidth(100)),
                        child: Text(
                          item.collectionName ?? '',
                          maxLines: 2,
                          // overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        constraints:
                            BoxConstraints.loose(const Size.fromWidth(100)),
                        child: Text(
                          item.artistName ?? '',
                          maxLines: 2,
                          // overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            letterSpacing: 0.2,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, right: 3),
                  child: Text('Ep: ${item.trackCount}'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
