var path = require('path')
var webpack = require('webpack')
var BowerWebpackPlugin = require("bower-webpack-plugin")
var failPlugin = require('webpack-fail-plugin')

var APP_DIR = path.resolve(__dirname, 'app', 'frontend')
const PATHS = {
  app: APP_DIR,
  style: APP_DIR + '/styles',
  javascript: APP_DIR + '/javascripts'
}
//
var config = module.exports = {
  // the base path which will be used to resolve entry points
  context: __dirname,
  debug: true,
  entry: {
    admin: APP_DIR + '/admin.entry.js',
    research: APP_DIR + '/research.entry.js',
    "healthcare.ie8": [
      "es5-shim",
      "es5-shim/es5-sham",
      "ie8",
      APP_DIR + '/healthcare.ie8.entry.js'
    ],
    "healthcare.modern": [
      APP_DIR + '/healthcare.modern.entry.js'
    ]
  },
  module: {
    noParse: [
      /jquery-ujs/,
    ],
    loaders: [
      { test: /\.coffee$/, loader: "coffee" },
      { test: /\.json$/, loader: "json" },
      {
        test: /\.jsx?/,
        include: PATHS.app,
        loaders: ['babel']
      },
      { test: /\.css$/, loader: "style!css" },
      {
        test: /\.less$/,
        loader: "style!css!less",
        include: PATHS.style
      },
      { test: /\.scss/, loader: "style!css!sass" },
      // Exposure
      { test: require.resolve('jquery'), loader: 'expose?jQuery!expose?$' },
      { test: require.resolve("chartkick"), loaders: [
          'babel',
          'expose?Chartkick'
        ]
      },
      { test: require.resolve("highcharts"), loaders: [
          'babel',
          'expose?Highcharts'
        ]
      },
      { test: /angular/, loaders: [
         'babel'
       ]
      },
      // Shims
      { test: /jquery(\.|-)(.+)\.js/, loaders: [
         'babel',
         'exports?$'
       ]
      },
      { test: require.resolve("chosen-js"), loaders: [
         'babel',
         'exports?$'
       ]
      },
      // TinyMCE
      {
        test: require.resolve('tinymce/tinymce'),
        loaders: [
          'babel',
          'imports?this=>window',
          'exports?window.tinymce'
        ]
      },
      {
        test: /tinymce\/(themes|plugins)\//,
        loaders: [
          'babel',
          'imports?this=>window'
        ]
      },
      {
          test: /\.png$/,
          loader: "url",
          query: { mimetype: "image/png" }
      },
      // all files with a `.ts` or `.tsx` extension will be handled by `ts`
      { test: /\.tsx?$/, loader: 'ts' }
    ]
  }
}

config.output = {
  // this is our app/assets/javascripts directory, which is part of the Sprockets pipeline
  path: path.join(__dirname, 'app', 'assets', 'javascripts'),
  // the filename of the compiled bundle, e.g. app/assets/javascripts/bundle.js
  filename: '[name].entry.js',
  // if the webpack code-splitting feature is enabled, this is the path it'll use to download bundles
  publicPath: 'http://localhost:8080/assets', // Required for webpack-dev-server
  devtoolModuleFilenameTemplate: '[resourcePath]',
  devtoolFallbackModuleFilenameTemplate: '[resourcePath]?[hash]'
}

config.resolveLoader = {
  root: [
    path.join(__dirname, 'node_modules'),
    path.join(__dirname, 'bower_components')
  ]
}

config.resolve = {
  root: [
    path.join(__dirname, 'node_modules'),
    path.join(__dirname, 'bower_components')
  ],
  // tell webpack which extensions to auto search when it resolves modules. With this,
  // you'll be able to do `require('./utils')` instead of `require('./utils.js')`
  extensions: ['', '.js', '.jsx', '.json', '.coffee', '.ts', '.tsx'],
  // by default, webpack will search in `web_modules` and `node_modules`. Because we're using
  // Bower, we want it to look in there too
  modulesDirectories: [ 'node_modules', 'bower_components', 'lib', 'styles' ],
  alias: {
      'jquery.bootstrap-tag': 'bootstrap-tag/js/bootstrap-tag.js',
      'bootstrap-tag.less': 'bootstrap-tag/less/bootstrap-tag.less'
    }
}

config.plugins = [
  new webpack.NoErrorsPlugin(),
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    jquery: 'jquery'
  }),
  new webpack.ResolverPlugin(
     new webpack.ResolverPlugin.DirectoryDescriptionFilePlugin('.bower.json', ['main','name'])
     , ["normal", "loader"]
  ),
  failPlugin,
  // new BowerWebpackPlugin({
  //   modulesDirectories: ["bower_components"],
  //   manifestFiles:      "bower.json",
  //   includes:           /.*/,
  //   excludes:           [],
  //   searchResolveModulesDirectories: true
  // })
]
