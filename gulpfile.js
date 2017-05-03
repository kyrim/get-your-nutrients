var gulp = require('gulp');
var elm = require('gulp-elm');
var fs = require ('fs');
var elmCss = require('elm-css');
var browserify = require('browserify');
var babel = require('babelify');
var source = require('vinyl-source-stream');
var plumber = require('gulp-plumber');

var provisionData = require('./provisionData');

var tasks = {
  elmInit: 'elm-init',
  elmCompile: 'elm-compile',
  elmCssCompile: 'elm-css-compile',
  css: 'css',
  browserify: 'browserify',
  static: 'static',
  watch: 'watch',
  buildAll: 'build-all',
  provisionData: 'provision-data'
}

var paths = {
  sourceJsFolder: 'src/js/',
  destinationJsFolder: 'dist/js/',

  sourceAssetsFolder: 'src/assets/**/*.*',
  destinationAssetsFolder: 'dist/',

  sourceElmCssFolder: 'src/elm/',
  sourceElmCssFile: 'Stylesheets.elm',
  destinationElmCssFile: 'dist/css/',

  elmWatchPath: 'src/elm/**/*.elm',
  elmEntryFile: 'src/elm/Main.elm',
  elmOutputFile: 'src/js/Main.js',

  appEntryFile: 'src/js/app.js',
  appOutputFile: 'app.js'
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
    .transform({
  global: true
}, 'uglifyify')
    .bundle()
    .pipe(source(paths.appOutputFile))
    .pipe(gulp.dest(paths.destinationJsFolder));
});

gulp.task(tasks.elmCssCompile, function() {
  var rootDir = process.cwd() + "/";
  var elmcssDir = rootDir + paths.destinationElmCssFile;

  if (!fs.existsSync(elmcssDir)) fs.mkdirSync(elmcssDir);

  return elmCss(
      rootDir,
      rootDir + paths.sourceElmCssFolder + paths.sourceElmCssFile,
      elmcssDir
    )
});

gulp.task(tasks.static, function () {
  return gulp.src(paths.sourceAssetsFolder)
    .pipe(gulp.dest(paths.destinationAssetsFolder));
});

gulp.task(tasks.provisionData, function() {
  return provisionData('data/', 'src/js/data.json');
});

gulp.task(tasks.buildAll, [tasks.static, tasks.browserify, tasks.elmCssCompile]);

//==================WATCHERS=====================
gulp.task(tasks.watch, [tasks.static, tasks.browserify, tasks.elmCssCompile], function () {
  gulp.watch(paths.elmWatchPath, [tasks.browserify, tasks.elmCssCompile]);
  gulp.watch(paths.sourceAssetsFolder, [tasks.static]);
});