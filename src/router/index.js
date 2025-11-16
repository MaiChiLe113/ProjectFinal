import { createWebHistory, createRouter } from 'vue-router'

import Home from '../pages/Home.vue'
import About from '../pages/About.vue'
import News from '../pages/News.vue'
import NewsDetail from '../components/NewsDetail.vue'

import Competitions from '../pages/Stage2/Competition.vue'
import CompetitionDetail from '../components/CompetitionDetail.vue'
import Join from '../pages/Stage2/Join.vue'
import SubmitProject from '../pages/Stage2/SubmitProject.vue'
import PreviewProject from '../pages/Stage2/PreviewProject.vue'
import Host from '../pages/Stage2/Host.vue'
import SignIn from '../pages/Stage2/SignIn.vue'
import SignUp from '../pages/Stage2/SignUp.vue'

// import MyCompetition from '../pages/Stage2/MyCompetition.vue'
// import Joined from '../pages/Stage2/MyCompetition/Join.vue'
import Vote from '../pages/Stage2/Vote.vue'
// import Mark from '../pages/Stage2/Mark.vue'
// import MarkCompetition from '../pages/Stage2/MarkCompetition.vue'
import Hosted from '../pages/Stage2/MyCompetition/Host.vue'

import Projects from '../pages/Stage2/Projects.vue'
import ProjectDetail from '../components/ProjectDetail.vue'
import DashBoard from '../pages/Stage2/DashBoard.vue'


const routes = [
  {path: '/', component: Home},
  {path: '/about', component: About},
  {path: '/news', component: News},
  {path: '/news/:id', name: 'NewsDetail', component: NewsDetail},
  {path: '/competitions', component: Competitions},
  {path: '/competitions/:id', name: 'CompetitionDetail', component: CompetitionDetail},
  {path: '/competitions/:id/join', component: Join},
  {path: '/submit', component: SubmitProject},
  {path: '/preview', name: 'PreviewProject', component: PreviewProject},
  {path: '/host', component: Host},
//   {path: '/mycompetition', component: MyCompetition},
//   {path: '/mycompetition/join', component: Joined},
  {path: '/mycompetition/host', component: Hosted},
//   {path: '/mark', component: Mark},
  {path: '/competitions/:id/projects', name: 'ProjectsInACompetition', component: Projects},
  {path: '/vote', name: 'AllProjects', component: Vote},
  {path: '/competitions/:id/projects/:ProjectId', name: 'ProjectDetail', component: ProjectDetail},
  {path: '/signin', name: 'SignIn', component: SignIn},
  {path: '/signup', name: 'SignUp', component: SignUp},
  {path: '/dashboard', name: 'DashBoard', component: DashBoard},
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

export default router