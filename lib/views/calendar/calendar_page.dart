import 'package:flutter/material.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  static const List<String> _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  final Color _background = const Color(0xFF07160F);
  final Color _card = const Color(0xFF0D241D);
  final Color _accent = const Color(0xFF06D66E);
  final Color _muted = const Color(0xFF37BF6C);

  DateTime _focusedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime? _selectedDay;

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  int _daysInMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0).day;
  }

  int _leadingEmptySlots(DateTime date) {
    final firstWeekday = DateTime(date.year, date.month, 1).weekday;
    return firstWeekday - 1;
  }

  void _goToPreviousMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
    });
  }

  void _goToNextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
    });
  }

  Widget _buildHeader() {
    final monthLabel =
        '${_monthNames[_focusedMonth.month - 1]} ${_focusedMonth.year}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Calendar',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            IconButton(
              onPressed: _goToPreviousMonth,
              icon: const Icon(Icons.chevron_left),
              color: Colors.white,
              splashRadius: 20,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: _card,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  monthLabel,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: _goToNextMonth,
              icon: const Icon(Icons.chevron_right),
              color: Colors.white,
              splashRadius: 20,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeekdayLabels() {
    const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Row(
      children: labels
          .map(
            (label) => Expanded(
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(color: _muted, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final totalDays = _daysInMonth(_focusedMonth);
    final leadingSlots = _leadingEmptySlots(_focusedMonth);
    final totalSlots = (leadingSlots + totalDays) % 7 == 0
        ? leadingSlots + totalDays
        : null;
    final slots =
        totalSlots ??
        (leadingSlots + totalDays + (7 - (leadingSlots + totalDays) % 7));

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount: slots,
      itemBuilder: (context, index) {
        if (index < leadingSlots || index >= leadingSlots + totalDays) {
          return const SizedBox.shrink();
        }

        final dayNumber = index - leadingSlots + 1;
        final date = DateTime(
          _focusedMonth.year,
          _focusedMonth.month,
          dayNumber,
        );
        final isToday = _isSameDay(date, DateTime.now());
        final isSelected =
            _selectedDay != null && _isSameDay(date, _selectedDay!);

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDay = date;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: isSelected ? _accent : _card,
              borderRadius: BorderRadius.circular(10),
              border: isToday
                  ? Border.all(color: _accent, width: 2)
                  : Border.all(color: Colors.transparent, width: 2),
            ),
            child: Center(
              child: Text(
                '$dayNumber',
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 18),
              _buildWeekdayLabels(),
              const SizedBox(height: 12),
              _buildCalendarGrid(),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: _card,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        color: _accent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _selectedDay != null
                          ? 'Selected: ${_selectedDay!.day} ${_monthNames[_selectedDay!.month - 1]}'
                          : 'Tap a date to view your plan',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
