import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:readit/services/feeds/models/channel.dart';
import 'package:readit/services/feeds/readibility.dart';
import 'package:xml/xml.dart';
import 'package:readit/services/feeds/models/feed.dart';
import 'package:http/http.dart' as http;

class FeedParser {
  static final _atomNS = 'http://www.w3.org/2005/Atom';
  static final _ytNS = 'http://www.youtube.com/xml/schemas/2015';
  static final _mediaNSHttp = 'http://search.yahoo.com/mrss/';
  static final _mediaNSHttps = 'https://search.yahoo.com/mrss/';
  static final _webfeedNS = 'http://webfeeds.org/rss/1.0';
  static final _contentNS = 'http://purl.org/rss/1.0/modules/content/';
  static final _dcNS = 'http://purl.org/dc/elements/1.1/';
  static final _itunesNS = 'http://www.itunes.com/dtds/podcast-1.0.dtd';

  static XmlElement? _getElementWithMediaNS(XmlElement? parent, String tag) {
    if (parent == null) return null;
    return parent.getElement(tag, namespace: _mediaNSHttps) ??
        parent.getElement(tag, namespace: _mediaNSHttp);
  }

  static Iterable<XmlElement> _findElementsWithMediaNS(
    XmlElement? parent,
    String tag,
  ) {
    if (parent == null) return [];
    return [
      ...parent.findElements(tag, namespace: _mediaNSHttps),
      ...parent.findElements(tag, namespace: _mediaNSHttp),
    ];
  }

  static DateTime? _tryParseDate(String? raw) {
    if (raw == null) return null;
    final formats = [
      'EEE, dd MMM yyyy HH:mm:ss Z', // RFC 822
      'dd MMM yyyy HH:mm:ss Z', // no weekday
      'EEE, dd MMM yyyy HH:mm Z', // no seconds
      'yyyy-MM-ddTHH:mm:ssZ', // ISO 8601 with Z
      'yyyy-MM-ddTHH:mm:ss', // ISO 8601
      'yyyy-MM-ddTHH:mm:ss.SSSZ', // with milliseconds
      'EEE MMM dd HH:mm:ss yyyy', // old-style formats
    ];

    for (final format in formats) {
      try {
        return DateFormat(format, 'en_US').parse(raw.trim(), true).toLocal();
      } catch (_) {
        continue;
      }
    }

    // Fallback: try DateTime.tryParse (UTC assumed if format allows)
    try {
      return DateTime.tryParse(raw.trim())?.toLocal();
    } catch (_) {
      return null;
    }
  }

  static String? _extractImageFromHtml(String? html) {
    if (html == null) return null;
    final imgRegex = RegExp(r'<img[^>]*src="([^"]+)"[^>]*>');
    final match = imgRegex.firstMatch(html);
    return match?.group(1);
  }

  /// Get Channel and its feeds from xml [String]
  static Channel? _parseFromString(List source) {
    String feedUrl = source[0];
    String xmlString = source[1];
    final doc = XmlDocument.parse(xmlString);
    final root = doc.rootElement;

    if (root.name.local == 'rss') {
      return _parseRss2(doc, feedUrl);
    } else if (root.name.local == 'RDF') {
      return _parseRss1(doc, feedUrl);
    } else if (root.name.local == 'feed') {
      return _parseAtom(doc, feedUrl);
    } else {
      return null;
    }
  }

