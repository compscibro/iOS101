# Idea 1: CreditCarnival

### Home Screen
- Scrollable list of credit cards with card images and quick highlights.

### Card Detail View
- Full benefit breakdown categorized (travel, cashback, insurance, fees, etc.).

### Search & Filter: 
- Find cards by issuer, category, annual fee, or benefit type.

### Saved Cards (Optional): 
- Bookmark cards users are interested in.

### Comparison View (Optional): 
- Simple side-by-side perks comparison.

### Local Data Storage: 
- Cards and benefits stored locally (JSON or static data) for fast performance.

# Idea 2: TaskStoic

### Task Management
- Add, edit, complete, and delete tasks.
- Optional notes field for additional details.
- Auto-sorting: incomplete tasks on top, completed tasks below.
- Persistent storage using UserDefaults.

### Calendar Integration
- View tasks by date using UICalendarView.
- Swipe-to-delete directly from the calendar task list.
- Visual indicators:
    - Hollow circle → incomplete tasks
    - Filled circle → all tasks complete
- Automatic syncing between tabs.

### Daily Stoic Quotes
- Fetch quotes from external Stoic Quotes API.
- Automatic fallback to local curated quotes when offline.
- Tap-to-refresh (with haptics + bounce animation).
- Smooth fade-in animation for each new quote.
