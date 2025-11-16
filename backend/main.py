# FastAPI Backend for ComSwin
# Basic API endpoints for frontend integration
# Run with: uvicorn main:app --reload

from fastapi import FastAPI, HTTPException, Depends, UploadFile, File, Form
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Optional, List
import mysql.connector
from mysql.connector import Error
import os
from datetime import datetime
import json

app = FastAPI(title="ComSwin API")

# CORS configuration for Vue.js frontend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:5173"], 
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ============================================================================
# DATABASE CONNECTION
# ============================================================================

def get_db_connection():
    """Create database connection"""
    try:
        connection = mysql.connector.connect(
            host='localhost',
            database='swincom',
            user='root',      # Default XAMPP MySQL user
            password=''       # Default XAMPP MySQL password 
        )
        return connection
    except Error as e:
        print(f"Error connecting to MySQL: {e}")
        raise HTTPException(status_code=500, detail="Database connection failed")

def execute_query(query, params=None, fetch_one=False, fetch_all=False, commit=False):
    """Execute database query with proper connection handling"""
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)
    try:
        cursor.execute(query, params or ())
        if commit:
            connection.commit()
            return cursor.lastrowid
        if fetch_one:
            return cursor.fetchone()
        if fetch_all:
            return cursor.fetchall()
    except Error as e:
        print(f"Database error: {e}")
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        cursor.close()
        connection.close()

# ============================================================================
# PYDANTIC MODELS (Request/Response schemas)
# ============================================================================

class UserLogin(BaseModel):
    email: str
    password: str

class UserRegister(BaseModel):
    first_name: str
    last_name: str
    email: str
    phone: str
    password: str
    gender: str
    role: str = "student"

class ProjectCreate(BaseModel):
    competition_id: int
    project_name: str
    elevator_pitch: str
    about_project: str
    built_with: str
    video_demo_link: Optional[str] = None
    try_it_out_links: List[str] = []

class CommentCreate(BaseModel):
    project_id: int
    comment: str

# ============================================================================
# AUTHENTICATION ENDPOINTS
# ============================================================================

@app.post("/api/register")
async def register(user: UserRegister):
    """Register new user"""
    # Check if user exists
    existing = execute_query(
        "SELECT id FROM users WHERE email = %s",
        (user.email,),
        fetch_one=True
    )
    if existing:
        raise HTTPException(status_code=400, detail="Email already registered")

    # Insert user (in production, hash the password!)
    query = """
        INSERT INTO users (first_name, last_name, email, phone, password, gender, role)
        VALUES (%s, %s, %s, %s, %s, %s, %s)
    """
    user_id = execute_query(
        query,
        (user.first_name, user.last_name, user.email, user.phone, user.password, user.gender, user.role),
        commit=True
    )

    # Get the created user to return
    created_user = execute_query(
        "SELECT id, first_name, last_name, email, phone, gender, role FROM users WHERE id = %s",
        (user_id,),
        fetch_one=True
    )

    return {
        "id": created_user["id"],
        "first_name": created_user["first_name"],
        "last_name": created_user["last_name"],
        "email": created_user["email"],
        "phone": created_user["phone"],
        "gender": created_user["gender"],
        "role": created_user["role"]
    }

@app.post("/api/login")
async def login(credentials: UserLogin):
    """Login user"""
    user = execute_query(
        "SELECT id, first_name, last_name, email, phone, gender, role, avatar FROM users WHERE email = %s AND password = %s",
        (credentials.email, credentials.password),
        fetch_one=True
    )

    if not user:
        raise HTTPException(status_code=401, detail="Invalid email or password.")

    # Return user object directly (frontend expects this format)
    return {
        "id": user["id"],
        "first_name": user["first_name"],
        "last_name": user["last_name"],
        "email": user["email"],
        "phone": user.get("phone"),
        "gender": user.get("gender"),
        "role": user["role"],
        "avatar": user.get("avatar")
    }

# ============================================================================
# COMPETITIONS ENDPOINTS
# ============================================================================

