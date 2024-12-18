class Reel {
  final String id, title, description, url;
  final int views, likes, comments, shares;
  final bool likesShown,
      commentsShown,
      sharesShown,
      viewsShown,
      commentsDisabled;

  const Reel({
    required this.id,
    required this.title,
    required this.description,
    required this.url,
    required this.views,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.likesShown,
    required this.commentsShown,
    required this.sharesShown,
    required this.viewsShown,
    required this.commentsDisabled,
  });

  factory Reel.fromJson(Map<String, dynamic> json) => Reel(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        url: json['url'],
        views: json['views'],
        likes: json['likes'],
        comments: json['comments'],
        shares: json['shares'],
        likesShown: json['likes_shown'],
        commentsShown: json['comments_shown'],
        sharesShown: json['shares_shown'],
        viewsShown: json['views_shown'],
        commentsDisabled: json['comments_disabled'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'url': url,
        'views': views,
        'likes': likes,
        'comments': comments,
        'shares': shares,
        'likes_shown': likesShown,
        'comments_shown': commentsShown,
        'shares_shown': sharesShown,
        'views_shown': viewsShown,
        'comments_disabled': commentsDisabled,
      };
}
