var gulp = require('gulp');
var elm = require('gulp-elm');
var browserify = require('browserify');
var babel = require('babelify');
var runSequence = require('run-sequence');
var source = require('vinyl-source-stream');

var elmMain = 'web/elm/Main.elm'

var phoenixPaths = [
    'deps/phoenix/priv/static/phoenix.js', 
    'deps/phoenix_html/priv/static/phoenix_html.js'
];

gulp.task('elm-init', elm.init);

gulp.task('elm', ['elm-init'], function() {
    return gulp.src(elmMain)
        .pipe(elm())
        .pipe(gulp.dest('web/static/js/'));
});

gulp.task('browserify', function() {
    return browserify('web/static/js/app.js', {debug: true})
      .transform(babel, {
          ignore: ['web/static/js/Main.js'],
          presets: ["es2015"]
        })
      .bundle()
      .pipe(source("app.js"))
      .pipe(gulp.dest('priv/static/js/'));
});

gulp.task('build', function(callback) {
  runSequence('elm', 'browserify', callback);
});

//==================WATCHERS=====================

var elmWatchPaths = [
 'web/elm/**/*.elm'
];

gulp.task('watch', ['build'], function() {
  // ELM
  gulp.watch(elmWatchPaths, ['build']);
});