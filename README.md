#sar-helpers

*sar-helpers* are a set of bash function to ease the extration of information out of SAR data.

## Motivation

All SAR data users have written short scripts to extract e.g. the mission, the cycle, the relative orbit or the sensing date.
We also went through that when using GMTSAR, ROI_PAC or DORIS (via Adore) on our Cloud platform. 

Each Space Agency went through a different path in terms of file format, archiving stategy. Within each Agency there are also differences between the missions (e.g. ESA with ERS-1/2 CEOS format, Envisat ASAR in Envisat format, and finally Sentinel-1 data as XML and Geotiff).

This repo gathers helper functions that have the goal to ease the extraction of metadata and data before using tools like GMTSAR, ROI_PAC or DORIS (among others).

## Getting Started 

The sar-helpers functions are packaged as a single bash file that can be sourced within your bash scripts.
There are external dependencies (e.g. CEOS metadata extraction) and thus portability from CentOS is not garanteed. 

### Installation

#### Development version

```bash
cd
git clone git@github.com:Terradue/sar-helpers.git
cd sar-helpers
mvn install
```

This will install the sar-helpers bash file in `/opt/sar-helpers`

Source it in your scripts with:

```bash
#!/bin/bash

. /opt/sar-helpers/sar-helpers.sh
```

#### Releases

There are no releases yet, we're working on it!

#### Dependencies

* *shunit2* for tests, we expect to find shunit2 under $SHUNIT2_HOME/src/shunit2
* *asf_mapready* for extracting CEOS metadata
* *HeaderDoc* for documenting the functions

### How to collaborate

Your help is welcome! You can for instance work on the portability or adding new missions (e.g. RADARSAT).

The best strategy is to [fork](https://github.com/Terradue/sar-helpers/fork) and provide us pull requests (do not make commits on the master branch though).

Feedback can also be provided as [issues](https://github.com/Terradue/sar-helpers/issues/new)

### Authors

* Fabrice Brito

### License for this tutorial

Copyright 2015 Terradue Srl

Licensed under the Apache License, Version 2.0: http://www.apache.org/licenses/LICENSE-2.0