  /// Get Channel and its feeds from url
  static Future<Channel?> parseFromUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        return null;
      }
      return await compute(_parseFromString, [url, response.body]);
    } catch (e) {
      return null;
    }
  }

  static Channel? _parseRss2(XmlDocument doc, String feedurl) {
    final channel = doc.findAllElements('channel').firstOrNull;
    if (channel == null) return null;
    final title = channel.getElement('title')?.innerText ?? '';
    final link = channel.getElement('link')?.innerText ?? '';
    final description = channel.getElement('description')?.innerText ?? '';
    String? image = channel.getElement('image')?.getElement('url')?.innerText;
    image ??= channel
        .findElements('logo', namespace: _webfeedNS)
        .firstOrNull
        ?.innerText;
    final creator = channel.getElement('creator', namespace: _dcNS)?.innerText;
    final publisher = channel
        .getElement('publisher', namespace: _dcNS)
        ?.innerText;
    final rights = channel.getElement('rights', namespace: _dcNS)?.innerText;
    final language = channel
        .getElement('language', namespace: _dcNS)
        ?.innerText;
    final lastBuildDate = channel.getElement('lastBuildDate')?.innerText;

    final items = channel.findAllElements('item').map((item) {
      final enclosure = item.getElement('enclosure');
      final enclosureType = enclosure?.getAttribute('type') ?? '';

      final content = item
          .getElement('encoded', namespace: _contentNS)
          ?.innerText;
      String? image = (enclosureType.startsWith('image/'))
          ? enclosure?.getAttribute('url')
          : null;
      image ??= _findElementsWithMediaNS(item, 'content')
          .where(
            (e) =>
                e.getAttribute('medium') == 'image' &&
                e.getAttribute('url') != null,
          )
          .firstOrNull
          ?.getAttribute('url');
      image ??= item
          .getElement('image', namespace: _itunesNS)
          ?.getAttribute('href');
      image ??= _extractImageFromHtml(content);
      final rawSummary = item
          .getElement('summary', namespace: _itunesNS)
          ?.innerText;
      final rawDescription = item.getElement('description')?.innerText;

      String? description = item.getElement('description')?.innerText;
      description ??= (rawSummary ?? rawDescription)?.trim();
      final pubDate = item.getElement('pubDate')?.innerText;
      final itemCreator = item
          .getElement('creator', namespace: _dcNS)
          ?.innerText;
      final itemPublisher = item
          .getElement('publisher', namespace: _dcNS)
          ?.innerText;
      final itemRights = item.getElement('rights', namespace: _dcNS)?.innerText;
      final itemLanguage = item
          .getElement('language', namespace: _dcNS)
          ?.innerText;

      return FeedItem(
        title: item.getElement('title')?.innerText.trim() ?? '',
        link: item.getElement('link')?.innerText.trim() ?? '',
        description: description?.trim() ?? '',
        content: content?.trim(),
        published: _tryParseDate(pubDate),
        image: image?.trim(),
        creator: itemCreator,
        publisher: itemPublisher,
        rights: itemRights,
        language: itemLanguage,
        guid: item.getElement('guid')?.innerText.trim(),
      );
    }).toList();

    return Channel(
      title: title.trim(),
      feedUrl: feedurl,
      link: link.trim(),
      description: description.trim(),
      image: image?.trim(),
      creator: creator,
      publisher: publisher,
      rights: rights,
      language: language,
      feeds: items,
      lastBuildDate: _tryParseDate(lastBuildDate),
    );
  }

  static Channel? _parseRss1(XmlDocument doc, String feedUrl) {
    final channel = doc.findAllElements('channel').firstOrNull;
    if (channel == null) return null;
    final title = channel.getElement('title')?.innerText ?? '';
    final link = channel.getElement('link')?.innerText ?? '';
    final description = channel.getElement('description')?.innerText ?? '';
    final creator = channel.getElement('creator', namespace: _dcNS)?.innerText;
    final publisher = channel
        .getElement('publisher', namespace: _dcNS)
        ?.innerText;
    final rights = channel.getElement('rights', namespace: _dcNS)?.innerText;
    final language = channel
        .getElement('language', namespace: _dcNS)
        ?.innerText;
    final lastBuildDate = channel.getElement('lastBuildDate')?.innerText;

    final items = doc.findAllElements('item').map((item) {
      final pubDate = item.getElement('date', namespace: _dcNS)?.innerText;
      final itemCreator = item
          .getElement('creator', namespace: _dcNS)
          ?.innerText;
      final itemPublisher = item
          .getElement('publisher', namespace: _dcNS)
          ?.innerText;
      final itemRights = item.getElement('rights', namespace: _dcNS)?.innerText;
      final itemLanguage = item
          .getElement('language', namespace: _dcNS)
          ?.innerText;
      return FeedItem(
        title: item.getElement('title')?.innerText.trim() ?? '',
        link: item.getElement('link')?.innerText.trim() ?? '',
        description: item.getElement('description')?.innerText.trim() ?? '',
        published: _tryParseDate(pubDate),
        image: null,
        creator: itemCreator,
        publisher: itemPublisher,
        rights: itemRights,
        language: itemLanguage,
        guid: item.getElement('guid')?.innerText.trim(),
      );
    }).toList();

    return Channel(
      title: title.trim(),
      feedUrl: feedUrl,
      link: link.trim(),
      description: description.trim(),
      creator: creator,
      publisher: publisher,
      rights: rights,
      language: language,
      feeds: items,
      lastBuildDate: _tryParseDate(lastBuildDate),
    );
  }

  static Channel? _parseAtom(XmlDocument doc, String feedurl) {
    final feedElement = doc.getElement('feed');
    if (feedElement == null) return null;
    final title =
        feedElement.getElement('title', namespace: _atomNS)?.innerText ?? '';
    final link =
        feedElement
            .findElements('link', namespace: _atomNS)
            .firstWhere(
              (e) => e.getAttribute('rel') != 'self',
              orElse: () => XmlElement(XmlName('')),
            )
            .getAttribute('href') ??
        '';
    final description =
        feedElement.getElement('subtitle', namespace: _atomNS)?.innerText ?? '';
    final creator = feedElement
        .getElement('creator', namespace: _dcNS)
        ?.innerText;
    final publisher = feedElement
        .getElement('publisher', namespace: _dcNS)
        ?.innerText;
    final rights = feedElement
        .getElement('rights', namespace: _dcNS)
        ?.innerText;
    final language = feedElement
        .getElement('language', namespace: _dcNS)
        ?.innerText;
    final lastBuildDate = feedElement.getElement('lastBuildDate')?.innerText;

    final items = doc.findAllElements('entry', namespace: _atomNS).map((entry) {
      // Try multiple strategies to find image

      final pubStr =
          entry.getElement('published', namespace: _atomNS)?.innerText ??
          entry.getElement('updated', namespace: _atomNS)?.innerText;
      final contentHtml = entry
          .getElement('content', namespace: _atomNS)
          ?.innerText;
      final mediaGroup = _getElementWithMediaNS(entry, 'group');
      String? description = _getElementWithMediaNS(
        mediaGroup,
        'description',
      )?.innerText;
      description ??= entry
          .getElement('summary', namespace: _atomNS)
          ?.innerText;
      description ??= entry
          .getElement('content', namespace: _atomNS)
          ?.innerText;
      String? image;

      // 1. media:thumbnail
      image ??= _getElementWithMediaNS(entry, 'thumbnail')?.getAttribute('url');

      // 2. media:content with image mime
      image ??= _findElementsWithMediaNS(entry, 'content')
          .firstWhere(
            (e) => (e.getAttribute('type')?.startsWith('image/') ?? false),
            orElse: () => XmlElement(XmlName('')),
          )
          .getAttribute('url');

      // 3. enclosure image
      image ??= entry
          .findElements('link', namespace: _atomNS)
          .firstWhere(
            (e) =>
                e.getAttribute('rel') == 'enclosure' &&
                (e.getAttribute('type')?.startsWith('image/') ?? false),
            orElse: () => XmlElement(XmlName('')),
          )
          .getAttribute('href');
      image ??= _extractImageFromHtml(contentHtml);
      // 4. YouTube fallback
      final videoId = entry.getElement('videoId', namespace: _ytNS)?.innerText;
      image ??= videoId != null
          ? 'https://i.ytimg.com/vi/$videoId/hqdefault.jpg'
          : null;
      final itemCreator = entry
          .getElement('creator', namespace: _dcNS)
          ?.innerText;
      final itemPublisher = entry
          .getElement('publisher', namespace: _dcNS)
          ?.innerText;
      final itemRights = entry
          .getElement('rights', namespace: _dcNS)
          ?.innerText;
      final itemLanguage = entry
          .getElement('language', namespace: _dcNS)
          ?.innerText;
      return FeedItem(
        title:
            entry.getElement('title', namespace: _atomNS)?.innerText.trim() ??
            '',
        link:
            (entry
                        .findElements('link', namespace: _atomNS)
                        .firstWhere(
                          (e) => e.getAttribute('rel') != 'self',
                          orElse: () => XmlElement(XmlName('')),
                        )
                        .getAttribute('href') ??
                    (videoId != null
                        ? 'https://youtube.com/watch?v=$videoId'
                        : ''))
                .trim(),
        description: description?.trim() ?? '',
        content: contentHtml?.trim(),
        published: _tryParseDate(pubStr),
        image: image,
        creator: itemCreator,
        publisher: itemPublisher,
        rights: itemRights,
        language: itemLanguage,
        guid: entry.getElement('id', namespace: _atomNS)?.innerText,
      );
    }).toList();

    return Channel(
      title: title.trim(),
      feedUrl: feedurl,
      link: link.trim(),
      description: description.trim(),
      creator: creator,
      publisher: publisher,
      rights: rights,
      language: language,
      feeds: items,
      lastBuildDate: _tryParseDate(lastBuildDate),
    );
  }

  static Future<String> getArticleContentFromUrl(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to load page');
    }

    final result = ReadableHtmlConverter.convertToReadableHtml(response.body);
    return result;
  }
}
