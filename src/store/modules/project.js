// src/store/modules/project.js

const state = () => ({
  projectData: {
    // General Info
    projectName: '',
    elevatorPitch: '',
    thumbnail: null,
    thumbnailPreview: null,
    
    // Project Story
    aboutProject: '',
    builtWith: '',
    
    // Try It Out Links
    tryItOutLinks: [],
    
    // Project Media
    projectImages: [],
    videoDemoLink: '',
    
    // Metadata
    category: '',
    tags: [],
    createdAt: null,
    updatedAt: null
  },
  isLoading: false,
  error: null
})

const getters = {
  // Get all project data
  getProjectData: (state) => state.projectData,
  
  // Get specific fields - General Info
  getProjectName: (state) => state.projectData.projectName,
  getElevatorPitch: (state) => state.projectData.elevatorPitch,
  getThumbnailPreview: (state) => state.projectData.thumbnailPreview,
  getThumbnail: (state) => state.projectData.thumbnail,
  
  // Get specific fields - Project Story
  getAboutProject: (state) => state.projectData.aboutProject,
  getBuiltWith: (state) => state.projectData.builtWith,
  
  // Get specific fields - Links & Media
  getTryItOutLinks: (state) => state.projectData.tryItOutLinks,
  getProjectImages: (state) => state.projectData.projectImages,
  getVideoDemoLink: (state) => state.projectData.videoDemoLink,
  
  // Get loading state
  isLoading: (state) => state.isLoading,
  getError: (state) => state.error,
  
  // Check if project is valid
  isProjectValid: (state) => {
    return state.projectData.projectName.trim() !== '' &&
           state.projectData.elevatorPitch.trim() !== '' &&
           state.projectData.aboutProject.trim() !== ''
  }
}

const mutations = {
  // Update entire project data
  SET_PROJECT_DATA(state, payload) {
    state.projectData = { 
      ...state.projectData, 
      ...payload,
      updatedAt: new Date().toISOString()
    }
  },
  
  // Update specific fields - General Info
  UPDATE_PROJECT_NAME(state, name) {
    state.projectData.projectName = name
    state.projectData.updatedAt = new Date().toISOString()
  },
  
  UPDATE_ELEVATOR_PITCH(state, pitch) {
    state.projectData.elevatorPitch = pitch
    state.projectData.updatedAt = new Date().toISOString()
  },
  
  UPDATE_THUMBNAIL_PREVIEW(state, preview) {
    state.projectData.thumbnailPreview = preview
    state.projectData.updatedAt = new Date().toISOString()
  },
  
  UPDATE_THUMBNAIL_FILE(state, file) {
    state.projectData.thumbnail = file
    state.projectData.updatedAt = new Date().toISOString()
  },
  
  // Update specific fields - Project Story
  UPDATE_ABOUT_PROJECT(state, about) {
    state.projectData.aboutProject = about
    state.projectData.updatedAt = new Date().toISOString()
  },
  
  UPDATE_BUILT_WITH(state, builtWith) {
    state.projectData.builtWith = builtWith
    state.projectData.updatedAt = new Date().toISOString()
  },
  
  // Update specific fields - Links & Media
  UPDATE_TRY_IT_OUT_LINKS(state, links) {
    state.projectData.tryItOutLinks = links
    state.projectData.updatedAt = new Date().toISOString()
  },
  
  UPDATE_PROJECT_IMAGES(state, images) {
    state.projectData.projectImages = images
    state.projectData.updatedAt = new Date().toISOString()
  },
  
  UPDATE_VIDEO_DEMO_LINK(state, link) {
    state.projectData.videoDemoLink = link
    state.projectData.updatedAt = new Date().toISOString()
  },
  
  UPDATE_CATEGORY(state, category) {
    state.projectData.category = category
    state.projectData.updatedAt = new Date().toISOString()
  },
  
  UPDATE_TAGS(state, tags) {
    state.projectData.tags = tags
    state.projectData.updatedAt = new Date().toISOString()
  },
  
  SET_LOADING(state, loading) {
    state.isLoading = loading
  },
  
  SET_ERROR(state, error) {
    state.error = error
  },
  
  // Reset project data
  RESET_PROJECT_DATA(state) {
    state.projectData = {
      projectName: '',
      elevatorPitch: '',
      thumbnailPreview: null,
      thumbnail: null,
      aboutProject: '',
      builtWith: '',
      tryItOutLinks: [],
      projectImages: [],
      videoDemoLink: '',
      category: '',
      tags: [],
      createdAt: null,
      updatedAt: null
    }
    state.error = null
  }
}

