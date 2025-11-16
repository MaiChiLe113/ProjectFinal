<template>
  <div class="projects-page">
    <!-- Header Section -->
    <div class="hero-section bg-primary text-white py-5">
      <div class="container">
        <div class="row align-items-center">
          <div class="col-md-8">
            <nav aria-label="breadcrumb">
              <ol class="breadcrumb text-white-50 mb-3">
                <li class="breadcrumb-item">
                  <router-link to="/competitions" class="text-white">Competitions</router-link>
                </li>
                <li class="breadcrumb-item">
                  <router-link :to="`/competitions/${competitionId}`" class="text-white">
                    {{ competition?.title }}
                  </router-link>
                </li>
                <li class="breadcrumb-item active text-white" aria-current="page">Projects</li>
              </ol>
            </nav>
            <h1 class="display-5 fw-bold mb-3">Competition Projects</h1>
            <p class="lead mb-0" v-if="competition">
              {{ filteredProjects.length }} project{{ filteredProjects.length !== 1 ? 's' : '' }} submitted
            </p>
          </div>
          <div class="col-md-4 text-md-end">
            <router-link 
              :to="`/submit?competitionId=${competitionId}`" 
              class="btn btn-light btn-lg">
              <i class="bi bi-plus-circle me-2"></i>Submit Project
            </router-link>
          </div>
        </div>
      </div>
    </div>

    <!-- Filters and Controls -->
    <div class="bg-light border-bottom sticky-top" style="top: 0; z-index: 1000;">
      <div class="container py-3">
        <div class="row g-3 align-items-center">
          <!-- Search Bar -->
          <div class="col-md-6">
            <div class="input-group">
              <span class="input-group-text bg-white">
                <i class="bi bi-search"></i>
              </span>
              <input
                type="text"
                class="form-control"
                v-model="searchQuery"
                placeholder="Search projects by name, description, or tags..."
                @input="handleSearch">
            </div>
          </div>

          <!-- Sort Dropdown -->
          <div class="col-md-3">
            <select class="form-select" v-model="sortBy" @change="handleSort">
              <option value="newest">Newest First</option>
              <option value="oldest">Oldest First</option>
              <option value="most-voted">Most Voted</option>
              <option value="most-commented">Most Commented</option>
              <option value="alphabetical">A to Z</option>
            </select>
          </div>

          <!-- View Toggle -->
          <div class="col-md-3">
            <div class="btn-group w-100" role="group">
              <button
                type="button"
                class="btn btn-outline-secondary"
                :class="{ active: viewMode === 'grid' }"
                @click="viewMode = 'grid'">
                <i class="bi bi-grid-3x3-gap"></i> Grid
              </button>
              <button
                type="button"
                class="btn btn-outline-secondary"
                :class="{ active: viewMode === 'list' }"
                @click="viewMode = 'list'">
                <i class="bi bi-list-ul"></i> List
              </button>
            </div>
          </div>
        </div>

        <!-- Active Filters -->
        <div v-if="searchQuery" class="mt-3">
          <span class="badge bg-primary me-2">
            Search: "{{ searchQuery }}"
            <i class="bi bi-x-circle ms-2" style="cursor: pointer;" @click="searchQuery = ''"></i>
          </span>
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
        <p class="text-muted mt-3">Loading projects...</p>
      </div>

      <!-- No Results -->
      <div v-else-if="filteredProjects.length === 0" class="text-center py-5">
        <i class="bi bi-folder-x text-muted" style="font-size: 4rem;"></i>
        <h3 class="mt-3">No Projects Found</h3>
        <p class="text-muted">
          {{ searchQuery ? 'Try adjusting your search criteria' : 'No projects have been submitted yet' }}
        </p>
        <button 
          v-if="searchQuery" 
          class="btn btn-primary"
          @click="searchQuery = ''">
          Clear Search
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
  name: 'Projects',
  components: {
    ProjectCard,
    ProjectListItem
  },
  data() {
    return {
      competition: null,
      projects: [],
      filteredProjects: [],
      searchQuery: '',
      sortBy: 'newest',
      viewMode: 'grid', // 'grid' or 'list'
      currentPage: 1,
      itemsPerPage: 9,
      isLoading: true,
      newComment: '',
      selectedProjectId: null
    }
  },
  computed: {
    competitionId() {
      return parseInt(this.$route.params.id)
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
    async loadCompetition() {
      try {
        const response = await fetch('/src/data/competitions.json')
        const data = await response.json()
        this.competition = data.competitions.find(c => c.id === this.competitionId)
      } catch (error) {
        console.error('Error loading competition:', error)
      }
    },
    async loadProjects() {
      this.isLoading = true
      try {
        const response = await fetch('/src/data/projects.json')
        const data = await response.json()
        
        // Filter projects by competition ID
        this.projects = data.projects.filter(p => p.competitionId === this.competitionId)
        this.filteredProjects = [...this.projects]
        
        // Apply initial sort
        this.handleSort()
      } catch (error) {
        console.error('Error loading projects:', error)
      } finally {
        this.isLoading = false
      }
    },
    handleSearch() {
      const query = this.searchQuery.toLowerCase().trim()
      
      if (!query) {
        this.filteredProjects = [...this.projects]
      } else {
        this.filteredProjects = this.projects.filter(project => {
          // Search in project name
          const nameMatch = project.projectName.toLowerCase().includes(query)
          
          // Search in elevator pitch
          const pitchMatch = project.elevatorPitch.toLowerCase().includes(query)
          
          // Search in project story
          const storyMatch = project.aboutProject.toLowerCase().includes(query)
          
          // Search in tags
          const tagsMatch = project.tags.some(tag => 
            tag.toLowerCase().includes(query)
          )
          
          // Search in technologies
          const techMatch = project.builtWith?.toLowerCase().includes(query)
          
          // Search in team member names
          const teamMatch = project.team.some(member => 
            member.name.toLowerCase().includes(query)
          )
          
          return nameMatch || pitchMatch || storyMatch || tagsMatch || techMatch || teamMatch
        })
      }
      
      // Reset to first page after search
      this.currentPage = 1
      
      // Reapply sort
      this.handleSort()
    },
    handleSort() {
      switch (this.sortBy) {
        case 'newest':
          this.filteredProjects.sort((a, b) => 
            new Date(b.dates.submitted) - new Date(a.dates.submitted)
          )
          break
        case 'oldest':
          this.filteredProjects.sort((a, b) => 
            new Date(a.dates.submitted) - new Date(b.dates.submitted)
          )
          break
        case 'most-voted':
          this.filteredProjects.sort((a, b) => b.votes - a.votes)
          break
        case 'most-commented':
          this.filteredProjects.sort((a, b) => 
            b.comments.length - a.comments.length
          )
          break
        case 'alphabetical':
          this.filteredProjects.sort((a, b) => 
            a.projectName.localeCompare(b.projectName)
          )
          break
      }
    },
    changePage(page) {
      if (page >= 1 && page <= this.totalPages) {
        this.currentPage = page
        // Scroll to top
        window.scrollTo({ top: 0, behavior: 'smooth' })
      }
    },
    handleVote(projectId) {
      const project = this.projects.find(p => p.id === projectId)
      if (project) {
        // Toggle vote (in real app, this would be an API call)
        project.votes++
        
        // If sorted by votes, re-sort
        if (this.sortBy === 'most-voted') {
          this.handleSort()
        }
      }
    },
    handleComment(projectId) {
      this.selectedProjectId = projectId
      this.newComment = ''
      
      // Show modal (using Bootstrap modal)
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
        
        // If sorted by comments, re-sort
        if (this.sortBy === 'most-commented') {
          this.handleSort()
        }
        
        // Close modal
        const modal = bootstrap.Modal.getInstance(this.$refs.commentModal)
        modal.hide()
        
        // Reset form
        this.newComment = ''
        this.selectedProjectId = null
      }
    }
  },
  mounted() {
    this.loadCompetition()
    this.loadProjects()
  },
  watch: {
    competitionId() {
      this.loadCompetition()
      this.loadProjects()
    }
  }
}
</script>

<style scoped>
.projects-page {
  min-height: 100vh;
  background-color: #f8f9fa;
}

.hero-section {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.breadcrumb-item + .breadcrumb-item::before {
  color: rgba(255, 255, 255, 0.5);
}

.breadcrumb-item a {
  text-decoration: none;
}

.breadcrumb-item a:hover {
  text-decoration: underline;
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

.pagination {
  margin-bottom: 0;
}

.page-link {
  color: #0d6efd;
  transition: all 0.3s ease;
}

.page-link:hover {
  background-color: #e7f1ff;
  border-color: #0d6efd;
}

.page-item.active .page-link {
  background-color: #0d6efd;
  border-color: #0d6efd;
}

.badge i {
  cursor: pointer;
}

.badge i:hover {
  opacity: 0.7;
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
  
  .hero-section .lead {
    font-size: 1rem;
  }
}
</style>