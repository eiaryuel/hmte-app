// lib/models/blog_post_mode.dart

class BlogPost {
  final String imageUrl;
  final String title;
  final String date;
  final String author;

  BlogPost({
    required this.imageUrl,
    required this.title,
    required this.date,
    required this.author,
  });
}

final List<BlogPost> blogDataList = [
  // Data 1-3 (Lama)
  BlogPost(
    imageUrl: 'assets/images/blogs/blog1.jpg',
    title: 'Pelantikan Pengurus Baru HMTE 2025',
    date: '22 October 2025',
    author: 'Admin HMTE',
  ),
  BlogPost(
    imageUrl: 'assets/images/blogs/blog2.jpg',
    title: 'Seminar Teknologi Masa Depan',
    date: '25 October 2025',
    author: 'Divisi IPTEK',
  ),
  BlogPost(
    imageUrl: 'assets/images/blogs/blog3.jpg',
    title: 'Kunjungan Industri ke Jakarta',
    date: '01 November 2025',
    author: 'Humas',
  ),

  // --- TAMBAHAN 2 DATA BARU ---
  BlogPost(
    imageUrl: 'assets/images/blogs/blog4.jpg',
    title: 'Workshop IoT untuk Pemula',
    date: '10 November 2025',
    author: 'Divisi Riset',
  ),
  BlogPost(
    imageUrl: 'assets/images/blogs/blog5.jpg',
    title: 'Open Recruitment Panitia Makrab',
    date: '15 November 2025',
    author: 'PSDM',
  ),
];
