import 'dart:math';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

class ReadableHtmlConverter {
  static const Set<String> _tagsToRemoveCompletely = {
    'script', 'style', 'nav', 'header', 'footer', 'aside', 'form', 'iframe',
    'noscript', 'link', 'meta', 'button', 'input', 'select', 'textarea',
    'label', 'fieldset', 'legend', 'optgroup', 'option',
    // Elements that are almost always UI chrome or non-content
    'svg', // SVGs can be decorative
    'applet', 'object', 'embed',
  };

  static const Set<String> _tagsToUnwrap = {
    // Tags that often just wrap content without adding semantic meaning for readability
    // and can sometimes break up text flow if not handled.
    // Be cautious with this list.
    'span', // If it's a direct child of a block and doesn't have specific styling that's crucial
    // 'font', // Older tag, usually not needed
  };

  static const Set<String> _contentTags = {
    'p', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'blockquote', 'pre', 'code',
    'ul', 'ol', 'li', 'table', 'thead', 'tbody', 'tr', 'th', 'td', 'figure',
    'figcaption',
    'img',
    'video',
    'audio',
    'details',
    'summary',
    'article',
    'section',
    'div',
    // Adding 'div' and 'section' here as they can be primary content containers
  };

  static const Set<String> _attributesToRemove = {
    'style',
    'class',
    'id', // We'll apply our own. Consider keeping some classes if they are content-semantic.
    'onclick',
    'onsubmit',
    'onload',
    'onmouseover',
    'onmouseout',
    'onmousedown',
    'onmouseup',
    'data-src', // Often for lazy loading, we'd want the actual src if available or handle it.
    // Common tracking/framework-specific attributes:
    'data-reactid', 'data-reactroot',
    'ng-', // Angular attributes
    'vue-', // Vue attributes
    'data-cy', 'data-test', 'data-testid', // Testing attributes
    'width',
    'height', // For images/media, these might be better handled by CSS max-width
    'align',
    'bgcolor',
    'border',
    'cellpadding',
    'cellspacing', // Deprecated presentation attributes
  };

  // More sophisticated Class/ID analysis
  // Boost keywords/patterns (higher weight = stronger boost)
  static final List<Map<String, dynamic>> _boostMatchers = [
    {
      'pattern': RegExp(
        r'article|story|blog|post|content|entry|text|body|main',
        caseSensitive: false,
      ),
      'weight': 60.0,
    },
    {
      'pattern': RegExp(
        r'content-?body|article-?body|main-?content|story-?content',
        caseSensitive: false,
      ),
      'weight': 80.0,
    },
    {
      'pattern': RegExp(r'post-?entry|blog-?post', caseSensitive: false),
      'weight': 70.0,
    },
    {
      'pattern': RegExp(
        r'^(content|main|article|blog)(-inner|-wrap|-container)?$',
        caseSensitive: false,
      ),
      'weight': 75.0,
    },
    {
      'pattern': 'prose',
      'weight': 50.0,
    }, // Common in Tailwind for readable content
  ];

  // Penalty keywords/patterns (higher weight = stronger penalty, applied as multiplier < 1.0)
  static final List<Map<String, dynamic>> _penaltyMatchers = [
    {
      'pattern': RegExp(
        r'nav|menu|sidebar|aside|toc|index|related|breadcrumb',
        caseSensitive: false,
      ),
      'weight': 0.2,
    },
    {
      'pattern': RegExp(
        r'header|footer|masthead|bottom|top|site-header|site-footer',
        caseSensitive: false,
      ),
      'weight': 0.3,
    },
    {
      'pattern': RegExp(
        r'comment|discuss|share|social|tool|widget|banner|promo',
        caseSensitive: false,
      ),
      'weight': 0.1,
    },
    {
      'pattern': RegExp(
        r'ad|advert|sponsor|popup|modal|overlay|flyout',
        caseSensitive: false,
      ),
      'weight': 0.05,
    },
    {
      'pattern': RegExp(
        r'form|contact|login|search|subscribe',
        caseSensitive: false,
      ),
      'weight': 0.2,
    },
    {
      'pattern': RegExp(
        r'pagination|pager|meta|byline|author|timestamp|info',
        caseSensitive: false,
      ),
      'weight': 0.4,
    }, // Meta can sometimes be part of content
    {
      'pattern': RegExp(
        r'hidden|hide|sr-only|visually-hidden|noprint',
        caseSensitive: false,
      ),
      'weight': 0.1,
    },
    {
      'pattern': RegExp(r'dropdown|accordion|tabs', caseSensitive: false),
      'weight': 0.3,
    },
    // Common framework/utility classes (often for layout or non-content components)
    {
      'pattern': RegExp(
        r'^(container|row|col(-[a-z0-9]+)*|grid|flex|wrapper|inner|graphic|media|figure)$',
        caseSensitive: false,
      ),
      'weight': 0.7,
    }, // Figure can be good, but often a layout class too
    {
      'pattern': RegExp(
        r'btn|button|icon|logo|badge|tag|chip|alert|card',
        caseSensitive: false,
      ),
      'weight': 0.3,
    }, // Card might contain content, but the card itself is a container
    {
      'pattern': RegExp(
        r'clearfix|pull-left|pull-right|text-center|float-left|float-right',
        caseSensitive: false,
      ),
      'weight': 0.8,
    },
    {
      'pattern': RegExp(r'user|profile|author-box', caseSensitive: false),
      'weight': 0.4,
    },
  ];

