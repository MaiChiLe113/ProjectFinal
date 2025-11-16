<template>
  <div class="vote-page">
    <!-- Header Section -->
    <div class="hero-section bg-blue text-white py-5">
      <div class="container">
        <div class="row align-items-center">
          <div class="col-md-8">
            <h1 class="display-4 fw-bold mb-3">
              <i class="bi bi-star-fill me-3"></i>Vote for Projects
            </h1>
            <p class="lead mb-0">
              Discover and vote for amazing projects from all competitions
            </p>
            <p class="text-white-50 mt-2">
              {{ filteredProjects.length }} projects • {{ competitions.length }} competitions
            </p>
          </div>
          <div class="col-md-4 text-md-end">
            <div class="stats-box bg-white bg-opacity-10 rounded p-3">
              <div class="d-flex justify-content-around">
                <div class="text-center">
                  <h3 class="mb-0">{{ totalVotes }}</h3>
                  <small>Total Votes</small>
                </div>
                <div class="text-center">
                  <h3 class="mb-0">{{ totalComments }}</h3>
                  <small>Comments</small>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Advanced Filters -->
    <div class="bg-light border-bottom sticky-top" style="top: 0; z-index: 1000;">
      <div class="container py-3">
        <div class="row g-3 align-items-center">
          <!-- Search Bar -->
          <div class="col-lg-4">
            <div class="input-group">
              <span class="input-group-text bg-white">
                <i class="bi bi-search"></i>
              </span>
              <input
                type="text"
                class="form-control"
                v-model="searchQuery"
                placeholder="Search projects..."
                @input="handleSearch">
            </div>
          </div>

          <!-- Competition Filter -->
          <div class="col-lg-3">
            <select class="form-select" v-model="filterCompetition" @change="handleFilter">
              <option value="">All Competitions</option>
              <option v-for="comp in competitions" :key="comp.id" :value="comp.id">
                {{ comp.title }}
              </option>
            </select>
          </div>

          <!-- Sort & Rank Options -->
          <div class="col-lg-3">
            <select class="form-select" v-model="sortBy" @change="handleSort">
              <option value="rank">Highest Ranked</option>
              <option value="most-voted">Most Voted</option>
              <option value="most-commented">Most Commented</option>
              <option value="newest">Newest First</option>
              <option value="alphabetical">A to Z</option>
            </select>
          </div>

          <!-- View Toggle -->
          <div class="col-lg-2">
            <div class="btn-group w-100" role="group">
              <button
                type="button"
                class="btn btn-outline-secondary"
                :class="{ active: viewMode === 'grid' }"
                @click="viewMode = 'grid'">
                <i class="bi bi-grid-3x3-gap"></i>
              </button>
              <button
                type="button"
                class="btn btn-outline-secondary"
                :class="{ active: viewMode === 'list' }"
                @click="viewMode = 'list'">
                <i class="bi bi-list-ul"></i>
              </button>
            </div>
          </div>
        </div>

        <!-- Active Filters -->
        <div v-if="hasActiveFilters" class="mt-3 d-flex flex-wrap gap-2">
          <span v-if="searchQuery" class="badge bg-primary">
            Search: "{{ searchQuery }}"
            <i class="bi bi-x-circle ms-2" style="cursor: pointer;" @click="searchQuery = ''"></i>
          </span>
          <span v-if="filterCompetition" class="badge bg-info">
            {{ getCompetitionName(filterCompetition) }}
            <i class="bi bi-x-circle ms-2" style="cursor: pointer;" @click="filterCompetition = ''"></i>
          </span>
          <button 
            v-if="hasActiveFilters"
            class="btn btn-sm btn-outline-secondary"
            @click="clearAllFilters">
            Clear All
          </button>
        </div>
      </div>
    </div>

    <!-- Projects Content -->
    <div class="container my-5">
      <!-- Loading State -->
      <div v-if="isLoading" class="text-center py-5">
        <div class="spinner-border text-primary" role="status">
          <span class="visually-hidden">Loading...</span>
        </div>
        <p class="text-muted mt-3">Loading all projects...</p>
      </div>

      <!-- No Results -->
      <div v-else-if="filteredProjects.length === 0" class="text-center py-5">
        <i class="bi bi-inbox text-muted" style="font-size: 4rem;"></i>
        <h3 class="mt-3">No Projects Found</h3>
        <p class="text-muted">
          {{ searchQuery || filterCompetition ? 'Try adjusting your filters' : 'No projects available to vote on' }}
        </p>
        <button 
          v-if="hasActiveFilters" 
          class="btn btn-primary"
          @click="clearAllFilters">
          Clear All Filters
        </button>
      </div>

      <!-- Grid View -->
      <div v-else-if="viewMode === 'grid'" class="row g-4">
        <div 
          v-for="project in paginatedProjects" 
          :key="project.id" 
          class="col-md-6 col-lg-4">
          <ProjectCard :project="project" @vote="handleVote" @comment="handleComment" />
        </div>
      </div>

      <!-- List View -->
      <div v-else class="row g-4">
        <div 
          v-for="project in paginatedProjects" 
          :key="project.id" 
          class="col-12">
          <ProjectListItem :project="project" @vote="handleVote" @comment="handleComment" />
        </div>
      </div>

      <!-- Pagination -->
      <div v-if="totalPages > 1" class="d-flex justify-content-center mt-5">
        <nav>
          <ul class="pagination">
            <li class="page-item" :class="{ disabled: currentPage === 1 }">
              <a class="page-link" href="#" @click.prevent="changePage(currentPage - 1)">
                <i class="bi bi-chevron-left"></i>
              </a>
            </li>
            <li 
              v-for="page in visiblePages" 
              :key="page"
              class="page-item"
              :class="{ active: page === currentPage }">
              <a class="page-link" href="#" @click.prevent="changePage(page)">
                {{ page }}
              </a>
            </li>
            <li class="page-item" :class="{ disabled: currentPage === totalPages }">
              <a class="page-link" href="#" @click.prevent="changePage(currentPage + 1)">
                <i class="bi bi-chevron-right"></i>
              </a>
            </li>
          </ul>
        </nav>
      </div>

      <!-- Results Info -->
      <div v-if="filteredProjects.length > 0" class="text-center text-muted mt-4">
        Showing {{ startIndex + 1 }}-{{ Math.min(endIndex, filteredProjects.length) }} of {{ filteredProjects.length }} projects
      </div>
    </div>

    <!-- Quick Stats Section -->
    <div class="bg-light py-5">
      <div class="container">
        <h3 class="text-center mb-4">Top Voted Projects</h3>
        <div class="row g-3">
          <div 
            v-for="(project, index) in topVotedProjects" 
            :key="project.id"
            class="col-md-4">
            <div class="card h-100 border-primary">
              <div class="card-body">
                <div class="d-flex align-items-start">
                  <div class="rank-badge me-3">
                    <span class="badge bg-primary rounded-circle" style="width: 40px; height: 40px; display: flex; align-items: center; justify-content: center; font-size: 1.2rem;">
                      {{ index + 1 }}
                    </span>
                  </div>
                  <div class="flex-grow-1">
                    <h6 class="card-title mb-1">{{ project.projectName }}</h6>
                    <small class="text-muted">{{ getCompetitionName(project.competitionId) }}</small>
                    <div class="mt-2">
                      <span class="badge bg-danger me-2">
                        <i class="bi bi-heart-fill"></i> {{ project.votes }}
                      </span>
                      <span class="badge bg-primary">
                        <i class="bi bi-chat-fill"></i> {{ project.comments.length }}
                      </span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Comment Modal -->
    <div 
      class="modal fade" 
      id="commentModal" 
      tabindex="-1" 
      ref="commentModal">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Add Comment</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body">
            <textarea 
              class="form-control" 
              rows="4"
              v-model="newComment"
              placeholder="Share your thoughts about this project..."></textarea>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
            <button type="button" class="btn btn-primary" @click="submitComment">
              <i class="bi bi-send-fill me-2"></i>Post Comment
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import ProjectCard from '../../components/ProjectCard.vue'
import ProjectListItem from '../../components/ProjectListItem.vue'

