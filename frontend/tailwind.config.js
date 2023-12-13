/** @type {import('tailwindcss').Config} */
export default {
  content: ['./src/**/*.{html,js,svelte,ts}'],
  theme: {
    extend: {},
    borderWidth: {
      "0": "0px",
      "1": "1px"
    },
    colors: {
      "black": "#000000",
      "primary": "#9FC200",
      "primary-transparent": "rgba(159,194,0,0.2)",
      "gold": "#EEA900",
      "gold-transparent": "rgba(238,169,0,0.2)",
      "light-brown": "#371f19",
      "dark-brown": "rgb(36, 21, 18)"
    }
  },
  plugins: [],
}

