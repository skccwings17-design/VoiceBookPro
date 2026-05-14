const express = require('express');
const admin = require('firebase-admin'); // Fixed from cloud-functions
const { verifyToken } = require('../middleware/auth');
const { v4: uuidv4 } = require('uuid');

const router = express.Router();
const db = admin.firestore ? admin.firestore() : null;

/**
 * GET /api/voice-profile/list
 * Fetch user's voice profiles from Firestore
 */
router.get('/list', verifyToken, async (req, res) => {
  try {
    const userId = req.user.uid;
    const snapshot = await admin.firestore().collection('users').doc(userId).collection('profiles').get();
    const profiles = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
    res.json(profiles);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

/**
 * POST /api/voice-profile/create
 * This is a placeholder for the actual Chirp 3 Voice Cloning Key generation logic.
 * In a real scenario, you'd send audio to GCP and get a customVoiceKey back.
 */
router.post('/create', verifyToken, async (req, res) => {
  try {
    const userId = req.user.uid;
    const { name, customVoiceKey } = req.body;

    if (!name || !customVoiceKey) {
      return res.status(400).json({ error: 'Name and customVoiceKey are required' });
    }

    const profileId = uuidv4();
    const profileData = {
      name,
      customVoiceKey,
      createdAt: new Date().toISOString()
    };

    await admin.firestore()
      .collection('users').doc(userId)
      .collection('profiles').doc(profileId)
      .set(profileData);

    res.json({ id: profileId, ...profileData });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
