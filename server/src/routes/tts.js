const express = require('express');
const { synthesizeBilingualStory } = require('../modules/tts-synthesizer');
const { assembleAudio } = require('../modules/audio-assembler');
const { verifyToken } = require('../middleware/auth');

const router = express.Router();

// POST /api/tts
router.post('/', verifyToken, async (req, res) => {
  try {
    const { storyData, voiceProfile } = req.body;
    if (!Array.isArray(storyData)) {
      return res.status(400).json({ error: 'Invalid story data' });
    }

    const pcmBuffers = await synthesizeBilingualStory(storyData, voiceProfile);
    const wavBuffer = assembleAudio(pcmBuffers);

    res.set({
      'Content-Type': 'audio/wav',
      'Content-Length': wavBuffer.length
    });
    res.send(wavBuffer);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
