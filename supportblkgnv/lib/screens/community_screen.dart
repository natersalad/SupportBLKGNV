import 'package:flutter/material.dart';
import 'package:supportblkgnv/models/community_goal.dart';
import 'package:supportblkgnv/services/mock_community_service.dart';
import 'package:supportblkgnv/widgets/economic_impact_chart.dart';
import 'package:supportblkgnv/screens/community_map_screen.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:intl/intl.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
    with SingleTickerProviderStateMixin {
  final MockCommunityService _mockService = MockCommunityService();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Goals'),
            Tab(text: 'Impact'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildOverviewTab(), _buildGoalsTab(), _buildImpactTab()],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildCommunityStats(),
          _buildUpcomingEvents(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Theme.of(context).colorScheme.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Black Gainesville Community',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Supporting, connecting, and empowering the Black community in Gainesville, FL',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Implement join community feature
            },
            icon: const Icon(Icons.person_add),
            label: const Text('Join Community'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityStats() {
    final impactReport = _mockService.getImpactReports().first;
    final formatter = NumberFormat.compact();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Community Stats',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatCard(
                'Businesses',
                formatter.format(_mockService.getBusinesses().length),
                Icons.store,
                Colors.blue,
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                'Events',
                formatter.format(_mockService.getEvents().length),
                Icons.event,
                Colors.orange,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatCard(
                'Members',
                formatter.format(_mockService.getUsers().length),
                Icons.people,
                Colors.green,
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                'Economic Impact',
                '\$${formatter.format(impactReport.totalSpending)}',
                Icons.attach_money,
                Colors.purple,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingEvents() {
    final events = _mockService.getEvents().take(3).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Upcoming Events',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to events page
                },
                child: const Text('See All'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              final formattedDate = DateFormat(
                'MMM dd, yyyy',
              ).format(event.startTime);
              final formattedTime = DateFormat(
                'h:mm a',
              ).format(event.startTime);

              return Card(
                margin: const EdgeInsets.only(bottom: 16.0),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      event.imageUrl ?? 'https://via.placeholder.com/60',
                    ),
                  ),
                  title: Text(
                    event.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 16),
                          const SizedBox(width: 4),
                          Text(formattedDate),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 16),
                          const SizedBox(width: 4),
                          Text(formattedTime),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              event.location?.address ??
                                  'No location specified',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Navigate to event details
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsTab() {
    final goals = _mockService.getCommunityGoals();

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: goals.length,
      itemBuilder: (context, index) {
        final goal = goals[index];
        final progress = goal.currentAmount / goal.targetAmount;
        final formatter = NumberFormat.currency(symbol: '\$');

        return Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(goal.title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(goal.description),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${(progress * 100).toStringAsFixed(1)}% Complete',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${formatter.format(goal.currentAmount)} of ${formatter.format(goal.targetAmount)}',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(5),
                  backgroundColor: Colors.grey[300],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildGoalInfoRow(
                      Icons.calendar_today,
                      'Ends ${DateFormat('MMM dd').format(goal.endDate)}',
                    ),
                    _buildGoalInfoRow(
                      Icons.people,
                      '${goal.participants.length} Participants',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Navigate to goal details or contribution flow
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Contribute'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGoalInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildImpactTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          const EconomicImpactChart(
            title: 'Monthly Economic Impact',
            subtitle: 'Community spending over the past year',
            chartType: ChartType.line,
          ),
          const EconomicImpactChart(
            title: 'Impact by Category',
            subtitle: 'Where our community dollars are spent',
            chartType: ChartType.bar,
          ),
          const EconomicImpactChart(
            title: 'Spending Distribution',
            subtitle: 'Percentage breakdown by category',
            chartType: ChartType.pie,
          ),
          _buildImpactTimeline(),
        ],
      ),
    );
  }

  Widget _buildImpactTimeline() {
    final milestones = [
      {
        'date': 'Jan 2023',
        'title': 'Community Launch',
        'description':
            'Launched the Support BLK GNV initiative with 25 founding businesses',
        'isCompleted': true,
      },
      {
        'date': 'Mar 2023',
        'title': '\$100K Economic Impact',
        'description': 'Reached \$100,000 in tracked community spending',
        'isCompleted': true,
      },
      {
        'date': 'Jun 2023',
        'title': '50 Business Milestone',
        'description':
            'Directory expanded to include 50 Black-owned businesses',
        'isCompleted': true,
      },
      {
        'date': 'Sep 2023',
        'title': 'Community Center Fundraising',
        'description': 'Raised \$250,000 for the new community center space',
        'isCompleted': true,
      },
      {
        'date': 'Jan 2024',
        'title': '\$500K Economic Impact',
        'description': 'Celebrated half a million dollars in economic impact',
        'isCompleted': true,
      },
      {
        'date': 'Jun 2024',
        'title': 'Community Center Opening',
        'description':
            'Grand opening of the new Black Gainesville Community Center',
        'isCompleted': false,
      },
    ];

    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Impact Timeline',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: milestones.length,
              itemBuilder: (context, index) {
                final milestone = milestones[index];
                final isFirst = index == 0;
                final isLast = index == milestones.length - 1;
                final isCompleted = milestone['isCompleted'] as bool;

                return TimelineTile(
                  isFirst: isFirst,
                  isLast: isLast,
                  alignment: TimelineAlign.start,
                  indicatorStyle: IndicatorStyle(
                    width: 20,
                    color:
                        isCompleted
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey,
                    iconStyle: IconStyle(
                      color: Colors.white,
                      iconData:
                          isCompleted ? Icons.check : Icons.hourglass_empty,
                    ),
                  ),
                  endChild: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          milestone['date'] as String,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          milestone['title'] as String,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(milestone['description'] as String),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
