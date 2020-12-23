class User {
  final String login;
  final String name;
  final String avatarUrl;
  final String email;
  final String bio;
  final String htmlUrl;
  final String company;
  final String publicRepo;
  final String following;
  final String followers;

  User(
      this.login,
      this.name,
      this.avatarUrl,
      this.email,
      this.bio,
      this.htmlUrl,
      this.company,
      this.publicRepo,
      this.following,
      this.followers);

  Map toJson() => {
        'login': login,
        'name': name,
        'avatar_url': avatarUrl,
        'email': email,
        'bio': bio,
        'html_url': htmlUrl,
        'company': company,
        'public_repos': publicRepo,
        'following': following,
        'followers': followers
      };

  User.fromJson(Map json)
      : login = json['login'],
        name = json['name'],
        avatarUrl = json['avatar_url'],
        email = json['email'],
        bio = json['bio'],
        htmlUrl = json['html_url'],
        company = json['company'],
        publicRepo = json['public_repos'].toString(),
        following = json['following'].toString(),
        followers = json['followers'].toString();
}
