class ScraperConfig {
  final List<String> movieFolders;
  final List<String> tvShowFolders;
  final List<String> excludeFolders;
  final List<String> videoExtensions;
  final bool useNfo;
  final String language;
  final bool autoMatch;
  final double matchThreshold;

  const ScraperConfig({
    this.movieFolders = const ['Movies', '电影'],
    this.tvShowFolders = const ['TV Shows', 'TV', '电视剧'],
    this.excludeFolders = const ['Extras', 'Featurettes', 'Behind The Scenes'],
    this.videoExtensions = const ['.mp4', '.mkv', '.avi', '.mov', '.wmv'],
    this.useNfo = true,
    this.language = 'zh-CN',
    this.autoMatch = true,
    this.matchThreshold = 0.8,
  });
}