# Analysis: CMS-mobile Integration for Admin Tools

## Source Repository
`references/CMS-mobile/` — A BLoC-based Flutter admin+member app for church management.

## Architecture

| Layer | CMS-mobile | iszlamweb_app |
|-------|-----------|---------------|
| State | **BLoC** | **Riverpod** |
| API | Dio + custom REST | **Supabase** |
| Models | `EventModel`, `AdminModel`, `Stats` | Already has events in Supabase |

> [!IMPORTANT]
> BLoC → Riverpod conversion required. Do NOT port BLoC files directly.

## Portworthy Components

### 1. Admin Overview Dashboard (`admin/feature/overview/`)
- **What**: Stats cards + bar charts (fl_chart) showing member/event/attendee counts
- **Effort**: Medium — need to wire to Supabase analytics queries
- **Port strategy**: Take the UI layout from `OverViewScreen` (408 lines), replace BLoC with Riverpod FutureProvider that calls Supabase RPC functions
- **Value**: ⭐⭐⭐ High — gives admins a quick visual pulse

### 2. Event Management (`member/feature/events/`)
- **What**: Event CRUD with `EventRepository` (past/upcoming/today), `EventCard` widget, detail screen
- **Port**: EventModel fields (`title, thumbnail, venue, location, startDate, endDate, startTime, endTime`) align with our Supabase `events` table
- **Effort**: Low — we already have event management; can borrow `event_card.dart` styling
- **Value**: ⭐⭐ Medium — UI polish, not new functionality

### 3. Admin Management (`admin/feature/admins/`)
- **What**: List admins, add admin, admin tiles
- **Port**: Layout from `admins_screen.dart` + `admin_screen_tile_widget.dart`
- **Effort**: Low-Medium — wire to Supabase `profiles` table `is_admin` flag
- **Value**: ⭐⭐ Medium

### 4. Shared Widgets
- `custom_text_field.dart` — styled form input (useful for any future forms)
- `form_validator.dart` — basic validation utilities

## Skip List
| Component | Reason |
|-----------|--------|
| `church_api.dart` | REST/Dio, we use Supabase |
| `DioError` patterns | Obsolete API, use Supabase error handling |
| `flutter_screenutil` | We don't use it; stick with responsive design |
| `styles/colors.dart` | We have `GardenPalette` |

## Recommended Next Steps

1. **Add `fl_chart`** to pubspec for dashboard visualizations
2. Create `admin_dashboard_screen.dart` with stats cards querying Supabase
3. Add event stats RPC in Supabase (`get_admin_stats`)
4. Port `event_card.dart` styling to our existing event cards
