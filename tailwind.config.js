/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./app/views/**/*.{html,erb}",
    "./app/helpers/**/*.rb",
    "./app/components/**/*.{html,erb}",
    "./app/assets/stylesheets/**/*.css",
    "./app/javascript/**/*.js",
  ],
  theme: {
    extend: {
      colors: {
        brand: {
        },
      },
      maxWidth: {
        'screen-1200': '1200px',
      },
    },
  },
  plugins: [],
};