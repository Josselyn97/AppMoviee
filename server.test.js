const request = require('supertest');
const app = require('./server'); // Importa tu servidor Express
const { Pool } = require('pg');

// Simulamos la librería 'pg' para el entorno de pruebas
jest.mock('pg', () => {
  const mPool = {
    query: jest.fn(),
    connect: jest.fn(),
    end: jest.fn(),
  };
  return { Pool: jest.fn(() => mPool) };
});

describe('API de Autenticación - Pruebas de Integración', () => {
  let pool;

  beforeEach(() => {
    jest.clearAllMocks();
    pool = new Pool();
  });

  // ==========================================
  // 1. ESCENARIO: POST /api/login
  // ==========================================
  it('POST /api/login debe iniciar sesión correctamente con credenciales válidas', async () => {
    const mockUsuario = { id: 1, name: 'Miguel', email: 'miguel@example.com' };
    pool.query.mockResolvedValue({ rows: [mockUsuario] });

    const response = await request(app)
      .post('/api/login')
      .send({ email: 'miguel@example.com', password: 'password123' });

    expect(response.statusCode).toBe(200);
    expect(response.body).toEqual({
      success: true,
      user: mockUsuario
    });
  });

  // ==========================================
  // 2. ESCENARIO: POST /api/register
  // ==========================================
  it('POST /api/register debe devolver 400 si el correo ya existe', async () => {
    pool.query.mockResolvedValue({ rows: [{ id: 1 }] });

    const response = await request(app)
      .post('/api/register')
      .send({ name: 'Miguel', email: 'miguel@example.com', password: 'password123' });

    expect(response.statusCode).toBe(400);
    expect(response.body).toEqual({
      error: 'El correo ya existe'
    });
  });
});