  static String convertToReadableHtml(String htmlString) {
    if (htmlString.trim().isEmpty) return '';
    Document? document;
    try {
      document = parse(htmlString);
    } catch (e) {
      print('Error parsing HTML: $e');
      return htmlString;
    }

    _preprocess(document.body);
    Element? bestCandidate = _findMainContentCandidate(document.body);

    if (bestCandidate == null || bestCandidate.text.trim().length < 150) {
      // Added min length
      final cleanedBody = _cleanElement(
        document.body!.clone(true),
      ); // Clean a clone
      if (cleanedBody.text.trim().isEmpty ||
          cleanedBody.text.trim().length < 100) {
        // Stricter check for fallback
        print(
          'No significant content found after cleaning body or no best candidate.',
        );
        return _buildReadableHtml(
          '<p>No readable content could be extracted.</p>',
        );
      }
      print(
        'Warning: Using cleaned body as fallback. Best candidate was weak or null.',
      );
      return _buildReadableHtml(cleanedBody.innerHtml);
    }

    final cleanedContentElement = _cleanElement(bestCandidate.clone(true));
    return _buildReadableHtml(cleanedContentElement.innerHtml);
  }

  static void _preprocess(Element? body) {
    if (body == null) return;

    body.querySelectorAll('*').forEach((element) {
      if (_tagsToRemoveCompletely.contains(element.localName?.toLowerCase())) {
        element.remove();
      } else if (_tagsToUnwrap.contains(element.localName?.toLowerCase())) {
        // Unwrap: replace element with its children
        final parent = element.parent;
        if (parent != null) {
          final index = parent.children.indexOf(element);
          element.children.reversed.forEach((child) {
            // Insert in reverse to maintain order
            parent.children.insert(
              index,
              child.clone(true),
            ); // Clone to avoid issues with live list
          });
          element.remove();
        }
      }
      element.nodes.whereType<Comment>().toList().forEach(
        (comment) => comment.remove(),
      );
    });
  }

