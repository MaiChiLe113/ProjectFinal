<template>
  <div class="project-detail" v-if="project">
    <!-- Hero Banner -->
    <div class="hero-banner position-relative">
      <img
        :src="project.projectImages[0]?.url || 'https://i.pinimg.com/736x/a7/16/18/a7161851115fea0f1c7ef4746c90bd02.jpg'"
        :alt="project.projectName"
        class="hero-banner__image w-100"
      />
      <div class="hero-banner__overlay"></div>

      <div class="container position-relative">
        <div class="hero-banner__content">
          <div class="d-flex gap-2 mb-3">
            <span class="badge bg-primary bg-opacity-90 px-3 py-2 fs-6">
              <i class="bi bi-folder-fill me-2"></i>Project
            </span>
            <span class="badge bg-success bg-opacity-90 px-3 py-2 fs-6">
              <i class="bi bi-check-circle-fill me-2"></i>{{ project.status }}
            </span>
            <span 
              v-for="award in project.awards" 
              :key="award"
              class="badge bg-warning text-dark px-3 py-2 fs-6">
              <i class="bi bi-trophy-fill me-2"></i>{{ award }}
            </span>
          </div>

          <h1 class="display-4 fw-bold text-white mb-3">{{ project.projectName }}</h1>
          <p class="lead text-white mb-4">{{ project.elevatorPitch }}</p>

          <div class="d-flex flex-wrap gap-3 align-items-center">
            <button
              class="btn btn-danger btn-lg px-4"
              @click="toggleVote"
              :class="{ 'active': hasVoted }">
              <i class="bi bi-heart-fill me-2"></i>
              {{ hasVoted ? 'Voted' : 'Vote' }} ({{ project.votes }})
            </button>
            <a
              v-if="project.tryItOutLinks && project.tryItOutLinks[0]"
              :href="project.tryItOutLinks[0]"
              target="_blank"
              class="btn btn-outline-light btn-lg px-4">
              <i class="bi bi-box-arrow-up-right me-2"></i>Try It Out
            </a>
            <span class="badge bg-info bg-opacity-90 px-3 py-2 fs-6">
              <i class="bi bi-calendar3 me-2"></i>Submitted {{ formatDate(project.dates.submitted) }}
            </span>
          </div>
        </div>
      </div>
    </div>

    <!-- Quick Info Bar -->
    <div class="quick-info bg-light border-bottom">
      <div class="container">
        <div class="row py-3 text-center">
          <div class="col-6 col-md-3 border-end">
            <div class="quick-info__item">
              <i class="bi bi-heart-fill text-danger fs-4 d-block mb-2"></i>
              <div class="fw-bold">{{ project.votes }}</div>
              <div class="small text-muted">votes</div>
            </div>
          </div>
          <div class="col-6 col-md-3 border-end">
            <div class="quick-info__item">
              <i class="bi bi-chat-fill text-primary fs-4 d-block mb-2"></i>
              <div class="fw-bold">{{ project.comments.length }}</div>
              <div class="small text-muted">comments</div>
            </div>
          </div>
          <div class="col-6 col-md-3 border-end">
            <div class="quick-info__item">
              <i class="bi bi-people-fill text-primary fs-4 d-block mb-2"></i>
              <div class="fw-bold">{{ project.team.length }}</div>
              <div class="small text-muted">team members</div>
            </div>
          </div>
          <div class="col-6 col-md-3">
            <div class="quick-info__item">
              <i class="bi bi-trophy-fill text-warning fs-4 d-block mb-2"></i>
              <div class="fw-bold">{{ project.awards.length }}</div>
              <div class="small text-muted">awards</div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Navigation Tabs -->
    <div class="project-tabs sticky-top bg-white border-bottom">
      <div class="container">
        <ul class="nav nav-tabs border-0 justify-content-center">
          <li class="nav-item">
            <a
              class="nav-link"
              :class="{ active: activeTab === 'overview' }"
              @click.prevent="activeTab = 'overview'"
              href="#">
              <i class="bi bi-info-circle me-2"></i>Overview
            </a>
          </li>
          <li class="nav-item">
            <a
              class="nav-link"
              :class="{ active: activeTab === 'team' }"
              @click.prevent="activeTab = 'team'"
              href="#">
              <i class="bi bi-people me-2"></i>Team ({{ project.team.length }})
            </a>
          </li>
          <li class="nav-item">
            <a
              class="nav-link"
              :class="{ active: activeTab === 'gallery' }"
              @click.prevent="activeTab = 'gallery'"
              href="#">
              <i class="bi bi-images me-2"></i>Gallery ({{ project.projectImages.length }})
            </a>
          </li>
          <li class="nav-item">
            <a
              class="nav-link"
              :class="{ active: activeTab === 'comments' }"
              @click.prevent="activeTab = 'comments'"
              href="#">
              <i class="bi bi-chat-dots me-2"></i>Comments ({{ project.comments.length }})
            </a>
          </li>
        </ul>
      </div>
    </div>

    <!-- Tab Content -->
    <div class="container my-5">
      <div class="row">
        <!-- Main Content -->
        <div class="col-lg-8">
          <!-- Overview Tab -->
          <div v-show="activeTab === 'overview'" class="tab-content-panel">
            <h2 class="mb-4">Project Overview</h2>

            <!-- Video Demo -->
            <div v-if="project.videoDemoLink" class="card mb-4">
              <div class="card-body">
                <h5 class="card-title mb-3">
                  <i class="bi bi-play-circle text-primary me-2"></i>Video Demo
                </h5>
                <div class="ratio ratio-16x9">
                  <iframe 
                    :src="getEmbedUrl(project.videoDemoLink)" 
                    allowfullscreen>
                  </iframe>
                </div>
              </div>
            </div>

            <!-- Project Story -->
            <div class="card mb-4">
              <div class="card-body">
                <h5 class="card-title mb-3">
                  <i class="bi bi-book text-primary me-2"></i>Project Story
                </h5>
                <div class="project-story" v-html="renderMarkdown(project.aboutProject)"></div>
              </div>
            </div>

            <!-- Built With -->
            <div class="card mb-4" v-if="project.builtWith">
              <div class="card-body">
                <h5 class="card-title mb-3">
                  <i class="bi bi-code-square text-primary me-2"></i>Built With
                </h5>
                <div class="d-flex flex-wrap gap-2">
                  <span 
                    v-for="(tech, index) in getTechnologies(project.builtWith)" 
                    :key="index"
                    class="badge bg-secondary bg-opacity-75 px-3 py-2">
                    {{ tech }}
                  </span>
                </div>
              </div>
            </div>

            <!-- Try It Out Links -->
            <div class="card mb-4" v-if="project.tryItOutLinks && project.tryItOutLinks.length > 0">
              <div class="card-body">
                <h5 class="card-title mb-3">
                  <i class="bi bi-link-45deg text-primary me-2"></i>Try It Out
                </h5>
                <div class="list-group">
                  <a 
                    v-for="(link, index) in project.tryItOutLinks" 
                    :key="index"
                    :href="link"
                    target="_blank"
                    class="list-group-item list-group-item-action">
                    <i class="bi bi-box-arrow-up-right me-2"></i>{{ getLinkLabel(link, index) }}
                  </a>
                </div>
              </div>
            </div>

            <!-- Tags -->
            <div class="card">
              <div class="card-body">
                <h5 class="card-title mb-3">
                  <i class="bi bi-tags text-primary me-2"></i>Tags
                </h5>
                <div class="d-flex flex-wrap gap-2">
                  <span 
                    v-for="tag in project.tags" 
                    :key="tag"
                    class="badge bg-light text-dark border px-3 py-2">
                    {{ tag }}
                  </span>
                </div>
              </div>
            </div>
          </div>

          <!-- Team Tab -->
          <div v-show="activeTab === 'team'" class="tab-content-panel">
            <h2 class="mb-4">Team Members ({{ project.team.length }})</h2>

            <div class="row g-3">
              <div v-for="member in project.team" :key="member.id" class="col-md-6">
                <div class="card h-100">
                  <div class="card-body">
                    <div class="d-flex align-items-center">
                      <div class="avatar bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-3"
                        style="width: 60px; height: 60px; font-size: 1.5rem;">
                        {{ member.name.charAt(0) }}
                      </div>
                      <div>
                        <h6 class="mb-1">{{ member.name }}</h6>
                        <p class="text-muted small mb-0">{{ member.role }}</p>
                        <span 
                          v-if="member.id === project.uploader.id"
                          class="badge bg-warning text-dark mt-1">
                          <i class="bi bi-star-fill me-1"></i>Project Lead
                        </span>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Gallery Tab -->
          <div v-show="activeTab === 'gallery'" class="tab-content-panel">
            <h2 class="mb-4">Project Gallery</h2>

            <div class="row g-3" v-if="project.projectImages && project.projectImages.length > 0">
              <div v-for="(image, index) in project.projectImages" :key="index" class="col-md-6">
                <div class="card">
                  <img 
                    :src="image.url" 
                    :alt="image.caption || 'Project image'" 
                    class="card-img-top"
                    style="height: 300px; object-fit: cover; cursor: pointer;"
                    @click="openImageModal(image)">
                  <div class="card-body" v-if="image.caption">
                    <p class="card-text">{{ image.caption }}</p>
                  </div>
                </div>
              </div>
            </div>
            <div v-else class="text-center py-5">
              <i class="bi bi-images text-muted" style="font-size: 4rem;"></i>
              <p class="text-muted mt-3">No images available</p>
            </div>
          </div>

          <!-- Comments Tab -->
          <div v-show="activeTab === 'comments'" class="tab-content-panel">
            <h2 class="mb-4">Comments ({{ project.comments.length }})</h2>

            <!-- Add Comment -->
            <div class="card mb-4">
              <div class="card-body">
                <h5 class="card-title mb-3">Leave a Comment</h5>
                <textarea 
                  class="form-control mb-3" 
                  rows="3"
                  v-model="newComment"
                  placeholder="Share your thoughts about this project..."></textarea>
                <button class="btn btn-primary" @click="addComment">
                  <i class="bi bi-send-fill me-2"></i>Post Comment
                </button>
              </div>
            </div>

            <!-- Comments List -->
            <div v-for="comment in project.comments" :key="comment.id" class="card mb-3">
              <div class="card-body">
                <div class="d-flex align-items-start">
                  <div class="avatar bg-secondary text-white rounded-circle d-flex align-items-center justify-content-center me-3"
                    style="width: 40px; height: 40px; flex-shrink: 0;">
                    {{ comment.userName.charAt(0) }}
                  </div>
                  <div class="flex-grow-1">
                    <div class="d-flex justify-content-between align-items-start mb-2">
                      <div>
                        <h6 class="mb-0">{{ comment.userName }}</h6>
                        <small class="text-muted">{{ formatDateTime(comment.timestamp) }}</small>
                      </div>
                      <button 
                        class="btn btn-sm btn-outline-secondary"
                        @click="toggleCommentLike(comment)">
                        <i class="bi bi-heart-fill me-1"></i>{{ comment.likes }}
                      </button>
                    </div>
                    <p class="mb-0">{{ comment.comment }}</p>
                  </div>
                </div>
              </div>
            </div>

            <div v-if="project.comments.length === 0" class="text-center py-5">
              <i class="bi bi-chat-dots text-muted" style="font-size: 4rem;"></i>
              <p class="text-muted mt-3">No comments yet. Be the first to comment!</p>
            </div>
          </div>
        </div>

        <!-- Sidebar -->
        <div class="col-lg-4">
          <!-- Uploader Info -->
          <div class="card mb-4 sticky-sidebar">
            <div class="card-body">
              <h5 class="card-title mb-3">
                <i class="bi bi-person-circle text-primary me-2"></i>Submitted By
              </h5>
              <div class="d-flex align-items-center mb-3">
                <div class="avatar bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-3"
                  style="width: 50px; height: 50px;">
                  {{ project.uploader.name.charAt(0) }}
                </div>
                <div>
                  <h6 class="mb-0">{{ project.uploader.name }}</h6>
                  <small class="text-muted">{{ project.uploader.email }}</small>
                </div>
              </div>
              <button class="btn btn-outline-primary w-100">
                <i class="bi bi-envelope-fill me-2"></i>Contact
              </button>
            </div>
          </div>

          <!-- Competition Link -->
          <div class="card mb-4">
            <div class="card-body">
              <h5 class="card-title mb-3">
                <i class="bi bi-trophy text-primary me-2"></i>Competition
              </h5>
              <p class="mb-3">This project was submitted for:</p>
              <router-link 
                :to="`/competitions/${project.competitionId}`"
                class="btn btn-primary w-100">
                <i class="bi bi-box-arrow-up-right me-2"></i>View Competition
              </router-link>
            </div>
          </div>

          <!-- Stats -->
          <div class="card">
            <div class="card-body">
              <h5 class="card-title mb-3">
                <i class="bi bi-graph-up text-primary me-2"></i>Project Stats
              </h5>
              <div class="d-flex justify-content-between mb-2">
                <span>Votes:</span>
                <strong>{{ project.votes }}</strong>
              </div>
              <div class="d-flex justify-content-between mb-2">
                <span>Comments:</span>
                <strong>{{ project.comments.length }}</strong>
              </div>
              <div class="d-flex justify-content-between mb-2">
                <span>Team Size:</span>
                <strong>{{ project.team.length }}</strong>
              </div>
              <div class="d-flex justify-content-between">
                <span>Submitted:</span>
                <strong>{{ formatDate(project.dates.submitted) }}</strong>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Back Button -->
    <div class="container mb-5">
      <button @click="$router.back()" class="btn btn-outline-secondary">
        <i class="bi bi-arrow-left me-2"></i>Back to Projects
      </button>
    </div>
  </div>

  <!-- Loading State -->
  <div v-else class="container my-5 text-center">
    <div class="spinner-border text-primary" role="status">
      <span class="visually-hidden">Loading...</span>
    </div>
    <p class="mt-3 text-muted">Loading project details...</p>
  </div>
