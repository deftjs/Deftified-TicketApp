var gulp = require('gulp'),
    coffee = require('gulp-coffee'),
    lint = require('gulp-coffeelint');

gulp.task('coffee', function() {
  gulp.src('./apps/ticket-app/app/coffee/**/*.coffee')
      .pipe(coffee({ bare: true, sourceMap: true }))
      .pipe(gulp.dest('./apps/ticket-app/app/js'));
});

gulp.task('lint', function() {
  gulp.src('./apps/ticket-app/app/coffee/**/*.coffee')
    .pipe(lint())
    .pipe(lint.reporter());
});

gulp.task('scripts', [ 'lint', 'coffee' ]);

gulp.task('default', [ 'scripts' ]);

gulp.task('watch', [ 'scripts' ], function() {
  gulp
    .watch('./apps/ticket-app/app/coffee/**/*.coffee', [ 'scripts' ]);
});