@app.get("/api/competitions")
async def get_competitions(
    status: Optional[str] = None,
    category: Optional[str] = None,
    limit: int = 20,
    offset: int = 0
):
    """Get all competitions with optional filters"""
    query = "SELECT * FROM v_competitions_full WHERE 1=1"
    params = []

    if status:
        query += " AND status = %s"
        params.append(status)

    if category:
        query += " AND category = %s"
        params.append(category)

    query += " ORDER BY created_date DESC LIMIT %s OFFSET %s"
    params.extend([limit, offset])

    competitions = execute_query(query, tuple(params), fetch_all=True)

    # Build nested structure like frontend expects
    result = []
    for comp in competitions:
        result.append({
            "id": comp["id"],
            "title": comp["title"],
            "description": comp["description"],
            "category": comp["category"],
            "organizer": {
                "id": comp["organizer_id"],
                "name": comp["organizer_name"],
                "email": comp["organizer_email"],
                "type": comp["organizer_type"]
            },
            "dates": {
                "created": str(comp["created_date"]),
                "start": str(comp["start_date"]),
                "end": str(comp["end_date"]),
                "registrationDeadline": str(comp["registration_deadline"])
            },
            "participants": comp["participants"],
            "capacity": {
                "max": comp["max_capacity"],
                "current": comp["current_capacity"],
                "waitlist": comp["waitlist"]
            },
            "status": comp["status"],
            "registration": {
                "isOpen": bool(comp["registration_is_open"]),
                "requiresApproval": bool(comp["requires_approval"]),
                "allowTeams": bool(comp["allow_teams"]),
                "teamSize": comp["team_size"]
            },
            "location": {
                "type": comp["location_type"],
                "venue": comp["venue"],
                "link": comp["location_link"]
            },
            "prizes": comp["prizes"],
            "rules": comp["rules"],
            "contactEmail": comp["contact_email"],
            "images": {
                "banner": comp["banner_image"],
                "thumbnail": comp["thumbnail_image"]
            },
            "metadata": {
                "views": comp["views"],
                "votes": comp["votes"],
                "registrations": comp["actual_registrations"],
                "completionRate": float(comp["completion_rate"])
            }
        })

    return {"competitions": result}

@app.get("/api/competitions/{competition_id}")
async def get_competition(competition_id: int):
    """Get single competition by ID"""
    comp = execute_query(
        "SELECT * FROM v_competitions_full WHERE id = %s",
        (competition_id,),
        fetch_one=True
    )

    if not comp:
        raise HTTPException(status_code=404, detail="Competition not found")

    # Return nested structure
    return {
        "id": comp["id"],
        "title": comp["title"],
        "description": comp["description"],
        "category": comp["category"],
        "organizer": {
            "id": comp["organizer_id"],
            "name": comp["organizer_name"],
            "email": comp["organizer_email"],
            "type": comp["organizer_type"]
        },
        "dates": {
            "created": str(comp["created_date"]),
            "start": str(comp["start_date"]),
            "end": str(comp["end_date"]),
            "registrationDeadline": str(comp["registration_deadline"])
        },
        "participants": comp["participants"],
        "capacity": {
            "max": comp["max_capacity"],
            "current": comp["current_capacity"],
            "waitlist": comp["waitlist"]
        },
        "status": comp["status"],
        "registration": {
            "isOpen": bool(comp["registration_is_open"]),
            "requiresApproval": bool(comp["requires_approval"]),
            "allowTeams": bool(comp["allow_teams"]),
            "teamSize": comp["team_size"]
        },
        "location": {
            "type": comp["location_type"],
            "venue": comp["venue"],
            "link": comp["location_link"]
        },
        "prizes": comp["prizes"],
        "rules": comp["rules"],
        "contactEmail": comp["contact_email"],
        "images": {
            "banner": comp["banner_image"],
            "thumbnail": comp["thumbnail_image"]
        },
        "metadata": {
            "views": comp["views"],
            "votes": comp["votes"],
            "registrations": comp["actual_registrations"],
            "completionRate": float(comp["completion_rate"])
        }
    }

@app.post("/api/competitions/{competition_id}/join")
async def join_competition(competition_id: int, user_id: int):
    """Join a competition"""
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)

    try:
        cursor.callproc('sp_join_competition', [competition_id, user_id])
        result = None
        for res in cursor.stored_results():
            result = res.fetchone()
        connection.commit()

        if result and result['status'] == 'error':
            raise HTTPException(status_code=400, detail=result['message'])

        return result
    finally:
        cursor.close()
        connection.close()

# ============================================================================
# PROJECTS ENDPOINTS
# ============================================================================

