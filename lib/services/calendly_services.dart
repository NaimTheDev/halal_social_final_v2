import 'package:pkce/pkce.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> initiateCalendlyAuth() async {
  final pkcePair = PkcePair.generate();

  // ✅ Save verifier to Firestore
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) throw Exception('User not logged in');

  await FirebaseFirestore.instance.collection('calendly_pkce').doc(uid).set({
    'codeVerifier': pkcePair.codeVerifier,
  });

  final redirectUri =
      'https://us-central1-halal-social-prod.cloudfunctions.net/calendlyOAuthRedirect';
  final clientId = 'eZFqOyoS9EKUn4Yc8lxK2mbftcaQii1roX7av-zEiFU';
  final state = uid; // or session ID

  final uri = Uri.https('auth.calendly.com', '/oauth/authorize', {
    'client_id': clientId,
    'response_type': 'code',
    'redirect_uri': redirectUri,
    // 'code_challenge': pkcePair.codeChallenge,
    // 'code_challenge_method': 'S256',
    'state': state,
    'prompt': 'login', // Optional but ensures fresh prompt
  });
  print('🔗 Calendly Auth URL: ${uri.toString()}');
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    throw Exception('Could not launch Calendly auth URL');
  }
}
