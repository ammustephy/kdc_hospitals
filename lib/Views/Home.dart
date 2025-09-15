import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:collection/collection.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import 'package:intl/intl.dart';

import '../Provider/Booking_Provider.dart';
import '../Provider/Home_Provider.dart';
import '../Provider/News_Provider.dart';
import 'Notifications.dart';
import 'Profile.dart';
import 'Settings.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  final storage = const FlutterSecureStorage();
  int _idx = 0, _catIdx = -1;

  Future<void> _onRefresh() async {
    await Provider.of<NewsProvider>(context, listen: false).fetchNews();
    // Optionally reload other data
  }

  void _switchAccount() => showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Switch Account'),
      content: const Text('Do you want to add another account?'),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context), // close dialog
        ),
        TextButton(
          child: const Text('Add Account'),
          onPressed: () {
            Navigator.pop(context);
            // Navigate to your Add Account page / form here
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AddAccountPage(), // <-- your custom page
              ),
            );
          },
        ),
      ],
    ),
  );

  void _onNav(int i) {
    setState(() => _idx = i);
    switch (i) {
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsPage()));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (_) =>  SettingsPage()));
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (_) =>  ProfilePage()));
        break;
      default:
    }
  }

  void _onCat(int i, Widget? page) {
    setState(() => _catIdx = i);
    if (page != null) Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final homeProv = context.watch<HomeProvider>();
    final bookProv = context.watch<BookingProvider>();
    final newsProv = context.watch<NewsProvider>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 120,
        backgroundColor: Colors.transparent, // important for gradient to show
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.shade900,
                Colors.blue.shade500,
              ],
            ),
          ),
        ),
        title: Column(
          children: [
            SizedBox(height: 10,),
            Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset('assets/images/KDCH-logo.jpg', height: 25),
                      const SizedBox(width: 8),
                      const Text('KDCH',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                          color: Colors.white)),
                    ]),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (v) => homeProv.search = v,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.switch_account, size: 28, color: Colors.black),
                  tooltip: 'Switch Account',
                  onPressed: _switchAccount,
                ),
              ],
            ),
          ],
        ),
      ),
      extendBody: true,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Stack(children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 70),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              // ensures pull-to-refresh always works :contentReference[oaicite:1]{index=1}
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
                // 📢 News Carousel Slider
                if (newsProv.news.isNotEmpty)
                  SliverToBoxAdapter(
                    child: CarouselSlider.builder(
                      itemCount: newsProv.news.length,
                      itemBuilder: (ctx, idx, realIdx) {
                        final article = newsProv.news[idx];
                        return SizedBox(
                          width: MediaQuery.of(ctx).size.width,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              color: Colors.blue.shade200,
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(article.title,
                                      style: const TextStyle(fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center),
                                  const SizedBox(height: 8),
                                  Text(article.date,
                                      style: const TextStyle(fontSize: 14,
                                          color: Colors.black)),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      options: CarouselOptions(
                        height: 130,
                        viewportFraction: 1.0,            // full screen width :contentReference[oaicite:1]{index=1}
                        autoPlay: true,
                        enlargeCenterPage: false,        // disable center enlargement if full width
                        autoPlayInterval: const Duration(seconds: 4),
                        padEnds: false,                  // optional: removes padding at edges :contentReference[oaicite:2]{index=2}
                      ),
                    ),
                  ),
                if (newsProv.news.isNotEmpty) const SliverToBoxAdapter(child: SizedBox(height: 25)
                ),
                // Appointments Section
                SliverToBoxAdapter(
                  child: bookProv.bookings.isEmpty
                      ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text("No active appointments", style: TextStyle(fontSize: 16)),
                  )
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text("Active Appointments",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 8),
                      ...bookProv.bookings.mapIndexed((idx, b) {
                        final first = idx == 0;
                        return Card(
                          color: first ? Colors.blue.shade50 : null,
                          elevation: first ? 6 : 2,
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          child: ListTile(
                            title: Text(
                              "${b.department} • ${b.slot} on ${DateFormat.yMMMEd().format(b.date)}",
                              style: TextStyle(fontWeight: first ? FontWeight.bold : null),
                            ),
                            subtitle: Text(b.mode == AppointmentMode.online ? 'Online' : 'Offline'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => bookProv.deleteBookingAt(idx),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 15)),
                // Categories Grid
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisExtent: 140,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    delegate: SliverChildBuilderDelegate(
                          (_, i) {
                        final cat = homeProv.categories[i];
                        final selected = i == _catIdx;
                        return GestureDetector(
                          onTap: () => _onCat(i, cat.page),
                          child: Card(
                            elevation: selected ? 8 : 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                color: selected ? Colors.blue : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(cat.imageUrl,
                                      width: 50, height: 50, fit: BoxFit.cover),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  cat.name,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(fontWeight: selected ? FontWeight.bold : null),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: homeProv.categories.length,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                    child: SizedBox(height: 15)),
              ],
            ),
          ),
        ]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: PhysicalShape(
          elevation: 10,
          color: Colors.white,
          shadowColor: Colors.black38,
          clipper: const ShapeBorderClipper(shape: StadiumBorder()),
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: const ShapeDecoration(shape: StadiumBorder(), color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(4, (i) {
                const icons = [
                  Icons.home_filled,
                  Icons.notifications_active,
                  // Icons.calendar_today,
                  Icons.settings,
                  Icons.person_outline,
                ];
                final active = _idx == i;
                return IconButton(
                  icon: Icon(icons[i], color: active ? Colors.black : Colors.grey),
                  onPressed: () => _onNav(i),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}


class AddAccountPage extends StatefulWidget {
  const AddAccountPage({super.key});

  @override
  State<AddAccountPage> createState() => _AddAccountPageState();
}
class _AddAccountPageState extends State<AddAccountPage> {
  final _formKey = GlobalKey<FormState>();
  // Controllers to capture form input
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  void _saveAccount() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      // Simulate API/Database call delay
      Future.delayed(const Duration(seconds: 2), () {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account added successfully!')),
        );
        Navigator.pop(context); // go back to previous screen
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Account')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.trim().isEmpty ? 'Enter your name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your email';
                  }
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) => value != null && value.length < 6
                    ? 'Password must be at least 6 characters'
                    : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveAccount,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.blue.shade900,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Add Account', style: TextStyle(fontSize: 16,color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


