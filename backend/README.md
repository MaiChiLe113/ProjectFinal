## Setup Instructions

### Install Dependencies

```bash
cd backend
pip install -r requirements.txt
```
## API Endpoints

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login user

### Competitions
- `GET /api/competitions` - Get all competitions (with filters)
- `GET /api/competitions/{id}` - Get competition details
- `POST /api/competitions/{id}/join` - Join a competition

### Projects
- `GET /api/projects` - Get all projects (with filters)
- `GET /api/projects/{id}` - Get project details
- `POST /api/projects` - Create new project
- `POST /api/projects/{id}/vote` - Vote for a project
- `POST /api/projects/{id}/comments` - Add comment to project

### News
- `GET /api/news` - Get all news (with filters)
- `GET /api/news/{id}` - Get news item

### Health Check
- `GET /` - API status
- `GET /api/health` - Database health check

## Development Workflow

1. Start XAMPP MySQL
2. cd backend
3. Run backend: `uvicorn main:app --reload`
4. In another terminal, run frontend: `npm run dev`
5. Access frontend at http://localhost:5173
6. Backend API at http://localhost:8000
