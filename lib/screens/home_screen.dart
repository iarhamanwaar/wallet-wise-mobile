import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallet_wise/constants/constants.dart';
import 'package:wallet_wise/screens/check_login.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? displayName;
  int? balance;
  int? income;
  int? expenses;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchUserBalance();
  }

  List<Map<String, String>> transactions = [
    {
      'name': 'Shopping',
      'description': 'Buy some groceries',
      'amount': '-12000',
      'time': '10:00 AM'
    },
    {
      'name': 'Utilities',
      'description': 'Electricity bill',
      'amount': '-5000',
      'time': '02:00 PM'
    },
    {
      'name': 'Salary',
      'description': 'Monthly salary',
      'amount': '200000',
      'time': '09:00 AM'
    },
    {
      'name': 'Rent',
      'description': 'Monthly house rent',
      'amount': '-40000',
      'time': '12:00 PM'
    },
    {
      'name': 'Dining Out',
      'description': 'Dinner at restaurant',
      'amount': '-15000',
      'time': '07:00 PM'
    },
    {
      'name': 'Gym',
      'description': 'Gym membership fee',
      'amount': '-3000',
      'time': '11:00 AM'
    },
    {
      'name': 'Transportation',
      'description': 'Monthly subway pass',
      'amount': '-10000',
      'time': '08:00 AM'
    },
    {
      'name': 'Entertainment',
      'description': 'Movie tickets',
      'amount': '-8000',
      'time': '06:00 PM'
    },
    {
      'name': 'Gift',
      'description': 'Birthday gift for friend',
      'amount': '-25000',
      'time': '03:00 PM'
    },
    {
      'name': 'Savings',
      'description': 'Monthly savings deposit',
      'amount': '50000',
      'time': '01:00 PM'
    },
  ];

  void fetchUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userData =
            await _firestore.collection('users').doc(user.uid).get();
        setState(() {
          displayName = userData['username'];
        });
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }

  void fetchUserBalance() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        QuerySnapshot balanceSnapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('Balances')
            .get();

        if (balanceSnapshot.docs.isNotEmpty) {
          setState(() {
            income = balanceSnapshot.docs.first.get('income');
            expenses = balanceSnapshot.docs.first.get('expenditures');
          });
        } else {
          throw Exception('No balance record found for user with ID');
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 330,
              width: double.infinity,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: SvgPicture.asset(
                      'assets/home-screen-bg.svg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 74,
                    left: 24,
                    child: Text(
                      'Good Evening',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w300,
                        fontSize: 24,
                        color: Colors.white,
                        letterSpacing: -0.45,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 111,
                    left: 24,
                    child: Text(
                      displayName ?? 'Fetching...',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                        color: Colors.white,
                        letterSpacing: -0.45,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 172,
                    left: 8,
                    right: 8,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                        left: 19,
                        right: 19,
                        top: 23,
                        bottom: 29,
                      ),
                      decoration: BoxDecoration(
                        color: kYellowColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Total Balance',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.white,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              const Icon(
                                Icons.keyboard_arrow_up_rounded,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Rs ${income != null && expenses != null ? income! - expenses! : ''}',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/income-icon.svg',
                                      ),
                                      const SizedBox(
                                        width: 6,
                                      ),
                                      Text(
                                        'Income',
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: const Color(0xFF0B8520),
                                          letterSpacing: -0.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Rs ${income ?? ''}',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                      color: Colors.white,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/expense-icon.svg',
                                      ),
                                      const SizedBox(
                                        width: 6,
                                      ),
                                      Text(
                                        'Expenses',
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: const Color(0xFFC40000),
                                          letterSpacing: -0.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Rs ${expenses ?? ''}',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                      color: Colors.white,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 19,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Transactions History',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.black,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();

                          if (mounted) {
                            Navigator.popUntil(context, (route) => false);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CheckLogin(),
                              ),
                            );
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF6A5931).withOpacity(0.65),
                        ),
                        child: Text(
                          'See All',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 7,
            ),
            ListView.separated(
              shrinkWrap: true,
              itemCount: transactions.length,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      width: 36,
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.amber,
                      ),
                    ),
                    const SizedBox(
                      width: 9,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            transactions[index]['name']!,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.black,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            transactions[index]['description']!,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.black38,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          transactions[index]['amount']!,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.black,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          transactions[index]['time']!,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.black,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 36,
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 22,
                );
              },
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
