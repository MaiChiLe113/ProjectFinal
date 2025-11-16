<template>
  <div class="news-page">
    <div class="container">
      <!-- Title and View Toggle -->
      <div class="row mb-4 align-items-center">
        <div class="position-relative overflow-hidden p-3 p-md-5 m-md-3 text-center bg-body-tertiary" bis_skin_checked="1"> <div class="col-md-6 p-lg-5 mx-auto my-5" bis_skin_checked="1"> <h1 class="display-3 fw-bold">Lateset SwinNews</h1> <h3 class="fw-normal text-muted mb-3">See updated news about winners, regulations,... abotu competition</h3> </div></div>
        <div class="col-12 col-md-6">
          <div class="news-page__view-toggle">
            <button
              @click="viewMode = 'card'"
              :class="['btn', 'news-page__view-btn', { 'active': viewMode === 'card' }]"
              title="Card View"
            >
              <i class="bi bi-grid-3x3-gap-fill"></i> Card View
            </button>
            <button
              @click="viewMode = 'line'"
              :class="['btn', 'news-page__view-btn', { 'active': viewMode === 'line' }]"
              title="Line View"
            >
              <i class="bi bi-list-ul"></i> Line View
            </button>
          </div>
        </div>
      </div>

      <!-- Filter Controls -->
      <div class="row mb-3">
        <div class="col-12 col-md-3 mb-3 mb-md-0">
          <label class="form-label fw-bold">
            <i class="bi bi-search me-1"></i>Title
          </label>
          <input
            v-model="filters.title"
            type="text"
            class="form-control"
            placeholder="Search by title..."
          />
        </div>
        <div class="col-12 col-md-3 mb-3 mb-md-0">
          <label class="form-label fw-bold">
            <i class="bi bi-file-text me-1"></i>Content
          </label>
          <input
            v-model="filters.content"
            type="text"
            class="form-control"
            placeholder="Search by content..."
          />
        </div>
        <div class="col-12 col-md-2 mb-3 mb-md-0">
          <label class="form-label fw-bold">
            <i class="bi bi-calendar3 me-1"></i>Date
          </label>
          <input
            v-model="filters.date"
            type="date"
            class="form-control"
          />
        </div>
        <div class="col-12 col-md-2 mb-3 mb-md-0">
          <label class="form-label fw-bold">
            <i class="bi bi-tag me-1"></i>Category
          </label>
          <select v-model="filters.category" class="form-select">
            <option value="">All</option>
            <option v-for="category in categories" :key="category" :value="category">
              {{ category }}
            </option>
          </select>
        </div>
        <div class="col-12 col-md-2 d-flex align-items-end">
          <button
            v-if="hasActiveFilters"
            @click="clearAllFilters"
            class="btn btn-outline-danger w-100"
          >
            <i class="bi bi-x-circle me-2"></i>Clear All
          </button>
        </div>
      </div>

      <!-- Active Filters Chips -->
      <div v-if="hasActiveFilters" class="row mb-3">
        <div class="col-12">
          <div class="news-page__filter-chips">
            <span class="news-page__filter-label">
              <i class="bi bi-funnel-fill me-2"></i>Active Filters:
            </span>
            <div class="news-page__chip-container">
              <div v-if="filters.title" class="news-page__chip">
                <span class="news-page__chip-type">Title:</span>
                <span class="news-page__chip-value">{{ filters.title }}</span>
                <button
                  @click="filters.title = ''"
                  class="news-page__chip-remove"
                  aria-label="Remove title filter"
                >
                  <i class="bi bi-x"></i>
                </button>
              </div>
              <div v-if="filters.content" class="news-page__chip">
                <span class="news-page__chip-type">Content:</span>
                <span class="news-page__chip-value">{{ filters.content }}</span>
                <button
                  @click="filters.content = ''"
                  class="news-page__chip-remove"
                  aria-label="Remove content filter"
                >
                  <i class="bi bi-x"></i>
                </button>
              </div>
              <div v-if="filters.date" class="news-page__chip">
                <span class="news-page__chip-type">Date:</span>
                <span class="news-page__chip-value">{{ formatDate(filters.date) }}</span>
                <button
                  @click="filters.date = ''"
                  class="news-page__chip-remove"
                  aria-label="Remove date filter"
                >
                  <i class="bi bi-x"></i>
                </button>
              </div>
              <div v-if="filters.category" class="news-page__chip">
                <span class="news-page__chip-type">Category:</span>
                <span class="news-page__chip-value">{{ filters.category }}</span>
                <button
                  @click="filters.category = ''"
                  class="news-page__chip-remove"
                  aria-label="Remove category filter"
                >
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
          <p class="news-page__count mb-0">
            <em v-if="filteredItems.length === 0">No news found</em>
            <span v-else>
              Total: <strong>{{ filteredItems.length }}</strong> SwinNews
              <span v-if="filteredItems.length !== newsItems.length">
                (filtered from {{ newsItems.length }})
              </span>
            </span>
          </p>
        </div>
        <div class="col-12 col-md-6 text-md-end">
          <label class="news-page__items-per-page">
            SwinNews per page:
            <select v-model.number="perPage" class="form-select form-select-sm d-inline-block w-auto ms-2">
              <option :value="6">6</option>
              <option :value="10">10</option>
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
          <p class="mt-3 text-muted">Loading news...</p>
        </div>
      </div>

      <!-- Error State -->
      <div v-else-if="error" class="row">
        <div class="col-12">
          <div class="alert alert-danger" role="alert">
            <i class="bi bi-exclamation-circle-fill me-2"></i>
            {{ error }}
            <button @click="loadNews" class="btn btn-sm btn-outline-danger ms-3">
              <i class="bi bi-arrow-clockwise me-1"></i>
              Retry
            </button>
          </div>
        </div>
      </div>

      <!-- Card View -->
      <div v-else-if="viewMode === 'card'" class="row">
        <div v-if="paginatedItems.length === 0" class="col-12">
          <div class="news-page__no-results-card">
            <i class="bi bi-search"></i>
            <p>No SwinNews found matching your search.</p>
          </div>
        </div>
        <div
          v-for="item in paginatedItems"
          :key="item.id"
          class="col-12 col-md-6 col-lg-4 mb-4"
        >
          <NewsCard :news-item="item" />
        </div>
      </div>

      <!-- Line View (Table) -->
      <div v-else-if="viewMode === 'line'" class="row">
        <div class="col-12">
          <div class="table-responsive">
            <table class="table table-hover news-page__table">
              <thead class="news-page__table-head">
                <tr>
                  <th scope="col">Date</th>
                  <th scope="col">Title</th>
                  <th scope="col">Content</th>
                  <th scope="col">Category</th>
                </tr>
              </thead>
              <tbody class="news-page__table-body">
                <tr v-if="paginatedItems.length === 0">
                  <td colspan="4" class="text-center news-page__no-results">
                    No SwinNews found matching your search.
                  </td>
                </tr>
                <tr v-for="item in paginatedItems" :key="item.id" class="news-page__table-row">
                  <td class="news-page__table-date">{{ formatDate(item.date) }}</td>
                  <td class="news-page__table-title">{{ item.title }}</td>
                  <td class="news-page__table-content">{{ item.content }}</td>
                  <td class="news-page__table-category">
                    <span class="badge news-page__badge bg-primary">{{ item.category }}</span>
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
          <paginate
            v-model="currentPage"
            :page-count="totalPages"
            :page-range="3"
            :margin-pages="2"
            :click-handler="handlePageChange"
            :prev-text="'Previous'"
            :next-text="'Next'"
            :container-class="'pagination justify-content-center'"
            :page-class="'page-item'"
            :page-link-class="'page-link'"
            :prev-class="'page-item'"
            :prev-link-class="'page-link'"
            :next-class="'page-item'"
            :next-link-class="'page-link'"
            :active-class="'active'"
          >
          </paginate>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import NewsCard from '../components/NewsCard.vue'
