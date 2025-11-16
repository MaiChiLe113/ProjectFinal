<template>
  <div class="submit-project">
    <div class="container py-5">
      <div class="row">
        <!-- Left Column - Form -->
        <div class="col-lg-8">
          <!-- Header -->
          <div class="mb-4">
            <h2 class="display-6 fw-bold mb-2">Project overview</h2>
            <p class="text-muted">Please respect our <a href="#" class="text-primary">Community Guidelines</a>.</p>
          </div>

          <!-- General Info Section -->
          <div class="card shadow-sm mb-4">
            <div class="card-body p-4">
              <h5 class="fw-bold mb-4">
                <span class="text-danger">*</span> General info
              </h5>

              <!-- Project Name -->
              <div class="mb-4">
                <label for="projectName" class="form-label fw-bold">
                  <span class="text-danger">*</span> Project name
                </label>
                <p class="text-muted small mb-2">You can change this at any time.</p>
                <input 
                  type="text" 
                  id="projectName"
                  class="form-control form-control-lg" 
                  v-model="projectName"
                  placeholder="Enter project name"
                  maxlength="60">
                <div class="form-text text-end">
                  {{ projectName.length }} / 60 characters
                </div>
              </div>

              <!-- Elevator Pitch -->
              <div class="mb-4">
                <label for="elevatorPitch" class="form-label fw-bold">
                  <span class="text-danger">*</span> Elevator pitch
                </label>
                <p class="text-muted small mb-2">Provide a short tagline for the project. You can change this later.</p>
                <textarea 
                  id="elevatorPitch"
                  class="form-control" 
                  rows="4"
                  v-model="elevatorPitch"
                  placeholder="Brief description of your project..."
                  maxlength="200"></textarea>
                <div class="form-text text-end">
                  {{ elevatorPitch.length }} / 200 characters
                </div>
              </div>

              <!-- Error Messages -->
              <div v-if="errorMessage" class="alert alert-danger small">
                <i class="bi bi-exclamation-circle me-2"></i>{{ errorMessage }}
              </div>
            </div>
          </div>

          <!-- Project Story Section -->
          <div class="card shadow-sm mb-4">
            <div class="card-body p-4">
              <h5 class="fw-bold mb-4">
                <span class="text-danger">*</span> Project Story
              </h5>

              <!-- About the Project -->
              <div class="mb-4">
                <label for="aboutProject" class="form-label fw-bold">
                  <span class="text-danger">*</span> About the project
                </label>
                <p class="text-muted small mb-2">Be sure to write what inspired you, what you learned, how you built your project, and the challenges you faced. Format your story in Markdown, with LaTeX support for math.</p>
                <textarea 
                  id="aboutProject"
                  class="form-control" 
                  rows="8"
                  v-model="aboutProject"
                  placeholder="### Inspiration&#10;&#10;Write your project story here..."
                  maxlength="5000"></textarea>
                <div class="form-text text-end">
                  {{ aboutProject.length }} / 5000 characters
                </div>
              </div>

              <!-- Built With -->
              <div class="mb-4">
                <label for="builtWith" class="form-label fw-bold">
                  Built with
                </label>
                <p class="text-muted small mb-2">Languages, frameworks, platforms, cloud services, databases, APIs, or other technologies did you use?</p>
                <input 
                  type="text" 
                  id="builtWith"
                  class="form-control form-control-lg" 
                  v-model="builtWith"
                  placeholder="Languages, frameworks, platforms, cloud services, databases, APIs, etc."
                  maxlength="500">
                <div class="form-text text-end">
                  {{ builtWith.length }} / 500 characters
                </div>
              </div>
            </div>
          </div>

          <!-- Try It Out Links Section -->
          <div class="card shadow-sm mb-4">
            <div class="card-body p-4">
              <h5 class="fw-bold mb-4">
                "Try it out" links
              </h5>
              <p class="text-muted small mb-4">Add links where people can try your project or see your code</p>

              <!-- Links List -->
              <div v-for="(link, index) in tryItOutLinks" :key="index" class="mb-3">
                <div class="input-group input-group-lg">
                  <input 
                    type="url"
                    class="form-control"
                    v-model="tryItOutLinks[index]"
                    placeholder="URL for demo site, app store listing, GitHub repo, etc."
                    @input="validateLinks">
                  <button 
                    class="btn btn-outline-danger"
                    type="button"
                    @click="removeLink(index)">
                    <i class="bi bi-trash"></i>
                  </button>
                </div>
              </div>

              <!-- Add Link Button -->
              <button 
                class="btn btn-outline-secondary w-100"
                @click="addLink"
                v-if="tryItOutLinks.length < 5">
                <i class="bi bi-plus-circle me-2"></i>Add another link
              </button>
            </div>
          </div>

          <!-- Project Media Section -->
          <div class="card shadow-sm mb-4">
            <div class="card-body p-4">
              <h5 class="fw-bold mb-4">
                Project Media
              </h5>

              <!-- Image Gallery -->
              <div class="mb-4">
                <label class="form-label fw-bold">
                  Image gallery
                </label>
                <p class="text-muted small mb-2">JPG, PNG or GIF format, 5 MB max file size. For best results, use a 3:2 ratio.</p>
                
                <div 
                  class="border-2 border-dashed rounded p-4 text-center"
                  style="border-color: #dee2e6; cursor: pointer;"
                  @click="$refs.imageInput.click()"
                  @dragover.prevent="dragOverImage = true"
                  @dragleave.prevent="dragOverImage = false"
                  @drop.prevent="handleImageDrop"
                  :class="{ 'bg-light': dragOverImage }">
                  <i class="bi bi-image text-muted" style="font-size: 2rem;"></i>
                  <p class="mb-0 mt-2">
                    <span class="fw-bold">Choose files</span> or drag and drop
                  </p>
                  <p class="text-muted small">JPG, PNG or GIF, max 5 MB</p>
                </div>

                <input 
                  ref="imageInput"
                  type="file"
                  multiple
                  accept="image/jpeg,image/png,image/gif"
                  class="d-none"
                  @change="handleImageSelect">

                <!-- Preview Images -->
                <div v-if="projectImages.length > 0" class="row mt-3 g-2">
                  <div v-for="(image, index) in projectImages" :key="index" class="col-6 col-md-4">
                    <div class="position-relative">
                      <img 
                        :src="image.preview"
                        :alt="'Project image ' + (index + 1)"
                        class="img-fluid rounded"
                        style="width: 100%; height: 150px; object-fit: cover;">
                      <button 
                        type="button"
                        class="btn btn-sm btn-danger position-absolute top-0 end-0 m-1"
                        @click="removeImage(index)">
                        <i class="bi bi-trash"></i>
                      </button>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Video Demo Link -->
              <div class="mb-4">
                <label for="videoDemoLink" class="form-label fw-bold">
                  Video demo link
                </label>
                <p class="text-muted small mb-2">This video will be embedded at the top of your project page. Read more about <a href="#" class="text-primary">uploading videos</a>.</p>
                <input 
                  type="url"
                  id="videoDemoLink"
                  class="form-control form-control-lg" 
                  v-model="videoDemoLink"
                  placeholder="YouTube, Facebook Video, Vimeo or Youku URL"
                  maxlength="500">
                <div class="form-text">
                  {{ videoDemoLink.length }} / 500 characters
                </div>
              </div>
            </div>
          </div>

          <!-- Error Messages -->
          <div v-if="formErrors.length > 0" class="alert alert-danger mb-4">
            <h6 class="alert-heading">Please fix the following errors:</h6>
            <ul class="mb-0">
              <li v-for="error in formErrors" :key="error">{{ error }}</li>
            </ul>
          </div>

          <!-- Action Buttons -->
          <div class="d-flex gap-2">
            <button 
              class="btn btn-primary btn-lg px-5"
              @click="handleSaveAndContinue"
              :disabled="!isFormValid || isLoading">
              <i v-if="!isLoading" class="bi bi-check-circle me-2"></i>
              <span v-if="isLoading" class="spinner-border spinner-border-sm me-2"></span>
              {{ isLoading ? 'Saving...' : 'Save & continue' }}
            </button>
            <button 
              class="btn btn-secondary btn-lg"
              @click="handleCancel"
              :disabled="isLoading">
              Cancel
            </button>
          </div>
        </div>

        <!-- Right Column - Preview -->
        <div class="col-lg-4">
          <div class="sticky-top" style="top: 20px;">
            <router-link
              class="btn btn-outline-primary w-100 mb-3"
              to="/preview"
              target="_blank">
              <i class="bi bi-box-arrow-up-right me-2"></i>Preview
            </router-link>
            <PreviewProject />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import PreviewProject from './PreviewProject.vue'

