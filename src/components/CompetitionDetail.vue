<template>
  <div class="competition-detail" v-if="competition">
    <!-- Hero Banner -->
    <div class="hero-banner position-relative">
      <img 
        :src="competition.images.banner" 
        :alt="competition.title"
        class="hero-banner__image w-100"
      />
      <div class="hero-banner__overlay"></div>
      
      <div class="container position-relative">
        <div class="hero-banner__content">
          <div class="d-flex gap-2 mb-3">
            <span class="badge bg-primary bg-opacity-90 px-3 py-2 fs-6">
              <i class="bi bi-tag-fill me-2"></i>{{ competition.category }}
            </span>
            <span 
              class="badge px-3 py-2 fs-6"
              :class="getStatusBadgeClass(competition.status)">
              <i class="bi bi-circle-fill me-2"></i>{{ competition.status }}
            </span>
          </div>
          
          <h1 class="display-4 fw-bold text-white mb-3">{{ competition.title }}</h1>
          <p class="lead text-white mb-4">{{ competition.description }}</p>
          
          <div class="d-flex flex-wrap gap-3 align-items-center">
            <button 
              v-if="competition.registration.isOpen" 
              class="btn btn-primary btn-lg px-4"
              @click="joinCompetition">
              <i class="bi bi-trophy-fill me-2"></i>Join Competition
            </button>
            <button 
              v-else 
              class="btn btn-secondary btn-lg px-4" 
              disabled>
              <i class="bi bi-lock-fill me-2"></i>Registration Closed
            </button>
            <span class="badge bg-success bg-opacity-90 px-3 py-2 fs-6" v-if="daysToDeadline > 0">
              <i class="bi bi-clock-fill me-2"></i>{{ daysToDeadline }} days to deadline
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
              <i class="bi bi-calendar3 text-primary fs-4 d-block mb-2"></i>
              <div class="fw-bold">Deadline</div>
              <div class="small text-muted">{{ formatDate(competition.dates.registrationDeadline) }}</div>
            </div>
          </div>
          <div class="col-6 col-md-3 border-end">
            <div class="quick-info__item">
              <i class="bi bi-people-fill text-primary fs-4 d-block mb-2"></i>
              <div class="fw-bold">{{ competition.capacity.current }} / {{ competition.capacity.max }}</div>
              <div class="small text-muted">participants</div>
            </div>
          </div>
          <div class="col-6 col-md-3 border-end">
            <div class="quick-info__item">
              <i :class="getLocationIcon(competition.location.type)" class="text-primary fs-4 d-block mb-2"></i>
              <div class="fw-bold">{{ competition.location.type }}</div>
              <div class="small text-muted">{{ competition.participants }}</div>
            </div>
          </div>
          <div class="col-6 col-md-3">
            <div class="quick-info__item">
              <i class="bi bi-currency-dollar text-primary fs-4 d-block mb-2"></i>
              <div class="fw-bold">Prize Pool</div>
              <div class="small text-muted">Available</div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Navigation Tabs -->
    <div class="competition-tabs sticky-top bg-white border-bottom">
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
              :class="{ active: activeTab === 'myproject' }"
              @click.prevent="activeTab = 'myproject'"
              href="#">
              <i class="bi bi-folder me-2"></i>My Project
            </a>
          </li>
          <!-- Projects in this competition -->
          <li class="nav-item">
            <router-link 
              class="nav-link" 
              :class="{ active: activeTab === 'projects' }"
              @click.prevent="activeTab = 'projects'"
              :to="`/competitions/${competition.id}/projects`"
              target="_self">
              <i class="bi bi-folder me-2"></i>Projects
            </router-link>
          </li>
          <li class="nav-item">
            <a 
              class="nav-link" 
              :class="{ active: activeTab === 'participants' }"
              @click.prevent="activeTab = 'participants'"
              href="#">
              <i class="bi bi-people me-2"></i>Participants ({{ competition.capacity.current }})
            </a>
          </li>
          <li class="nav-item">
            <a 
              class="nav-link" 
              :class="{ active: activeTab === 'gallery' }"
              @click.prevent="activeTab = 'gallery'"
              href="#">
              <i class="bi bi-images me-2"></i>Gallery
            </a>
          </li>
          <li class="nav-item">
            <a 
              class="nav-link" 
              :class="{ active: activeTab === 'news' }"
              @click.prevent="activeTab = 'news'"
              href="#">
              <i class="bi bi-newspaper me-2"></i>News
            </a>
          </li>
          <li class="nav-item">
            <a 
              class="nav-link" 
              :class="{ active: activeTab === 'rules' }"
              @click.prevent="activeTab = 'rules'"
              href="#">
              <i class="bi bi-file-text me-2"></i>Rules
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
            <h2 class="mb-4">About This Competition</h2>
            
            <div class="card mb-4">
              <div class="card-body">
                <h5 class="card-title mb-3">
                  <i class="bi bi-file-text text-primary me-2"></i>Description
                </h5>
                <p class="card-text">{{ competition.description }}</p>
                <p class="card-text text-muted">
                  This competition brings together talented individuals from {{ competition.participants }} 
                  to showcase their skills in {{ competition.category.toLowerCase() }}. 
                  Join us for an exciting journey of learning, competition, and networking.
                </p>
              </div>
            </div>

            <div class="card mb-4">
              <div class="card-body">
                <h5 class="card-title mb-3">
                  <i class="bi bi-trophy text-primary me-2"></i>Prizes & Rewards
                </h5>
                <p class="card-text">{{ competition.prizes }}</p>
                <div class="alert alert-success mt-3">
                  <i class="bi bi-star-fill me-2"></i>
                  Winners will also receive certificates and potential networking opportunities!
                </div>
              </div>
            </div>

            <div class="card mb-4">
              <div class="card-body">
                <h5 class="card-title mb-3">
                  <i class="bi bi-calendar-range text-primary me-2"></i>Important Dates
                </h5>
                <div class="row g-3">
                  <div class="col-md-6">
                    <div class="p-3 bg-light rounded">
                      <strong>Competition Start:</strong>
                      <div class="text-muted">{{ formatDate(competition.dates.start) }}</div>
                    </div>
                  </div>
                  <div class="col-md-6">
                    <div class="p-3 bg-light rounded">
                      <strong>Competition End:</strong>
                      <div class="text-muted">{{ formatDate(competition.dates.end) }}</div>
                    </div>
                  </div>
                  <div class="col-md-6">
                    <div class="p-3 bg-light rounded">
                      <strong>Registration Deadline:</strong>
                      <div class="text-muted">{{ formatDate(competition.dates.registrationDeadline) }}</div>
                    </div>
                  </div>
                  <div class="col-md-6">
                    <div class="p-3 bg-light rounded">
                      <strong>Created On:</strong>
                      <div class="text-muted">{{ formatDate(competition.dates.created) }}</div>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <div class="card">
              <div class="card-body">
                <h5 class="card-title mb-3">
                  <i class="bi bi-geo-alt text-primary me-2"></i>Location Details
                </h5>
                <p><strong>Type:</strong> {{ competition.location.type }}</p>
                <p><strong>Venue:</strong> {{ competition.location.venue }}</p>
                <p v-if="competition.location.link" class="mb-0">
                  <strong>Link:</strong> 
                  <a :href="competition.location.link" target="_blank" class="ms-2">
                    {{ competition.location.link }}
                    <i class="bi bi-box-arrow-up-right ms-1"></i>
                  </a>
                </p>
              </div>
            </div>
          </div>

          <!-- My Project Tab -->
          <div v-show="activeTab === 'myproject'" class="tab-content-panel">
            <ProjectTab />
          </div>


          <!-- Other Projects Tab -->
          <div v-show="activeTab === 'otherprojects'" class="tab-content-panel">
            <Projects />
          </div>

          <!-- Participants Tab -->
          <div v-show="activeTab === 'participants'" class="tab-content-panel">
            <h2 class="mb-4">Participants ({{ mockParticipants.length }})</h2>
            
            <div class="row g-3">
              <div v-for="participant in mockParticipants" :key="participant.id" class="col-md-6">
                <div class="card h-100">
                  <div class="card-body">
                    <div class="d-flex align-items-center">
                      <div class="avatar bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-3"
                           style="width: 50px; height: 50px; font-size: 1.25rem;">
                        {{ participant.name.charAt(0) }}
                      </div>
                      <div>
                        <h6 class="mb-0">{{ participant.name }}</h6>
                        <small class="text-muted">{{ participant.school }}</small>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Gallery Tab -->
          <div v-show="activeTab === 'gallery'" class="tab-content-panel">
            <h2 class="mb-4">Gallery</h2>
            
            <div class="row g-3" v-if="competition.images.gallery && competition.images.gallery.length > 0">
              <div v-for="(image, index) in competition.images.gallery" :key="index" class="col-md-6">
                <div class="card">
                  <img :src="image.url" :alt="image.caption" class="card-img-top" style="height: 250px; object-fit: cover;">
                  <div class="card-body">
                    <p class="card-text">{{ image.caption }}</p>
                  </div>
                </div>
              </div>
            </div>
            <div v-else class="text-center py-5">
              <i class="bi bi-images text-muted" style="font-size: 4rem;"></i>
              <p class="text-muted mt-3">No images available yet</p>
            </div>
          </div>

          <!-- News Tab -->
          <div v-show="activeTab === 'news'" class="tab-content-panel">
            <h2 class="mb-4">Latest News & Updates</h2>
            
            <div v-for="news in mockNews" :key="news.id" class="card mb-3">
              <div class="card-body">
                <div class="d-flex justify-content-between align-items-start mb-2">
                  <h5 class="card-title mb-0">{{ news.title }}</h5>
                  <span class="badge bg-secondary">{{ news.date }}</span>
                </div>
                <p class="card-text text-muted">{{ news.content }}</p>
              </div>
            </div>
          </div>

          <!-- Rules Tab -->
          <div v-show="activeTab === 'rules'" class="tab-content-panel">
            <h2 class="mb-4">Competition Rules</h2>
            
            <div class="card mb-4">
              <div class="card-body">
                <h5 class="card-title">
                  <i class="bi bi-shield-check text-primary me-2"></i>Official Rules
                </h5>
                <p class="card-text">{{ competition.rules }}</p>
              </div>
            </div>

            <div class="card mb-4">
              <div class="card-body">
                <h5 class="card-title mb-3">Eligibility</h5>
                <ul>
                  <li>Open to: {{ competition.participants }}</li>
                  <li v-if="competition.registration.requiresApproval">Requires approval from organizers</li>
                  <li v-if="competition.registration.allowTeams">
                    Team participation allowed ({{ competition.registration.teamSize }} members per team)
                  </li>
                  <li v-else>Individual participation only</li>
                </ul>
              </div>
            </div>

            <div class="alert alert-warning">
              <i class="bi bi-exclamation-triangle me-2"></i>
              <strong>Important:</strong> Please read all rules carefully before participating. 
              Violation of rules may result in disqualification.
            </div>
          </div>
        </div>

        <!-- Sidebar -->
        <div class="col-lg-4">
          <!-- Organizer Info -->
          <div class="card mb-4 sticky-sidebar">
            <div class="card-body">
              <h5 class="card-title mb-3">
                <i class="bi bi-building text-primary me-2"></i>Organized By
              </h5>
              <h6>{{ competition.organizer.name }}</h6>
              <p class="text-muted small mb-2">
                <i class="bi bi-tag me-1"></i>{{ competition.organizer.type }}
              </p>
              <p class="mb-3">
                <i class="bi bi-envelope me-2"></i>
                <a :href="'mailto:' + competition.organizer.email">{{ competition.organizer.email }}</a>
              </p>
              <button class="btn btn-outline-primary w-100">
                <i class="bi bi-envelope-fill me-2"></i>Contact Organizer
              </button>
            </div>
          </div>

          <!-- Registration Info -->
          <div class="card mb-4">
            <div class="card-body">
              <h5 class="card-title mb-3">
                <i class="bi bi-person-check text-primary me-2"></i>Registration
              </h5>
              <div class="mb-3">
                <div class="d-flex justify-content-between mb-2">
                  <span>Capacity:</span>
                  <strong>{{ competition.capacity.current }} / {{ competition.capacity.max }}</strong>
                </div>
                <div class="progress" style="height: 10px;">
                  <div 
                    class="progress-bar" 
                    :class="getCapacityClass()"
                    role="progressbar" 
                    :style="{ width: capacityPercentage + '%' }"
                    :aria-valuenow="capacityPercentage" 
                    aria-valuemin="0" 
                    aria-valuemax="100">
                  </div>
                </div>
              </div>
              <div v-if="competition.capacity.waitlist > 0" class="alert alert-info py-2">
                <small>{{ competition.capacity.waitlist }} on waitlist</small>
              </div>
              <div class="d-grid">
                <button 
                  v-if="competition.registration.isOpen" 
                  class="btn btn-success"
                  @click="joinCompetition">
                  <i class="bi bi-check-circle me-2"></i>Register Now
                </button>
                <button v-else class="btn btn-secondary" disabled>
                  <i class="bi bi-x-circle me-2"></i>Closed
                </button>
              </div>
            </div>
          </div>

          <!-- Stats -->
          <div class="card">
            <div class="card-body">
              <h5 class="card-title mb-3">
                <i class="bi bi-graph-up text-primary me-2"></i>Statistics
              </h5>
              <div class="d-flex justify-content-between mb-2">
                <span>Views:</span>
                <strong>{{ competition.metadata.views }}</strong>
              </div>
              <div class="d-flex justify-content-between mb-2">
                <span>Votes:</span>
                <strong>{{ competition.metadata.votes }}</strong>
              </div>
              <div class="d-flex justify-content-between">
                <span>Registrations:</span>
                <strong>{{ competition.metadata.registrations }}</strong>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Back Button -->
    <div class="container mb-5">
      <button @click="$router.back()" class="btn btn-outline-secondary">
        <i class="bi bi-arrow-left me-2"></i>Back to Competitions
      </button>
    </div>
  </div>

  <!-- Loading State -->
  <div v-else class="container my-5 text-center">
    <div class="spinner-border text-primary" role="status">
      <span class="visually-hidden">Loading...</span>
    </div>
    <p class="mt-3 text-muted">Loading competition details...</p>
  </div>
