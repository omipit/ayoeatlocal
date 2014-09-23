module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")

    uglify:
      options:
        mangle: false
        compress:
          drop_console: true
      all:
        files:
          "js/build/tbs-all.min.js" : ["js/tbs-all.js"]

    php:
      dist:
        options:
          port: 8000
          open: false
          keepalive: false
          hostname: '0.0.0.0'
      watch: {}


    wiredep:
      target:
        src: [
          'index.php',   #// .html support...
          'partials/footer.php',   #// .html support...

        ]
        options: 
          cwd: ''
          dependencies: true
          devDependencies: false
          exclude: []
          fileTypes: {}
          ignorePath: ''
          overrides: {}
          
    compass:
      dist:
        options:
          config: "config/compass.rb"
    
    # coffeescript task
    coffee:
      compile:
        options:
          sourceMap: true
          join: true
          bare: true
        files:
          'js/bundle.js': ['client/scripts/**/*.js', 'coffee/**/*.coffee']



    # browsersync
    browserSync:
      dev:
        bsFiles:
          src : [ 'css/*.css', "**/*.php", "js/*.js"]
        options:
          proxy: "0.0.0.0"
          watchTask: true # < VERY important
          port: 8000


    # imageoptimization
    imagemin:
      dist:
        files: [
          expand: true
          cwd: 'images'
          src: '{,*/}*.{gif,jpeg,jpg,png,svg}'
          dest: 'images/min'
        ]

    # build a modernizr file based on scanning the files
    modernizr:
      dist:
        # [REQUIRED] Path to the build you're using for development.
        "devFile" : "bower_components/modernizr/modernizr.js"
        # [REQUIRED] Path to save out the built file.
        "outputFile" : "js/modernizr-custom.js"

        extra :
           "shiv" : true
           "cssclasses" : true

        extensibility: [
          "teststyles" : true,
          "testallprops" : true
          "addtest" : true
          "prefixed" : true
          "hasevents" : true
        ]

        # "tests" : [
        #   'css_filters'
        # ]

        files:
          src: [
            'js/**/*.js',
            'css/**/*.css',
            'scss/*.scss'
          ]
        "matchCommunityTests" : true



    # watch for gruntfile changes
    watch:
      grunt:
        files: ["Gruntfile.coffee"]

      compass:
        files: "scss/**/*.scss"
        tasks: ["compass"]
     
      # watch the coffeescript files in the coffee folder
      coffee:
        files: "coffee/**/*.coffee"
        tasks: ["coffee"]
      
      # if js files change,  run the uglify task to minify them
      livereload:
        files: [
          "js/**/*.js"
          "css/**/*.css"
          "**/*.php"
        ]
        options:
          livereload: true

  
  # tasks: ['uglify']
  grunt.loadNpmTasks "grunt-php"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-compass"
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks 'grunt-browser-sync'
  grunt.loadNpmTasks 'grunt-wiredep'
  grunt.loadNpmTasks 'grunt-contrib-imagemin'
  grunt.loadNpmTasks "grunt-modernizr"

  # grunt.registerTask('build', ['sass']);
  grunt.registerTask "default", ["php:dist","browserSync" ,"watch"]
  grunt.registerTask "build", ["uglify"]

