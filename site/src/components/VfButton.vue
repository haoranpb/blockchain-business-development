<template>
  <button type="button">
    <slot></slot>
  </button>
</template>

<style scoped>
button {
  @apply px-4 py-1.5 rounded-md text-white inline-block shadow-lg bg-primary-500 hover:bg-primary-600 focus:bg-primary-700;
}
</style>
