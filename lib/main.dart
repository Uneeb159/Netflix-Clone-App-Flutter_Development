import 'dart:async';
import 'dart:math';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(NetflixApp());
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();

    Timer(Duration(seconds: 3), () {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => MainScreen()));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                'NETFLIX',
                style: TextStyle(
                  color: Color(0xFFE50914),
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 8,
                ),
              ),
            ),
            SizedBox(height: 40),
            FadeTransition(
              opacity: _fadeAnimation,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE50914)),
                strokeWidth: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NetflixApp extends StatelessWidget {
  const NetflixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Netflix',
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFFE50914), // Netflix red
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black.withOpacity(0.9),
          elevation: 0,
        ),
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Content {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String logoUrl;
  final String videoUrl;
  final double rating;
  final int year;
  final String maturityRating;
  final int runtime;
  final List<String> genres;
  final List<String> cast;
  final String category;
  final bool isMovie;
  final int? seasons;

  Content({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.logoUrl,
    required this.videoUrl,
    required this.rating,
    required this.year,
    required this.maturityRating,
    required this.runtime,
    required this.genres,
    required this.cast,
    required this.category,
    required this.isMovie,
    this.seasons,
  });
}

class NetflixState extends InheritedWidget {
  final List<Content> content;
  final Set<String> myList;
  final Function(String) toggleMyList;
  final Function(Content) playContent;

  NetflixState({
    required this.content,
    required this.myList,
    required this.toggleMyList,
    required this.playContent,
    required Widget child,
  }) : super(child: child);

