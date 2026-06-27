const mysql = require('mysql2/promise');
const bcrypt = require('bcryptjs');
const { v4: uuidv4 } = require('uuid');
const path = require('path');
require('dotenv').config({ path: path.join(__dirname, '.env') });

const dbConfig = {
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'eco_db',
  port: process.env.DB_PORT || 3306,
  ssl: process.env.DB_SSL === 'true' ? { rejectUnauthorized: false } : undefined
};

async function createUser(username, rawPassword, displayName, email) {
  let connection;
  try {
    connection = await mysql.createConnection(dbConfig);
    console.log('Connected to database.');

    // Check if user already exists
    const [existing] = await connection.query('SELECT id FROM users WHERE username = ?', [username]);
    if (existing.length > 0) {
      console.log(`Error: User with username "${username}" already exists.`);
      return;
    }

    // Hash password
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(rawPassword, salt);

    // Create user
    const userId = uuidv4();
    await connection.query(
      'INSERT INTO users (id, username, password, display_name, email) VALUES (?, ?, ?, ?, ?)',
      [userId, username, hashedPassword, displayName, email]
    );

    console.log('\n======================================');
    console.log('Akun User Berhasil Dibuat!');
    console.log('======================================');
    console.log(`ID:           ${userId}`);
    console.log(`Username:     ${username}`);
    console.log(`Password:     ${rawPassword}`);
    console.log(`Nama Lengkap: ${displayName}`);
    console.log(`Email:        ${email}`);
    console.log('======================================\n');
  } catch (error) {
    console.error('Error creating user:', error);
  } finally {
    if (connection) {
      await connection.end();
    }
  }
}

// Default user details to create
const username = 'eco_user';
const password = 'user123';
const displayName = 'VibEco Member';
const email = 'user@vibeco.com';

createUser(username, password, displayName, email);
