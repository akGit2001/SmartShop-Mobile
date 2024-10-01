// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// class BuyerProfilePage extends StatefulWidget {
//   const BuyerProfilePage({super.key});

//   @override
//   _BuyerProfilePageState createState() => _BuyerProfilePageState();
// }

// class _BuyerProfilePageState extends State<BuyerProfilePage> {
//   final ImagePicker _picker = ImagePicker();
//   File? _profileImage;
//   bool _isEditingName = false;
//   bool _isEditingEmail = false;
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _postController = TextEditingController();
//   File? _postImage;
//   List<Post> _posts = [];

//   // Sample buyer data
//   String buyerName = "";
//   String buyerEmail = "";

//   @override
//   void initState() {
//     super.initState();
//     _nameController.text = buyerName;
//     _emailController.text = buyerEmail;
//     _checkForEmptyProfile();
//   }

//   Future<void> _checkForEmptyProfile() async {
//     if (buyerName.isEmpty) {
//       await _promptForName();
//     }
//     if (buyerEmail.isEmpty) {
//       await _promptForEmail();
//     }
//   }

//   Future<void> _promptForName() async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false, // User must enter a name
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Enter your name'),
//           content: TextField(
//             controller: _nameController,
//             decoration: const InputDecoration(labelText: 'Name'),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Save'),
//               onPressed: () {
//                 setState(() {
//                   buyerName = _nameController.text;
//                 });
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> _promptForEmail() async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false, // User must enter an email
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Enter your email'),
//           content: TextField(
//             controller: _emailController,
//             decoration: const InputDecoration(labelText: 'Email'),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Save'),
//               onPressed: () {
//                 setState(() {
//                   buyerEmail = _emailController.text;
//                 });
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> _pickImage(ImageSource source) async {
//     final pickedFile = await _picker.pickImage(source: source);
//     if (pickedFile != null) {
//       setState(() {
//         _profileImage = File(pickedFile.path);
//       });
//     }
//   }

//   Future<void> _pickPostImage(ImageSource source) async {
//     final pickedFile = await _picker.pickImage(source: source);
//     if (pickedFile != null) {
//       setState(() {
//         _postImage = File(pickedFile.path);
//       });
//     }
//   }

//   void _toggleEditingName() {
//     setState(() {
//       _isEditingName = !_isEditingName;
//       if (!_isEditingName) {
//         buyerName = _nameController.text;
//       }
//     });
//   }

//   void _toggleEditingEmail() {
//     setState(() {
//       _isEditingEmail = !_isEditingEmail;
//       if (!_isEditingEmail) {
//         buyerEmail = _emailController.text;
//       }
//     });
//   }

//   void _addPost() {
//     setState(() {
//       if (_postController.text.isNotEmpty || _postImage != null) {
//         _posts.add(Post(text: _postController.text, image: _postImage));
//         _postController.clear();
//         _postImage = null;
//       }
//     });
//   }

//   void _openSettings() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => BuyerSettingsPage()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Buyer Profile'),
//         backgroundColor: Colors.blue,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.settings),
//             onPressed: _openSettings,
//           ),
//           IconButton(
//             icon: Icon(Icons.chat),
//             onPressed: () {
//               Navigator.pushNamed(context, '/chat');
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           padding: EdgeInsets.all(16.0),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [Colors.blue, Colors.purple],
//             ),
//           ),
//           child: Column(
//             children: <Widget>[
//               GestureDetector(
//                 onTap: () {
//                   _showImagePickerOptions(context);
//                 },
//                 child: CircleAvatar(
//                   radius: 50,
//                   backgroundImage: _profileImage != null
//                       ? FileImage(_profileImage!)
//                       : NetworkImage("https://via.placeholder.com/150") as ImageProvider,
//                   child: _profileImage == null
//                       ? Icon(
//                           Icons.camera_alt,
//                           size: 50,
//                           color: Colors.white.withOpacity(0.7),
//                         )
//                       : null,
//                 ),
//               ),
//               SizedBox(height: 20),
//               _isEditingName
//                   ? TextField(
//                       controller: _nameController,
//                       decoration: InputDecoration(
//                         labelText: 'Name',
//                         border: OutlineInputBorder(),
//                       ),
//                       onSubmitted: (newName) {
//                         _toggleEditingName();
//                       },
//                     )
//                   : GestureDetector(
//                       onTap: _toggleEditingName,
//                       child: Text(
//                         buyerName.isNotEmpty ? buyerName : 'Add your name',
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//               SizedBox(height: 10),
//               _isEditingEmail
//                   ? TextField(
//                       controller: _emailController,
//                       decoration: InputDecoration(
//                         labelText: 'Email',
//                         border: OutlineInputBorder(),
//                       ),
//                       onSubmitted: (newEmail) {
//                         _toggleEditingEmail();
//                       },
//                     )
//                   : GestureDetector(
//                       onTap: _toggleEditingEmail,
//                       child: Text(
//                         buyerEmail.isNotEmpty ? buyerEmail : 'Add your email',
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.grey[300],
//                         ),
//                       ),
//                     ),
//               SizedBox(height: 20),
//               TextField(
//                 controller: _postController,
//                 decoration: InputDecoration(
//                   labelText: 'Add a post',
//                   border: OutlineInputBorder(),
//                   suffixIcon: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       IconButton(
//                         icon: Icon(Icons.camera_alt),
//                         onPressed: () {
//                           _showPostImagePickerOptions(context);
//                         },
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.send),
//                         onPressed: _addPost,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               if (_postImage != null)
//                 Image.file(
//                   _postImage!,
//                   height: 200,
//                 ),
//               SizedBox(height: 20),
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 itemCount: _posts.length,
//                 itemBuilder: (context, index) {
//                   return Card(
//                     color: Colors.white,
//                     margin: EdgeInsets.symmetric(vertical: 10),
//                     child: ListTile(
//                       title: Text(_posts[index].text),
//                       leading: _posts[index].image != null
//                           ? Image.file(
//                               _posts[index].image!,
//                               width: 50,
//                             )
//                           : null,
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showImagePickerOptions(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return SafeArea(
//           child: Wrap(
//             children: <Widget>[
//               ListTile(
//                 leading: Icon(Icons.photo_library),
//                 title: Text('Gallery'),
//                 onTap: () {
//                   _pickImage(ImageSource.gallery);
//                   Navigator.of(context).pop();
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.photo_camera),
//                 title: Text('Camera'),
//                 onTap: () {
//                   _pickImage(ImageSource.camera);
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _showPostImagePickerOptions(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return SafeArea(
//           child: Wrap(
//             children: <Widget>[
//               ListTile(
//                 leading: Icon(Icons.photo_library),
//                 title: Text('Gallery'),
//                 onTap: () {
//                   _pickPostImage(ImageSource.gallery);
//                   Navigator.of(context).pop();
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.photo_camera),
//                 title: Text('Camera'),
//                 onTap: () {
//                   _pickPostImage(ImageSource.camera);
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// class Post {
//   final String text;
//   final File? image;

//   Post({required this.text, this.image});
// }

// class BuyerSettingsPage extends StatefulWidget {
//   @override
//   _BuyerSettingsPageState createState() => _BuyerSettingsPageState();
// }

// class _BuyerSettingsPageState extends State<BuyerSettingsPage> {
//   TextEditingController _nameController = TextEditingController();
//   TextEditingController _emailController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Settings"),
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Colors.blue, // Start color
//               Colors.purple, // End color,
//             ],
//           ),
//         ),
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             ListTile(
//               leading: Icon(Icons.person),
//               title: Text('Edit Profile'),
//               onTap: () {
//                 _showEditProfileDialog(context);
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.notifications),
//               title: Text('Notifications'),
//               onTap: () {
//                 // Navigate to notifications settings if needed
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.security),
//               title: Text('Privacy'),
//               onTap: () {
//                 // Navigate to privacy settings if needed
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.logout),
//               title: Text('Log Out'),
//               onTap: () {
//                 // Log out action
//                 // For now, we will just navigate back to the login page
//                 Navigator.of(context).popUntil((route) => route.isFirst);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showEditProfileDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Edit Profile'),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 TextField(
//                   controller: _nameController,
//                   decoration: InputDecoration(labelText: 'Name'),
//                 ),
//                 SizedBox(height: 8.0),
//                 TextField(
//                   controller: _emailController,
//                   decoration: InputDecoration(labelText: 'Email'),
//                 ),
//                 SizedBox(height: 16.0),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: Text('Save'),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     home: BuyerProfilePage(),
//     routes: {'/chat': (context) => Scaffold(body: Center(child: Text('Chat Page')))},
//   ));
// }

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:smartshop/HomePage/Shop.dart';

