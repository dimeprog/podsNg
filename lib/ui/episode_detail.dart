import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:podsonly/ui/podcast_details.dart';
import 'package:podsonly/ui/providers/audio_player_provider.dart';
import 'package:podsonly/ui/widgets/podcast_details_body.dart';
import 'package:rich_readmore/rich_readmore.dart';
import '../core/contants/image_strings.dart';

class EpisodeDetailScreen extends ConsumerStatefulWidget {
  final Episode episode;
  const EpisodeDetailScreen({super.key, required this.episode});

  @override
  ConsumerState<EpisodeDetailScreen> createState() =>
      _EpisodeDetailScreenState();
}

class _EpisodeDetailScreenState extends ConsumerState<EpisodeDetailScreen> {
  bool selected = false;
  @override
  Widget build(
    BuildContext context,
  ) {
    final audioPlayer = ref.watch(audioPlayerProvider);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          if (widget.episode.contentUrl == null) return;
          if (selected && audioPlayer.playing) {
            audioPlayer.pause();
            setState(() {
              selected = false;
            });
            return;
          }
          setState(() {
            selected = !selected;
          });
          audioPlayer.setUrl(widget.episode.contentUrl!);
          final audioSource = AudioSource.uri(
            Uri.parse(widget.episode.contentUrl ?? ''),
            tag: MediaItem(
              // Specify a unique ID for each media item:
              id: Key(widget.episode.guid).toString(),
              // Metadata to display in the notification:
              album: widget.episode.title,
              title: widget.episode.title,
              artUri: Uri.parse(getEpisodeImageUrl(widget.episode)),
            ),
          );
          audioPlayer.setAudioSource(audioSource);
          audioPlayer.play();
        },
        child:
            selected ? const Icon(Icons.pause) : const Icon(Icons.play_arrow),
      ),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Image Section
            EpisodeDetailImageSection(size: size, episode: widget.episode,),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                widget.episode.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.episode.duration == null
                      ? Container()
                      : Text(
                          '${widget.episode.duration!.inHours} hr ${widget.episode.duration!.inMinutes.remainder(60)} min',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                        ),
                  Text(
                    DateFormat.yMMMMd().format(
                        widget.episode.publicationDate ?? DateTime.now()),
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'About',
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: RichReadMoreText.fromString(
                        text: parseHtml(widget.episode.description),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        settings: LengthModeSettings(
                          trimLength: 500,
                          trimCollapsedText: 'Read more',
                          trimExpandedText: ' Read less ',
                          lessStyle:
                              const TextStyle(color: Colors.orangeAccent),
                          moreStyle:
                              const TextStyle(color: Colors.orangeAccent),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getEpisodeImageUrl(Episode episode) {
    return episode.imageUrl ??
        'https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg';
  }
}

class EpisodeDetailImageSection extends StatelessWidget {
  
  const EpisodeDetailImageSection({
    super.key,
    required this.size,
    required this.episode,
   
  });

  final Size size;
  final Episode episode;


  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.4,
      width: size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            episode.imageUrl ?? ImageString.defaultEpisodeUrl,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 50,
              width: size.width,
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
