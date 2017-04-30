const gulp = require('gulp')
const gulpif = require('gulp-if')
const haxe = require('gulp-haxe')
const uglify = require('gulp-uglify')

function build(release) {
  return haxe('build.hxml')
    .pipe(gulpif(release, uglify()))
    .pipe(gulp.dest(''))
}

gulp.task('build', function() {
  return build(true)
})

gulp.task('build-dev', function() {
  return build(false)
})

gulp.task('watch', function() {
  build(false)
  gulp.watch(['src/**/*.hx'], ['build-dev'])
})

gulp.task('default', ['build'])
