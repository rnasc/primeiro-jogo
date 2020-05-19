const { environment } = require('@rails/webpacker')
const webpack = require('webpack')

environment.plugins.append('Provide',
  new webpack.ProvidePlugin({
    // $: 'jquery/src/jquery',
    // jQuery: 'jquery/src/jquery',
    $: 'jquery',
    jQuery: 'jquery',
    jq: 'jquery',
    jquery: 'jquery',
    Popper: ['popper.js', 'default'],
    'window.$': 'jquery',
    'window.jQuery': 'jquery',
    Waves: 'node-waves'
  })
)

const aliasConfig = {
  'jquery': 'jquery-ui-dist/external/jquery/jquery.js',
  'jquery-ui': 'jquery-ui-dist/jquery-ui.js'
};

environment.config.set('resolve.alias', aliasConfig);
module.exports = environment