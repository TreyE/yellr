const XunitViewer = require('xunit-viewer/cli')
const result = XunitViewer({
    results: '../test-junit-report.xml',
    suites: [],
    xml: '',
    ignore: [],
    output: "./elixir/index.html",
    title: 'Yellr',
    port: false,
    watch: false,
    color: true,
    filter: {},
    format: 'html'
})
