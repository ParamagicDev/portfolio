// https://tailwindcss.com/docs/controlling-file-size#setting-up-purgecss
const purgecss = require('@fullhuman/postcss-purgecss')({
  // Specify the paths to all of the template files in your project 
  content: [
    './dist/**/*.html'
  ],

  // Include any special characters you're using in this regular expression
  defaultExtractor: content => content.match(/[A-Za-z0-9-_:/]+/g) || []
})

module.exports = {
  theme: {
    extend: {},
    fontSize: {
      '8xl': '6rem'
    },
    backgroundColor: theme => ({
      'primary': '#444',
      'secondary': '#eece1a'
    })
  },
  variants: {},
  plugins: [
    require('postcss-import'),
    require('tailwindcss'),
    require('postcss-color-function'),
    require('autoprefixer'),
    ...process.env.NODE_ENV === 'production'
    ? [purgecss]
    : []
  ]
}