  static Element? _findMainContentCandidate(Element? body) {
    if (body == null) return null;

    List<Map<String, dynamic>> scoredCandidates = [];

    void findAndScoreCandidates(Element element, int depth) {
      // Avoid going too deep or scoring tiny elements as primary candidates
      if (depth > 10 || element.text.trim().length < 20) {
        // Don't score elements with very little text
        return;
      }

      // Only consider elements that are likely to be block-level or structural
      if (element.localName == 'body' ||
          element.localName == 'div' ||
          element.localName == 'section' ||
          element.localName == 'article' ||
          element.localName == 'main' ||
          element.localName ==
              'td' // In rare cases, a table cell
              ) {
        double score = _calculateScore(element, depth);
        if (score > 0) {
          // Only consider candidates with a positive score
          scoredCandidates.add({'element': element, 'score': score});
        }
      }

      // Recurse, but not into elements that themselves are strong content types if we're looking for their container
      // This means if we are scoring a 'div', we still want to look at its child 'div's.
      // But if we encounter a 'p' directly, we don't try to make 'p' a candidate for main container.
      if (!{
        'p',
        'h1',
        'h2',
        'h3',
        'img',
        'ul',
        'ol',
        'table',
      }.contains(element.localName)) {
        element.children.forEach(
          (child) => findAndScoreCandidates(child, depth + 1),
        );
      }
    }

    findAndScoreCandidates(body, 0);

    if (scoredCandidates.isEmpty) {
      print('No candidates found with positive score.');
      return body; // Fallback to body if nothing scored positively
    }

    scoredCandidates.sort(
      (a, b) => (b['score'] as double).compareTo(a['score'] as double),
    );

    // The best candidate is often not the absolute root, but a child of it.
    // Consider relationship between top candidates. If a high-scoring candidate is a child of another high-scoring one,
    // the parent might be a better choice if it doesn't introduce too much noise.
    // This is a simplified approach:
    Element? bestCandidate = scoredCandidates.first['element'] as Element?;
    double topScore = scoredCandidates.first['score'] as double;

    print('Top candidates:');
    scoredCandidates.take(5).forEach((c) {
      final el = c['element'] as Element;
      final id = el.id.isNotEmpty ? '#${el.id}' : '';
      final classes = el.classes.isNotEmpty ? '.${el.classes.join('.')}' : '';
      print(
        '  - ${el.localName}$id$classes: ${c['score']} (Text Length: ${el.text.trim().length})',
      );
    });

    // If the best candidate is the body itself, check if any direct children are significantly better.
    if (bestCandidate == body && scoredCandidates.length > 1) {
      final secondCandidateElement = scoredCandidates[1]['element'] as Element;
      final secondCandidateScore = scoredCandidates[1]['score'] as double;
      if (secondCandidateElement.parent == body &&
          secondCandidateScore > topScore * 0.75) {
        print(
          'Promoting second candidate as it is a direct child of body and has comparable score.',
        );
        bestCandidate = secondCandidateElement;
      }
    }

    // If the best candidate is very large and its direct children contain the actual concentrated content...
    // This is where true clustering or density analysis on children would be powerful.
    // For now, we rely on the recursive scoring.

    if (bestCandidate != null &&
        _calculateScore(bestCandidate, 0) < 20 &&
        bestCandidate != body) {
      print(
        'Best candidate score is too low ($topScore), falling back to body or null.',
      );
      return body.text.trim().isNotEmpty ? body : null;
    }

    return bestCandidate ?? (body.text.trim().isNotEmpty ? body : null);
  }

  static Element _cleanElement(Element element) {
    List<Element> allElements = [element, ...element.querySelectorAll('*')];

    for (var el in allElements) {
      List<String> attributesToRemove = [];
      el.attributes.keys.forEach((attrKey) {
        if (attrKey is String) {
          final attrKeyLower = attrKey.toLowerCase();
          if (_attributesToRemove.contains(attrKeyLower) ||
              attrKeyLower.startsWith(
                'data-',
              ) || // Remove all data-* attributes
              attrKeyLower.startsWith('on') || // Remove all on* event handlers
              attrKeyLower.startsWith('aria-')) {
            // Remove aria attributes for simplification
            attributesToRemove.add(attrKey);
          }
        }
      });
      attributesToRemove.forEach((attr) => el.attributes.remove(attr));

      // Remove empty tags that are not self-closing or void elements
      // Be careful not to remove <img/>, <hr/>, <br/> etc.
      const voidElements = {
        'area',
        'base',
        'br',
        'col',
        'embed',
        'hr',
        'img',
        'input',
        'link',
        'meta',
        'param',
        'source',
        'track',
        'wbr',
      };
      if (!voidElements.contains(el.localName) &&
          el.innerHtml.trim().isEmpty &&
          el.text.trim().isEmpty &&
          el.children.isEmpty) {
        // Only remove if it's truly empty and not a structural part of some plugin
        // This is risky, so apply with caution or based on tag type
        if (['div', 'span', 'a'].contains(el.localName) &&
            el.attributes.isEmpty) {
          // el.remove(); // Removing elements during iteration can be problematic. Better to mark for removal.
        }
      }
    }
    return element;
  }

