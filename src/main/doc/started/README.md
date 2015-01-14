## Getting started with sar-helpers

#### Installing a release

_sar-helpers_ repository is hosted by GitHub, as such the releases are also there.

To see the current release go [here](https://github.com/Terradue/sar-helpers/releases)

*Download a release*

Use _wget_ to download the RPM and then _yum_ to install the package (as root):

```bash
wget TODO
yum install TODO
```

> *Note* adapt the version number to the release you want to install

The procedure above will install _sar-helpers_ in _/opt/sar-helpers_.

To use _sar-helpers_, do:

```bash
export SAR_HELPERS_HOME=/opt/sar-helpers/lib/
. $SAR_HELPERS_HOME/sar-helpers.sh
```

#### Installing the development version

Clone the repository:

```bash 
git clone git@github.com:Terradue/sar-helpers.git
cd sar-helpers
```

Use _maven_ to install the library:

```bash
mvn clean install
```
