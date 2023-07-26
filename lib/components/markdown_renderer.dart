import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkdownRenderer extends StatefulWidget {
  final String markdown;

  const MarkdownRenderer({super.key, required this.markdown});

  @override
  State<MarkdownRenderer> createState() => _MarkdownRendererState();
}

class _MarkdownRendererState extends State<MarkdownRenderer> {
  @override
  void initState() {
    super.initState();
    _convertToHtml(widget.markdown);
  }

  void _convertToHtml(String markdown) {
    // Customizable Markdown-to-HTML conversion rules
    var rules = [
      RegExp(r'# (.+)'),
      RegExp(r'## (.+)'),
      RegExp(r'### (.+)'),
      RegExp(r'#### (.+)'),
      RegExp(r'##### (.+)'),
      RegExp(r'###### (.+)'),
      RegExp(r'\*\*(.+?)\*\*'),
      RegExp(r'\*(.+?)\*'),
      RegExp(r'`(.+?)`'),
      RegExp(r'!\[(.*?)\]\((.*?)\)'),
      RegExp(r'\---'),
      // Add more rules as needed
    ];

    String htmlText = markdown;
    for (final rule in rules) {
      htmlText = htmlText.replaceAllMapped(rule, (match) {
        final String replacement = _getReplacement(match.group(0)!);
        return replacement;
      });
    }

    setState(() {
      _htmlText = htmlText;
    });
  }

  String _getReplacement(String match) {
    // Replace Markdown patterns with corresponding HTML elements
    if (match.startsWith('##')) {
      return '<h2>${match.substring(3, match.length)}</h2>';
    } else if (match.startsWith('#')) {
      return '<h1>${match.substring(2, match.length)}</h1>';
    } else if (match.startsWith('###')) {
      return '<h3>${match.substring(4, match.length)}</h3>';
    } else if (match.startsWith('####')) {
      return '<h4>${match.substring(5, match.length)}</h4>';
    } else if (match.startsWith('#####')) {
      return '<h5>${match.substring(6, match.length)}</h5>';
    } else if (match.startsWith('######')) {
      return '<h6>${match.substring(7, match.length)}</h6>';
    } else if (match.startsWith('**')) {
      return '<strong>${match.substring(2, match.length - 2)}</strong>';
    } else if (match.startsWith('*')) {
      return '<em>${match.substring(1, match.length - 1)}</em>';
    } else if (match.startsWith('`')) {
      return '<code>${match.substring(1, match.length - 1)}</code>';
    } else if (match.startsWith('![')) {
      final alt = match.substring(2, match.indexOf(']'));
      final src = match.substring(match.indexOf('(') + 1, match.length - 1);
      return '<img alt="$alt" src="$src">';
    } else if (match.startsWith('---')) {
      return '<hr />';
    }

    // Return the original match if no replacement was found
    return match;
  }

  String _htmlText = "";

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(data: _htmlText);
  }
}