</template>

<script>
export default {
  name: 'ProjectDetail',
  data() {
    return {
      project: null,
      activeTab: 'overview',
      hasVoted: false,
      newComment: ''
    }
  },
  methods: {
    async loadProject() {
      try {
        const projectId = this.$route.params.id
        const response = await fetch('/src/data/projects.json')
        const data = await response.json()
        this.project = data.projects.find(p => p.id === parseInt(projectId))

        if (!this.project) {
          this.$router.push('/projects')
        }
      } catch (error) {
        console.error('Error loading project:', error)
      }
    },
    formatDate(dateString) {
      const options = { year: 'numeric', month: 'short', day: 'numeric' }
      return new Date(dateString).toLocaleDateString('en-US', options)
    },
    formatDateTime(dateString) {
      const options = { 
        year: 'numeric', 
        month: 'short', 
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
      }
      return new Date(dateString).toLocaleDateString('en-US', options)
    },
    toggleVote() {
      this.hasVoted = !this.hasVoted
      if (this.hasVoted) {
        this.project.votes++
      } else {
        this.project.votes--
      }
    },
    toggleCommentLike(comment) {
      comment.likes++
    },
    addComment() {
      if (!this.newComment.trim()) return

      const comment = {
        id: this.project.comments.length + 1,
        userId: 999,
        userName: 'Current User',
        avatar: 'https://i.pravatar.cc/150?img=50',
        comment: this.newComment,
        timestamp: new Date().toISOString(),
        likes: 0
      }

      this.project.comments.unshift(comment)
      this.newComment = ''
    },
    renderMarkdown(text) {
      // Simple markdown rendering (you might want to use a library like marked.js)
      return text
        .replace(/### (.*)/g, '<h3>$1</h3>')
        .replace(/## (.*)/g, '<h2>$1</h2>')
        .replace(/# (.*)/g, '<h1>$1</h1>')
        .replace(/\n\n/g, '</p><p>')
        .replace(/\n/g, '<br>')
    },
    getTechnologies(builtWith) {
      return builtWith.split(',').map(tech => tech.trim())
    },
    getLinkLabel(link, index) {
      if (link.includes('github.com')) return 'GitHub Repository'
      if (link.includes('demo') || link.includes('herokuapp') || link.includes('vercel')) return 'Live Demo'
      return `Link ${index + 1}`
    },
    getEmbedUrl(url) {
      // Convert YouTube URLs to embed format
      if (url.includes('youtube.com') || url.includes('youtu.be')) {
        const videoId = url.split('v=')[1] || url.split('/').pop()
        return `https://www.youtube.com/embed/${videoId}`
      }
      return url
    },
    openImageModal(image) {
      // Implement image modal functionality
      window.open(image.url, '_blank')
    }
  },
  mounted() {
    this.loadProject()
  }
}
</script>

<style scoped>
/* Hero Banner */
.hero-banner {
  height: 500px;
  overflow: hidden;
}

.hero-banner__image {
  height: 100%;
  object-fit: cover;
  object-position: center;
}

.hero-banner__overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(to bottom, rgba(0,0,0,0.4), rgba(0,0,0,0.7));
}

.hero-banner__content {
  position: absolute;
  bottom: 60px;
  left: 15px;
  right: 15px;
}

/* Quick Info */
.quick-info__item {
  padding: 0.5rem;
}

/* Tabs */
.project-tabs {
  z-index: 1020;
}

.nav-tabs {
  border-bottom: none;
}

.nav-tabs .nav-link {
  border: none;
  color: #6c757d;
  font-weight: 500;
  padding: 1rem 1.5rem;
  border-bottom: 3px solid transparent;
  transition: all 0.3s ease;
}

.nav-tabs .nav-link:hover {
  color: #0d6efd;
  border-bottom-color: #0d6efd;
}

.nav-tabs .nav-link.active {
  color: #0d6efd;
  border-bottom-color: #0d6efd;
  background-color: transparent;
}

/* Tab Content */
.tab-content-panel {
  animation: fadeIn 0.3s ease-in;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* Sidebar */
.sticky-sidebar {
  position: sticky;
  top: 80px;
}

/* Cards */
.card {
  border: 1px solid #e9ecef;
  transition: box-shadow 0.3s ease;
}

.card:hover {
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
}

/* Project Story */
.project-story {
  line-height: 1.8;
}

.project-story h1,
.project-story h2,
.project-story h3 {
  margin-top: 1.5rem;
  margin-bottom: 1rem;
  color: #212529;
}

/* Avatar */
.avatar {
  font-weight: 600;
}

/* Buttons */
.btn-danger.active {
  background-color: #c82333;
  border-color: #bd2130;
}

/* Responsive */
@media (max-width: 992px) {
  .hero-banner {
    height: 400px;
  }

  .hero-banner__content {
    bottom: 30px;
  }

  .sticky-sidebar {
    position: static;
  }
}

@media (max-width: 768px) {
  .hero-banner {
    height: 350px;
  }

  .nav-tabs .nav-link {
    padding: 0.75rem 1rem;
    font-size: 0.875rem;
  }

  .quick-info .col-6 {
    border-right: none !important;
    border-bottom: 1px solid #dee2e6;
  }

  .quick-info .col-6:nth-child(3),
  .quick-info .col-6:nth-child(4) {
    border-bottom: none;
  }
}
</style>