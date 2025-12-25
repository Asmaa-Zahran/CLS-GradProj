# Library Management System

A modern, full-featured library management system with 3D visualization, built with Next.js, Flask, and PostgreSQL.

## Features

- 🎨 **Modern UI/UX** - Beautiful, responsive design with Tailwind CSS
- 🎮 **3D Visualization** - Interactive 3D library scene using Three.js and React Three Fiber
- 🤖 **AI Chatbot** - Intelligent library assistant for book searches and information
- 📚 **Book Management** - Complete CRUD operations for books
- 👥 **Member Management** - User registration and management
- 📖 **Transaction System** - Borrow and return books with due date tracking
- 📊 **Dashboard & Analytics** - Comprehensive statistics and reports
- 🔐 **Authentication** - JWT-based secure authentication
- 📱 **Responsive Design** - Works on all devices
- 🐳 **Docker Support** - Easy deployment with Docker Compose
- 🌙 **Dark Mode** - Beautiful dark theme support
- 🌍 **Multi-language** - English and Arabic support
- 📅 **Reservations** - Book reservation and waitlist system
- 📋 **Audit Logs** - Complete activity tracking
- 📦 **Bulk Operations** - Import/Export books and members
- 🔍 **Advanced Search** - Full-text search capabilities

## Tech Stack

### Frontend
- **Next.js 14** - React framework
- **TypeScript** - Type safety
- **Tailwind CSS** - Styling
- **Three.js / React Three Fiber** - 3D graphics
- **Framer Motion** - Animations
- **Recharts** - Data visualization
- **Axios** - HTTP client

### Backend
- **Flask** - Python web framework
- **PostgreSQL** - Database
- **JWT** - Authentication
- **bcrypt** - Password hashing
- **Gunicorn** - WSGI server

## Prerequisites

### For Docker Deployment (Recommended)
- **Docker** 20.10+
- **Docker Compose** 2.0+

### For Local Development
- **Node.js** 18+
- **Python** 3.11+
- **PostgreSQL** 15+

## Quick Start with Docker (Ubuntu/Linux)

### 1. Install Docker and Docker Compose

```bash
# Update package index
sudo apt-get update

# Install prerequisites
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker's official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set up the repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Verify installation
sudo docker --version
sudo docker compose version

# Add your user to docker group (optional, to run without sudo)
sudo usermod -aG docker $USER
# Log out and log back in for this to take effect
```

### 2. Clone the Repository

```bash
git clone <repository-url>
cd library-management-system
```

### 3. Configure Environment Variables (Optional)

The project comes with default configuration, but you can customize it:

**Backend Configuration** (`backend/.env`):
```bash
# Database Configuration
DATABASE_URL=postgresql://library_user:library_password_2024@db:5432/library_db

# Or use individual variables
DB_HOST=db
DB_PORT=5432
DB_NAME=library_db
DB_USER=library_user
DB_PASSWORD=library_password_2024

# JWT Configuration
JWT_SECRET_KEY=library-jwt-secret-key-change-in-production-2024

# Flask Configuration
FLASK_ENV=production
```

**Frontend Configuration** (`frontend/.env.local`):
```bash
NEXT_PUBLIC_API_URL=http://localhost:5055/api
```

### 4. Start All Services

```bash
# Build and start all containers
docker compose up -d

# View logs
docker compose logs -f

# Check container status
docker compose ps
```

### 5. Database Initialization

The database is automatically initialized on first startup:
- ✅ Schema and migrations run automatically
- ✅ Sample data is seeded automatically (admin user, books, members, transactions, etc.)

**Default Admin Credentials:**
- Email: `admin@library.com`
- Password: `admin123`

**Note:** If you need to re-seed the database:
```bash
docker compose exec backend python seed_data.py
```

### 6. Access the Application

- **Frontend**: http://localhost:3055
- **Backend API**: http://localhost:5055/api
- **Database**: localhost:5432
  - Username: `library_user`
  - Password: `library_password_2024`
  - Database: `library_db`

### 7. Login Credentials

- **Admin Account**:
  - Email: `admin@library.com`
  - Password: `admin123`

- **Member Accounts** (sample data):
  - Multiple member accounts are created with email format: `[name]@example.com`
  - Password: `password123`

## Docker Commands

