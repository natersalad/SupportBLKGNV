import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  List<DocumentSnapshot> _results = [];
  bool _isLoading = false;

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) return;
    setState(() => _isLoading = true);

    // Simple “starts with” search on the name field
    final snap = await FirebaseFirestore.instance
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: '$query\uf8ff')
        .get();

    setState(() {
      _results = snap.docs;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search users by name',
            border: InputBorder.none,
          ),
          textInputAction: TextInputAction.search,
          onSubmitted: _search,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _results.length,
              itemBuilder: (ctx, i) {
                final data = _results[i].data() as Map<String, dynamic>;
                final uid = _results[i].id;
                final name = data['name'] as String? ?? 'No Name';
                final bio = data['bio'] as String? ?? '';
                final imageUrl = data['imageUrl'] as String? ?? '';

                return ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundImage: imageUrl.isNotEmpty
                        ? NetworkImage(imageUrl)
                        : null,
                    backgroundColor: Colors.grey.shade300,
                    child: imageUrl.isEmpty
                        ? const Icon(Icons.person, size: 20)
                        : null,
                  ),
                  title: Text(name),
                  subtitle: Text(bio, maxLines: 1, overflow: TextOverflow.ellipsis),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/public_profile',
                      arguments: uid,
                    ).then((didChange) {
                      if (didChange == true) {
                        // if they just followed/unfollowed, pop back to refresh
                        Navigator.pop(context, true);
                      }
                    });
                  },
                );
              },
            ),
    );
  }
}
