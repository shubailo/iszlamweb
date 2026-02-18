import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/library_item.dart';
import 'package:iszlamweb_app/features/library/providers/library_provider.dart';

class LibraryFilterState {
  final String searchQuery;
  final LibraryItemType? typeFilter;
  final String? categoryId; // UUID or 'all'

  const LibraryFilterState({
    this.searchQuery = '',
    this.typeFilter,
    this.categoryId,
  });

  LibraryFilterState copyWith({
    String? searchQuery,
    LibraryItemType? typeFilter,
    String? categoryId,
    bool clearTypeFilter = false,
    bool clearCategoryId = false,
  }) {
    return LibraryFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      typeFilter: clearTypeFilter ? null : (typeFilter ?? this.typeFilter),
      categoryId: clearCategoryId ? null : (categoryId ?? this.categoryId),
    );
  }
}

class LibraryFilterNotifier extends Notifier<LibraryFilterState> {
  @override
  LibraryFilterState build() => const LibraryFilterState();

  void setSearch(String query) =>
      state = state.copyWith(searchQuery: query);

  void setTypeFilter(LibraryItemType? type) {
    if (type == state.typeFilter) {
      state = state.copyWith(clearTypeFilter: true);
    } else {
      state = state.copyWith(typeFilter: type);
    }
  }

  void setCategory(String? categoryId) {
    if (categoryId == null || categoryId == 'all') {
      state = state.copyWith(clearCategoryId: true);
    } else {
      state = state.copyWith(categoryId: categoryId);
    }
  }

  void clearAll() => state = const LibraryFilterState();
}

final libraryFilterProvider =
    NotifierProvider<LibraryFilterNotifier, LibraryFilterState>(
        LibraryFilterNotifier.new);

final filteredLibraryItemsProvider = Provider<List<LibraryItem>>((ref) {
  final filter = ref.watch(libraryFilterProvider);
  final allItems = ref.watch(libraryCatalogProvider);

  return allItems.where((item) {
    if (filter.typeFilter != null && item.type != filter.typeFilter) {
      return false;
    }
    if (filter.categoryId != null && filter.categoryId != 'all' &&
        item.categoryId != filter.categoryId) {
      return false;
    }
    if (filter.searchQuery.isNotEmpty) {
      final q = filter.searchQuery.toLowerCase();
      return item.title.toLowerCase().contains(q) ||
          item.author.toLowerCase().contains(q) ||
          item.description.toLowerCase().contains(q);
    }
    return true;
  }).toList();
});

final libraryCatalogProvider = Provider<List<LibraryItem>>((ref) {
  final booksAsync = ref.watch(libraryBooksStreamProvider);
  
  return booksAsync.when(
    data: (books) {
      final bookItems = books.map((book) {
        return LibraryItem(
          id: book.id,
          title: book.title,
          author: book.author,
          description: 'Book added on ${book.addedAt.toString().split(' ')[0]}',
          type: LibraryItemType.book,
          mediaUrl: book.isLocal ? book.filePath : (book.downloadUrl ?? ''),
          categoryId: book.categoryId,
          metadata: book.format.toUpperCase(),
          imageUrl: book.coverPath,
          fileUrl: book.downloadUrl,
          epubUrl: book.epubUrl,
        );
      }).toList();

      final mockKhutbas = libraryMockCatalog.where((i) => i.type == LibraryItemType.audio).toList();
      return [...bookItems, ...mockKhutbas];
    },
    loading: () => [], // Show empty while loading initial sync? 
    error: (e, s) => [],
  );
});

const libraryMockCatalog = <LibraryItem>[
  LibraryItem(
    id: 'b1',
    title: 'Az Iszlám alapjai',
    author: 'Suba László',
    description: 'Bevezetés az iszlám hit pilléreibe és alapvető tanításaiba.',
    type: LibraryItemType.book,
    mediaUrl: 'assets/books/islam_alapjai.md',
    categoryId: 'aqidah',
    metadata: '120 oldal',
  ),
  LibraryItem(
    id: 'b2',
    title: 'A próféta élete',
    author: 'Ibn Hisám',
    description: 'Mohamed próféta (s.a.w.) életrajza az eredeti arab forrásokból.',
    type: LibraryItemType.book,
    mediaUrl: 'assets/books/profeta_elete.md',
    categoryId: 'history',
    metadata: '340 oldal',
  ),
  LibraryItem(
    id: 'b3',
    title: 'Negyven hadísz',
    author: 'Imam An-Nawawi',
    description: 'Az Iszlám legfontosabb 40 hadísza magyarul, kommentárokkal.',
    type: LibraryItemType.book,
    mediaUrl: 'assets/books/negyven_hadisz.md',
    categoryId: 'hadith',
    metadata: '95 oldal',
  ),
  LibraryItem(
    id: 'b4',
    title: 'A szív megtisztítása',
    author: 'Hamza Yusuf',
    description: 'A belső spirituális úton való haladás útmutatója.',
    type: LibraryItemType.book,
    mediaUrl: 'assets/books/sziv_megtisztitasa.md',
    categoryId: 'general',
    metadata: '154 oldal',
  ),
  LibraryItem(
    id: 'a1',
    title: 'Pénteki khutba — Türelem',
    author: 'Ahmed Imam',
    description: 'A türelem fontossága az Iszlámban.',
    type: LibraryItemType.audio,
    mediaUrl: 'https://example.com/khutba_turelem.mp3',
    categoryId: 'khutba',
    metadata: '25 perc',
  ),
  LibraryItem(
    id: 'a2',
    title: 'Pénteki khutba — Ramadán',
    author: 'Ahmed Imam',
    description: 'A Ramadán szellemiségéről és a böjt bölcsességéről.',
    type: LibraryItemType.audio,
    mediaUrl: 'https://example.com/khutba_ramadan.mp3',
    categoryId: 'khutba',
    metadata: '30 perc',
  ),
  LibraryItem(
    id: 'b5',
    title: 'Fiqh a mindennapokban',
    author: 'Dr. Kovács Imre',
    description: 'Az iszlám jog gyakorlati alkalmazása a modern életben.',
    type: LibraryItemType.book,
    mediaUrl: 'assets/books/fiqh_mindennapokban.md',
    categoryId: 'fiqh',
    metadata: '210 oldal',
  ),
  LibraryItem(
    id: 'b6',
    title: 'Korán-tanulmányok',
    author: 'Dr. Mustafa Khattab',
    description: 'A Korán magyarul, részletes lábjegyzetekkel és tematikus mutatóval.',
    type: LibraryItemType.book,
    mediaUrl: 'assets/books/koran_tanulmanyok.md',
    categoryId: 'quran',
    metadata: '604 oldal',
  ),
];
