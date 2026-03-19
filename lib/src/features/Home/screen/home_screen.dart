import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_size_converter/src/data/services/shared_preferences_service.dart';
import 'package:smart_size_converter/src/features/Bottems/screen/bottoms_screen.dart';
import 'package:smart_size_converter/src/features/Home/widgets/big_menu_button.dart';
import 'package:smart_size_converter/src/features/Profile/screen/profile_screen.dart';
import 'package:smart_size_converter/src/features/Tops/screen/tops_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    final userRepo = context.watch<SharedPreferencesService>();
    final profile = userRepo.currentProfile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfect Fit'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
       body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: GridView.count(
              shrinkWrap: true, 
              crossAxisCount: 2, 
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0, 
              physics: const NeverScrollableScrollPhysics(),
              children: [
                BigMenuButton(
                  icon: Icons.person,
                  label: 'Profil',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    );
                  },
                ),
                BigMenuButton(
                  icon: Icons.checkroom, 
                  label: 'Tops',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TopsScreen(),
                      ),
                    );
                  },
                ),
                BigMenuButton(
                  icon: Icons.accessibility_new,
                  label: 'Pants',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BottomsScreen(),
                      ),
                    );
                  },
                ),
                BigMenuButton(
                  icon: Icons.snowshoeing,
                  label: 'Shoes',
onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        // TODO: Create ShoesScreen and link here --- IGNORE ---
                        builder: (context) => const BottomsScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