void main() {
  runApp(MaterialApp(
    home: BuyerProfilePage(),
    routes: {
      '/chat': (context) => Scaffold(body: Center(child: Text('Chat Page'))),
      '/shop': (context) => ShopPage(),
    },
  ));
}

class BuyerProfilePage extends StatefulWidget {
  const BuyerProfilePage({super.key});

  @override
  _BuyerProfilePageState createState() => _BuyerProfilePageState();
}

class _BuyerProfilePageState extends State<BuyerProfilePage> {
  final ImagePicker _picker = ImagePicker();
  File? _profileImage;
  bool _isEditingName = false;
  bool _isEditingEmail = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _postController = TextEditingController();
  File? _postImage;
  List<Post> _posts = [];

  // Sample buyer data
  String buyerName = "";
  String buyerEmail = "";

  @override
  void initState() {
    super.initState();
    _nameController.text = buyerName;
    _emailController.text = buyerEmail;
    _checkForEmptyProfile();
  }

  Future<void> _checkForEmptyProfile() async {
    if (buyerName.isEmpty) {
      await _promptForName();
    }
    if (buyerEmail.isEmpty) {
      await _promptForEmail();
    }
  }

  Future<void> _promptForName() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must enter a name
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter your name'),
          content: TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                setState(() {
                  buyerName = _nameController.text;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _promptForEmail() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must enter an email
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter your email'),
          content: TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                setState(() {
                  buyerEmail = _emailController.text;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickPostImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _postImage = File(pickedFile.path);
      });
    }
  }

