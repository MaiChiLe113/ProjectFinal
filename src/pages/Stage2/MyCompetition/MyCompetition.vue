<template>
    <ul class="nav justify-content-center">
    <li class="nav-item">
        <router-link class="nav-link active" aria-current="page" to="/mycompetition/join">Joined Competitions</router-link>
    </li>
    <li class="nav-item">
        <router-link class="nav-link" to="/mycompetition/host">Hosted Competitions</router-link>
    </li>
    </ul>
</template>
<script>
import Joined from './Join.vue'
import Hosted from './Host.vue'
export default {
  name: 'MyCompetition',
    components: {
        Joined,
        Hosted
    }
};
</script>