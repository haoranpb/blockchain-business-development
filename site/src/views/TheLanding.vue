<template>
  <div id="the-landing" class="h-full px-24 pr-36">
    <section class="container pt-20">
      <img src="@/assets/logo.png" alt="logo" class="w-72 mb-12" />
      <h1 class="text-6xl text-gray-900 leading-none font-bold">
        Next Generation of Holiday House Marketplace
      </h1>
      <h2 class="text-2xl font-medium text-gray-500 leading-10 my-8">
        Find your best - guaranteed place, at the cheapest rate
      </h2>

      <div
        class="flex flex-wrap space-y-4 sm:space-y-0 sm:space-x-4 text-center"
      >
        <router-link
          class="
            w-full
            sm:w-auto
            flex-none
            bg-gray-900
            hover:bg-gray-700
            text-white text-lg
            leading-6
            font-semibold
            py-3
            px-6
            border border-transparent
            rounded-xl
            focus:ring-2
            focus:ring-offset-2
            focus:ring-offset-white
            focus:ring-gray-900
            focus:outline-none
            transition-colors
            duration-200
          "
          to="/auth/"
        >
          Get started
        </router-link>

        <OutboundLink
          class="
            w-full
            sm:w-auto
            flex-none
            bg-gray-50
            text-gray-400
            hover:text-gray-900
            font-mono
            leading-6
            py-3
            sm:px-6
            border border-gray-200
            rounded-xl
            flex
            items-center
            justify-center
            space-x-2
            sm:space-x-4
            focus:ring-2
            focus:ring-offset-2
            focus:ring-offset-white
            focus:ring-gray-300
            focus:outline-none
            transition-colors
            duration-200
          "
          href="https://github.com/haoranpb/blockchain-business-development"
        >
          <span class="text-gray-700">
            <span class="hidden sm:inline text-gray-500" aria-hidden="true">
              $
            </span>
            help us become better!
          </span>
        </OutboundLink>
      </div>
    </section>
  </div>
</template>

<script>
import OutboundLink from '@/components/OutboundLink.vue'

export default {
  components: {
    OutboundLink,
  },
}
</script>