import Paginate from 'vuejs-paginate-next'

export default {
  name: 'News',
  components: {
    NewsCard,
    Paginate
  },
  data() {
    return {
      newsItems: [],
      filters: {
        title: '',
        content: '',
        date: '',
        category: ''
      },
      currentPage: 1,
      perPage: 6,
      viewMode: 'card',
      categories: [],
      loading: false,
      error: null
    }
  },
  computed: {
    hasActiveFilters() {
      return this.filters.title || this.filters.content || this.filters.date || this.filters.category
    },
    filteredItems() {
      let items = this.newsItems

      if (this.filters.title.trim()) {
        const query = this.filters.title.toLowerCase()
        items = items.filter(item =>
          item.title.toLowerCase().includes(query)
        )
      }

      if (this.filters.content.trim()) {
        const query = this.filters.content.toLowerCase()
        items = items.filter(item =>
          item.content.toLowerCase().includes(query)
        )
      }

      if (this.filters.date) {
        items = items.filter(item => item.date === this.filters.date)
      }

      if (this.filters.category) {
        items = items.filter(item => item.category === this.filters.category)
      }

      return items
    },
    paginatedItems() {
      const start = (this.currentPage - 1) * this.perPage
      const end = start + this.perPage
      return this.filteredItems.slice(start, end)
    },
    totalPages() {
      return Math.ceil(this.filteredItems.length / this.perPage)
    }
  },
  methods: {
    formatDate(dateString) {
      const options = { year: 'numeric', month: 'short', day: 'numeric' }
      return new Date(dateString).toLocaleDateString('en-US', options)
    },
    async loadNews() {
      this.loading = true
      this.error = null

      try {
        // Fetch all news items by setting a high limit
        const response = await fetch('/api/news?limit=1000')

        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`)
        }

        const data = await response.json()

        // API returns an array of news items directly
        this.newsItems = Array.isArray(data) ? data : []

        // Extract unique categories
        this.categories = [...new Set(this.newsItems.map(item => item.category))].sort()
      } catch (error) {
        console.error('Error loading news:', error)
        this.error = 'Failed to load news. Please try again later.'
        this.newsItems = []
      } finally {
        this.loading = false
      }
    },
    clearAllFilters() {
      this.filters = {
        title: '',
        content: '',
        date: '',
        category: ''
      }
    },
    handlePageChange(pageNum) {
      this.currentPage = pageNum
      window.scrollTo({ top: 0, behavior: 'smooth' })
    }
  },
  watch: {
    'filters.title'() {
      this.currentPage = 1
    },
    'filters.content'() {
      this.currentPage = 1
    },
    'filters.date'() {
      this.currentPage = 1
    },
    'filters.category'() {
      this.currentPage = 1
    },
    perPage() {
      this.currentPage = 1
    }
  },
  mounted() {
    this.loadNews()
  }
}
</script>