```bash
# Start services
docker compose up -d

# Stop services
docker compose down

# Stop and remove volumes (⚠️ deletes database data)
docker compose down -v

# View logs
docker compose logs -f [service_name]

# Restart a service
docker compose restart [service_name]

# Execute command in container
docker compose exec [service_name] [command]

# Rebuild containers
docker compose up -d --build

# View container status
docker compose ps

# Access database shell
docker compose exec db psql -U library_user -d library_db
```

## Local Development Setup

### Backend Setup

1. **Navigate to backend directory**
   ```bash
   cd backend
   ```

2. **Create virtual environment**
   ```bash
   python3 -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   ```

4. **Set up environment variables**
   Create a `.env` file:
   ```bash
   cp .env.example .env
   ```
   Edit `.env` with your database credentials:
   ```
   DB_HOST=localhost
   DB_PORT=5432
   DB_NAME=library_db
   DB_USER=library_user
   DB_PASSWORD=library_password_2024
   JWT_SECRET_KEY=your-secret-key
   FLASK_ENV=development
   ```

5. **Initialize database**
   ```bash
   # Make sure PostgreSQL is running
   psql -U library_user -d library_db -f database/schema.sql
   python run_migrations.py
   ```

6. **Run the server**
   ```bash
   python app.py
   # Or with gunicorn:
   gunicorn --bind 0.0.0.0:5000 --workers 4 app:app
   ```

### Frontend Setup

1. **Navigate to frontend directory**
   ```bash
   cd frontend
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Set up environment variables**
   Create a `.env.local` file:
   ```bash
   cp .env.local.example .env.local
   ```
   Edit `.env.local`:
   ```
   NEXT_PUBLIC_API_URL=http://localhost:5055/api
   ```

4. **Run the development server**
   ```bash
   npm run dev
   ```

5. **Build for production**
   ```bash
   npm run build
   npm start
   ```

## Database Configuration

### Default Credentials (Docker)
- **Host**: `db` (container name) or `localhost` (from host)
- **Port**: `5432`
- **Database**: `library_db`
- **Username**: `library_user`
- **Password**: `library_password_2024`

### Change Database Credentials

1. **Update `docker-compose.yml`**:
   ```yaml
   db:
     environment:
       POSTGRES_DB: your_database_name
       POSTGRES_USER: your_username
       POSTGRES_PASSWORD: your_secure_password
   ```

2. **Update backend environment variables**:
   ```bash
   DB_NAME=your_database_name
   DB_USER=your_username
   DB_PASSWORD=your_secure_password
   ```

3. **Rebuild and restart**:
   ```bash
   docker compose down -v
   docker compose up -d --build
   ```

## Project Structure

```
library-management-system/
├── backend/
│   ├── app.py                 # Flask application entry point
│   ├── routes/                # API route handlers
│   │   ├── auth.py           # Authentication routes
│   │   ├── books.py          # Book management routes
│   │   ├── members.py        # Member management routes
│   │   ├── transactions.py   # Transaction routes
│   │   ├── dashboard.py      # Dashboard routes
│   │   ├── chatbot.py        # Chatbot routes
│   │   ├── categories.py     # Category routes
│   │   ├── reports.py        # Report routes
│   │   ├── reservations.py   # Reservation routes
│   │   ├── audit_logs.py     # Audit log routes
│   │   └── ...
│   ├── database/
│   │   ├── db.py             # Database connection
│   │   ├── schema.sql        # Database schema
│   │   └── migrations.sql    # Database migrations
│   ├── requirements.txt      # Python dependencies
│   ├── Dockerfile            # Backend Docker image
│   └── .env.example          # Environment variables example
├── frontend/
│   ├── app/                  # Next.js app directory
│   │   ├── page.tsx         # Home page
│   │   ├── login/           # Login page
│   │   ├── dashboard/       # Dashboard page
│   │   ├── books/           # Books page
│   │   └── ...
│   ├── components/           # React components
│   │   ├── Layout.tsx       # Main layout
│   │   ├── Library3D.tsx     # 3D library scene
│   │   ├── LibraryScene.tsx  # 3D scene components
│   │   └── ...
│   ├── lib/                  # Utility functions
│   │   ├── api.ts           # API client
│   │   ├── auth.ts          # Auth utilities
│   │   └── i18n.ts          # Internationalization
│   ├── package.json         # Node dependencies
│   ├── Dockerfile           # Frontend Docker image
│   └── .env.local.example   # Environment variables example
├── docker-compose.yml        # Docker Compose configuration
└── README.md                # This file
```

## API Endpoints

### Authentication
- `POST /api/auth/login` - User login
- `POST /api/auth/register` - User registration
- `GET /api/auth/me` - Get current user
- `POST /api/auth/change-password` - Change password

### Books
- `GET /api/books/` - Get all books (with filters)
- `GET /api/books/:id` - Get book by ID
- `POST /api/books/` - Add new book (admin)
- `PUT /api/books/:id` - Update book (admin)
- `DELETE /api/books/:id` - Delete book (admin)
- `GET /api/books/:id/reviews` - Get book reviews
- `POST /api/books/:id/reviews` - Add book review

### Members
- `GET /api/members/` - Get all members (admin)
- `GET /api/members/:id` - Get member by ID (admin)
- `PUT /api/members/:id` - Update member (admin)
- `DELETE /api/members/:id` - Delete member (admin)

### Transactions
- `POST /api/transactions/borrow` - Borrow a book (admin)
- `POST /api/transactions/return` - Return a book (admin)
- `GET /api/transactions/` - Get all transactions
- `GET /api/transactions/overdue` - Get overdue transactions (admin)

### Reservations
- `GET /api/reservations/` - Get all reservations
- `POST /api/reservations/` - Create reservation
- `PUT /api/reservations/:id/cancel` - Cancel reservation
- `PUT /api/reservations/:id/pickup` - Mark as picked up

### Dashboard
- `GET /api/dashboard/stats` - Get dashboard statistics (admin)
- `GET /api/dashboard/member-stats` - Get member statistics

### Chatbot
- `POST /api/chatbot/chat` - Send message to chatbot
- `GET /api/chatbot/suggestions` - Get chat suggestions

### Categories
- `GET /api/categories/` - Get all categories
- `POST /api/categories/` - Add category (admin)
- `PUT /api/categories/:id` - Update category (admin)
- `DELETE /api/categories/:id` - Delete category (admin)

### Reports
- `GET /api/reports/borrowing-trends` - Get borrowing trends (admin)
- `GET /api/reports/popular-books` - Get popular books (admin)
- `GET /api/reports/member-activity` - Get member activity (admin)
- `GET /api/reports/fines-report` - Get fines report (admin)

## Troubleshooting

### Database Connection Issues

```bash
# Check if database is running
docker compose ps db

