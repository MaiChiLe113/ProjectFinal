<template>
  <div class="news-detail">
    <div class="container py-5">
      <!-- Back Button -->
      <div class="mb-4">
        <button @click="goBack" class="btn btn-outline-primary">
          <i class="bi bi-arrow-left me-2"></i>Back to News
        </button>
      </div>

      <!-- Loading State -->
      <div v-if="loading" class="text-center py-5">
        <div class="spinner-border text-primary" role="status">
          <span class="visually-hidden">Loading...</span>
        </div>
      </div>

      <!-- Error State -->
      <div v-else-if="error" class="alert alert-danger">
        <i class="bi bi-exclamation-circle-fill me-2"></i>
        {{ error }}
        <button @click="loadNewsItem" class="btn btn-sm btn-outline-danger ms-3">
          <i class="bi bi-arrow-clockwise me-1"></i>
          Retry
        </button>
      </div>

      <!-- News Not Found -->
      <div v-else-if="!newsItem" class="alert alert-warning">
        <i class="bi bi-exclamation-triangle me-2"></i>
        News item not found.
      </div>

      <!-- News Detail Content -->
      <div v-else class="news-detail__content">
        <!-- Category Badge -->
        <div class="mb-3">
          <span class="badge bg-primary fs-6 px-3 py-2">
            <i class="bi bi-tag me-2"></i>{{ newsItem.category }}
          </span>
        </div>

        <!-- Title -->
        <h1 class="news-detail__title mb-3">{{ newsItem.title }}</h1>

        <!-- Date -->
        <div class="text-muted mb-4">
          <i class="bi bi-calendar3 me-2"></i>
          {{ formatDate(newsItem.date) }}
        </div>

        <!-- Image -->
        <div class="news-detail__image-container mb-4">
          <img
            :src="newsItem.image"
            :alt="newsItem.title"
            class="news-detail__image"
            @error="handleImageError"
          />
        </div>

        <!-- Full Content -->
        <div class="news-detail__text">
          <p class="fs-5 lh-lg">{{ newsItem.content }}</p>
        </div>

        <!-- Additional Actions -->
        <div class="news-detail__actions mt-5 pt-4 border-top">
          <button @click="goBack" class="btn btn-primary">
            <i class="bi bi-arrow-left me-2"></i>Back to News
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'NewsDetail',
  data() {
    return {
      newsItem: null,
      loading: true,
      error: null
    }
  },
  methods: {
    formatDate(dateString) {
      const options = { year: 'numeric', month: 'long', day: 'numeric' }
      return new Date(dateString).toLocaleDateString('en-US', options)
    },
    handleImageError(event) {
      event.target.src = 'https://placehold.co/1200x600/6366f1/ffffff?text=News+Image'
    },
    goBack() {
      this.$router.push('/news')
    },
    async loadNewsItem() {
      this.loading = true
      this.error = null

      try {
        const id = parseInt(this.$route.params.id)

        // Fetch from local JSON file
        const response = await fetch('/data/news.json')

        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`)
        }

        const newsData = await response.json()

        // Find the specific news item by ID
        this.newsItem = newsData.find(item => item.id === id)

        if (!this.newsItem) {
          console.log('News item not found with ID:', id)
        }
      } catch (error) {
        console.error('Error loading news:', error)
        this.error = 'Failed to load news item. Please try again later.'
        this.newsItem = null
      } finally {
        this.loading = false
      }
    }
  },
  mounted() {
    this.loadNewsItem()
  },
  watch: {
    '$route.params.id'() {
      this.loading = true
      this.loadNewsItem()
    }
  }
}
</script>

<style scoped>
.news-detail {
  min-height: calc(100vh - 200px);
  background-color: #f8f9fa;
}

.news-detail__content {
  background: white;
  border-radius: 12px;
  padding: 2rem;
  box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
}

.news-detail__title {
  font-size: 2.5rem;
  font-weight: bold;
  color: #212529;
  line-height: 1.2;
}

.news-detail__image-container {
  width: 100%;
  overflow: hidden;
  border-radius: 12px;
  box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
}

.news-detail__image {
  width: 100%;
  height: auto;
  max-height: 500px;
  object-fit: cover;
  display: block;
}

.news-detail__text {
  font-size: 1.1rem;
  line-height: 1.8;
  color: #495057;
}

.news-detail__actions {
  display: flex;
  gap: 1rem;
}

@media (max-width: 768px) {
  .news-detail__content {
    padding: 1.5rem;
  }

  .news-detail__title {
    font-size: 2rem;
  }

  .news-detail__image {
    max-height: 300px;
  }
}
</style>
