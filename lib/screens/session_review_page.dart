import 'package:flutter/material.dart';
import '../models/session.dart';

class SessionReviewPage extends StatefulWidget {
  @override
  _SessionReviewPageState createState() => _SessionReviewPageState();
}

class _SessionReviewPageState extends State<SessionReviewPage> {
  late List<Session> _sessions;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    // This would use the session service in a real app
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _sessions = [
        Session(
          id: '1',
          customer: 'John Smith',
          time: '10:05 AM',
          duration: '12m 34s',
          emotion: 'Angry',
          agentAction: 'Escalated to supervisor',
          emotionColor: Colors.red,
        ),
        Session(
          id: '2',
          customer: 'Sarah Johnson',
          time: '11:32 AM',
          duration: '8m 12s',
          emotion: 'Happy',
          agentAction: 'Resolved issue',
          emotionColor: Colors.green,
        ),
        Session(
          id: '3',
          customer: 'Michael Brown',
          time: '01:45 PM',
          duration: '15m 47s',
          emotion: 'Confused',
          agentAction: 'Provided detailed guide',
          emotionColor: Colors.blue,
        ),
        Session(
          id: '4',
          customer: 'Emily Davis',
          time: '03:20 PM',
          duration: '5m 39s',
          emotion: 'Frustrated',
          agentAction: 'Offered discount',
          emotionColor: Colors.orange,
        ),
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Session History'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              // Filter sessions
              _showFilterOptions(context);
            },
          ),
        ],
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: _sessions.length,
                itemBuilder: (context, index) {
                  final session = _sessions[index];
                  return _buildSessionCard(session);
                },
              ),
    );
  }

  Widget _buildSessionCard(Session session) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  session.customer,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(session.time, style: TextStyle(color: Colors.grey)),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(
                  'Duration: ${session.duration}',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: session.emotionColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.emoji_emotions,
                        size: 16,
                        color: session.emotionColor,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Primary: ${session.emotion}',
                        style: TextStyle(
                          color: session.emotionColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              'Agent Action:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(session.agentAction),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    // View session details
                    _showSessionDetails(session);
                  },
                  child: Text('VIEW DETAILS'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Filter Sessions'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('All Emotions'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Happy'),
                onTap: () {
                  Navigator.pop(context);
                  // Filter by happy
                },
              ),
              ListTile(
                title: Text('Angry'),
                onTap: () {
                  Navigator.pop(context);
                  // Filter by angry
                },
              ),
              ListTile(
                title: Text('Confused'),
                onTap: () {
                  Navigator.pop(context);
                  // Filter by confused
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('CANCEL'),
            ),
          ],
        );
      },
    );
  }

  void _showSessionDetails(Session session) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SessionDetailPage(session: session),
      ),
    );
  }
}

class SessionDetailPage extends StatelessWidget {
  final Session session;

  const SessionDetailPage({Key? key, required this.session}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Session Details')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customer Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    _buildInfoRow('Name', session.customer),
                    _buildInfoRow('Time', session.time),
                    _buildInfoRow('Duration', session.duration),
                    _buildInfoRow('Primary Emotion', session.emotion),
                    _buildInfoRow('Agent Action', session.agentAction),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Emotion Timeline',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Container(
              height: 200,
              child: Center(child: Text('Emotion Graph Placeholder')),
            ),
            SizedBox(height: 24),
            Text(
              'Call Transcript',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTranscriptMessage(
                      'Customer',
                      'Hi, I\'m having trouble with my account.',
                      '10:05:23',
                    ),
                    _buildTranscriptMessage(
                      'Agent',
                      'I understand. What specific issue are you experiencing?',
                      '10:05:45',
                    ),
                    _buildTranscriptMessage(
                      'Customer',
                      'I can\'t log in and I\'ve tried resetting my password three times!',
                      '10:06:10',
                      emotion: 'Frustrated',
                    ),
                    _buildTranscriptMessage(
                      'Agent',
                      'I apologize for the frustration. Let me help you resolve this immediately.',
                      '10:06:30',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
          ),
          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildTranscriptMessage(
    String sender,
    String message,
    String time, {
    String? emotion,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(sender, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(time, style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          SizedBox(height: 4),
          Text(message),
          if (emotion != null) ...[
            SizedBox(height: 4),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Emotion: $emotion',
                style: TextStyle(color: Colors.orange, fontSize: 12),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
