import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter/features/auth/domain/services/user_session_service.dart';
import 'package:twitter/features/feed/presentation/bloc/create_post/create_post_bloc.dart';
import 'package:twitter/features/feed/presentation/bloc/feed/feed_bloc.dart';
import 'package:twitter/features/feed/presentation/screens/widgets/post_card.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  void initState() {
    context.read<FeedBloc>().add(FetchPostsRequested());
    super.initState();
  }

  void _showCreatePostModal(BuildContext context) {
    final TextEditingController contentController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return BlocConsumer<CreatePostBloc, CreatePostState>(
          listener: (context, state) {
            if (state is CreatePostSuccess) {
              Navigator.pop(context);
              context.read<FeedBloc>().add(FetchPostsRequested());
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Post created!')));
            } else if (state is CreatePostFailure) {
              Navigator.pop(context);
              context.read<FeedBloc>().add(FetchPostsRequested());
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            return SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: Padding(
                padding: EdgeInsetsGeometry.all(16),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(radius: 20),
                          SizedBox(width: 20),
                          Expanded(
                            child: TextFormField(
                              controller: contentController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: "What's happening?",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                              ),
                              validator: (value) =>
                                  value == null || value.trim().isEmpty
                                  ? 'Content is required'
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: state is CreatePostLoading
                              ? null
                              : () async {
                                  if (formKey.currentState!.validate()) {
                                    final userSession = await context
                                        .read<UserSessionService>()
                                        .getUserSession();

                                    if (userSession != null) {
                                      if (!context.mounted) return;
                                      context.read<CreatePostBloc>().add(
                                        CreatePostRequested(
                                          userId: userSession.id,
                                          username: userSession.email,
                                          content: contentController.text
                                              .trim(),

                                          imageUrl: '',
                                        ),
                                      );
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: state is CreatePostLoading
                              ? SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(),
                                )
                              : Text(
                                  'Post',
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0.5,
        leading: Padding(
          padding: EdgeInsetsGeometry.all(8),
          child: CircleAvatar(backgroundColor: Colors.grey[800]),
        ),
        title: Image.asset('assets/images/logo.png', width: 24, height: 24),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.mail_outline, color: Colors.white),
          ),
          IconButton(
            onPressed: () async {
              await context.read<UserSessionService>().logout();
              if (!context.mounted) return;
              Navigator.pushReplacementNamed(context, '/splash');
            },
            icon: Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: BlocBuilder<FeedBloc, FeedState>(
        builder: (context, state) {
          if (state is FeedLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is FeedLoaded) {
            final posts = state.posts;
            if (posts.isEmpty) {
              return Center(child: Text('Posts empty'));
            }

            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) => PostCard(post: posts[index]),
            );
          } else if (state is FeedFailure) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreatePostModal(context),
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
