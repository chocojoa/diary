import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/diary_provider.dart';
import '../models/diary.dart';
import '../models/emotion_enum.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  // 감정별 일기 개수 계산
  Map<EmotionTag, int> _getEmotionCounts(List<Diary> diaries) {
    final Map<EmotionTag, int> counts = {};
    for (var emotion in EmotionTag.values) {
      counts[emotion] = diaries
          .where((diary) => diary.emotion == emotion)
          .length;
    }
    return counts;
  }

  // 감정별 비율 계산
  Map<String, double> _getEmotionPercentages(
      List<Diary> diaries, Map<EmotionTag, int> counts) {
    final total = diaries
        .where((diary) => diary.emotion != null)
        .length;
    if (total == 0) return {};

    final Map<String, double> percentages = {};
    counts.forEach((emotion, count) {
      percentages[emotion.label] = (count / total) * 100;
    });
    return percentages;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Consumer<DiaryProvider>(
        builder: (context, provider, child) {
          final emotionCounts = _getEmotionCounts(provider.diaries);
          final percentages =
              _getEmotionPercentages(provider.diaries, emotionCounts);

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 전체 통계
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Colors.grey[200]!,
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.analytics_rounded,
                                size: 24,
                                color: Colors.grey[700],
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '전체 통계',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem(
                                '📓',
                                provider.diaries.length.toString(),
                                '전체 일기',
                              ),
                              _buildStatItem(
                                '✅',
                                provider.diaries
                                    .where((d) => d.emotion != null)
                                    .length
                                    .toString(),
                                '분석됨',
                              ),
                              _buildStatItem(
                                '⏳',
                                provider.diaries
                                    .where((d) => d.emotion == null)
                                    .length
                                    .toString(),
                                '대기중',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 감정별 통계
                  Text(
                    '감정 분석',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...[
                    (EmotionCategory.positive, '😊 긍정'),
                    (EmotionCategory.neutral, '😐 중립'),
                    (EmotionCategory.negative, '😢 부정'),
                  ].map((category) {
                    final emotions = EmotionTag.values
                        .where((e) => e.category == category.$1)
                        .toList();
                    final categoryCount = emotions
                        .fold(0, (sum, emotion) => sum + (emotionCounts[emotion] ?? 0));
                    final categoryPercentage = provider.diaries
                            .where((d) => d.emotion != null)
                            .isEmpty
                        ? 0.0
                        : (categoryCount /
                                provider.diaries
                                    .where((d) => d.emotion != null)
                                    .length) *
                            100;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: Colors.grey[200]!,
                          width: 1,
                        ),
                      ),
                      child: ExpansionTile(
                        leading: Icon(
                          Icons.sentiment_satisfied,
                          color: category.$1.color,
                          size: 24,
                        ),
                        title: Text(
                          category.$2,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.grey[800],
                          ),
                        ),
                        subtitle: Text(
                          '$categoryCount건 (${categoryPercentage.toStringAsFixed(1)}%)',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: emotions.map((emotion) {
                                final count = emotionCounts[emotion] ?? 0;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey[100],
                                          border: Border.all(
                                            color: Colors.grey[300]!,
                                            width: 1,
                                          ),
                                        ),
                                        child: Icon(
                                          emotion.icon,
                                          color: emotion.category.color,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          emotion.label,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey[800],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          border: Border.all(
                                            color: Colors.grey[300]!,
                                            width: 0.5,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          '$count건',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey[700],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 24),

                  // 최근 감정 트렌드
                  Text(
                    '최근 일주일 감정',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildWeeklyChart(provider.diaries),
                  const SizedBox(height: 24),

                  // 가장 많은 감정
                  if (emotionCounts.isNotEmpty)
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: Colors.grey[200]!,
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.star_rounded,
                                  size: 24,
                                  color: Colors.grey[700],
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  '주요 감정',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ...emotionCounts.entries
                                .where((e) => e.value > 0)
                                .toList()
                                .asMap()
                                .entries
                                .take(3)
                                .map((entry) {
                              final emotion = entry.value.key;
                              final count = entry.value.value;
                              final rank = entry.key + 1;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey[300],
                                      ),
                                      child: Center(
                                        child: Text(
                                          rank.toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[800],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Icon(
                                      emotion.icon,
                                      color: emotion.category.color,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        emotion.label,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        border: Border.all(
                                          color: Colors.grey[300]!,
                                          width: 0.5,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        '$count건',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey[700],
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatItem(
    String emoji,
    String count,
    String label,
  ) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 8),
        Text(
          count,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyChart(List<Diary> diaries) {
    final now = DateTime.now();
    final weekDays = List.generate(7, (i) => now.subtract(Duration(days: 6 - i)));

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: weekDays.map((day) {
              final dayDiaries = diaries.where((diary) {
                return diary.createdAt.year == day.year &&
                    diary.createdAt.month == day.month &&
                    diary.createdAt.day == day.day;
              }).toList();

              final emotion =
                  dayDiaries.isNotEmpty ? dayDiaries.last.emotion : null;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          emotion?.icon ?? Icons.help_outline,
                          color: emotion?.category.color ?? Colors.grey[400],
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${day.month}/${day.day}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
