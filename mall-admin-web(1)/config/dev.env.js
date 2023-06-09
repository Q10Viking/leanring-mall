'use strict'
const merge = require('webpack-merge')
const prodEnv = require('./prod.env')

module.exports = merge(prodEnv, {
  NODE_ENV: '"development"',
  BASE_API: '"http://localhost:8081"'
  // BASE_API: '"http://192.168.65.220:8081"'
  //BASE_API: '"http://localhost:8201/mall-admin/"'
})
