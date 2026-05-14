const express = require('express');
const { translateStory } = require('../modules/gemini-translator');
const { verifyToken } = require('../middleware/auth');

const router = express.Router();

// POST /api/translate
router.post('/', verifyToken, async (req, res) => {
  try {
    const { texts, sourceLanguage } = req.body;
    if (!Array.isArray(texts)) {
      return res.status(400).json({ error: 'texts must be an array of strings' });
    }

    const translated = await translateStory(texts, sourceLanguage);
    res.json(translated);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
