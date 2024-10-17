import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  // Lista de itens do cardápio com descrição, divididos por categoria
  final Map<String, List<Map<String, dynamic>>> categorizedMenuItems = {
    'Pizzas': [
      {
        'name': 'Pizza Margherita',
        'price': 29.90,
        'image': 'assets/images/pizza.jpeg',
        'description': 'Deliciosa pizza com molho de tomate, mussarela e manjericão fresco.'
      },
      {
        'name': 'Pizza Pepperoni',
        'price': 35.90,
        'image': 'assets/images/pepperoni.jpeg',
        'description': 'Pizza com fatias de pepperoni, molho de tomate e queijo mussarela.'
      },
    ],
    'Hambúrgueres': [
      {
        'name': 'Hambúrguer Clássico',
        'price': 19.90,
        'image': 'assets/images/hamburguer.jpeg',
        'description': 'Hambúrguer suculento com queijo cheddar, alface, tomate e molho especial.'
      },
    ],
    'Massas': [
      {
        'name': 'Lasanha',
        'price': 25.90,
        'image': 'assets/images/lasanha.jpeg',
        'description': 'Lasanha caseira com camadas de carne moída, molho de tomate e queijo.'
      },
    ],
    'Saladas': [
      {
        'name': 'Salada Caesar',
        'price': 15.90,
        'image': 'assets/images/salada.jpeg',
        'description': 'Salada fresca com alface, croutons crocantes, queijo parmesão e molho Caesar.'
      },
    ],
  };

  // Simulação de um pedido (lista de itens adicionados)
  final List<Map<String, dynamic>> cart = [];

  // Função para adicionar itens ao pedido
  void addToCart(Map<String, dynamic> item) {
    setState(() {
      cart.add(item);
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${item['name']} adicionado ao pedido!'),
    ));
  }

  // Função de logout
  void logout() {
    Navigator.pushReplacementNamed(context, '/login'); // Exemplo de redirecionamento para tela de login
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(192, 3, 7, 44),
      appBar: AppBar(
        title: const Text('Cardápio'),
        backgroundColor: const Color.fromARGB(255, 246, 246, 247),
        actions: [
          // Botão para ver o resumo do pedido
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage(cart: cart)),
              );
            },
          ),
          // Botão de logout
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
            return Column(
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
                        title: Text(
                          item['name'],
                          style: const TextStyle(color: Colors.white, fontSize: 18),
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
                          onPressed: () {
                            addToCart(item);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
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
            );
          }).toList(),
        ),
      ),
    );
  }
}

// Página de Resumo do Pedido
class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cart;

  const CartPage({super.key, required this.cart});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Função para remover itens do pedido
  void removeFromCart(int index) {
    setState(() {
      widget.cart.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Item removido do pedido!'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    double total = widget.cart.fold(0, (sum, item) => sum + item['price']);

    return Scaffold(
      backgroundColor: const Color.fromARGB(192, 3, 7, 44),
      appBar: AppBar(
        title: const Text('Seu Pedido'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.cart.length,
                itemBuilder: (context, index) {
                  final item = widget.cart[index];
                  return Card(
                    color: const Color.fromARGB(100, 255, 255, 255),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      title: Text(
                        item['name'],
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      subtitle: Text(
                        'R\$ ${item['price'].toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () {
                          removeFromCart(index);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Total: R\$ ${total.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.white, fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Pedido Confirmado'),
                    content: const Text('Seu pedido foi realizado com sucesso!'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.25, // Botão maior em telas pequenas
                  vertical: screenHeight * 0.02,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Confirmar Pedido',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(192, 3, 7, 44),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