  static NetflixState? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<NetflixState>();
  }

  @override
  bool updateShouldNotify(NetflixState oldWidget) {
    return myList != oldWidget.myList;
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  Set<String> _myList = {};
  late List<Content> _content;

  @override
  void initState() {
    super.initState();
    _initializeContent();
    _loadMyList();
  }

  void _initializeContent() {
    _content = [
      // Featured/Trending Content
      Content(
        id: '1',
        title: 'Stranger Things',
        description:
            'When a young boy vanishes, a small town uncovers a mystery involving secret experiments, terrifying supernatural forces, and one strange little girl.',
        thumbnailUrl:
            'https://www.butlerbranding.com/wp-content/uploads/2018/05/Stranger-Things-thumbnail.jpg',
        logoUrl:
            'https://1000logos.net/wp-content/uploads/2019/06/Stranger-Things-logo.jpg',
        videoUrl: 'https://youtu.be/iKZyYdwS3Wg',
        rating: 8.7,
        year: 2016,
        maturityRating: 'TV-14',
        runtime: 51,
        genres: ['Sci-Fi', 'Horror', 'Drama'],
        cast: ['Winona Ryder', 'David Harbour', 'Finn Wolfhard'],
        category: 'trending',
        isMovie: false,
        seasons: 4,
      ),
      Content(
        id: '2',
        title: 'The Witcher',
        description:
            'Geralt of Rivia, a mutated monster-hunter for hire, journeys toward his destiny in a turbulent world where people often prove more wicked than beasts.',
        thumbnailUrl:
            'https://occ-0-8407-2219.1.nflxso.net/dnm/api/v6/Qs00mKCpRvrkl3HZAN5KwEL1kpE/AAAABZxG5qQeEr-Pod-FoL373Vptidyb5Geu25qr6aqpPUrSzqHUKCr1GsvxEM96qNCrvsGqFrEk0dnZB_0wZNT6kH1gntrW2mk5NYfyz8QWAwHV6abhwluxR-FbtQisKFen2qDp0g.webp?r=23e',
        logoUrl:
            'https://mir-s3-cdn-cf.behance.net/project_modules/1400/b6037c93472227.5e6769f0d9af7.png',
        videoUrl: 'https://youtu.be/ndl1W4ltcmg',
        rating: 8.2,
        year: 2019,
        maturityRating: 'TV-MA',
        runtime: 60,
        genres: ['Fantasy', 'Action', 'Adventure'],
        cast: ['Henry Cavill', 'Anya Chalotra', 'Freya Allan'],
        category: 'trending',
        isMovie: false,
        seasons: 3,
      ),
      Content(
        id: '3',
        title: 'Red Notice',
        description:
            'An Interpol agent tracks the world\'s most wanted art thief in this action-packed heist thriller.',
        thumbnailUrl: 'https://images3.alphacoders.com/132/1321315.jpeg',
        logoUrl:
            'https://mir-s3-cdn-cf.behance.net/project_modules/max_632_webp/22691f131845265.61ab7aacc9bec.png',
        videoUrl: 'https://youtu.be/Pj0wz7zu3Ms',
        rating: 6.4,
        year: 2021,
        maturityRating: 'PG-13',
        runtime: 118,
        genres: ['Action', 'Comedy', 'Crime'],
        cast: ['Dwayne Johnson', 'Ryan Reynolds', 'Gal Gadot'],
        category: 'netflix_originals',
        isMovie: true,
      ),
      Content(
        id: '4',
        title: 'The Queen\'s Gambit',
        description:
            'In a Kentucky orphanage in the 1950s, a young girl discovers an astonishing talent for chess while struggling with addiction.',
        thumbnailUrl:
            'https://baylorlariat.com/wp-content/uploads/2021/01/the-queens-gambit.jpg',
        logoUrl:
            'https://i.pinimg.com/736x/43/95/9a/43959ad21415f001b250b34a249972c2.jpg',
        videoUrl: 'https://youtu.be/oZn3qSgmLqI',
        rating: 8.5,
        year: 2020,
        maturityRating: 'TV-MA',
        runtime: 56,
        genres: ['Drama', 'Coming-of-Age'],
        cast: ['Anya Taylor-Joy', 'Bill Camp', 'Marielle Heller'],
        category: 'netflix_originals',
        isMovie: false,
        seasons: 1,
      ),
      Content(
        id: '5',
        title: 'Squid Game',
        description:
            'Hundreds of cash-strapped players accept a strange invitation to compete in children\'s games for a tempting prize.',
        thumbnailUrl:
            'https://wallpapers.com/images/featured/squid-game-fvsfw2qlkey7u5o8.jpg',
        logoUrl:
            'https://upload.wikimedia.org/wikipedia/commons/5/57/Squid_Game_2021_vector_logo_english.svg',
        videoUrl: 'https://youtu.be/oqxAJKy0ii4',
        rating: 8.0,
        year: 2021,
        maturityRating: 'TV-MA',
        runtime: 54,
        genres: ['Thriller', 'Drama', 'Action'],
        cast: ['Lee Jung-jae', 'Park Hae-soo', 'Wi Ha-jun'],
        category: 'trending',
        isMovie: false,
        seasons: 1,
      ),
      Content(
        id: '6',
        title: 'Money Heist',
        description:
            'An unusual group of robbers attempt to carry out the most perfect robbery in Spanish history - stealing 2.4 billion euros from the Royal Mint of Spain.',
        thumbnailUrl:
            'https://wallpapers.com/images/featured/money-heist-segtwbhffwy01w82.jpg',
        logoUrl:
            'https://static.vecteezy.com/system/resources/previews/010/503/928/non_2x/la-casa-de-papel-title-with-dali-mask-clothes-red-design-graphic-netflix-film-abstract-illustration-money-heist-in-black-background-free-vector.jpg',
        videoUrl: 'https://youtu.be/htBUDu9y52s',
        rating: 8.2,
        year: 2017,
        maturityRating: 'TV-MA',
        runtime: 67,
        genres: ['Crime', 'Drama', 'Thriller'],
        cast: ['Úrsula Corberó', 'Álvaro Morte', 'Itziar Ituño'],
        category: 'popular',
        isMovie: false,
        seasons: 5,
      ),
      Content(
        id: '7',
        title: '6 Underground',
        description:
            'After faking his death, a tech billionaire recruits a team of international operatives for a bold and bloody mission.',
        thumbnailUrl:
            'https://www.acmodasi.in/amdb/images/movie/c/2/6-underground-2019-66572.jpg',
        logoUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ8OcXcHpgRm2Lxcn-Wav_NvJHfcVKXFlXRKg&s',
        videoUrl: 'https://youtu.be/YLE85olJjp8',
        rating: 6.1,
        year: 2019,
        maturityRating: 'R',
        runtime: 128,
        genres: ['Action', 'Thriller'],
        cast: ['Ryan Reynolds', 'Mélanie Laurent', 'Manuel Garcia-Rulfo'],
        category: 'action',
        isMovie: true,
      ),
      Content(
        id: '8',
        title: 'The Crown',
        description:
            'This drama follows the political rivalries and romance of Queen Elizabeth II\'s reign and the events that shaped the second half of the 20th century.',
        thumbnailUrl:
            'https://resizing.flixster.com/uDQxXwdYS1K5V62ZVSx23RLmIrc=/fit-in/705x460/v2/https://resizing.flixster.com/-XZAfHZM39UwaGJIFWKAE8fS0ak=/v3/t/assets/p14453812_b_h10_aa.jpg',
        logoUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQObvCGoAr-WyY6h98kXOAMJFXvEC1ATHAboA&s',
        videoUrl: 'https://youtu.be/JWtnJjn6ng0',
        rating: 8.7,
        year: 2016,
        maturityRating: 'TV-MA',
        runtime: 58,
        genres: ['Drama', 'History', 'Biography'],
        cast: ['Claire Foy', 'Olivia Colman', 'Imelda Staunton'],
        category: 'netflix_originals',
        isMovie: false,
        seasons: 6,
      ),
      Content(
        id: '9',
        title: 'Extraction',
        description:
            'A hardened mercenary\'s mission becomes a soul-searching race to survive when he\'s sent to Bangladesh to rescue a drug lord\'s kidnapped son.',
        thumbnailUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSdXKGx1zezi9xvKshPDC7snomqQMcyQLFIZw&s',
        logoUrl:
            'https://static0.cbrimages.com/wordpress/wp-content/uploads/sharedimages/2025/02/extraction-placeholder-poster.jpg',
        videoUrl: 'https://your-video-link.com/extraction.mp4', // ← EDIT THIS
        rating: 6.7,
        year: 2020,
        maturityRating: 'R',
        runtime: 116,
        genres: ['Action', 'Thriller'],
        cast: ['Chris Hemsworth', 'Rudhraksh Jaiswal', 'Randeep Hooda'],
        category: 'action',
        isMovie: true,
      ),
      Content(
        id: '10',
        title: 'Dark',
        description:
            'A missing child causes four families to help each other for answers and force them to enter a web of mysterious events.',
        thumbnailUrl:
            'https://resizing.flixster.com/oZOpwImPeG1OaFQaH3EA1rYpQbM=/fit-in/705x460/v2/https://resizing.flixster.com/-XZAfHZM39UwaGJIFWKAE8fS0ak=/v3/t/assets/p14652182_b_h9_aa.jpg',
        logoUrl:
            'https://w0.peakpx.com/wallpaper/803/135/HD-wallpaper-dark-logo-dark-netflix-dark-season-dark-web-series-german-sci-fi-thriller.jpg',
        videoUrl: 'https://your-video-link.com/dark.mp4', // ← EDIT THIS
        rating: 8.8,
        year: 2017,
        maturityRating: 'TV-MA',
        runtime: 60,
        genres: ['Sci-Fi', 'Mystery', 'Drama'],
        cast: ['Louis Hofmann', 'Lisa Vicari', 'Maja Schöne'],
        category: 'sci_fi',
        isMovie: false,
        seasons: 3,
      ),
      Content(
        id: '11',
        title: 'Bird Box',
        description:
            'Five years after an ominous unseen presence drives most of society to suicide, a mother and her two children make a desperate bid for safety.',
        thumbnailUrl:
            'https://m.media-amazon.com/images/M/MV5BZDkzZWQ1YjctNTUyZi00NmM4LTljNTEtNWFiMzQwM2YzNGZiXkEyXkFqcGc@._V1_.jpg',
        logoUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRQ-f7O3NgKS3r21K0d1iDQuEuyPdJIdwx_uw&s',
        videoUrl: 'https://your-video-link.com/bird-box.mp4', // ← EDIT THIS
        rating: 6.6,
        year: 2018,
        maturityRating: 'R',
        runtime: 124,
        genres: ['Horror', 'Thriller', 'Drama'],
        cast: ['Sandra Bullock', 'Trevante Rhodes', 'John Malkovich'],
        category: 'thriller',
        isMovie: true,
      ),
      Content(
        id: '12',
        title: 'Ozark',
        description:
            'A financial advisor drags his family from Chicago to the Missouri Ozarks, where he must launder money to appease a drug boss.',
        thumbnailUrl:
            'https://aspiringhumanshazam.wordpress.com/wp-content/uploads/2020/09/ozark-5f06e23a514d5.jpg',
        logoUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS790HM1oNfCq28EMktkqOtQzX-ohrs9NneZA&s',
        rating: 8.4,
        year: 2017,
        maturityRating: 'TV-MA',
        runtime: 60,
        genres: ['Crime', 'Drama', 'Thriller'],
        cast: ['Jason Bateman', 'Laura Linney', 'Sofia Hublitz'],
        category: 'popular',
        isMovie: false,
        seasons: 4,
        videoUrl: 'https://your-video-link.com/ozark.mp4', // ← EDIT THIS
      ),
      // More Netflix Originals
      Content(
        id: '13',
        title: 'Wednesday',
        description:
            'Smart, sarcastic and a little dead inside, Wednesday Addams investigates a murder spree while making new friends at Nevermore Academy.',
        thumbnailUrl:
            'https://resizing.flixster.com/LumPRA7tw5a4VtKzSnGnTWpW2Q8=/ems.cHJkLWVtcy1hc3NldHMvdHZzZXJpZXMvNTlmOGIyM2ItMzRhMy00MjdkLThkNDYtZWJkZDI1ODMzNmI3LmpwZw==',
        logoUrl:
            'https://res.cloudinary.com/jerrick/image/upload/c_scale,f_jpg,q_auto/6478e76ead0f68001d405bab.jpg',
        rating: 8.1,
        year: 2022,
        maturityRating: 'TV-14',
        runtime: 51,
        genres: ['Comedy', 'Crime', 'Family'],
        cast: ['Jenna Ortega', 'Hunter Doohan', 'Percy Hynes White'],
        category: 'trending',
        isMovie: false,
        seasons: 1,
        videoUrl: 'https/',
      ),
      Content(
        id: '14',
        title: 'The Gray Man',
        description:
            'When the CIA\'s most skilled operative-whose true identity is known to none-accidentally uncovers dark agency secrets, he becomes a primary target.',
        thumbnailUrl:
            'https://www.tvguide.com/a/img/catalog/provider/2/13/2-9f19da437839c217f5b186d2a3de0bf8.jpg',
        logoUrl: 'https://d3q27bh1u24u2o.cloudfront.net/news/gray_man.png',
        rating: 6.5,
        year: 2022,
        maturityRating: 'PG-13',
        runtime: 129,
        genres: ['Action', 'Thriller'],
        cast: ['Ryan Gosling', 'Chris Evans', 'Ana de Armas'],
        category: 'netflix_originals',
        isMovie: true,
        videoUrl: 'http',
      ),
      Content(
        id: '15',
        title: 'Cobra Kai',
        description:
            'Decades after the tournament that changed their lives, the rivalry between Johnny and Daniel reignites in this sequel to the Karate Kid films.',
        thumbnailUrl:
            'https://images.squarespace-cdn.com/content/v1/63f801ba5d82947c2340fc01/99c58421-0602-4751-8abb-00b1acc98218/https___fansided.com_files_2018_05_cobra-kai-thumbnail.jpg',
        logoUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS8R-O68ldhRbf7ot3EJJfCQRVQ5xhOabScyA&s',
        rating: 8.5,
        year: 2018,
        maturityRating: 'TV-14',
        runtime: 30,
        genres: ['Action', 'Comedy', 'Drama'],
        cast: ['Ralph Macchio', 'William Zabka', 'Courtney Henggeler'],
        category: 'popular',
        isMovie: false,
        seasons: 6,
        videoUrl: 'http',
      ),
      Content(
        id: '16',
        title: 'Glass Onion: A Knives Out Mystery',
        description:
            'Tech billionaire Miles Bron invites his friends for a getaway on his private Greek island. When someone turns up dead, Detective Benoit Blanc is put on the case.',
        thumbnailUrl:
            'https://maxblizz.com/wp-content/uploads/2023/03/Glass-Onion-A-Knives-Out-Mystery.jpg',
        logoUrl:
            'https://deadline.com/wp-content/uploads/2023/01/glass-onion-logo-rian-johnson.jpg?w=681&h=383&crop=1',
        rating: 7.2,
        year: 2022,
        maturityRating: 'PG-13',
        runtime: 139,
        genres: ['Comedy', 'Crime', 'Drama'],
        cast: ['Daniel Craig', 'Edward Norton', 'Janelle Monáe'],
        category: 'netflix_originals',
        isMovie: true,
        videoUrl: 'http',
      ),
      Content(
        id: '17',
        title: 'The Umbrella Academy',
        description:
            'A dysfunctional family of superheroes comes together to solve the mystery of their father\'s death, the threat of the apocalypse and more.',
        thumbnailUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRHtZ_DF1raJkkwRE7b1TA7Y_JOFnFDIaIQXg&s',
        logoUrl:
            'https://upload.wikimedia.org/wikipedia/commons/8/86/The_Umbrella_Academy_logo.svg',
        rating: 7.9,
        year: 2019,
        maturityRating: 'TV-14',
        runtime: 60,
        genres: ['Action', 'Adventure', 'Comedy'],
        cast: ['Elliot Page', 'Tom Hopper', 'David Castañeda'],
        category: 'netflix_originals',
        isMovie: false,
        seasons: 4,
        videoUrl: 'http',
      ),
      Content(
        id: '18',
        title: 'Enola Holmes',
        description:
            'While searching for her missing mother, intrepid teen Enola Holmes uses her sleuthing skills to outsmart big brother Sherlock and help a runaway lord.',
        thumbnailUrl:
            'https://cf.geekdo-images.com/f0TUlXNhjfQIcHgpRjK0cA__opengraph/img/DA3kJq8PhGJ246lCtNu7pzVMcw0=/fit-in/1200x630/filters:strip_icc()/pic7027477.jpg',
        logoUrl:
            'https://static.wikia.nocookie.net/logopedia/images/c/c4/Enola_Holmes_logo.png/revision/latest?cb=20201004222450',
        rating: 6.6,
        year: 2020,
        maturityRating: 'PG-13',
        runtime: 123,
        genres: ['Adventure', 'Crime', 'Drama'],
        cast: ['Millie Bobby Brown', 'Henry Cavill', 'Sam Claflin'],
        category: 'netflix_originals',
        isMovie: true,
        videoUrl: 'htpp',
      ),
      Content(
        id: '19',
        title: 'All Quiet on the Western Front',
        description:
            'A young German soldier\'s terrifying experiences and distress on the western front during World War I.',
        thumbnailUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQYrP0zUgV2lM83hpXmyaPA9snoPwYqG4yBaQ&s',
        logoUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcScNgLbSsnSuNvaR59SkqaGIgd7Fe8J5H07OQ&s',
        rating: 7.8,
        year: 2022,
        maturityRating: 'R',
        runtime: 148,
        genres: ['Action', 'Drama', 'War'],
        cast: ['Felix Kammerer', 'Albrecht Schuch', 'Aaron Hilmer'],
        category: 'netflix_originals',
        isMovie: true,
        videoUrl: 'http',
      ),
      Content(
        id: '20',
        title: 'Bridgerton',
        description:
            'Wealth, lust, and betrayal set in the backdrop of Regency era England, seen through the eyes of the powerful Bridgerton family.',
        thumbnailUrl:
            'https://etvbharatimages.akamaized.net/etvbharat/prod-images/768-512-14693904-thumbnail-3x2-brid.jpg',
        logoUrl:
            'https://i.pinimg.com/736x/91/53/9c/91539c36466e4aab8eb60a6d57b2cab0.jpg',
        rating: 7.3,
        year: 2020,
        maturityRating: 'TV-MA',
        runtime: 60,
        genres: ['Drama', 'Romance'],
        cast: ['Nicola Coughlan', 'Jonathan Bailey', 'Luke Newton'],
        category: 'popular',
        isMovie: false,
        seasons: 3,
        videoUrl: 'http',
      ),
      Content(
        id: '21',
        title: 'Army of the Dead',
        description:
            'Following a zombie outbreak in Las Vegas, a group of mercenaries take the ultimate gamble, venturing into the quarantine zone to pull off the greatest heist ever attempted.',
        thumbnailUrl: 'https://images7.alphacoders.com/114/1148029.jpg',
        logoUrl:
            'https://upload.wikimedia.org/wikipedia/it/thumb/d/d0/Army_of_the_Dead.jpg/1200px-Army_of_the_Dead.jpg',
        rating: 5.8,
        year: 2021,
        maturityRating: 'R',
        runtime: 148,
        genres: ['Action', 'Crime', 'Horror'],
        cast: ['Dave Bautista', 'Ella Purnell', 'Omari Hardwick'],
        category: 'action',
        isMovie: true,
        videoUrl: 'htpp',
      ),
      Content(
        id: '22',
        title: 'The Witcher: Nightmare of the Wolf',
        description:
            'Escaping from poverty to become a witcher, Vesemir slays monsters for coin and glory, but when a new menace rises, he must face the demons of his past.',
        thumbnailUrl:
            'https://i.ytimg.com/vi/TxHVVRNjUFQ/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLASh8sNJTgSYEPf3pOy1F-mWNNFhA',
        logoUrl: 'https://i.ytimg.com/vi/l8587MnA-zc/maxresdefault.jpg',
        rating: 7.2,
        year: 2021,
        maturityRating: 'TV-MA',
        runtime: 83,
        genres: ['Animation', 'Action', 'Adventure'],
        cast: ['Theo James', 'Mary McDonnell', 'Lara Pulver'],
        category: 'netflix_originals',
        isMovie: true,
        videoUrl: 'http',
      ),
      Content(
        id: '23',
        title: 'Emily in Paris',
        description:
            'A young American woman from the Midwest is hired by a marketing firm in Paris to provide them with an American perspective on things.',
        thumbnailUrl:
            'https://ntvb.tmsimg.com/assets/p18761121_b_h8_am.jpg?w=960&h=540',
        logoUrl:
            'https://i.pinimg.com/736x/cc/0c/8b/cc0c8b504aceabe3f63344a333e8fe5c.jpg',
        rating: 6.8,
        year: 2020,
        maturityRating: 'TV-MA',
        runtime: 30,
        genres: ['Comedy', 'Drama', 'Romance'],
        cast: ['Lily Collins', 'Philippine Leroy-Beaulieu', 'Ashley Park'],
        category: 'popular',
        isMovie: false,
        seasons: 4,
        videoUrl: 'http',
      ),
      Content(
        id: '24',
        title: 'The Adam Project',
        description:
            'A time-traveling pilot teams up with his younger self and his late father to come to terms with his past while saving the future.',
        thumbnailUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSnk9ZGMNg_8su3sPp2ymUyZVbjs8U2FUGxdg&s',
        logoUrl:
            'https://wallpapers.com/images/featured/the-adam-project-1twoin7993y18mi8.jpg',
        rating: 6.7,
        year: 2022,
        maturityRating: 'PG-13',
        runtime: 106,
        genres: ['Action', 'Adventure', 'Comedy'],
        cast: ['Ryan Reynolds', 'Walker Scobell', 'Mark Ruffalo'],
        category: 'netflix_originals',
        isMovie: true,
        videoUrl: 'http',
      ),
    ];
  }

  Future<void> _loadMyList() async {
    final prefs = await SharedPreferences.getInstance();
    final myListData = prefs.getStringList('netflix_my_list') ?? [];
    setState(() {
      _myList = myListData.toSet();
    });
  }

  Future<void> _saveMyList() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('netflix_my_list', _myList.toList());
  }

  void _toggleMyList(String contentId) {
    setState(() {
      if (_myList.contains(contentId)) {
        _myList.remove(contentId);
      } else {
        _myList.add(contentId);
      }
    });
    _saveMyList();
  }

  void _playContent(Content content) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PlayerScreen(content: content)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NetflixState(
      content: _content,
      myList: _myList,
      toggleMyList: _toggleMyList,
      playContent: _playContent,
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: [
            HomeScreen(),
            SearchScreen(),
            ComingSoonScreen(),
            DownloadsScreen(),
            MoreScreen(),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.8),
                Colors.black,
              ],
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey[600],
            selectedFontSize: 10,
            unselectedFontSize: 10,
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 24),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search, size: 24),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.video_library, size: 24),
                label: 'Coming Soon',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.download, size: 24),
                label: 'Downloads',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu, size: 24),
                label: 'More',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _heroController;
  late Timer _autoScrollTimer;
  int _currentHeroIndex = 0;

  @override
  void initState() {
    super.initState();
    _heroController = PageController();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(Duration(seconds: 6), (timer) {
      final netflixState = NetflixState.of(context);
      if (netflixState != null && _heroController.hasClients) {
        final trendingContent = netflixState.content
            .where((c) => c.category == 'trending')
            .toList();
        final nextIndex = (_currentHeroIndex + 1) % trendingContent.length;
        _heroController.animateToPage(
          nextIndex,
          duration: Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer.cancel();
    _heroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final netflixState = NetflixState.of(context);
    if (netflixState == null) {
      return Center(child: CircularProgressIndicator());
    }
    final trendingContent = netflixState.content
        .where((c) => c.category == 'trending')
        .toList();
    final netflixOriginalsContent = netflixState.content
        .where((c) => c.category == 'netflix_originals')
        .toList();
    final popularContent = netflixState.content
        .where((c) => c.category == 'popular')
        .toList();
    final actionContent = netflixState.content
        .where((c) => c.category == 'action')
        .toList();
    final myListContent = netflixState.content
        .where((c) => netflixState.myList.contains(c.id))
        .toList();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Stack(
            children: [
              // Hero carousel
              Container(
                height: MediaQuery.of(context).size.height * 0.75,
                child: PageView.builder(
                  controller: _heroController,
                  onPageChanged: (index) =>
                      setState(() => _currentHeroIndex = index),
                  itemCount: trendingContent.length,
                  itemBuilder: (context, index) {
                    final content = trendingContent[index];
                    return HeroContentCard(content: content);
                  },
                ),
              ),
              // Netflix logo and navigation
              Positioned(
                top: MediaQuery.of(context).padding.top + 10,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'NETFLIX',
                        style: TextStyle(
                          color: Color(0xFFE50914),
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.cast,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: () {},
                          ),
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              SizedBox(height: 20),
              // My List section
              if (myListContent.isNotEmpty)
                ContentCarousel(title: 'My List', content: myListContent),
              SizedBox(height: 20),
              // Netflix Originals
              ContentCarousel(
                title: 'Netflix Originals',
                content: netflixOriginalsContent,
                isNetflixOriginals: true,
              ),
              SizedBox(height: 20),
              // Trending Now
              ContentCarousel(title: 'Trending Now', content: trendingContent),
              SizedBox(height: 20),
              // Popular on Netflix
              ContentCarousel(
                title: 'Popular on Netflix',
                content: popularContent,
              ),
              SizedBox(height: 20),
              // Action Movies
              ContentCarousel(title: 'Action Movies', content: actionContent),
              SizedBox(height: 20),
              // Continue Watching (Mock)
              ContentCarousel(
                title: 'Continue Watching for User',
                content: netflixState.content.take(4).toList(),
              ),
              SizedBox(height: 20),
              // Because you watched
              ContentCarousel(
                title: 'Because you watched Stranger Things',
                content: netflixState.content
                    .where(
                      (c) =>
                          c.genres.contains('Sci-Fi') ||
                          c.genres.contains('Horror'),
                    )
                    .take(6)
                    .toList(),
              ),
              SizedBox(height: 20),
              // Top 10 in Your Country
              ContentCarousel(
                title: 'Top 10 in Your Country Today',
                content: popularContent.take(10).toList(),
              ),
              SizedBox(height: 100),
            ],
          ),
        ),
      ],
    );
  }
}

class HeroContentCard extends StatelessWidget {
  final Content content;

  const HeroContentCard({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final netflixState = NetflixState.of(context);
    if (netflixState == null) {
      return Center(child: CircularProgressIndicator());
    }
    final isInMyList = netflixState.myList.contains(content.id);

    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(content.thumbnailUrl),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3),
                BlendMode.darken,
              ),
            ),
          ),
        ),
        // Gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.5, 1.0],
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.1),
                Colors.black.withOpacity(0.9),
              ],
            ),
          ),
        ),
        // Content overlay
        Positioned(
          bottom: 120,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Content logo/title
              Container(
                height: 80,
                child: Image.network(
                  content.logoUrl,
                  fit: BoxFit.contain,
                  alignment: Alignment.centerLeft,
                  errorBuilder: (context, error, stackTrace) {
                    return Text(
                      content.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.8),
                            offset: Offset(2, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 15),
              // Genres
              Text(
                content.genres.join(' • '),
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 20),
              // Action buttons
              Row(
                children: [
                  // Play button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => netflixState.playContent(content),
                      icon: Icon(
                        Icons.play_arrow,
                        color: Colors.black,
                        size: 28,
                      ),
                      label: Text(
                        'Play',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  // My List button
                  ElevatedButton.icon(
                    onPressed: () => netflixState.toggleMyList(content.id),
                    icon: Icon(
                      isInMyList ? Icons.check : Icons.add,
                      color: Colors.white,
                      size: 22,
                    ),
                    label: Text(
                      'My List',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: (Colors.grey[850] ?? Colors.grey)
                          .withOpacity(0.8),
                      padding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  // Info button
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ContentDetailScreen(content: content),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.info_outline,
                      color: Colors.white,
                      size: 28,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: (Colors.grey[850] ?? Colors.grey)
                          .withOpacity(0.8),
                      padding: EdgeInsets.all(12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ContentCarousel extends StatelessWidget {
  final String title;
  final List<Content> content;
  final bool isNetflixOriginals;

  const ContentCarousel({
    Key? key,
    required this.title,
    required this.content,
    this.isNetflixOriginals = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 12),
        Container(
          height: isNetflixOriginals ? 160 : 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 12),
            itemCount: content.length,
            itemBuilder: (context, index) {
              return ContentThumbnail(
                content: content[index],
                isNetflixOriginal: isNetflixOriginals,
              );
            },
          ),
        ),
      ],
    );
  }
}

class ContentThumbnail extends StatefulWidget {
  final Content content;
  final bool isNetflixOriginal;

  const ContentThumbnail({
    Key? key,
    required this.content,
    this.isNetflixOriginal = false,
  }) : super(key: key);

  @override
  _ContentThumbnailState createState() => _ContentThumbnailState();
}

class _ContentThumbnailState extends State<ContentThumbnail> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final width = widget.isNetflixOriginal ? 110.0 : 130.0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                ContentDetailScreen(content: widget.content),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
          ),
        );
      },
      onTapDown: (_) => setState(() => _isHovered = true),
      onTapUp: (_) => setState(() => _isHovered = false),
      onTapCancel: () => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 0.95 : 1.0,
        duration: Duration(milliseconds: 150),
        child: Container(
          width: width,
          margin: EdgeInsets.symmetric(horizontal: 4),
          child: Hero(
            tag: 'content_${widget.content.id}',
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  widget.content.thumbnailUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[800],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.movie, size: 30, color: Colors.white54),
                          SizedBox(height: 4),
                          Text(
                            widget.content.title,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ContentDetailScreen extends StatelessWidget {
  final Content content;

  const ContentDetailScreen({Key? key, required this.content})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final netflixState = NetflixState.of(context);
    if (netflixState == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Loading...')),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final isInMyList = netflixState.myList.contains(content.id);
    final similarContent = netflixState.content
        .where(
          (c) =>
              c.id != content.id &&
              c.genres.any((g) => content.genres.contains(g)),
        )
        .take(10)
        .toList();

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'content_${content.id}',
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      content.thumbnailUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[800],
                          child: Icon(
                            Icons.movie,
                            size: 100,
                            color: Colors.white54,
                          ),
                        );
                      },
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.8),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    content.title,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red[700],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${(content.rating * 10).toInt()}% Match',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        content.year.toString(),
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      SizedBox(width: 12),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white54),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Text(
                          content.maturityRating,
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ),
                      SizedBox(width: 12),
                      if (!content.isMovie) ...[
                        Text(
                          '${content.seasons} Season${(content.seasons ?? 1) > 1 ? 's' : ''}',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ] else ...[
                        Text(
                          '${content.runtime}m',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ],
                      Spacer(),
                      Icon(Icons.hd, color: Colors.white70),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => netflixState.playContent(content),
                          icon: Icon(
                            Icons.play_arrow,
                            color: Colors.black,
                            size: 28,
                          ),
                          label: Text(
                            'Play',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Mock download
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Download started for ${content.title}',
                              ),
                              backgroundColor: Colors.grey[800],
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.download,
                          color: Colors.white,
                          size: 22,
                        ),
                        label: Text(
                          'Download',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[850]!.withOpacity(0.8),
                          padding: EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      // My List button
                      Column(
                        children: [
                          IconButton(
                            onPressed: () =>
                                netflixState.toggleMyList(content.id),
                            icon: Icon(
                              isInMyList ? Icons.check : Icons.add,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          Text(
                            'My List',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 40),
                      // Rate button
                      Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              // Mock rate
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Thanks for rating!'),
                                  backgroundColor: Colors.grey[800],
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.thumb_up_outlined,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          Text(
                            'Rate',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 40),
                      // Share button
                      Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              // Mock share
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Shared ${content.title}'),
                                  backgroundColor: Colors.grey[800],
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.share,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          Text(
                            'Share',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Text(
                    content.description,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Genres
                  Wrap(
                    spacing: 8,
                    children: content.genres
                        .map(
                          (genre) => Chip(
                            label: Text(genre, style: TextStyle(fontSize: 12)),
                            backgroundColor: Colors.grey[800],
                            labelStyle: TextStyle(color: Colors.white),
                            side: BorderSide.none,
                          ),
                        )
                        .toList(),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Cast: ${content.cast.join(', ')}',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  SizedBox(height: 30),
                  // More Like This section
                  if (similarContent.isNotEmpty) ...[
                    Text(
                      'More Like This',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 15),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: math.min(similarContent.length, 6),
                      itemBuilder: (context, index) {
                        final similarItem = similarContent[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ContentDetailScreen(content: similarItem),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.network(
                                similarItem.thumbnailUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[800],
                                    child: Icon(
                                      Icons.movie,
                                      size: 30,
                                      color: Colors.white54,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                  SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Content> _filteredContent = [];
  bool _showPopularContent = true;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final netflixState = NetflixState.of(context);
    if (netflixState != null) {
      final query = _searchController.text.toLowerCase();
      setState(() {
        _showPopularContent = query.isEmpty;
        if (query.isNotEmpty) {
          _filteredContent = netflixState.content
              .where(
                (content) =>
                    content.title.toLowerCase().contains(query) ||
                    content.genres.any(
                      (genre) => genre.toLowerCase().contains(query),
                    ) ||
                    content.cast.any(
                      (actor) => actor.toLowerCase().contains(query),
                    ),
              )
              .toList();
        }
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final netflixState = NetflixState.of(context);
    if (netflixState == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final popularContent = netflixState.content
        .where((c) => c.category == 'popular' || c.category == 'trending')
        .toList();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search for shows, movies, genres, etc.',
                  hintStyle: TextStyle(color: Colors.white54),
                  prefixIcon: Icon(Icons.search, color: Colors.white54),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.white54),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _showPopularContent = true;
                              _filteredContent = [];
                            });
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                autofocus: false,
              ),
            ),
            // Content
            Expanded(
              child: _showPopularContent
                  ? _buildPopularContent(popularContent)
                  : _filteredContent.isEmpty
                  ? _buildNoResults()
                  : _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularContent(List<Content> popularContent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Popular Searches',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: popularContent.length,
            itemBuilder: (context, index) {
              final content = popularContent[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ContentDetailScreen(content: content),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 120,
                        height: 68,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            content.thumbnailUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[800],
                                child: Icon(
                                  Icons.movie,
                                  size: 30,
                                  color: Colors.white54,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          content.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.play_circle_outline,
                        color: Colors.white,
                        size: 28,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.7,
      ),
      itemCount: _filteredContent.length,
      itemBuilder: (context, index) {
        final content = _filteredContent[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ContentDetailScreen(content: content),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                content.thumbnailUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[800],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.movie, size: 30, color: Colors.white54),
                        SizedBox(height: 4),
                        Text(
                          content.title,
                          style: TextStyle(color: Colors.white70, fontSize: 10),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.white54),
          SizedBox(height: 16),
          Text(
            'No results found',
            style: TextStyle(color: Colors.white54, fontSize: 18),
          ),
          SizedBox(height: 8),
          Text(
            'Try searching with different keywords',
            style: TextStyle(color: Colors.white38, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final netflixState = NetflixState.of(context);
    if (netflixState == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final comingSoonContent = netflixState.content
        .take(6)
        .toList(); // Mock coming soon content

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Coming Soon',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            // Content list
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: comingSoonContent.length,
                itemBuilder: (context, index) {
                  final content = comingSoonContent[index];
                  return ComingSoonCard(content: content);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ComingSoonCard extends StatelessWidget {
  final Content content;

  const ComingSoonCard({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final netflixState = NetflixState.of(context);
    if (netflixState == null) {
      return Container(
        margin: EdgeInsets.only(bottom: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    final isInMyList = netflixState.myList.contains(content.id);

    return Container(
      margin: EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    content.thumbnailUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[800],
                        child: Icon(
                          Icons.movie,
                          size: 50,
                          color: Colors.white54,
                        ),
                      );
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  // Netflix logo
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Text(
                      'NETFLIX',
                      style: TextStyle(
                        color: Color(0xFFE50914),
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          // Title and info
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      content.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Coming ${DateTime.now().add(Duration(days: Random().nextInt(90))).day}/${DateTime.now().add(Duration(days: Random().nextInt(90))).month}',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              // Remind Me button
              Column(
                children: [
                  IconButton(
                    onPressed: () => netflixState.toggleMyList(content.id),
                    icon: Icon(
                      isInMyList
                          ? Icons.notifications
                          : Icons.notifications_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  Text(
                    'Remind Me',
                    style: TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                ],
              ),
              SizedBox(width: 20),
              // Info button
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ContentDetailScreen(content: content),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.info_outline,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  Text(
                    'Info',
                    style: TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12),
          // Description
          Text(
            content.description,
            style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 8),
          // Genres
          Text(
            content.genres.join(' • '),
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class DownloadsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Downloads',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.cast, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            // Smart Downloads info
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.settings, color: Colors.white),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Smart Downloads',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'ON',
                          style: TextStyle(color: Colors.blue, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: true,
                    onChanged: (value) {},
                    activeColor: Colors.blue,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Empty downloads message
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.download_outlined,
                      size: 50,
                      color: Colors.white54,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'No downloads yet',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'Movies and TV shows that you download appear here.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to browse content
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      'Find Something to Download',
                      style: TextStyle(fontWeight: FontWeight.bold),
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

class MoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile header
              Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.person, color: Colors.white, size: 30),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'User',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Switch Profiles',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.grey[800], thickness: 1),
              // Menu items
              _buildMenuItem(
                Icons.notifications_outlined,
                'Notifications',
                () {},
              ),
              _buildMenuItem(Icons.download_outlined, 'My Downloads', () {}),
              _buildMenuItem(Icons.star_border, 'App Settings', () {}),
              _buildMenuItem(Icons.account_circle_outlined, 'Account', () {}),
              _buildMenuItem(Icons.help_outline, 'Help', () {}),
              _buildMenuItem(Icons.logout, 'Sign Out', () {}),
              SizedBox(height: 40),
              // App info
              Text(
                'Version 2.1.0',
                style: TextStyle(color: Colors.white54, fontSize: 14),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 24),
      title: Text(title, style: TextStyle(color: Colors.white, fontSize: 16)),
      trailing: Icon(Icons.chevron_right, color: Colors.white54),
      onTap: onTap,
    );
  }
}

class PlayerScreen extends StatefulWidget {
  final Content content;

  const PlayerScreen({Key? key, required this.content}) : super(key: key);

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  bool _isPlaying = true;
  bool _showControls = true;
  double _progress = 0.0;
  Timer? _hideControlsTimer;
  Timer? _progressTimer;
  late WebViewController _webViewController;
  bool _useWebView = false;

  @override
  void initState() {
    super.initState();
    _startHideControlsTimer();
    _startProgressTimer();
    _initializeWebView();
  }

  void _initializeWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
        ),
      );
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _showControls = false);
      }
    });
  }

  void _startProgressTimer() {
    _progressTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (_isPlaying && _progress < 1.0) {
        setState(() => _progress += 0.002);
      }
    });
  }

  void _toggleControls() {
    setState(() => _showControls = !_showControls);
    if (_showControls) {
      _startHideControlsTimer();
    }
  }

  void _togglePlayPause() {
    setState(() => _isPlaying = !_isPlaying);
    _startHideControlsTimer();
  }

  Future<void> _launchVideo(String? videoUrl) async {
    if (videoUrl == null ||
        videoUrl.isEmpty ||
        videoUrl == 'http' ||
        videoUrl == 'htpp' ||
        videoUrl == 'https/' ||
        videoUrl.startsWith('https://your-video-link.com')) {
      _showVideoUrlDialog();
      return;
    }

    if (!mounted) return;

    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.grey[900],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Colors.red),
              SizedBox(height: 16),
              Text('Opening video...', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      );

      final Uri url = Uri.parse(videoUrl);

      // Check if it's a YouTube URL and convert to proper format
      String finalUrl = videoUrl;
      if (videoUrl.contains('youtu.be/')) {
        final videoId = videoUrl.split('youtu.be/')[1].split('?')[0];
        finalUrl = 'https://www.youtube.com/watch?v=$videoId';
      } else if (videoUrl.contains('youtube.com/watch')) {
        finalUrl = videoUrl;
      }

      final Uri finalUri = Uri.parse(finalUrl);

      if (mounted) Navigator.pop(context); // Close loading dialog

      // Try to launch in external app first
      if (await canLaunchUrl(finalUri)) {
        await launchUrl(finalUri, mode: LaunchMode.externalApplication);
      } else {
        // Fallback to WebView
        _showWebView(finalUrl);
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog if open
        _showErrorDialog('Error launching video: $e');
      }
    }
  }

  void _showWebView(String videoUrl) {
    setState(() {
      _useWebView = true;
    });
    _webViewController.loadRequest(Uri.parse(videoUrl));
  }

  void _showErrorDialog(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text('Error', style: TextStyle(color: Colors.white)),
        content: Text(message, style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showVideoUrlDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text('Video Player', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Video for: ${widget.content.title}',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 15),
            Text(
              'Current URL: ${widget.content.videoUrl ?? "Not set"}',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Text(
                'To add video links:\n\n1. Find the video URL in the code\n2. Look for "videoUrl:" in the Content objects\n3. Replace with your video link\n\nExample: "https://youtu.be/your-video-id"',
                style: TextStyle(color: Colors.orange, fontSize: 12),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showVideoUrlInput();
            },
            child: Text('Add URL', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showVideoUrlInput() {
    final TextEditingController urlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text('Add Video URL', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: urlController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter video URL (YouTube, etc.)',
                hintStyle: TextStyle(color: Colors.white54),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Example: https://youtu.be/dQw4w9WgXcQ',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (urlController.text.isNotEmpty) {
                _launchVideo(urlController.text);
              }
            },
            child: Text('Play', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    _progressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _useWebView ? _buildWebView() : _buildVideoPlayer(),
    );
  }

  Widget _buildWebView() {
    return Stack(
      children: [
        WebViewWidget(controller: _webViewController),
        Positioned(
          top: 40,
          left: 16,
          child: SafeArea(
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
              onPressed: () {
                setState(() => _useWebView = false);
              },
            ),
          ),
        ),
        Positioned(
          top: 40,
          right: 16,
          child: SafeArea(
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoPlayer() {
    return GestureDetector(
      onTap: _toggleControls,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Video player background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black, Colors.grey[900]!, Colors.black],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.red, width: 2),
                    ),
                    child: Icon(
                      Icons.play_arrow,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    widget.content.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.content.description,
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: () => _launchVideo(widget.content.videoUrl),
                    icon: Icon(Icons.play_arrow),
                    label: Text('Play Video'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () => _showVideoUrlInput(),
                    icon: Icon(Icons.edit),
                    label: Text('Set Video URL'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Colors.white),
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Controls overlay
          AnimatedOpacity(
            opacity: _showControls ? 1.0 : 0.0,
            duration: Duration(milliseconds: 300),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
              child: Column(
                children: [
                  // Top controls
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Expanded(
                            child: Text(
                              widget.content.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.cast,
                              color: Colors.white,
                              size: 24,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  // Bottom info
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.white70,
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Tap "Play Video" to watch or "Set Video URL" to add your own link',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