@app.get("/api/projects")
async def get_projects(
    competition_id: Optional[int] = None,
    status: str = "approved",
    limit: int = 20,
    offset: int = 0
):
    """Get all projects with optional filters"""
    query = "SELECT * FROM v_projects_full WHERE status = %s"
    params = [status]

    if competition_id:
        query += " AND competition_id = %s"
        params.append(competition_id)

    query += " ORDER BY submitted_at DESC LIMIT %s OFFSET %s"
    params.extend([limit, offset])

    projects = execute_query(query, tuple(params), fetch_all=True)

    # Get related data for each project
    result = []
    for proj in projects:
        # Get links
        links = execute_query(
            "SELECT url FROM project_links WHERE project_id = %s ORDER BY display_order",
            (proj["id"],),
            fetch_all=True
        )

        # Get images
        images = execute_query(
            "SELECT url, caption FROM project_images WHERE project_id = %s ORDER BY display_order",
            (proj["id"],),
            fetch_all=True
        )

        # Get team
        team = execute_query(
            "SELECT user_id as id, name, role FROM team_members WHERE project_id = %s ORDER BY display_order",
            (proj["id"],),
            fetch_all=True
        )

        result.append({
            "id": proj["id"],
            "competitionId": proj["competition_id"],
            "projectName": proj["project_name"],
            "elevatorPitch": proj["elevator_pitch"],
            "aboutProject": proj["about_project"],
            "builtWith": proj["built_with"],
            "tryItOutLinks": [link["url"] for link in links],
            "projectImages": images,
            "videoDemoLink": proj["video_demo_link"],
            "uploader": {
                "id": proj["uploader_id"],
                "name": proj["uploader_name"],
                "email": proj["uploader_email"],
                "avatar": proj["uploader_avatar"]
            },
            "team": team,
            "dates": {
                "submitted": str(proj["submitted_at"]),
                "updated": str(proj["updated_at"])
            },
            "status": proj["status"],
            "votes": proj["vote_count"]
        })

    return {"projects": result}

@app.get("/api/projects/{project_id}")
async def get_project(project_id: int):
    """Get single project with all details"""
    proj = execute_query(
        "SELECT * FROM v_projects_full WHERE id = %s",
        (project_id,),
        fetch_one=True
    )

    if not proj:
        raise HTTPException(status_code=404, detail="Project not found")

    # Get related data
    links = execute_query(
        "SELECT url FROM project_links WHERE project_id = %s ORDER BY display_order",
        (project_id,),
        fetch_all=True
    )

    images = execute_query(
        "SELECT url, caption FROM project_images WHERE project_id = %s ORDER BY display_order",
        (project_id,),
        fetch_all=True
    )

    team = execute_query(
        "SELECT user_id as id, name, role FROM team_members WHERE project_id = %s ORDER BY display_order",
        (project_id,),
        fetch_all=True
    )

    comments = execute_query(
        "SELECT * FROM project_comments WHERE project_id = %s ORDER BY timestamp DESC",
        (project_id,),
        fetch_all=True
    )

    return {
        "id": proj["id"],
        "competitionId": proj["competition_id"],
        "projectName": proj["project_name"],
        "elevatorPitch": proj["elevator_pitch"],
        "aboutProject": proj["about_project"],
        "builtWith": proj["built_with"],
        "tryItOutLinks": [link["url"] for link in links],
        "projectImages": images,
        "videoDemoLink": proj["video_demo_link"],
        "uploader": {
            "id": proj["uploader_id"],
            "name": proj["uploader_name"],
            "email": proj["uploader_email"],
            "avatar": proj["uploader_avatar"]
        },
        "team": team,
        "dates": {
            "submitted": str(proj["submitted_at"]),
            "updated": str(proj["updated_at"])
        },
        "status": proj["status"],
        "votes": proj["vote_count"],
        "comments": [
            {
                "id": c["id"],
                "userId": c["user_id"],
                "userName": c["user_name"],
                "avatar": c["user_avatar"],
                "comment": c["comment"],
                "timestamp": str(c["timestamp"]),
                "likes": c["likes"]
            }
            for c in comments
        ]
    }

