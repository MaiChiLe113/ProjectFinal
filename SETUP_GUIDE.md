# ComSwin Complete Setup Guide

Complete step-by-step guide to set up the ComSwin platform with database and backend.

## Prerequisites

- **Node.js** 16+ and npm
- **Python** 3.8+
- **XAMPP** (for MySQL)
- **Git** (optional)

## Project Structure

```
ComSwin/
├── backend/              # Python FastAPI backend
│   ├── main.py          # Main API application
│   ├── requirements.txt # Python dependencies
│   └── README.md        # Backend documentation
├── src/                 # Vue.js frontend
│   ├── components/      # Reusable components
│   ├── pages/          # Route pages
│   ├── services/       # API service layer
│   │   └── api.js      # Axios API client
│   ├── store/          # Vuex state management
│   ├── data/           # JSON data (legacy)
│   └── main.js         # App entry point
├── schema.sql          # MySQL database schema
├── API_INTEGRATION.md  # API usage guide
└── package.json        # Frontend dependencies
```

## Part 1: Database Setup

### 1. Start XAMPP

1. Open XAMPP Control Panel
2. Start **Apache** and **MySQL** modules
3. Click **Admin** button next to MySQL to open phpMyAdmin

### 2. Create Database

**Option A: Using phpMyAdmin**
1. Go to http://localhost/phpmyadmin
2. Click **Import** tab
3. Choose `schema.sql` file from project root
4. Click **Go** to execute

**Option B: Using MySQL Command Line**
```bash
# Navigate to MySQL bin directory
cd C:\xampp\mysql\bin

# Run schema file
mysql -u root < C:\Users\Admin\ComSwin\schema.sql
```

**Option C: Using MySQL Workbench**
1. Open MySQL Workbench
2. Connect to local instance (localhost:3306, user: root, no password)
3. File → Open SQL Script → select `schema.sql`
4. Execute script

### 3. Verify Database

In phpMyAdmin:
1. Check that `comswin_db` database exists
2. Verify tables are created (users, competitions, projects, news, etc.)
3. Check sample data exists:
   - 5 users
   - 1 competition
   - 1 project
   - 3 news items

## Part 2: Backend Setup

### 1. Install Python Dependencies

```bash
cd backend
pip install -r requirements.txt
```

If you encounter SSL errors on Windows:
```bash
pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org -r requirements.txt
```

### 2. Configure Database Connection

Open `backend/main.py` and verify the database configuration (lines ~30-35):

```python
connection = mysql.connector.connect(
    host='localhost',
    database='comswin_db',
    user='root',
    password=''  # XAMPP default is empty
)
```

### 3. Run Backend Server

```bash
uvicorn main:app --reload
```

You should see:
```
INFO:     Uvicorn running on http://127.0.0.1:8000
INFO:     Application startup complete.
```

### 4. Test Backend

Open your browser and visit:
- API Status: http://localhost:8000/
- Health Check: http://localhost:8000/api/health
- API Documentation: http://localhost:8000/docs (Swagger UI)
- Alternative Docs: http://localhost:8000/redoc

Try the health endpoint:
```bash
curl http://localhost:8000/api/health
```

Expected response:
```json
{
  "status": "healthy",
  "database": "connected"
}
```

## Part 3: Frontend Setup

### 1. Install Dependencies

```bash
# In project root (not in backend folder)
cd C:\Users\Admin\ComSwin
npm install
```

### 2. Install Axios

```bash
npm install axios
```

### 3. Verify API Service

The API service is already created at `src/services/api.js`. It's configured to connect to `http://localhost:8000/api`.

### 4. Run Frontend Development Server

```bash
npm run dev
```

You should see:
```
VITE v7.2.2  ready in XXX ms

➜  Local:   http://localhost:5173/
➜  Network: use --host to expose
```

### 5. Access Application

Open your browser and navigate to: http://localhost:5173

## Part 4: Integration Testing

### Test 1: Health Check

In browser console (F12), run:
```javascript
fetch('http://localhost:8000/api/health')
  .then(r => r.json())
  .then(data => console.log(data));
```

### Test 2: Get Competitions

```javascript
fetch('http://localhost:8000/api/competitions')
  .then(r => r.json())
  .then(data => console.log(data));
```

### Test 3: Get News

```javascript
fetch('http://localhost:8000/api/news')
  .then(r => r.json())
  .then(data => console.log(data));
```

## Part 5: Using the API in Components

### Example 1: Fetch Competitions in Home.vue

```vue
<script>
import { competitionsAPI } from '@/services/api';

export default {
  data() {
    return {
      competitions: [],
      loading: false
    };
  },
  async mounted() {
    this.loading = true;
    try {
      const data = await competitionsAPI.getAll({ limit: 6 });
      this.competitions = data.competitions;
    } catch (error) {
      console.error('Error loading competitions:', error);
    } finally {
      this.loading = false;
    }
  }
};
</script>
```

### Example 2: Fetch News in News.vue

