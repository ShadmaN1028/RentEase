import 'package:flutter/material.dart';
import 'package:rentease/utils/constants.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor.bgcolor,

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Section
              _buildHeroSection(),
              const SizedBox(height: 30),

              // Why RentEase?
              _buildSectionTitle("Why RentEase?"),
              const SizedBox(height: 16),
              _buildFeatureCard(
                icon: Icons.payment,
                title: "Hassle-Free Rent Payments",
                description:
                    "Pay rent securely, track dues, and get receipts—all in one place.",
              ),
              _buildFeatureCard(
                icon: Icons.home_work,
                title: "Digital Lease Management",
                description:
                    "No more paper contracts! Store agreements digitally & access anytime.",
              ),
              _buildFeatureCard(
                icon: Icons.handyman,
                title: "Instant Maintenance Requests",
                description:
                    "Report issues with a tap. Owners get notified immediately.",
              ),
              const SizedBox(height: 30),

              // How It Works
              _buildSectionTitle("How It Works"),
              const SizedBox(height: 16),
              _buildStepCard(
                step: "1",
                title: "Sign Up",
                subtitle: "Tenants & owners create profiles.",
              ),
              _buildStepCard(
                step: "2",
                title: "Manage Properties",
                subtitle: "Owners list flats; tenants apply.",
              ),
              _buildStepCard(
                step: "3",
                title: "Automate Rent & Requests",
                subtitle: "Payments, reminders, and repairs—all simplified.",
              ),
              const SizedBox(height: 30),

              // Testimonials (Optional)
              _buildSectionTitle("What Users Say"),
              const SizedBox(height: 16),
              _buildTestimonialCard(
                name: "Sarah K.",
                role: "Tenant",
                quote:
                    "Paying rent used to be stressful. Now it’s just a click!",
              ),
              _buildTestimonialCard(
                name: "Mr. Rahman",
                role: "Landlord",
                quote:
                    "Tracking 10+ tenants is now effortless. Highly recommend!",
              ),
              const SizedBox(height: 40),

              // CTA Button
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widgets for Clean Code ---
  Widget _buildHeroSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: BackgroundColor.bgcolor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Image.asset(
            "assets/images/renteaseLogo.png", // Replace with your asset
            height: 200,
          ),
          const SizedBox(height: 20),
          Text(
            "Rent Smarter, Not Harder",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: BackgroundColor.button,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Text(
            "The all-in-one app for tenants & landlords. Pay rent, manage leases, and request repairs—effortlessly.",
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: BackgroundColor.button,
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 32, color: BackgroundColor.button),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: BackgroundColor.button,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(description, style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepCard({
    required String step,
    required String title,
    required String subtitle,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.teal[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: BackgroundColor.bgcolor,
              child: Text(
                step,
                style: TextStyle(
                  color: BackgroundColor.button,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: BackgroundColor.button,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(color: Colors.grey[700])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestimonialCard({
    required String name,
    required String role,
    required String quote,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '"$quote"',
              style: TextStyle(
                fontSize: 15,
                fontStyle: FontStyle.italic,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "- $name ($role)",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
