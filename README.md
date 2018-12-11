# Patchfox
This is a new client for [Secure Scuttlebutt](http://scuttlebutt.nz) packaged as a Web Extension for Firefox.

## Requirements

* [Firefox Developer Edition](https://www.mozilla.org/en-US/firefox/developer/)
* [Scuttle Shell](https://github.com/ssbc/scuttle-shell)

## Building

`
$ npm run dev
`

This will launch [Firefox Developer Edition](https://www.mozilla.org/en-US/firefox/developer/) running the WebExtension, you need to click on the little _hermie_ button on the toolbar to launch it.

## Setup inside Patchfox

Once patchfox is running, it needs to learn your _remote_ and _secret_, you can just click the "browse" button on the setup screen and select your `.ssb/secret` file and then click save. 

Patchfox will then verify the configuration, if you're not running scuttle-shell, it will ask you if you want to run it.