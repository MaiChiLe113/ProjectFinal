<template>
  <div class="preview-project">
    <!-- Preview Card (for inline preview in SubmitProject) -->
    <div v-if="!isFullPage" class="card shadow-sm">
      <div class="card-body p-4">
        <div class="project-thumbnail mb-3">
          <img 
            v-if="getThumbnailPreview"
            :src="getThumbnailPreview"
            :alt="getProjectName || 'Project thumbnail'"
            class="img-fluid rounded"
            style="width: 100%; height: 180px; object-fit: cover;">
          <div 
            v-else
            class="bg-light rounded d-flex align-items-center justify-content-center"
            style="width: 100%; height: 180px;">
            <div class="text-center">
              <i class="bi bi-image text-muted" style="font-size: 3rem;"></i>
              <p class="text-muted small mt-2">No thumbnail yet</p>
            </div>
          </div>
        </div>

        <h6 class="fw-bold mb-2" style="font-size: 0.9rem;">
          {{ getProjectName || 'Untitled' }}
        </h6>
        
        <p class="text-muted small mb-3">
          {{ getElevatorPitch || 'Add a project description...' }}
        </p>

        <button 
          class="btn btn-primary btn-sm w-100"
          @click="editThumbnail">
          <i class="bi bi-pencil me-1"></i>Edit thumbnail
        </button>
      </div>
    </div>

    <!-- Full Page Preview (when opened in new tab) -->
    <div v-else class="full-page-preview">
      <div class="container py-5">
        <div class="row justify-content-center">
          <div class="col-lg-8">
            <!-- Header with Close Button -->
            <div class="d-flex justify-content-between align-items-center mb-4">
              <h1 class="display-6 fw-bold">{{ getProjectName || 'Untitled' }}</h1>
              <button 
                class="btn btn-outline-secondary"
                @click="handleClose">
                <i class="bi bi-x-lg"></i>
              </button>
            </div>

            <!-- Project Card -->
            <div class="card shadow-sm">
              <div class="card-body p-4">
                <!-- Thumbnail -->
                <div class="project-thumbnail mb-4">
                  <img 
                    v-if="getThumbnailPreview"
                    :src="getThumbnailPreview"
                    :alt="getProjectName"
                    class="img-fluid rounded"
                    style="width: 100%; max-height: 400px; object-fit: cover;">
                  <div 
                    v-else
                    class="bg-light rounded d-flex align-items-center justify-content-center"
                    style="width: 100%; height: 300px;">
                    <div class="text-center">
                      <i class="bi bi-image text-muted" style="font-size: 4rem;"></i>
                      <p class="text-muted mt-3">No thumbnail uploaded</p>
                      <p class="text-muted small">JPG, PNG or GIF, 5 MB max file size</p>
                    </div>
                  </div>
                </div>

                <!-- Project Details -->
                <div class="project-details">
                  <div class="mb-4">
                    <h5 class="text-muted mb-2">Elevator Pitch</h5>
                    <p class="lead">
                      {{ getElevatorPitch || 'No description provided yet.' }}
                    </p>
                  </div>

                  <div class="d-flex gap-2">
                    <button 
                      class="btn btn-primary"
                      @click="handleEdit">
                      <i class="bi bi-pencil me-2"></i>Edit Project
                    </button>
                    <button 
                      class="btn btn-outline-secondary"
                      @click="handleClose">
                      <i class="bi bi-x-circle me-2"></i>Close
                    </button>
                  </div>
                </div>
              </div>
            </div>

            <!-- Live Updates Indicator -->
            <div class="alert alert-info small mt-3">
              <i class="bi bi-info-circle me-2"></i>
              This preview updates in real-time as you edit your project.
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Hidden File Input for Thumbnail -->
    <input 
      ref="fileInput"
      type="file"
      class="d-none"
      accept="image/jpeg,image/png,image/gif"
      @change="handleThumbnailUpload">
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'

export default {
  name: 'PreviewProject',
  computed: {
    // Get data from Vuex store (automatically reactive)
    ...mapGetters('project', [
      'getProjectName',
      'getElevatorPitch',
      'getThumbnailPreview',
      'isProjectValid'
    ]),

    // Get error state
    errorMessage() {
      return this.$store.state.project.error
    },

    // Check if this is full page preview
    isFullPage() {
      return this.$route.name === 'PreviewProject'
    }
  },
  methods: {
    // Get actions from store
    ...mapActions('project', [
      'uploadThumbnail'
    ]),

    editThumbnail() {
      this.$refs.fileInput.click()
    },

    handleThumbnailUpload(event) {
      const file = event.target.files[0]
      if (!file) return

      try {
        // Create preview
        const reader = new FileReader()
        reader.onload = (e) => {
          // Upload using Vuex action (with validation)
          this.uploadThumbnail({
            file: file,
            preview: e.target.result
          })
        }
        reader.readAsDataURL(file)
      } catch (error) {
        alert(this.errorMessage || 'Error uploading file')
      }

      // Reset input so same file can be selected again
      event.target.value = ''
    },

    handleEdit() {
      // Close this window and return to SubmitProject
      window.close()
    },

    handleClose() {
      if (this.isFullPage) {
        // Close this window
        window.close()
      }
    }
  }
}
</script>

<style scoped>
.preview-project {
  width: 100%;
}

.card {
  border: none;
  border-radius: 8px;
}

.project-thumbnail {
  border-radius: 8px;
  overflow: hidden;
  background-color: #f8f9fa;
}

.full-page-preview {
  background-color: #f8f9fa;
  min-height: 100vh;
}

.project-details {
  border-top: 1px solid #e9ecef;
  padding-top: 2rem;
}

img {
  display: block;
}

@media (max-width: 768px) {
  .full-page-preview .container {
    padding: 2rem 1rem;
  }

  .card-body {
    padding: 1rem !important;
  }

  .display-6 {
    font-size: 1.5rem;
  }
}
</style>