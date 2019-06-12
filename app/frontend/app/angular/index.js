import angular from 'angular'
require('angular-aria')
require('angular-animate')
require('angular-messages')
import ngRoute from 'angular-route'
import ngResource from 'angular-resource'
import ngMaterial from 'angular-material'

// import { HeroDetailComponent } from '../angular2/hero-detail.component';
// import { downgradeComponent } from '@angular/upgrade/static';

angular
  .module('inpharmd', [
    ngRoute,
    ngResource,
    ngMaterial
  ])
  .config(function ($mdThemingProvider) {
    $mdThemingProvider.theme('default')
    .primaryPalette('red', {
      'default': '400', // by default use shade 400 from the pink palette for primary intentions
      'hue-1': '100', // use shade 100 for the <code>md-hue-1</code> class
      'hue-2': '600', // use shade 600 for the <code>md-hue-2</code> class
      'hue-3': 'A100' // use shade A100 for the <code>md-hue-3</code> class
    })
    // If you specify less than all of the keys, it will inherit from the
    // default shades
    .accentPalette('blue', {
      'default': '200' // use shade 200 for default, and keep all other shades the same
    })

  })
  // .directive(
    // 'heroDetail',
    // downgradeComponent({component: HeroDetailComponent}) as angular.IDirectiveFactory
  // )

// angular.bootstrap(document.body, ['inpharmd'], { cloak: true })

module.exports = angular.module('inpharmd')