export default {
  name: 'SubmitProject',
  components: {
    PreviewProject
  },
  data() {
    return {
      aboutProject: '',
      builtWith: '',
      tryItOutLinks: [''],
      projectImages: [],
      videoDemoLink: '',
      dragOverImage: false,
      formErrors: []
    }
  },
  computed: {
    ...mapGetters('project', [
      'getProjectName',
      'getElevatorPitch',
      'isProjectValid',
      'isLoading'
    ]),

    errorMessage() {
      return this.$store.state.project.error
    },

    projectName: {
      get() {
        return this.getProjectName
      },
      set(value) {
        this.updateProjectName(value)
      }
    },

    elevatorPitch: {
      get() {
        return this.getElevatorPitch
      },
      set(value) {
        this.updateElevatorPitch(value)
      }
    },

    isFormValid() {
      return this.projectName.trim() &&
             this.elevatorPitch.trim() &&
             this.aboutProject.trim() &&
             this.hasValidLinks()
    }
  },
  methods: {
    ...mapActions('project', [
      'updateProjectName',
      'updateElevatorPitch',
      'saveProject'
    ]),

    addLink() {
      if (this.tryItOutLinks.length < 5) {
        this.tryItOutLinks.push('')
      }
    },

    removeLink(index) {
      this.tryItOutLinks.splice(index, 1)
      if (this.tryItOutLinks.length === 0) {
        this.tryItOutLinks.push('')
      }
    },

    validateLinks() {
      this.formErrors = this.formErrors.filter(e => !e.includes('link'))
      const invalidLinks = this.tryItOutLinks.filter(link => link && !this.isValidUrl(link))
      if (invalidLinks.length > 0) {
        this.formErrors.push('Some links have invalid URL format')
      }
    },

    isValidUrl(url) {
      try {
        new URL(url)
        return true
      } catch {
        return false
      }
    },

    hasValidLinks() {
      const filledLinks = this.tryItOutLinks.filter(link => link.trim())
      if (filledLinks.length === 0) return true // Links are optional
      return filledLinks.every(link => this.isValidUrl(link))
    },

    handleImageSelect(event) {
      const files = Array.from(event.target.files)
      this.processImages(files)
    },

    handleImageDrop(event) {
      this.dragOverImage = false
      const files = Array.from(event.dataTransfer.files)
      this.processImages(files)
    },

    processImages(files) {
      files.forEach(file => {
        // Validate file
        if (!this.validateImageFile(file)) {
          return
        }

        // Create preview
        const reader = new FileReader()
        reader.onload = (e) => {
          this.projectImages.push({
            file: file,
            preview: e.target.result,
            name: file.name
          })
        }
        reader.readAsDataURL(file)
      })
    },

    validateImageFile(file) {
      const validTypes = ['image/jpeg', 'image/png', 'image/gif']
      if (!validTypes.includes(file.type)) {
        alert('File must be JPG, PNG, or GIF')
        return false
      }

      if (file.size > 5 * 1024 * 1024) {
        alert('File size must not exceed 5MB')
        return false
      }

      return true
    },

    removeImage(index) {
      this.projectImages.splice(index, 1)
    },

    validateForm() {
      this.formErrors = []

      if (!this.projectName.trim()) {
        this.formErrors.push('Project name is required')
      }

      if (!this.elevatorPitch.trim()) {
        this.formErrors.push('Elevator pitch is required')
      }

      if (!this.aboutProject.trim()) {
        this.formErrors.push('Project story is required')
      }

      this.validateLinks()

      if (this.videoDemoLink && !this.isValidUrl(this.videoDemoLink)) {
        this.formErrors.push('Video demo link must be a valid URL')
      }

      return this.formErrors.length === 0
    },

    async handleSaveAndContinue() {
      if (!this.validateForm()) {
        return
      }

      try {
        // Update store with all form data
        await this.$store.dispatch('project/updateProjectData', {
          aboutProject: this.aboutProject,
          builtWith: this.builtWith,
          tryItOutLinks: this.tryItOutLinks.filter(link => link.trim()),
          projectImages: this.projectImages.map(img => ({
            name: img.name,
            preview: img.preview
          })),
          videoDemoLink: this.videoDemoLink
        })

        await this.saveProject()
        alert('Project details saved successfully!')
        this.$router.push({ name: 'ProjectDetails' })
      } catch (error) {
        console.error('Error saving project:', error)
      }
    },

    handleCancel() {
      if (confirm('Are you sure you want to cancel? Your changes will not be saved.')) {
        this.$router.back()
      }
    }
  }
}
</script>

<style scoped>
.submit-project {
  background-color: #f8f9fa;
  min-height: 100vh;
}

.card {
  border: none;
  border-radius: 8px;
}

.form-control:focus,
.form-control:active,
.form-select:focus,
textarea:focus {
  border-color: #0d6efd;
  box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
}

.sticky-top {
  position: sticky;
}

.spinner-border-sm {
  width: 1rem;
  height: 1rem;
}

.border-2 {
  border-width: 2px !important;
}

.border-dashed {
  border-style: dashed !important;
}

.input-group-lg > .form-control {
  padding: 0.75rem 1rem;
  font-size: 1rem;
}

@media (max-width: 768px) {
  .sticky-top {
    position: relative;
    top: 0 !important;
  }

  .display-6 {
    font-size: 1.5rem;
  }
}
</style>