import { createStore } from 'vuex'

export default createStore({
  state() {
    return {
      user: '',
    }
  },
  mutations: {
    setUser(state, user) {
      state.user = user
    },
  },
})
