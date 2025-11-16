<script >
import Header from './components/Header.vue';
import Footer from './components/Footer.vue'
export default {
  name: 'App',
  components: {
    Header,
    Footer
  }
};
</script>

<template>
  <div id="app">
    <Header></Header>
    <main>
    <RouterView />
   </main>
    <Footer></Footer>
  </div>
</template>
<style>
html, body {
  height: 100%;
}

#app {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

main {
  flex: 1 0 auto;
}
</style>