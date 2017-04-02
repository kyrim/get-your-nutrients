var gulp = require('gulp');
var elm = require('gulp-elm');
var plumber = require('gulp-plumber');
var merge = require('gulp-merge');
var concat = require('gulp-concat');
const babel = require('gulp-babel');

var elmMain = 'web/elm/Main.elm'

gulp.task('elm-init', elm.init);

gulp.task('elm', ['elm-init'], function() {
    var phoenixJs = gulp.src([
        'deps/phoenix/priv/static/phoenix.js', 
        'deps/phoenix_html/priv/static/phoenix_html.js'
    ]);    

    var elmJs = gulp.src(elmMain).pipe(elm());
    var appJs = gulp.src("web/static/js/app.js").pipe(babel());
    var socketJs = gulp.src("web/static/js/socket.js").pipe(babel());

    return merge(phoenixJs, elmJs, socketJs, appJs)
        .pipe(concat('app.js'))
        .pipe(gulp.dest('priv/static/js/'));
});

//==================WATCHERS=====================

var elmWatchPaths = [
 'web/elm/**/*.elm'
];

gulp.task('watch', ['elm'], function() {
  // ELM
  gulp.watch(elmWatchPaths, ['elm']);
});