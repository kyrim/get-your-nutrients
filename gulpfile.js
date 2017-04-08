var gulp = require('gulp');
var elm = require('gulp-elm');
var elmCss = require('elm-css');
var browserify = require('browserify');
var babel = require('babelify');
var source = require('vinyl-source-stream');
var plumber = require('gulp-plumber');

var tasks = {
  elmInit: 'elm-init',
  elmCompile: 'elm-compile',
  elmCssCompile: 'elm-css-compile',
  css: 'css',
  browserify: 'browserify',
  static: 'static',
  watch: 'watch'
}

var paths = {
  sourceJsFolder: 'web/static/js/',
  destinationJsFolder: 'priv/static/js/',

  sourceAssetsFolder: 'web/static/assets/**/*.*',
  destinationAssetsFolder: 'priv/static/',

  sourceElmCssFolder: 'web/elm/',
  sourceElmCssFile: 'Stylesheets.elm',
  destinationElmCssFile: 'priv/static/css/',

  elmWatchPath: 'web/elm/**/*.elm',
  elmEntryFile: 'web/elm/Main.elm',
  elmOutputFile: 'web/static/js/Main.js',

  appEntryFile: 'web/static/js/app.js',
  appOutputFile: 'app.js',

  phoenixPaths: [
    'deps/phoenix/priv/static/phoenix.js',
    'deps/phoenix_html/priv/static/phoenix_html.js'
  ]
}

gulp.task(tasks.elmInit, elm.init);

gulp.task(tasks.elmCompile, [tasks.elmInit], function () {
  return gulp.src(paths.elmEntryFile)
    .pipe(plumber())
    .pipe(elm())
    .pipe(gulp.dest(paths.sourceJsFolder));
});

gulp.task(tasks.browserify, [tasks.elmCompile], function () {
  return browserify(paths.appEntryFile, { debug: true })
    .transform(babel, {
      ignore: [paths.elmOutputFile],
      presets: ["es2015"]
    })
    .bundle()
    .pipe(source(paths.appOutputFile))
    .pipe(gulp.dest(paths.destinationJsFolder));
});

gulp.task(tasks.elmCssCompile, function() {
  var rootDir = process.cwd() + "/";

  return elmCss(
      rootDir,
      rootDir + paths.sourceElmCssFolder + paths.sourceElmCssFile,
      rootDir + paths.destinationElmCssFile
    )
});

gulp.task(tasks.static, function () {
  return gulp.src(paths.sourceAssetsFolder)
    .pipe(gulp.dest(paths.destinationAssetsFolder));
});

//==================WATCHERS=====================
gulp.task(tasks.watch, [tasks.static, tasks.browserify, tasks.elmCssCompile], function () {
  gulp.watch(paths.elmWatchPath, [tasks.browserify, tasks.elmCssCompile]);
  gulp.watch(paths.sourceAssetsFolder, [tasks.static]);
});