# gruntjs.com
module.exports = (grunt) ->
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)

  grunt.initConfig
    sass:
      dist:
        files:
          'dist/style.css': 'lib/style.scss'

    coffee:
      dist:
        files:
          'dist/dumper.js': 'lib/dumper.coffee'

    coffeelint:
      options:
        configFile: 'coffeelint.json'
      dist: [
        'lib/dumper.coffee'
      ]

    watch:
      options:
        livereload: 35729
      sass:
        files: [
          'lib/*.scss'
        ],
        tasks: 'sass'
      coffee:
        files: [
            'lib/*.coffee'
        ],
        tasks: ['coffeelint', 'coffee']

  grunt.registerTask 'default', ['watch']
