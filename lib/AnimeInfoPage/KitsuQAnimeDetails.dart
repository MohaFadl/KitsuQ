import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import '../APIServices/GraphQLPain.dart';

class KitsuQAnimeDetails extends StatefulWidget {
  final Map anime;
  final bool isRomaji;

  const KitsuQAnimeDetails({super.key, required this.anime, required this.isRomaji});

  @override
  State<KitsuQAnimeDetails> createState() => _KitsuQAnimeDetailsState();
}

class _KitsuQAnimeDetailsState extends State<KitsuQAnimeDetails> {
  int? hoveredIndex;

  String get cleanedDescription {
    return widget.anime['description']?.replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&quot;', '"')
        .replaceAll('&rsquo;', "'")
        .replaceAll('&mdash;', '—')
        .replaceAll('&amp;', '&')
        .replaceAll('&hellip;', '...')
        .trim() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final coverUrl = widget.anime['coverImage']?['large'] ?? widget.anime['bannerImage'] ?? '';
    final title = widget.isRomaji
        ? widget.anime['title']['romaji'] ?? widget.anime['title']['english'] ?? "No Title"
        : widget.anime['title']['english'] ?? widget.anime['title']['romaji'] ?? "No Title";

    final isAnime = widget.anime['type'] == 'ANIME';

    return Scaffold(
      backgroundColor: const Color(0xff202020),
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AppBar(
              backgroundColor: Colors.black.withAlpha(10),
              elevation: 0,
              centerTitle: true,
              title: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: coverUrl.isNotEmpty
                ? Image.network(
              coverUrl,
              fit: BoxFit.cover,
            )
                : Container(color: Colors.black),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: Container(color: Colors.black.withAlpha(85)),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: kToolbarHeight + 40, bottom: 20),
            child: Column(
              children: [
                Hero(
                  tag: widget.anime['id'] ?? coverUrl,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: coverUrl.isNotEmpty
                        ? Image.network(
                      coverUrl,
                      width: 160,
                      height: 240,
                      fit: BoxFit.cover,
                    )
                        : Container(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(25),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cleanedDescription,
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        const SizedBox(height: 16),
                        if (widget.anime['startDate'] != null)
                          _InfoRow(
                            icon: Icons.calendar_today,
                            label:
                            "Start Date: ${widget.anime['startDate']?['year']}-${widget.anime['startDate']?['month']?.toString().padLeft(2, '0') ?? '01'}-${widget.anime['startDate']?['day']?.toString().padLeft(2, '0') ?? '01'}",
                          ),
                        if (widget.anime['status'] != null)
                          _InfoRow(
                            icon: Icons.tv,
                            label: "Status: ${widget.anime['status']?.toString().replaceAll('_', ' ')}",
                          ),
                        if (widget.anime['averageScore'] != null)
                          _InfoRow(
                            icon: Icons.star,
                            label: "Average Score: ${widget.anime['averageScore']} / 100",
                          ),
                        if (widget.anime['genres'] != null && widget.anime['genres'].isNotEmpty)
                          _InfoRow(
                            icon: Icons.category,
                            label: "Genres: ${widget.anime['genres'].join(', ')}",
                          ),
                        if (isAnime && widget.anime['episodes'] != null)
                          _InfoRow(
                            icon: Icons.video_library,
                            label: "Episodes: ${widget.anime['episodes']}",
                          ),
                        if (!isAnime && widget.anime['chapters'] != null)
                          _InfoRow(
                            icon: Icons.library_books,
                            label: "Chapters: ${widget.anime['chapters']}",
                          ),
                        if (!isAnime && widget.anime['volumes'] != null)
                          _InfoRow(
                            icon: Icons.library_books,
                            label: "Volumes: ${widget.anime['volumes']}",
                          ),
                        if (widget.anime['studios'] != null && widget.anime['studios']?['nodes']?.isNotEmpty ?? false)
                          _InfoRow(
                            icon: Icons.business,
                            label: "Studio: ${widget.anime['studios']?['nodes']?[0]?['name'] ?? 'N/A'}",
                          ),
                      ],
                    ),
                  ),
                ),
                if (widget.anime['recommendations'] != null &&
                    widget.anime['recommendations']?['nodes']?.isNotEmpty ?? false)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(widget.anime['episodes'] != null)const SizedBox(height: 30),
                        if(widget.anime['episodes'] != null)const Text(
                          "Episodes",
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        if(widget.anime['episodes'] != null)const SizedBox(height: 20),
                        if(widget.anime['episodes'] != null)Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: List.generate(widget.anime['episodes'], (index) {
                        final isHovered = hoveredIndex == index;

                        return Material(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {


                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                        const SizedBox(height: 50),
                        const Text(
                          "You might also like",
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        _buildRecommendationList(widget.anime['recommendations']?['nodes'] ?? []),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationList(List recommendations) {
    final validRecommendations = recommendations.where((recommendation) {
      try {
        final media = recommendation['mediaRecommendation'];
        return media != null && media['coverImage'] != null && media['title'] != null;
      } catch (e) {
        print("Invalid recommendation at index $recommendation: $e");
        return false;
      }
    }).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        const minCardWidth = 160.0;
        final crossAxisCount = (constraints.maxWidth / minCardWidth).floor();
        final cardWidth = constraints.maxWidth / crossAxisCount;
        final cardHeight = cardWidth * 2.9;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: validRecommendations.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 16,
            crossAxisSpacing: 12,
            childAspectRatio: cardWidth / cardHeight,
          ),
          itemBuilder: (context, index) {
            final recommendation = validRecommendations[index];
            final media = recommendation['mediaRecommendation'];
            final genres = media['genres'] as List? ?? [];
            final id = media['id'];

            return GestureDetector(
              onTap: () async {
                final id = recommendation['mediaRecommendation']['id'];

                try {
                  final client = await initGraphQLClient().value;
                  final animeDetails = await fetchAnimeDetails(id, client);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => KitsuQAnimeDetails(
                        anime: animeDetails,
                        isRomaji: true,
                      ),
                    ),
                  );
                } catch (e) {
                  if (kDebugMode) {
                    print("Error fetching anime details: $e");
                  }
                }

              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(30),
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        media['coverImage']?['extraLarge'] ?? media['coverImage']?['large'] ?? '',
                        width: double.infinity,
                        height: cardHeight * 0.55,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      media['title']?['romaji'] ?? media['title']?['english'] ?? "No Title",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if(media['averageScore'] != null)
                        const Icon(Icons.star, size: 12, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          "${media['averageScore'] ?? ''}",
                          style: const TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 4,
                      runSpacing: 2,
                      children: () {
                        if (genres.isNotEmpty) {
                          return genres.take(4).map<Widget>((genre) {
                            return Chip(
                              label: Text(
                                genre,
                                style: const TextStyle(fontSize: 10, color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                              backgroundColor: Colors.grey[800],
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                            );
                          }).toList();
                        } else {
                          return [Text("")];
                        }
                      }(),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.white70),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}
