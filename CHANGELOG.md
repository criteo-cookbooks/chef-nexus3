# Changelog

## 4.0.0 2020-05-05

- Task creation is now more generic. This change is breaking with any previous
  usage of tasks. Please have a look at api_examples/task.rb for integration

## 3.6.0 2019-12-16

- Knob to configure outbound proxy #106
- Bump nexus3 to 3.20 with fixed cleanup_policy script #107

## 3.5.0 2019-12-06

- Set the Nexus admin password when the repo is setup #105
- Fix support for multiple instances on linux #104

## 3.4.1 2019-10-29

- Support Multi-policy Cleanup on repo creation

## 3.4.0 2019-10-18

- Pin faraday to version compatible with this cookbook
- Bump to latest version 3.19.1
- Update tests to change admin password as it is not the default
  anymore, it is generated randomly at installation.

## 3.3.0 2019-06-26

- Fix a bug where last option in vmoptions would be ignored

## 3.2.0 2019-06-13

- Make scripts helper usable by other cookbooks.
  - This lets you easily register scripts which reside in your own cookbooks.
- Bump nexus3 version to 3.16.2

## 3.1.0 2019-04-03

A lot of changes went into this release.

- Capture Errno::EHOSTUNREACH exception.
  - It was raising an exception rather than retrying on first converge.
- Stop depending on an outdated Java installation for tests.
- Be more precise in setting the JVM options.
- Extend nexus.properties with application-port-ssl.
- Bump nexus3 version to 3.15.2.
- Add nexus3_cleanup_policy resource.
  - This lets you define new cleanup polices for your repositories.
- Add nexus3_realm resource.
  - This lets you handle activation on secutiry realm.

## 3.0.0 2018-06-15

A lot of changes went into this release.

- Made Nexus3 installation a resource to support multi-tenancy.
  - SysVinit or Systemd Linux systems are supported, as well as Windows.
  - JVM settings are attribute-driven.
- Users, groups, repositories, roles and tasks can now be created via
  resources.
  - All these functions are supported by Groovy scripts uploaded to the Nexus3
    via its REST API.
- An API resource does most of the job of talking to Nexus3 for all
  operations.
- All operations are idempotent and will wait on Nexus3 startup.
- A comprehensive test suite is included (ChefSpec and Kitchen/ServerSpec)
- Criteo took over maintenance of the cookbook (Thank you Dennis for your hard
  work supporting the cookbook previously!)

## 2.1.0 2017-03-14

- Add another variable to nexus.properties.erb to configure nexus-args

## 2.0.1 2017-03-08

- Update uninstall so it doesn't delete the entire contents of /opt

## 2.0.0 2016-12-17

- Refactor for 3.1

## 1.0.0 2016-11-14

- Fix #17 nexus 3.1.0 config file location changed

## 0.9.2 2016-10-14

- Fix #16 Fixes version regex that matches host-name when containing digits 

## 0.9.1 2016-09-06

- Fix #13 Wrong home folder

## 0.9.0 2016-09-05

- Make application-host configurable

## 0.8.0 2016-08-20

- Fix #11 Do not set user home to path dir

## 0.7.0 2016-08-19

- Replace root attribute with path
- Fix #10 nexus3_api ignore_failure attribute defaults to false 

## 0.6.0 2016-08-15

- Fix #9 Why_run/converge_by causes notifies to fire when no changes

## 0.5.0 2016-08-13

- Resolve #5 Add support for Windows configuration

## 0.4.0 2016-08-11

- Wait for Nexus Rest API endpoint to respond
- Replace vmoptions attribute with template

## 0.3.0 2016-08-08

- Fix #4 Support Windows install
- Fix #6 Change install directory to closely match docker image

## 0.2.1 2016-08-01

- Fix #2 Custom url issue

## 0.2.0 2016-07-29

- Add REST API

## 0.1.1 2016-07-28

- Fix #1 FileNotFoundException due to Chef searching for template files in a wrapper cookbook

## 0.1.0 2016-07-26

- Initial beta release
