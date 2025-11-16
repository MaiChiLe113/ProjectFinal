import axios from 'axios'; 

const state = {
  user: null,
  isAuthenticated: false,
}

const getters = {
  isAuthenticated: (state) => state.isAuthenticated,
  currentUser: (state) => state.user,
  userLastName: (state) => state.user ? state.user.last_name : null,
}

const mutations = {
  SET_USER(state, user) {
    state.user = user
    state.isAuthenticated = !!user
  },
  CLEAR_USER(state) {
    state.user = null
    state.isAuthenticated = false
  },
}

const actions = {
  async register({ commit }, userData) {
    try {
      const response = await axios.post('/api/register', {
        first_name: userData.firstName,
        last_name: userData.lastName,
        email: userData.email,
        phone: userData.phone,
        password: userData.password,
        gender: userData.gender,
        role: 'student' // default role
      })

      const user = response.data;

      if (user && user.email) {
        // Registration successful
        return user
      } else {
        throw new Error('Registration failed due to unexpected server response.')
      }
    } catch (error) {
      console.error('API Registration Error:', error.response || error)
      throw new Error(error.response?.data?.message || 'Registration failed. Please try again.')
    }
  },

  async login({ commit }, { email, password }) {
    try {
      const response = await axios.post('/api/login', {
        email: email,
        password: password
      })
      const user = response.data;

      if (user && user.email) {
        commit('SET_USER', user)

        localStorage.setItem('swincom_user', JSON.stringify(user))

        return user
      } else {
        throw new Error('Login failed due to unexpected server response.')
      }
    } catch (error) {
      console.error('API Login Error:', error.response || error)
      throw new Error(error.response?.data?.message || 'Invalid email or password.')
    }
  },
  logout({ commit }) {
    commit('CLEAR_USER')
    localStorage.removeItem('swincom_user')
  },
  checkAuth({ commit }) {
    const storedUser = localStorage.getItem('swincom_user')
    if (storedUser) {
      try {
        const user = JSON.parse(storedUser)
        commit('SET_USER', user)
      } catch (error) {
        console.error('Error parsing stored user:', error)
        localStorage.removeItem('swincom_user')
      }
    }
  },
}

export default {
  namespaced: true,
  state,
  getters,
  mutations,
  actions,
}