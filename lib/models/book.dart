import 'package:flutter/material.dart';

class Book {
  final String id;
  final String title;
  final String author;
  final int price;
  final String imageUrl;
  final IconData placeholderIcon;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.price,
    required this.imageUrl,
    required this.placeholderIcon,
  });
}

class CartItem {
  final Book book;
  int quantity;

  CartItem({
    required this.book,
    this.quantity = 1,
  });

  int get subtotal => book.price * quantity;
}