<template>
  <nav class="flex container h-16 mx-auto items-center">
    <router-link
      v-if="$route.name != 'landing'"
      class="text-2xl font-medium pl-8 inline-block"
      to="/"
    >
      Nesters
    </router-link>
    <div class="flex-grow"></div>
    <div class="flex flex-row space-x-5">
      <router-link to="/market">Marketplace</router-link>
      <router-link to="/vote">Voting</router-link>
      <router-link to="/profile">Profile</router-link>
      <router-link to="/auth">Register</router-link>
    </div>
  </nav>
</template>