```vue
<script>
import { newsAPI } from '@/services/api';

export default {
  data() {
    return {
      news: [],
      loading: false
    };
  },
  async mounted() {
    this.loading = true;
    try {
      this.news = await newsAPI.getAll({ limit: 20 });
    } catch (error) {
      console.error('Error loading news:', error);
    } finally {
      this.loading = false;
    }
  }
};
</script>
```

### Example 3: Submit Project with Vuex

```vue
<script>
import { projectsAPI } from '@/services/api';
import { mapGetters } from 'vuex';

export default {
  computed: {
    ...mapGetters('project', [
      'getProjectName',
      'getElevatorPitch',
      'getAboutProject',
      'getBuiltWith',
      'getThumbnail',
      'getTryItOutLinks',
      'getVideoDemoLink'
    ])
  },
  methods: {
    async submitProject() {
      const user = JSON.parse(localStorage.getItem('user'));
      const competitionId = this.$route.params.id;

      try {
        const result = await projectsAPI.create({
          competition_id: competitionId,
          user_id: user.id,
          project_name: this.getProjectName,
          elevator_pitch: this.getElevatorPitch,
          about_project: this.getAboutProject,
          built_with: this.getBuiltWith,
          video_demo_link: this.getVideoDemoLink,
          try_it_out_links: this.getTryItOutLinks,
          thumbnail: this.getThumbnail
        });

        alert('Project submitted successfully!');
        this.$router.push(`/projects/${result.project_id}`);
      } catch (error) {
        alert('Failed to submit project');
        console.error(error);
      }
    }
  }
};
</script>
```

## Troubleshooting

### Issue: Database Connection Failed

**Symptoms**: Backend shows "Database connection failed"

**Solutions**:
1. Verify MySQL is running in XAMPP
2. Check database name is `comswin_db`
3. Verify user is `root` with empty password
4. Try restarting MySQL in XAMPP

### Issue: CORS Errors

**Symptoms**: Browser console shows CORS policy errors

**Solutions**:
1. Ensure backend is running on port 8000
2. Check CORS configuration in `backend/main.py`
3. Verify frontend dev server URL in `allow_origins`
4. Clear browser cache

### Issue: Port Already in Use

**Symptoms**: "Address already in use" error

**Solutions**:

For backend (port 8000):
```bash
# Windows
netstat -ano | findstr :8000
taskkill /PID <PID> /F

# Or change port
uvicorn main:app --reload --port 8001
```

For frontend (port 5173):
```bash
# Kill process or change port in vite.config.js
```

### Issue: Module Not Found (Python)

**Symptoms**: `ModuleNotFoundError`

**Solutions**:
```bash
# Reinstall dependencies
pip install -r requirements.txt

# Use virtual environment (recommended)
python -m venv venv
venv\Scripts\activate  # Windows
pip install -r requirements.txt
```

### Issue: npm Install Errors

**Symptoms**: Package installation fails

**Solutions**:
```bash
# Clear npm cache
npm cache clean --force

# Delete node_modules and reinstall
rmdir /s /q node_modules
del package-lock.json
npm install
```

## Development Workflow

### Daily Development

1. **Start XAMPP MySQL** (if not running)
2. **Start Backend**:
   ```bash
   cd backend
   uvicorn main:app --reload
   ```
3. **Start Frontend** (new terminal):
   ```bash
   npm run dev
   ```
4. **Access**: http://localhost:5173

### Making Changes

- **Frontend Changes**: Auto-reload (Vite HMR)
- **Backend Changes**: Auto-reload (uvicorn --reload)
- **Database Changes**:
  - Modify `schema.sql`
  - Re-import database
  - Or use SQL queries in phpMyAdmin

## Production Deployment Notes

⚠️ **Important**: This setup is for development only!

For production, you MUST:

### Database
- Use production MySQL server (not XAMPP)
- Create strong passwords
- Enable SSL connections
- Regular backups

### Backend
- No Hash passwords
- Implement JWT authentication
- Use environment variables for config
- Enable HTTPS
- Add rate limiting
- Deploy to cloud (AWS, Heroku, DigitalOcean)

### Frontend
- Build for production: `npm run build`
- Serve from web server (Nginx, Apache)
- Update API base URL to production backend
- Enable HTTPS
- Deploy to hosting (Vercel, Netlify, AWS S3)

## Additional Resources

- **Backend API Docs**: http://localhost:8000/docs
- **API Integration Guide**: See `API_INTEGRATION.md`
- **Backend README**: See `backend/README.md`
- **Vue Router Docs**: https://router.vuejs.org/
- **Vuex Docs**: https://vuex.vuejs.org/
- **FastAPI Docs**: https://fastapi.tiangolo.com/

## Getting Help

1. Check browser console for errors (F12)
2. Check backend terminal for Python errors
3. Check MySQL logs in XAMPP
4. Review API documentation at http://localhost:8000/docs
5. Test endpoints with Swagger UI

## Next Steps

1. ✅ Database setup complete
2. ✅ Backend running
3. ✅ Frontend running
4. 🔄 Replace JSON imports with API calls
5. 🔄 Implement authentication flow
6. 🔄 Add form validation
7. 🔄 Implement file uploads
8. 🔄 Add error handling
9. 🔄 Create user dashboard
10. 🔄 Build admin panel