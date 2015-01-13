
## Motivation

All SAR data users have written short scripts to extract e.g. the mission, the cycle, the relative orbit or the sensing date.
We also went through that when using GMTSAR, ROI_PAC or DORIS (via Adore) on our Cloud platform. 

Each Space Agency went through a different path in terms of file format, archiving stategy, etc. Within each Agency there are also differences between the missions (e.g. ESA with ERS-1/2 CEOS format, Envisat ASAR in Envisat format, and finally Sentinel-1 data as XML and Geotiff).

This bash library gathers helper functions that have the goal to ease the extraction of metadata and data before using tools like GMTSAR, ROI_PAC or DORIS (among others).