  void _toggleEditingName() {
    setState(() {
      _isEditingName = !_isEditingName;
      if (!_isEditingName) {
        buyerName = _nameController.text;
      }
    });
  }

  void _toggleEditingEmail() {
    setState(() {
      _isEditingEmail = !_isEditingEmail;
      if (!_isEditingEmail) {
        buyerEmail = _emailController.text;
      }
    });
  }

  void _addPost() {
    setState(() {
      if (_postController.text.isNotEmpty || _postImage != null) {
        _posts.add(Post(text: _postController.text, image: _postImage));
        _postController.clear();
        _postImage = null;
      }
    });
  }

  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BuyerSettingsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buyer Profile'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
             // Navigator.pushNamed(context, '/shop');
            Navigator.push(context, MaterialPageRoute(builder: (context) => Shop()));
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: _openSettings,
          ),
          IconButton(
            icon: Icon(Icons.chat),
            onPressed: () {
              Navigator.pushNamed(context, '/chat');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue, Colors.purple],
            ),
          ),
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  _showImagePickerOptions(context);
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : NetworkImage("https://via.placeholder.com/150") as ImageProvider,
                  child: _profileImage == null
                      ? Icon(
                          Icons.camera_alt,
                          size: 50,
                          color: Colors.white.withOpacity(0.7),
                        )
                      : null,
                ),
              ),
              SizedBox(height: 20),
              _isEditingName
                  ? TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (newName) {
                        _toggleEditingName();
                      },
                    )
                  : GestureDetector(
                      onTap: _toggleEditingName,
                      child: Text(
                        buyerName.isNotEmpty ? buyerName : 'Add your name',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
              SizedBox(height: 10),
              _isEditingEmail
                  ? TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (newEmail) {
                        _toggleEditingEmail();
                      },
                    )
                  : GestureDetector(
                      onTap: _toggleEditingEmail,
                      child: Text(
                        buyerEmail.isNotEmpty ? buyerEmail : 'Add your email',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
              SizedBox(height: 20),
              TextField(
                controller: _postController,
                decoration: InputDecoration(
                  labelText: 'Add a post',
                  border: OutlineInputBorder(),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: () {
                          _showPostImagePickerOptions(context);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: _addPost,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (_postImage != null)
                Image.file(
                  _postImage!,
                  height: 200,
                ),
              SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _posts.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      title: Text(_posts[index].text),
                      leading: _posts[index].image != null
                          ? Image.file(
                              _posts[index].image!,
                              width: 50,
                            )
                          : null,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPostImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () {
                  _pickPostImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () {
                  _pickPostImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class Post {
  final String text;
  final File? image;

  Post({required this.text, this.image});
}

class BuyerSettingsPage extends StatefulWidget {
  @override
  _BuyerSettingsPageState createState() => _BuyerSettingsPageState();
}

class _BuyerSettingsPageState extends State<BuyerSettingsPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue, // Start color
              Colors.purple, // End color,
            ],
          ),
        ),
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Edit Profile'),
              onTap: () {
                _showEditProfileDialog(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifications'),
              onTap: () {
                // Navigate to notifications settings if needed
              },
            ),
            ListTile(
              leading: Icon(Icons.security),
              title: Text('Privacy'),
              onTap: () {
                // Navigate to privacy settings if needed
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Log Out'),
              onTap: () {
                // Log out action
                // For now, we will just navigate back to the login page
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                SizedBox(height: 8.0),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ShopPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shop"),
      ),
      body: Center(
        child: Text('Welcome to the Shop Page!'),
      ),
    );
  }
}

