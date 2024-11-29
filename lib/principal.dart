import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'cart_page.dart'; // Adicionei a importação do CartPage

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final Map<String, List<Map<String, dynamic>>> categorizedMenuItems = {
    'Pizzas': [
      {
        'name': 'Pizza Margherita',
        'price': 29.90,
        'image': 'assets/images/pizza.jpeg',
        'description':
            'Deliciosa pizza com molho de tomate, mussarela e manjericão fresco.',
      },
      {
        'name': 'Pizza Pepperoni',
        'price': 35.90,
        'image': 'assets/images/pizza.jpeg',
        'description':
            'Pizza com fatias de pepperoni, molho de tomate e queijo mussarela.',
      },
    ],
    'Hambúrgueres': [
      {
        'name': 'Hambúrguer Clássico',
        'price': 19.90,
        'image': 'assets/images/hamburguer.jpeg',
        'description':
            'Hambúrguer suculento com queijo cheddar, alface, tomate e molho especial.',
      },
    ],
    'Massas': [
      {
        'name': 'Lasanha',
        'price': 25.90,
        'image': 'assets/images/lasanha.jpeg',
        'description':
            'Lasanha caseira com camadas de carne moída, molho de tomate e queijo.',
      },
    ],
    'Saladas': [
      {
        'name': 'Salada Caesar',
        'price': 15.90,
        'image': 'assets/images/salada.jpeg',
        'description':
            'Salada fresca com alface, croutons crocantes, queijo parmesão e molho Caesar.',
      },
    ],
  };

  final List<Map<String, dynamic>> cart = [];

  Future<void> saveOrderToFirestore(List<Map<String, dynamic>> cart) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final orders = FirebaseFirestore.instance.collection('orders');
      final snapshot = await orders.where('user_id', isEqualTo: user.uid).get();

      if (snapshot.docs.isNotEmpty) {
        // Atualiza o pedido existente
        final orderId = snapshot.docs.first.id;
        await orders.doc(orderId).update({'items': cart});
      } else {
        // Cria um novo pedido
        await orders.add({
          'user_id': user.uid,
          'items': cart,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar o pedido: $e')),
      );
    }
  }

  Future<void> loadOrderFromFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final orders = FirebaseFirestore.instance.collection('orders');
      final snapshot = await orders
          .where('user_id', isEqualTo: user.uid)
          .orderBy('timestamp', descending: true)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final orderData = snapshot.docs.first;
        final List<dynamic> items = orderData['items'] ?? [];
        setState(() {
          cart.clear();
          cart.addAll(items.cast<Map<String, dynamic>>());
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar o pedido: $e')),
      );
    }
  }

  void addToCart(Map<String, dynamic> item) {
    setState(() {
      cart.add(item);
    });
    saveOrderToFirestore(cart);
  }

  Future<void> logout() async {
    try {
      await saveOrderToFirestore(cart);
      await FirebaseAuth.instance.signOut();
      Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao fazer logout: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    loadOrderFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(192, 3, 7, 44),
      appBar: AppBar(
        title: const Text('Cardápio'),
        backgroundColor: const Color.fromARGB(255, 246, 246, 247),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(cart: cart),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: categorizedMenuItems.entries.map((category) {
            return Animate(
              effects: [FadeEffect(duration: 1000.ms)],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      category.key,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Column(
                    children: category.value.map((item) {
                      return Card(
                        color: const Color.fromARGB(100, 255, 255, 255),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              item['image'],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.image_not_supported),
                            ),
                          ),
                          title: Text(
                            item['name'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['description'],
                                style: const TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'R\$ ${item['price'].toStringAsFixed(2)}',
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                          trailing: ElevatedButton(
                            onPressed: () => addToCart(item),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              'Adicionar',
                              style: TextStyle(
                                color: Color.fromARGB(192, 3, 7, 44),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
