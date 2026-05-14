const config = require('../config');

function escapeXml(unsafe) {
  if (!unsafe) return '';
  const sanitized = unsafe.replace(/[^\x09\x0A\x0D\x20-\xFF\x85\xA0-\uD7FF\uE000-\uFFFD\u10000-\u10FFFF]/g, '');
  return sanitized.replace(/[<>&"']/g, (c) => {
    switch (c) {
      case '<': return '&lt;';
      case '>': return '&gt;';
      case '&': return '&amp;';
      case '"': return '&quot;';
      case "'": return '&apos;';
      default: return c;
    }
  });
}

/**
 * Builds SSML for Storytelling Persona
 * - Enforces slow rate (0.85x)
 * - Natural intonation
 */
function buildSsml(text, languageCode, emphasis = false) {
  const escapedText = escapeXml(text);
  const rate = config.tts.speakingRate; // 0.85
  const pitch = config.tts.pitchSemitones; // +1st
  
  let content = escapedText;
  if (emphasis) {
    content = `<prosody volume="loud" rate="${rate}">${escapedText}</prosody>`;
  }

  return `<speak><prosody rate="${rate}" pitch="${pitch}">${content}</prosody></speak>`;
}

module.exports = {
  buildSsml,
  escapeXml
};
