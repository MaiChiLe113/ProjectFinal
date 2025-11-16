import { createStore } from 'vuex'
import projectModule from './modules/project'
import authModule from './modules/auth'

export default createStore({
  modules: {
    project: projectModule,
    auth: authModule,
  }
})