export default {
  name: 'Vote',
  components: {
    ProjectCard,
    ProjectListItem
  },
  data() {
    return {
      competitions: [],
      projects: [],
      filteredProjects: [],
      searchQuery: '',
      filterCompetition: '',
      sortBy: 'rank',
      viewMode: 'grid',
      currentPage: 1,
      itemsPerPage: 12,
      isLoading: true,
      newComment: '',
      selectedProjectId: null
    }
  },
  computed: {
    totalVotes() {
      return this.projects.reduce((sum, p) => sum + p.votes, 0)
    },
    totalComments() {
      return this.projects.reduce((sum, p) => sum + p.comments.length, 0)
    },
    topVotedProjects() {
      return [...this.projects]
        .sort((a, b) => b.votes - a.votes)
        .slice(0, 3)
    },
    hasActiveFilters() {
      return this.searchQuery || this.filterCompetition
    },
    totalPages() {
      return Math.ceil(this.filteredProjects.length / this.itemsPerPage)
    },
    startIndex() {
      return (this.currentPage - 1) * this.itemsPerPage
    },
    endIndex() {
      return this.startIndex + this.itemsPerPage
    },
    paginatedProjects() {
      return this.filteredProjects.slice(this.startIndex, this.endIndex)
    },
    visiblePages() {
      const pages = []
      const maxVisible = 5
      let start = Math.max(1, this.currentPage - Math.floor(maxVisible / 2))
      let end = Math.min(this.totalPages, start + maxVisible - 1)
      
      if (end - start < maxVisible - 1) {
        start = Math.max(1, end - maxVisible + 1)
      }
      
      for (let i = start; i <= end; i++) {
        pages.push(i)
      }
      
      return pages
    }
  },
  methods: {
    async loadCompetitions() {
      try {
        const response = await fetch('/src/data/competitions.json')
        const data = await response.json()
        this.competitions = data.competitions
      } catch (error) {
        console.error('Error loading competitions:', error)
      }
    },
    async loadProjects() {
      this.isLoading = true
      try {
        const response = await fetch('/src/data/projects.json')
        const data = await response.json()
        
        // Load ALL projects (no competition filter)
        this.projects = data.projects
        this.filteredProjects = [...this.projects]
        
        // Apply initial sort
        this.handleSort()
      } catch (error) {
        console.error('Error loading projects:', error)
      } finally {
        this.isLoading = false
      }
    },
    getCompetitionName(competitionId) {
      const competition = this.competitions.find(c => c.id === parseInt(competitionId))
      return competition ? competition.title : 'Unknown'
    },
    handleSearch() {
      this.applyFilters()
    },
    handleFilter() {
      this.applyFilters()
    },
    applyFilters() {
      let filtered = [...this.projects]
      
      // Apply competition filter
      if (this.filterCompetition) {
        filtered = filtered.filter(p => p.competitionId === parseInt(this.filterCompetition))
      }
      
      // Apply search filter
      if (this.searchQuery) {
        const query = this.searchQuery.toLowerCase().trim()
        filtered = filtered.filter(project => {
          const nameMatch = project.projectName.toLowerCase().includes(query)
          const pitchMatch = project.elevatorPitch.toLowerCase().includes(query)
          const storyMatch = project.aboutProject.toLowerCase().includes(query)
          const tagsMatch = project.tags.some(tag => tag.toLowerCase().includes(query))
          const techMatch = project.builtWith?.toLowerCase().includes(query)
          const teamMatch = project.team.some(member => member.name.toLowerCase().includes(query))
          
          return nameMatch || pitchMatch || storyMatch || tagsMatch || techMatch || teamMatch
        })
      }
      
      this.filteredProjects = filtered
      this.currentPage = 1
      this.handleSort()
    },
    handleSort() {
      switch (this.sortBy) {
        case 'rank':
        case 'most-voted':
          this.filteredProjects.sort((a, b) => b.votes - a.votes)
          break
        case 'most-commented':
          this.filteredProjects.sort((a, b) => b.comments.length - a.comments.length)
          break
        case 'newest':
          this.filteredProjects.sort((a, b) => 
            new Date(b.dates.submitted) - new Date(a.dates.submitted)
          )
          break
        case 'alphabetical':
          this.filteredProjects.sort((a, b) => 
            a.projectName.localeCompare(b.projectName)
          )
          break
      }
    },
    clearAllFilters() {
      this.searchQuery = ''
      this.filterCompetition = ''
      this.applyFilters()
    },
    changePage(page) {
      if (page >= 1 && page <= this.totalPages) {
        this.currentPage = page
        window.scrollTo({ top: 0, behavior: 'smooth' })
      }
    },
    handleVote(projectId) {
      const project = this.projects.find(p => p.id === projectId)
      if (project) {
        project.votes++
        
        if (this.sortBy === 'rank' || this.sortBy === 'most-voted') {
          this.handleSort()
        }
      }
    },
    handleComment(projectId) {
      this.selectedProjectId = projectId
      this.newComment = ''
      
      const modal = new bootstrap.Modal(this.$refs.commentModal)
      modal.show()
    },
    submitComment() {
      if (!this.newComment.trim()) return
      
      const project = this.projects.find(p => p.id === this.selectedProjectId)
      if (project) {
        const comment = {
          id: project.comments.length + 1,
          userId: 999,
          userName: 'Current User',
          avatar: 'https://i.pravatar.cc/150?img=50',
          comment: this.newComment,
          timestamp: new Date().toISOString(),
          likes: 0
        }
        
        project.comments.push(comment)
        
        if (this.sortBy === 'most-commented') {
          this.handleSort()
        }
        
        const modal = bootstrap.Modal.getInstance(this.$refs.commentModal)
        modal.hide()
        
        this.newComment = ''
        this.selectedProjectId = null
      }
    }
  },
  mounted() {
    this.loadCompetitions()
    this.loadProjects()
  }
}
</script>

<style scoped>
.vote-page {
  min-height: 100vh;
  background-color: #f8f9fa;
}

.hero-section {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.stats-box {
  backdrop-filter: blur(10px);
}

.sticky-top {
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.input-group-text {
  border-right: none;
}

.input-group .form-control {
  border-left: none;
}

.input-group .form-control:focus {
  border-left: none;
  box-shadow: none;
}

.btn-group .btn.active {
  background-color: #0d6efd;
  color: white;
  border-color: #0d6efd;
}

.badge i {
  cursor: pointer;
}

.badge i:hover {
  opacity: 0.7;
}

.rank-badge {
  flex-shrink: 0;
}

/* Animations */
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.col-md-6,
.col-lg-4,
.col-12 {
  animation: fadeIn 0.5s ease-out;
}

/* Responsive */
@media (max-width: 768px) {
  .hero-section h1 {
    font-size: 2rem;
  }
  
  .stats-box {
    margin-top: 1rem;
  }
}
</style>