</template>

<script>
import Projects from '../pages/Stage2/Projects.vue';
import ProjectTab from './ProjectTab.vue'

export default {
  name: 'CompetitionDetail',
  components: {
    ProjectTab
  },
  data() {
    return {
      competition: null,
      activeTab: 'overview',
      mockParticipants: [
        { id: 1, name: 'Alice Nguyen', school: 'Computer Science' },
        { id: 2, name: 'Bob Tran', school: 'Information Technology' },
        { id: 3, name: 'Charlie Le', school: 'Software Engineering' },
        { id: 4, name: 'David Pham', school: 'Data Science' },
        { id: 5, name: 'Emma Hoang', school: 'Computer Science' },
        { id: 6, name: 'Frank Vo', school: 'Cybersecurity' }
      ],
      mockNews: [
        {
          id: 1,
          title: 'Registration Now Open!',
          date: 'Nov 10, 2025',
          content: 'We are excited to announce that registration for this competition is now open. Don\'t miss your chance to participate!'
        },
        {
          id: 2,
          title: 'Prizes Announced',
          date: 'Nov 5, 2025',
          content: 'Check out the amazing prizes waiting for our winners. Good luck to all participants!'
        },
        {
          id: 3,
          title: 'Competition Guidelines Updated',
          date: 'Nov 1, 2025',
          content: 'We have updated the competition guidelines. Please review the rules section for the latest information.'
        }
      ]
    }
  },
  computed: {
    daysToDeadline() {
      const deadline = new Date(this.competition.dates.registrationDeadline)
      const today = new Date()
      const diffTime = deadline - today
      const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24))
      return diffDays > 0 ? diffDays : 0
    },
    capacityPercentage() {
      return (this.competition.capacity.current / this.competition.capacity.max) * 100
    }
  },
  methods: {
    async loadCompetition() {
      try {
        const competitionId = this.$route.params.id
        const response = await fetch('/data/competitions.json')
        const data = await response.json()
        this.competition = data.competitions.find(c => c.id === parseInt(competitionId))
        
        if (!this.competition) {
          this.$router.push('/competitions')
        }
      } catch (error) {
        console.error('Error loading competition:', error)
      }
    },
    formatDate(dateString) {
      const options = { year: 'numeric', month: 'long', day: 'numeric' }
      return new Date(dateString).toLocaleDateString('en-US', options)
    },
    getStatusBadgeClass(status) {
      const classes = {
        'upcoming': 'bg-info',
        'ongoing': 'bg-success',
        'completed': 'bg-secondary'
      }
      return classes[status] || 'bg-secondary'
    },
    getLocationIcon(locationType) {
      const icons = {
        'online': 'bi bi-laptop',
        'offline': 'bi bi-geo-alt-fill',
        'hybrid': 'bi bi-globe'
      }
      return icons[locationType] || 'bi bi-question-circle'
    },
    getCapacityClass() {
      const percentage = this.capacityPercentage
      if (percentage < 50) return 'bg-success'
      if (percentage < 80) return 'bg-warning'
      return 'bg-danger'
    },
    joinCompetition() {
        this.$router.push(`/competitions/${this.competition.id}/join`)
    }
  },
  mounted() {
    this.loadCompetition()
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
.competition-tabs {
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