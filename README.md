# Github-based CI for running Xous in Renode

Copyright (c) 2021 [Antmicro](https://www.antmicro.com/)

This repository contains a script for preparing emulated [xous-precursor](https://github.com/betrusted-io/xous-core) in Renode and testing it using Github Actions.

## Building

To test it locally, build [the latest Renode version](https://github.com/renode/renode/tree/master) from GitHub repository. For build instructions, please refer to [documentation](https://renode.readthedocs.io/en/latest/advanced/building_from_sources.html).

You can also use one of the pre-built [nightly packages](https://builds.renode.io).

To build xous-precursor for testing run:
```
./prepare_image.sh
```
All emulation files (e.g. xous.resc, xous.repl) will be stored in ``xous-core/emulation`` folder.

## Usage
To start the emulation, run the following in Renode:
```
(monitor) s xous-core/emulation/xous.resc
```
or from terminal:
```
renode xous-core/emulation/xous.resc
```

## Running the simulation
You should see an emulated lcd screen like [this](https://github.com/antmicro/renode-xous-precursor/blob/master/screenshots/onBootScreenshot.png).

You can use your keyboard to interact with the emulated lcd screen. Run ``help`` to see the list of all available commands.
