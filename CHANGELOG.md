# Change Log

## [v0.7.1](https://github.com/tumugi/tumugi/tree/v0.7.1) (2017-01-07)
[Full Changelog](https://github.com/tumugi/tumugi/compare/v0.7.0...v0.7.1)

**Fixed bugs:**

- Local file target misses some data on Linux \(Ubuntu\) [\#139](https://github.com/tumugi/tumugi/issues/139)

**Merged pull requests:**

- Fix local\_file target result unstable. [\#141](https://github.com/tumugi/tumugi/pull/141) ([hakobera](https://github.com/hakobera))

## [v0.7.0](https://github.com/tumugi/tumugi/tree/v0.7.0) (2016-11-01)
[Full Changelog](https://github.com/tumugi/tumugi/compare/v0.6.3...v0.7.0)

**Implemented enhancements:**

- Force run all tasks in a workflow [\#125](https://github.com/tumugi/tumugi/issues/125)
- Custom callback on success/retry/failure for each task [\#122](https://github.com/tumugi/tumugi/issues/122)
- Add secret option for parameter [\#117](https://github.com/tumugi/tumugi/issues/117)
- Add log about elapsed time for each tasks and workflow [\#116](https://github.com/tumugi/tumugi/issues/116)
- \[Breaking Change\] Introduce subcommand of `tumugi new` [\#111](https://github.com/tumugi/tumugi/issues/111)

**Merged pull requests:**

- Prepare release for v0.7.0 [\#130](https://github.com/tumugi/tumugi/pull/130) ([hakobera](https://github.com/hakobera))
- Write workflow and task elapsed time to log [\#124](https://github.com/tumugi/tumugi/pull/124) ([hakobera](https://github.com/hakobera))
- Bumpup version to 0.7.0.dev [\#115](https://github.com/tumugi/tumugi/pull/115) ([hakobera](https://github.com/hakobera))
- Introduce success/failure event callback [\#128](https://github.com/tumugi/tumugi/pull/128) ([hakobera](https://github.com/hakobera))
- Support force run all tasks [\#127](https://github.com/tumugi/tumugi/pull/127) ([hakobera](https://github.com/hakobera))
- Filter coverage target files [\#121](https://github.com/tumugi/tumugi/pull/121) ([hakobera](https://github.com/hakobera))
- Test with jruby-9.1.5.0 on travis [\#120](https://github.com/tumugi/tumugi/pull/120) ([hakobera](https://github.com/hakobera))
- Introduce new sub commands [\#119](https://github.com/tumugi/tumugi/pull/119) ([hakobera](https://github.com/hakobera))
- Add param secret option [\#118](https://github.com/tumugi/tumugi/pull/118) ([hakobera](https://github.com/hakobera))

## [v0.6.3](https://github.com/tumugi/tumugi/tree/v0.6.3) (2016-08-13)
[Full Changelog](https://github.com/tumugi/tumugi/compare/v0.6.2...v0.6.3)

**Implemented enhancements:**

- Log tumugi version [\#113](https://github.com/tumugi/tumugi/pull/113) ([hakobera](https://github.com/hakobera))

**Fixed bugs:**

- Fix plugin template [\#112](https://github.com/tumugi/tumugi/pull/112) ([hakobera](https://github.com/hakobera))
- Fix commad failed error message [\#110](https://github.com/tumugi/tumugi/pull/110) ([hakobera](https://github.com/hakobera))

**Merged pull requests:**

- Prepare release for 0.6.3 [\#114](https://github.com/tumugi/tumugi/pull/114) ([hakobera](https://github.com/hakobera))

## [v0.6.2](https://github.com/tumugi/tumugi/tree/v0.6.2) (2016-08-02)
[Full Changelog](https://github.com/tumugi/tumugi/compare/v0.6.1...v0.6.2)

**Implemented enhancements:**

- Improve Log output [\#105](https://github.com/tumugi/tumugi/issues/105)

**Fixed bugs:**

- tumugi should abort when config file not found [\#108](https://github.com/tumugi/tumugi/issues/108)

**Merged pull requests:**

- Prepare release for 0.6.2 [\#109](https://github.com/tumugi/tumugi/pull/109) ([hakobera](https://github.com/hakobera))
- Improve and change logging [\#107](https://github.com/tumugi/tumugi/pull/107) ([hakobera](https://github.com/hakobera))

## [v0.6.1](https://github.com/tumugi/tumugi/tree/v0.6.1) (2016-07-10)
[Full Changelog](https://github.com/tumugi/tumugi/compare/v0.6.0...v0.6.1)

**Merged pull requests:**

- Prepare release for 0.6.1 [\#103](https://github.com/tumugi/tumugi/pull/103) ([hakobera](https://github.com/hakobera))
- Suppress unusable info log [\#102](https://github.com/tumugi/tumugi/pull/102) ([hakobera](https://github.com/hakobera))

## [v0.6.0](https://github.com/tumugi/tumugi/tree/v0.6.0) (2016-07-09)
[Full Changelog](https://github.com/tumugi/tumugi/compare/v0.5.3...v0.6.0)

**Implemented enhancements:**

- Refactoring executor [\#95](https://github.com/tumugi/tumugi/issues/95)
- Improve log [\#87](https://github.com/tumugi/tumugi/issues/87)
- DSL improvement [\#81](https://github.com/tumugi/tumugi/issues/81)
- param\_set accept block [\#53](https://github.com/tumugi/tumugi/issues/53)
- Plugin test helper [\#29](https://github.com/tumugi/tumugi/issues/29)
- Plugin template generator [\#28](https://github.com/tumugi/tumugi/issues/28)
- Add Tumugi.app which is alias of Tumugi.application [\#92](https://github.com/tumugi/tumugi/pull/92) ([hakobera](https://github.com/hakobera))
- Add short cut method to set parmeter in DSL [\#84](https://github.com/tumugi/tumugi/pull/84) ([hakobera](https://github.com/hakobera))
- Improve result table [\#83](https://github.com/tumugi/tumugi/pull/83) ([hakobera](https://github.com/hakobera))
- Introduce new DSL syntax: set [\#82](https://github.com/tumugi/tumugi/pull/82) ([hakobera](https://github.com/hakobera))

**Fixed bugs:**

- Fix result reporting failed if parameter type is not :string [\#96](https://github.com/tumugi/tumugi/pull/96) ([hakobera](https://github.com/hakobera))
- Fix task timeout logic [\#93](https://github.com/tumugi/tumugi/pull/93) ([hakobera](https://github.com/hakobera))

**Closed issues:**

- \[Breaking Change\] Remove auto\_bind feature and make accessible CLI param from task [\#88](https://github.com/tumugi/tumugi/issues/88)

**Merged pull requests:**

- Prepare release for 0.6.0 [\#101](https://github.com/tumugi/tumugi/pull/101) ([hakobera](https://github.com/hakobera))
- Remove File.exists? [\#100](https://github.com/tumugi/tumugi/pull/100) ([hakobera](https://github.com/hakobera))
- Remove development dependency: github\_changelog\_generator [\#98](https://github.com/tumugi/tumugi/pull/98) ([hakobera](https://github.com/hakobera))
- Refactoring executor [\#97](https://github.com/tumugi/tumugi/pull/97) ([hakobera](https://github.com/hakobera))
- Update README [\#94](https://github.com/tumugi/tumugi/pull/94) ([hakobera](https://github.com/hakobera))
- Test with jruby 9.1.2.0 on travis [\#91](https://github.com/tumugi/tumugi/pull/91) ([hakobera](https://github.com/hakobera))
- Add command to create plugin template project [\#90](https://github.com/tumugi/tumugi/pull/90) ([hakobera](https://github.com/hakobera))
- Improve log [\#89](https://github.com/tumugi/tumugi/pull/89) ([hakobera](https://github.com/hakobera))
- Add plugin test helper [\#86](https://github.com/tumugi/tumugi/pull/86) ([hakobera](https://github.com/hakobera))
- Parameter can be set by block [\#85](https://github.com/tumugi/tumugi/pull/85) ([hakobera](https://github.com/hakobera))

## [v0.5.3](https://github.com/tumugi/tumugi/tree/v0.5.3) (2016-06-14)
[Full Changelog](https://github.com/tumugi/tumugi/compare/v0.5.2...v0.5.3)

**Fixed bugs:**

- Fix logger not defiend in Tumugi::Config [\#79](https://github.com/tumugi/tumugi/pull/79) ([hakobera](https://github.com/hakobera))

**Merged pull requests:**

- Preapre release for 0.5.3 [\#80](https://github.com/tumugi/tumugi/pull/80) ([hakobera](https://github.com/hakobera))

## [v0.5.2](https://github.com/tumugi/tumugi/tree/v0.5.2) (2016-06-13)
[Full Changelog](https://github.com/tumugi/tumugi/compare/v0.5.1...v0.5.2)

**Implemented enhancements:**

- Add `to\_s` method to FileSystemTarget [\#73](https://github.com/tumugi/tumugi/issues/73)

**Fixed bugs:**

- Parameter should return `false` if default value is `false` [\#76](https://github.com/tumugi/tumugi/issues/76)

**Merged pull requests:**

- Prepare release for 0.5.2 [\#78](https://github.com/tumugi/tumugi/pull/78) ([hakobera](https://github.com/hakobera))
- when type is boolean and default value is false, it should return false [\#77](https://github.com/tumugi/tumugi/pull/77) ([hakobera](https://github.com/hakobera))
- Add to\_s method to FileSystemTarget [\#74](https://github.com/tumugi/tumugi/pull/74) ([hakobera](https://github.com/hakobera))

## [v0.5.1](https://github.com/tumugi/tumugi/tree/v0.5.1) (2016-05-29)
[Full Changelog](https://github.com/tumugi/tumugi/compare/v0.5.0...v0.5.1)

**Implemented enhancements:**

- \[Breaking Change\] Parameter auto bind feature is disabled as default [\#69](https://github.com/tumugi/tumugi/issues/69)
- Restruct FileSystemError [\#70](https://github.com/tumugi/tumugi/pull/70) ([hakobera](https://github.com/hakobera))

**Merged pull requests:**

- Prepare release for v0.5.1 [\#72](https://github.com/tumugi/tumugi/pull/72) ([hakobera](https://github.com/hakobera))
- Disable param auto binding feature as default [\#71](https://github.com/tumugi/tumugi/pull/71) ([hakobera](https://github.com/hakobera))

## [v0.5.0](https://github.com/tumugi/tumugi/tree/v0.5.0) (2016-05-26)
[Full Changelog](https://github.com/tumugi/tumugi/compare/v0.4.5...v0.5.0)

**Implemented enhancements:**

- Add ExternalTask as bundled plugin [\#61](https://github.com/tumugi/tumugi/issues/61)
- \[Breaking Change\] Tumugi.configure [\#60](https://github.com/tumugi/tumugi/issues/60)
- Better task scheduling [\#57](https://github.com/tumugi/tumugi/issues/57)
- \[Breaking Change\] Disable parameter auto binding from ENV [\#56](https://github.com/tumugi/tumugi/issues/56)
- Timeout feature [\#54](https://github.com/tumugi/tumugi/issues/54)
- \[Breaking Change\] Restruct Error class [\#51](https://github.com/tumugi/tumugi/issues/51)
- Enhance logger [\#36](https://github.com/tumugi/tumugi/issues/36)

**Merged pull requests:**

- Prepare release for v0.5.0 [\#68](https://github.com/tumugi/tumugi/pull/68) ([hakobera](https://github.com/hakobera))
- Call init first Tumugi::Logger instance access [\#67](https://github.com/tumugi/tumugi/pull/67) ([hakobera](https://github.com/hakobera))
- Better task scheduling. [\#66](https://github.com/tumugi/tumugi/pull/66) ([hakobera](https://github.com/hakobera))
- Support log output to file [\#65](https://github.com/tumugi/tumugi/pull/65) ([hakobera](https://github.com/hakobera))
- Add EternalTask as bundled plugin [\#64](https://github.com/tumugi/tumugi/pull/64) ([hakobera](https://github.com/hakobera))
- Add Tumugi.configure method to modify config. [\#63](https://github.com/tumugi/tumugi/pull/63) ([hakobera](https://github.com/hakobera))
- Implement timeout feature [\#62](https://github.com/tumugi/tumugi/pull/62) ([hakobera](https://github.com/hakobera))
- Disable parameter auto binding from ENV [\#59](https://github.com/tumugi/tumugi/pull/59) ([hakobera](https://github.com/hakobera))
- Restruct error handling [\#58](https://github.com/tumugi/tumugi/pull/58) ([hakobera](https://github.com/hakobera))
- Change CLI test to fix failed test with ruby-head [\#52](https://github.com/tumugi/tumugi/pull/52) ([hakobera](https://github.com/hakobera))

## [v0.4.5](https://github.com/tumugi/tumugi/tree/v0.4.5) (2016-05-16)
[Full Changelog](https://github.com/tumugi/tumugi/compare/v0.4.4...v0.4.5)

**Fixed bugs:**

- Fix required parameter validation [\#49](https://github.com/tumugi/tumugi/pull/49) ([hakobera](https://github.com/hakobera))

**Merged pull requests:**

- Prepare release for v0.4.5 [\#50](https://github.com/tumugi/tumugi/pull/50) ([hakobera](https://github.com/hakobera))

## [v0.4.4](https://github.com/tumugi/tumugi/tree/v0.4.4) (2016-05-13)
[Full Changelog](https://github.com/tumugi/tumugi/compare/v0.4.3...v0.4.4)

**Fixed bugs:**

- Fix workflow result output of parameters [\#47](https://github.com/tumugi/tumugi/pull/47) ([hakobera](https://github.com/hakobera))

**Merged pull requests:**

- Prepare release for v0.4.4 [\#48](https://github.com/tumugi/tumugi/pull/48) ([hakobera](https://github.com/hakobera))

## [v0.4.3](https://github.com/tumugi/tumugi/tree/v0.4.3) (2016-05-12)
[Full Changelog](https://github.com/tumugi/tumugi/compare/v0.4.2...v0.4.3)

**Implemented enhancements:**

- Param set accept proc [\#45](https://github.com/tumugi/tumugi/pull/45) ([hakobera](https://github.com/hakobera))

**Fixed bugs:**

- Fix param\_set in subclass overrite parent class param [\#44](https://github.com/tumugi/tumugi/pull/44) ([hakobera](https://github.com/hakobera))

**Merged pull requests:**

- Prepare release for v0.4.3 [\#46](https://github.com/tumugi/tumugi/pull/46) ([hakobera](https://github.com/hakobera))

## [v0.4.2](https://github.com/tumugi/tumugi/tree/v0.4.2) (2016-05-10)
[Full Changelog](https://github.com/tumugi/tumugi/compare/v0.4.1...v0.4.2)

**Fixed bugs:**

- Cannot read parameters of parent task [\#41](https://github.com/tumugi/tumugi/issues/41)

**Merged pull requests:**

- Prepare release for v0.4.2 [\#43](https://github.com/tumugi/tumugi/pull/43) ([hakobera](https://github.com/hakobera))
- Fix parent class parameters are not visible in a subclass [\#42](https://github.com/tumugi/tumugi/pull/42) ([hakobera](https://github.com/hakobera))

## [v0.4.1](https://github.com/tumugi/tumugi/tree/v0.4.1) (2016-05-09)
[Full Changelog](https://github.com/tumugi/tumugi/compare/v0.4.0...v0.4.1)

**Fixed bugs:**

- Check workflow file existance before load [\#39](https://github.com/tumugi/tumugi/pull/39) ([hakobera](https://github.com/hakobera))

**Merged pull requests:**

- Prepare release for v0.4.1 [\#40](https://github.com/tumugi/tumugi/pull/40) ([hakobera](https://github.com/hakobera))

## [v0.4.0](https://github.com/tumugi/tumugi/tree/v0.4.0) (2016-05-09)
[Full Changelog](https://github.com/tumugi/tumugi/compare/v0.3.0...v0.4.0)

**Implemented enhancements:**

- \[Breaking Change\] Remove support ruby 2.0 [\#33](https://github.com/tumugi/tumugi/issues/33)
- Add config section [\#31](https://github.com/tumugi/tumugi/issues/31)

**Merged pull requests:**

- Prepare release for v0.4.0 [\#38](https://github.com/tumugi/tumugi/pull/38) ([hakobera](https://github.com/hakobera))
- Refactoring error handling [\#37](https://github.com/tumugi/tumugi/pull/37) ([hakobera](https://github.com/hakobera))
- Change config section spec [\#35](https://github.com/tumugi/tumugi/pull/35) ([hakobera](https://github.com/hakobera))
- Remove support Ruby 2.0 [\#34](https://github.com/tumugi/tumugi/pull/34) ([hakobera](https://github.com/hakobera))
- Implement config section [\#32](https://github.com/tumugi/tumugi/pull/32) ([hakobera](https://github.com/hakobera))

## [v0.3.0](https://github.com/tumugi/tumugi/tree/v0.3.0) (2016-05-06)
[Full Changelog](https://github.com/tumugi/tumugi/compare/v0.2.0...v0.3.0)

**Implemented enhancements:**

- Show result report [\#23](https://github.com/tumugi/tumugi/issues/23)
- Support parameter [\#21](https://github.com/tumugi/tumugi/issues/21)

**Fixed bugs:**

- Fix workflow dead locked when some task failed [\#25](https://github.com/tumugi/tumugi/pull/25) ([hakobera](https://github.com/hakobera))

**Merged pull requests:**

- Prepare for release v0.3.0 [\#27](https://github.com/tumugi/tumugi/pull/27) ([hakobera](https://github.com/hakobera))
- Update README [\#26](https://github.com/tumugi/tumugi/pull/26) ([hakobera](https://github.com/hakobera))
- Implement workflow run result report [\#24](https://github.com/tumugi/tumugi/pull/24) ([hakobera](https://github.com/hakobera))
- Implement parameter feature [\#22](https://github.com/tumugi/tumugi/pull/22) ([hakobera](https://github.com/hakobera))

## [v0.2.0](https://github.com/tumugi/tumugi/tree/v0.2.0) (2016-05-02)
[Full Changelog](https://github.com/tumugi/tumugi/compare/v0.1.0...v0.2.0)

**Implemented enhancements:**

- \[Breaking Change\] Support plugin [\#15](https://github.com/tumugi/tumugi/issues/15)
- Add required\_ruby\_version to gemspec [\#19](https://github.com/tumugi/tumugi/pull/19) ([hakobera](https://github.com/hakobera))
- \[Breaking Change\] Change eval scope of output, run method [\#14](https://github.com/tumugi/tumugi/pull/14) ([hakobera](https://github.com/hakobera))
- \[Breaking Change\] Add Task\#logger and Task\#log method  [\#12](https://github.com/tumugi/tumugi/pull/12) ([hakobera](https://github.com/hakobera))
- Update command description / Set file options mandatory [\#11](https://github.com/tumugi/tumugi/pull/11) ([hakobera](https://github.com/hakobera))

**Fixed bugs:**

- Fix show command cannot handle task which id include underscore [\#13](https://github.com/tumugi/tumugi/pull/13) ([hakobera](https://github.com/hakobera))

**Merged pull requests:**

- Use bundler cache on travis [\#17](https://github.com/tumugi/tumugi/pull/17) ([hakobera](https://github.com/hakobera))
- Add gem version badge to README [\#16](https://github.com/tumugi/tumugi/pull/16) ([hakobera](https://github.com/hakobera))
- Prepare for release v0.2.0 [\#20](https://github.com/tumugi/tumugi/pull/20) ([hakobera](https://github.com/hakobera))
- \[Breaking Change\] Implement plugin architecture [\#18](https://github.com/tumugi/tumugi/pull/18) ([hakobera](https://github.com/hakobera))
- Add changelog of v0.1.0 [\#10](https://github.com/tumugi/tumugi/pull/10) ([hakobera](https://github.com/hakobera))

## [v0.1.0](https://github.com/tumugi/tumugi/tree/v0.1.0) (2016-04-28)
**Implemented enhancements:**

- Retry when task failed [\#8](https://github.com/tumugi/tumugi/pull/8) ([hakobera](https://github.com/hakobera))
- Support run tasks concurrently [\#7](https://github.com/tumugi/tumugi/pull/7) ([hakobera](https://github.com/hakobera))
- Visualize [\#6](https://github.com/tumugi/tumugi/pull/6) ([hakobera](https://github.com/hakobera))
- Support task inheritance [\#5](https://github.com/tumugi/tumugi/pull/5) ([hakobera](https://github.com/hakobera))
- First DSL implementation [\#3](https://github.com/tumugi/tumugi/pull/3) ([hakobera](https://github.com/hakobera))

**Closed issues:**

- Features and Tasks for v0.1 [\#4](https://github.com/tumugi/tumugi/issues/4)

**Merged pull requests:**

- Create gem [\#2](https://github.com/tumugi/tumugi/pull/2) ([hakobera](https://github.com/hakobera))
- Add initial spec [\#1](https://github.com/tumugi/tumugi/pull/1) ([hakobera](https://github.com/hakobera))



\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*
