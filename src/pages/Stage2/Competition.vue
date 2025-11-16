<template>
  <div class="competition-page">
    <div class="container">
      <!-- Title and View Toggle -->
      <div class="row mb-4 align-items-center">
        <div class="position-relative overflow-hidden p-3 p-md-5 m-md-3 text-center bg-body-tertiary">
          <div class="col-md-6 p-lg-5 mx-auto my-5">
            <h1 class="display-3 fw-bold">Browse Competitions</h1>
            <h3 class="fw-normal text-muted mb-3">
              Discover exciting competitions and join the challenge
            </h3>
          </div>
        </div>
        <div class="col-12 col-md-6">
          <div class="competition-page__view-toggle">
            <button
              @click="viewMode='card'"
              :class="['btn', 'competition-page__view-btn', { 'active': viewMode === 'card' }]"
              title="Card View"
            >
              <i class="bi bi-grid-3x3-gap-fill"></i> Card View
            </button>
            <button
              @click="viewMode='line'"
              :class="['btn', 'competition-page__view-btn', { 'active': viewMode === 'line' }]"
              title="Line View"
            >
              <i class="bi bi-list-ul"></i> Line View
            </button>
          </div>
        </div>
      </div>

      <!-- Filter Controls -->
      <div class="row mb-4">
        <!-- Search Input -->
        <div class="col-12 mb-3">
          <label class="form-label fw-bold">
            <i class="bi bi-search me-1"></i>Search Competitions
          </label>
          <input
            v-model="filters.title"
            type="text"
            class="form-control form-control-lg"
            placeholder="Search by title or description..."
          />
        </div>
      </div>

      <div class="row mb-3">
        <!-- Category Filters -->
        <div class="col-12 col-md-6 col-lg-3 mb-3">
          <label class="form-label fw-bold">
            <i class="bi bi-tag me-1"></i>Category
          </label>
          <div class="filter-box p-3 bg-light rounded">
            <div class="form-check mb-2">
              <input 
                class="form-check-input" 
                type="checkbox" 
                id="category-all"
                :checked="filters.categories.length === 0"
                @change="clearCategoryFilter">
              <label class="form-check-label" for="category-all">
                All Categories
              </label>
            </div>
            <hr class="my-2">
            <div 
              v-for="category in categories" 
              :key="category" 
              class="form-check mb-2">
              <input 
                class="form-check-input" 
                type="checkbox" 
                :id="'category-' + category"
                :value="category"
                v-model="filters.categories">
              <label class="form-check-label" :for="'category-' + category">
                {{ category }}
              </label>
            </div>
          </div>
        </div>

        <!-- Status Filters -->
        <div class="col-12 col-md-6 col-lg-3 mb-3">
          <label class="form-label fw-bold">
            <i class="bi bi-circle-fill me-1"></i>Status
          </label>
          <div class="filter-box p-3 bg-light rounded">
            <div class="form-check mb-2">
              <input 
                class="form-check-input" 
                type="checkbox" 
                id="status-all"
                :checked="filters.statuses.length === 0"
                @change="clearStatusFilter">
              <label class="form-check-label" for="status-all">
                All Status
              </label>
            </div>
            <hr class="my-2">
            <div class="form-check mb-2">
              <input 
                class="form-check-input" 
                type="checkbox" 
                id="status-upcoming"
                value="upcoming"
                v-model="filters.statuses">
              <label class="form-check-label" for="status-upcoming">
                <span class="badge bg-info me-2">●</span>Upcoming
              </label>
            </div>
            <div class="form-check mb-2">
              <input 
                class="form-check-input" 
                type="checkbox" 
                id="status-ongoing"
                value="ongoing"
                v-model="filters.statuses">
              <label class="form-check-label" for="status-ongoing">
                <span class="badge bg-success me-2">●</span>Ongoing
              </label>
            </div>
            <div class="form-check mb-2">
              <input 
                class="form-check-input" 
                type="checkbox" 
                id="status-completed"
                value="completed"
                v-model="filters.statuses">
              <label class="form-check-label" for="status-completed">
                <span class="badge bg-secondary me-2">●</span>Completed
              </label>
            </div>
          </div>
        </div>

        <!-- Location Filters -->
        <div class="col-12 col-md-6 col-lg-3 mb-3">
          <label class="form-label fw-bold">
            <i class="bi bi-geo-alt me-1"></i>Location
          </label>
          <div class="filter-box p-3 bg-light rounded">
            <div class="form-check mb-2">
              <input 
                class="form-check-input" 
                type="checkbox" 
                id="location-all"
                :checked="filters.locations.length === 0"
                @change="clearLocationFilter">
              <label class="form-check-label" for="location-all">
                All Locations
              </label>
            </div>
            <hr class="my-2">
            <div 
              v-for="location in locations" 
              :key="location" 
              class="form-check mb-2">
              <input 
                class="form-check-input" 
                type="checkbox" 
                :id="'location-' + location"
                :value="location"
                v-model="filters.locations">
              <label class="form-check-label" :for="'location-' + location">
                {{ location }}
              </label>
            </div>
          </div>
        </div>

        <!-- Organizer Type Filters -->
        <div class="col-12 col-md-6 col-lg-3 mb-3">
          <label class="form-label fw-bold">
            <i class="bi bi-building me-1"></i>Organizer Type
          </label>
          <div class="filter-box p-3 bg-light rounded">
            <div class="form-check mb-2">
              <input 
                class="form-check-input" 
                type="checkbox" 
                id="organizer-all"
                :checked="filters.organizerTypes.length === 0"
                @change="clearOrganizerFilter">
              <label class="form-check-label" for="organizer-all">
                All Organizers
              </label>
            </div>
            <hr class="my-2">
            <div class="form-check mb-2">
              <input 
                class="form-check-input" 
                type="checkbox" 
                id="organizer-staff"
                value="staff"
                v-model="filters.organizerTypes">
              <label class="form-check-label" for="organizer-staff">
                <i class="bi bi-mortarboard me-2"></i>Faculty
              </label>
            </div>
            <div class="form-check mb-2">
              <input 
                class="form-check-input" 
                type="checkbox" 
                id="organizer-clubs"
                value="clubs"
                v-model="filters.organizerTypes">
              <label class="form-check-label" for="organizer-clubs">
                <i class="bi bi-people me-2"></i>Clubs
              </label>
            </div>
            <div class="form-check mb-2">
              <input 
                class="form-check-input" 
                type="checkbox" 
                id="organizer-individual"
                value="individual"
                v-model="filters.organizerTypes">
              <label class="form-check-label" for="organizer-individual">
                <i class="bi bi-person me-2"></i>Individuals
              </label>
            </div>
          </div>
        </div>
      </div>

      <!-- Clear All Filters Button -->
      <div v-if="hasActiveFilters" class="row mb-3">
        <div class="col-12 text-end">
          <button
            @click="clearAllFilters"
            class="btn btn-outline-danger">
            <i class="bi bi-x-circle me-2"></i>Clear All Filters
          </button>
        </div>
      </div>

      <!-- Active Filters Chips -->
      <div v-if="hasActiveFilters" class="row mb-3">
        <div class="col-12">
          <div class="competition-page__filter-chips">
            <span class="competition-page__filter-label">
              <i class="bi bi-funnel-fill me-2"></i>Active Filters:
            </span>
            <div class="competition-page__chip-container">
              <!-- Title Filter Chip -->
              <div v-if="filters.title" class="competition-page__chip">
                <span class="competition-page__chip-type">Search:</span>
                <span class="competition-page__chip-value">{{ filters.title }}</span>
                <button
                  @click="filters.title = ''"
                  class="competition-page__chip-remove"
                  aria-label="Remove search filter">
                  <i class="bi bi-x"></i>
                </button>
              </div>

              <!-- Category Filter Chips -->
              <div 
                v-for="category in filters.categories" 
                :key="'cat-' + category" 
                class="competition-page__chip">
                <span class="competition-page__chip-type">Category:</span>
                <span class="competition-page__chip-value">{{ category }}</span>
                <button
                  @click="removeCategory(category)"
                  class="competition-page__chip-remove"
                  aria-label="Remove category filter">
                  <i class="bi bi-x"></i>
                </button>
              </div>

              <!-- Status Filter Chips -->
              <div 
                v-for="status in filters.statuses" 
                :key="'status-' + status" 
                class="competition-page__chip">
                <span class="competition-page__chip-type">Status:</span>
                <span class="competition-page__chip-value">{{ status }}</span>
                <button
                  @click="removeStatus(status)"
                  class="competition-page__chip-remove"
                  aria-label="Remove status filter">
                  <i class="bi bi-x"></i>
                </button>
              </div>

              <!-- Location Filter Chips -->
              <div 
                v-for="location in filters.locations" 
                :key="'loc-' + location" 
                class="competition-page__chip">
                <span class="competition-page__chip-type">Location:</span>
                <span class="competition-page__chip-value">{{ location }}</span>
                <button
                  @click="removeLocation(location)"
                  class="competition-page__chip-remove"
                  aria-label="Remove location filter">
                  <i class="bi bi-x"></i>
                </button>
              </div>

              <!-- Organizer Type Filter Chips -->
              <div 
                v-for="orgType in filters.organizerTypes" 
                :key="'org-' + orgType" 
                class="competition-page__chip">
                <span class="competition-page__chip-type">Organizer:</span>
                <span class="competition-page__chip-value">{{ orgType }}</span>
                <button
                  @click="removeOrganizerType(orgType)"
                  class="competition-page__chip-remove"
                  aria-label="Remove organizer filter">
                  <i class="bi bi-x"></i>
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Item Count and Items Per Page -->
      <div class="row mb-3 align-items-center">
        <div class="col-12 col-md-6 mb-2 mb-md-0">
          <p class="competition-page__count mb-0">
            <em v-if="filteredCompetitions.length === 0">No competitions found</em>
            <span v-else>
              Total: <strong>{{ filteredCompetitions.length }}</strong> Competition(s)
              <span v-if="filteredCompetitions.length !== competitions.length">
                (filtered from {{ competitions.length }})
              </span>
            </span>
          </p>
        </div>
        <div class="col-12 col-md-6 text-md-end">
          <label class="competition-page__items-per-page">
            Competitions per page:
            <select v-model.number="perPage" class="form-select form-select-sm d-inline-block w-auto ms-2">
              <option :value="6">6</option>
              <option :value="9">9</option>
              <option :value="12">12</option>
              <option :value="20">20</option>
            </select>
          </label>
        </div>
      </div>

      <!-- Loading State -->
      <div v-if="loading" class="row">
        <div class="col-12 text-center py-5">
          <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Loading...</span>
          </div>
          <p class="mt-3 text-muted">Loading competitions...</p>
        </div>
      </div>

      <!-- Error State -->
      <div v-else-if="error" class="row">
        <div class="col-12">
          <div class="alert alert-danger" role="alert">
            <i class="bi bi-exclamation-circle-fill me-2"></i>
            {{ error }}
            <button @click="loadCompetitions" class="btn btn-sm btn-outline-danger ms-3">
              <i class="bi bi-arrow-clockwise me-1"></i>
              Retry
            </button>
          </div>
        </div>
      </div>

      <!-- Card View -->
      <div v-else-if="viewMode === 'card'" class="row">
        <div v-if="paginatedCompetitions.length === 0" class="col-12">
          <div class="competition-page__no-results-card">
            <i class="bi bi-search"></i>
            <p>No competitions found matching your search.</p>
            <button @click="clearAllFilters" class="btn btn-primary mt-3">
              <i class="bi bi-arrow-counterclockwise me-2"></i>Clear Filters
            </button>
          </div>
        </div>
        <div
          v-for="competition in paginatedCompetitions"
          :key="competition.id"
          class="col-12 col-md-6 col-lg-4 mb-4"
        >
          <CompetitionCard :competition="competition" />
        </div>
      </div>

      <!-- Line View (Table) -->
      <div v-else class="row">
        <div class="col-12">
          <div class="table-responsive">
            <table class="table table-hover competition-page__table">
              <thead class="competition-page__table-head">
                <tr>
                  <th scope="col">Title</th>
                  <th scope="col">Category</th>
                  <th scope="col">Organizer</th>
                  <th scope="col">Location</th>
                  <th scope="col">Start Date</th>
                  <th scope="col">Status</th>
                  <th scope="col">Participants</th>
                </tr>
              </thead>
              <tbody class="competition-page__table-body">
                <tr v-if="paginatedCompetitions.length === 0">
                  <td colspan="7" class="text-center competition-page__no-results">
                    No competitions found matching your search.
                  </td>
                </tr>
                <tr 
                  v-for="competition in paginatedCompetitions" 
                  :key="competition.id" 
                  class="competition-page__table-row"
                  @click="navigateToDetail(competition.id)"
                  style="cursor: pointer;">
                  <td class="competition-page__table-title">
                    <strong>{{ competition.title }}</strong>
                  </td>
                  <td class="competition-page__table-category">
                    <span class="badge bg-primary">{{ competition.category }}</span>
                  </td>
                  <td class="competition-page__table-organizer">
                    {{ competition.organizer?.name || competition.organizer_name || 'Unknown' }}
                  </td>
                  <td class="competition-page__table-location">
                    <i :class="getLocationIcon(competition.location?.type || competition.location_type)" class="me-1"></i>
                    {{ competition.participants || competition.location || 'All campuses' }}
                  </td>
                  <td class="competition-page__table-date">
                    {{ formatDate(competition.dates?.start || competition.start_date) }}
                  </td>
                  <td class="competition-page__table-status">
                    <span
                      class="badge"
                      :class="getStatusClass(competition.status)">
                      {{ competition.status }}
                    </span>
                  </td>
                  <td class="competition-page__table-participants">
                    {{ competition.capacity?.current ?? competition.current_participants ?? 0 }}/{{ competition.capacity?.max ?? competition.max_participants ?? 100 }}
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>

      <!-- Pagination Controls -->
      <div v-if="totalPages > 1" class="row mt-4">
        <div class="col-12">
          <nav aria-label="Competition pagination">
            <ul class="pagination justify-content-center">
              <li class="page-item" :class="{ disabled: currentPage === 1 }">
                <a class="page-link" @click.prevent="changePage(currentPage - 1)" href="#">
                  Previous
                </a>
              </li>
              <li 
                v-for="page in visiblePages" 
                :key="page" 
                class="page-item" 
                :class="{ active: currentPage === page }">
                <a class="page-link" @click.prevent="changePage(page)" href="#">
                  {{ page }}
                </a>
              </li>
              <li class="page-item" :class="{ disabled: currentPage === totalPages }">
                <a class="page-link" @click.prevent="changePage(currentPage + 1)" href="#">
                  Next
                </a>
              </li>
            </ul>
          </nav>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import CompetitionCard from '../../components/CompetitionCard.vue'

