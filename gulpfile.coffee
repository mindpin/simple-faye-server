gulp    = require "gulp"
util    = require 'gulp-util'

coffee  = require "gulp-coffee"
# 防止编译 coffee 过程中 watch 进程中止
plumber = require 'gulp-plumber'

haml    = require 'gulp-ruby-haml'

sass    = require 'gulp-ruby-sass'

options =
  coffee2js:
    src:
      coffee: "demo/src/coffee/**/*.coffee"
    dist:
      js: "demo/dist/js"
  haml2html:
    src:
      haml: "demo/src/index.haml"
    dist:
      html: "demo/dist"
  scss2css:
    src:
      scss: "demo/src/scss"
      scss_file: "demo/src/scss/*.scss"
    dist:
      css: "demo/dist/css"
  css2css:
    src:
      css: "demo/src/css/**/*.css"
    dist:
      css: "demo/dist/css"

gulp.task "coffee2js", ->
  gulp.src options.coffee2js.src.coffee
    .pipe plumber()
    .pipe coffee()
    .pipe gulp.dest(options.coffee2js.dist.js)

gulp.task "haml2html", ->
  gulp.src options.haml2html.src.haml
    .pipe haml()
    .on "error", (err)->
      util.log [
        err.plugin,
        util.colors.red err.message
        err.message
      ].join " "
    .pipe gulp.dest(options.haml2html.dist.html)


gulp.task "scss2css", ->
  return sass options.scss2css.src.scss
  .on "error", (err)->
    console.error "Error!", err.message
  .pipe gulp.dest(options.scss2css.dist.css)

gulp.task "css2css", ->
  gulp.src options.css2css.src.css
    .pipe gulp.dest(options.css2css.dist.css)


gulp.task "build", ["coffee2js", "haml2html", "scss2css", "css2css"]

gulp.task 'watch', ['build'], ->
  gulp.watch options.coffee2js.src.coffee, ['coffee2js']
  gulp.watch options.haml2html.src.haml, ['haml2html']
  gulp.watch options.scss2css.src.scss_file, ['scss2css']
  gulp.watch options.css2css.src.css, ['css2css']