  static double _calculateScore(Element element, int depth) {
    double score = 0;

    // 0. Basic penalty for being too deep (less likely to be main container)
    score -= depth * 5.0;

    // 1. Class and ID analysis (more sophisticated)
    String classNames = element.className.toLowerCase();
    String idName = element.id.toLowerCase();

    for (var matcherEntry in _boostMatchers) {
      final pattern = matcherEntry['pattern'];
      final weight = matcherEntry['weight'] as double;
      if (pattern is String &&
          (classNames.contains(pattern) || idName.contains(pattern))) {
        score += weight;
      } else if (pattern is RegExp &&
          (pattern.hasMatch(classNames) || pattern.hasMatch(idName))) {
        score += weight;
      }
    }

    double penaltyMultiplier = 1.0;
    for (var matcherEntry in _penaltyMatchers) {
      final pattern = matcherEntry['pattern'];
      final weight =
          matcherEntry['weight']
              as double; // This is now a direct multiplier effect.
      if (pattern is String &&
          (classNames.contains(pattern) || idName.contains(pattern))) {
        penaltyMultiplier *= weight;
      } else if (pattern is RegExp &&
          (pattern.hasMatch(classNames) || pattern.hasMatch(idName))) {
        penaltyMultiplier *= weight;
      }
    }
    score *= penaltyMultiplier;
    if (score < 0 && penaltyMultiplier < 1.0)
      score = 0; // Don't let penalties alone make score too negative initially.

    // 2. Text content length
    String currentElementText = element.nodes
        .whereType<Text>()
        .map((t) => t.text.trim())
        .join(' ');
    int textLength = element.text.trim().length; // All text including children
    score += textLength * 0.1; // General bonus for having text
    score += currentElementText.length * 0.2; // Bonus for direct text

    // 3. Paragraphs and their quality
    List<Element> paragraphs = element.querySelectorAll('p');
    int paragraphTextLength = 0;
    int numGoodParagraphs = 0;
    for (var p in paragraphs) {
      String pText = p.text.trim();
      if (pText.length > 25) {
        // Consider a paragraph "good" if it has decent length
        numGoodParagraphs++;
        paragraphTextLength += pText.length;
      }
    }
    score += numGoodParagraphs * 20; // Bonus for each good paragraph
    score += paragraphTextLength * 0.25;

    // 4. Link density (penalize if too many links compared to text)
    int linkTextLength = 0;
    List<Element> links = element.querySelectorAll('a');
    links.forEach((a) => linkTextLength += a.text.trim().length);

    if (textLength > 0 && linkTextLength > textLength * 0.4) {
      // Over 40% link text
      score *= 0.4;
    } else if (textLength > 0 && linkTextLength > textLength * 0.25) {
      // Over 25% link text
      score *= 0.7;
    }
    if (links.length > 10 &&
        (links.length.toDouble() / (paragraphs.length.toDouble() + 1)) > 2) {
      // Many links, few paragraphs
      score *= 0.5;
    }

    // 5. Content-suggesting child tags density (Simplified DOM Clustering idea)
    int significantChildren = 0;
    int shortTextChildren = 0; // Children that are mostly text but very short
    double childrenContentScore = 0;

    element.children.forEach((child) {
      String childText = child.text.trim();
      if (_contentTags.contains(child.localName) && childText.length > 50) {
        significantChildren++;
        childrenContentScore += childText.length * 0.1;
        if (child.localName == 'p' && childText.length > 80)
          childrenContentScore += 20; // Bonus for good P
        if (RegExp(r'^h[1-6]$').hasMatch(child.localName!))
          childrenContentScore += 15; // Bonus for headings
      } else if (childText.length > 10 &&
          childText.length < 50 &&
          child.children.isEmpty) {
        shortTextChildren++;
      }

      // Penalize if child itself has strong negative indicators (e.g. a div full of share buttons inside candidate)
      String childClassAndId = (child.className + ' ' + child.id).toLowerCase();
      for (var matcherEntry in _penaltyMatchers) {
        final pattern = matcherEntry['pattern'];
        final weight = matcherEntry['weight'] as double;
        if (pattern is String && childClassAndId.contains(pattern) ||
            pattern is RegExp && pattern.hasMatch(childClassAndId)) {
          if (weight < 0.3)
            childrenContentScore -= 50; // Strong penalty for very bad children
          break; // Apply first strong penalty
        }
      }
    });
    score += childrenContentScore;

    if (element.children.isNotEmpty) {
      double significantChildRatio =
          significantChildren / element.children.length.toDouble();
      if (significantChildRatio > 0.3) {
        // More than 30% significant children
        score *= (1 + significantChildRatio * 0.5); // Boost based on ratio
      } else if (element.children.length > 5) {
        // Many children, but few are significant
        score *= 0.6;
      }
    }
    // Penalize if there are many short text children, suggesting fragmentation or menu-like structures
    if (shortTextChildren > 5 && shortTextChildren > significantChildren * 2) {
      score *= 0.5;
    }

    // 6. Penalize very short direct text if element is a container (has children)
    //    and doesn't have strong paragraph content
    if (currentElementText.length < 50 &&
        element.children.isNotEmpty &&
        numGoodParagraphs < 2 &&
        textLength > 200) {
      // This element has little direct text, few good paragraphs, but its children contribute to overall text length
      // Could be a wrapper, penalize slightly if it doesn't have other strong positive signals
      score *= 0.8;
    } else if (currentElementText.length > textLength * 0.8 &&
        numGoodParagraphs == 0 &&
        textLength < 150) {
      // Most text is direct, no paragraphs, short total length - likely not main article text
      score *= 0.4;
    }

    // 7. Penalize elements that are typically containers for non-content (even if they slip through _tagsToRemove)
    if (['ul', 'ol'].contains(element.localName) &&
        !element.parent!.classes.any(
          (c) => c.contains('content') || c.contains('article'),
        )) {
      // If it's a list and not clearly marked as part of content, check its items
      bool listIsLikelyNav = true;
      if (element.children.isNotEmpty) {
        final avgLinkTextInLi = element.children
            .where((li) => li.localName == 'li')
            .map((li) {
              final linksInLi = li.querySelectorAll('a');
              if (linksInLi.isEmpty) return 0.0;
              return linksInLi
                      .map((a) => a.text.trim().length)
                      .reduce((a, b) => a + b) /
                  linksInLi.length.toDouble();
            })
            .where((avg) => avg > 0)
            .toList();

        if (avgLinkTextInLi.isNotEmpty &&
            avgLinkTextInLi.reduce((a, b) => a + b) / avgLinkTextInLi.length <
                30) {
          // Avg link text is short
          listIsLikelyNav = true;
        } else if (numGoodParagraphs == 0) {
          // No actual paragraphs, just list items
          listIsLikelyNav = true;
        } else {
          listIsLikelyNav = false;
        }
      }
      if (listIsLikelyNav) score *= 0.3;
    }

    // 8. Boost for specific tag types if other signals are positive
    if (element.localName == 'article') score *= 1.5;
    if (element.localName == 'main') score *= 1.3;

    // Ensure score isn't wildly negative if penalties were harsh
    return max(0, score); // Ensure score is not negative
  }

