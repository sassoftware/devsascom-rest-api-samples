One of the best features of The [SAS® Viya REST API](https://developer.sas.com/apis/rest/) is the ability to leverage the reportImages service to generate SVG images representing Visual Analytics Report(s).  This is particularly useful for SAS developers who are making updates to a report's data source(s) and would like to get a quick view of how these changes are reflected in Visual Analytics.  More information on this service can be found on the [reportImages developer.sas.com page](https://developer.sas.com/apis/rest/Visualization/#report-images)

The SAS code in this folder will programmatically call a Visual Analytics report using the reportImages service and generate an SVG image from it.  More so, the SVG image is then presented in SAS Studio's results tab so the SAS developer can instantly get a view of the report's current state.

![](./create_VA_svg_image.png)

The image above shows an SVG image of a SAS Visual Analytics report (created via the reportImages service) presented in the SAS Studio results tab.

Code Prerequisites:

* All code included in this folder must be submitted in a SAS Studio 5.1 (or later) session within a Viya 3.4 (or later) environment which contains the SAS Viya services that are being called. 
* The Visual Analytics Report's URI must be placed in the macro call at the bottom of the code
    * example: %create_VA_svg_image(/reports/reports/9d9d1a82-1e39-4284-a278-c3a05388ea72)
* All of the report's data sources are have been lifted into memory as CAS Datasets

