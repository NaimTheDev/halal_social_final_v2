// eslint-disable-next-line object-curly-spacing
import { initializeApp, applicationDefault } from "firebase-admin/app";
// eslint-disable-next-line object-curly-spacing
import { getFirestore } from "firebase-admin/firestore";

initializeApp({
  credential: applicationDefault(),
});

const firestore = getFirestore();

async function seedFirestoreData() {
  // Seed Mentor data
  const mentors = [
    {
      id: "mentor1",
      name: "Ahmed Ali",
      bio:
        "Expert in Quranic studies and Islamic theology." +
        " Over 20 years of teaching experience.",
      expertise: "Quranic Studies",
      imageUrl: "https://example.com/ahmed_ali.jpg",
      calendlyUrl: "https://calendly.com/naimabubaker/test-meeting",
      categories: ["Islamic Studies", "Quran"],
    },
    {
      id: "mentor2",
      name: "Fatima Noor",
      bio: "Specialist in Islamic history and women empowerment in Islam.",
      expertise: "Islamic History",
      imageUrl: "https://example.com/fatima_noor.jpg",
      calendlyUrl: "https://calendly.com/naimabubaker/test-meeting",
      categories: ["History", "Women in Islam"],
    },
    {
      id: "mentor3",
      name: "Hassan Ibrahim",
      bio: "Renowned scholar in Hadith studies and Islamic jurisprudence.",
      expertise: "Hadith Studies",
      imageUrl: "https://example.com/hassan_ibrahim.jpg",
      calendlyUrl: "https://calendly.com/naimabubaker/test-meeting",
      categories: ["Hadith", "Fiqh"],
    },
    {
      id: "mentor4",
      name: "Aisha Khan",
      bio: "Educator focusing on Islamic ethics and moral development.",
      expertise: "Islamic Ethics",
      imageUrl: "https://example.com/aisha_khan.jpg",
      calendlyUrl: "https://calendly.com/naimabubaker/test-meeting",
      categories: ["Ethics", "Morality"],
    },
    {
      id: "mentor5",
      name: "Omar Farooq",
      bio: "Expert in Islamic finance and business ethics.",
      expertise: "Islamic Finance",
      imageUrl: "https://example.com/omar_farooq.jpg",
      calendlyUrl: "https://calendly.com/naimabubaker/test-meeting",
      categories: ["Finance", "Business"],
    },
    {
      id: "mentor6",
      name: "Layla Ahmed",
      bio: "Specialist in Arabic language and Quranic interpretation.",
      expertise: "Arabic Language",
      imageUrl: "https://example.com/layla_ahmed.jpg",
      calendlyUrl: "https://calendly.com/naimabubaker/test-meeting",
      categories: ["Language", "Interpretation"],
    },
    {
      id: "mentor7",
      name: "Bilal Yusuf",
      bio: "Teacher of Islamic spirituality and Sufi traditions.",
      expertise: "Islamic Spirituality",
      imageUrl: "https://example.com/bilal_yusuf.jpg",
      calendlyUrl: "https://calendly.com/naimabubaker/test-meeting",
      categories: ["Spirituality", "Sufism"],
    },
    {
      id: "mentor8",
      name: "Zainab Malik",
      bio: "Advocate for women’s rights in Islam and community development.",
      expertise: "Women’s Rights",
      imageUrl: "https://example.com/zainab_malik.jpg",
      calendlyUrl: "https://calendly.com/naimabubaker/test-meeting",
      categories: ["Rights", "Community"],
    },
    {
      id: "mentor9",
      name: "Yusuf Ali",
      bio: "Expert in Islamic history and civilization.",
      expertise: "Islamic Civilization",
      imageUrl: "https://example.com/yusuf_ali.jpg",
      calendlyUrl: "https://calendly.com/naimabubaker/test-meeting",
      categories: ["History", "Civilization"],
    },
    {
      id: "mentor10",
      name: "Maryam Saeed",
      bio: "Educator in Islamic education and pedagogy.",
      expertise: "Islamic Education",
      imageUrl: "https://example.com/maryam_saeed.jpg",
      calendlyUrl: "https://calendly.com/naimabubaker/test-meeting",
      categories: ["Education", "Pedagogy"],
    },
  ];

  for (const mentor of mentors) {
    await firestore.collection("mentors").doc(mentor.id).set(mentor);
  }

  // Seed AppUser data
  const users = [
    {
      uid: "user1",
      email: "user1@example.com",
      role: "mentor",
      imageUrl: "https://example.com/user1.jpg",
    },
    {
      uid: "user2",
      email: "user2@example.com",
      role: "mentee",
      imageUrl: "https://example.com/user2.jpg",
    },
  ];

  for (const user of users) {
    await firestore.collection("users").doc(user.uid).set(user);
  }

  console.log("Firestore seeding completed!");
}

seedFirestoreData().catch(console.error);
