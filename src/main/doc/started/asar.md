### Getting started with Envisat ASAR Image Mode Level 0 & Level 1

* [Setting the environment](#setting-environment)
* [Getting the mission](#getting-mission)
* [Getting the cycle](#getting-cycle)
* [Getting the track (relative orbit)](#getting-track)
* [Getting the sensing date](#getting-date)

#### <a name="setting-environment"></a>Setting up the environment

Export the _sar_helpers_ environment variable:

```bash
export SAR_HELPERS_HOME=/opt/sar-helpers/lib
. $SAR_HELPERS_HOME/sar-helpers.sh
```

The Envisat ASAR product can be downloaded from http://eo-virtual-archive4.esa.int/?q=ASA_IM__0CNPDE20120328_174858_000000163113_00113_52713_6275.N1

#### <a name="getting-mission"></a>Mission

```bash
get_mission ASA_IM__0CNPDE20120328_174858_000000163113_00113_52713_6275.N1
```

will return:

```bash
ASAR
```

#### <a name="getting-cycle"></a>Cycle

```bash
get_cycle ASA_IM__0CNPDE20120328_174858_000000163113_00113_52713_6275.N1
```

will return:

```bash
TODO
```

#### <a name="getting-track"></a>Track (relative orbit)

```bash
get_track ASA_IM__0CNPDE20120328_174858_000000163113_00113_52713_6275.N1
```

will return:

```bash
113
```

#### <a name="getting-date"></a>Sensing date

```bash
get_sensing_date ASA_IM__0CNPDE20120328_174858_000000163113_00113_52713_6275.N1
```

will return:

```bash
20120328
```

#### <a name="getting-direction"></a>Direction

*Not supported*

