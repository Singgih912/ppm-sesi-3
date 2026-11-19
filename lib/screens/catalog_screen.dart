import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../providers/cart_provider.dart';
import '../providers/theme_provider.dart';
import 'cart_screen.dart';

class BookCatalogScreen extends StatelessWidget {
  const BookCatalogScreen({super.key});

  static const List<Book> _books = [
    Book(
      id: 'BK-01',
      title: 'Arsitektur & Pola Desain Aplikasi Mobile',
      author: 'Nugraha & Tim NusaBookstore',
      price: 125000,
      imageUrl: 'assets/images/book_mobile.png',
      placeholderIcon: Icons.smartphone,
    ),
    Book(
      id: 'BK-02',
      title: 'Rekayasa Perangkat Lunak Modern',
      author: 'Yulhan Wahyudin',
      price: 145000,
      imageUrl: 'assets/images/book_rpl.png',
      placeholderIcon: Icons.menu_book,
    ),
    Book(
      id: 'BK-03',
      title: 'Sistem Terdistribusi & Cloud Kampus',
      author: 'Divisi Modul Digital TI',
      price: 160000,
      imageUrl: 'assets/images/book_cloud.png',
      placeholderIcon: Icons.cloud_done,
    ),
    Book(
      id: 'BK-04',
      title: 'Basis Data Relasional & Optimasi Query',
      author: 'Laboratorium Informatika',
      price: 110000,
      imageUrl: 'assets/images/book_db.png',
      placeholderIcon: Icons.storage,
    ),
  ];

  String _formatRupiah(int amount) {
    final digits = amount.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(digits[i]);
    }
    return 'Rp ${buffer.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('NusaBookstore'),
        actions: [
          IconButton(
            tooltip: themeProvider.isDarkMode ? 'Light Mode' : 'Dark Mode',
            onPressed: () {
              context.read<ThemeProvider>().toggleTheme();
            },
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
          ),
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  tooltip: 'Keranjang Belanja',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CartScreen(),
                      ),
                    );
                  },
                  icon: Badge(
                    isLabelVisible: cart.totalItems > 0,
                    label: Text('${cart.totalItems}'),
                    child: const Icon(Icons.shopping_cart),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _books.length,
        itemBuilder: (context, index) {
          final book = _books[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 14),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 64,
                        height: 84,
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          book.placeholderIcon,
                          size: 32,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Penulis: ${book.author}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _formatRupiah(book.price),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.read<CartProvider>().addItem(book);
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('"${book.title}" ditambah ke keranjang.'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text('Tambah ke Keranjang'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}