  static String _buildReadableHtml(String contentHtml) {
    // Ensure contentHtml isn't just whitespace or empty before wrapping
    if (contentHtml.trim().isEmpty) {
      contentHtml =
          "<p>No content could be extracted or the extracted content was empty.</p>";
    }
    return '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    ${_getReadableStyles()}
</head>
<body>
    <article class="readable-content">
        $contentHtml
    </article>
</body>
</html>
''';
  }

  static String _getReadableStyles() {
    return '''
<style>
    body {
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Oxygen-Sans, Ubuntu, Cantarell, "Helvetica Neue", sans-serif;
        line-height: 1.7;
        color: #333;
        background-color: #f9f9f9;
        margin: 0;
        padding: 0;
    }
    .readable-content {
        max-width: 750px; /* Slightly wider */
 
        background-color: #fff;
        border-radius: 8px;
        box-shadow: 0 6px 18px rgba(0,0,0,0.07);
        font-size: 1.0em; /* Slightly larger base font */
    }
    h1, h2, h3, h4, h5, h6 {
        line-height: 1.3;
        margin-top: 1.8em;
        margin-bottom: 0.6em;
        color: #111;
    }
    h1 { font-size: 1.6em; letter-spacing: -0.5px; }
    h2 { font-size: 1.2em; letter-spacing: -0.3px; }
    h3 { font-size: 1.0em; }
    h4 { font-size: 1.0em; }
    p {
        margin-bottom: 1.3em;
    }
    a {
        color: #0067c0; /* Adjusted link color */
        text-decoration: none;
    }
    a:hover {
        text-decoration: underline;
    }
    img, video, figure {
        max-width: 100%;
        height: auto;
        margin: 1.5em 0;
        border-radius: 6px;
        display: block; /* Center images in figure/p */
        margin-left: auto;
        margin-right: auto;
    }
    figure {
        padding: 0;
    }
    figcaption {
        font-size: 0.9em;
        color: #555;
        text-align: center;
        margin-top: 0.5em;
    }
    blockquote {
        border-left: 4px solid #0067c0;
        padding-left: 1.2em;
        margin-left: 0;
        margin-right: 0;
        margin-top: 1.5em;
        margin-bottom: 1.5em;
        font-style: italic;
        color: #444;
        font-size: 1.05em;
    }
    pre {
        font-family: "SFMono-Regular", Consolas, "Liberation Mono", Menlo, Courier, monospace;
        background-color: #f3f4f6; /* Lighter pre background */
        padding: 1.2em;
        border-radius: 6px;
        font-size: 0.95em;
        overflow-x: auto;
        line-height: 1.45;
    }
    code { /* For inline code */
        font-family: "SFMono-Regular", Consolas, "Liberation Mono", Menlo, Courier, monospace;
        background-color: #f3f4f6;
        padding: 0.2em 0.5em;
        border-radius: 4px;
        font-size: 0.9em;
    }
    pre code { /* Reset for code inside pre */
        padding: 0;
        background-color: transparent;
        border-radius: 0;
        font-size: inherit;
    }
    ul, ol {
        padding-left: 1.8em;
        margin-bottom: 1.3em;
    }
    li {
        margin-bottom: 0.6em;
    }
    table {
        width: 100%;
        border-collapse: collapse;
        margin-bottom: 1.5em;
        font-size: 0.95em;
    }
    th, td {
        border: 1px solid #e1e1e1; /* Lighter table borders */
        padding: 10px 12px;
        text-align: left;
    }
    th {
        background-color: #f7f7f7;
        font-weight: 600;
    }
    hr {
        border: none;
        border-top: 1px solid #e5e5e5;
        margin: 2.5em 0;
    }
    /* Avoid excessively large images */
    .readable-content img[width], .readable-content img[height] {
      width: auto;
      height: auto;
    }
</style>
''';
  }

  static void example() {
    String sampleHtml = '''
<html>
<head><title>My Page</title><style>.hide{display:none;}</style></head>
<body>
    <div class="site-header-wrapper">
      <header id="masthead" class="site-header"><h1>Site Title - News Portal</h1><nav><ul><li>Home</li><li>About</li></ul></nav></header>
    </div>
    <div id="page-container">
      <div class="main-column content-area" id="primary">
          <main id="main-content" class="site-main">
            <article id="article-123" class="blog-post prose">
                <h2>An Interesting Article About Next.js and Modern Web</h2>
                <p class="byline author-meta">By John Doe on <time>June 1, 2025</time></p>
                <p>This is the <strong>first paragraph</strong> of the main content. It's quite interesting and provides a lot of value to readers who are looking for high-quality information.</p>
                <p>Here's another paragraph, continuing the discussion. Frameworks like Next.js often use <em>divs</em> for structure. We aim for readability here. This paragraph is a bit longer to test text scoring properly and ensure it contributes well.</p>
                <figure class="wp-block-image size-large">
                    <img src="image.jpg" alt="A descriptive image of modern web design" width="1024" height="683">
                    <figcaption>This is an image related to the content, perhaps a diagram.</figcaption>
                </figure>
                <p>Links can be tricky: <a href="#">this is an important link</a>. We don't want too many of them if it's just navigation. But some links are part of the content. This paragraph has one such link.</p>
                <div class="embedded-tweet">A tweet might be here, but it's often in an iframe or script-generated.</div>
                <h3>A Subheading for More Details</h3>
                <p>Some more text to make it longer and more substantial. This section delves into the specifics of class analysis and DOM clustering for better content extraction from various websites, including those built with React, Vue, or Angular.</p>
                <ul>
                    <li>Point one: Sophisticated class/ID analysis.</li>
                    <li>Point two: DOM clustering algorithms.</li>
                    <li>Point three: Handling short text nodes.</li>
                </ul>
                <blockquote>This is a quote from an expert. "Content extraction is challenging but rewarding." It should be styled nicely.</blockquote>
                <pre><code>function helloWorld() {\n  console.log("Hello, from a code block!");\n}</code></pre>
                <p>Final thoughts on the topic, summarizing the key takeaways and offering further reading or next steps for the interested user.</p>
            </article>
          </main>
          <div class="comments-area" id="comments">
              <h3>Comments Section</h3>
              <p class="comment-reply-title">User1: Great post! Really insightful.</p>
              <a href="#reply" class="comment-reply-link">Reply</a>
          </div>
      </div>
      <aside id="secondary" class="widget-area sidebar">
          <h3>Related Links</h3>
          <ul>
              <li><a href="#">Link 1 - Irrelevant</a></li>
              <li><a href="#">Link 2 - Also not main</a></li>
              <li><a href="#">Another Sidebar Link</a></li>
          </ul>
          <div class="advertisement-banner">AD GOES HERE</div>
      </aside>
    </div>
    <footer class="site-footer" id="colophon"><p>&copy; 2025 My Awesome Site. All rights reserved.</p><script>console.log("footer script here");</script></footer>
</body>
</html>
''';

    String complexHtmlNoSemantic = '''
<html><body>
    <div id="page-wrapper" class="bg-gray-100">
        <div id="top-navigation-bar" class="flex justify-between p-4 bg-blue-600 text-white">
            <span>My Site Logo</span>
            <div class="navigation-links"> <a href="#">Home</a> <a href="#">Products</a> <a href="#">Contact</a></div>
        </div>
        <div class="container mx-auto mt-8 grid grid-cols-3 gap-4">
            <div class="col-span-2">
                <div class="post-container bg-white p-6 shadow-lg rounded-md">
                    <div class="post-title text-3xl font-bold mb-4">Main Title Here - A Deep Dive</div>
                    <div class="post-meta text-sm text-gray-600 mb-2">Published by Admin | 2 days ago</div>
                    <div class="entry-content prose prose-lg">
                        <p class="intro-paragraph leading-relaxed">This is the introduction. It's designed to grab your attention and set the stage for the information that follows. We'll be looking at various aspects of data processing.</p>
                        <div class="main-story-body">
                            <p>Paragraph 1 of the story. This is where the good stuff is. We explore the nuances of the topic, providing detailed explanations and examples. This section forms the core of the information presented.</p>
                            <p>Paragraph 2, adding more details and information. The goal is to extract this section primarily, along with its surrounding context that forms the article. It includes <em>emphasized text</em> and <strong>strong importance</strong> where needed.</p>
                            <img src="placeholder.jpg" alt="Story image related to data processing" class="my-4 rounded shadow"/>
                            <p>Paragraph 3, concluding the main part of the story. We summarize the findings and offer some concluding thoughts. This part is crucial for reader comprehension.</p>
                            <h4>Subsection Title</h4>
                            <p>More details under a subsection. This shows how h4 might be used within the main content flow.</p>
                        </div>
                    </div>
                </div>
                 <div class="post-footer-actions mt-4 p-4 bg-white rounded shadow-md">
                    <span class="share-button">Share on Twitter</span> <span class="like-button">Like this</span>
                 </div>
            </div>
            <div class="col-span-1 sidebar-content">
                <div class="p-4 bg-white shadow-lg rounded-md mb-4">
                    <h3 class="font-bold text-lg mb-2">Related Articles</h3>
                    <a href="#" class="block text-blue-500 hover:underline">Related Story 1 - An Overview</a>
                    <a href="#" class="block text-blue-500 hover:underline">Related Story 2 - Advanced Techniques</a>
                </div>
                <div class="p-4 bg-gray-200 shadow-lg rounded-md ad-widget">Advertisement Here</div>
            </div>
        </div>
        <div id="main-footer-area" class="text-center p-4 mt-8 bg-gray-800 text-white">Copyright info 2025. All rights reserved by The Example Corp.</div>
    </div>
</body></html>
    ''';

    print("--- Converting Sample HTML (with semantic tags) ---");
    String readableHtml = convertToReadableHtml(sampleHtml);
    print(readableHtml);

    print(
      "\n--- Converting Complex HTML (div-heavy, Tailwind-like classes) ---",
    );
    String readableComplexHtml = convertToReadableHtml(complexHtmlNoSemantic);
    print(readableComplexHtml);
  }
}

// To run the example:
// void main() {
//   ReadableHtmlConverter.example();
// }
