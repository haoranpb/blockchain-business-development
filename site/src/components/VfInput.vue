<template>
  <input
    :type="type"
    :value="modelValue"
    @input="$emit('update:modelValue', $event.target.value)"
  />
</template>

<script>
export default {
  props: {
    modelValue: { type: String, default: '' },
    type: { type: String, default: 'text' },
  },
  emits: ['update:modelValue'],
}
</script>

<style scoped>
input {
  @apply block text-sm w-full shadow-sm rounded-md bg-gray-100 border-transparent focus:border-primary-500 focus:bg-white focus:ring-0;
}
</style>
