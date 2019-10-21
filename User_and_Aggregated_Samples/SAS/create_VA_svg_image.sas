/******************************************************************************\
* Copyright 2019 SAS Institute Inc.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* https://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*
* Author: Michael Drutar
*
* Input: The desired image width and height of the SVG image. 
*		 The internal report id (UID) of the Visual Analytics report that the
*		 SVG image will created from (this is placed in the macro call at the
*        bottom of this program).
*
* Output: SVG Image file displayed in the SAS Studio Results window
*
* All code included in this section must be submitted in a SAS Studio 5.1 (or later) 
* session within a Viya 3.4 (or later) environment which contains the SAS Viya services 
* that are being called. 
\******************************************************************************/



/* Input desired image width and height */
%let width=800;
%let height=600;

%macro create_VA_svg_image(report_uri);

* Base URI for the service call;
%let BASE_URI=%sysfunc(getoption(servicesbaseurl));

/* -------------------------------------------------------------- */
/*                  Step 1 - Create a job                         */
/* -------------------------------------------------------------- */

/* Create input for the job request */
data create_params;
	request_params = "'" || trim('{"reportUri" : "') || "&report_uri" || trim('","layoutType" : "entireSection","refresh":false,"selectionType" : "report","size" : "' || "&width" || 'x' || "&height" || '","version" : 1}' || "'");
	call symput('request_params',request_params);
run;

/* create filenames to hold responses*/
filename startjob temp;
filename resp_hdr temp;

/* Make request */
proc http 
	 method="POST"
     oauth_bearer=sas_services
	 url="&BASE_URI/reportImages/jobs"
	 ct="application/vnd.sas.report.images.job.request+json"
	 in=&request_params.
	/* place response in filenames */
	 	out=startjob 
 		headerout=resp_hdr
 		headerout_overwrite;

run;

/* Use JSON LIBNAME engine to read in response */
libname startjob json;

/* View startjob.root ouput */
/* title 'Job Creation Output'; */
/* proc print data=startjob.root noobs; */
/* var id state creationTimeStamp; */
/* run; */
/* title; */

/* capture the job id for step 2 */
data _NULL_;
	set startjob.root;
  	   call symputx('job_id',id);
run;

/* -------------------------------------------------------------- */
/*      Step 2 - Retrieve job status & duration (In a Macro!)     */
/* -------------------------------------------------------------- */

%let status=0;
%macro jobstatus;
   %do %until (&status ne 0);
		/* clear filenames and libname librefs */
			filename res_hdr clear;
			filename j_status clear;
			libname j_status clear;
		/* assign filenames */
			filename j_status temp;
			filename res_hdr temp;
        /* Make request */
			proc http 
			 method="GET"
                 oauth_bearer=sas_services
	 		 url="&BASE_URI/reportImages/jobs/&job_id"
			 out=j_status
			 headerout=res_hdr
 	 		 headerout_overwrite;
			run;
			
		/* Read response */
			libname j_status json;
		/* Determine state and reset status */
			data job_status;
				set j_status.root;
					if state = 'running' then status = 0;
					else if state = 'completed' then status = 1;
					call symputx('status',status);
			run;

			/* Wait one second */
			data _NULL_;
			   time_slept=sleep(1,1);
			run;

   %end;
%mend jobstatus;
/*call the macro*/
%jobstatus;

/* ---------------------------------------------------------------------- */
/* Step 3 - Display the generated SVG image within the results window     */
/* ---------------------------------------------------------------------- */

/* retrieve image url */
data _NULL_;
set j_status.Images_links(obs = 1);
call symput('image_link',compress(href));
run;

/* create dataset to display image */
data showImage; 
Url_Link = '<iframe src="'|| compress("&image_link")||'" width="'|| compress("&width")||'" height="'|| compress("&height")||'"></iframe>'; 
RUN; 

/* Display the Image */
title1 'An SVG image file of the requested report is below!';
proc report data=WORK.showImage nowd noheader;
column Url_Link;
run;
%mend create_VA_svg_image;



/* -------------------------------------------------------------- */
/*    				  Create and View SVG Image				      */
/* -------------------------------------------------------------- */

/* place your report uri in the macro call below: */
/* example: %create_VA_svg_image(/reports/reports/0ce19e27-94bb-49a3-baad-4a673078c55b) */
%create_VA_svg_image(<- report uri ->)
