// lib/models/blog_post_model.dart

// (Class BlogPost tetap sama)
class BlogPost {
  final String imageUrl;
  final String title;
  final String date;

  BlogPost({required this.imageUrl, required this.title, required this.date});
}

// --- GANTI DAFTAR INI ---
final List<BlogPost> blogDataList = [
  BlogPost(
    imageUrl: 'assets/images/blogs/blog1.jpg', // Path lokal
    title: 'Blog Title 1',
    date: '22 October 2025',
  ),
  BlogPost(
    imageUrl: 'assets/images/blogs/blog2.jpg', // Path lokal
    title: 'Blog Title 2',
    date: '22 October 2025',
  ),
  BlogPost(
    imageUrl: 'assets/images/blogs/blog3.jpg', // Path lokal
    title: 'Blog Title 3',
    date: '22 October 2025',
  ),
];
