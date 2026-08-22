const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');

const app = express();

app.use(cors());
app.use(express.json());

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: process.env.NODE_ENV === 'production'
    ? { rejectUnauthorized: false }
    : false,
});

// Ruta de prueba
app.get('/', (req, res) => {
  res.json({
    message: 'API Moviee funcionando correctamente',
    status: 'OK'
  });
});

// Endpoint para iniciar sesión
app.post('/api/login', async (req, res) => {
  const { email, password } = req.body;

  try {
    const result = await pool.query(
      'SELECT id, name, email FROM users WHERE email = $1 AND password = $2',
      [email, password]
    );

    if (result.rows.length > 0) {
      res.status(200).json({
        success: true,
        user: result.rows[0]
      });
    } else {
      res.status(401).json({
        error: 'Credenciales incorrectas'
      });
    }

  } catch (err) {
    console.error(err);
    res.status(500).json({
      error: 'Error de servidor'
    });
  }
});

// Endpoint para registrarse
app.post('/api/register', async (req, res) => {
  const { name, email, password } = req.body;

  try {
    const userCheck = await pool.query(
      'SELECT id FROM users WHERE email = $1',
      [email]
    );

    if (userCheck.rows.length > 0) {
      return res.status(400).json({
        error: 'El correo ya existe'
      });
    }

    await pool.query(
      'INSERT INTO users (name, email, password) VALUES ($1, $2, $3)',
      [name, email, password]
    );

    res.status(201).json({
      success: true
    });

  } catch (err) {
    console.error(err);
    res.status(500).json({
      error: 'Error de servidor'
    });
  }
});

if (process.env.NODE_ENV !== 'test') {
  const PORT = process.env.PORT || 3000;

  app.listen(PORT, '0.0.0.0', () => {
    console.log(`🚀 Servidor corriendo en el puerto ${PORT}`);
  });
}

module.exports = app;