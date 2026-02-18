import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/bento_item.dart';

part 'home_mock_data.g.dart';

@riverpod
List<BentoItem> mockNews(Ref ref) {
  return [
    const BentoItem(
      id: 'n1',
      title: 'Ramadán felkészülés',
      description: 'Gyakorlati tanácsok a szent hónap előtt. Hogyan készüljünk testben és lélekben?',
      category: 'news',
      imageUrl: 'https://images.unsplash.com/photo-1596401057633-56565389d700', // Placeholder
      date: null,
    ),
    const BentoItem(
      id: 'n2',
      title: 'Új mecset épül Budapesten',
      description: 'A közösség összefogásával hamarosan elkezdődhetnek a munkálatok a X. kerületben.',
      category: 'news',
      imageUrl: 'https://images.unsplash.com/photo-1543329241-e94f7243c24b', // Placeholder
      date: null,
    ),
    const BentoItem(
      id: 'n3',
      title: 'Online Korán verseny',
      description: 'Jelentkezz az országos online versenyre, ahol értékes nyeremények várnak!',
      category: 'news',
      imageUrl: null,
      date: null,
    ),
  ];
}

@riverpod
List<BentoItem> mockEvents(Ref ref) {
  return [
    BentoItem(
      id: 'e1',
      title: 'Közösségi Iftar',
      description: 'Várunk mindenkit szeretettel a közös iftar vacsoránkra.',
      category: 'event',
      imageUrl: null,
      date: DateTime.now().add(const Duration(days: 2)),
    ),
    BentoItem(
      id: 'e2',
      title: 'Fiatalok találkozója',
      description: 'Beszélgetés, játék és közösségépítés 14-25 éveseknek.',
      category: 'event',
      imageUrl: null,
      date: DateTime.now().add(const Duration(days: 5)),
    ),
  ];
}
