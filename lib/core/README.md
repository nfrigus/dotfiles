Dotfiles core
===

Features
---

- Install script
  - Symlinking
- Handle modules loading

todo:
- Path caching
- init: build dependencies tree, define loading order

Lifecycle
---

- Initiation - run once on dotfiles install
  - symlinking
  - path cahing
  - bash sources caching
- Loading
  - [todo]


Modules structure
---

Modules are located in `lib/` folder and must have `doty.mod` file with optional configurations.

#### Configuration options

- env - define environment variable
- link - define a symlinking source-target pair to be applied on installation
- path - add `PATH` variable entry
- source - add import entry for `.bashrc`

Paths defined in module configuration are extended with following rules:
- path starting with `$HOME/` will point items in user home directory
- path starting with `$ROOT/` will point items in Doty installation directory
- path starting with `/` will remain unchanged and target absolute path in the system
- other paths will target items located in the directory of module where it was defined
