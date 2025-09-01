import 'package:flutter/material.dart';
import 'package:payment_apps/theme.dart';

void main() {
  runApp(const PaymentApps());
}

class PaymentApps extends StatefulWidget {
  const PaymentApps({super.key});

  @override
  State<PaymentApps> createState() => _PaymentAppsState();
}

class _PaymentAppsState extends State<PaymentApps> {
  int selectedIndex = -1;

  // ✅ Extract data ke list untuk menghindari repetitive code
  final List<Map<String, String>> plans = [
    {
      'plan': 'Basic',
      'subtitle': 'Good for starting up',
      'price': '\$9',
    },
    {
      'plan': 'Standard', 
      'subtitle': 'Most popular choice',
      'price': '\$20',
    },
    {
      'plan': 'Premium',
      'subtitle': 'Best for professionals',
      'price': '\$35',
    },
  ];

  void _selectPlan(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ✅ Add theme for consistency
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xff04112f),
      ),
      home: Scaffold(
        backgroundColor: const Color(0xff04112f), // ✅ Use const
        body: SafeArea( // ✅ Add SafeArea
          child: SingleChildScrollView( // ✅ Make scrollable
            child: Column(
              children: [
                const Header(),
                const SizedBox(height: 20), // ✅ Add spacing
                
                // ✅ Use ListView.builder instead of repetitive code
                ...List.generate(
                  plans.length,
                  (index) => Option(
                    plan: plans[index]['plan']!,
                    subtitle: plans[index]['subtitle']!,
                    price: plans[index]['price']!,
                    index: index,
                    selectedIndex: selectedIndex,
                    onTap: () => _selectPlan(index),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // ✅ Add CTA button
                if (selectedIndex != -1) 
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle subscription
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Selected: ${plans[selectedIndex]['plan']}'),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff007DFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 32, right: 32), // ✅ Reduced top padding karena ada SafeArea
      child: Column(
        children: [
          Center(
            child: Image.asset(
              'assets/images/image-1.png',
              width: 267,
              height: 200,
              // ✅ Add error handling
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 267,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                    size: 50,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 32),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: titleTextStyle,
              children: [
                TextSpan(text: "Upgrade to "),
                TextSpan(text: "Pro", style: titleProTextStyle),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text(
            "Go unlock all Features\n and Build your own Bigger NFT",
            style: subtitleTextStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class Option extends StatelessWidget {
  final int index;
  final int selectedIndex;
  final VoidCallback onTap;
  final String plan;
  final String subtitle;
  final String price;

  const Option({
    super.key,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
    required this.plan,
    required this.subtitle,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedIndex == index;
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer( // ✅ Add smooth animation
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8), // ✅ Better margin
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xff007DFF) : const Color(0xff4D5B7C),
            width: isSelected ? 2 : 1, // ✅ Dynamic border width
          ),
          // ✅ Add subtle background for selected
          color: isSelected ? const Color(0xff007DFF).withOpacity(0.1) : Colors.transparent,
        ),
        child: Row(
          children: [
            // ✅ Extract radio button to custom widget
            CustomRadioButton(
              isSelected: isSelected,
              selectedColor: const Color(0xff007DFF),
              unselectedColor: Colors.grey,
            ),
            const SizedBox(width: 20), // ✅ Reduced spacing
            Expanded( // ✅ Use Expanded instead of Column + Spacer
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(plan, style: planTextStyle),
                  const SizedBox(height: 4), // ✅ Add spacing between texts
                  Text(subtitle, style: subtitleTextStyle),
                ],
              ),
            ),
            Text(price, style: priceTextStyle),
          ],
        ),
      ),
    );
  }
}

// ✅ Extract radio button to reusable custom widget
class CustomRadioButton extends StatelessWidget {
  final bool isSelected;
  final Color selectedColor;
  final Color unselectedColor;
  final double size;

  const CustomRadioButton({
    super.key,
    required this.isSelected,
    this.selectedColor = Colors.blue,
    this.unselectedColor = Colors.grey,
    this.size = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer( // ✅ Add animation
      duration: const Duration(milliseconds: 200),
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? selectedColor : unselectedColor,
                width: 3,
              ),
            ),
          ),
          AnimatedContainer( // ✅ Animate inner circle
            duration: const Duration(milliseconds: 200),
            width: isSelected ? size * 0.5 : 0, // ✅ Dynamic size
            height: isSelected ? size * 0.5 : 0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? selectedColor : Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:payment_apps/theme.dart';

// void main() {
//   runApp(const PaymentApps());
// }

// class PaymentApps extends StatefulWidget {
//   const PaymentApps({super.key});

//   @override
//   State<PaymentApps> createState() => _PaymentAppsState();
// }

// class _PaymentAppsState extends State<PaymentApps> {
//   int selectedIndex = -1;
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         backgroundColor: Color(0xff04112f),
//         body: Column(
//           children: [
//             Header(),
//             Option(
//               plan: "Monthly",
//               subtitle: "Good for starting up",
//               price: '\$20',
//               index: 0,
//               selectedIndex: selectedIndex,
//               onTap: () {
//                 setState(() {
//                   selectedIndex = 0;
//                 });
//               },
//             ),
//             Option(
//               plan: "Monthly",
//               subtitle: "Good for starting up",
//               price: '\$20',
//               index: 1,
//               selectedIndex: selectedIndex,
//               onTap: () {
//                 setState(() {
//                   selectedIndex = 1;
//                 });
//               },
//             ),
//             Option(
//               plan: "Monthly",
//               subtitle: "Good for starting up",
//               price: '\$20',
//               index: 2,
//               selectedIndex: selectedIndex,
//               onTap: () {
//                 setState(() {
//                   selectedIndex = 2;
//                 });
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class Header extends StatelessWidget {
//   const Header({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 50, left: 32, right: 32),
//       child: Column(
//         children: [
//           Center(
//             child: Image.asset(
//               'assets/images/image-1.png',
//               width: 267,
//               height: 200,
//             ),
//           ),
//           SizedBox(height: 32),
//           RichText(
//             textAlign: TextAlign.center,
//             text: TextSpan(
//               style: titleTextStyle,
//               children: [
//                 TextSpan(text: "Upgrade to "),
//                 TextSpan(text: "Pro", style: titleProTextStyle),
//               ],
//             ),
//           ),
//           SizedBox(height: 32),
//           Text(
//             "Go unlock all Features\n and Build your own Bigger NFT",
//             style: subtitleTextStyle,
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class Option extends StatelessWidget {
//   final int index;
//   final int selectedIndex;
//   final VoidCallback onTap;
//   final String plan;
//   final String subtitle;
//   final String price;

//   const Option({
//     super.key,
//     required this.index,
//     required this.selectedIndex,
//     required this.onTap,
//     required this.plan,
//     required this.subtitle,
//     required this.price,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: EdgeInsets.all(20),
//         padding: EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(
//             color:
//                 selectedIndex == index ? Color(0xff007DFF) : Color(0xff4D5B7C),
//           ),
//         ),
//         child: Row(
//           children: [
//             selectedIndex == index
//                 ? SizedBox(
//                   width: 20,
//                   height: 20,
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       Container(
//                         width: 20,
//                         height: 20,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(color: Colors.blue, width: 3),
//                         ),
//                       ),
//                       Container(
//                         width: 10,
//                         height: 10,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Colors.blue,
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//                 : SizedBox(
//                   width: 20,
//                   height: 20,
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       Container(
//                         width: 20,
//                         height: 20,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(color: Colors.grey, width: 3),
//                         ),
//                       ),
//                       Container(
//                         width: 10,
//                         height: 10,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//             SizedBox(width: 30),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(plan, style: planTextStyle),
//                 Text(subtitle, style: subtitleTextStyle),
//               ],
//             ),
//             Spacer(),
//             Text(price, style: priceTextStyle),
//           ],
//         ),
//       ),
//     );
//   }
// }