const actions = {
  // Update project data (batch update)
  updateProjectData({ commit }, payload) {
    commit('SET_PROJECT_DATA', payload)
  },
  
  // Update individual fields - General Info
  updateProjectName({ commit }, name) {
    commit('UPDATE_PROJECT_NAME', name)
  },
  
  updateElevatorPitch({ commit }, pitch) {
    commit('UPDATE_ELEVATOR_PITCH', pitch)
  },
  
  updateThumbnailPreview({ commit }, preview) {
    commit('UPDATE_THUMBNAIL_PREVIEW', preview)
  },
  
  updateThumbnailFile({ commit }, file) {
    commit('UPDATE_THUMBNAIL_FILE', file)
  },
  
  // Update individual fields - Project Story
  updateAboutProject({ commit }, about) {
    commit('UPDATE_ABOUT_PROJECT', about)
  },
  
  updateBuiltWith({ commit }, builtWith) {
    commit('UPDATE_BUILT_WITH', builtWith)
  },
  
  // Update individual fields - Links & Media
  updateTryItOutLinks({ commit }, links) {
    commit('UPDATE_TRY_IT_OUT_LINKS', links)
  },
  
  updateProjectImages({ commit }, images) {
    commit('UPDATE_PROJECT_IMAGES', images)
  },
  
  updateVideoDemoLink({ commit }, link) {
    commit('UPDATE_VIDEO_DEMO_LINK', link)
  },
  
  updateCategory({ commit }, category) {
    commit('UPDATE_CATEGORY', category)
  },
  
  updateTags({ commit }, tags) {
    commit('UPDATE_TAGS', tags)
  },
  
  // Upload thumbnail with validation
  uploadThumbnail({ commit }, { file, preview }) {
    // Validate file size (5MB max)
    if (file.size > 5 * 1024 * 1024) {
      commit('SET_ERROR', 'File size must not exceed 5MB')
      throw new Error('File size exceeds 5MB limit')
    }

    // Validate file type
    const validTypes = ['image/jpeg', 'image/png', 'image/gif']
    if (!validTypes.includes(file.type)) {
      commit('SET_ERROR', 'File must be JPG, PNG, or GIF')
      throw new Error('Invalid file type')
    }

    commit('UPDATE_THUMBNAIL_FILE', file)
    commit('UPDATE_THUMBNAIL_PREVIEW', preview)
    commit('SET_ERROR', null)
  },
  
  // Save project to backend (async)
  async saveProject({ state, commit }) {
    commit('SET_LOADING', true)
    commit('SET_ERROR', null)

    try {
      // Demo mode - Using local JSON files, no API calls
      // Prepare project data (but don't persist it)
      const projectData = {
        projectName: state.projectData.projectName,
        elevatorPitch: state.projectData.elevatorPitch,
        aboutProject: state.projectData.aboutProject,
        builtWith: state.projectData.builtWith,
        tryItOutLinks: state.projectData.tryItOutLinks,
        videoDemoLink: state.projectData.videoDemoLink,
        category: state.projectData.category,
        tags: state.projectData.tags,
        thumbnail: state.projectData.thumbnail ? 'uploaded' : null,
        projectImages: state.projectData.projectImages.length
      }

      console.log('Project data prepared (demo mode):', projectData)

      // Simulate successful save
      const result = {
        success: true,
        message: 'Project saved successfully (demo mode - data not persisted)',
        project: projectData
      }

      commit('SET_LOADING', false)
      return result
    } catch (error) {
      commit('SET_ERROR', error.message)
      commit('SET_LOADING', false)
      throw error
    }
  },
  
  // Load project from backend (async)
  async loadProject({ commit }, projectId) {
    commit('SET_LOADING', true)
    commit('SET_ERROR', null)

    try {
      const response = await fetch(`/api/projects/${projectId}`)

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`)
      }

      const project = await response.json()
      commit('SET_PROJECT_DATA', project)
      commit('SET_LOADING', false)
      return project
    } catch (error) {
      commit('SET_ERROR', error.message)
      commit('SET_LOADING', false)
      throw error
    }
  },
  
  // Reset project to default state
  resetProject({ commit }) {
    commit('RESET_PROJECT_DATA')
  },
  
  // Clear error
  clearError({ commit }) {
    commit('SET_ERROR', null)
  }
}

export default {
  namespaced: true,
  state,
  getters,
  mutations,
  actions
}