export default {
  name: 'Competition',
  components: {
    CompetitionCard
  },
  data() {
    return {
      competitions: [],
      filters: {
        title: '',
        categories: [],
        statuses: [],
        locations: [],
        organizerTypes: []
      },
      currentPage: 1,
      perPage: 9,
      viewMode: 'card',
      categories: [],
      locations: [],
      loading: false,
      error: null
    }
  },
  computed: {
    hasActiveFilters() {
      return this.filters.title || 
             this.filters.categories.length > 0 || 
             this.filters.statuses.length > 0 || 
             this.filters.locations.length > 0 ||
             this.filters.organizerTypes.length > 0
    },
    filteredCompetitions() {
      let items = this.competitions

      if (this.filters.title.trim()) {
        const query = this.filters.title.toLowerCase()
        items = items.filter(item =>
          item.title.toLowerCase().includes(query) ||
          item.description.toLowerCase().includes(query)
        )
      }

      if (this.filters.categories.length > 0) {
        items = items.filter(item => 
          this.filters.categories.includes(item.category)
        )
      }

      if (this.filters.statuses.length > 0) {
        items = items.filter(item => 
          this.filters.statuses.includes(item.status)
        )
      }

      if (this.filters.locations.length > 0) {
        items = items.filter(item =>
          this.filters.locations.includes(item.participants) ||
          this.filters.locations.includes(item.location) ||
          this.filters.locations.includes(item.location_type)
        )
      }

      if (this.filters.organizerTypes.length > 0) {
        items = items.filter(item => {
          const orgType = item.organizer?.type || item.organizer_type
          return this.filters.organizerTypes.includes(orgType)
        })
      }

      return items
    },
    paginatedCompetitions() {
      const start = (this.currentPage - 1) * this.perPage
      const end = start + this.perPage
      return this.filteredCompetitions.slice(start, end)
      // return this.competitions;
    },
    totalPages() {
      return Math.ceil(this.filteredCompetitions.length / this.perPage)
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
    formatDate(dateString) {
      const options = { year: 'numeric', month: 'short', day: 'numeric' }
      return new Date(dateString).toLocaleDateString('en-US', options)
    },
    async loadCompetitions() {
      this.loading = true
      this.error = null

      try {
        // Fetch competitions from local JSON file
        const response = await fetch('/src/data/competitions.json')

        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`)
        }

        const data = await response.json()

        // Debug: Log the response structure
        console.log('Competitions Data:', data)

        // JSON file returns an object with competitions array
        if (data.competitions && Array.isArray(data.competitions)) {
          this.competitions = data.competitions
          console.log('First competition structure:', this.competitions[0])
        } else if (Array.isArray(data)) {
          // Fallback: handle if data is array directly
          this.competitions = data
          console.log('First competition structure:', this.competitions[0])
        } else {
          this.competitions = []
        }

        // Extract unique categories and locations
        this.categories = [...new Set(this.competitions.map(item => item.category))].filter(Boolean).sort()
        this.locations = [...new Set(this.competitions.map(item => item.participants || item.location))].filter(Boolean).sort()
      } catch (error) {
        console.error('Error loading competitions:', error)
        this.error = 'Failed to load competitions. Please try again later.'
        this.competitions = []
      } finally {
        this.loading = false
      }
    },
    clearAllFilters() {
      this.filters = {
        title: '',
        categories: [],
        statuses: [],
        locations: [],
        organizerTypes: []
      }
      this.currentPage = 1
    },
    clearCategoryFilter() {
      this.filters.categories = []
    },
    clearStatusFilter() {
      this.filters.statuses = []
    },
    clearLocationFilter() {
      this.filters.locations = []
    },
    clearOrganizerFilter() {
      this.filters.organizerTypes = []
    },
    removeCategory(category) {
      this.filters.categories = this.filters.categories.filter(c => c !== category)
    },
    removeStatus(status) {
      this.filters.statuses = this.filters.statuses.filter(s => s !== status)
    },
    removeLocation(location) {
      this.filters.locations = this.filters.locations.filter(l => l !== location)
    },
    removeOrganizerType(orgType) {
      this.filters.organizerTypes = this.filters.organizerTypes.filter(o => o !== orgType)
    },
    changePage(pageNum) {
      if (pageNum >= 1 && pageNum <= this.totalPages) {
        this.currentPage = pageNum
        window.scrollTo({ top: 0, behavior: 'smooth' })
      }
    },
    getStatusClass(status) {
      const statusClasses = {
        'upcoming': 'bg-info',
        'ongoing': 'bg-success',
        'completed': 'bg-secondary'
      }
      return statusClasses[status] || 'bg-secondary'
    },
    getLocationIcon(locationType) {
      const icons = {
        'online': 'bi bi-laptop',
        'offline': 'bi bi-geo-alt-fill',
        'hybrid': 'bi bi-globe'
      }
      return icons[locationType] || 'bi bi-question-circle'
    },
    navigateToDetail(competitionId) {
      this.$router.push(`/competitions/${competitionId}`)
    }
  },
  watch: {
    'filters.title'() {
      this.currentPage = 1
    },
    'filters.categories'() {
      this.currentPage = 1
    },
    'filters.statuses'() {
      this.currentPage = 1
    },
    'filters.locations'() {
      this.currentPage = 1
    },
    'filters.organizerTypes'() {
      this.currentPage = 1
    },
    perPage() {
      this.currentPage = 1
    }
  },
  mounted() {
    this.loadCompetitions()
  }
}
</script>

<style scoped>
.competition-page__view-toggle {
  display: flex;
  gap: 0.5rem;
  justify-content: flex-end;
}

.competition-page__view-btn {
  border: 1px solid #dee2e6;
  background-color: white;
  color: #495057;
  transition: all 0.3s ease;
}

.competition-page__view-btn:hover {
  background-color: #f8f9fa;
  border-color: #0d6efd;
}

.competition-page__view-btn.active {
  background-color: #0d6efd;
  color: white;
  border-color: #0d6efd;
}

.filter-box {
  max-height: 250px;
  overflow-y: auto;
}

.filter-box::-webkit-scrollbar {
  width: 6px;
}

.filter-box::-webkit-scrollbar-thumb {
  background-color: #0d6efd;
  border-radius: 3px;
}

.form-check-input:checked {
  background-color: #0d6efd;
  border-color: #0d6efd;
}

.form-check-label {
  cursor: pointer;
  user-select: none;
}

.competition-page__filter-chips {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 0.5rem;
  padding: 1rem;
  background-color: #f8f9fa;
  border-radius: 0.375rem;
}

.competition-page__filter-label {
  font-weight: 600;
  color: #495057;
}

.competition-page__chip-container {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}

.competition-page__chip {
  display: inline-flex;
  align-items: center;
  gap: 0.25rem;
  padding: 0.375rem 0.75rem;
  background-color: #0d6efd;
  color: white;
  border-radius: 1rem;
  font-size: 0.875rem;
}

.competition-page__chip-type {
  font-weight: 600;
}

.competition-page__chip-value {
  max-width: 150px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.competition-page__chip-remove {
  background: none;
  border: none;
  color: white;
  padding: 0;
  margin-left: 0.25rem;
  cursor: pointer;
  font-size: 1rem;
  line-height: 1;
  transition: opacity 0.2s;
}

.competition-page__chip-remove:hover {
  opacity: 0.7;
}

.competition-page__count {
  font-size: 1rem;
  color: #495057;
}

.competition-page__items-per-page {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 0.875rem;
  color: #495057;
}

.competition-page__no-results-card {
  text-align: center;
  padding: 4rem 2rem;
  background-color: #f8f9fa;
  border-radius: 0.5rem;
  border: 2px dashed #dee2e6;
}

.competition-page__no-results-card i {
  font-size: 4rem;
  color: #adb5bd;
  margin-bottom: 1rem;
}

.competition-page__no-results-card p {
  font-size: 1.25rem;
  color: #6c757d;
  margin-bottom: 0;
}

.competition-page__table {
  background-color: white;
  border-radius: 0.5rem;
  overflow: hidden;
}

.competition-page__table-head {
  background-color: #f8f9fa;
  border-bottom: 2px solid #dee2e6;
}

.competition-page__table-head th {
  font-weight: 600;
  color: #495057;
  padding: 1rem;
  border-bottom: none;
}

.competition-page__table-body tr {
  transition: background-color 0.2s;
}

.competition-page__table-body tr:hover {
  background-color: #f8f9fa;
}

.competition-page__table-body td {
  padding: 1rem;
  vertical-align: middle;
}

.competition-page__table-title {
  font-weight: 500;
  color: #212529;
}

.competition-page__no-results {
  padding: 3rem;
  font-size: 1.125rem;
  color: #6c757d;
}

@media (max-width: 768px) {
  .competition-page__view-toggle {
    justify-content: center;
    margin-top: 1rem;
  }

  .competition-page__chip-value {
    max-width: 100px;
  }

  .competition-page__items-per-page {
    justify-content: center;
  }
}
</style>