# Check database logs
docker compose logs db

# Test database connection
docker compose exec db psql -U library_user -d library_db -c "SELECT version();"
```

### Backend Issues

```bash
# Check backend logs
docker compose logs backend

# Restart backend
docker compose restart backend

# Access backend shell
docker compose exec backend bash
```

### Frontend Issues

```bash
# Check frontend logs
docker compose logs frontend

# Rebuild frontend
docker compose up -d --build frontend
```

### Port Conflicts

If ports 3055, 5055, or 5432 are already in use:

1. **Change ports in `docker-compose.yml`**:
   ```yaml
   frontend:
     ports:
       - "3056:3000"  # Change 3055 to 3056
   backend:
     ports:
       - "5056:5000"  # Change 5055 to 5056
   db:
     ports:
       - "5433:5432"  # Change 5432 to 5433
   ```

2. **Update frontend API URL**:
   ```bash
   NEXT_PUBLIC_API_URL=http://localhost:5056/api
   ```

## Security Notes

⚠️ **Important**: Before deploying to production:

1. **Change default passwords** in `docker-compose.yml`
2. **Update JWT_SECRET_KEY** with a strong random key
3. **Use environment variables** for sensitive data
4. **Enable HTTPS** for production
5. **Configure firewall** rules
6. **Regular backups** of the database

## Production Deployment

### On Ubuntu Server

1. **Install Docker** (see Quick Start section)

2. **Clone and configure**:
   ```bash
   git clone <repository-url>
   cd library-management-system
   # Edit docker-compose.yml with production credentials
   ```

3. **Start services**:
   ```bash
   docker compose up -d
   ```

4. **Set up reverse proxy** (Nginx example):
   ```nginx
   server {
       listen 80;
       server_name your-domain.com;

       location / {
           proxy_pass http://localhost:3055;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection 'upgrade';
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }

       location /api {
           proxy_pass http://localhost:5055;
           proxy_http_version 1.1;
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
       }
   }
   ```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

This project is licensed under the MIT License.

## Support

For issues and questions, please open an issue on GitHub.
