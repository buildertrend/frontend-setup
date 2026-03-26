# Changelog

## [3.0.0](https://github.com/buildertrend/product-toolkit/compare/v2.0.0...v3.0.0) (2026-03-26)


### ⚠ BREAKING CHANGES

* **frontend-setup:** Convert commands to skills

### Features

* Add branch management skill to guide users onto feature branches before making changes ([63b7513](https://github.com/buildertrend/product-toolkit/commit/63b75138c6623f85a6fffb45c970c2ecafbec589))
* Check for an existing copy of the project before downloading ([63a4f46](https://github.com/buildertrend/product-toolkit/commit/63a4f46c2e73e338183ba47505af541c30f779a6))
* Copy commands to clipboard when user needs to run them in another terminal ([c7f2832](https://github.com/buildertrend/product-toolkit/commit/c7f28320ad1ac0e314b3329fe69611b3b8932baa))
* **frontend-setup:** Connect Confluence during setup ([b1f43ed](https://github.com/buildertrend/product-toolkit/commit/b1f43ed41c9117bf443e3e52576488fdcd540119))
* **frontend-setup:** Convert commands to skills ([f43dd8f](https://github.com/buildertrend/product-toolkit/commit/f43dd8facd55572c90731fedfe593a203dbb1a75))


### Bug Fixes

* Clarify which password the user needs at each step ([bfdb600](https://github.com/buildertrend/product-toolkit/commit/bfdb600d22ec9063262b806385ec787b903be0f0))
* Strengthen the instruction to avoid combining shell commands ([861f920](https://github.com/buildertrend/product-toolkit/commit/861f92024ba32c0ba2dff7f6c47637cafeab44bc))

## [2.0.0](https://github.com/buildertrend/product-toolkit/compare/v1.1.0...v2.0.0) (2026-03-25)


### ⚠ BREAKING CHANGES

* Rename the setup command from /frontend-setup:frontend-setup to /frontend-setup:start
* Rename marketplace to product-toolkit

### Features

* Add a preview command to start the dev server and open the frontend ([c43e344](https://github.com/buildertrend/product-toolkit/commit/c43e344a4cba7f7fe74877706d080f8b13082ec1))
* Rename the setup command from /frontend-setup:frontend-setup to /frontend-setup:start ([4c70807](https://github.com/buildertrend/product-toolkit/commit/4c70807d9746dc6c364cab23b774e6977a3ceb48))
* Walk users through connecting Figma and Azure DevOps during setup ([d49ded6](https://github.com/buildertrend/product-toolkit/commit/d49ded665ccfbbf904ccf0917b7b1abf50ed97a0))


### Bug Fixes

* Clarify that sudo may or may not prompt for a password ([dfc9b81](https://github.com/buildertrend/product-toolkit/commit/dfc9b8183b965bbf36b645d26507d0e59cef40cf))
* Have the user run package auth themselves so the browser actually opens ([d200ded](https://github.com/buildertrend/product-toolkit/commit/d200ded18c5a2c007d977ea4e4174007959ebb90))
* Stop blocking unrelated commands when the plugin is installed ([f768a6e](https://github.com/buildertrend/product-toolkit/commit/f768a6e0f3775fa2ffdb75ff496099e547d61772))


### Miscellaneous Chores

* Rename marketplace to product-toolkit ([450f41f](https://github.com/buildertrend/product-toolkit/commit/450f41ffa575d82b7c1c51a4677952a3e5c7b28c))

## [1.1.0](https://github.com/buildertrend/frontend-setup/compare/v1.0.0...v1.1.0) (2026-03-25)


### Features

* Add hosts file setup step for local.buildertrend.net ([c98f106](https://github.com/buildertrend/frontend-setup/commit/c98f106c4447def269fdf8ed5e4cd512dbda49ae))
* Add initial plugin structure ([1c250ab](https://github.com/buildertrend/frontend-setup/commit/1c250ab82e1cf8f7eb86f716f6e12a790a6a1fbc))
* Check if the dev server is already running before starting a new one ([a1ed074](https://github.com/buildertrend/frontend-setup/commit/a1ed07483076889cc29d6fdcfdfcd57f8854f64d))
* Migrate to PermissionRequest API and add CI tests ([f89b6c6](https://github.com/buildertrend/frontend-setup/commit/f89b6c6a012dcef0e205c48251e2e38d0d2c369a))
* Update plugin name and rewrite setup steps ([db53976](https://github.com/buildertrend/frontend-setup/commit/db53976e0a6432d49e748d8521e2439101a2b26e))


### Bug Fixes

* Allow the setup tool to search inside files ([bd1c9be](https://github.com/buildertrend/frontend-setup/commit/bd1c9be2af262b2c6aaf25ff6f7cd50396655835))
* Block shell operator injection and use deny API ([1ed575c](https://github.com/buildertrend/frontend-setup/commit/1ed575c2c9b95c9f961b8b6c362f884158c26c6a))
* Correct approve-commands hook configuration ([929aaf1](https://github.com/buildertrend/frontend-setup/commit/929aaf1c102e9dce3fe3a82509c3ca7b5b4b7f1c))
* Correct ordered list numbering in setup command ([71ebc5a](https://github.com/buildertrend/frontend-setup/commit/71ebc5a32dbd8bd17b7f32f57e106768d7c5478a))
* Correct plugin name references in README ([d55cf0b](https://github.com/buildertrend/frontend-setup/commit/d55cf0ba430402858159f065cd15b83a9867f5c2))
* Remove command substitution and eval for security ([0081431](https://github.com/buildertrend/frontend-setup/commit/00814317951d286751741ffeb63d81cc5a64f7bf))
* Resolve markdown lint issue in setup command ([a7d30a0](https://github.com/buildertrend/frontend-setup/commit/a7d30a0edc3d3f67f5bdc1dafac407dcfd9a950e))
* Walk user through hosts file command instead of running it directly ([9e09ca8](https://github.com/buildertrend/frontend-setup/commit/9e09ca8d1701ca304fa8d08a514da16801b066cf))
