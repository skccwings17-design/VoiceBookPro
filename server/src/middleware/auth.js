const admin = require('firebase-admin');

// Initialize Firebase Admin (Assumes GOOGLE_APPLICATION_CREDENTIALS is set or running on GCP)
if (admin.apps.length === 0) {
  admin.initializeApp();
}

/**
 * Middleware to verify Firebase ID Token from Authorization header
 */
async function verifyToken(req, res, next) {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ error: 'Unauthorized: Missing token' });
  }

  const idToken = authHeader.split('Bearer ')[1];
  try {
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    req.user = decodedToken;
    next();
  } catch (error) {
    console.error('Token verification error:', error.message);
    res.status(403).json({ error: 'Unauthorized: Invalid token' });
  }
}

module.exports = { verifyToken };
