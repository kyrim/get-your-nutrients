var gulp = require('gulp');
var elm = require('gulp-elm');
var fs = require('fs');
var elmCss = require('elm-css');
var browserify = require('browserify');
var babel = require('babelify');
var source = require('vinyl-source-stream');
var plumber = require('gulp-plumber');

var provisionData = require('./data/provisionData');

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
  sourceJsFolder: 'client/js/',
  destinationJsFolder: 'dist/js/',

  sourceAssetsFolder: 'client/assets/**/*.*',
  destinationAssetsFolder: 'dist/',

  sourceElmCssFolder: 'client/elm/',
  sourceElmCssFile: 'Stylesheets.elm',
  destinationElmCssFile: 'dist/css/',

  elmWatchPath: 'client/elm/**/*.elm',
  elmEntryFile: 'client/elm/Main.elm',
  elmOutputFile: 'client/js/Main.js',

  appEntryFile: 'client/js/app.js',
  appOutputFile: 'app.js'
}
function createDirRecursive(dir) {
  dir.split('/')
    .reduce((path, folder) => {
      path += folder + '/';
      if (!fs.existsSync(path)) {
        fs.mkdirSync(path);
      }
      return path;
    }, '');
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

gulp.task(tasks.elmCssCompile, function () {
  var rootDir = process.cwd() + "/";
  var elmcssDir = rootDir + paths.destinationElmCssFile;

  if (!fs.existsSync(elmcssDir)) createDirRecursive(elmcssDir);

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

gulp.task(tasks.provisionData, function () {
  return provisionData('data/', 'data/foods.json', 'client/js/searchableFoods.json', 'client/js/nutrients.json');
});

gulp.task(tasks.buildAll, [tasks.static, tasks.provisionData, tasks.browserify, tasks.elmCssCompile]);

//==================WATCHERS=====================
gulp.task(tasks.watch, [tasks.static, tasks.browserify, tasks.elmCssCompile], function () {
  gulp.watch(paths.elmWatchPath, [tasks.browserify, tasks.elmCssCompile]);
  gulp.watch(paths.sourceAssetsFolder, [tasks.static]);
});