@app.post("/api/projects")
async def create_project(
    competition_id: int = Form(...),
    user_id: int = Form(...),
    project_name: str = Form(...),
    elevator_pitch: str = Form(...),
    about_project: str = Form(...),
    built_with: str = Form(...),
    video_demo_link: Optional[str] = Form(None),
    try_it_out_links: str = Form("[]"),  # JSON string
    thumbnail: Optional[UploadFile] = File(None)
):
    """Create new project (matches Vuex store action)"""
    # Get user info
    user = execute_query(
        "SELECT first_name, last_name, email, avatar FROM users WHERE id = %s",
        (user_id,),
        fetch_one=True
    )

    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    # Handle thumbnail upload (simplified - in production, save to file storage)
    thumbnail_url = None
    if thumbnail:
        # Save file and get URL - simplified for demo
        thumbnail_url = f"/uploads/{thumbnail.filename}"

    # Insert project
    query = """
        INSERT INTO projects (
            competition_id, project_name, elevator_pitch, about_project, built_with,
            video_demo_link, thumbnail,
            uploader_id, uploader_name, uploader_email, uploader_avatar,
            status
        ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
    """
    uploader_name = f"{user['first_name']} {user['last_name']}"

    project_id = execute_query(
        query,
        (
            competition_id, project_name, elevator_pitch, about_project, built_with,
            video_demo_link, thumbnail_url,
            user_id, uploader_name, user['email'], user['avatar'],
            'submitted'
        ),
        commit=True
    )

    # Insert links
    links = json.loads(try_it_out_links)
    for idx, link in enumerate(links):
        execute_query(
            "INSERT INTO project_links (project_id, url, display_order) VALUES (%s, %s, %s)",
            (project_id, link, idx),
            commit=True
        )

    return {
        "status": "success",
        "message": "Project created successfully",
        "project_id": project_id
    }

@app.post("/api/projects/{project_id}/vote")
async def vote_project(project_id: int, user_id: int):
    """Vote for a project"""
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)

    try:
        cursor.callproc('sp_vote_project', [project_id, user_id])
        result = None
        for res in cursor.stored_results():
            result = res.fetchone()
        connection.commit()

        if result and result['status'] == 'error':
            raise HTTPException(status_code=400, detail=result['message'])

        return result
    finally:
        cursor.close()
        connection.close()

@app.post("/api/projects/{project_id}/comments")
async def add_comment(project_id: int, user_id: int, comment: CommentCreate):
    """Add comment to project"""
    # Get user info
    user = execute_query(
        "SELECT first_name, last_name, avatar FROM users WHERE id = %s",
        (user_id,),
        fetch_one=True
    )

    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    user_name = f"{user['first_name']} {user['last_name']}"

    # Insert comment
    comment_id = execute_query(
        """
        INSERT INTO project_comments (project_id, user_id, user_name, user_avatar, comment)
        VALUES (%s, %s, %s, %s, %s)
        """,
        (project_id, user_id, user_name, user['avatar'], comment.comment),
        commit=True
    )

    return {
        "status": "success",
        "comment_id": comment_id
    }

# ============================================================================
# NEWS ENDPOINTS
# ============================================================================

@app.get("/api/news")
async def get_news(
    category: Optional[str] = None,
    limit: int = 20,
    offset: int = 0
):
    """Get all news with optional filters"""
    query = "SELECT * FROM news WHERE 1=1"
    params = []

    if category:
        query += " AND category = %s"
        params.append(category)

    query += " ORDER BY id ASC LIMIT %s OFFSET %s"
    params.extend([limit, offset])

    news = execute_query(query, tuple(params), fetch_all=True)

    return [
        {
            "id": item["id"],
            "title": item["title"],
            "content": item["content"],
            "category": item["category"],
            "image": item["image"],
            "date": str(item["date"])
        }
        for item in news
    ]

@app.get("/api/news/{news_id}")
async def get_news_item(news_id: int):
    """Get single news item"""
    news = execute_query(
        "SELECT * FROM news WHERE id = %s",
        (news_id,),
        fetch_one=True
    )

    if not news:
        raise HTTPException(status_code=404, detail="News not found")

    return {
        "id": news["id"],
        "title": news["title"],
        "content": news["content"],
        "category": news["category"],
        "image": news["image"],
        "date": str(news["date"])
    }

# ============================================================================
# HEALTH CHECK
# ============================================================================

@app.get("/")
async def root():
    """API health check"""
    return {
        "status": "running",
        "message": "ComSwin API is running",
        "version": "1.0.0"
    }

@app.get("/api/health")
async def health():
    """Database health check"""
    try:
        connection = get_db_connection()
        connection.close()
        return {"status": "healthy", "database": "connected"}
    except:
        raise HTTPException(status_code=500, detail="Database connection failed")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)