;LandXML for Autocad - importer, creator and exporter of NSW based LandXML data
;Copyright (C) 2015  Phillip Nixon

;    This program is free software: you can redistribute it and/or modify
;    it under the terms of the GNU General Public License as published by
;    the Free Software Foundation, either version 3 of the License, or
;    any later version.

;    This program is distributed in the hope that it will be useful,
;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;    GNU General Public License for more details.

;    To view a copy of the GNU General Public License see <http://www.gnu.org/licenses/>.

;THE BEER-WARE LICENSE" (Revision 42):
; Phillip Nixon wrote this file. As long as you retain this notice you can do whatever you want with this stuff.
;If we meet some day, and you think this stuff is worth it, you can buy me a beer in return.

;This program is dedicated to my daughter Lucy who got me up at 5.30 in the morning then slept on my arm while I wrote the beta version one handed.

;Revision 1.0 - Beta
;Revision 1.1 - Occupations Buildings added
;             - Fixed seconds missing when exported at exactly 00
;             - Revised Irregular boundary CG points
;             - Change the Easement designator system
;             - Added easemet legend maker
;             - Added adjoining boundaries and roads
;             - Change the RM PM connection back to PM connection line
;Revision 1.2  - Fixed reverse PM coords in coordbox
;             - Fixed arc observation checking on adjoining boundaries (found by C.Colbert)
;             - Fixed initial value for road/easment location when ray caster does hit any edges (found by C.Colbert)
;             - Change the requirmentes for "Occupation" to different spelling
;             - Added OFFSET as a occupations variable type (case problem)
;             - Fixed irregular line reading too many lines from the file and also adding a space at the end of the 2dpntlist
;             - Added adjoining easement change line type to dashed
;             - Added XINO & XINS command
;             - Rewrote line readed to deal with XML comments <!-- -->
;Revision 1.2.1- Changed adjoining curve centrepoint to sideshot instead of boundary (found by C.Colbert)
;Revision 1.3 -Fixed pickstyle hatch creation object deletion on XCL, XCR, XCE (found by J.Herdgren)
;             -Added setting to reset and set scale list to fix custom scales affecting line types
;             -Made thickness of lot definitions 0.7 so with line thickness turned on lots are visible.
;             -CG points labelled on export.
;Revision 1.4 -Added function to reverse lot definition polyline direction to clockwise on export (found by H.Choi)
;Revision 1.5 -Added better xml searching fuctions to deal with tabbed spacing (C.Colbert's thesis 12d xml file)
;             -Added CG point labeller to xino command
;             -Ajoining lot with no xdata's now identified (found by M.Forsyth)
;             -Got rid of residual AEC objects from Planform blocks causes problems with block inserts
;             -Problem with adjoining lots and plan features not closing fixed
;             -Fixed issue with XOC not calculating from buildings
;             -Fixed easecount being a fuction as well as a variable
;             -Existing easement lots are no longer checked for geometry on XOUT and linework is now placed over the top on XIN so they plot, this is the form of a polyline
;             -Dates changed so they match existing plans format (dd-mm-yyyy) but are changed to xml format on export
;             -Adjustments to code so it also works with BricsCAD V16. Changes checked against AutoCAD 2016, edits from file changed by Jason Bourhill at http:\\www.cadconcepts.co.nz.
;             -Corrected misspell of 'PICKSTYLE
;	      -HATCHEDIT BricsCAD V16 is missing some of AutoCAD's options use HATCHGENERATEBOUNDARY instead, which works the same in both
;	      -AutoCAD uses a "d" as a suffix to angles in DMS Format, BricsCAD uses a "�" Adjusted code so that DMS angles are in the expected AutoCAD format
;	      -INSERT. AutoCAD uses a different command syntax to BricsCAD when inserting blocks without attributes adjusted these INSERT calls to declare scale first, which works without issues in both applications.
;Revision 1.6 -Added ability to use survey bearings on input (eg N45W instead of 315) on XTR,XTA,XRM and XDRM
;             -Added datum description when using MM (found by J.Herdegen)
;             -Added extra line to PM box which labels the zone and CSF in both XIN and XPM (gets data if available on XPM)(found by J.Herdegen)
;             -Doesn't reverse dates on PM box labeller
;Revision 1.7 -fixed hatch generation problem in Autocad 2012 where hatchgenerateboundary finishes with polyline selected
;             -fixed non tuncating numbers in XAL and XAA
;             -added "SS" to "SSM" conversion on PM creator
;             -added XALN & XAAN commands to add notes by assigning lines and arcs
;             -added ability to use 2d polylines (splined polylines) for irregular boundaries (Mentioned by D.Jobs at ISNSW HMG meeting April 2016)
;             -Allowed spaces in XPM
;             -Added facility for flow arrows
;             -Added ability to add non connected RM's (eg RM gone on Adjoining lot with no connection)
;             -Added state determinations for PM, eg found/placed
;             -Add ability to work with UCS with XAL,XAA,XAP,XCL,XCR,XCE,XJR,XJL to correct text rotation when north is not directly up the page
;             -Fixed problem with bulbous arcs in XAA and XIN (found by A.Vance)
;Revision 1.7.1-Fixed problem with UCS translation on XAE,XAP,XJL,XJR and easecount when no lots exist yet (found by A.Vance)
;Revision 1.7.2-Fixed problem with PM creator
;              -Added z axis transformer for points inserted in a UCS
;Revision 1.8  -Added XAO command for assigning description to occupation plan features
;              -Revised Direction of Flow Arrows to match recipe and insert automatically when using XAI
;              -Fixed adjoining lot with no xdata error finder pointing to wrong point (found by Gavin Murray)
;              -Added drafting tools XSP, XSW and XSB
;              -Added stages notification to XOUT to assist users with error detection.
;              -Changed irregular boundarys from sideshot proposed boundary to traverse proposed connection
;              -Made provision for linefeeds in ptlist2d
;              -XOC revised, all offsets now plan feature offsets which allows direction
;              -All text now written in uppercase to meet RG Dir 6.
;              -RM Gone using XCM changed to incorporate type and print RM at start
;              -XOUT hierachy revised to move adjoining boundaries to number 7.
;              -Minor enumeration list changes
;              -Ability to deal with lxmls with no monuments added (for example complied plans)
;Revisoin 1.81 -Problem with more than one multipart lot fixed
;              -Allow spaces in Occ comments
;Revision 1.8.3-Fixed problem double spaces where there was a monument condition
;Revision 1.8.4-Added short line tables for arcs (as requested by Jacek Idzikowski)
;Revision 1.8.5-Fixed bug with reverse arc traverse (found by Greg Smiths smart young draftsman)
;Revision 1.8.6-Reverted back to 6 decimal places
;Revision 1.8.7-Added an entered bearing validator
;Revision 1.8.8-Re-reverted back to 6 decimal places after some sort of stuffup by author
;Revision 1.8.9-Made any leftover boundary parcels pntsurv boundary instead of sideshot and respects the lots state (found by David Loftberg)
;Revision 1.8.10-Fixed fieldonote "" being added to arcs and PM'a on import (found by Greg Smith)
;Revision 1.8.11-Made allowances for only irregualr boundary for lot edge (eg. track in use)(example from Greg Smith)
;Revision 1.9  -Added slanty text entries when entering "ye old" distances in XTR
;              -Added compile type lines to XALC
;              -Added ability to have a line with just a bearing on import
;              -Fixed "Not Marked" state "Not Marked" label
;              -XRD values changed, now rounds to 5" for all distances under 10km long.  For PM connections turn rounding off
;              -Fixed problem with mounment condition importer
;              -Added peditaccept setting (found by Roumen Mollov)
;              -Change set to setq on non entered plan of attribute (found by Roumen Mollov)
;              -Added double // remover so adjoining lots can be copied from Google Earth nswglobe.kml placemarks
;              -Added XCB for drafting to add brackets around text
;              -Modified XAA and XOUT to work with arcs not in world UCS
;              -Fixed trig station (and other PM types) exporting TS to cg points
;              -Fixed XAM not recording decimal point when exactly square
;              -Added XHV tool
;              -Added XBE tool to allow bulk attribute editing
;              -Added XJO tool for other objects
;              -Fixed problem with RM's referencing natural boundary lines
;              -Added XCT tool to tidy coords at 4th decimal place
;              -Add ability to have bearing symbols and & in comments and descriptions
;              -Updated moument states to complete list
;              -Major changes to allow for strata plans and the level and wall codes
;              -XSA, XST tool added for assigning and totaling strata lots
;              -XALS, XALSN, XALSM and XALSMN added for strata lines and strata lines with notes
;              -XVI and XLV added to assign levels to vincs and adjoining information
;              -Added ability to use planform 3 for stratas
;Revision1.9.1 -Fixed problem with decimal point storing when adding cardinal bearings (eg 90,270etc) found by Ahmed El-Kiki
;Revision1.9.2 -Dealt with files with no linefeed (example from Stringer eplan by Ahmed El-Kiki)
;              -Shifted attdia and attreq to either side of the admin sheet importer (request from Greg Smith)
;Revision1.9.3 -Fixed xino cgpoint reader (found in Non linefed file by Ahmed El-Kiki)
;Revision1.9.4 -Dealt with fieldnotes and irregular lines in non linefed files (found by Ahmed El-Kiki)
;              -Dealt with brackets around text in point occupations
;              -Changed to match new adjoining Hydrography format, but still allow old format to import and export
;Revision1.9.5 -Made more polylines go clockwise on creation and assignement (request from Jacek Idzikowski)
;              -Fixed bug with areas less than 1m�
;Revision1.9.6 -Fixed bug with calculated areas in XSA (found by Roumen Mollov)
;Revision1.9.7 -Fixed "" on XAA xdata assignment (found by Libby Whyte and Ziemowit Wierzchowski)
;Revision1.9.8 -Improvements and repairs to xdata checking on xout (as requested by Ziemowit Wierzchowski and to make sure Gavin Murray doesn't go bald)
;              -Updated planfeature symbol replacer
;Revision1.10  -Added ability to add other secondary interests using XCE and XAE
;              -Added XUP tool for assigining some useOfParcels attributes
;Revision1.10.1-Compilation plan type now changes "Date of Survey" to "Date of Compilation"
;Revision1.10.2-Adjoining Easements Added to XAE
;Revision1.10.3-Ends of Irregular line change to boundary for irregualar easement centreline
;              -Fixed fractional part error for recurring 9's in area calculations
;Revision1.10.4-Fixed XRD on lines rounded to 60" (found by Michael Kadziela)
;Revision1.10.5-Added format to multipart parcel definition on export
;Revision1.10.6-Added irregualar boundary error checker (to reduce Gavin Murray's hair loss)
;Revision1.10.7-Fixed problem with extra centerpoints being exported when exporting an pntlist2d and change adjoining centres back to existing
;Revision1.10.8-Changed Datum points to allow other letters for marking plan notes
;Revision1.11  -Changed Datum points to allow for RL and added XBM command for creating stratum benchmarks
;Revision1.11.1-Changed the requirements for strata datum points.
;Revision1.11.2-Fixed bug with stratum datum point list counter
;Revision1.11.3-Minor bug fixes to XSD and XSDR tools and other strata fuctions (thanks to Michael Homsey for a fresh exmaple)
;              -SSIR2017 wording changes
;              -Fixed problem with missing <Parcel on XJO
;              -Rounding and scale values now stored in DWG
;              -Scale value read from strata xml on xin
;Revision1.11.4-Add ability for multiple admin areas (lga,locality,parish,county) seperated by a /
;Revision1.12  -Added road extents for ends of proposed roads and road widening
;              -Made coordinate boxes more compliant with SG Direction 7 (2017) example
;              -Allowed for number prefixes on strata levels and datum points
;              -Added XHD to add height difference to line
;              -Condition removed from XRM, XDRM and XCM
;              -Changed RM Connections to Reference on output and added distanceAccClass and adoptedDistanceSurvey to line
;              -Centroid calculator added to XAP,XAR,XAE,XJL,XJR and XJO
;              -Fixed problen with rounded chord distances in Short Arc Table (found by Gavin Murray)
;Revision1.12.1-Fixed problem with RM or corner mark gone still looking for a condition (found by Michael Kadziela)
;Revision1.12.2-Readded brackets and letter labeller when easement description starts with (#)
;              -Changed text height to 0 at beginning of xin (found by Greg Gruber) - Bricscad does seem to change at start
;              -EST requirement on PM's changed from "SCIMS" to include also "From SCIMS" and fixed problem with BM is imported first (found by Michael Kadziela)
;              -Added old versions link
;Revision1.12.3-Fixed XPM where no pm connection lines exist
;              -Removed selector from XCL
;              -Minor bug fixes to menu and spelling
;Revision1.12.4-Fixed bug where not importing two reference lines to one monument not setting layer to RM Connection (found by Michael Kadziela)
;Revision1.12.5-Fixed bug where PM or BM points were not incrementing on export when on top of each other (found by David Loftberg)
;Revision1.12.6-Fixed bug with replaceitem function not adding list item in a list
;              -Added allowance for Height Difference layer and height difference lines with no azimuth or horizontal distance
;Revision1.12.7-Fixed error where HDT goes from non pm point - no label
;              -Allowed marks other than Scims mark types to be reducedhorizontalpositions
;Revision1.12.8-Fix problem with extra " when adding XHD to exsiting line  (found by Michael Kadziela)
;Revision1.12.9-Removed xout command hardwiring, would not run in Bricscad (found by Michael Kadziela)
;Revision1.13  -Change XJO to add "parish/county of" text
;              -Added default "" value for date of survey for compiled plans
;              -Added XAUD audit tool for comparing/ identifying differences between xdata and line geomtery
;              -Updated admin sheet EPAA section reference
;              -Fixed problem with recurring 9's when converting then getting integer portion of maunally entered areas to real numbers (found by Robert Booth)
;Revision1.13.1-Changed added MGA94 and MGA2020 to datums
;              -Order and posistional uncertainty mixed together for XPM and XBM
;              -XRT Added to recreate text from xdata
;Revision1.13.2-Problem exporting irregulars when using lwpolyline (found by Roumen Mollov)
;Revision1.13.3-Changes made to import PM/SSM used as reference mark using post V8 recipe (found by Roumen Mollov)
;              -Auto "used as reference mark" commenter removed from XAM, XRM etc
;              -Bug in order/pu fixed
;              -Fixed xino to ignore height difference only reduced obs (found by Ahmed El-Kiki)
;              -Amended xino code to deal with instrument heights that are not connected by geometry (eg height diff lines)
;              -Changed reader where DSM files have extras spaces on datum points, horizontalfix, horiztonaldatum and vertdistance
;              -Fixed problem with BM's not showing as EST when higher in file than PM
;Revision1.13.4-Restriciton of the use of land with no description will plot class as desc
;              -Fixed problem with roads with areas not being labelled
;              -Fixed problem with optional date on reduced vert's
;              -Move PM connections up in Redobs decison tree to draw line for RM on point 2 and change to RM Connection line(pre V8 recipe PM as ref point with non-peg mark at cnr)
;              -Default scale set to 1:200
;Revision1.13.5-Removed spaces on either side of - in pm csv maker SCIMS-Datum Validation (found by Brian Raaen)
;              -Allowed no value of PU in xin and N/A on XBM and XPM will not record pu in xdata
;              -Feature dictionary updated
;Revision1.13.6-Fixed bug with commment variable preventing feild note import (found by Roumen Mollov)
;Revision1.13.7-Fixed fieldnotes prefixing with <Fieldnote> when linefed
;              -When cg desc is "COORDINATE ERROR", point is not classed as a datum point and description is suffixed to cgpoint text
;              -When reduced observation field note contains the work "ILLEGIBLE" colour of line and notation turned orange
;Revision1.13.8-Change vertical observation date allowance of null value on XBM and XIN
;              -When value of Null on verticalfix coordinate box is populated with blank
;Revision1.13.9-Ajoining boundaries were not recoding a default strata code value
;              -Requirement for lot areas removed (for eg. existing lots)
;Revision1.13.10-Rebuilt allowance of rm referenced twice (found by Roumen Mollov)
;Revision1.13.11-Added vl-load-com
;Revision1.13.12-Added adjoining boundaries to XMLC
;               -Fixed warning when no height difference connection lines are found
;               -Fixed prompt for XAN
;               -Fixed problem when adding additional roads to an imported xml
;Revision1.13.13-Fixed problem when cardinals calced 0 minutes
;               -Added example file
;Revision1.13.14-Addd close vicinity point checker into xout
;               -Modernised some prompts to 2020 version (found by Kim Meijer)
;Revision1.13.15-Fixed problem with PM's not exporting to islist when not connected to geometry (thanks to Brian Raaen)
;               -Fixed problem comments and translation of & ' from xml to text when doing an xin (thanks to Brian Raaen)
;               -Height difference lines allow to have a CSF (why they need one is unknown - validator requirement)
;Revision1.13.16-Allowed non-schema enumeration red obs desc "irregularline" and converted to Irregular Right Line layer
;               -Added more orange coloured lines for other backcapture feildnote
;               -Attempted Speed enhancements to xin and xout by replacing member with vl-position
;Revision1.14.0 -Added XMO for exporting monument and XARP for store plan origins for compiles
;Revision1.14.1 -Added checker for oid requiring monument
;               -Fixed isolated point checker in XINO
;Revision1.14.2 -Removed bring RM to front - was bugging out in Bricscad and was unneccsary
;               -Fixed default text height to match scale
;Revision1.15   -Added option to stop areas always rounding down to XRD which affects XCL, XAP and XIN (as requested by Gavin Murray)
;Revision1.15.1 -Fixed bug in header export version
;Revision1.15.2 -Fixed semantic error in landxml.dcl and set dcl auditing to 0 (found by Elliot Griffiths)
;Revision1.15.3 -Fixed bug with assigning scale factor to lines with field notes (found by Elliot Griffiths)
;Revisino1.15.4 -Fixed � not exporting properly for road names
;               -Added area prompt for roads in XCR and XAR

(setq version "1.15.4")

(REGAPP "LANDXML")

;Set up page and variables for xml work
(SETVAR "CMDECHO" 0)
(vl-load-com)

(setq textstyle (getvar "textstyle"))
(SETQ textfont (ENTGET (tblobjname "style" textstyle)))
(setq theElist (subst (cons 40 0)(assoc 40 theElist) textfont))
(entmod theElist)


;Check to see if scale and rounding values are stored in drawing
(IF (= (SETQ MAXLEN1 (VLAX-LDATA-GET "LXML4AC" "MAXLEN1" )) nil) (PROGN   (setq MAXLEN1 1)  (VLAX-LDATA-PUT "LXML4AC" "MAXLEN1" MAXLEN1)   )  )
(IF (= (SETQ maxlen2 (VLAX-LDATA-GET "LXML4AC" "maxlen2" )) nil) (PROGN   (setq maxlen2 10000)  (VLAX-LDATA-PUT "LXML4AC" "maxlen2" maxlen2)   )  )
(IF (= (setq brnd1   (VLAX-LDATA-GET "LXML4AC" "brnd1" )) nil) (PROGN   (setq brnd1 60)  (VLAX-LDATA-PUT "LXML4AC" "brnd1" brnd1)   )  )
(IF (= (setq brnd2   (VLAX-LDATA-GET "LXML4AC" "brnd2" )) nil) (PROGN   (setq brnd2 5)  (VLAX-LDATA-PUT "LXML4AC" "brnd2" brnd2)   )  )
(IF (= (setq brnd3   (VLAX-LDATA-GET "LXML4AC" "brnd3" )) nil) (PROGN   (setq brnd3 1)  (VLAX-LDATA-PUT "LXML4AC" "brnd3" brnd3)   )  )
(IF (= (setq distmax1 (VLAX-LDATA-GET "LXML4AC" "distmax1" )) nil) (PROGN   (setq distmax1 1)  (VLAX-LDATA-PUT "LXML4AC" "distmax1" distmax1)   )  )
(IF (= (setq distmax2 (VLAX-LDATA-GET "LXML4AC" "distmax2" )) nil) (PROGN   (setq distmax2 1000)  (VLAX-LDATA-PUT "LXML4AC" "distmax2" distmax2)   )  )
(IF (= (setq drnd1 (VLAX-LDATA-GET "LXML4AC" "drnd1" )) nil) (PROGN   (setq drnd1 0.005)  (VLAX-LDATA-PUT "LXML4AC" "drnd1" drnd1)   )  )
(IF (= (setq drnd2 (VLAX-LDATA-GET "LXML4AC" "drnd2" )) nil) (PROGN   (setq drnd2 0.005)  (VLAX-LDATA-PUT "LXML4AC" "drnd2" drnd2)   )  )
(IF (= (setq drnd3 (VLAX-LDATA-GET "LXML4AC" "drnd3" )) nil) (PROGN   (setq drnd3 0.005)  (VLAX-LDATA-PUT "LXML4AC" "drnd3" drnd3)   )  )
(IF (= (setq qround (VLAX-LDATA-GET "LXML4AC" "qround" )) nil) (PROGN   (setq qround "NO")  (VLAX-LDATA-PUT "LXML4AC" "qround" qround)   )  )
(IF (= (setq ard (VLAX-LDATA-GET "LXML4AC" "ard" )) nil) (PROGN   (setq ard "YES")  (VLAX-LDATA-PUT "LXML4AC" "ard" ard)   )  ) ;always round down
(IF (= (setq scale (VLAX-LDATA-GET "LXML4AC" "scale" )) nil) (PROGN   (setq scale 200)  (VLAX-LDATA-PUT "LXML4AC" "scale" scale)   )  )
(IF (= (setq th    (VLAX-LDATA-GET "LXML4AC" "TH" )) nil) (PROGN   (setq TH 0.5)  (VLAX-LDATA-PUT "LXML4AC" "TH" TH)   )  )
(IF (= (setq ATHR  (VLAX-LDATA-GET "LXML4AC" "ATHR" )) nil) (PROGN   (setq ATHR "Y")  (VLAX-LDATA-PUT "LXML4AC" "ATHR" ATHR)   )  )





(if (= setupdone nil)(progn
(setq prevlayer (getvar "CLAYER"))

(setq notereq 0)



;LOAD LINETYPES
(setq expertlevel (getvar "expert"))
(setvar "expert" 3)
(COMMAND "-LINETYPE" "L" "*" "LANDXML" "" )
 (setvar "expert" expertlevel)




;(if (= textfontext "ttf") (COMMAND "STYLE" "" "" "0" "" "" "" "" ))
;(if (= textfontext "shx") (COMMAND "STYLE" "" "" "0" "" "" "" "" "" ))

      (setvar "cannoscale" "1:1")
(command "-scalelistedit" "d" "*" "e")

      
(command "layer" "m" "Road" "c" "red" "" "lw" "0.5" "" "")
(command "layer" "m" "Boundary" "c" "blue" "" "lw" "0.5" "" "")
(command "layer" "m" "Connection" "c" "cyan" "" "lw" "0.25" "" "l" "EASEMENT" "" "")
(command "layer" "m" "Road Extent" "c" "red" "" "lw" "0.25" "" "l" "EASEMENT" "" "")
(command "layer" "m" "Easement" "c" "8" "" "lw" "0.25" "" "l" "EASEMENT" "" "")
(command "layer" "m" "PM Connection" "c" "193" "" "lw" "0.25" "" "l" "PM_CONNECTION" "" "")
(command "layer" "m" "RM Connection" "c" "yellow" "" "p" "n" "" "")
(command "layer" "m" "Height Difference" "c" "52" "" "p" "n" "" "")
(command "layer" "m" "Monument" "c" "magenta" ""  "p" "n" "" "")
(command "layer" "m" "Lot Definitions" "c" "green" "" "p" "n" "" "lw" "0.7" "" "")
(command "layer" "m" "Adjoining Boundary" "c" "white" "" "lw" "0.25" "" "")
(command "layer" "m" "PM" "p" "n" "" "")
(command "layer" "m" "Datum Points" "p" "n" "" "")
(command "layer" "m" "Drafting" "c" "white" "" "lw" "0.25" "" "")
(command "layer" "m" "CG Points" "c" "white" "" "lw" "0.25" "" "p" "n" "" "")
(command "layer" "m" "Admin Sheet" "c" "white" "" "lw" "0.25" "" "")
(command "layer" "m" "Occupation Walls" "c" "white" "" "lw" "0.25" "" "L" "WALL" "" "")
(command "layer" "m" "Occupation Buildings" "c" "white" "" "lw" "0.25" "" "L" "BUILDING" "" "")
(command "layer" "m" "Occupation Fences" "c" "8" "" "lw" "0.25" "" "L" "FENCE" "" "")
(command "layer" "m" "Occupation Kerbs" "c" "9" "" "lw" "0.25" "" "L" "KERB" "" "")
(command "layer" "m" "Occupations" "c" "green" "" "p" "n" "" "")
(command "layer" "m" "Irregular Boundary" "c" "140" "" "lw" "0.5" "" "")
(command "layer" "m" "Irregular Right Lines" "c" "9" "" "p" "n" "" "")
(setvar "clayer" prevlayer )

(setvar "pdmode" 35)
(setvar "pdsize" 0.2)
(setq prevdesc "");previous strata description default
(setq prevblno "");previous strata level description






;@@@@@@possibly add rm and pop defintion here
(setq setupdone 1)
));p&if

(setvar "osnapcoord" 1)
(setvar "angdir" 1)
(setvar "angbase" (* 0.5 pi))
(setvar "attreq" 1)
(setvar "dimzin" 8)
(setvar "peditaccept" 0)
(SETQ UNITS "M")

;default values

(setq rmtype "GIP")
(setq rmstate "Found")
(setq paclass "Hydrography")
(setq peclass "Easement")
(setq labelyeolddist 0)
(setq notereq 0)
(setq compile 0)
(if ( = plotno nil)(setq plotno ""))
(if (= lrmrefdp nil)(setq lrmrefdp ""))
(if ( = ped nil)(setq ped ""))
(setq phdt "Differential Levelling")










;checking lists
(setq rmtypelist (list "DH&W" "GIP" "Wing" "Reference Tree" "Tree" "Approved Mark" "Broad Arrow" "Conc Block" "DH" "Bottle" "Lockspit" "Metal Spike" "GIN" "Nail"
"Peg" "PM" "Pipe" "Post" "PVC Pipe" "Rod" "Specified Point" "Spike" "Star Picket" "SSM" "TS" "Not Marked" "Occupation" "MM" "GB" "CP" "CR" "Witness Mark" "BM" "None"
		       "Steel Fence Post" "Chiselled Triangle" "Non Corrodible Bolt " "Non Corrodible Spike" "Non Corrodible Nail" "Bench Mark Token" "Boundary Mark Token" "Non Corrodible Nail And Wing" "PVC Star Picket" "Reference Mark Token" 

))
(setq rmtypelist (vl-sort rmtypelist '<))

(setq rmstatelist (list "Existing" "Found" "Gone" "Not Found"  "Placed"   "Not Marked" "Found By Me" "Not Marked Obstructed" ))
(setq rmconditionlist (list "Destroyed" "Disturbed" "Original" "Replaced" "Remains" "Subsidence Area" "Uncertain" "Inaccessible" "Submerged" ""))
(setq alotclasslist (list "Administrative Area" "Association Property" "Building" "Common Property" "Hydrography" "Lot" "Road" "Reserved Road" "Railway"))
(setq hydrolist (list "Access Channel" "Artificial Water Way" "Bay" "Canal" "Creek" "Ocean" "River"))
(setq lotuoplist (list "Cemetery" "Drainage Reserve" "Permit To Occupy" "Public Reserve" "Public Use Land" "Temporary Road" "Travelling Stock Route"   ))
(setq adminlist (list "Coastal Management Zone" "County" "Local Government Area" "Locality" "Parish" ))	      
(setq interestlist (list "Caveat" "Covenant" "Designated Area" "Easement" "Exclusive Use Area" "Footprint" "License" "Permit" "Positive Covenant" "Profit A Prende" "Restriction On Use Of Land" "Restriction On User"))
(setq stratadpwl (list "Basement" "Carpark" "Level" "Location" "Plan" "Mezzanine" "Upper" "Floor" "Ground"
		       "BASEMENT" "CARPARK" "LEVEL" "LOCATION" "PLAN" "MEZZANINE" "UPPER" "FLOOR" "GROUND"));list of words associated with strata datum point levels


;end of page setup
(princ (strcat "\nLandxml for Autocad NSW Recipe Version " version ))
(princ "\nCommand List")
(princ "\nXSS - Set Drawing Scale")
(princ "\nXRD - Set Drawing to Round")
(princ "\nXMLC - Redefine Lot Centre Positions")

(princ "\nXTR - Traverse")
(princ "\nXTA - Arc Traverse")
(princ "\nXCL - Create Lot")
(princ "\nXCE - Create Easement Lot")
(princ "\nXCR - Create Road Lot")
(princ "\nXRM - Create reference mark")
(PRINC "\nXDRM - Create Double reference mark")
(princ "\nXCM - Create mark, add non peg mark to corner")
(princ "\nXPM - Create PM mark (PM or SSM)")
(princ "\nXBM - Create Benchmark (PM or SSM)")
(princ "\nXSF - Add combined scale factor information to line")
(princ "\nXHD - Add height difference to line")
(princ "\nXDP - Create Datum Point")
(princ "\nXOC - Create occupation offset")
(princ "\nXOQ - Create Queensland style point occupation")
(princ "\nXCP - Create Pops on Lot corners")
(princ "\nXAS - Create Admin Sheet")
(princ "\nXAS2 - Create Admin Sheet page 2")
(princ "\nXLA - Add Layout Sheet")
(princ "\nXEL - Create Easement Legend")
(princ"\n ")
(princ "\nXAL- Assign line to XML")
(princ "\nXALN - Assign line with note")
(princ "\nXALC - Assign line as compiled")
(princ "\nXALCN - Assign line as compiled with note")
(princ "\nXAA - Assign arc to XML")
(princ "\nXAAN - Assign arc with note")
(princ "\nXAAC - Assign arc as compiled")
(princ "\nXAACN - Assign arc as compiled with note")
(princ "\nXAP - Assign Polyline Lot to XML")
(princ "\nXAE - Assign Polyline Easement to XML")
(princ "\nXAR - Assign Polyline Road to XML")
(princ "\nXJL - Assign Polyline to Adjoining Boundary")
(princ "\nXJR - Assign Polyline to Existing Road")
(princ "\nXJO - Assign Polyline to Other boundary type")
(princ "\nXAM - Assign Reference Mark from points")
(princ "\nXAI - Assign Polyline as Irregular Boundary")
(princ "\nXAO - Assign description to Occupation")
(princ "\nXUP - Assign Use of Parcel to lot")
(princ "\n ")
(princ "\nXSL - Assign lines to Short Line Table")
(princ "\nXSC - Assign arcs to Short Line Table")
(princ "\nXSW - Swap text positions")
(princ "\nXSP - Spin text 180�")
(princ "\nXCB - Create Brackets around text")
(princ "\nXRT - Recreate text from xdata")
(princ "\nXDE - Edit xdata manually")
(princ "\nXBE - Edit bulk data single attrribute")
(princ "\nXHV - View xdata by hovering")
(princ "\nXCT - Tidy coordinates")
(princ "\nXAUD - Audit xdata against geometry")
(princ "\n ")
(princ "\nXSA - Assign Polyline to Strata lot")
(princ "\nXST - Total Strata Areas")
(princ "\nXVI - Assign Level to Vinculumn")
(princ "\nXLV - Assign Level to Object")
(princ "\nXSD - Draft Strata walls")
(princ "\nXSDR - Reverse draft strata walls")
(princ "\nXALS - Assign strata line")
(princ "\nXALSN - Assign strata line with note")
(princ "\nXALSM - Assign strata line with manual distance")
(princ "\nXALSMN - Assign strata lines with manual distance and note")
(princ "\nXAAS - Assign strata arc")
(princ "\nXAASN - Assign strata arc with note")
(princ "\n ")
(princ "\nXIN - Import XML file")
(princ "\nXINO - Import XML file from observations")
(princ "\nXINS - Import simple XML file from observations")
(princ "\nXOUT - Export XML file")
(princ (strcat "\nLandxml for Autocad NSW Recipe Version " version ))



;-------------------------------------------------------------------SET SCALE AND AUTOROUND-------------------------------------
(defun C:XSS (/)
  (PRINC (strcat "\nCurrent Scale 1:" (rtos scale 2 0)))
(setq SCALE (getreal "\nType Scale 1:"))
  (setq TH (* 2.5 (/ scale 1000 )))
  (setvar "celtscale" (/ (/ scale 100) 2))
  (setq ATHR (getstring "\nAutomatically Reduce Text Height? (Y/N):"))
  (if (or (= ATHR "")(= ATHR "y")(= ATHR "YES")(= ATHR "Yes")(= ATHR "yes"))(setq ATHR "Y"))
  (VLAX-LDATA-PUT "LXML4AC" "scale" scale)
  (VLAX-LDATA-PUT "LXML4AC" "TH" TH)
  (VLAX-LDATA-PUT "LXML4AC" "ATHR" ATHR) 
  
)

(defun C:XRD (/)
  (SETQ QROUND (GETSTRING "\nDo you want to Autoround when using Assigning Tools?(Y/N):"))
  (IF (OR (= QROUND "Y") (= QROUND "y"))(progn (SETQ QROUND "YES")
					  (princ (strcat "\nCurrent Values \nBearings \nLess than " (rtos maxlen1 2 3) "m round to " (rtos brnd1 2 0) " seconds"
							 "\nFrom " (rtos maxlen1 2 3) "m to " (rtos maxlen2 2 3) "m round to " (rtos brnd2 2 0) " seconds"
							 "\nGreater than " (rtos maxlen2 2 3) "m round to " (rtos brnd3 2 0) " seconds"
							 "\nDistance \nLess than " (rtos distmax1  2 3) "m round to " (rtos drnd1 2 3)
							 "\nFrom " (rtos distmax1 2 3) "m to " (rtos distmax2 2 3) "m round to " (rtos drnd2 2 3)
							 "\nGreater than " (rtos distmax2 2 3) "m round to " (rtos drnd3 2 3)
							 "\nAlways round areas down:" ard))
					  
					  (setq cvals (getstring "\nDo you wish to change these values?(Y/N):"))
					   (IF (OR (= cvals "Y") (= cvals "y"))(changerounding))
					  )
  (IF (OR (= QROUND "N") (= QROUND "n"))(SETQ QROUND "NO"))
  )
  (VLAX-LDATA-PUT "LXML4AC" "qround" qround) 
  )


  (defun changerounding (/)
    (princ "\nBearings")
    (setq maxlen1s (getstring (strcat "\nLess than <" (rtos maxlen1 2 3) ">:"  )))
    (if (/= maxlen1s "")(setq maxlen1 (atof maxlen1s)))
    (setq brnd1s (getstring (strcat "\nRound to how many seconds? <"(rtos brnd1 2 3) ">:")))
    (if (/= brnd1s "")(setq brnd1 (atof brnd1s)))
    (setq maxlen2s (getstring (strcat "\nFrom " (rtos maxlen1 2 3) " to <" (rtos maxlen2 2 3)">:")))
    (if (/= maxlen2s "")(setq maxlen2 (atof maxlen2s)))
    (setq brnd2s (getstring (strcat "\nRound to how many seconds? <" (rtos brnd2 2 3) ">:")))
    (if (/= brnd2s "")(setq brnd2 (atof brnd2s)))
    (setq brnd3s (getstring (strcat "\nGreater than " (rtos maxlen2 2 3) " round to how many seconds? <" (rtos brnd3 2 3) ">:")))
    (if (/= brnd3s "")(setq brnd3 (atof brnd3s)))
    (princ "\nDistances")
    (setq distmax1s (getstring (strcat "\nLess than <" (rtos distmax1 2 3) ">:")))
    (if (/= distmax1s "")(setq distmax1 (atof distmax1s)))
    (setq drnd1s (getstring (strcat "\nRound to (in metres) <" (rtos drnd1 2 3) ">:")))
    (if (/= drnd1s "")(setq drnd1 (atof drnd1s)))
    (setq distmax2s (getstring (strcat "\nFrom " (rtos distmax1 2 3) " to <" (rtos distmax2 2 3) ">:")))
    (if (/= distmax2s "")(setq distmax2 (atof distmax2s )))
    (setq drnd2s  (getstring (strcat "\nRound to (in metres) <"(rtos drnd2 2 3) ">:") ))
    (if (/= drnd2s "")(setq drnd2 (atof drnd2s)))
    (setq drnd3s  (getstring (strcat "\nGreater than " (rtos distmax2 2 3) " round to (in metres) <"(rtos drnd3 2 3) ">:")))
    (if (/= drnd3s "")(setq drnd3 (atof drnd3s)))
    (setq ards  (getstring (strcat "\nAlways round areas down(YES/NO) <" ard ">:")))
    (if (/= ards "")(setq ard ards))
    (if (or (= ard "Y")(= ard "y")(= ard "Yes")(= ard "yes"))(setq ard "YES"))
    (if (or (= ard "N")(= ard "n")(= ard "No")(= ard "no"))(setq ard "NO"))

    ;store values in dwg
 (VLAX-LDATA-PUT "LXML4AC" "MAXLEN1" MAXLEN1)   
  (VLAX-LDATA-PUT "LXML4AC" "maxlen2" maxlen2)   
  (VLAX-LDATA-PUT "LXML4AC" "brnd1" brnd1)   
 (VLAX-LDATA-PUT "LXML4AC" "brnd2" brnd2)   
 (VLAX-LDATA-PUT "LXML4AC" "brnd3" brnd3)   
  (VLAX-LDATA-PUT "LXML4AC" "distmax1" distmax1)   
  (VLAX-LDATA-PUT "LXML4AC" "distmax2" distmax2)   
 (VLAX-LDATA-PUT "LXML4AC" "drnd1" drnd1)   
 (VLAX-LDATA-PUT "LXML4AC" "drnd2" drnd2)   
 (VLAX-LDATA-PUT "LXML4AC" "drnd3" drnd3)
    (VLAX-LDATA-PUT "LXML4AC" "ard" ard)   
   
    )

  

;--------------------------Remove Element from List Function-----------------------------
(defun remove_nth ( lst n / lstn)
  (setq n (1+ n))
  (mapcar (function (lambda (x) (if (not (zerop (setq n (1- n))))(setq lstn (cons x lstn))))) lst)
  (reverse lstn)
  )

;---------------------------Replace element function-------------------------------------
(defun ReplaceItem (place item lst / lol i)

(if (and lst (>= (length lst) place))
(progn
(setq i 0)
(repeat (length lst)
(setq lol (cons (if (eq place (1+ i))
                        item
                          (nth i lst)
                        )
                        lol
                  )
        )
        (setq i (1+ i))
      );r
));p&if
 (reverse lol)
);defun

;--------------------------check polyline direction function------------------------------
 (defun LCW ( lst )
 
(apply '+ 
(mapcar
 (function
 (lambda ( a b )
 (- (* (car b) (cadr a)) (* (car a) (cadr b)))
 )
 ) lst (cons (last lst) lst)
 )
 )
 )
;---------------------------calcualate lot centre-----------------------------------------
(defun CALCLOTC (ptlist)
 ;calc lot centre if not specified
       
			 (setq easttot 0)
			 (setq northtot 0)
			 (if (= (nth 0 ptlist)(nth (- (length ptlist) 1) ptlist))(setq n (- (length ptlist) 1))(setq n (length ptlist)));make repeat for closed or unclosed list

			 (setq avgcnt 0)
			 (repeat n
			   (setq pnt (nth avgcnt ptlist))
       (setq east (nth 0 pnt))
    (setq north  (nth 1 pnt))
			   (setq easttot (+ easttot east))
			   (setq northtot (+ northtot north))
			   (setq avgcnt (+ avgcnt 1))
			   )
			 (setq lotc (list (/ easttot n)(/ northtot n)))
			 
			 

)

;-------------------------------------------------------------------TRAVERSE-------------------------------------
(defun C:XTR (/)

  ;GET 1ST LINE INFO
    (graphscr)
    
    (setq p1 (getpoint "\nEnter start coords: "))
    (setq bearing (getstring "\nBearing(DD.MMSS): "))
        (setq dist (getstring T (strcat "\nDistance[Meters/Feet/Links]" units ":")))

  (if (or (= dist "f") (= dist "F") (= dist "Feet") (= dist "feet") (= dist "FEET"))
    (progn
      (setq dist (getstring T "\nDistance(Feet FF.II.n/d ): "))
      (setq units "F")
      )
    )

  (if (or (= dist "l") (= dist "L") (= dist "Links") (= dist "LINKS") (= DIST "links"))
    (progn
      (setq dist (getstring T "\nDistance(Links): "))
      (setq units "L")
      )
    )

    (if (or (= dist "m") (= dist "M") (= dist "Meters") (= dist "meters") (= DIST "METERS"))
    (progn
      (setq dist (getstring T "\nDistance(Meters): "))
      (setq units "M")
      )
    )
  (setq prevdist dist)
 

  (if (or (= units "F")(= units "L"));label ye old distances when typeing them in for checking
    (setq labelyeolddist 1)
    (setq labelyeolddist 0)
    )
 ;APPLY ALL CORRECTIONS AND EXTRACT INFORMATION FROM USER INPUT

  ;reverse
  (if (or (= (substr bearing 1 1 ) "r") (= (substr bearing 1 1 ) "R" ))
    (progn
      (setq bearing (substr bearing 2 50))
      (setq rswitch "T")
      )
     (setq rswitch "F")
    )

;look for cardinals
  (setq card1 ""
	card2 "")
  (IF (OR (= (substr bearing 1 1 ) "n") (= (substr bearing 1 1 ) "N" )
	  (= (substr bearing 1 1 ) "s" )(= (substr bearing 1 1 ) "S" )
	  (= (substr bearing 1 1 ) "e" )(= (substr bearing 1 1 ) "E" )
	  (= (substr bearing 1 1 ) "w" )(= (substr bearing 1 1 ) "W" ))
(progn
    (setq card1 (substr bearing 1 1))
    (setq card2 (substr bearing (strlen bearing) 1))
    (setq bearing (substr bearing 2 (- (strlen bearing )2)))
  )
    )
    
  
(if (/= (vl-string-position 46 bearing 0) nil ) (PROGN
  (setq dotpt1 (vl-string-position 46 bearing 0))
  (setq deg  (substr bearing 1  dotpt1 ))
  (SETQ mins  (strcat (substr bearing (+ dotpt1 2) 2) (chr 39)))
  (setq sec  (substr bearing (+ dotpt1 4) 10))

  
  (if (> (strlen sec) 2) (setq sec (strcat (substr sec 1 2) "." (substr sec 3 10))))
  (if (= (strlen sec) 0) (setq sec "") (setq sec (strcat sec (chr 34))))

    (if (or
	(= (strlen sec) 2)
	(= (strlen mins) 2)
	(> (atof mins) 60)
	(> (atof sec) 60)
	(> (atof deg) 360)
	)
    (alert (strcat "That bearing looks a little funky - " bearing)))
  
  
  );P
	(progn
	  (setq deg bearing)
	  (setq mins "")
	  (setq sec "")
	  );p else
  
  );IF

 ;correct cardinals
  (if (and (or (= card1 "n")(= card1 "N"))(or (= card2 "w")(= card2 "W")))
    (progn
      (setq deg (rtos (- 360 (atof deg)) 2 0))
      (if (< 0 (atof mins))(progn
			     (setq mins (strcat (rtos (- 60 (atof mins)) 2 0) (chr 39)))
			     (setq deg (rtos (- (atof deg) 1) 2 0))
			     (if (< (atof deg) 0)(setq deg (rtos (+ (atof deg) 360) 2 0)))
				)
	     )
	(if (< 0 (atof sec))
	       (progn
		 (setq sec (strcat (rtos (- 60 (atof sec)) 2 0) (chr 34)))
		 (if (= 0 (atof mins)) (setq deg (rtos (- (atof deg) 1) 2 0)))
		 (setq mins (strcat (rtos (- (atof mins) 1) 2 0) (chr 39)))
	       
		 (if (< (atof deg) 0)(setq deg (rtos (+ (atof deg) 360) 2 0)))
		 (if (< (atof mins) 0)(setq mins (strcat (rtos (+ (atof mins) 60) 2 0)(chr 39))))
		 )
	  )
      	           
(if (or (and (< (atof mins) 10)(/= 0 (atof mins))) (= mins "0'")) (setq mins (strcat "0" mins)))
(if (and (< (atof sec) 10)(/= 0 (atof sec))) (setq sec (strcat "0" sec)))
		 
      )
    );NW

		   

		   (if (and (or (= card1 "w")(= card1 "W"))(or (= card2 "s")(= card2 "S")))
    (progn
      (setq deg (rtos (- 270 (atof deg)) 2 0))
      (if (< 0 (atof mins))(progn
			     (setq mins (strcat (rtos (- 60 (atof mins)) 2 0) (chr 39)))
			     (setq deg (rtos (- (atof deg) 1) 2 0))
			     (if (< (atof deg) 0)(setq deg (rtos (+ (atof deg) 360) 2 0)))
				)
	     )
	(if (< 0 (atof sec))
	       (progn
		 (setq sec (strcat (rtos (- 60 (atof sec)) 2 0) (chr 34)))
		 (if (= 0 (atof mins)) (setq deg (rtos (- (atof deg) 1) 2 0)))
		 (setq mins (strcat (rtos (- (atof mins) 1) 2 0) (chr 39)))
	       
		 (if (< (atof deg) 0)(setq deg (rtos (+ (atof deg) 360) 2 0)))
		 (if (< (atof mins) 0)(setq mins (strcat (rtos (+ (atof mins) 60) 2 0)(chr 39))))
		 )
	  )
      	           
(if (or (and (< (atof mins) 10)(/= 0 (atof mins))) (= mins "0'")) (setq mins (strcat "0" mins)))
(if (and (< (atof sec) 10)(/= 0 (atof sec))) (setq sec (strcat "0" sec)))
		 
      )
    );WS

		   
		   (if (and (or (= card1 "e")(= card1 "E"))(or (= card2 "n")(= card2 "N")))
    (progn
      (setq deg (rtos (- 90 (atof deg)) 2 0))
      (if (< 0 (atof mins))(progn
			     (setq mins (strcat (rtos (- 60 (atof mins)) 2 0) (chr 39)))
			     (setq deg (rtos (- (atof deg) 1) 2 0))
			     (if (< (atof deg) 0)(setq deg (rtos (+ (atof deg) 360) 2 0)))
				)
	     )
	(if (< 0 (atof sec))
	       (progn
		 (setq sec (strcat (rtos (- 60 (atof sec)) 2 0) (chr 34)))
		 (if (= 0 (atof mins)) (setq deg (rtos (- (atof deg) 1) 2 0)))
		 (setq mins (strcat (rtos (- (atof mins) 1) 2 0) (chr 39)))
	       
		 (if (< (atof deg) 0)(setq deg (rtos (+ (atof deg) 360) 2 0)))
		 (if (< (atof mins) 0)(setq mins (strcat (rtos (+ (atof mins) 60) 2 0)(chr 39))))
		 )
	  )
      	           
(if (or (and (< (atof mins) 10)(/= 0 (atof mins))) (= mins "0'")) (setq mins (strcat "0" mins)))
(if (and (< (atof sec) 10)(/= 0 (atof sec))) (setq sec (strcat "0" sec)))
		 
      )
    );EN

  (if (and (or (= card1 "s")(= card1 "S"))(or (= card2 "e")(= card2 "E")))
    (progn
      (setq deg (rtos (- 180 (atof deg)) 2 0))
      (if (< 0 (atof mins))(progn
			     (setq mins (strcat (rtos (- 60 (atof mins)) 2 0) (chr 39)))
			     (setq deg (rtos (- (atof deg) 1) 2 0))
			     (if (< (atof deg) 0)(setq deg (rtos (+ (atof deg) 360) 2 0)))
				)
	     )
	(if (< 0 (atof sec))
	       (progn
		 (setq sec (strcat (rtos (- 60 (atof sec)) 2 0) (chr 34)))
		 (if (= 0 (atof mins)) (setq deg (rtos (- (atof deg) 1) 2 0)))
		 (setq mins (strcat (rtos (- (atof mins) 1) 2 0) (chr 39)))
	       
		 (if (< (atof deg) 0)(setq deg (rtos (+ (atof deg) 360) 2 0)))
		 (if (< (atof mins) 0)(setq mins (strcat (rtos (+ (atof mins) 60) 2 0)(chr 39))))
		 )
	  )
      	           
(if (or (and (< (atof mins) 10)(/= 0 (atof mins))) (= mins "0'")) (setq mins (strcat "0" mins)))
(if (and (< (atof sec) 10)(/= 0 (atof sec))) (setq sec (strcat "0" sec)))
		 
      )
    );SE

  (if (and (or (= card1 "s")(= card1 "S"))(or (= card2 "w")(= card2 "W")))
    (progn
      (setq deg (rtos (+ 180 (atof deg)) 2 0))
      
      )
    );SW

		    (if (and (or (= card1 "w")(= card1 "W"))(or (= card2 "n")(= card2 "N")))
    (progn
      (setq deg (rtos (+ 270 (atof deg)) 2 0))
      
      )
    );WN
		    (if (and (or (= card1 "e")(= card1 "E"))(or (= card2 "s")(= card2 "S")))
    (progn
      (setq deg (rtos (+ 90 (atof deg)) 2 0))
      
      )
    );ES
  
		   (if (and (= mins "")(= sec ""))(setq decimal "")(setq decimal "."))
	(setq lbearing (strcat deg decimal (substr mins 1 2) (substr sec 1 2)))
 (IF (= rswitch "T")(setq lbearing (strcat "R" lbearing)))
  
  



  ;look for line comment
  (setq spcpos1 (vl-string-position 32 dist 0))
	(if (= spcpos1 nil)(setq comment "")(progn
					      (setq comment (substr dist ( + spcpos1 2) 50))
					      (setq dist (substr dist 1  spcpos1 ))
					      )
	  )


  
    (if (= units "F")
      (progn
	 (setq dotpos1 (vl-string-position 46 dist 0)) 
		    
	(if (= dotpos1 nil)(setq dotpos2 nil)(setq dotpos2 (vl-string-position 46 dist (+ dotpos1 1))))
	(setq /pos1 (vl-string-position 47 dist 0))
	(if (/= /pos1 nil)
	  (progn
	    (setq den (substr dist ( + /pos1 2) 50))
	    (setq num (substr dist ( + dotpos2 2) (- (- /pos1 dotpos2) 1)))
	    (setq idist (/ (atof num) (atof den)))
	    (setq inches (substr dist (+ dotpos1 2) (- (- dotpos2 dotpos1) 1)))
	    (setq idist (+ idist (atof inches)))
	    (setq feet (substr dist 1  dotpos1 ))
	    (setq idist (+ idist (* (atof feet) 12)))
	    (setq dist (rtos (* idist 0.0254) 2 9))
	    )
	  )
	(if (and (/= dotpos1 nil) (= /pos1 nil))
	  (progn
	    (setq inches (substr dist ( + dotpos1 2) 50))
	    (setq feet (substr dist 1  dotpos1 ))
	    (setq idist  (atof inches))
	    (setq idist (+ idist (* (atof feet) 12)))
	    (setq dist (rtos (* idist 0.0254) 2 9))
	    )
	  )
	(if (and (= dotpos1 nil) (= /pos1 nil) (= dotpos2 nil))
	  (progn
	   
	    (setq feet (substr dist 1  50))
	    (setq idist (* (atof feet) 12))
	    (setq dist (rtos (* idist 0.0254) 2 9))
	    )
	  )
      )
    )
  (if (= units "L")
    (progn
      (setq dist (atof dist))
      (setq dist (rtos (* dist 0.201168)))
      )
    )
	      
	      

    ;DRAW LINE 1
     
  (IF ( = rswitch "T")(setq obearing (substr lbearing 2 200))(setq obearing lbearing))
  (setq dist (rtos (atof dist)2 3));remove trailing zeros
  (if (= dist "0") (progn
		     (princ "\nDistance of 0 entered")
		     (exit))
    )
  (setq ldist dist)
  (setq bearing (strcat  deg "d" mins sec))

  (setq linetext (strcat "@" dist "<" bearing))
    (command "line" p1 linetext "")

;Add observation data to line as XDATA


  
   
  (if (/= comment "")(setq ocomment (strcat "><FieldNote>\"" comment "\"</FieldNote></ReducedObservation>"))(setq ocomment "/>"))
(SETQ BDINFO (STRCAT "azimuth=\"" obearing "\" horizDistance=\"" ldist "\" distanceType=\"Measured\"" ocomment))
(SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 BDINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)

  
;Move line if reverse activated
(if (= rswitch "T")
  (progn
    (setq p1 (CDR(ASSOC 10 sentlist)))
    (setq p2 (CDR(ASSOC 11 sentlist)))
    (command "move" sent "" p2 p1)

;get last line end point
(SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
(setq p1 (CDR(ASSOC 10 sentlist)))    
    
    );p
  
;get last line end point if not reverse
  (progn
(SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
(setq p1 (CDR(ASSOC 11 sentlist)))
);p else

  

);if
  (setq p1 (trans p1 0 1))

  (lba)
(setvar "clayer" prevlayer)

  ;GET 2ND+ LINE INFO
  (while (> 1 0) (progn
		   (setq bearing (getstring "\nBearing [Last]: "))

        (setq dist (getstring T (strcat "\nDistance [Last]" units ":")))

		   (if (or (= bearing "Last") (= bearing "L") (= bearing "l") (= bearing "" )) (setq bearing lbearing))
		   (if (or (= dist "Last") (= dist "L") (= dist "l") (= dist "")) (setq dist prevdist))
		   (setq prevdist dist)


 ;APPLY ALL CORRECTIONS AND EXTRACT INFORMATION FROM USER INPUT


  (if (or (= units "F")(= units "L"));label ye old distances when typeing them in for checking
    (setq labelyeolddist 1)
    (setq labelyeolddist 0)
    )

  ;reverse
  (if (or (= (substr bearing 1 1 ) "r") (= (substr bearing 1 1 ) "R" ))
    (progn
      (setq bearing (substr bearing 2 50))
      (setq rswitch "T")
      )
     (setq rswitch "F")
    )

  ;look for cardinals
  (setq card1 ""
	card2 "")
  (IF (OR (= (substr bearing 1 1 ) "n") (= (substr bearing 1 1 ) "N" )
	  (= (substr bearing 1 1 ) "s" )(= (substr bearing 1 1 ) "S" )
	  (= (substr bearing 1 1 ) "e" )(= (substr bearing 1 1 ) "E" )
	  (= (substr bearing 1 1 ) "w" )(= (substr bearing 1 1 ) "W" ))
(progn
    (setq card1 (substr bearing 1 1))
    (setq card2 (substr bearing (strlen bearing) 1))
    (setq bearing (substr bearing 2 (- (strlen bearing )2)))
  )
    )
    
  
(if (/= (vl-string-position 46 bearing 0) nil ) (PROGN
  (setq dotpt1 (vl-string-position 46 bearing 0))
  (setq deg  (substr bearing 1  dotpt1 ))
  (SETQ mins  (strcat (substr bearing (+ dotpt1 2) 2) (chr 39)))
  (setq sec  (substr bearing (+ dotpt1 4) 10))

  
  (if (> (strlen sec) 2) (setq sec (strcat (substr sec 1 2) "." (substr sec 3 10))))
  (if (= (strlen sec) 0) (setq sec "") (setq sec (strcat sec (chr 34))))

    (if (or
	(= (strlen sec) 2)
	(= (strlen mins) 2)
	(> (atof mins) 60)
	(> (atof sec) 60)
	(> (atof deg) 360)
	)
    (alert (strcat "That bearing looks a little funky - " bearing)))
  
  );P
	(progn
	  (setq deg bearing)
	  (setq mins "")
	  (setq sec "")
	  );p else
  
  );IF

 ;correct cardinals
  (if (and (or (= card1 "n")(= card1 "N"))(or (= card2 "w")(= card2 "W")))
    (progn
      (setq deg (rtos (- 360 (atof deg)) 2 0))
      (if (< 0 (atof mins))(progn
			     (setq mins (strcat (rtos (- 60 (atof mins)) 2 0) (chr 39)))
			     (setq deg (rtos (- (atof deg) 1) 2 0))
			     (if (< (atof deg) 0)(setq deg (rtos (+ (atof deg) 360) 2 0)))
				)
	     )
	(if (< 0 (atof sec))
	       (progn
		 (setq sec (strcat (rtos (- 60 (atof sec)) 2 0) (chr 34)))
		 (if (= 0 (atof mins)) (setq deg (rtos (- (atof deg) 1) 2 0)))
		 (setq mins (strcat (rtos (- (atof mins) 1) 2 0) (chr 39)))
	       
		 (if (< (atof deg) 0)(setq deg (rtos (+ (atof deg) 360) 2 0)))
		 (if (< (atof mins) 0)(setq mins (strcat (rtos (+ (atof mins) 60) 2 0)(chr 39))))
		 )
	  )
      	           
(if (or (and (< (atof mins) 10)(/= 0 (atof mins))) (= mins "0'")) (setq mins (strcat "0" mins)))
(if (and (< (atof sec) 10)(/= 0 (atof sec))) (setq sec (strcat "0" sec)))
		 
      )
    );NW

		   

		   (if (and (or (= card1 "w")(= card1 "W"))(or (= card2 "s")(= card2 "S")))
    (progn
      (setq deg (rtos (- 270 (atof deg)) 2 0))
      (if (< 0 (atof mins))(progn
			     (setq mins (strcat (rtos (- 60 (atof mins)) 2 0) (chr 39)))
			     (setq deg (rtos (- (atof deg) 1) 2 0))
			     (if (< (atof deg) 0)(setq deg (rtos (+ (atof deg) 360) 2 0)))
				)
	     )
	(if (< 0 (atof sec))
	       (progn
		 (setq sec (strcat (rtos (- 60 (atof sec)) 2 0) (chr 34)))
		 (if (= 0 (atof mins)) (setq deg (rtos (- (atof deg) 1) 2 0)))
		 (setq mins (strcat (rtos (- (atof mins) 1) 2 0) (chr 39)))
	       
		 (if (< (atof deg) 0)(setq deg (rtos (+ (atof deg) 360) 2 0)))
		 (if (< (atof mins) 0)(setq mins (strcat (rtos (+ (atof mins) 60) 2 0)(chr 39))))
		 )
	  )
      	           
(if (or (and (< (atof mins) 10)(/= 0 (atof mins))) (= mins "0'")) (setq mins (strcat "0" mins)))
(if (and (< (atof sec) 10)(/= 0 (atof sec))) (setq sec (strcat "0" sec)))
		 
      )
    );WS

		   
		   (if (and (or (= card1 "e")(= card1 "E"))(or (= card2 "n")(= card2 "N")))
    (progn
      (setq deg (rtos (- 90 (atof deg)) 2 0))
      (if (< 0 (atof mins))(progn
			     (setq mins (strcat (rtos (- 60 (atof mins)) 2 0) (chr 39)))
			     (setq deg (rtos (- (atof deg) 1) 2 0))
			     (if (< (atof deg) 0)(setq deg (rtos (+ (atof deg) 360) 2 0)))
				)
	     )
	(if (< 0 (atof sec))
	       (progn
		 (setq sec (strcat (rtos (- 60 (atof sec)) 2 0) (chr 34)))
		 (if (= 0 (atof mins)) (setq deg (rtos (- (atof deg) 1) 2 0)))
		 (setq mins (strcat (rtos (- (atof mins) 1) 2 0) (chr 39)))
	       
		 (if (< (atof deg) 0)(setq deg (rtos (+ (atof deg) 360) 2 0)))
		 (if (< (atof mins) 0)(setq mins (strcat (rtos (+ (atof mins) 60) 2 0)(chr 39))))
		 )
	  )
      	           
(if (or (and (< (atof mins) 10)(/= 0 (atof mins))) (= mins "0'")) (setq mins (strcat "0" mins)))
(if (and (< (atof sec) 10)(/= 0 (atof sec))) (setq sec (strcat "0" sec)))
		 
      )
    );EN

  (if (and (or (= card1 "s")(= card1 "S"))(or (= card2 "e")(= card2 "E")))
    (progn
      (setq deg (rtos (- 180 (atof deg)) 2 0))
      (if (< 0 (atof mins))(progn
			     (setq mins (strcat (rtos (- 60 (atof mins)) 2 0) (chr 39)))
			     (setq deg (rtos (- (atof deg) 1) 2 0))
			     (if (< (atof deg) 0)(setq deg (rtos (+ (atof deg) 360) 2 0)))
				)
	     )
	(if (< 0 (atof sec))
	       (progn
		 (setq sec (strcat (rtos (- 60 (atof sec)) 2 0) (chr 34)))
		 (if (= 0 (atof mins)) (setq deg (rtos (- (atof deg) 1) 2 0)))
		 (setq mins (strcat (rtos (- (atof mins) 1) 2 0) (chr 39)))
	       
		 (if (< (atof deg) 0)(setq deg (rtos (+ (atof deg) 360) 2 0)))
		 (if (< (atof mins) 0)(setq mins (strcat (rtos (+ (atof mins) 60) 2 0)(chr 39))))
		 )
	  )
      	           
(if (or (and (< (atof mins) 10)(/= 0 (atof mins))) (= mins "0'")) (setq mins (strcat "0" mins)))
(if (and (< (atof sec) 10)(/= 0 (atof sec))) (setq sec (strcat "0" sec)))
		 
      )
    );SE

  (if (and (or (= card1 "s")(= card1 "S"))(or (= card2 "w")(= card2 "W")))
    (progn
      (setq deg (rtos (+ 180 (atof deg)) 2 0))
      
      )
    );SW

		    (if (and (or (= card1 "w")(= card1 "W"))(or (= card2 "n")(= card2 "N")))
    (progn
      (setq deg (rtos (+ 270 (atof deg)) 2 0))
      
      )
    );WN
		    (if (and (or (= card1 "e")(= card1 "E"))(or (= card2 "s")(= card2 "S")))
    (progn
      (setq deg (rtos (+ 90 (atof deg)) 2 0))
      
      )
    );ES

		   (if (and (= mins "")(= sec ""))(setq decimal "")(setq decimal "."))
	(setq lbearing (strcat deg decimal (substr mins 1 2) (substr sec 1 2)))
 (IF (= rswitch "T")(setq lbearing (strcat "R" lbearing)))	   

  

  
		  
		   (setq bearing (strcat  deg "d" mins sec))

		   ;look for line comment
  (setq spcpos1 (vl-string-position 32 dist 0))
	(if (= spcpos1 nil)(setq comment "")(progn
					      (setq comment (substr dist ( + spcpos1 2) 50))
					      (setq dist (substr dist 1  spcpos1 ))
					      )
	  )
		   
		   (if (= units "F")
      (progn
(setq dotpos1 (vl-string-position 46 dist 0))
	(if (= dotpos1 nil)(setq dotpos2 nil)(setq dotpos2 (vl-string-position 46 dist (+ dotpos1 1))))
	(setq /pos1 (vl-string-position 47 dist 0))
	(if (/= /pos1 nil)
	  (progn
	    (setq den (substr dist ( + /pos1 2) 50))
	    (setq num (substr dist ( + dotpos2 2) (- (- /pos1 dotpos2) 1)))
	    (setq idist (/ (atof num) (atof den)))
	    (setq inches (substr dist (+ dotpos1 2) (- (- dotpos2 dotpos1) 1)))
	    (setq idist (+ idist (atof inches)))
	    (setq feet (substr dist 1  dotpos1 ))
	    (setq idist (+ idist (* (atof feet) 12)))
	    (setq dist (rtos (* idist 0.0254) 2 9))
	    );P
	  );IF
	(if (and (/= dotpos1 nil) (= /pos1 nil))
	  (progn
	    (setq inches (substr dist ( + dotpos1 2) 50))
	    (setq feet (substr dist 1   dotpos1 ))
	    (setq idist  (atof inches))
	    (setq idist (+ idist (* (atof feet) 12)))
	    (setq dist (rtos (* idist 0.0254) 2 9))
	    );P
	  );IF
	(if (and (= dotpos1 nil) (= /pos1 nil) (= dotpos2 nil))
	  (progn
	   
	    (setq feet (substr dist 1  50))
	    (setq idist (* (atof feet) 12))
	    (setq dist (rtos (* idist 0.0254) 2 9))
	    );P
	  );IF
      );P
    );IF
  (if (= units "L")
    (progn
      (setq dist (atof dist))
      (setq dist (rtos (* dist 0.201168)))
      );P
    );IF

		;DRAW LINE 2+

		    (setq dist (rtos (atof dist)2 3));remove trailing zeros
		   (if (= dist "0") (progn
		     (princ "\nDistance of 0 entered")
		     (exit))
    )
  (setq ldist dist)
	(IF ( = rswitch "T")(setq obearing (substr lbearing 2 200))(setq obearing lbearing))	   
    

  (setq linetext (strcat "@" dist "<" bearing))


		   
  (command "line" p1 linetext "")
;Add observation data to line as XDATA
(if (/= comment "")(setq ocomment (strcat "><FieldNote>\"" comment "\"</FieldNote></ReducedObservation>"))(setq ocomment "/>"))
(SETQ BDINFO (STRCAT "azimuth=\"" obearing "\" horizDistance=\"" ldist "\" distanceType=\"Measured\"" ocomment))
(SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 BDINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)
 ;Move line if reverse activated
(if (= rswitch "T")
  (progn
    (setq p1 (CDR(ASSOC 10 sentlist)))
    (setq p2 (CDR(ASSOC 11 sentlist)))
    (command "move" sent "" p2 p1)

;get last line end point
(SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
(setq p1 (CDR(ASSOC 10 sentlist)))    
    
    );p
  
;get last line end point if not reverse
  (progn
(SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
(setq p1 (CDR(ASSOC 11 sentlist)))
);p else

  
  
);if

		   (setq p1 (trans p1 0 1))

(lba)		   
(setvar "clayer" prevlayer)
		   
  
);P
    );WHILE 1>0
  );DEFUN

;-------------------------------------------------------------------ARCS TRAVERSE-------------------------------------
(defun C:XTA (/)
  (setq prevlayer (getvar "CLAYER"))
  ;GET 1ST LINE INFO
    (graphscr)
    
    (setq p1 (getpoint "\nEnter start coords: "))
    (setq bearing (getstring "\nChord Bearing(DD.MMSS): "))
        (setq dist (getstring T (strcat "\nChord Distance[Meters/Feet/Links]" units ":")))

  (if (or (= dist "f") (= dist "F") (= dist "Feet") (= dist "feet") (= dist "FEET"))
    (progn
      (setq dist (getstring T "\nDistance(Feet FF.II.n/d ): "))
      (setq units "F")
      )
    )

  (if (or (= dist "l") (= dist "L") (= dist "Links") (= dist "LINKS") (= DIST "links"))
    (progn
      (setq dist (getstring T "\nDistance(Links): "))
      (setq units "L")
      )
    )

    (if (or (= dist "m") (= dist "M") (= dist "Meters") (= dist "meters") (= DIST "METERS"))
    (progn
      (setq dist (getstring T "\nDistance(Meters): "))
      (setq units "M")
      )
    )
  (setq prevdist dist)
  

 (setq radius (getstring (strcat "\nRadius (" units "):")))
(setq prevradius radius)

  ;look for line comment
  (setq spcpos1 (vl-string-position 32 dist 0))
	(if (= spcpos1 nil)(setq comment "")(progn
					      (setq comment (substr dist ( + spcpos1 2) 50))
					      (setq dist (substr dist 1  spcpos1 ))
					      )
	  )

  
 ;APPLY ALL CORRECTIONS AND EXTRACT INFORMATION FROM USER INPUT


  ;reverse
  (if (or (= (substr bearing 1 1 ) "r") (= (substr bearing 1 1 ) "R" ))
    (progn
      (setq bearing (substr bearing 2 50))
      (setq rswitch "T")
      )
     (setq rswitch "F")
    )

;look for cardinals
  (setq card1 ""
	card2 "")
  (IF (OR (= (substr bearing 1 1 ) "n") (= (substr bearing 1 1 ) "N" )
	  (= (substr bearing 1 1 ) "s" )(= (substr bearing 1 1 ) "S" )
	  (= (substr bearing 1 1 ) "e" )(= (substr bearing 1 1 ) "E" )
	  (= (substr bearing 1 1 ) "w" )(= (substr bearing 1 1 ) "W" ))
(progn
    (setq card1 (substr bearing 1 1))
    (setq card2 (substr bearing (strlen bearing) 1))
    (setq bearing (substr bearing 2 (- (strlen bearing )2)))
  )
    )
    
  
(if (/= (vl-string-position 46 bearing 0) nil ) (PROGN
  (setq dotpt1 (vl-string-position 46 bearing 0))
  (setq deg  (substr bearing 1  dotpt1 ))
  (SETQ mins  (strcat (substr bearing (+ dotpt1 2) 2) (chr 39)))
  (setq sec  (substr bearing (+ dotpt1 4) 10))

  
  (if (> (strlen sec) 2) (setq sec (strcat (substr sec 1 2) "." (substr sec 3 10))))
  (if (= (strlen sec) 0) (setq sec "") (setq sec (strcat sec (chr 34))))

    (if (or
	(= (strlen sec) 2)
	(= (strlen mins) 2)
	(> (atof mins) 60)
	(> (atof sec) 60)
	(> (atof deg) 360)
	)
    (alert (strcat "That bearing looks a little funky - " bearing)))
  
  );P
	(progn
	  (setq deg bearing)
	  (setq mins "")
	  (setq sec "")
	  );p else
  
  );IF

 ;correct cardinals
  (if (and (or (= card1 "n")(= card1 "N"))(or (= card2 "w")(= card2 "W")))
    (progn
      (setq deg (rtos (- 360 (atof deg)) 2 0))
      (if (< 0 (atof mins))(progn
			     (setq mins (strcat (rtos (- 60 (atof mins)) 2 0) (chr 39)))
			     (setq deg (rtos (- (atof deg) 1) 2 0))
			     (if (< (atof deg) 0)(setq deg (rtos (+ (atof deg) 360) 2 0)))
				)
	     )
	(if (< 0 (atof sec))
	       (progn
		 (setq sec (strcat (rtos (- 60 (atof sec)) 2 0) (chr 34)))
		 (if (= 0 (atof mins)) (setq deg (rtos (- (atof deg) 1) 2 0)))
		 (setq mins (strcat (rtos (- (atof mins) 1) 2 0) (chr 39)))
	       
		 (if (< (atof deg) 0)(setq deg (rtos (+ (atof deg) 360) 2 0)))
		 (if (< (atof mins) 0)(setq mins (strcat (rtos (+ (atof mins) 60) 2 0)(chr 39))))
		 )
	  )
      	           
(if (or (and (< (atof mins) 10)(/= 0 (atof mins))) (= mins "0'")) (setq mins (strcat "0" mins)))
(if (and (< (atof sec) 10)(/= 0 (atof sec))) (setq sec (strcat "0" sec)))
		 
      )
    );NW

		   

		   (if (and (or (= card1 "w")(= card1 "W"))(or (= card2 "s")(= card2 "S")))
    (progn
      (setq deg (rtos (- 270 (atof deg)) 2 0))
      (if (< 0 (atof mins))(progn
			     (setq mins (strcat (rtos (- 60 (atof mins)) 2 0) (chr 39)))
			     (setq deg (rtos (- (atof deg) 1) 2 0))
			     (if (< (atof deg) 0)(setq deg (rtos (+ (atof deg) 360) 2 0)))
				)
	     )
	(if (< 0 (atof sec))
	       (progn
		 (setq sec (strcat (rtos (- 60 (atof sec)) 2 0) (chr 34)))
		 (if (= 0 (atof mins)) (setq deg (rtos (- (atof deg) 1) 2 0)))
		 (setq mins (strcat (rtos (- (atof mins) 1) 2 0) (chr 39)))
	       
		 (if (< (atof deg) 0)(setq deg (rtos (+ (atof deg) 360) 2 0)))
		 (if (< (atof mins) 0)(setq mins (strcat (rtos (+ (atof mins) 60) 2 0)(chr 39))))
		 )
	  )
      	           
(if (or (and (< (atof mins) 10)(/= 0 (atof mins))) (= mins "0'")) (setq mins (strcat "0" mins)))
(if (and (< (atof sec) 10)(/= 0 (atof sec))) (setq sec (strcat "0" sec)))
		 
      )
    );WS

		   
		   (if (and (or (= card1 "e")(= card1 "E"))(or (= card2 "n")(= card2 "N")))
    (progn
      (setq deg (rtos (- 90 (atof deg)) 2 0))
      (if (< 0 (atof mins))(progn
			     (setq mins (strcat (rtos (- 60 (atof mins)) 2 0) (chr 39)))
			     (setq deg (rtos (- (atof deg) 1) 2 0))
			     (if (< (atof deg) 0)(setq deg (rtos (+ (atof deg) 360) 2 0)))
				)
	     )
	(if (< 0 (atof sec))
	       (progn
		 (setq sec (strcat (rtos (- 60 (atof sec)) 2 0) (chr 34)))
		 (if (= 0 (atof mins)) (setq deg (rtos (- (atof deg) 1) 2 0)))
		 (setq mins (strcat (rtos (- (atof mins) 1) 2 0) (chr 39)))
	       
		 (if (< (atof deg) 0)(setq deg (rtos (+ (atof deg) 360) 2 0)))
		 (if (< (atof mins) 0)(setq mins (strcat (rtos (+ (atof mins) 60) 2 0)(chr 39))))
		 )
	  )
      	           
(if (or (and (< (atof mins) 10)(/= 0 (atof mins))) (= mins "0'")) (setq mins (strcat "0" mins)))
(if (and (< (atof sec) 10)(/= 0 (atof sec))) (setq sec (strcat "0" sec)))
		 
      )
    );EN

  (if (and (or (= card1 "s")(= card1 "S"))(or (= card2 "e")(= card2 "E")))
    (progn
      (setq deg (rtos (- 180 (atof deg)) 2 0))
      (if (< 0 (atof mins))(progn
			     (setq mins (strcat (rtos (- 60 (atof mins)) 2 0) (chr 39)))
			     (setq deg (rtos (- (atof deg) 1) 2 0))
			     (if (< (atof deg) 0)(setq deg (rtos (+ (atof deg) 360) 2 0)))
				)
	     )
	(if (< 0 (atof sec))
	       (progn
		 (setq sec (strcat (rtos (- 60 (atof sec)) 2 0) (chr 34)))
		 (if (= 0 (atof mins)) (setq deg (rtos (- (atof deg) 1) 2 0)))
		 (setq mins (strcat (rtos (- (atof mins) 1) 2 0) (chr 39)))
	       
		 (if (< (atof deg) 0)(setq deg (rtos (+ (atof deg) 360) 2 0)))
		 (if (< (atof mins) 0)(setq mins (strcat (rtos (+ (atof mins) 60) 2 0)(chr 39))))
		 )
	  )
      	           
(if (or (and (< (atof mins) 10)(/= 0 (atof mins))) (= mins "0'")) (setq mins (strcat "0" mins)))
(if (and (< (atof sec) 10)(/= 0 (atof sec))) (setq sec (strcat "0" sec)))
		 
      )
    );SE

  (if (and (or (= card1 "s")(= card1 "S"))(or (= card2 "w")(= card2 "W")))
    (progn
      (setq deg (rtos (+ 180 (atof deg)) 2 0))
      
      )
    );SW

		    (if (and (or (= card1 "w")(= card1 "W"))(or (= card2 "n")(= card2 "N")))
    (progn
      (setq deg (rtos (+ 270 (atof deg)) 2 0))
      
      )
    );WN
		    (if (and (or (= card1 "e")(= card1 "E"))(or (= card2 "s")(= card2 "S")))
    (progn
      (setq deg (rtos (+ 90 (atof deg)) 2 0))
      
      )
    );ES
  
	
  		   (if (and (= mins "")(= sec ""))(setq decimal "")(setq decimal "."))
	(setq lbearing (strcat deg decimal (substr mins 1 2) (substr sec 1 2)))
 (IF (= rswitch "T")(setq lbearing (strcat "R" lbearing)))
    
     
  

  (setq bearing (strcat  deg "d" mins sec))
  
   
    (if (= units "F")
      (progn
	(setq dotpos1 (vl-string-position 46 dist 0))
	(if (= dotpos1 nil)(setq dotpos2 nil)(setq dotpos2 (vl-string-position 46 dist (+ dotpos1 1))))
	(setq /pos1 (vl-string-position 47 dist 0))
	(if (/= /pos1 nil)
	  (progn
	    (setq den (substr dist ( + /pos1 2) 50))
	    (setq num (substr dist ( + dotpos2 2) (- (- /pos1 dotpos2) 1)))
	    (setq idist (/ (atof num) (atof den)))
	    (setq inches (substr dist (+ dotpos1 2) (- (- dotpos2 dotpos1) 1)))
	    (setq idist (+ idist (atof inches)))
	    (setq feet (substr dist 1  dotpos1 ))
	    (setq idist (+ idist (* (atof feet) 12)))
	    (setq dist (rtos (* idist 0.0254) 2 9))
	    )
	  )
	(if (and (/= dotpos1 nil) (= /pos1 nil))
	  (progn
	    (setq inches (substr dist ( + dotpos1 2) 50))
	    (setq feet (substr dist 1  dotpos1 ))
	    (setq idist  (atof inches))
	    (setq idist (+ idist (* (atof feet) 12)))
	    (setq dist (rtos (* idist 0.0254) 2 9))
	    )
	  )
	(if (and (= dotpos1 nil) (= /pos1 nil) (= dotpos2 nil))
	  (progn
	   
	    (setq feet (substr dist 1  50))
	    (setq idist (* (atof feet) 12))
	    (setq dist (rtos (* idist 0.0254) 2 9))
	    )
	  )
;radius in feet
	
	(setq dotpos1 (vl-string-position 46 radius 0))
	(if (= dotpos1 nil)(setq dotpos2 nil)(setq dotpos2 (vl-string-position 46 radius (+ dotpos1 1))))
	(setq /pos1 (vl-string-position 47 radius 0))
	(if (/= /pos1 nil)
	  (progn
	    (setq den (substr radius ( + /pos1 2) 50))
	    (setq num (substr radius ( + dotpos2 2) (- (- /pos1 dotpos2) 1)))
	    (setq idist (/ (atof num) (atof den)))
	    (setq inches (substr radius (+ dotpos1 2) (- (- dotpos2 dotpos1) 1)))
	    (setq idist (+ idist (atof inches)))
	    (setq feet (substr radius 1  dotpos1 ))
	    (setq idist (+ idist (* (atof feet) 12)))
	    (setq radius (rtos (* idist 0.0254) 2 9))
	    )
	  )
	(if (and (/= dotpos1 nil) (= /pos1 nil))
	  (progn
	    (setq inches (substr radius ( + dotpos1 2) 50))
	    (setq feet (substr radius 1  dotpos1 ))
	    (setq idist  (atof inches))
	    (setq idist (+ idist (* (atof feet) 12)))
	    (setq radius (rtos (* idist 0.0254) 2 9))
	    )
	  )
	(if (and (= dotpos1 nil) (= /pos1 nil) (= dotpos2 nil))
	  (progn
	   
	    (setq feet (substr radius 1  50))
	    (setq idist (* (atof feet) 12))
	    (setq radius (rtos (* idist 0.0254) 2 9))
	    )
	  )
	

	
	));if & p feet

  
  (if (= units "L")
    (progn
      (setq dist (atof dist))
      (setq dist (rtos (* dist 0.201168)))
      (setq radius (atof radius))
      (setq radius (rtos (* radius 0.201168)))
      
      )); if & p links
	      
	      

    ;DRAW LINE 1
  
   (setq dist (rtos (atof dist)2 3));remove trailing zeros
  (if (= dist "0") (progn
		     (princ "\nDistance of 0 entered")
		     (exit))
    )
   
  (setq dist (rtos (atof dist)2 3));remove trailing zeros
  (setq ldist dist)
  (setq lradius radius)

  (setq linetext (strcat "@" dist "<" bearing))
 
  (command "line" p1 linetext "")
(setvar "CLAYER" prevlayer )
  



  
;Move line if reverse activated
(if (= rswitch "T")
  (progn
      (SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
    (setq p1 (CDR(ASSOC 10 sentlist)))
    (setq p2 (CDR(ASSOC 11 sentlist)))
    (command "move" sent "" p2 p1)

;get last line end point
(SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
(setq p1 (CDR(ASSOC 10 sentlist)))
    (setq ap1 (CDR(ASSOC 11 sentlist))) 
    (setq ap2 (CDR(ASSOC 10 sentlist))) 
    
    );p
  
;get last line end point if not reverse
  (progn
(SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
(setq p1 (CDR(ASSOC 11 sentlist)))
(setq ap1 (CDR(ASSOC 10 sentlist)))
(setq ap2 (CDR(ASSOC 11 sentlist))) 
);p else

);if

(setq p1 (trans p1 0 1))
(setq ap1 (trans ap1 0 1))
  (setq ap2 (trans ap2 0 1))


(Setq op1 (getpoint "Select Side of line to draw arc:"))
  (command "erase" sent "")
  (setq offang (+ (angle ap1 ap2) (* 0.5 pi)))
  (if (> offang (* 2 pi))(setq offang (- offang (* 2 pi))))
  (setq op2 (polar op1 offang 50))
  (setq intpt (inters ap1 ap2 op1 op2 nil))
  (setq offangs (rtos (angle op1 intpt) 2 9))
  (if (= (rtos offang 2 9) offangs)(setq curverot "ccw")(setq curverot "cw"))
  (setq prevrot curverot)


  (SETQ MAST (SQRT (- (* (atof RADIUS) (atof RADIUS)) (* (/ (ATOF DIST) 2)(/ (ATOF DIST) 2 )))))
  (SETQ O (* 2 (ATAN (/ (/ (ATOF DIST) 2) MAST))))
  	   (setq arclength (rtos ( * (atof radius) O) 2 3))
  ;(if (= units "F")(setq arclength (rtos ( * (/ (atof radius) 0.3048) O) 2 3)))
  ;(if (= units "L")(setq arclength (rtos ( * (/ (atof radius) 0.201168) O) 2 3)))
	    (setq remhalfO (/ (- pi O) 2))
	    (if (= curverot "ccw")(setq raybearing (+ (angle ap1 ap2) remhalfO))(setq raybearing (- (angle ap1 ap2) remhalfO)))
	    



	    
	    (setq curvecen (polar ap1 raybearing  (atof radius)))
  	    (setq curvecenc (strcat (rtos (car curvecen) 2 6) "," (rtos (cadr curvecen) 2 6)))
  ;calc curve midpoint
  (setq a1 (angle curvecen ap1))
  (setq a2 (angle curvecen ap2))
  (if (= curverot "ccw")(setq da (- a2 a1))(setq da (- a1 a2)))
  (if (< da 0)(setq da (+ da (* 2 pi))))
    (SETQ DA (/ DA 2))
    (IF (= CURVEROT "ccw")(setq midb (+ a1 da))(setq midb (+ a2 da)))
  (setq amp (polar curvecen midb (atof radius)))
(IF ( = rswitch "T")(setq obearing (substr lbearing 2 200))(setq obearing lbearing))

    (if (= curverot "ccw") (command "arc" "c" curvecenc ap1 ap2)(command "arc" "c" curvecenc ap2 ap1))

  ;reverse arc direction if reversed
  (if (and (= rswitch "T")(= curverot "ccw"))(setq rcurverot "cw"))
  (if (and (= rswitch "T")(= curverot "cw"))(setq rcurverot "ccw"))
  (if (= rswitch  "T")(setq curverot rcurverot))


  

  
  ;Add observation data to line as XDATA
      (if (/= comment "")(setq ocomment (strcat "><FieldNote>\"" comment "\"</FieldNote></ReducedArcObservation>"))(setq ocomment "/>"))
(SETQ BDINFO (STRCAT "chordAzimuth=\"" obearing "\" length=\"" arclength "\" radius=\"" radius  "\" rot=\"" curverot   "\" arcType=\"Measured\"" ocomment))
 (SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 BDINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)
      


 
  (SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))

 
  (setq tp1  (trans ap1 1 0))
  (setq tp2  (trans ap2 1 0))
  (setq amp  (trans amp 1 0))
  					   
  
   

 
   (LBARC);label arc using function
(setvar "clayer" prevlayer)
 
       
    (SETQ AANG (ANGLE tP2 tP1))
  

  


  
  ;GET 2ND+ LINE INFO
  (while (> 1 0) (progn
		   (setq bearing (getstring "\nChord Bearing [Last]: "))

        (setq dist (getstring T (strcat "\nChord Distance [Last]" units ":")))
(setq radius (getstring (strcat "\nRadius [Last] (" units "):")))
		   (if (or (= bearing "Last") (= bearing "L") (= bearing "l") (= bearing "" )) (setq bearing lbearing))
		   (if (or (= dist "Last") (= dist "L") (= dist "l") (= dist "")) (setq dist prevdist))
		   (if (or (= radius "Last") (= radius "L") (= radius "l") (= radius "")) (setq radius prevradius))
(setq prevradius radius)
(setq prevdist dist)


;look for line comment
  (setq spcpos1 (vl-string-position 32 dist 0))
	(if (= spcpos1 nil)(setq comment "")(progn
					      (setq comment (substr dist ( + spcpos1 2) 50))
					      (setq dist (substr dist 1  spcpos1 ))
					      )
	  )

  
 ;APPLY ALL CORRECTIONS AND EXTRACT INFORMATION FROM USER INPUT


  ;reverse
  (if (or (= (substr bearing 1 1 ) "r") (= (substr bearing 1 1 ) "R" ))
    (progn
      (setq bearing (substr bearing 2 50))
      (setq rswitch "T")
      )
     (setq rswitch "F")
    )

;look for cardinals
  (setq card1 ""
	card2 "")
  (IF (OR (= (substr bearing 1 1 ) "n") (= (substr bearing 1 1 ) "N" )
	  (= (substr bearing 1 1 ) "s" )(= (substr bearing 1 1 ) "S" )
	  (= (substr bearing 1 1 ) "e" )(= (substr bearing 1 1 ) "E" )
	  (= (substr bearing 1 1 ) "w" )(= (substr bearing 1 1 ) "W" ))
(progn
    (setq card1 (substr bearing 1 1))
    (setq card2 (substr bearing (strlen bearing) 1))
    (setq bearing (substr bearing 2 (- (strlen bearing )2)))
  )
    )
    
  
(if (/= (vl-string-position 46 bearing 0) nil ) (PROGN
  (setq dotpt1 (vl-string-position 46 bearing 0))
  (setq deg  (substr bearing 1  dotpt1 ))
  (SETQ mins  (strcat (substr bearing (+ dotpt1 2) 2) (chr 39)))
  (setq sec  (substr bearing (+ dotpt1 4) 10))

  
  (if (> (strlen sec) 2) (setq sec (strcat (substr sec 1 2) "." (substr sec 3 10))))
  (if (= (strlen sec) 0) (setq sec "") (setq sec (strcat sec (chr 34))))

    (if (or
	(= (strlen sec) 2)
	(= (strlen mins) 2)
	(> (atof mins) 60)
	(> (atof sec) 60)
	(> (atof deg) 360)
	)
    (alert (strcat "That bearing looks a little funky - " bearing)))
  
  );P
	(progn
	  (setq deg bearing)
	  (setq mins "")
	  (setq sec "")
	  );p else
  
  );IF

 ;correct cardinals
  (if (and (or (= card1 "n")(= card1 "N"))(or (= card2 "w")(= card2 "W")))
    (progn
      (setq deg (rtos (- 360 (atof deg)) 2 0))
      (if (< 0 (atof mins))(progn
			     (setq mins (strcat (rtos (- 60 (atof mins)) 2 0) (chr 39)))
			     (setq deg (rtos (- (atof deg) 1) 2 0))
			     (if (< (atof deg) 0)(setq deg (rtos (+ (atof deg) 360) 2 0)))
				)
	     )
	(if (< 0 (atof sec))
	       (progn
		 (setq sec (strcat (rtos (- 60 (atof sec)) 2 0) (chr 34)))
		 (if (= 0 (atof mins)) (setq deg (rtos (- (atof deg) 1) 2 0)))
		 (setq mins (strcat (rtos (- (atof mins) 1) 2 0) (chr 39)))
	       
		 (if (< (atof deg) 0)(setq deg (rtos (+ (atof deg) 360) 2 0)))
		 (if (< (atof mins) 0)(setq mins (strcat (rtos (+ (atof mins) 60) 2 0)(chr 39))))
		 )
	  )
      	           
(if (or (and (< (atof mins) 10)(/= 0 (atof mins))) (= mins "0'")) (setq mins (strcat "0" mins)))
(if (and (< (atof sec) 10)(/= 0 (atof sec))) (setq sec (strcat "0" sec)))
		 
      )
    );NW

		   

		   (if (and (or (= card1 "w")(= card1 "W"))(or (= card2 "s")(= card2 "S")))
    (progn
      (setq deg (rtos (- 270 (atof deg)) 2 0))
      (if (< 0 (atof mins))(progn
			     (setq mins (strcat (rtos (- 60 (atof mins)) 2 0) (chr 39)))
			     (setq deg (rtos (- (atof deg) 1) 2 0))
			     (if (< (atof deg) 0)(setq deg (rtos (+ (atof deg) 360) 2 0)))
				)
	     )
	(if (< 0 (atof sec))
	       (progn
		 (setq sec (strcat (rtos (- 60 (atof sec)) 2 0) (chr 34)))
		 (if (= 0 (atof mins)) (setq deg (rtos (- (atof deg) 1) 2 0)))
		 (setq mins (strcat (rtos (- (atof mins) 1) 2 0) (chr 39)))
	       
		 (if (< (atof deg) 0)(setq deg (rtos (+ (atof deg) 360) 2 0)))
		 (if (< (atof mins) 0)(setq mins (strcat (rtos (+ (atof mins) 60) 2 0)(chr 39))))
		 )
	  )
      	           
(if (or (and (< (atof mins) 10)(/= 0 (atof mins))) (= mins "0'")) (setq mins (strcat "0" mins)))
(if (and (< (atof sec) 10)(/= 0 (atof sec))) (setq sec (strcat "0" sec)))
		 
      )
    );WS

		   
		   (if (and (or (= card1 "e")(= card1 "E"))(or (= card2 "n")(= card2 "N")))
    (progn
      (setq deg (rtos (- 90 (atof deg)) 2 0))
      (if (< 0 (atof mins))(progn
			     (setq mins (strcat (rtos (- 60 (atof mins)) 2 0) (chr 39)))
			     (setq deg (rtos (- (atof deg) 1) 2 0))
			     (if (< (atof deg) 0)(setq deg (rtos (+ (atof deg) 360) 2 0)))
				)
	     )
	(if (< 0 (atof sec))
	       (progn
		 (setq sec (strcat (rtos (- 60 (atof sec)) 2 0) (chr 34)))
		 (if (= 0 (atof mins)) (setq deg (rtos (- (atof deg) 1) 2 0)))
		 (setq mins (strcat (rtos (- (atof mins) 1) 2 0) (chr 39)))
	       
		 (if (< (atof deg) 0)(setq deg (rtos (+ (atof deg) 360) 2 0)))
		 (if (< (atof mins) 0)(setq mins (strcat (rtos (+ (atof mins) 60) 2 0)(chr 39))))
		 )
	  )
      	           
(if (or (and (< (atof mins) 10)(/= 0 (atof mins))) (= mins "0'")) (setq mins (strcat "0" mins)))
(if (and (< (atof sec) 10)(/= 0 (atof sec))) (setq sec (strcat "0" sec)))
		 
      )
    );EN

  (if (and (or (= card1 "s")(= card1 "S"))(or (= card2 "e")(= card2 "E")))
    (progn
      (setq deg (rtos (- 180 (atof deg)) 2 0))
      (if (< 0 (atof mins))(progn
			     (setq mins (strcat (rtos (- 60 (atof mins)) 2 0) (chr 39)))
			     (setq deg (rtos (- (atof deg) 1) 2 0))
			     (if (< (atof deg) 0)(setq deg (rtos (+ (atof deg) 360) 2 0)))
				)
	     )
	(if (< 0 (atof sec))
	       (progn
		 (setq sec (strcat (rtos (- 60 (atof sec)) 2 0) (chr 34)))
		 (if (= 0 (atof mins)) (setq deg (rtos (- (atof deg) 1) 2 0)))
		 (setq mins (strcat (rtos (- (atof mins) 1) 2 0) (chr 39)))
	       
		 (if (< (atof deg) 0)(setq deg (rtos (+ (atof deg) 360) 2 0)))
		 (if (< (atof mins) 0)(setq mins (strcat (rtos (+ (atof mins) 60) 2 0)(chr 39))))
		 )
	  )
      	           
(if (or (and (< (atof mins) 10)(/= 0 (atof mins))) (= mins "0'")) (setq mins (strcat "0" mins)))
(if (and (< (atof sec) 10)(/= 0 (atof sec))) (setq sec (strcat "0" sec)))
		 
      )
    );SE

  (if (and (or (= card1 "s")(= card1 "S"))(or (= card2 "w")(= card2 "W")))
    (progn
      (setq deg (rtos (+ 180 (atof deg)) 2 0))
      
      )
    );SW

		    (if (and (or (= card1 "w")(= card1 "W"))(or (= card2 "n")(= card2 "N")))
    (progn
      (setq deg (rtos (+ 270 (atof deg)) 2 0))
      
      )
    );WN
		    (if (and (or (= card1 "e")(= card1 "E"))(or (= card2 "s")(= card2 "S")))
    (progn
      (setq deg (rtos (+ 90 (atof deg)) 2 0))
      
      )
    );ES
  
	
 		   (if (and (= mins "")(= sec ""))(setq decimal "")(setq decimal "."))
	(setq lbearing (strcat deg decimal (substr mins 1 2) (substr sec 1 2)))
 (IF (= rswitch "T")(setq lbearing (strcat "R" lbearing)))
  
		 
		   
(setq bearing (strcat  deg "d" mins sec))

 

  
    (if (= units "F")
      (progn
	(setq dotpos1 (vl-string-position 46 dist 0))
	(if (= dotpos1 nil)(setq dotpos2 nil)(setq dotpos2 (vl-string-position 46 dist (+ dotpos1 1))))
	(setq /pos1 (vl-string-position 47 dist 0))
	(if (/= /pos1 nil)
	  (progn
	    (setq den (substr dist ( + /pos1 2) 50))
	    (setq num (substr dist ( + dotpos2 2) (- (- /pos1 dotpos2) 1)))
	    (setq idist (/ (atof num) (atof den)))
	    (setq inches (substr dist (+ dotpos1 2) (- (- dotpos2 dotpos1) 1)))
	    (setq idist (+ idist (atof inches)))
	    (setq feet (substr dist 1  dotpos1 ))
	    (setq idist (+ idist (* (atof feet) 12)))
	    (setq dist (rtos (* idist 0.0254) 2 9))
	    )
	  )
	(if (and (/= dotpos1 nil) (= /pos1 nil))
	  (progn
	    (setq inches (substr dist ( + dotpos1 2) 50))
	    (setq feet (substr dist 1  dotpos1 ))
	    (setq idist  (atof inches))
	    (setq idist (+ idist (* (atof feet) 12)))
	    (setq dist (rtos (* idist 0.0254) 2 9))
	    )
	  )
	(if (and (= dotpos1 nil) (= /pos1 nil) (= dotpos2 nil))
	  (progn
	   
	    (setq feet (substr dist 1  50))
	    (setq idist (* (atof feet) 12))
	    (setq dist (rtos (* idist 0.0254) 2 9))
	    )
	  )
;radius in feet
	
	(setq dotpos1 (vl-string-position 46 radius 0))
	(if (= dotpos1 nil)(setq dotpos2 nil)(setq dotpos2 (vl-string-position 46 radius (+ dotpos1 1))))
	(setq /pos1 (vl-string-position 47 radius 0))
	(if (/= /pos1 nil)
	  (progn
	    (setq den (substr radius ( + /pos1 2) 50))
	    (setq num (substr radius ( + dotpos2 2) (- (- /pos1 dotpos2) 1)))
	    (setq idist (/ (atof num) (atof den)))
	    (setq inches (substr radius (+ dotpos1 2) (- (- dotpos2 dotpos1) 1)))
	    (setq idist (+ idist (atof inches)))
	    (setq feet (substr radius 1  dotpos1 ))
	    (setq idist (+ idist (* (atof feet) 12)))
	    (setq radius (rtos (* idist 0.0254) 2 9))
	    )
	  )
	(if (and (/= dotpos1 nil) (= /pos1 nil))
	  (progn
	    (setq inches (substr radius ( + dotpos1 2) 50))
	    (setq feet (substr radius 1  dotpos1 ))
	    (setq idist  (atof inches))
	    (setq idist (+ idist (* (atof feet) 12)))
	    (setq radius (rtos (* idist 0.0254) 2 9))
	    )
	  )
	(if (and (= dotpos1 nil) (= /pos1 nil) (= dotpos2 nil))
	  (progn
	   
	    (setq feet (substr radius 1  50))
	    (setq idist (* (atof feet) 12))
	    (setq radius (rtos (* idist 0.0254) 2 9))
	    )
	  )
	

	
	));if & p feet

  
  (if (= units "L")
    (progn
      (setq dist (atof dist))
      (setq dist (rtos (* dist 0.201168)))
      (setq radius (atof radius))
      (setq radius (rtos (* radius 0.201168)))
      
      )); if & p links
	      
	      

    ;DRAW LINE 1
  (setq dist (rtos (atof dist)2 3));remove trailing zeros
  (setq ldist dist)
  (setq radius (rtos (atof radius)2 3));remove trailing zeros
  (setq lradius radius)
		   
  
  (if (= dist "0") (progn
		     (princ "\nDistance of 0 entered")
		     (exit))
    )
		   

  (setq linetext (strcat "@" dist "<" bearing))
 
  (command "line" p1 linetext "")
		   (SETVAR "CLAYER" prevlayer)

  
  
;Add observation data to line as XDATA

;Move line if reverse activated
(if (= rswitch "T")
  (progn
    (SETQ SENT (ENTLAST))
    (SETQ SENTLIST (ENTGET SENT))
(setq p1 (CDR(ASSOC 10 sentlist)))
    (setq p1 (CDR(ASSOC 10 sentlist)))
    (setq p2 (CDR(ASSOC 11 sentlist)))
    (command "move" sent "" p2 p1)

;get last line end point
(SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
(setq p1 (CDR(ASSOC 10 sentlist)))
    (setq ap1 (CDR(ASSOC 11 sentlist))) 
    (setq ap2 (CDR(ASSOC 10 sentlist))) 
    
    );p
  
;get last line end point if not reverse
  (progn
(SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
(setq p1 (CDR(ASSOC 11 sentlist)))
(setq ap1 (CDR(ASSOC 10 sentlist)))
(setq ap2 (CDR(ASSOC 11 sentlist))) 
);p else

);if

		   (setq p1 (trans p1 0 1))
(setq ap1 (trans ap1 0 1))
  (setq ap2 (trans ap2 0 1))

(Setq op1 (getpoint "Select Side of line to draw arc (Last):"))
		   (command "erase" sent "")
		   (if (= op1 nil)(setq curverot prevrot)(progn
		   
  (setq offang (+ (angle ap1 ap2) (* 0.5 pi)))
  (if (> offang (* 2 pi))(setq offang (- offang (* 2 pi))))
  (setq op2 (polar op1 offang 50))
  (setq intpt (inters ap1 ap2 op1 op2 nil))
  (setq offangs (rtos (angle op1 intpt) 2 9))
  (if (= (rtos offang 2 9) offangs)(setq curverot "ccw")(setq curverot "cw"))
		   ))
(setq prevrot curverot)

  (SETQ MAST (SQRT (- (* (atof RADIUS) (atof RADIUS)) (* (/ (ATOF DIST) 2)(/ (ATOF DIST) 2 )))))
  (SETQ O (* 2 (ATAN (/ (/ (ATOF DIST) 2) MAST))))
  	   (setq arclength (rtos ( * (atof radius) O) 2 3))
           ;(if (= units "F")(setq arclength (rtos ( * (/ (atof radius) 0.3048) O) 2 3)))
           ;(if (= units "L")(setq arclength (rtos ( * (/ (atof radius) 0.201168) O) 2 3)))
	    (setq remhalfO (/ (- pi O) 2))
	    (if (= curverot "ccw")(setq raybearing (+ (angle ap1 ap2) remhalfO))(setq raybearing (- (angle ap1 ap2) remhalfO)))
	    
	    (setq curvecen (polar ap1 raybearing  (atof radius)))
	    (setq curvecenc (strcat (rtos (car curvecen) 2 6) "," (rtos (cadr curvecen) 2 6)))
		   ;calc curve midpoint
  (setq a1 (angle curvecen ap1))
  (setq a2 (angle curvecen ap2))
  (if (= curverot "ccw")(setq da (- a2 a1))(setq da (- a1 a2)))
  (if (< da 0)(setq da (+ da (* 2 pi))))
    (SETQ DA (/ DA 2))
    (IF (= CURVEROT "ccw")(setq midb (+ a1 da))(setq midb (+ a2 da)))
  (setq amp (polar curvecen midb (atof radius)))


    (if (= curverot "ccw") (command "arc" "c" curvecenc ap1 ap2)(command "arc" "c" curvecenc ap2 ap1))
  (IF ( = rswitch "T")(setq obearing (substr lbearing 2 200))(setq obearing lbearing))


		    ;reverse arc direction if reversed
  (if (and (= rswitch "T")(= curverot "ccw"))(setq rcurverot "cw"))
  (if (and (= rswitch "T")(= curverot "cw"))(setq rcurverot "ccw"))
  (if (= rswitch  "T")(setq curverot rcurverot))

		   

		   
    (if (/= comment "")(setq ocomment (strcat "><FieldNote>\"" comment "\"</FieldNote></ReducedArcObservation>"))(setq ocomment "/>"))
(SETQ BDINFO (STRCAT "chordAzimuth=\"" obearing "\" length=\"" arclength "\" radius=\"" radius  "\" rot=\"" curverot   "\" arcType=\"Measured\"" ocomment))
 (SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 BDINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)
 

 
  (SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))

  (setq tp1  (trans ap1 1 0))
  (setq tp2  (trans ap2 1 0))
  (setq amp  (trans amp 1 0))
   

 
   (LBARC);label arc using function
(setvar "clayer" prevlayer)
 
       
    (SETQ AANG (ANGLE tP2 tP1))
  

		   
  
);P
    );WHILE 1>0
  );DEFUN




;----------------------------------------------------------------CREATE LOT--------------------------------------------

(defun C:XCL (/)

  (setq prevlayer (getvar "CLAYER"))
  (SETQ areapercent NIL)
  (setq pickstyle (getvar "Pickstyle"))
  (setvar "pickstyle" 0)

  (SETVAR "CLAYER"  "Lot Definitions" )
  (setq lotc (getpoint "\nSelect Lot Centre:"))
  
  (command "-layer" "off" "Drafting"
	   "off" "Easement"
	   "off" "Connection"
	   "off" "Occupation Fences"
	   "Off" "Occupation Walls"
	   "off" "Occupations"
	   "off" "PM Connection"
	   "off" "RM Connection"
	   "off" "Occupation Kerbs"
	   "off" "Occupation Buildings"
	   "off" "Irregular Right Lines" "")
  
  (command "-hatch" "A" "I" "N" "N" "" "p" "s" lotc "")
  (command "-layer" "on" "Drafting"
	   "on" "Easement"
	   "on" "Connection"
	   "on" "Occupation Fences"
	   "on" "Occupation Walls"
	   "on" "Occupations"
	   "on" "PM Connection"
	   "oN" "RM Connection"
	   "on" "Occupation Kerbs"
	   "on" "Occupation Buildings"
	   "on" "Irregular Right Lines" "")
  (SETQ lothatch (ENTLAST))
 (if (/= (CDR(ASSOC 0 (ENTGET lothatch))) "HATCH")(PROGN (PRINC "\nError - Unable to flood lot")
			    (quit)))
  (SETQ ENTSS lothatch)
(command "._HATCHGENERATEBOUNDARY" ENTSS "" );edited for Bricscad, much neater, courtesy Jason Bourhill www.cadconcepts.co.nz
  (COMMAND)
  (COMMAND)
 (SETQ lotno (getstring (strcat "\n Lot Number [" plotno "]:")))
  (if (= lotno "") (setq lotno plotno))
  ;(COMMAND "SELECT" "" "")
  (COMMAND "ERASE" ENTSS "")
  (SETQ lotedge (ENTLAST))
  (SETQ ENTSS (SSADD))
  (SSADD lotedge ENTSS)

  (if (= plotno nil) (setq plotno "1"))
  
(SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  
    ;go through polyline to get points to check for clockwise direction
  (SETQ ZA (CDR (ASSOC 210 SENTLIST)))
    (SETQ CWLIST (LIST))
	    (foreach a SenTlist
	      (if (= 10 (car a))

		(setq CWLIST (append CWLIST (list (TRANS (cdr a) ZA 0))))
	      )				;IF
	      
	    )				;FOREACH 			

  (IF (> (lcw CWLIST) 0) (command "pedit" sent "r" "" ))
  					(SETQ SENTLIST (ENTGET SENT))
  

  (setq area (getstring "\nArea or [C]alculate (mm.dm) (aa.rr.pp.f/p) [Last]:"))
(if (or (= area "l")(= area "L")(= area "LAST")(= area "last"))(setq area "Last"))

  (if (= area "Last" )(setq area arealast))
  (SETQ arealast area)

(if (/= area "")
  (progn
  ;deal with imperial areas
  
      
	(setq dotpos1 (vl-string-position 46 area 0))
	(if (= dotpos1 nil)(setq dotpos2 nil)(setq dotpos2 (vl-string-position 46 area (+ dotpos1 1))))
	(if (/= dotpos2 nil)(progn;idenfited as imperial area, must have second dotpos to work
			      
	(if (= dotpos2 nil)(setq dotpos3 nil)(setq dotpos3 (vl-string-position 46 area (+ dotpos2 1))))
	(setq /pos1 (vl-string-position 47 area 0))
	(if (/= /pos1 nil);with factional part
	  (progn
	    (setq den (substr area ( + /pos1 2) 50))
	    (setq num (substr area ( + dotpos3 2) (- (- /pos1 dotpos3) 1)))
	    (setq fperch (/ (atof num) (atof den)))
	    (setq perch (substr area (+ dotpos2 2) (- (- dotpos3 dotpos2) 1)))
	    (setq perch (+ fperch (atof perch)))
	    (setq rood (substr area (+ dotpos1 2) (- (- dotpos2 dotpos1) 1)))
	    (setq perch (+ perch (* (atof rood) 40)))
	    (setq acre (substr area 1  dotpos1 ))
	    (setq perch (+ perch (* (atof acre) 160)))
	    (setq area (rtos (* perch 25.2929538117) 2 9))
	    )
	  )
	(if (and (/= dotpos1 nil)(/= dotpos2 nil)(= /pos1 nil));without fractional part
	  (progn
	    (setq perch (substr area ( + dotpos2 2) 50))
	    (setq perch (atof perch))
	    (setq rood (substr area (+ dotpos1 2) (- (- dotpos2 dotpos1) 1)))
	    (setq perch (+ perch (* (atof rood) 40)))
	    (setq acre (substr area 1  dotpos1 ))
	    (setq perch (+ perch (* (atof acre) 160)))
	    (setq area (rtos (* perch 25.2929538117) 2 9))
	    )
	  )
	
	));p&if imperial area
	  

	

  




  
   
   (SETQ area1 (vlax-get-property (vlax-ename->vla-object sent ) 'area ))

  (setvar "dimzin" 0)
  (IF (or ( = area "C")(= area "c"))
    (progn
      (setq area (rtos area1 2 3))
      (setq area1 (atof (rtos area1 2 3)));deal with recurring 9's

      (if (= ard "YES")
	(progn
      					    (if (> area1 0)(setq textarea (strcat (rtos (* (fix (/ area1 0.001)) 0.001) 2 3) "m�")))
					    (if (> area1 10)(setq textarea (strcat (rtos (* (fix (/ area1 0.01)) 0.01) 2 2) "m�")))
					    (if (> area1 100)(setq textarea (strcat (rtos (* (fix (/ area1 0.1)) 0.1) 2 1) "m�")))
					    (if (> area1 1000)(setq textarea (strcat (rtos (* (fix (/ area1 1)) 1) 2 0) "m�")))
      					    (if (> area1 10000) (setq textarea (strcat (rtos (* (fix (/ (/ area1 10000) 0.001)) 0.001) 2 3) "ha")))
					    (if (> area1 100000) (setq textarea (strcat (rtos (* (fix (/ (/ area1 10000) 0.01)) 0.01) 2 2) "ha")))
					    (if (> area1 1000000) (setq textarea (strcat (rtos (* (fix (/ (/ area1 10000) 0.1)) 0.1) 2 1) "ha")))
					    (if (> area1 10000000) (setq textarea (strcat (rtos (* (fix (/ (/ area1 10000) 1)) 1) 2 0) "ha")))
                                            (if (> area1 100000000) (setq textarea (strcat (rtos (* (fix (/ (/ area1 1000000) 0.1)) 0.1) 2 1) "km�")))
                                            (if (> area1 1000000000) (setq textarea (strcat (rtos (* (fix (/ (/ area1 1000000) 1)) 1) 2 0) "km�")))
	  )
	(progn
	        			    (if (> area1 0)(setq textarea (strcat (rtos   area1 2 3) "m�")))
					    (if (> area1 10)(setq textarea (strcat (rtos   area1  2 2) "m�")))
					    (if (> area1 100)(setq textarea (strcat (rtos  area1  2 1) "m�")))
					    (if (> area1 1000)(setq textarea (strcat (rtos area1  2 0) "m�")))
      					    (if (> area1 10000) (setq textarea (strcat (rtos  (/ area1 10000)  2 3) "ha")))
					    (if (> area1 100000) (setq textarea (strcat (rtos  (/ area1 10000)  2 2) "ha")))
					    (if (> area1 1000000) (setq textarea (strcat (rtos  (/ area1 10000)  2 1) "ha")))
					    (if (> area1 10000000) (setq textarea (strcat (rtos   (/ area1 10000) 2 0) "ha")))
                                            (if (> area1 100000000) (setq textarea (strcat (rtos (/ area1 1000000)  2 1) "km�")))
                                            (if (> area1 1000000000) (setq textarea (strcat (rtos  (/ area1 1000000) 2 0) "km�")))

      ));if ard
      
					    
      )
    (progn
     (setq areapercent (ABS(* (/  (- area1 (ATOF area)) area1) 100)))
     (if (> areapercent 10) (alert (strcat "\nArea different to calulated by " (rtos areapercent 2 0)"%")))
 (if (= ard "YES")
	(progn
                                            (if (> (atof area) 1)(setq textarea (strcat (rtos (atof area) 2 3) "m�")))
      					    (if (> (atof area) 0)(setq textarea (strcat (rtos (* (fix (+(/ (atof area) 0.001)0.00001)) 0.001)  2 3) "m�")))
					    (if (> (atof area) 10)(setq textarea (strcat (rtos (* (fix (+ (/ (atof area) 0.01) 0.00001)) 0.01) 2 2) "m�")))
					    (if (> (atof area) 100)(setq textarea (strcat (rtos (* (fix (+(/ (atof area) 0.1) 0.00001)) 0.1) 2 1) "m�")))
					    (if (> (atof area) 1000)(setq textarea (strcat (rtos (* (fix (+(/ (atof area) 1)0.00001)) 1) 2 0) "m�")))
      					    (if (> (atof area) 10000) (setq textarea (strcat (rtos (* (fix (+(/ (/ (atof area) 10000) 0.001)0.00001)) 0.001) 2 3) "ha")))
					    (if (> (atof area) 100000) (setq textarea (strcat (rtos (* (fix (+(/ (/ (atof area) 10000) 0.01)0.00001)) 0.01) 2 2) "ha")))
					    (if (> (atof area) 1000000) (setq textarea (strcat (rtos (* (fix (+(/ (/ (atof area) 10000) 0.1)0.00001)) 0.1) 2 1) "ha")))
					    (if (> (atof area) 10000000) (setq textarea (strcat (rtos (* (fix (+(/ (/ (atof area) 10000) 1)0.00001)) 1) 2 0) "ha")))
                                            (if (> (atof area) 100000000) (setq textarea (strcat (rtos (* (fix (+ (/ (/ (atof area) 1000000) 0.1)0.00001)) 0.1) 2 1) "km�")))
                                            (if (> (atof area) 1000000000) (setq textarea (strcat (rtos (* (fix (+(/ (/ (atof area) 1000000) 1)0.00001)) 1) 2 0) "km�")))
	  )
   (progn
           			    (if (> area1 0)(setq textarea (strcat (rtos   area 2 3) "m�")))
					    (if (> area1 10)(setq textarea (strcat (rtos   area  2 2) "m�")))
					    (if (> area1 100)(setq textarea (strcat (rtos  area  2 1) "m�")))
					    (if (> area1 1000)(setq textarea (strcat (rtos area  2 0) "m�")))
      					    (if (> area1 10000) (setq textarea (strcat (rtos  (/ area 10000)  2 3) "ha")))
					    (if (> area1 100000) (setq textarea (strcat (rtos  (/ area 10000)  2 2) "ha")))
					    (if (> area1 1000000) (setq textarea (strcat (rtos  (/ area 10000)  2 1) "ha")))
					    (if (> area1 10000000) (setq textarea (strcat (rtos   (/ area 10000) 2 0) "ha")))
                                            (if (> area1 100000000) (setq textarea (strcat (rtos (/ area 1000000)  2 1) "km�")))
                                            (if (> area1 1000000000) (setq textarea (strcat (rtos  (/ area 1000000) 2 0) "km�")))
     ));if ard

     )
    )
    ));if there is an area
  (setvar "dimzin" 8)
    (setq lotstate (getstring "\nProposed or Existing (P/E) [P]:"))
  (if (or (= lotstate "p")(= lotstate "P"))(setq lotstate "proposed"))
  (if (or (= lotstate "e")(= lotstate "E"))(setq lotstate "existing"))
  (if (= lotstate "")(setq lotstate "proposed"))

  (if (= (substr lotno 1 2) "PT")(setq pcltype " parcelType=\"Part\""
				     lotno (substr lotno 3 50)
				       desc "\" desc=\"PT"
				       textarea (strcat "(" textarea ")")
				       )
    (setq pcltype " parcelType=\"Single\""
	  desc ""    
    ))
  (if (/= area "")(setq areas (strcat " area=\"" area "\""))(setq areas ""))
(setq lotc (trans lotc 1 0));convert to world if in a UCS
  
    ;<Parcel name="30" class="Lot" state="proposed" parcelType="Single" parcelFormat="Standard" area="951.8">
  (SETQ LTINFO (STRCAT "  <Parcel name=\"" lotno  "\" class=\"Lot\" state=\"" lotstate "\"" pcltype " parcelFormat=\"Standard\"" areas ">!" (rtos (cadr lotc) 2 6 ) " " (rtos (car lotc) 2 6)))
	 ;(setq arealast area)
(SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 LTINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)

  (if (= pcltype " parcelType=\"Part\"")(setq lotnos (strcat "PT" lotno))(setq lotnos lotno))
  
         
       (setq lotc (trans lotc 0 1));convert back to UCS if using one
(SETVAR "CELWEIGHT" 50)
  (SETVAR "CLAYER"  "Drafting" )
  (setq areapos (polar lotc (* 1.5 pi) (* th 2.5)))
  (COMMAND "TEXT" "J" "BC" lotc (* TH 2) "90" lotnos)
  (SETVAR "CELWEIGHT" 35)
  (if (/= area "")(COMMAND "TEXT" "J" "BC" areapos (* TH 1.4) "90"  textarea ))
(SETVAR "CELWEIGHT" -1)
  (if (/= (atof lotno) 0)(setq plotno (rtos (+ (atof lotno) 1) 2 0)))  
  (SETVAR "CLAYER" prevlayer)

  
  (COMMAND "DRAWORDER" ENTSS "" "BACK")

  (setvar "pickstyle" pickstyle)
  (IF (/= areapercent NIL)(PRINC (strcat "\nArea different to calulated by " (rtos areapercent 2 0)"%")))
  
  )

;-----------------------------------------------------------------------------Create Easement----------------------------------------------------
(defun C:XCE (/)

  (setq pickstyle (getvar "Pickstyle"))
  (setvar "pickstyle" 0)
  (setq prevlayer (getvar "CLAYER"))
 (easecount)
  (SETVAR "CLAYER"  "Lot Definitions" )
  (setq lotc (getpoint "\nSelect Lot Centre:"))
 (command "-layer" "off" "Drafting"
	   
	   "off" "Connection"
	   "off" "Occupation Fences"
	   "Off" "Occupation Walls"
	   "off" "Occupations"
	   "off" "PM Connection"
	   "off" "RM Connection"
	   "off" "Occupation Kerbs"
	   "off" "Occupation Buildings"
	  "")
  
  (command "-hatch" "A" "I" "N" "N" "" "p" "s" lotc "")
  (command "-layer" "on" "Drafting"
	   
	   "on" "Connection"
	   "on" "Occupation Fences"
	   "on" "Occupation Walls"
	   "on" "Occupations"
	   "on" "PM Connection"
	   "oN" "RM Connection"
	   "on" "Occupation Kerbs"
	   "on" "Occupation Buildings"
	   "")
  (SETQ lothatch (ENTLAST))
  (SETQ ENTSS (SSADD))
  (SSADD lothatch ENTSS)
(command "._HATCHGENERATEBOUNDARY" ENTSS "");edited for Bricscad, much neater, courtesy Jason Bourhill www.cadconcepts.co.nz
(COMMAND)

  (setq class (getstring T (strcat "Type of Interest (* for list) [" peclass "]:")))
  (if (= class "")(setq class peclass))
    ;execute list finder
  (if (= class "*")(progn
		      (setq workingselnum tselnum)
		      (setq names interestlist)
		      (dbox)
		      (setq class returntype)
		      (setq tselnum workingselnum)
		      )
    )
	(setq peclass class)
  
 (SETQ lotno (getstring T (STRCAT "\n Description (" ped "):")))
(if (and (/= ped "")(= lotno ""))(setq lotno ped))
  (SETQ ped lotno)
  
    (setq lotstate (getstring  "\nProposed or Existing (P/E) [P]:"))
  (if (or (= lotstate "p")(= lotstate "P"))(setq lotstate "proposed"))
  (if (or (= lotstate "e")(= lotstate "E"))(setq lotstate "existing"))
  (if (= lotstate "")(setq lotstate "proposed"))
  
  
  (COMMAND "ERASE" ENTSS "")
  (SETQ lotedge (ENTLAST))
  (SETQ ENTSS (SSADD))
  (SSADD lotedge ENTSS)

  
  
(SETQ SENT (ENTLAST))
 (SETQ SENTLIST (ENTGET SENT))
    ;go through polyline to get points to check for clockwise direction
  (SETQ ZA (CDR (ASSOC 210 SENTLIST)))
    (SETQ CWLIST (LIST))
	    (foreach a SenTlist
	      (if (= 10 (car a))

		(setq CWLIST (append CWLIST (list (TRANS (cdr a) ZA 0))))
	      )				;IF
	      
	    )				;FOREACH 			

  (IF (> (lcw CWLIST) 0) (command "pedit" sent "r" "" ))
  					(SETQ SENTLIST (ENTGET SENT))

  (SETQ PTLIST (LIST))
				
;CREATE LIST OF POLYLINE POINTS
    (SETQ PTLIST (LIST))
	    (foreach a SENTLIST
	      (if (= 10 (car a))

		(setq PTLIST (append PTLIST (list (cdr a))))
	      )				;IF
	     
	    )				;FOREACH 			)

(setq ptlist (append ptlist (list(nth 0 ptlist))))
  
  

 
    (setq lotc (trans lotc 1 0));convert to world if using UCS
  (SETQ LTINFO (STRCAT "<Parcel name=\"E" (rtos easecounter 2 0) "\" desc=\"" lotno "\" class=\"" class "\" state=\"" lotstate "\" parcelType=\"Single\" parcelFormat=\"Standard\">!"
		       (rtos (cadr lotc) 2 6 ) " " (rtos (car lotc) 2 6)))
(SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 LTINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)

  (setq THF 1)

  (setq lotc (trans lotc 0 1));convert back to UCS
  (setq easelabelpos (polar lotc (* 1.5 pi) (* th 1.1)))
  (SETVAR "CLAYER"  "Drafting" )

   (if (= (substr lotno 1 1) "(")(progn
				 (setq cbpos1 (vl-string-position 41 lotno 0))
				 (setq easeletter  (substr lotno 1 (+ cbpos1 1)))
				  (setvar "clayer" "Lot definitions")
				(COMMAND "TEXT" "J" "MC" easelabelpos (* TH 0.75) "90" (strcat  "E" (rtos easecounter)  ))
				 (setvar "clayer" "Drafting")
				 (COMMAND "TEXT" "J" "MC" lotc (* TH 1.4) "90" (strcat easeletter ))

					    
					    )
						 
(COMMAND "TEXT" "J" "MC" lotc (* TH THF) "90" (strcat "E" (rtos easecounter)))
						   );if first character is bracket

  		      
					
  
       (setq roadname (entget (entlast)))

   (SETVAR "CLAYER" prevlayer)


(setq lotc (trans lotc 1 0));convert to world if using UCS
    
		(setq count 0)
		(setq minoff 100000000000000000000000000000000000000)
(repeat (- (length ptlist)2 )

  (setq op1 (nth count ptlist))
  (setq op2 (nth (+ count 1) ptlist))
  (setq op3 (nth (+ count 2) ptlist))



  ;check line one
;check offset to line
  (SETQ ANG (ANGLE oP1 oP2))
  (SETQ CANG (+ ANG (/ PI 2)))
  (SETQ P4 (POLAR lotc CANG 50))
  (SETQ P6 (POLAR lotc (+ CANG PI) 50))
   
  (IF (SETQ P5 (INTERS oP1 oP2 P6 P4 ))(PROGN
					
 
      (SETQ OFF (DISTANCE lotc P5))

    (if (< OFF (ABS MINOFF))(SETQ minoff (abs off)
				  nearang cang))
     
    
  ));p & if inters

    ;check inside deflection angle
    (setq ang2 (angle op2 op3))
    (setq cang2 (+ ang (/ pi 2)))
    (setq ltopang (angle op2 lotc))
    (setq defl (- ang2 ang))
(if (/= defl 0);check for straight line
  (progn
    (if (< defl pi)(progn
		     (setq ray1 (- ang (/ pi 2)))
		     ;(if (< ray1 0) (setq ray1 (+ ray1 (* 2 pi))))
		     (setq ray2 (- ang2 (/ pi 2)))
		     ;(if (< ray2 0) (setq ray2 (+ ray2 (* 2pi))))
		     ));p and if less than pi
    (if (> defl pi)(progn
		     (setq ray1 (+ ang (/ pi 2)))
		     ;(if (> ray1 (* 2 pi)(setq ray1 (- ray1 (* 2 pi)))))
		     (setq ray2 (+ ang (/ pi 2)))
		     ;(if (> ray2 (* 2 pi)(setq ray2 (- ray2 (* 2 pi)))))
		     ));p and if greater than pi

    (if (or (and (> ltopang ray1) (< ltopang ray2))(and (> ltopang ray2)(< ltopang ray1)));check ot see if inside deflection squares **** needs testing later
      (progn
	(setq off (distance lotc op2))
(if (< OFF (ABS MINOFF))(SETQ minoff (abs off)
				  nearang ltopang)
      );if
	));p and if in defl sqr
   ));p and if not straight line

  (setq count (+ count 1))
    );repeat
      
				;using this info change the road name text rotation to the angle of the line
		(setq rrot (+ nearang (/ pi 2)))
		(if (> rrot (* 2 pi))(setq rrot (- rrot (* 2 pi))))
		(IF (AND (> rrot  (* 0.5 pi)) (< rrot (* 1.5 pi)))(setq rrot (+ rrot pi))) ;if text is upsidedown reverse rotation
					  
		
    
  (SETQ	roadname (subst (cons 50  rrot);SUB IN NEW POINT 2 HEIGHT
		     (assoc 50 roadname)
		     roadname     ) )
  (ENTMOD roadname)
(COMMAND "DRAWORDER" ENTSS "" "BACK")
  (setvar "pickstyle" pickstyle)
  )



;------------------------------------------------------Create Road Lot----------------------------------------------

(defun C:XCR (/)
(setq pickstyle (getvar "Pickstyle"))
  (setvar "pickstyle" 0)

  (setq prevlayer (getvar "CLAYER"))

  (SETVAR "CLAYER"  "Lot Definitions" )
  (setq lotc (getpoint "\nSelect Lot Centre:"))
  (command "-layer" "off" "Drafting"
	   "off" "Easement"
	   "off" "Connection"
	   "off" "Occupation Fences"
	   "Off" "Occupation Walls"
	   "off" "Occupations"
	   "off" "PM Connection"
	   "off" "RM Connection"
	   "off" "Occupation Kerbs"
	   "off" "Occupation Buildings"
	   "")
  
  (command "-hatch" "A" "I" "N" "N" "" "p" "s" lotc "")
  (command "-layer" "on" "Drafting"
	   "on" "Easement"
	   "on" "Connection"
	   "on" "Occupation Fences"
	   "on" "Occupation Walls"
	   "on" "Occupations"
	   "on" "PM Connection"
	   "oN" "RM Connection"
	   "on" "Occupation Buildings"
	   "on" "Occupation Kerbs" "")
  (SETQ lothatch (ENTLAST))
  (SETQ ENTSS (SSADD))
  (SSADD lothatch ENTSS)
(command "._HATCHGENERATEBOUNDARY" ENTSS "");edited for Bricscad, much neater, courtesy Jason Bourhill www.cadconcepts.co.nz
(command)
  (SETQ lotno (getstring T"\n Road Name:"))
  
    (setq lotstate (getstring  "\nProposed or Existing (P/E) [P]:"))
  (if (or (= lotstate "p")(= lotstate "P"))(setq lotstate "proposed"))
  (if (or (= lotstate "e")(= lotstate "E"))(setq lotstate "existing"))
  (if (= lotstate "")(setq lotstate "proposed"))


  
  (setq area (getstring "\nArea or [C]alculate (mm.dm) (aa.rr.pp.f/p) [Last]:"))
(if (or (= area "l")(= area "L")(= area "LAST")(= area "last"))(setq area "Last"))

  (if (= area "Last" )(setq area arealast))
  (SETQ arealast area)



  
	
(COMMAND "ERASE" ENTSS "")
(SETQ lotedge (ENTLAST))
  (SETQ ENTSS (SSADD))
  (SSADD lotedge ENTSS)
  

  
(SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
    ;go through polyline to get points to check for clockwise direction
  (SETQ ZA (CDR (ASSOC 210 SENTLIST)))
    (SETQ CWLIST (LIST))
	    (foreach a SenTlist
	      (if (= 10 (car a))

		(setq CWLIST (append CWLIST (list (TRANS (cdr a) ZA 0))))
	      )				;IF
	      
	    )				;FOREACH 			

  (IF (> (lcw CWLIST) 0) (command "pedit" sent "r" "" ))
  					(SETQ SENTLIST (ENTGET SENT))

  (SETQ PTLIST (LIST))
				
;CREATE LIST OF POLYLINE POINTS
    (SETQ PTLIST (LIST))
	    (foreach a SENTLIST
	      (if (= 10 (car a))

		(setq PTLIST (append PTLIST (list (cdr a))))
	      )				;IF
	     
	    )				;FOREACH 			)


  (setq ptlist (append ptlist (list (nth 0 ptlist))))




  


  
(if (/= area "")
  (progn
  ;deal with imperial areas
  
      
	(setq dotpos1 (vl-string-position 46 area 0))
	(if (= dotpos1 nil)(setq dotpos2 nil)(setq dotpos2 (vl-string-position 46 area (+ dotpos1 1))))
	(if (/= dotpos2 nil)(progn;idenfited as imperial area, must have second dotpos to work
			      
	(if (= dotpos2 nil)(setq dotpos3 nil)(setq dotpos3 (vl-string-position 46 area (+ dotpos2 1))))
	(setq /pos1 (vl-string-position 47 area 0))
	(if (/= /pos1 nil);with factional part
	  (progn
	    (setq den (substr area ( + /pos1 2) 50))
	    (setq num (substr area ( + dotpos3 2) (- (- /pos1 dotpos3) 1)))
	    (setq fperch (/ (atof num) (atof den)))
	    (setq perch (substr area (+ dotpos2 2) (- (- dotpos3 dotpos2) 1)))
	    (setq perch (+ fperch (atof perch)))
	    (setq rood (substr area (+ dotpos1 2) (- (- dotpos2 dotpos1) 1)))
	    (setq perch (+ perch (* (atof rood) 40)))
	    (setq acre (substr area 1  dotpos1 ))
	    (setq perch (+ perch (* (atof acre) 160)))
	    (setq area (rtos (* perch 25.2929538117) 2 9))
	    )
	  )
	(if (and (/= dotpos1 nil)(/= dotpos2 nil)(= /pos1 nil));without fractional part
	  (progn
	    (setq perch (substr area ( + dotpos2 2) 50))
	    (setq perch (atof perch))
	    (setq rood (substr area (+ dotpos1 2) (- (- dotpos2 dotpos1) 1)))
	    (setq perch (+ perch (* (atof rood) 40)))
	    (setq acre (substr area 1  dotpos1 ))
	    (setq perch (+ perch (* (atof acre) 160)))
	    (setq area (rtos (* perch 25.2929538117) 2 9))
	    )
	  )
	
	));p&if imperial area
	  




  
   
   (SETQ area1 (vlax-get-property (vlax-ename->vla-object sent ) 'area ))

  (setvar "dimzin" 0)
  (IF (or ( = area "C")(= area "c"))
    (progn
      (setq area (rtos area1 2 3))
      (setq area1 (atof (rtos area1 2 3)));deal with recurring 9's

      (if (= ard "YES")
	(progn
      					    (if (> area1 0)(setq textarea (strcat (rtos (* (fix (/ area1 0.001)) 0.001) 2 3) "m�")))
					    (if (> area1 10)(setq textarea (strcat (rtos (* (fix (/ area1 0.01)) 0.01) 2 2) "m�")))
					    (if (> area1 100)(setq textarea (strcat (rtos (* (fix (/ area1 0.1)) 0.1) 2 1) "m�")))
					    (if (> area1 1000)(setq textarea (strcat (rtos (* (fix (/ area1 1)) 1) 2 0) "m�")))
      					    (if (> area1 10000) (setq textarea (strcat (rtos (* (fix (/ (/ area1 10000) 0.001)) 0.001) 2 3) "ha")))
					    (if (> area1 100000) (setq textarea (strcat (rtos (* (fix (/ (/ area1 10000) 0.01)) 0.01) 2 2) "ha")))
					    (if (> area1 1000000) (setq textarea (strcat (rtos (* (fix (/ (/ area1 10000) 0.1)) 0.1) 2 1) "ha")))
					    (if (> area1 10000000) (setq textarea (strcat (rtos (* (fix (/ (/ area1 10000) 1)) 1) 2 0) "ha")))
                                            (if (> area1 100000000) (setq textarea (strcat (rtos (* (fix (/ (/ area1 1000000) 0.1)) 0.1) 2 1) "km�")))
                                            (if (> area1 1000000000) (setq textarea (strcat (rtos (* (fix (/ (/ area1 1000000) 1)) 1) 2 0) "km�")))
	  )
	(progn
	        			    (if (> area1 0)(setq textarea (strcat (rtos   area1 2 3) "m�")))
					    (if (> area1 10)(setq textarea (strcat (rtos   area1  2 2) "m�")))
					    (if (> area1 100)(setq textarea (strcat (rtos  area1  2 1) "m�")))
					    (if (> area1 1000)(setq textarea (strcat (rtos area1  2 0) "m�")))
      					    (if (> area1 10000) (setq textarea (strcat (rtos  (/ area1 10000)  2 3) "ha")))
					    (if (> area1 100000) (setq textarea (strcat (rtos  (/ area1 10000)  2 2) "ha")))
					    (if (> area1 1000000) (setq textarea (strcat (rtos  (/ area1 10000)  2 1) "ha")))
					    (if (> area1 10000000) (setq textarea (strcat (rtos   (/ area1 10000) 2 0) "ha")))
                                            (if (> area1 100000000) (setq textarea (strcat (rtos (/ area1 1000000)  2 1) "km�")))
                                            (if (> area1 1000000000) (setq textarea (strcat (rtos  (/ area1 1000000) 2 0) "km�")))

      ));if ard
      
					    
      )
    (progn
     (setq areapercent (ABS(* (/  (- area1 (ATOF area)) area1) 100)))
     (if (> areapercent 10) (alert (strcat "\nArea different to calulated by " (rtos areapercent 2 0)"%")))
 (if (= ard "YES")
	(progn
                                            (if (> (atof area) 1)(setq textarea (strcat (rtos (atof area) 2 3) "m�")))
      					    (if (> (atof area) 0)(setq textarea (strcat (rtos (* (fix (+(/ (atof area) 0.001)0.00001)) 0.001)  2 3) "m�")))
					    (if (> (atof area) 10)(setq textarea (strcat (rtos (* (fix (+ (/ (atof area) 0.01) 0.00001)) 0.01) 2 2) "m�")))
					    (if (> (atof area) 100)(setq textarea (strcat (rtos (* (fix (+(/ (atof area) 0.1) 0.00001)) 0.1) 2 1) "m�")))
					    (if (> (atof area) 1000)(setq textarea (strcat (rtos (* (fix (+(/ (atof area) 1)0.00001)) 1) 2 0) "m�")))
      					    (if (> (atof area) 10000) (setq textarea (strcat (rtos (* (fix (+(/ (/ (atof area) 10000) 0.001)0.00001)) 0.001) 2 3) "ha")))
					    (if (> (atof area) 100000) (setq textarea (strcat (rtos (* (fix (+(/ (/ (atof area) 10000) 0.01)0.00001)) 0.01) 2 2) "ha")))
					    (if (> (atof area) 1000000) (setq textarea (strcat (rtos (* (fix (+(/ (/ (atof area) 10000) 0.1)0.00001)) 0.1) 2 1) "ha")))
					    (if (> (atof area) 10000000) (setq textarea (strcat (rtos (* (fix (+(/ (/ (atof area) 10000) 1)0.00001)) 1) 2 0) "ha")))
                                            (if (> (atof area) 100000000) (setq textarea (strcat (rtos (* (fix (+ (/ (/ (atof area) 1000000) 0.1)0.00001)) 0.1) 2 1) "km�")))
                                            (if (> (atof area) 1000000000) (setq textarea (strcat (rtos (* (fix (+(/ (/ (atof area) 1000000) 1)0.00001)) 1) 2 0) "km�")))
	  )
   (progn
           			    (if (> area1 0)(setq textarea (strcat (rtos   area 2 3) "m�")))
					    (if (> area1 10)(setq textarea (strcat (rtos   area  2 2) "m�")))
					    (if (> area1 100)(setq textarea (strcat (rtos  area  2 1) "m�")))
					    (if (> area1 1000)(setq textarea (strcat (rtos area  2 0) "m�")))
      					    (if (> area1 10000) (setq textarea (strcat (rtos  (/ area 10000)  2 3) "ha")))
					    (if (> area1 100000) (setq textarea (strcat (rtos  (/ area 10000)  2 2) "ha")))
					    (if (> area1 1000000) (setq textarea (strcat (rtos  (/ area 10000)  2 1) "ha")))
					    (if (> area1 10000000) (setq textarea (strcat (rtos   (/ area 10000) 2 0) "ha")))
                                            (if (> area1 100000000) (setq textarea (strcat (rtos (/ area 1000000)  2 1) "km�")))
                                            (if (> area1 1000000000) (setq textarea (strcat (rtos  (/ area 1000000) 2 0) "km�")))
     ));if ard

     )
    )
    ));if there is an area
  (setvar "dimzin" 8)


  
  
  
  
  
   (if (/= area "")(setq areas (strcat " area=\"" area "\""))(setq areas ""))
 

  (setq lotc (trans lotc 1 0));convert to world if using UCS
  (SETQ LTINFO (STRCAT "desc=\"" lotno "\" class=\"Road\" state=\"" lotstate "\" parcelType=\"Single\" parcelFormat=\"Standard\"" areas ">!"
		       (rtos (cadr lotc) 2 6 ) " " (rtos (car lotc) 2 6)))
(SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 LTINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)

  (setq THF 2)
  (if (= area "") (setq just "MC")(setq just "BC"));if area exists set justification to bottom centre

  (setq lotc (trans lotc 0 1));convert back to UCS
  (SETVAR "CLAYER"  "Drafting" )
	(SETVAR "CELWEIGHT" 50)				
  (COMMAND "TEXT" "J" just lotc (* TH THF) "90" lotno)
       (setq roadname (entget (entlast)))
 
  
(SETVAR "CELWEIGHT" -1)
  


(setq lotc (trans lotc 1 0));convert to world if using UCS
    
		(setq count 0)
		(setq minoff 100000000000000000000000000000000000000)
(repeat (- (length ptlist)2 )

  (setq op1 (nth count ptlist))
  (setq op2 (nth (+ count 1) ptlist))
  (setq op3 (nth (+ count 2) ptlist))



  ;check line one
;check offset to line
  (SETQ ANG (ANGLE oP1 oP2))
  (SETQ CANG (+ ANG (/ PI 2)))
  (SETQ P4 (POLAR lotc CANG 1000))
  (SETQ P6 (POLAR lotc (+ CANG PI) 2000))
  (IF (SETQ P5 (INTERS oP1 oP2 P6 P4 ))(PROGN

					 (SETQ OFF (DISTANCE lotc P5))

    (if (< OFF (ABS MINOFF))(SETQ minoff (abs off)
				  nearang cang)
      );if
    
  ));p & if inters

    ;check inside deflection angle
    (setq ang2 (angle op2 op3))
    (setq cang2 (+ ang (/ pi 2)))
    (setq ltopang (angle op2 lotc))
    (setq defl (- ang2 ang))
(if (/= defl 0);check for straight line
  (progn
    (if (< defl pi)(progn
		     (setq ray1 (- ang (/ pi 2)))
		     ;(if (< ray1 0) (setq ray1 (+ ray1 (* 2 pi))))
		     (setq ray2 (- ang2 (/ pi 2)))
		     ;(if (< ray2 0) (setq ray2 (+ ray2 (* 2pi))))
		     ));p and if less than pi
    (if (> defl pi)(progn
		     (setq ray1 (+ ang (/ pi 2)))
		     ;(if (> ray1 (* 2 pi)(setq ray1 (- ray1 (* 2 pi)))))
		     (setq ray2 (+ ang (/ pi 2)))
		     ;(if (> ray2 (* 2 pi)(setq ray2 (- ray2 (* 2 pi)))))
		     ));p and if greater than pi

    (if (or (and (> ltopang ray1) (< ltopang ray2))(and (> ltopang ray2)(< ltopang ray1)));check ot see if inside deflection squares **** needs testing later
      (progn
	(setq off (distance lotc op2))
(if (< OFF (ABS MINOFF))(SETQ minoff (abs off)
				  nearang ltopang)
      );if
	));p and if in defl sqr
   ));p and if not straight line

  (setq count (+ count 1))
    );repeat
      
				;using this info change the road name text rotation to the angle of the line
		(setq rrot (+ nearang (/ pi 2)))
		(if (> rrot (* 2 pi))(setq rrot (- rrot (* 2 pi))))
		(IF (AND (> rrot  (* 0.5 pi)) (< rrot (* 1.5 pi)))(setq rrot (+ rrot pi))) ;if text is upsidedown reverse rotation
					  
		
    
  (SETQ	roadname (subst (cons 50  rrot);SUB IN NEW POINT 2 HEIGHT
		     (assoc 50 roadname)
		     roadname     ) )
  (ENTMOD roadname)


  ;add area if there is one
  (setq areapos (polar lotc (+ (* 1.5 pi) rrot) (* th 2.5)))
  
   (if (/= area "")(COMMAND "TEXT" "J" just areapos (* TH 1.4) (angtos rrot)  textarea ))
(SETVAR "CELWEIGHT" -1)
  
    (SETVAR "CLAYER" prevlayer) 

  
(COMMAND "DRAWORDER" ENTSS "" "BACK")
(setvar "pickstyle" pickstyle)
  )

;---------------------------------------------------------------REDEFINE LOT CENTRES---------------------------------------------
(defun C:XMLC (/)

  (setq lots (ssget "_X" '((0 . "LWPOLYLINE") (8 . "Lot Definitions,Adjoining Boundary"))))
  (command "layiso" "s" "off" "" lots "")

  (setq lot (car (entsel "\nSelect Refernce lot")))
  (command "layuniso")

  (setq centext (car (entsel "\nSelect \"Lot Number\" Text")))

    (command "layiso" lots "")
  (princ "\nSelect Lots to apply shift to:")
   (setq lotstbe (ssget '((0 . "LWPOLYLINE") (8 . "Lot Definitions,Adjoining Boundary"))))
(command "layuniso");change from layerp for BricsCAD
  
     	    (SETQ XDATAI (ENTGET lot '("LANDXML")))
	   (SETQ XDATAI (ASSOC -3 XDATAI))
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))

       (setq !pos1 (vl-string-position 33 xdatai 0))
                      (setq lotc (substr xdatai (+ !pos1 2) 200))
                      (setq xdatai  (substr xdatai 1 !pos1))

(setq spcpos1 (vl-string-position 32 lotc 0))
                      (setq eeast (atof(substr lotc (+ spcpos1 2) 200)))
                      (setq enorth  (atof (substr lotc 1 spcpos1)))

 (SETQ P1 (CDR(ASSOC 11 (ENTGET centext))))
  (setq neast (car p1))
  (setq nnorth (cadr p1))
  (setq deltae (- neast eeast))
  (setq deltan (- nnorth enorth))

  (SETQ COUNT 0)
  (repeat (sslength lotstbe)
     (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME lotstbe COUNT)))))
    (SETQ P1 (CDR(ASSOC 10 (ENTGET (SSNAME lots COUNT)))))
      	    (SETQ XDATAI (ENTGET EN '("LANDXML")))
	    (IF (= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL)(princ (strcat "\nLot with no XML data at " (rtos (car p1) 2 3) "," (rtos (cadr p1)2 3))))
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))

      (setq !pos1 (vl-string-position 33 xdatai 0))
                      (setq lotc (substr xdatai (+ !pos1 2) 200))
                      (setq xdatai  (substr xdatai 1 !pos1))

    (setq spcpos1 (vl-string-position 32 lotc 0))
                      (setq east (ATOF(substr lotc (+ spcpos1 2) 200)))
                      (setq north  (ATOF(substr lotc 1 spcpos1)))
    (setq nlotc (strcat "!" (rtos (+ north deltan) 2 3) " " (rtos (+ east deltae) 2 3)))
    (setq LTINFO (strcat xdatai nlotc))

    (SETQ SENT EN)
  (SETQ SENTLIST (ENTGET SENT))

  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 LTINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)
(SETQ COUNT (+ COUNT 1))
    )

  (princ (strcat "\n Shift of " (rtos deltae 2 3) "," (rtos deltan 2 3) " applied to " (rtos count 2 0) " lots"))
  
  );d

;----------------------------------------------------------------REFERENCE MARK--------------------------------------------

(defun C:XRM (/)

    ;GET 1ST LINE INFO
    (graphscr)

  (setq prevlayer (getvar "CLAYER"))
    
    (setq p1 (getpoint "\nSelect Corner to Reference: "))
  
(setq prmtype rmtype)
  (setq rmtype (getstring T (strcat "\nType [" rmtype "](#-comment)(* for list):")))

  ;look for mark comment
  (setq minpos1 (vl-string-position 45 rmtype 0))
	(if (= minpos1 nil)(setq rmcomment "")(progn
					      (setq rmcomment (substr rmtype ( + minpos1 2) 500))
					      (setq rmtype (substr rmtype 1  minpos1 ))
					      )
	  )
  ;execute list finder
  (if (= rmtype "*")(progn
		      (setq workingselnum tselnum)
		      (setq names rmtypelist)
		      (dbox)
		      (setq rmtype returntype)
		      (setq tselnum workingselnum)
		      )
    )
    

  

  
(if (= rmtype "CB" ) (setq rmtype "Conc Block"))
  (if (= rmtype "")(setq rmtype prmtype ))
  (if (= (member rmtype rmtypelist) nil) (progn
					     (alert "\nType not fount, please choose from list" )
					   (setq workingselnum tselnum)
					     (setq names rmtypelist)
		      (dbox)
		      (setq rmtype returntype)
					   (setq tselnum workingselnum)
					     )
    )

  
  (setq prmstate rmstate)
 
  
  (setq rmstate (getstring (strcat "\nState eg Found/Placed[f/p](* for list)(default is placed):")))
(if (or (= rmstate "f") (= rmstate "F")) (setq rmstate "Found"))
(if (or (= rmstate "p") (= rmstate "P") (= rmstate "")) (setq rmstate "Placed"))

  (if (= rmstate "*")(progn
		       (setq workingselnum sselnum)
		      (setq names rmstatelist)
		      (dbox)
		      (setq rmstate returntype)
		       (setq sselnum workingselnum)
		      )
    )
  
  (if (= (member rmstate rmstatelist) nil) (progn
					     (Alert "\nState not fount, please choose from list:" )
					      (setq workingselnum sselnum)
		      (setq names rmstatelist)
		      (dbox)
		      (setq rmstate returntype)
		       (setq sselnum workingselnum)
					     )
    )

  

;Condition removed version 1.12 and Recipie 9.0
  (setq rmcondition "")
;  (setq rmcondition (getstring (strcat "\nCondition egDisturbed/Remains[d/r](* for list)(default is nil):")))
;(if (= rmcondition "*")(progn
;			 (setq workingselnum cselnum)
;		      (setq names rmconditionlist)
;		      (dbox)
;		      (setq rmcondition returntype)
;			 (setq cselnum workingselnum)
;		      )
;    )


  
;  (if (or (= rmcondition "d")(= rmcondition "D")) (setq rmcondition "Disturbed"))
 ; (if (or (= rmcondition "r")(= rmcondition "R")) (setq rmcondition "Remains"))
  
 ; (if (= (member rmcondition rmconditionlist) nil) (progn
;					     (Alert "\nCondition not fount, please choose from list" )
;					     (setq workingselnum cselnum)
;					     (setq names rmconditionlist)
					     
;		      (dbox)
;		      (setq rmcondition returntype)
;					     (setq cselnum workingselnum)
;					     )
 ;   )


  (setq bearing (getstring "\nBearing(DD.MMSS): "))
  
  
        (setq dist (getstring T (strcat "\nDistance[Meters/Feet/Links]" units ":")))

  (if (or (= dist "f") (= dist "F") (= dist "Feet") (= dist "feet") (= dist "FEET"))
    (progn
      (setq dist (getstring "\nDistance(Feet FF.II.n/d ): "))
      (setq units "F")
      )
    )

  (if (or (= dist "l") (= dist "L") (= dist "Links") (= dist "LINKS") (= DIST "links"))
    (progn
      (setq dist (getstring "\nDistance(Links): "))
      (setq units "L")
      )
    )

    (if (or (= dist "m") (= dist "M") (= dist "Meters") (= dist "meters") (= DIST "METERS"))
    (progn
      (setq dist (getstring "\nDistance(Meters): "))
      (setq units "M")
      )
    )

  (if (/= rmstate "Placed")(progn
   (setq rmrefdp (getstring T(strcat "\nReference DP number (default is nil)(L=Last " lrmrefdp "):")))
   
   (if (or (= rmrefdp "LAST")(= rmrefdp "Last")(= rmrefdp "L")(= rmrefdp "l")(= rmrefdp "last"))(setq rmrefdp lrmrefdp))
   (setq lrmrefdp rmrefdp)
  (if (= (substr rmrefdp 1 2) "dp") (setq rmrefdp (strcat "DP" ( substr rmrefdp 3 50))))
  (if (= (substr rmrefdp 1 2) "cp") (setq rmrefdp (strcat "CP" ( substr rmrefdp 3 50))))
    (if (and (>= (ascii (substr rmrefdp 1 1)) 48)(<= (ascii (substr rmrefdp 1 1)) 57))(setq rmrefdp (strcat "DP" rmrefdp)));will add dp if you enter only the number
   )
    (setq rmrefdp "")
    )

  
  
	(SETQ LBEARING (STRCAT BEARING))
  
 ;APPLY ALL CORRECTIONS AND EXTRACT INFORMATION FROM USER INPUT


  
;look for cardinals
  (setq card1 ""
	card2 "")
  (IF (OR (= (substr bearing 1 1 ) "n") (= (substr bearing 1 1 ) "N" )
	  (= (substr bearing 1 1 ) "s" )(= (substr bearing 1 1 ) "S" )
	  (= (substr bearing 1 1 ) "e" )(= (substr bearing 1 1 ) "E" )
	  (= (substr bearing 1 1 ) "w" )(= (substr bearing 1 1 ) "W" ))
(progn
    (setq card1 (substr bearing 1 1))
    (setq card2 (substr bearing (strlen bearing) 1))
    (setq bearing (substr bearing 2 (- (strlen bearing )2)))
  )
    )
    
  
(if (/= (vl-string-position 46 bearing 0) nil ) (PROGN
  (setq dotpt1 (vl-string-position 46 bearing 0))
  (setq deg  (substr bearing 1  dotpt1 ))
  (SETQ mins  (strcat (substr bearing (+ dotpt1 2) 2) (chr 39)))
  (setq sec  (substr bearing (+ dotpt1 4) 10))

  
  (if (> (strlen sec) 2) (setq sec (strcat (substr sec 1 2) "." (substr sec 3 10))))
  (if (= (strlen sec) 0) (setq sec "") (setq sec (strcat sec (chr 34))))

    (if (or
	(= (strlen sec) 2)
	(= (strlen mins) 2)
	(> (atof mins) 60)
	(> (atof sec) 60)
	(> (atof deg) 360)
	)
    (alert (strcat "That bearing looks a little funky - " bearing)))
  
  
  );P
	(progn
	  (setq deg bearing)
	  (setq mins "")
	  (setq sec "")
	  );p else
  
  );IF

 ;correct cardinals
  (if (and (or (= card1 "n")(= card1 "N"))(or (= card2 "w")(= card2 "W")))
    (progn
      (setq deg (rtos (- 360 (atof deg)) 2 0))
      (if (< 0 (atof mins))(progn
			     (setq mins (strcat (rtos (- 60 (atof mins)) 2 0) (chr 39)))
			     (setq deg (rtos (- (atof deg) 1) 2 0))
			     (if (< (atof deg) 0)(setq deg (rtos (+ (atof deg) 360) 2 0)))
				)
	     )
	(if (< 0 (atof sec))
	       (progn
		 (setq sec (strcat (rtos (- 60 (atof sec)) 2 0) (chr 34)))
		 (if (= 0 (atof mins)) (setq deg (rtos (- (atof deg) 1) 2 0)))
		 (setq mins (strcat (rtos (- (atof mins) 1) 2 0) (chr 39)))
	       
		 (if (< (atof deg) 0)(setq deg (rtos (+ (atof deg) 360) 2 0)))
		 (if (< (atof mins) 0)(setq mins (strcat (rtos (+ (atof mins) 60) 2 0)(chr 39))))
		 )
	  )
      	           
(if (or (and (< (atof mins) 10)(/= 0 (atof mins))) (= mins "0'")) (setq mins (strcat "0" mins)))
(if (and (< (atof sec) 10)(/= 0 (atof sec))) (setq sec (strcat "0" sec)))
		 
      )
    );NW

		   

		   (if (and (or (= card1 "w")(= card1 "W"))(or (= card2 "s")(= card2 "S")))
    (progn
      (setq deg (rtos (- 270 (atof deg)) 2 0))
      (if (< 0 (atof mins))(progn
			     (setq mins (strcat (rtos (- 60 (atof mins)) 2 0) (chr 39)))
			     (setq deg (rtos (- (atof deg) 1) 2 0))
			     (if (< (atof deg) 0)(setq deg (rtos (+ (atof deg) 360) 2 0)))
				)
	     )
	(if (< 0 (atof sec))
	       (progn
		 (setq sec (strcat (rtos (- 60 (atof sec)) 2 0) (chr 34)))
		 (if (= 0 (atof mins)) (setq deg (rtos (- (atof deg) 1) 2 0)))
		 (setq mins (strcat (rtos (- (atof mins) 1) 2 0) (chr 39)))
	       
		 (if (< (atof deg) 0)(setq deg (rtos (+ (atof deg) 360) 2 0)))
		 (if (< (atof mins) 0)(setq mins (strcat (rtos (+ (atof mins) 60) 2 0)(chr 39))))
		 )
	  )
      	           
(if (or (and (< (atof mins) 10)(/= 0 (atof mins))) (= mins "0'")) (setq mins (strcat "0" mins)))
(if (and (< (atof sec) 10)(/= 0 (atof sec))) (setq sec (strcat "0" sec)))
		 
      )
    );WS

		   
		   (if (and (or (= card1 "e")(= card1 "E"))(or (= card2 "n")(= card2 "N")))
    (progn
      (setq deg (rtos (- 90 (atof deg)) 2 0))
      (if (< 0 (atof mins))(progn
			     (setq mins (strcat (rtos (- 60 (atof mins)) 2 0) (chr 39)))
			     (setq deg (rtos (- (atof deg) 1) 2 0))
			     (if (< (atof deg) 0)(setq deg (rtos (+ (atof deg) 360) 2 0)))
				)
	     )
	(if (< 0 (atof sec))
	       (progn
		 (setq sec (strcat (rtos (- 60 (atof sec)) 2 0) (chr 34)))
		 (if (= 0 (atof mins)) (setq deg (rtos (- (atof deg) 1) 2 0)))
		 (setq mins (strcat (rtos (- (atof mins) 1) 2 0) (chr 39)))
	       
		 (if (< (atof deg) 0)(setq deg (rtos (+ (atof deg) 360) 2 0)))
		 (if (< (atof mins) 0)(setq mins (strcat (rtos (+ (atof mins) 60) 2 0)(chr 39))))
		 )
	  )
      	           
(if (or (and (< (atof mins) 10)(/= 0 (atof mins))) (= mins "0'")) (setq mins (strcat "0" mins)))
(if (and (< (atof sec) 10)(/= 0 (atof sec))) (setq sec (strcat "0" sec)))
		 
      )
    );EN

  (if (and (or (= card1 "s")(= card1 "S"))(or (= card2 "e")(= card2 "E")))
    (progn
      (setq deg (rtos (- 180 (atof deg)) 2 0))
      (if (< 0 (atof mins))(progn
			     (setq mins (strcat (rtos (- 60 (atof mins)) 2 0) (chr 39)))
			     (setq deg (rtos (- (atof deg) 1) 2 0))
			     (if (< (atof deg) 0)(setq deg (rtos (+ (atof deg) 360) 2 0)))
				)
	     )
	(if (< 0 (atof sec))
	       (progn
		 (setq sec (strcat (rtos (- 60 (atof sec)) 2 0) (chr 34)))
		 (if (= 0 (atof mins)) (setq deg (rtos (- (atof deg) 1) 2 0)))
		 (setq mins (strcat (rtos (- (atof mins) 1) 2 0) (chr 39)))
	       
		 (if (< (atof deg) 0)(setq deg (rtos (+ (atof deg) 360) 2 0)))
		 (if (< (atof mins) 0)(setq mins (strcat (rtos (+ (atof mins) 60) 2 0)(chr 39))))
		 )
	  )
      	           
(if (or (and (< (atof mins) 10)(/= 0 (atof mins))) (= mins "0'")) (setq mins (strcat "0" mins)))
(if (and (< (atof sec) 10)(/= 0 (atof sec))) (setq sec (strcat "0" sec)))
		 
      )
    );SE

  (if (and (or (= card1 "s")(= card1 "S"))(or (= card2 "w")(= card2 "W")))
    (progn
      (setq deg (rtos (+ 180 (atof deg)) 2 0))
      
      )
    );SW

		    (if (and (or (= card1 "w")(= card1 "W"))(or (= card2 "n")(= card2 "N")))
    (progn
      (setq deg (rtos (+ 270 (atof deg)) 2 0))
      
      )
    );WN
		    (if (and (or (= card1 "e")(= card1 "E"))(or (= card2 "s")(= card2 "S")))
    (progn
      (setq deg (rtos (+ 90 (atof deg)) 2 0))
      
      )
    );ES
  
	
  
      (setq rswitch "T")
  


  ;look for line comment
  (setq spcpos1 (vl-string-position 32 dist 0))
	(if (= spcpos1 nil)(setq comment "")(progn
					      (setq comment (substr dist ( + spcpos1 2) 50))
					      (setq dist (substr dist 1  spcpos1 ))
					      )
	  )


  
    (if (= units "F")
      (progn
	(setq dotpos1 (vl-string-position 46 dist 0))
	(if (= dotpos1 nil)(setq dotpos2 nil)(setq dotpos2 (vl-string-position 46 dist (+ dotpos1 1))))
	(setq /pos1 (vl-string-position 47 dist 0))
	(if (/= /pos1 nil)
	  (progn
	    (setq den (substr dist ( + /pos1 2) 50))
	    (setq num (substr dist ( + dotpos2 2) (- (- /pos1 dotpos2) 1)))
	    (setq idist (/ (atof num) (atof den)))
	    (setq inches (substr dist (+ dotpos1 2) (- (- dotpos2 dotpos1) 1)))
	    (setq idist (+ idist (atof inches)))
	    (setq feet (substr dist 1  dotpos1 ))
	    (setq idist (+ idist (* (atof feet) 12)))
	    (setq dist (rtos (* idist 0.0254) 2 9))
	    )
	  )
	(if (and (/= dotpos1 nil) (= /pos1 nil))
	  (progn
	    (setq inches (substr dist ( + dotpos1 2) 50))
	    (setq feet (substr dist 1  dotpos1 ))
	    (setq idist  (atof inches))
	    (setq idist (+ idist (* (atof feet) 12)))
	    (setq dist (rtos (* idist 0.0254) 2 9))
	    )
	  )
	(if (and (= dotpos1 nil) (= /pos1 nil) (= dotpos2 nil))
	  (progn
	   
	    (setq feet (substr dist 1  50))
	    (setq idist (* (atof feet) 12))
	    (setq dist (rtos (* idist 0.0254) 2 9))
	    )
	  )
      )
    )
  (if (= units "L")
    (progn
      (setq dist (atof dist))
      (setq dist (rtos (* dist 0.201168)))
      )
    )

  
  (SETQ BEARING (STRCAT DEG "d" MINS  SEC ))

  

      
  (setq dist (rtos (atof dist)2 3));remove trailing zeros
  (setq ldist dist)
	      

    ;DRAW LINE 1
  
(SETVAR "CLAYER"  "RM Connection" )
  (setq linetext (strcat "@" dist "<" bearing))
  (command "line" p1 linetext "")



  
;Add observation data to line as XDATA
(if (/= comment "")(setq ocomment (strcat "><FieldNote>\"" comment "\"</FieldNote></ReducedObservation>"))(setq ocomment "/>"))
(if (/= rmrefdp "")(setq ormrefdpads (strcat " adoptedDistanceSurvey=\"" rmrefdp "\""))(setq ormrefdpads ""))
(SETQ BDINFO (STRCAT "azimuth=\"" lbearing "\" horizDistance=\"" ldist "\" distanceType=\"Measured\"" " distanceAccClass=\"" rmstate "\"" ormrefdpads ocomment))
(SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 BDINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)
  ;Move line if reverse activated
(if (= rswitch "T")
  (progn
    (setq p1 (CDR(ASSOC 10 sentlist)))
    (setq p2 (CDR(ASSOC 11 sentlist)))
    (command "move" sent "" p2 p1)
    );p
  );if

  ;GET LAST LINE DATA
  (SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
   (setq p1 (CDR(ASSOC 10 sentlist)))
   (setq p2 (CDR(ASSOC 11 sentlist)))
  
(lrm);DRAW DP REF INFO

 


  (SETVAR "CLAYER" "Monument" )
  (COMMAND "POINT" P1)

  ;check for no values and replace with "none"
  (if (= rmrefdp "")(setq rmrefdp "none"))
  ;(if (= rmcondition "")(setq rmcondition "none"))
  (if (= rmrefdp "")(setq rmrefdp "none"))
  ;(if (or (= rmtype "SSM")(= rmtype "PM")(= rmtype "TS")(= rmtype "MM")(= rmtype "GB")(= rmtype "CP")(= rmtype "CR"))(setq rmcomment (strcat rmcomment "used as reference mark")))
 


     (if (/= rmcomment "")(setq ormcomment (strcat " desc=\"" rmcomment "\""))(setq ormcomment ""))
  ; (if (/= rmcondition "none")(setq ormcondition (strcat " condition=\"" rmcondition "\""))
     (setq ormcondition "")
   (if (/= rmrefdp "none")(setq ormrefdp (strcat " originSurvey=\"" rmrefdp "\""))(setq ormrefdp ""))
  
    (SETQ PTINFO (STRCAT "type=\"" rmtype "\" state=\""  rmstate "\"" ormcondition  ormrefdp  ormcomment " />" ));Note comment for desc in xml added to distance entry seperated by a space
(SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 PTINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)

  
  ;DRAW RM BLOCK AND ADD RM POINT
  (SETVAR "CLAYER" "Drafting" )
  (COMMAND "._INSERT" "RM" "_S" TH P2 "0");changed to lock in scale for BricsCAD via www.cadconcepts.co.nz
;  (SETQ RMB (ENTLAST))
;  (SETQ ENTSS (SSADD))
;  (SSADD RMB ENTSS)
;(COMMAND "DRAWORDER" ENTSS "" "FRONT")
  


  (setvar "clayer" prevlayer )
)

;----------------------------------------------------------------DOUBLE REFERENCE MARK--------------------------------------------

(defun C:XDRM (/)

    ;GET 1ST LINE INFO
    (graphscr)

  (setq prevlayer (getvar "CLAYER"))
    
    (setq inp1 (getpoint "\nSelect Corner to Reference: "))
  
(setq prmtype rmtype)
  (setq rmtype (getstring T (strcat "\nType [" rmtype "](#-comment)(* for list):")))

  ;look for mark comment
  (setq minpos1 (vl-string-position 45 rmtype 0))
	(if (= minpos1 nil)(setq rmcomment "")(progn
					      (setq rmcomment (substr rmtype ( + minpos1 2) 50))
					      (setq rmtype (substr rmtype 1  minpos1 ))
					      )
	  )
  ;execute list finder
  (if (= rmtype "*")(progn
		      (setq workingselnum tselnum)
		      (setq names rmtypelist)
		      (dbox)
		      (setq rmtype returntype)
		      (setq tselnum workingselnum)
		      )
    )
    

  

  
(if (= rmtype "CB" ) (setq rmtype "Conc Block"))
  (if (= rmtype "")(setq rmtype prmtype ))
  (if (= (member rmtype rmtypelist) nil) (progn
					     (alert "\nType not fount, please choose from list" )
					   (setq workingselnum tselnum)
					     (setq names rmtypelist)
		      (dbox)
		      (setq rmtype returntype)
					   (setq tselnum workingselnum)
					     )
    )

  
  (setq prmstate rmstate)
 
  
  (setq rmstate (getstring (strcat "\nState eg Found/Placed[f/p](* for list)(default is placed):")))
(if (or (= rmstate "f") (= rmstate "F")) (setq rmstate "Found"))
(if (or (= rmstate "p") (= rmstate "P") (= rmstate "")) (setq rmstate "Placed"))

  (if (= rmstate "*")(progn
		       (setq workingselnum sselnum)
		      (setq names rmstatelist)
		      (dbox)
		      (setq rmstate returntype)
		       (setq sselnum workingselnum)
		      )
    )
  
  (if (= (member rmstate rmstatelist) nil) (progn
					     (Alert "\nState not fount, please choose from list:" )
					      (setq workingselnum sselnum)
		      (setq names rmstatelist)
		      (dbox)
		      (setq rmstate returntype)
		       (setq sselnum workingselnum)
					     )
    )

;condition removed
 (setq rmcondition "")


  (setq bearing (getstring "\nBearing(DD.MMSS): "))
  
  
        (setq dist1 (getstring T (strcat "\nDistance[Meters/Feet/Links]" units ":")))

     (setq dist2 (getstring T (strcat "\nOther Distance[Meters/Feet/Links]" units ":")))

  (if (or (= dist "f") (= dist "F") (= dist "Feet") (= dist "feet") (= dist "FEET"))
    (progn
      (setq dist (getstring "\nDistance(Feet FF.II.n/d ): "))
      (setq units "F")
      )
    )

  (if (or (= dist1 "l") (= dist1 "L") (= dist1 "Links") (= dist1 "LINKS") (= dist1 "links"))
    (progn
      (setq dist1 (getstring "\ndist1ance(Links): "))
      (setq units "L")
      )
    )

    (if (or (= dist1 "m") (= dist1 "M") (= dist1 "Meters") (= dist1 "meters") (= dist1 "METERS"))
    (progn
      (setq dist1 (getstring "\ndist1ance(Meters): "))
      (setq units "M")
      )
    )


   (if (or (= dist2 "f") (= dist2 "F") (= dist2 "Feet") (= dist2 "feet") (= dist2 "FEET"))
    (progn
      (setq dist2 (getstring "\ndist2ance(Feet FF.II.n/d ): "))
      (setq units "F")
      )
    )

  (if (or (= dist2 "l") (= dist2 "L") (= dist2 "Links") (= dist2 "LINKS") (= dist2 "links"))
    (progn
      (setq dist2 (getstring "\ndist2ance(Links): "))
      (setq units "L")
      )
    )

    (if (or (= dist2 "m") (= dist2 "M") (= dist2 "Meters") (= dist2 "meters") (= dist2 "METERS"))
    (progn
      (setq dist2 (getstring "\ndist2ance(Meters): "))
      (setq units "M")
      )
    )

  (if (/= rmstate "Placed")(progn
   (setq rmrefdp (getstring T(strcat "\nReference DP number (default is nil)(L=Last " lrmrefdp "):")))
   
   (if (or (= rmrefdp "LAST")(= rmrefdp "Last")(= rmrefdp "L")(= rmrefdp "l")(= rmrefdp "last"))(setq rmrefdp lrmrefdp))
   (setq lrmrefdp rmrefdp)
  (if (= (substr rmrefdp 1 2) "dp") (setq rmrefdp (strcat "DP" ( substr rmrefdp 3 50))))
  (if (= (substr rmrefdp 1 2) "cp") (setq rmrefdp (strcat "CP" ( substr rmrefdp 3 50))))
    (if (and (>= (ascii (substr rmrefdp 1 1)) 48)(<= (ascii (substr rmrefdp 1 1)) 57))(setq rmrefdp (strcat "DP" rmrefdp)));will add dp if you enter only the number
   )
    (setq rmrefdp "")
    )

  
  
	(SETQ LBEARING (STRCAT BEARING))
  
 ;APPLY ALL CORRECTIONS AND EXTRACT INFORMATION FROM USER INPUT

  
;look for cardinals
  (setq card1 ""
	card2 "")
  (IF (OR (= (substr bearing 1 1 ) "n") (= (substr bearing 1 1 ) "N" )
	  (= (substr bearing 1 1 ) "s" )(= (substr bearing 1 1 ) "S" )
	  (= (substr bearing 1 1 ) "e" )(= (substr bearing 1 1 ) "E" )
	  (= (substr bearing 1 1 ) "w" )(= (substr bearing 1 1 ) "W" ))
(progn
    (setq card1 (substr bearing 1 1))
    (setq card2 (substr bearing (strlen bearing) 1))
    (setq bearing (substr bearing 2 (- (strlen bearing )2)))
  )
    )
    
  
(if (/= (vl-string-position 46 bearing 0) nil ) (PROGN
  (setq dotpt1 (vl-string-position 46 bearing 0))
  (setq deg  (substr bearing 1  dotpt1 ))
  (SETQ mins  (strcat (substr bearing (+ dotpt1 2) 2) (chr 39)))
  (setq sec  (substr bearing (+ dotpt1 4) 10))

  
  (if (> (strlen sec) 2) (setq sec (strcat (substr sec 1 2) "." (substr sec 3 10))))
  (if (= (strlen sec) 0) (setq sec "") (setq sec (strcat sec (chr 34))))

    (if (or
	(= (strlen sec) 2)
	(= (strlen mins) 2)
	(> (atof mins) 60)
	(> (atof sec) 60)
	(> (atof deg) 360)
	)
    (alert (strcat "That bearing looks a little funky - " bearing)))
  
  );P
	(progn
	  (setq deg bearing)
	  (setq mins "")
	  (setq sec "")
	  );p else
  
  );IF

 ;correct cardinals
  (if (and (or (= card1 "n")(= card1 "N"))(or (= card2 "w")(= card2 "W")))
    (progn
      (setq deg (rtos (- 360 (atof deg)) 2 0))
      (if (< 0 (atof mins))(progn
			     (setq mins (strcat (rtos (- 60 (atof mins)) 2 0) (chr 39)))
			     (setq deg (rtos (- (atof deg) 1) 2 0))
			     (if (< (atof deg) 0)(setq deg (rtos (+ (atof deg) 360) 2 0)))
				)
	     )
	(if (< 0 (atof sec))
	       (progn
		 (setq sec (strcat (rtos (- 60 (atof sec)) 2 0) (chr 34)))
		 (if (= 0 (atof mins)) (setq deg (rtos (- (atof deg) 1) 2 0)))
		 (setq mins (strcat (rtos (- (atof mins) 1) 2 0) (chr 39)))
	       
		 (if (< (atof deg) 0)(setq deg (rtos (+ (atof deg) 360) 2 0)))
		 (if (< (atof mins) 0)(setq mins (strcat (rtos (+ (atof mins) 60) 2 0)(chr 39))))
		 )
	  )
      	           
(if (or (and (< (atof mins) 10)(/= 0 (atof mins))) (= mins "0'")) (setq mins (strcat "0" mins)))
(if (and (< (atof sec) 10)(/= 0 (atof sec))) (setq sec (strcat "0" sec)))
		 
      )
    );NW

		   

		   (if (and (or (= card1 "w")(= card1 "W"))(or (= card2 "s")(= card2 "S")))
    (progn
      (setq deg (rtos (- 270 (atof deg)) 2 0))
      (if (< 0 (atof mins))(progn
			     (setq mins (strcat (rtos (- 60 (atof mins)) 2 0) (chr 39)))
			     (setq deg (rtos (- (atof deg) 1) 2 0))
			     (if (< (atof deg) 0)(setq deg (rtos (+ (atof deg) 360) 2 0)))
				)
	     )
	(if (< 0 (atof sec))
	       (progn
		 (setq sec (strcat (rtos (- 60 (atof sec)) 2 0) (chr 34)))
		 (if (= 0 (atof mins)) (setq deg (rtos (- (atof deg) 1) 2 0)))
		 (setq mins (strcat (rtos (- (atof mins) 1) 2 0) (chr 39)))
	       
		 (if (< (atof deg) 0)(setq deg (rtos (+ (atof deg) 360) 2 0)))
		 (if (< (atof mins) 0)(setq mins (strcat (rtos (+ (atof mins) 60) 2 0)(chr 39))))
		 )
	  )
      	           
(if (or (and (< (atof mins) 10)(/= 0 (atof mins))) (= mins "0'")) (setq mins (strcat "0" mins)))
(if (and (< (atof sec) 10)(/= 0 (atof sec))) (setq sec (strcat "0" sec)))
		 
      )
    );WS

		   
		   (if (and (or (= card1 "e")(= card1 "E"))(or (= card2 "n")(= card2 "N")))
    (progn
      (setq deg (rtos (- 90 (atof deg)) 2 0))
      (if (< 0 (atof mins))(progn
			     (setq mins (strcat (rtos (- 60 (atof mins)) 2 0) (chr 39)))
			     (setq deg (rtos (- (atof deg) 1) 2 0))
			     (if (< (atof deg) 0)(setq deg (rtos (+ (atof deg) 360) 2 0)))
				)
	     )
	(if (< 0 (atof sec))
	       (progn
		 (setq sec (strcat (rtos (- 60 (atof sec)) 2 0) (chr 34)))
		 (if (= 0 (atof mins)) (setq deg (rtos (- (atof deg) 1) 2 0)))
		 (setq mins (strcat (rtos (- (atof mins) 1) 2 0) (chr 39)))
	       
		 (if (< (atof deg) 0)(setq deg (rtos (+ (atof deg) 360) 2 0)))
		 (if (< (atof mins) 0)(setq mins (strcat (rtos (+ (atof mins) 60) 2 0)(chr 39))))
		 )
	  )
      	           
(if (or (and (< (atof mins) 10)(/= 0 (atof mins))) (= mins "0'")) (setq mins (strcat "0" mins)))
(if (and (< (atof sec) 10)(/= 0 (atof sec))) (setq sec (strcat "0" sec)))
		 
      )
    );EN

  (if (and (or (= card1 "s")(= card1 "S"))(or (= card2 "e")(= card2 "E")))
    (progn
      (setq deg (rtos (- 180 (atof deg)) 2 0))
      (if (< 0 (atof mins))(progn
			     (setq mins (strcat (rtos (- 60 (atof mins)) 2 0) (chr 39)))
			     (setq deg (rtos (- (atof deg) 1) 2 0))
			     (if (< (atof deg) 0)(setq deg (rtos (+ (atof deg) 360) 2 0)))
				)
	     )
	(if (< 0 (atof sec))
	       (progn
		 (setq sec (strcat (rtos (- 60 (atof sec)) 2 0) (chr 34)))
		 (if (= 0 (atof mins)) (setq deg (rtos (- (atof deg) 1) 2 0)))
		 (setq mins (strcat (rtos (- (atof mins) 1) 2 0) (chr 39)))
	       
		 (if (< (atof deg) 0)(setq deg (rtos (+ (atof deg) 360) 2 0)))
		 (if (< (atof mins) 0)(setq mins (strcat (rtos (+ (atof mins) 60) 2 0)(chr 39))))
		 )
	  )
      	           
(if (or (and (< (atof mins) 10)(/= 0 (atof mins))) (= mins "0'")) (setq mins (strcat "0" mins)))
(if (and (< (atof sec) 10)(/= 0 (atof sec))) (setq sec (strcat "0" sec)))
		 
      )
    );SE

  (if (and (or (= card1 "s")(= card1 "S"))(or (= card2 "w")(= card2 "W")))
    (progn
      (setq deg (rtos (+ 180 (atof deg)) 2 0))
      
      )
    );SW

		    (if (and (or (= card1 "w")(= card1 "W"))(or (= card2 "n")(= card2 "N")))
    (progn
      (setq deg (rtos (+ 270 (atof deg)) 2 0))
      
      )
    );WN
		    (if (and (or (= card1 "e")(= card1 "E"))(or (= card2 "s")(= card2 "S")))
    (progn
      (setq deg (rtos (+ 90 (atof deg)) 2 0))
      
      )
    );ES
  
			   


  
      (setq rswitch "T")
     
  
  ;look for line comment dist1
  (setq spcpos1 (vl-string-position 32 dist1 0))
	(if (= spcpos1 nil)(setq comment1 "")(progn
					      (setq comment1 (substr dist1 ( + spcpos1 2) 50))
					      (setq dist1 (substr dist1 1  spcpos1 ))
					      )
	  )

  ;look for line comment dist2
  (setq spcpos1 (vl-string-position 32 dist2 0))
	(if (= spcpos1 nil)(setq comment2 "")(progn
					      (setq comment2 (substr dist2 ( + spcpos1 2) 50))
					      (setq dist2 (substr dist2 1  spcpos1 ))
					      )
	  )


;dist1
  
    (if (= units "F")
      (progn
	(setq dotpos1 (vl-string-position 46 dist1 0))
	(if (= dotpos1 nil)(setq dotpos2 nil)(setq dotpos2 (vl-string-position 46 dist1 (+ dotpos1 1))))
	(setq /pos1 (vl-string-position 47 dist1 0))
	(if (/= /pos1 nil)
	  (progn
	    (setq den (substr dist1 ( + /pos1 2) 50))
	    (setq num (substr dist1 ( + dotpos2 2) (- (- /pos1 dotpos2) 1)))
	    (setq idist1 (/ (atof num) (atof den)))
	    (setq inches (substr dist1 (+ dotpos1 2) (- (- dotpos2 dotpos1) 1)))
	    (setq idist1 (+ idist1 (atof inches)))
	    (setq feet (substr dist1 1  dotpos1 ))
	    (setq idist1 (+ idist1 (* (atof feet) 12)))
	    (setq dist1 (rtos (* idist1 0.0254) 2 9))
	    )
	  )
	(if (and (/= dotpos1 nil) (= /pos1 nil))
	  (progn
	    (setq inches (substr dist1 ( + dotpos1 2) 50))
	    (setq feet (substr dist1 1  dotpos1 ))
	    (setq idist1  (atof inches))
	    (setq idist1 (+ idist1 (* (atof feet) 12)))
	    (setq dist1 (rtos (* idist1 0.0254) 2 9))
	    )
	  )
	(if (and (= dotpos1 nil) (= /pos1 nil) (= dotpos2 nil))
	  (progn
	   
	    (setq feet (substr dist1 1  50))
	    (setq idist1 (* (atof feet) 12))
	    (setq dist1 (rtos (* idist1 0.0254) 2 9))
	    )
	  )
      )
    )
  (if (= units "L")
    (progn
      (setq dist1 (atof dist1))
      (setq dist1 (rtos (* dist1 0.201168)))
      )
    )


  ;dist2

  (if (= units "F")
      (progn
	(setq dotpos1 (vl-string-position 46 dist2 0))
	(if (= dotpos1 nil)(setq dotpos2 nil)(setq dotpos2 (vl-string-position 46 dist2 (+ dotpos1 1))))
	(setq /pos1 (vl-string-position 47 dist2 0))
	(if (/= /pos1 nil)
	  (progn
	    (setq den (substr dist2 ( + /pos1 2) 50))
	    (setq num (substr dist2 ( + dotpos2 2) (- (- /pos1 dotpos2) 1)))
	    (setq idist2 (/ (atof num) (atof den)))
	    (setq inches (substr dist2 (+ dotpos1 2) (- (- dotpos2 dotpos1) 1)))
	    (setq idist2 (+ idist2 (atof inches)))
	    (setq feet (substr dist2 1  dotpos1 ))
	    (setq idist2 (+ idist2 (* (atof feet) 12)))
	    (setq dist2 (rtos (* idist2 0.0254) 2 9))
	    )
	  )
	(if (and (/= dotpos1 nil) (= /pos1 nil))
	  (progn
	    (setq inches (substr dist2 ( + dotpos1 2) 50))
	    (setq feet (substr dist2 1  dotpos1 ))
	    (setq idist2  (atof inches))
	    (setq idist2 (+ idist2 (* (atof feet) 12)))
	    (setq dist2 (rtos (* idist2 0.0254) 2 9))
	    )
	  )
	(if (and (= dotpos1 nil) (= /pos1 nil) (= dotpos2 nil))
	  (progn
	   
	    (setq feet (substr dist2 1  50))
	    (setq idist2 (* (atof feet) 12))
	    (setq dist2 (rtos (* idist2 0.0254) 2 9))
	    )
	  )
      )
    )
  (if (= units "L")
    (progn
      (setq dist2 (atof dist2))
      (setq dist2 (rtos (* dist2 0.201168)))
      )
    )

  

  
  (SETQ BEARING (STRCAT DEG "d" MINS  SEC ))

  

      
  (setq dist1 (rtos (atof dist1)2 3));remove trailing zeros
  

   (setq dist2 (rtos (atof dist2)2 3));remove trailing zeros
  (setq comment (strcat comment1 "&" dist2 comment2))
  (setq ldist dist1 )
  (setq ldist1 dist1)
  (setq ldist2 dist2)
	      

    ;DRAW LINE 1
  
(SETVAR "CLAYER"  "RM Connection" )
  (setq linetext (strcat "@" dist1 "<" bearing))
  (command "line" inp1 linetext "")

  

;Add observation data to line as XDATA line1
(if (/= comment1 "")(setq ocomment (strcat "><FieldNote>\"" comment1 "\"</FieldNote></ReducedObservation>"))(setq ocomment "/>"))
(if (/= rmrefdp "")(setq ormrefdpads (strcat " adoptedDistanceSurvey=\"" rmrefdp "\""))(setq ormrefdpads ""))
(SETQ BDINFO (STRCAT "azimuth=\"" lbearing "\" horizDistance=\"" ldist "\" distanceType=\"Measured\"" " distanceAccClass=\"" rmstate "\"" ormrefdpads ocomment))
(SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 BDINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)
  ;Move line if reverse activated
(if (= rswitch "T")
  (progn
    (setq p1 (CDR(ASSOC 10 sentlist)))
    (setq p2 (CDR(ASSOC 11 sentlist)))
    (command "move" sent "" p2 p1)
    );p
  );if

  ;GET LAST LINE DATA
  (SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
   (setq p1 (CDR(ASSOC 10 sentlist)))
   (setq p2 (CDR(ASSOC 11 sentlist)))
  
(lrm);DRAW DP REF INFO

  (SETVAR "CLAYER" "Monument" )
  (COMMAND "POINT" P1)

  ;check for no values and replace with "none"
  (if (= rmrefdp "")(setq rmrefdp "none"))
  ;(if (= rmcondition "")(setq rmcondition "none"))
  (if (= rmrefdp "")(setq rmrefdp "none"))
  ;(if (or (= rmtype "SSM")(= rmtype "PM")(= rmtype "TS")(= rmtype "MM")(= rmtype "GB")(= rmtype "CP")(= rmtype "CR"))(setq rmcomment (strcat rmcomment "used as reference mark")))
 


     (if (/= rmcomment "")(setq ormcomment (strcat " desc=\"" rmcomment "\""))(setq ormcomment ""))
   ;(if (/= rmcondition "none")(setq ormcondition (strcat " condition=\"" rmcondition "\""))
     (setq ormcondition "")
   (if (/= rmrefdp "none")(setq ormrefdp (strcat " originSurvey=\"" rmrefdp "\""))(setq ormrefdp ""))
  
    (SETQ PTINFO (STRCAT "type=\"" rmtype "\" state=\""  rmstate "\"" ormcondition  ormrefdp  ormcomment " />" ));Note comment for desc in xml added to distance entry seperated by a space
(SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 PTINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)

  ;line2

  (SETVAR "CLAYER"  "RM Connection" )
  (setq linetext (strcat "@" dist2 "<" bearing))
  (command "line" inp1 linetext "")

  

  
;Add observation data to line as XDATA line2
(if (/= comment2 "")(setq ocomment (strcat "><FieldNote>\"" comment2 "\"</FieldNote></ReducedObservation>"))(setq ocomment "/>"))
(if (/= rmrefdp "none")(setq ormrefdpads (strcat " adoptedDistanceSurvey=\"" rmrefdp "\""))(setq ormrefdpads ""))
(SETQ BDINFO (STRCAT "azimuth=\"" lbearing "\" horizDistance=\"" ldist2 "\" distanceType=\"Measured\"" " distanceAccClass=\"" rmstate "\"" ormrefdpads ocomment))
(SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 BDINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)
  ;Move line if reverse activated
(if (= rswitch "T")
  (progn
    (setq p1 (CDR(ASSOC 10 sentlist)))
    (setq p2 (CDR(ASSOC 11 sentlist)))
    (command "move" sent "" p2 p1)
    );p
  );if

  ;GET LAST LINE DATA
  (SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
   (setq p1 (CDR(ASSOC 10 sentlist)))
   (setq p2 (CDR(ASSOC 11 sentlist)))
  


  (SETVAR "CLAYER" "Monument" )
  (COMMAND "POINT" P1)

  ;check for no values and replace with "none"
  (if (= rmrefdp "")(setq rmrefdp "none"))
  ;(if (= rmcondition "")(setq rmcondition "none"))
  (if (= rmrefdp "")(setq rmrefdp "none"))
  ;(if (or (= rmtype "SSM")(= rmtype "PM")(= rmtype "TS")(= rmtype "MM")(= rmtype "GB")(= rmtype "CP")(= rmtype "CR"))(setq rmcomment (strcat rmcomment "used as reference mark")))
 


     (if (/= rmcomment "")(setq ormcomment (strcat " desc=\"" rmcomment "\""))(setq ormcomment ""))
   ;(if (/= rmcondition "none")(setq ormcondition (strcat " condition=\"" rmcondition "\""))
     (setq ormcondition "")
   (if (/= rmrefdp "none")(setq ormrefdp (strcat " originSurvey=\"" rmrefdp "\""))(setq ormrefdp ""))
  
    (SETQ PTINFO (STRCAT "type=\"" rmtype "\" state=\""  rmstate "\"" ormcondition  ormrefdp  ormcomment " />" ));Note comment for desc in xml added to distance entry seperated by a space
(SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 PTINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)


     
  ;DRAW RM BLOCK AND ADD RM POINT
  (SETVAR "CLAYER" "Drafting" )
  (COMMAND "._INSERT" "RM" "_S" TH P2 "0");changed to lock in scale for BricsCAD via www.cadconcepts.co.nz
;  (SETQ RMB (ENTLAST))
;  (SETQ ENTSS (SSADD))
;  (SSADD RMB ENTSS)
;(COMMAND "DRAWORDER" ENTSS "" "FRONT")
  


  (setvar "clayer" prevlayer )
)



;----------------------------------------------------------------NON PEG CORNER MARK--------------------------------------------

(defun C:XCM (/)

    ;GET 1ST LINE INFO
    (graphscr)
    (setq prevlayer (getvar "CLAYER"))
  
    (setq p1 (getpoint "\nSelect Corner with mark: "))


(setq prmtype rmtype)
  (setq rmtype (getstring T (strcat "\nType [" rmtype "](* for list)(#-comment):")))

    ;look for mark comment
  (setq minpos1 (vl-string-position 45 rmtype 0))
	(if (= minpos1 nil)(setq rmcomment "")(progn
					      (setq rmcomment (substr rmtype ( + minpos1 2) 50))
					      (setq rmtype (substr rmtype 1  minpos1 ))
					      )
	  )
  (if (= rmtype "*")(progn
		      (setq workingselnum tselnum)
		      (setq names rmtypelist)
		      (dbox)
		      (setq rmtype returntype)
		      (setq tselnum workingselnum)
		      )
    )

  
    


  
(if (= rmtype "CB" ) (setq rmtype "Conc Block"))
  (if (= rmtype "")(setq rmtype prmtype ))
  (if (= (member rmtype rmtypelist) nil) (progn
					     (Alert "\nType not fount, please select from list" )
					   (setq workingselnum tselnum)
					      (setq names rmtypelist)
		      (dbox)
		      (setq rmtype returntype)
					   (setq workingselnum tselnum)
					     )
    )
  (if (= rmtype "None")(setq rmtype ""));gone or not found mark

  (if (and (= rmcomment "")(= rmtype "Occupation"))
	   (setq rmcomment (getstring T "\nOccupation Selected, please give type:"))
  )
  
  (setq prmstate rmstate)

  ;(IF (= rmtype "")(progn;deal with rmtype none with selector
;			 (setq rmstate (getstring "\nNone Selected - Gone or Not Found[G/N](default is Gone):"))
;			 (if (or (= rmstate "n") (= rmstate "N")) (setq rmstate "Not Found"))
;			 (if (or (= rmstate "g") (= rmstate "G") (= rmstate "")) (setq rmstate "Gone"))
;			 (setq rmcondition "")
;			 )
    
 ;   (progn;else just do a normal state selection
			       
  
  (setq rmstate (getstring (strcat "\nState eg Found/Placed[f/p](* for list)(default is placed):")))
   (if (= rmstate "*")(progn
			(setq workingselnum sselnum)
		      (setq names rmstatelist)
		      (dbox)
		      (setq rmstate returntype)
			(setq sselnum workingselnum)
		      )
    )
(if (or (= rmstate "f") (= rmstate "F")) (setq rmstate "Found"))
(if (or (= rmstate "p") (= rmstate "P") (= rmstate "")) (setq rmstate "Placed"))
  
  (if (= (member rmstate rmstatelist) nil) (progn
					     (Alert "\nState not fount, please choose from list" )
					     (setq workingselnum sselnum)
					     (setq names rmstatelist)
		      (dbox)					     
		      (setq rmstate returntype)
					     (setq sselnum workingselnum)
					     )
    )
  (setq rmornot "")
  (if (or (= rmstate "Gone") (= rmstate "Not Found"))(progn
						       (setq rmornot (getstring "\nWhat is gone/not found - the corner (C) or RM (R):"))
						       (if (or (= rmornot "c")(= rmornot "cnr")(= rmornot "CNR")(= rmornot "corner")(= rmornot "CONRNER")(= rmornot "corner")) (setq rmornot ""))
						       (if  (or (= rmornot "rm")(= rmornot "RM")(= rmornot "r")(= rmornot "R")) (setq rmornot " RM"))
						       )
    )
						    


  
  ;)
  ;);if type None


  (if (/= rmstate "Placed")(progn
   (setq rmrefdp (getstring T(strcat "\nReference DP number (default is nil)[Last-"lrmrefdp"]:")))
   
   (if (or (= rmrefdp "LAST")(= rmrefdp "Last")(= rmrefdp "L")(= rmrefdp "l")(= rmrefdp "last"))(setq rmrefdp lrmrefdp))
   (setq lrmrefdp rmrefdp)
  (if (= (substr rmrefdp 1 2) "dp") (setq rmrefdp (strcat "DP" ( substr rmrefdp 3 50))))
  (if (= (substr rmrefdp 1 2) "cp") (setq rmrefdp (strcat "CP" ( substr rmrefdp 3 50))))
    (if (and (>= (ascii (substr rmrefdp 1 1)) 48)(<= (ascii (substr rmrefdp 1 1)) 57))(setq rmrefdp (strcat "DP" rmrefdp)));will add dp if you enter only the number
   )
    (setq rmrefdp "")
    )
   

  


  (SETVAR "CLAYER"  "Monument" )
  (if (= rmtype "Occupation")(setvar "clayer" "Occupations"))
  
  (COMMAND "POINT" P1)

  ;check for no values and replace with "none"
  (if (= rmrefdp "")(setq rmrefdp "none"))
  ;(if (= rmcondition "")(setq rmcondition "none"))
  (if (= rmrefdp "")(setq rmrefdp "none"))
  (if (/= rmtype "")(setq ormtype (strcat "type=\"" rmtype "\""))(setq ormtype ""))
 
(if (and (= rmcomment "") (= rmornot " RM")) (setq rmornot "RM"));remove space when there is no comment
   (if (or (/= rmcomment "") (/= rmornot ""))(setq ormcomment (strcat " desc=\"" rmcomment rmornot "\""))(setq ormcomment ""))
  ; (if (/= rmcondition "none")(setq ormcondition (strcat " condition=\"" rmcondition "\""))
  (setq ormcondition "")
   (if (/= rmrefdp "none")(setq ormrefdp (strcat " originSurvey=\"" rmrefdp "\""))(setq ormrefdp ""))

  (if (and (= rmcomment "") (= rmornot "RM")) (setq rmornot " RM"));readd space when there is no comment
  
    (SETQ PTINFO (STRCAT  ormtype " state=\""  rmstate "\"" ormcondition  ormrefdp  ormcomment " />" ));Note comment for desc in xml added to distance entry seperated by a space
(SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 PTINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)

  

    (lcm)
 


  (setvar "clayer" prevlayer )
)





;----------------------------------------------------------------CREATE PM--------------------------------------------

(defun C:XPM (/)
   (setq prevlayer (getvar "CLAYER"))

  (setq pmpos (getpoint "\nSelect PM/SSM position:"))
  (setq pminfo (getstring T "\nPM information in Format Number,Easting,Northing,Class,P.Uncert/Order,Date,fixsouce(From SCIMS/ Cadastal Traverse),datum(MGA2020/ISG),state(Found/Placed)\n:"))
  


		 
      (setq ,pos1 (vl-string-position 44 pminfo 0))
      (setq ,pos2 (vl-string-position 44 pminfo (+ ,pos1 1)))
      (setq ,pos3 (vl-string-position 44 pminfo (+ ,pos2 1)))
      (setq ,pos4 (vl-string-position 44 pminfo (+ ,pos3 1)))
      (setq ,pos5 (vl-string-position 44 pminfo (+ ,pos4 1)))
      (setq ,pos6 (vl-string-position 44 pminfo (+ ,pos5 1)))
      (setq ,pos7 (vl-string-position 44 pminfo (+ ,pos6 1)))
      (setq ,pos8 (vl-string-position 44 pminfo (+ ,pos7 1)))

		 
      (setq pmnum (substr pminfo 1 ,pos1))
      (setq pmeast (substr pminfo (+ ,pos1 2) (- (- ,pos2 ,pos1) 1)))
      (setq pmnorth (substr pminfo (+ ,pos2 2) (- (- ,pos3 ,pos2) 1)))
      (setq pmclass (substr pminfo (+ ,pos3 2) (- (- ,pos4 ,pos3) 1)))
      (setq pmorder (substr pminfo (+ ,pos4 2) (- (- ,pos5 ,pos4) 1)))
      (setq pmdate (substr pminfo (+ ,pos5 2) (- (- ,pos6 ,pos5) 1)))
      (setq pmsource (substr pminfo (+ ,pos6 2) (- (- ,pos7 ,pos6) 1)))
      (setq pmdatum (substr pminfo (+ ,pos7 2) (- (- ,pos8 ,pos7) 1)))
      (setq pmstate (substr pminfo (+ ,pos8 2) 50))

  (setq pmdateo pmdate)

  ;sort date entrys

  ;replace /,\,. with -
  (setq /pos 0)
	      (while (/=  (setq /pos (vl-string-search "/" pmdate /pos )) nil) (setq pmdate (vl-string-subst "-" "/"  pmdate /pos)
										      /pos (+ /pos 1)))
(setq /pos 0)
	      (while (/=  (setq /pos (vl-string-search "\\" pmdate /pos )) nil) (setq pmdate (vl-string-subst "-" "\\"  pmdate /pos)
										      /pos (+ /pos 1)))
  (setq /pos 0)
	      (while (/=  (setq /pos (vl-string-search "." pmdate /pos )) nil) (setq pmdate (vl-string-subst "-" "."  pmdate /pos)
										      /pos (+ /pos 1)))
  (setq pmdateo pmdate)
  
  (setq minuspos1 (vl-string-position 45 pmdate 0))
  (setq minuspos2 (vl-string-position 45 pmdate (+ minuspos1 1)))
  (if (or (= minuspos1 1)(= minuspos1 2))(progn;rearrage date
				       (setq day  (substr pmdate 1 minuspos1))
				       (if (= (strlen day) 1) (setq day (strcat "0" day)));single digit days
				       (setq month (substr pmdate (+ minuspos1 2) (- (- minuspos2 minuspos1) 1)))
				       (if (= (strlen month) 1) (setq month (strcat "0" month)));single digit days
				       (setq year  (substr pmdate (+ minuspos2 2) 50))
				       (setq pmdate (strcat year "-" month "-" day))
				       ));p&if dos round the wrong way

		 (SETVAR "CLAYER"  "PM" )
		 
     (COMMAND "POINT" pmpos)

  (if (and (= (substr pmnum 1 2) "SS")(/= (substr pmnum 1 3) "SSM"))(setq pmnum (strcat "SSM" (substr pMnum 3 50))));fix ss if accidentally entered
  


  (if (/= pmdatum "MGA2020")
    (setq ordertype "\" order=\""
	  orders "ORDER")
    (setq ordertype "\"  positionalUncertainty=\""
	  orders "PU")
    )
  (if (or (= pmorder "NA")(= pmorder "N/A"))(setq pmordero ""
			    ordertype "")
    (setq pmordero pmorder)
    )
    
    
  
  
  
  
  
		 (SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  ;state added to end of xml
(SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 (strcat pmnum ",latitude=\"" pmnorth "\" longitude=\"" pmeast "\" class=\"" pmclass ordertype pmordero "\" horizontalFix=\"" pmsource "\" horizontalDatum=\"" pmdatum "\" currencyDate=\"" pmdate "\"/>!"pmstate))))));@@@@change to xml format
  (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)


		 (SETVAR "CLAYER"  "Drafting" )
  (COMMAND "._INSERT" "PM" "_S" TH pmpos "0");changed for BricsCAD 
;  (SETQ RMB (ENTLAST))
;  (SETQ ENTSS (SSADD))
;  (SSADD RMB ENTSS)
;(COMMAND "DRAWORDER" ENTSS "" "FRONT")
(SETQ TEXTPOS (LIST (+ (CAR PMPOS) TH) (+ (CADR PMPOS) (* 0.5 TH))))

  (IF (= pmstate "Found")  (SETQ PMNUMS (STRCAT PMNUM " FD")))
  (IF (= pmstate "Placed")  (SETQ PMNUMS (STRCAT PMNUM " PL")))
		 (COMMAND "TEXT" "J" "BL"  TEXTPOS (* TH 1.4) "90" PMNUMS)
  (SETQ TEXTPOS (LIST (+ (CAR PMPOS) TH) (+ (CADR PMPOS) (* -1.25 TH))))
  (IF (and (/= pmclass "U") (or (= pmsource "SCIMS" )(= pmsource "From SCIMS")))(COMMAND "TEXT" "J" "BL"  TEXTPOS (* TH 1.4) "90" "(EST)"))
  
  

  (if (= pmboxmark nil)(progn


			 ;get metadata from admin sheet if it exsits
			 
(IF (/= (setq adminsheet (ssget "_X" '((0 . "INSERT") (2 . "PLANFORM6")))) nil)(progn
		(SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME ADMINSHEET 0)))))								

		(setq count 1)
  (SETQ ATTLIST (LIST))
	    
(setq Obj (vlax-ename->vla-object En))
	(foreach x (vlax-invoke Obj 'GetAttributes)
	  (SETQ ATT (vla-get-textstring X))
	  (if (= att "none") (setq att ""))

	  (setq &pos 0)
	   (while (/=  (setq &pos (vl-string-search "&" att &pos )) nil) (setq att (vl-string-subst "&amp;" "&"  att &pos)
										      &pos (+ &pos 4)))
	 	  	  
	  (setq crlfpos 0)
	   (while (/=  (setq crlfpos (vl-string-search "\\P" att crlfpos )) nil) (setq att (vl-string-subst "&#xA;" "\\P"  att crlfpos)
										      crlfpos (+ crlfpos 5)))


	  (setq attlist (append attlist (list att)))
(setq zone (nth 22 attlist ))
	  )
	
	      
  ));P&IF ADMINSHEET EXISTS

(if (or (= attlist nil)(= zone ""))(progn
(setq zone (getstring "\nZone:" ))

))

    ;12.get PM connection lines
  
(IF (/= (setq bdyline (ssget "_X" '((0 . "LINE") (8 . "PM Connection")))) nil)(progn 
  (setq count 0)
  (setq daf "")
  (repeat (sslength bdyline)
 
  (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME bdyline COUNT)))))

    	    (SETQ XDATAI (ENTGET EN '("LANDXML")))
	    (IF (= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL) (progn
	      	     (COMMAND "CHANGE" en "" "P" "C" "6" "")
	      (princ (strcat "\nPM Connection Line with no XML data at " (rtos (car p1) 2 3) "," (rtos (cadr p1)2 3)))
	     ))
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))
    
 (if (/= (setq stringpos (vl-string-search "distanceAdoptionFactor" xdatai )) nil)(progn
	    (setq wwpos (vl-string-position 34 xdatai (+ stringpos 24)))
            (setq daf (substr xdatai (+ stringpos 25) (-(- wwpos 1)(+ stringpos 23))))))
    
   
    (setq count (+ count 1))
    );r
  );p
 
  );if

(if (or (= daf "")(= daf nil))(setq daf (getstring "\nCombined Scale Factor:")))







			 
			 (setq pmboxmark (getpoint "\nSelect Point for PM notation box:"))
			 (setq p10 (list (+ (car pmboxmark) (* 97 th))(+ (cadr pmboxmark) (* -2.5 th))))
			 (setq p11 (list (+ (car pmboxmark) 0)(+ (cadr pmboxmark) (* -2.5 th))))
			 (setq p12 (list (+ (car pmboxmark) (* th 48.5))(+ (cadr pmboxmark) (* -1.25 th))))
			 (command "rectangle" pmboxmark p10)
			 (command "text" "j" "mc" p12 th "90" "COORDINATE SCHEDULE")
			 (setq pmboxmark p11)
                         (setq p10 (list (+ (car pmboxmark) (* 97 th))(+ (cadr pmboxmark) (* -2.5 th))))
			 (setq p11 (list (+ (car pmboxmark) 0)(+ (cadr pmboxmark) (* -2.5 th))))
			 (setq p12 (list (+ (car pmboxmark) (* th 48.5))(+ (cadr pmboxmark) (* -1.25 th))))
			 (command "rectangle" pmboxmark p10)
			 (command "text" "j" "mc" p12 th "90" (strcat pmdatum " COORDINATES ZONE " zone " CSF: " daf))
			 (setq pmboxmark p11)
			 ;box corners
			 (setq p10 (list (+ (car pmboxmark) 0)(+ (cadr pmboxmark) (* -2.5 th))))
			 (setq p11 (list (+ (car pmboxmark) (* 12 th))(+ (cadr pmboxmark)  0 )))
			 (setq p12 (list (+ (car pmboxmark) (* 25 th))(+ (cadr pmboxmark) (* -2.5 th))))
			 (setq p13 (list (+ (car pmboxmark) (* 39 th))(+ (cadr pmboxmark)  0 )))
			 (setq p14 (list (+ (car pmboxmark) (* 45 th))(+ (cadr pmboxmark) (* -2.5 th))))
			 (setq p15 (list (+ (car pmboxmark) (* 51 th))(+ (cadr pmboxmark)  0 )))
			 (setq p16 (list (+ (car pmboxmark) (* 69 th))(+ (cadr pmboxmark) (* -2.5 th))))
			 (setq p17 (list (+ (car pmboxmark) (* 77 th))(+ (cadr pmboxmark)  0 )))
			 (setq p18 (list (+ (car pmboxmark) (* 87 th))(+ (cadr pmboxmark) (* -2.5 th))))
                         (setq p19 (list (+ (car pmboxmark) (* 97 th))(+ (cadr pmboxmark) 0)))
			 
			 ;draw boxes
			 (command "rectangle" p10 p11)
			 (command "rectangle" p11 p12)
			 (command "rectangle" p12 p13)
			 (command "rectangle" p13 p14)
			 (command "rectangle" p14 p15)
			 (command "rectangle" p15 p16)
			 (command "rectangle" p16 p17)
			 (command "rectangle" p17 p18)
                         (command "rectangle" p18 p19)


			 
			 ;text insertion points
			 (setq p20 (list (+ (car pmboxmark) (* 6 th))(+ (cadr pmboxmark)  (* -1.25 th ))))
			 (setq p21 (list (+ (car pmboxmark) (* 18.5 th))(+ (cadr pmboxmark)  (* -1.25 th ))))
			 (setq p22 (list (+ (car pmboxmark) (* 32 th))(+ (cadr pmboxmark)  (* -1.25 th ))))
			 (setq p23 (list (+ (car pmboxmark) (* 42 th))(+ (cadr pmboxmark)  (* -1.25 th ))))
			 (setq p24 (list (+ (car pmboxmark) (* 48 th))(+ (cadr pmboxmark)  (* -1.25 th ))))
			 (setq p25 (list (+ (car pmboxmark) (* 60 th))(+ (cadr pmboxmark)  (* -1.25 th ))))
			 (setq p26 (list (+ (car pmboxmark) (* 73 th))(+ (cadr pmboxmark)  (* -1.25 th ))))
			 (setq p27 (list (+ (car pmboxmark) (* 82 th))(+ (cadr pmboxmark)  (* -1.25 th ))))
                         (setq p28 (list (+ (car pmboxmark) (* 92 th))(+ (cadr pmboxmark)  (* -1.25 th ))))
			 
			 ;create text
			 (command "text" "j" "mc" p20 th "90" "MARK")
			 (command "text" "j" "mc" p21 th "90" "EAST")
			 (command "text" "j" "mc" p22 th "90" "NORTH")
			 (command "text" "j" "mc" p23 th "90" "CLASS")
			 (command "text" "j" "mc" p24 th "90" orders)
			 (command "text" "j" "mc" p25 th "90" "METHOD")
			 (command "text" "j" "mc" p26 th "90" "DATUM")
			 (command "text" "j" "mc" p27 th "90" "DATE")
                         (command "text" "j" "mc" p28 th "90" "STATE")
			 ;reset pm box mark point
			 (setq pmboxmark p10)
			 ));p&if no boxmark


  
  			;box corners
                         (setq p10 (list (+ (car pmboxmark) 0)(+ (cadr pmboxmark) (* -2.5 th))))
			 (setq p11 (list (+ (car pmboxmark) (* 12 th))(+ (cadr pmboxmark)  0 )))
			 (setq p12 (list (+ (car pmboxmark) (* 25 th))(+ (cadr pmboxmark) (* -2.5 th))))
			 (setq p13 (list (+ (car pmboxmark) (* 39 th))(+ (cadr pmboxmark)  0 )))
			 (setq p14 (list (+ (car pmboxmark) (* 45 th))(+ (cadr pmboxmark) (* -2.5 th))))
			 (setq p15 (list (+ (car pmboxmark) (* 51 th))(+ (cadr pmboxmark)  0 )))
			 (setq p16 (list (+ (car pmboxmark) (* 69 th))(+ (cadr pmboxmark) (* -2.5 th))))
			 (setq p17 (list (+ (car pmboxmark) (* 77 th))(+ (cadr pmboxmark)  0 )))
			 (setq p18 (list (+ (car pmboxmark) (* 87 th))(+ (cadr pmboxmark) (* -2.5 th))))
                         (setq p19 (list (+ (car pmboxmark) (* 97 th))(+ (cadr pmboxmark) 0)))
			 
			 ;draw boxes
			 (command "rectangle" p10 p11)
			 (command "rectangle" p11 p12)
			 (command "rectangle" p12 p13)
			 (command "rectangle" p13 p14)
			 (command "rectangle" p14 p15)
			 (command "rectangle" p15 p16)
			 (command "rectangle" p16 p17)
			 (command "rectangle" p17 p18)
                         (command "rectangle" p18 p19)
			 
			 ;text insertion points
			 (setq p20 (list (+ (car pmboxmark) (* 6 th))(+ (cadr pmboxmark)  (* -1.25 th ))))
			 (setq p21 (list (+ (car pmboxmark) (* 18.5 th))(+ (cadr pmboxmark)  (* -1.25 th ))))
			 (setq p22 (list (+ (car pmboxmark) (* 32 th))(+ (cadr pmboxmark)  (* -1.25 th ))))
			 (setq p23 (list (+ (car pmboxmark) (* 42 th))(+ (cadr pmboxmark)  (* -1.25 th ))))
			 (setq p24 (list (+ (car pmboxmark) (* 48 th))(+ (cadr pmboxmark)  (* -1.25 th ))))
			 (setq p25 (list (+ (car pmboxmark) (* 60 th))(+ (cadr pmboxmark)  (* -1.25 th ))))
			 (setq p26 (list (+ (car pmboxmark) (* 73 th))(+ (cadr pmboxmark)  (* -1.25 th ))))
			 (setq p27 (list (+ (car pmboxmark) (* 82 th))(+ (cadr pmboxmark)  (* -1.25 th ))))
                         (setq p28 (list (+ (car pmboxmark) (* 92 th))(+ (cadr pmboxmark)  (* -1.25 th ))))
			 
			 ;create text
			 (command "text" "j" "mc" p20 th "90" pmnum)
			 (command "text" "j" "mc" p21 th "90" pmeast)
			 (command "text" "j" "mc" p22 th "90" pmnorth)
			 (command "text" "j" "mc" p23 th "90" pmclass)
			 (command "text" "j" "mc" p24 th "90" pmorder)
			 (command "text" "j" "mc" p25 th "90" pmsource)
			 (command "text" "j" "mc" p26 th "90" pmdatum)
			 (command "text" "j" "mc" p27 th "90" pmdateo)
  			 (command "text" "j" "mc" p28 th "90" pmstate)
  
			 ;reset pm box mark point
			 (setq pmboxmark p10)



  ;create pm as monument
;  (SETVAR "CLAYER" "Monument" )
;  (COMMAND "POINT" PMPOS)

  ;check for no values and replace with "none"
    
;    (if (= (substr pmnum 1 2) "PM")(setq ormtype ( strcat "type=\"PM\" ")))
;  (if (= (substr pmnum 1 2) "TS")(setq ormtype ( strcat "type=\"TS\" ")))
;  (if (= (substr pmnum 1 2) "MM")(setq ormtype ( strcat "type=\"MM\" ")))
;  (if (= (substr pmnum 1 2) "GB")(setq ormtype ( strcat "type=\"GB\" ")))
;  (if (= (substr pmnum 1 2) "CP")(setq ormtype ( strcat "type=\"CP\" ")))
;  (if (= (substr pmnum 1 2) "CR")(setq ormtype ( strcat "type=\"CR\" ")))
;  (if (= (substr pmnum 1 3) "SSM")(setq ormtype ( strcat "type=\"SSM\" ")))
  


 ;   (SETQ PTINFO (STRCAT ormtype "state=\"Found\">" ));Note comment for desc in xml added to distance entry seperated by a space
;(SETQ SENT (ENTLAST))
;  (SETQ SENTLIST (ENTGET SENT))
;  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 PTINFO)))))
;   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
;  (ENTMOD NEWSENTLIST)

  (setvar "clayer" prevlayer)

  
  )



;----------------------------------------------------------------CREATE BM--------------------------------------------

(defun C:XBM (/)
   (setq prevlayer (getvar "CLAYER"))

  (setq pmlist (list))
   (princ "\nGathering PM point for comparison")
(IF (/= (setq bdyline (ssget "_X" '((0 . "POINT") (8 . "PM")))) nil)(progn 
  (setq count 0)
  (repeat (sslength bdyline)


(SETQ P1 (CDR(ASSOC 10 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME bdyline COUNT)))))
    (SETQ ZA (CDR (ASSOC 210 (ENTGET (SSNAME bdyline COUNT)))))
    (SETQ P1 (TRANS P1 ZA 0))
    (setq PMlist (append pmlist (list (strcat (rtos (car p1) 2 6) " " (rtos (cadr p1) 2 6)))))
    (setq count (+ count 1))
    )
  ));if PM points exist

  (setq pmpos (getpoint "\nSelect BM position:"))
  (setq pminfo (getstring T "\nBM information in Format Number,Height,Class,Order,Punc,datum(MGA/ISG),state(Found/Placed),Validation,Date\n:"))
  


		 
      (setq ,pos1 (vl-string-position 44 pminfo 0))
      (setq ,pos2 (vl-string-position 44 pminfo (+ ,pos1 1)))
      (setq ,pos3 (vl-string-position 44 pminfo (+ ,pos2 1)))
      (setq ,pos4 (vl-string-position 44 pminfo (+ ,pos3 1)))
      (setq ,pos5 (vl-string-position 44 pminfo (+ ,pos4 1)))
      (setq ,pos6 (vl-string-position 44 pminfo (+ ,pos5 1)))
      (setq ,pos7 (vl-string-position 44 pminfo (+ ,pos6 1)))
      (setq ,pos8 (vl-string-position 44 pminfo (+ ,pos7 1)))
      

		 
      (setq pmnum (substr pminfo 1 ,pos1))
      (setq pmheight (substr pminfo (+ ,pos1 2) (- (- ,pos2 ,pos1) 1)))
      (setq pmclass (substr pminfo (+ ,pos2 2) (- (- ,pos3 ,pos2) 1)))
      (setq pmorder (substr pminfo (+ ,pos3 2) (- (- ,pos4 ,pos3) 1)))
      (setq punc    (substr pminfo (+ ,pos4 2) (- (- ,pos5 ,pos4) 1)))
      (setq pmdatum (substr pminfo (+ ,pos5 2) (- (- ,pos6 ,pos5) 1)))
      (setq pmstate (substr pminfo (+ ,pos6 2) (- (- ,pos7 ,pos6) 1)))
      (setq pmvalid (substr pminfo (+ ,pos7 2) (- (- ,pos8 ,pos7) 1)))
      (setq pmdate (substr pminfo (+ ,pos8 2) 500))

  

  ;sort date entrys

  ;replace /,\,. with -
  (setq /pos 0)
	      (while (/=  (setq /pos (vl-string-search "/" pmdate /pos )) nil) (setq pmdate (vl-string-subst "-" "/"  pmdate /pos)
										      /pos (+ /pos 1)))
(setq /pos 0)
	      (while (/=  (setq /pos (vl-string-search "\\" pmdate /pos )) nil) (setq pmdate (vl-string-subst "-" "\\"  pmdate /pos)
										      /pos (+ /pos 1)))
  (setq /pos 0)
	      (while (/=  (setq /pos (vl-string-search "." pmdate /pos )) nil) (setq pmdate (vl-string-subst "-" "."  pmdate /pos)
										      /pos (+ /pos 1)))
  (setq pmdateo pmdate)

  (if (/= pmdate "")
    (progn
  
  (setq minuspos1 (vl-string-position 45 pmdate 0))
  (setq minuspos2 (vl-string-position 45 pmdate (+ minuspos1 1)))
  (if (or (= minuspos1 1)(= minuspos1 2))(progn;rearrage date
				       (setq day  (substr pmdate 1 minuspos1))
				       (if (= (strlen day) 1) (setq day (strcat "0" day)));single digit days
				       (setq month (substr pmdate (+ minuspos1 2) (- (- minuspos2 minuspos1) 1)))
				       (if (= (strlen month) 1) (setq month (strcat "0" month)));single digit days
				       (setq year  (substr pmdate (+ minuspos2 2) 50))
				       (setq pmdate (strcat year "-" month "-" day))
				       ));p&if dos round the wrong way
  ))

		 (SETVAR "CLAYER"  "PM" )
		 
     (COMMAND "POINT" pmpos)

  (if (and (= (substr pmnum 1 2) "SS")(/= (substr pmnum 1 3) "SSM"))(setq pmnum (strcat "SSM" (substr pMnum 3 50))));fix ss if accidentally entered
  


  (if (/= pmorder "")
    (setq ordertype "\"  order=\""
	  ordero pmorder)
    (setq ordertype "\"  positionalUncertainty=\""
	  ordero punc)
    )

  ;deal with N/A non xml recorder
  (if (= punc "N/A")(setq ordero ""
			    ordertype "")
    
    )

  (if (/= pmdate "")(setq pmdates (strcat "\" date=\"" pmdate))(setq pmdates ""))
  (if (/= pmvalid "")(setq pmvalids (strcat "\" verticalFix=\"" pmvalid))(setq pmvalids ""))
  
  
		 (SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  ;state added to end of xml
(SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 (strcat pmnum ",height=\"" pmheight "\" class=\"" pmclass ordertype ordero  "\" verticalDatum=\"" pmdatum
							      pmvalids pmdates  "\"/>!"pmstate))))));@@@@change to xml format
  (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)

(if (= (member (strcat (rtos (car pmpos) 2 6) " " (rtos (cadr pmpos) 2 6)) pmlist) nil)
  (progn
		 (SETVAR "CLAYER"  "Drafting" )
  (COMMAND "._INSERT" "BM" "_S" TH pmpos "0")
;  (SETQ RMB (ENTLAST))
;  (SETQ ENTSS (SSADD))
;  (SSADD RMB ENTSS)
;(COMMAND "DRAWORDER" ENTSS "" "FRONT")
(SETQ TEXTPOS (LIST (+ (CAR PMPOS) TH) (+ (CADR PMPOS) (* 0.5 TH))))

  (IF (= pmstate "Found")  (SETQ PMNUMS (STRCAT PMNUM " FD")))
  (IF (= pmstate "Placed")  (SETQ PMNUMS (STRCAT PMNUM " PL")))
		 (COMMAND "TEXT" "J" "BL"  TEXTPOS (* TH 1.4) "90" PMNUMS)
));p&if not a exsiting PM

  (if (= pmvalid "null") (setq pmvalid ""))
  (if (= bmboxmark nil)(progn

			 
			 (setq bmboxmark (getpoint "\nSelect Point for BM notation box:"))
			 (setq p10 (list (+ (car bmboxmark) (* 76 th))(+ (cadr bmboxmark) (* -5 th))))
			 (setq p11 (list (+ (car bmboxmark) 0)(+ (cadr bmboxmark) (* -5 th))))
			 (setq p12 (list (+ (car bmboxmark) (* th 38))(+ (cadr bmboxmark) (* -1.25 th))))
			 (setq p13 (list (+ (car bmboxmark) (* th 38))(+ (cadr bmboxmark) (* -3.75 th))))
			 (command "rectangle" bmboxmark p10)
			 (command "text" "j" "mc" p12 th "90" "HEIGHT SCHEDULLE")
			 (command "text" "j" "mc" p13 th "90" "HEIGHT DATUM: AHD71")
			 (setq bmboxmark p11)
                         
			 ;box corners
			 (setq p10 (list (+ (car bmboxmark) 0)(+ (cadr bmboxmark) (* -2.5 th))))
			 (setq p11 (list (+ (car bmboxmark) (* 12 th))(+ (cadr bmboxmark)  0 )))
			 (setq p12 (list (+ (car bmboxmark) (* 20 th))(+ (cadr bmboxmark) (* -2.5 th))))
			 (setq p13 (list (+ (car bmboxmark) (* 26 th))(+ (cadr bmboxmark)  0 )))
			 (setq p14 (list (+ (car bmboxmark) (* 32 th))(+ (cadr bmboxmark) (* -2.5 th))))
			 (setq p15 (list (+ (car bmboxmark) (* 59 th))(+ (cadr bmboxmark)  0 )))
			 (setq p16 (list (+ (car bmboxmark) (* 68 th))(+ (cadr bmboxmark) (* -2.5 th))))
			 (setq p17 (list (+ (car bmboxmark) (* 76 th))(+ (cadr bmboxmark)  0 )))
			 
			 ;draw boxes
			 (command "rectangle" p10 p11)
			 (command "rectangle" p11 p12)
			 (command "rectangle" p12 p13)
			 (command "rectangle" p13 p14)
			 (command "rectangle" p14 p15)
			 (command "rectangle" p15 p16)
			 (command "rectangle" p16 p17)
			 
			 ;text insertion points
			 (setq p20 (list (+ (car bmboxmark) (* 6 th))(+ (cadr bmboxmark)  (* -1.25 th ))))
			 (setq p21 (list (+ (car bmboxmark) (* 16 th))(+ (cadr bmboxmark)  (* -1.25 th ))))
			 (setq p22 (list (+ (car bmboxmark) (* 23 th))(+ (cadr bmboxmark)  (* -1.25 th ))))
			 (setq p23 (list (+ (car bmboxmark) (* 29 th))(+ (cadr bmboxmark)  (* -1.25 th ))))
			 (setq p24 (list (+ (car bmboxmark) (* 45.5 th))(+ (cadr bmboxmark)  (* -1.25 th ))))
			 (setq p25 (list (+ (car bmboxmark) (* 63.5 th))(+ (cadr bmboxmark)  (* -1.25 th ))))
			 (setq p26 (list (+ (car bmboxmark) (* 72 th))(+ (cadr bmboxmark)  (* -1.25 th ))))
			 
			 ;create text
			 (command "text" "j" "mc" p20 th "90" "MARK")
			 (command "text" "j" "mc" p21 th "90" "HEIGHT")
			 (command "text" "j" "mc" p22 th "90" "CLASS")
			 (if (/= pmorder "")(command "text" "j" "mc" p23 th "90" "ORDER"))
			 (if (/= punc "")(command "text" "j" "mc" p23 th "90" "PU"))
			 (command "text" "j" "mc" p24 th "90" "HEIGHT DATUM VALIDATION")
			 (command "text" "j" "mc" p25 th "90" "STATE")
			 (command "text" "j" "mc" p26 th "90" "DATE")
			 ;reset pm box mark point
			 (setq bmboxmark p10)
			 ));p&if no boxmark


  
  			;box corners
			 (setq p10 (list (+ (car bmboxmark) 0)(+ (cadr bmboxmark) (* -2.5 th))))
			 (setq p11 (list (+ (car bmboxmark) (* 12 th))(+ (cadr bmboxmark)  0 )))
			 (setq p12 (list (+ (car bmboxmark) (* 20 th))(+ (cadr bmboxmark) (* -2.5 th))))
			 (setq p13 (list (+ (car bmboxmark) (* 26 th))(+ (cadr bmboxmark)  0 )))
			 (setq p14 (list (+ (car bmboxmark) (* 32 th))(+ (cadr bmboxmark) (* -2.5 th))))
			 (setq p15 (list (+ (car bmboxmark) (* 59 th))(+ (cadr bmboxmark)  0 )))
			 (setq p16 (list (+ (car bmboxmark) (* 68 th))(+ (cadr bmboxmark) (* -2.5 th))))
                         (setq p17 (list (+ (car bmboxmark) (* 76 th))(+ (cadr bmboxmark)  0 )))
			 
			 ;draw boxes
			 (command "rectangle" p10 p11)
			 (command "rectangle" p11 p12)
			 (command "rectangle" p12 p13)
			 (command "rectangle" p13 p14)
			 (command "rectangle" p14 p15)
                         (command "rectangle" p15 p16)
                         (command "rectangle" p16 p17)
			 
			 ;text insertion points
			 (setq p20 (list (+ (car bmboxmark) (* 6 th))(+ (cadr bmboxmark)  (* -1.25 th ))))
			 (setq p21 (list (+ (car bmboxmark) (* 16 th))(+ (cadr bmboxmark)  (* -1.25 th ))))
			 (setq p22 (list (+ (car bmboxmark) (* 23 th))(+ (cadr bmboxmark)  (* -1.25 th ))))
			 (setq p23 (list (+ (car bmboxmark) (* 29 th))(+ (cadr bmboxmark)  (* -1.25 th ))))
			 (setq p24 (list (+ (car bmboxmark) (* 45.5 th))(+ (cadr bmboxmark)  (* -1.25 th ))))
                         (setq p25 (list (+ (car bmboxmark) (* 63.5 th))(+ (cadr bmboxmark)  (* -1.25 th ))))
                         (setq p26 (list (+ (car bmboxmark) (* 72 th))(+ (cadr bmboxmark)  (* -1.25 th ))))
			 
			 ;create text
			 (command "text" "j" "mc" p20 th "90" pmnum)
			 (command "text" "j" "mc" p21 th "90" pmheight)
			 (command "text" "j" "mc" p22 th "90" pmclass)
			 (if (/= pmorder "")(command "text" "j" "mc" p23 th "90" pmorder))
                         (if (/= punc "")(command "text" "j" "mc" p23 th "90" punc))
                         (if (= pmvalid "Null")(setq pmvalid ""))
			 (command "text" "j" "mc" p24 th "90" (strcase pmvalid))
                         (command "text" "j" "mc" p25 th "90" (strcase pmstate))
                         (command "text" "j" "mc" p26 th "90" pmdateo)
  
			 ;reset pm box mark point
			 (setq bmboxmark p10)



  (setvar "clayer" prevlayer)

  
  )


;-------------------------------------------------------------------Add Combined Scale Factor to Line-------------


(defun C:XSF (/)
  

(PRINC "\n Select Lines to Apply Scale Factor to:")
  
  
  (setq bdyline (ssget  '((0 . "LINE") (8 . "PM Connection,Height Difference"))))
  (setq csf (getstring "\nCombined Scale Factor:"))
  (setq count 0)
  (repeat (sslength bdyline)
  (SETQ P1 (CDR(ASSOC 10 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME bdyline COUNT)))))

    	    (SETQ XDATAI (ENTGET EN '("LANDXML")))
	    (IF (= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL) (progn
	      	     (COMMAND "CHANGE" en "" "P" "C" "6" "")
	      (princ (strcat "\nObject has not xdata " (rtos (car p1) 2 3) "," (rtos (cadr p1)2 3)))
	     ))
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))



    (if (/= (setq stringpos (vl-string-search "distanceAdoptionFactor" xdatai )) nil)(progn
(setq wwpos (vl-string-position 34 xdatai (+ stringpos 24)))
(setq stringpos1 (- stringpos 1)
       stringpos2 (+ wwpos 2) )
);p
      
(progn

 ;else
;serach for first >
  
  (setq stringpos1  (+ (vl-string-search ">" xdatai 1) 1))
  (if (= (substr xdatai (- stringpos1 1) 1) "/") (setq stringpos1 (- stringpos1 2))(setq stringpos1 (- stringpos1 1)))
         
  (setq stringpos2 (+ stringpos1 1)
	)
  )
      )
  
    
(setq xdatafront (substr xdatai 1  stringpos1 ))
    (setq xdataback (substr xdatai stringpos2 1000))
    (setq xdatai (strcat xdatafront " distanceAdoptionFactor=\"" csf "\"" xdataback))

    (SETQ SENTLIST (ENTGET EN))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 xdatai)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)

    (setq count (+ count 1))
    )
  )





;-------------------------------------------------------------------Add note to lines-------------


(defun C:XAN (/)
  

(PRINC "\n Select Lines to Apply Note to:")
  
  
  (setq bdyline (ssget  '((0 . "LINE,ARC") (8 . "Boundary,Connection,Road,Easement,Road Extent,PM Connection"))))
  (setq comment (getstring "\nNote:" T))
  (setq count 0)
  (repeat (sslength bdyline)
  (SETQ P1 (CDR(ASSOC 10 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME bdyline COUNT)))))

    	    (SETQ XDATAI (ENTGET EN '("LANDXML")))
	    (IF (= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL) (progn
	      	     (COMMAND "CHANGE" en "" "P" "C" "6" "")
	      (princ (strcat "\nObject has not xdata " (rtos (car p1) 2 3) "," (rtos (cadr p1)2 3)))
	     ))
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))


;search for normal
    (if (/= (setq stringpos (vl-string-search "/>" xdatai )) nil)
      (progn
	(setq front (substr xdatai 1 stringpos))
	);p
      (progn
	;else fieldontes already exist
	(setq stringpos (vl-string-search ">" xdatai ))
	(setq front (substr xdatai 1 stringpos))
	)
  )
      
  
    

    (setq xdatai (strcat front "><FieldNote>\"" comment  "\"</FieldNote></ReducedObservation>"))

    (SETQ SENTLIST (ENTGET EN))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 xdatai)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)

    (setq count (+ count 1))
    )
  );defun


;-------------------------------------------------------------------Add Height differnce to Line-------------


(defun C:XHD (/)
  
  (SETQ P1PM "")
  (SETQ P2PM "")
  
  (setq bdyline (car (entsel  "\n Select Line for height difference:" )))
  (setq HD (getstring "\nHeight Difference:"))
  (setq hdt (getstring (strcat "\Type of levelling [" phdt "]:") T))
(if (= hdt "")(setq hdt phdt))
(setq phdt hdt)
  
  
  (SETQ P1 (CDR(ASSOC 10 (ENTGET  bdyline ))))
  (SETQ P2 (CDR(ASSOC 11 (ENTGET  bdyline ))))
  (SETQ EN (CDR(ASSOC -1 (ENTGET  bdyline ))))

    	    (SETQ XDATAI (ENTGET EN '("LANDXML")))
	    (IF (= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL) (progn ;if no xdata on line create height difference line
	      	     (command "change" en "" "p" "la" "Height Difference" "")
	      (princ "\nObject has no xdata, assigning to Height Difference" )
		     	(SETQ BDINFO (STRCAT "vertDistance=\"" HD "\" MSLDistance=\"" hdt "\" />"))
   (SETQ SENTLIST (ENTGET EN))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 BDINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)
		     
	     )
	      (PROGN ;else add it to exsiting line
	      
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))



;run to add or change vert distance
    (if (/= (setq stringpos (vl-string-search "vertDistance" xdatai )) nil)(progn
(setq wwpos (vl-string-position 34 xdatai (+ stringpos 14)))
(if (/= stringpos 0)(setq stringpos1 (- stringpos 1))
  (setq stringpos1 stringpos));deal with space or no space
       (setq stringpos2 (+ wwpos 2) )
);p
      
(progn

 ;else
     (setq stringpos (vl-string-search ">" xdatai ))
  (setq stringpos/ (vl-string-search "/" xdatai))
  (if (= (- stringpos stringpos/) 1)(setq stringpos1 (- stringpos 1)
					  stringpos2 (- stringpos 1))
    (setq stringpos1  stringpos 
	 stringpos2  stringpos ))
  
	
  )
      )
  
    
(setq xdatafront (substr xdatai 1  stringpos1 ))
    (setq xdataback (substr xdatai (+ stringpos2 1)))
    (setq xdatai (strcat xdatafront " vertDistance=\"" HD "\"" xdataback))

;run again to add or change method
(if (/= (setq stringpos (vl-string-search "MSLDistance" xdatai )) nil)(progn
(setq wwpos (vl-string-position 34 xdatai (+ stringpos 13)))
(if (/= stringpos 0)(setq stringpos1 (- stringpos 1))
  (setq stringpos1 stringpos));deal with space or no space
       (setq stringpos2 (+ wwpos 2) )
);p
      
(progn

 ;else
     (setq stringpos (vl-string-search ">" xdatai ))
  (setq stringpos/ (vl-string-search "/" xdatai))
  (if (= (- stringpos stringpos/) 1)(setq stringpos1 (- stringpos 1)
					  stringpos2 (- stringpos 1))
    (setq stringpos1  stringpos 
	 stringpos2  stringpos ))
  
	
  )
      )
  
    
(setq xdatafront (substr xdatai 1  stringpos1 ))
    (setq xdataback (substr xdatai (+ stringpos2 1) ))
    (setq xdatai (strcat xdatafront " MSLDistance=\"" hdt "\"" xdataback))


    (SETQ SENTLIST (ENTGET EN))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 xdatai)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)
));p&if xdata already exists

;search all pms to find pm numbers for ends of line for table
  (IF (/= (setq bdyline (ssget "_X" '((0 . "POINT") (8 . "PM,BM")))) nil)(progn 
  (setq count 0)
  (repeat (sslength bdyline)


(SETQ P1C (CDR(ASSOC 10 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME bdyline COUNT)))))
    (SETQ ZA (CDR (ASSOC 210 (ENTGET (SSNAME bdyline COUNT)))))
    (SETQ P1C (TRANS P1C ZA 0))

     	    (SETQ XDATAI (ENTGET EN '("LANDXML")))
	    (IF (= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL) (progn
	      	     (COMMAND "CHANGE" en "" "P" "C" "6" "")
	      (princ (strcat "\nERROR Control point with no XML data at " (rtos (car p1) 2 3) "," (rtos (cadr p1)2 3)))
	     )
	      (PROGN ;ELSE
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))
   

     

    ;cut pm number from xdata
      (setq ,pos1 (vl-string-position 44 xdatai 0))
    (setq pmnum  (substr xdatai 1 ,pos1 ))

	    (IF (= (STRCAT (RTOS (CAR P1) 2 6)(RTOS (CADR P1) 2 6))(STRCAT (RTOS (CAR P1C) 2 6)(RTOS (CADR P1C) 2 6)))(SETQ P1PM PMNUM))
	    (IF (= (STRCAT (RTOS (CAR P2) 2 6)(RTOS (CADR P2) 2 6))(STRCAT (RTOS (CAR P1C) 2 6)(RTOS (CADR P1C) 2 6)))(SETQ P2PM PMNUM))
	    (setq count (+ count 1))
	    ))
    )
))

  (setq prevlayer (getvar "CLAYER"))
  (SETVAR "CLAYER"  "Drafting" )
  
   
  
  (if (= hdboxmark nil)(progn

			 
			 (setq hdboxmark (getpoint "\nSelect Point for Height difference notation box:"))
			 (setq p10 (list (+ (car hdboxmark) (* 61 th))(+ (cadr hdboxmark) (* -5 th))))
			 (setq p11 (list (+ (car hdboxmark) 0)(+ (cadr hdboxmark) (* -5 th))))
			 (setq p12 (list (+ (car hdboxmark) (* th 30.5))(+ (cadr hdboxmark) (* -1.25 th))))
			 (setq p13 (list (+ (car hdboxmark) (* th 30.5))(+ (cadr hdboxmark) (* -3.75 th))))
			 (command "rectangle" hdboxmark p10)
			 (command "text" "j" "mc" p12 th "90" "HEIGHT DIFFERENCE SCHEDULE")
			 (command "text" "j" "mc" p13 th "90" "HEIGHT DATUM: AHD71")
			 (setq hdboxmark p11)
                         
			 ;box corners
			 (setq p10 (list (+ (car hdboxmark) 0)(+ (cadr hdboxmark) (* -2.5 th))))
			 (setq p11 (list (+ (car hdboxmark) (* 12 th))(+ (cadr hdboxmark)  0 )))
			 (setq p12 (list (+ (car hdboxmark) (* 24 th))(+ (cadr hdboxmark) (* -2.5 th))))
			 (setq p13 (list (+ (car hdboxmark) (* 40 th))(+ (cadr hdboxmark)  0 )))
			 (setq p14 (list (+ (car hdboxmark) (* 61 th))(+ (cadr hdboxmark) (* -2.5 th))))
			 
			 
			 ;draw boxes
			 (command "rectangle" p10 p11)
			 (command "rectangle" p11 p12)
			 (command "rectangle" p12 p13)
			 (command "rectangle" p13 p14)
			 
			 
			 ;text insertion points
			 (setq p20 (list (+ (car hdboxmark) (* 6 th))(+ (cadr hdboxmark)  (* -1.25 th ))))
			 (setq p21 (list (+ (car hdboxmark) (* 18 th))(+ (cadr hdboxmark)  (* -1.25 th ))))
			 (setq p22 (list (+ (car hdboxmark) (* 32 th))(+ (cadr hdboxmark)  (* -1.25 th ))))
			 (setq p23 (list (+ (car hdboxmark) (* 50.5 th))(+ (cadr hdboxmark)  (* -1.25 th ))))
			 
			 
			 ;create text
			 (command "text" "j" "mc" p20 th "90" "FROM")
			 (command "text" "j" "mc" p21 th "90" "TO")
			 (command "text" "j" "mc" p22 th "90" "HEIGHT DIFFERENCE")
			 (command "text" "j" "mc" p23 th "90" "METHOD")
			 
			 ;reset pm box mark point
			 (setq hdboxmark p10)
			 ));p&if no boxmark


  
  			;box corners
			(setq p10 (list (+ (car hdboxmark) 0)(+ (cadr hdboxmark) (* -2.5 th))))
			 (setq p11 (list (+ (car hdboxmark) (* 12 th))(+ (cadr hdboxmark)  0 )))
			 (setq p12 (list (+ (car hdboxmark) (* 24 th))(+ (cadr hdboxmark) (* -2.5 th))))
			 (setq p13 (list (+ (car hdboxmark) (* 40 th))(+ (cadr hdboxmark)  0 )))
			 (setq p14 (list (+ (car hdboxmark) (* 61 th))(+ (cadr hdboxmark) (* -2.5 th))))
			 
			 ;draw boxes
			 (command "rectangle" p10 p11)
			 (command "rectangle" p11 p12)
			 (command "rectangle" p12 p13)
			 (command "rectangle" p13 p14)
			
			 
			 ;text insertion points
			 (setq p20 (list (+ (car hdboxmark) (* 6 th))(+ (cadr hdboxmark)  (* -1.25 th ))))
			 (setq p21 (list (+ (car hdboxmark) (* 18 th))(+ (cadr hdboxmark)  (* -1.25 th ))))
			 (setq p22 (list (+ (car hdboxmark) (* 32 th))(+ (cadr hdboxmark)  (* -1.25 th ))))
			 (setq p23 (list (+ (car hdboxmark) (* 50.5 th))(+ (cadr hdboxmark)  (* -1.25 th ))))
			 
			 
			 ;create text
			 (command "text" "j" "mc" p20 th "90" P1PM)
			 (command "text" "j" "mc" p21 th "90" P2PM)
			 (command "text" "j" "mc" p22 th "90" hd)
			 (command "text" "j" "mc" p23 th "90" hdt)
			 
			 ;reset pm box mark point
			 (setq hdboxmark p10)


  (setvar "clayer" prevlayer)

  
    
    
  )

   

;-------------------------------------------------------------------Add Use of Parcel to lot-------------


(defun C:XUP (/)
  (setq prevlayer (getvar "CLAYER"))

(PRINC "\n Select lots to add Use of Parcel:")
  
  
  (setq bdyline (ssget  '((0 . "LWPOLYLINE") (8 . "Lot Definitions"))))

  (setq uop (getstring T (strcat "\nUse of parcel (* for list):")))

  (if (= uop "*")(progn
		      (setq workingselnum tselnum)
		      (setq names lotuoplist)
		      (dbox)
		      (setq uop returntype)
		      (setq tselnum workingselnum)
		      ))
  
  
  (setq count 0)
  (repeat (sslength bdyline)
  (SETQ P1 (CDR(ASSOC 10 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME bdyline COUNT)))))

    	    (SETQ XDATAI (ENTGET EN '("LANDXML")))
	    (IF (= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL) (progn
	      	     (COMMAND "CHANGE" en "" "P" "C" "6" "")
	      (princ (strcat "\nObject has no xdata " (rtos (car p1) 2 3) "," (rtos (cadr p1)2 3)))
	     ))
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))

    ;get centrepoint and lineup UOP label
     (setq !pos1 (vl-string-position 33 xdatai 0))
                      (setq lotc (substr xdatai (+ !pos1 2) 200))
    (setq spcpos (vl-string-position 32 lotc ))
(setq north (atof (substr lotc 1 (+ spcpos 2 ))))
(setq east (atof (substr lotc (+ spcpos 2) 50)))
    (setq lotc (list east north))
    (setq descpos (polar lotc (* 1.5 pi) (* th 3.7)))
    


    (if (/= (setq stringpos (vl-string-search "useOfParcel" xdatai )) nil)(progn
(setq wwpos (vl-string-position 34 xdatai (+ stringpos 13)))
(setq stringpos1 stringpos
       stringpos2 (+ wwpos 2) )
);p
      
(progn

 ;else
    (setq stringpos (vl-string-search ">" xdatai ))
  (setq stringpos1  stringpos 
	stringpos2 (+ stringpos 1)
	)
  );p
      );if
  
    
(setq xdatafront (substr xdatai 1  stringpos1 ))
    (setq xdataback (substr xdatai stringpos2 ))
    (setq xdatai (strcat xdatafront " useOfParcel=\"" uop "\"" xdataback))

    (SETQ SENTLIST (ENTGET EN))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 xdatai)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)

    (setvar "clayer" "Drafting")
	      (SETVAR "CELWEIGHT" 35)
	(COMMAND "TEXT" "J" "BC" descpos (* TH 1.4) "90" (strcase uop))

    (setq count (+ count 1))
    )
  (setvar "clayer" prevlayer)
  )



;------------------------------------------------------------------Create Datum Point----------------------------


(defun C:XDP (/)
   (setq prevlayer (getvar "CLAYER"))

  (setq dppos (getpoint "\nSelect Datum Point position:"))
  (setq ab (getstring T "\nLetter assginment (eg A,B or Strata Level):"))
  
  (if (= ab "a")(setq ab "A"))
  (if (= ab "b")(setq ab "B"))
  (if (= ab "x")(setq ab "A"))
  (if (= ab "y")(setq ab "B"))
  (if (= ab "X")(setq ab "A"))
  (if (= ab "Y")(setq ab "B"))
  
  
		(SETVAR "CLAYER"  "Datum Points" )
		 
     (COMMAND "POINT" dppos)

  ;check for strata level words from list
(setq stratalevel "N")
  (setq CWcount 0)
  (repeat (length stratadpwl)
    (setq checkword (nth CWcount stratadpwl))
    (if (/= (vl-string-search checkword ab ) nil)(setq stratalevel "Y"))
    (setq CWcount (+ CWcount 1))
    )
  
			   
    
  
  
		 (SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
(SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 ab)))))
  (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)
(SETQ TEXTPOS (LIST (- (CAR dpPOS) TH) (+ (CADR dpPOS) (* 0.5 TH))))
  (setq height (caddr dppos))

  (if (= stratalevel "Y")(PROGN
			   (setq ,pos1 (vl-string-position 44 ab 0))
                   (setq ab  (substr ab (+ ,pos1 2) 200)))
    (setq ab (strcat "'" ab "'"))
    )

		 (SETVAR "CLAYER"  "Drafting" )
      (if (and (/= ab "A")(/= ab "B")(/= height 0)(= stratalevel "N"))
  		 (progn;stratum datum point
			 (COMMAND "TEXT" "J" "BR"  TEXTPOS (* TH 1.4) "90"  ab )
			 (COMMAND "TEXT" "J" "BL"  dppos (* TH 1) "45" (rtos  height 2 3))
			 );P
	       (COMMAND "TEXT" "J" "BR"  TEXTPOS (* TH 2) "90"  ab );normal datum point
		       );IF SPCPOS2 NIL
  
	
  
  (setvar "clayer" prevlayer)
  
  )


;------------------------------------------------------------Create Occupation Offset---------------------------------------------

(defun C:XOC (/)
    (setq prevlayer (getvar "CLAYER"))

  ;(setq occobj (car (entsel "\nSelect Object to Offset:" )))
  (setq occpnt (getpoint "\nSelect Point to offset:" ))
  (setq bdyline (car (entsel "\nSelect boundary line:" )))
  (setq comment (getstring T  "\nOccupation comment:" ))
  ;(SETQ layer (CDR(ASSOC 8 (ENTGET occobj))))
(if (/= comment "")(setq comment (strcat " " comment)))
  
  
(if ( = (CDR(ASSOC 0 (ENTGET bdyline))) "LINE")(PROGN
  (SETQ P1 (CDR(ASSOC 10 (ENTGET bdyline))))
  (SETQ P2 (CDR(ASSOC 11 (ENTGET bdyline))))
  (SETQ OCCPNT (TRANS OCCPNT 1 0))
 ;check line one
;check offset to line
  (SETQ ANG (ANGLE P1 P2))
  (SETQ CANG (+ ANG (/ PI 2)))
  (SETQ P4 (POLAR occpnt CANG 50))
  (SETQ P6 (POLAR occpnt (+ CANG PI) 50))
   
   (SETQ P5 (INTERS P1 P2 P6 P4 nil))					
 
      (SETQ OFF (DISTANCE occpnt P5))
      
  (setq mp (list (/ (+ (car occpnt)(car p5)) 2)(/ (+ (cadr occpnt)(cadr p5)) 2)))

  
  (setq ang (angle (trans occpnt 0 1) (trans  p5 0 1)))
  (if (and (> ang  (* 0.5 pi))(< ang (* 1.5 pi)))(setq ang (- ang pi)))
  (if (< ang 0)(setq ang (+ ang (* 2 pi))))

  ))

    
(if ( = (CDR(ASSOC 0 (ENTGET bdyline))) "ARC")(PROGN
  (SETQ CP (CDR(ASSOC 10 (ENTGET bdyline))))
  (SETQ RADIUS (CDR(ASSOC 40 (ENTGET bdyline))))
  
  (SETQ ANG (ANGLE CP OCCPNT))

  (SETQ P5 (POLAR CP ANG RADIUS))
  

  (SETQ OFF (DISTANCE occpnt P5))
  
      
   

  (setq mp (list (/ (+ (car occpnt)(car p5)) 2)(/ (+ (cadr occpnt)(cadr p5)) 2)))
  (setq ang (angle (trans occpnt 0 1) (trans  p5 0 1)))
  (if (and (> ang  (* 0.5 pi))(< ang (* 1.5 pi)))(setq ang (- ang pi)))
  (if (< ang 0)(setq ang (+ ang (* 2 pi))))

  ))

  (IF (= QROUND "YES")
    (progn
      ;ROUND ALL DISTANCES TO 5MM
    (SETQ LIP (FIX (/ OFF 0.005)))
    (SETQ LFP (- (/ OFF 0.005) LIP))
    (IF (>= LFP 0.5 ) (SETQ LIP (+ LIP 1)))
    (SETQ LLEN (* LIP 0.005))
    
    (SETQ OFF  LLEN)
    ;(IF (< LLEN 1) (SETQ DTS (STRCAT "0" DTS)))
    ))

  

      (setvar "clayer" "Occupations")

  (setq occpnt (trans occpnt 0 1))
  (setq p5 (trans p5 0 1))

  
      ;line based kerb occ
      
	(command "line" occpnt p5 "")
	(SETQ BDINFO (STRCAT "<PlanFeature name=\"Offset\" desc=\"(" (rtos off 2 3)")\">"))
 (SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 BDINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)

  (if (> off (* th 5))(setq tpos (TRANS mp 0 1)
			    just "BC"))

					  (if (and (< off (* th 7))(>= (angle occpnt p5) (* 0.5 pi))(<= (angle occpnt p5)(* 1.5 pi)))(setq tpos p5
																	 just "BR"))
					  (if (and (< off (* th 7))(or(<= (angle occpnt p5) (* 0.5 pi))(>= (angle occpnt p5)(* 1.5 pi))))(setq tpos p5
																	 just "BL"))
	(setvar "clayer" "Drafting")
	(COMMAND "TEXT" "J" JUST TPOS TH (ANGTOS ANG 1 4) (strcat "(" (rtos off 2 3)  (strcase comment) ")"))
	
	
  
;wall based monument offset
     ; (if (or (= layer "Occupation Walls")(= layer "Occupation Fences")(= layer "Occupation Buildings"))(progn
					;(command "point" occpnt)
					;(setq overclear (getstring "\nOver or Clear [C]:"))
					;(if (or (= overclear "o")(= overclear "O"))(setq overclear "Over"))
					;(if (or (= overclear "")(= overclear "c")(= overclear "C"))(setq overclear "Clear"))
  	;(SETQ BDINFO (STRCAT "type=\"Occupation\" state=\"Existing\" desc=\"" (rtos off 2 3) " " overclear "\" />"))
 ;(SETQ SENT (ENTLAST))
 ; (SETQ SENTLIST (ENTGET SENT))
  ;(SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 BDINFO)))))
   ;(setq NEWSENTLIST (APPEND SENTLIST XDATA))
  ;(ENTMOD NEWSENTLIST)
					;(if (> off (* th 5))(setq tpos mp
					;			  just "MC"))

					 ; (if (and (< off (* th 7))(>= (angle occpnt p5) (* 0.5 pi))(<= (angle occpnt p5)(* 1.5 pi)))(setq tpos p5
				;													 just "MR"))
				;	  (if (and (< off (* th 7))(or(<= (angle occpnt p5) (* 0.5 pi))(>= (angle occpnt p5)(* 1.5 pi))))(setq tpos p5
				;													 just "ML"))

				;	  (setvar "clayer" "Drafting")
	;(COMMAND "TEXT" "J" just tpos TH (ANGTOS ANG 1 4) (strcat "(" (rtos off 2 3) " " (substr overclear 1 2) ")"))
	;				  ));p&if wall or fence
				

     
(setvar "clayer" prevlayer)

  
  )

;------------------------------------------------------------Create Occupation Queensland Style---------------------------------------------

(defun C:XOQ (/)
  (setq prevlayer (getvar "CLAYER"))

  (setq occpnt (getpoint "\nOccupation Point:"))
  (setq bdycnr (getpoint "\nBoundary Corner:"))
  (setq bdyl1 (car (entsel "\nBoundary Line:")))
  (setq desc (getstring T "\nDescription of Occupation:" ))

  (if (= desc "") (setq desc "OCC"))

;check line one
;check offset to line
 
  (SETQ P11 (CDR(ASSOC 10 (ENTGET bdyl1))))
  (SETQ P12 (CDR(ASSOC 11 (ENTGET bdyl1))))
  (SETQ ANG1 (ANGLE P11 P12))
  (SETQ CANG (+ ANG1 (/ PI 2)))
  (SETQ P4 (POLAR occpnt CANG 50))
  (SETQ P6 (POLAR occpnt (+ CANG PI) 50))
   
   (SETQ P5 (INTERS P11 P12 P6 P4 nil))					
 
      (SETQ OFF1 (DISTANCE BDYCNR P5))
      (SETQ OFF2 (DISTANCE P5 OCCPNT))
  (SETQ ANG1 (ANGLE BDYcnr P5))
  (SETQ ANG2 (ANGLE P5 OCCPNT))
  

    


  (IF (= QROUND "YES")
    (progn
      ;ROUND ALL DISTANCES TO 5MM
    (SETQ LIP (FIX (/ OFF1 0.005)))
    (SETQ LFP (- (/ OFF1 0.005) LIP))
    (IF (>= LFP 0.5 ) (SETQ LIP (+ LIP 1)))
    (SETQ OFF1 (* LIP 0.005))
    
    

     (SETQ LIP (FIX (/ OFF2 0.005)))
    (SETQ LFP (- (/ OFF2 0.005) LIP))
    (IF (>= LFP 0.5 ) (SETQ LIP (+ LIP 1)))
    (SETQ OFF2 (* LIP 0.005))
    
    
   
   
    ))



  ;Discover directions
  (if (and (<= ang1 (* (/ 5.0 8.0) pi))(>= ang1 (* (/ 3.0 8.0) pi)))(setq dir1 "N"))
  (if (and (> ang1 (* (/ 1.0 8.0) pi))(< ang1 (* (/ 3.0 8.0) pi)))(setq dir1 "NE"))
  (if (or (>= ang1 (* (/ 15.0 8.0) pi))(<= ang1 (* (/ 1.0 8.0) pi)))(setq dir1 "E"))
  (if (and (> ang1 (* (/ 13.0 8.0) pi))(< ang1 (* (/ 15.0 8.0) pi)))(setq dir1 "SE"))
  (if (and (>= ang1 (* (/ 11.0 8.0) pi))(<= ang1 (* (/ 13.0 8.0) pi)))(setq dir1 "S"))
  (if (and (> ang1 (* (/ 9.0 8.0) pi))(< ang1 (* (/ 11.0 8.0) pi)))(setq dir1 "SW"))
  (if (and (>= ang1 (* (/ 7.0 8.0) pi))(<= ang1 (* (/ 9.0 8.0) pi)))(setq dir1 "W"))
  (if (and (> ang1 (* (/ 5.0 8.0) pi))(< ang1 (* (/ 7.0 8.0) pi)))(setq dir1 "NW"))
  
  

   (if (and (<= ang2 (* (/ 5.0 8.0) pi))(>= ang2 (* (/ 3.0 8.0) pi)))(setq dir2 "N"))
  (if (and (> ang2 (* (/ 1.0 8.0) pi))(< ang2 (* (/ 3.0 8.0) pi)))(setq dir2 "NE"))
  (if (or (>= ang2 (* (/ 15.0 8.0) pi))(<= ang2 (* (/ 1.0 8.0) pi)))(setq dir2 "E"))
  (if (and (> ang2 (* (/ 13.0 8.0) pi))(< ang2 (* (/ 15.0 8.0) pi)))(setq dir2 "SE"))
  (if (and (>= ang2 (* (/ 11.0 8.0) pi))(<= ang2 (* (/ 13.0 8.0) pi)))(setq dir2 "S"))
  (if (and (> ang2 (* (/ 9.0 8.0) pi))(< ang2 (* (/ 11.0 8.0) pi)))(setq dir2 "SW"))
  (if (and (>= ang2 (* (/ 7.0 8.0) pi))(<= ang2 (* (/ 9.0 8.0) pi)))(setq dir2 "W"))
  (if (and (> ang2 (* (/ 5.0 8.0) pi))(< ang2 (* (/ 7.0 8.0) pi)))(setq dir2 "NW"))

  ;calc bdy corner

  
(setvar "clayer" "Occupations")
  (command "point" bdycnr)
  
 (SETQ BDINFO (STRCAT "type=\"Occupation\" state=\"Found\" desc=\"" desc " " (rtos off1 2 3) " " dir1 " " (rtos off2 2 3) " " dir2 "\" />"))
 (SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 BDINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)
(setvar "clayer" "Drafting")
  (COMMAND "TEXT" "J" "TL" BDYCNR TH (ANGTOS 0 1 4) (strcat desc " " (rtos off1 2 3) " " dir1 " " (rtos off2 2 3) " " dir2))
				
  

 
  (setvar "clayer" prevlayer)


  )

;--------------------------------------------------------------Autopop--------------------------------------


(defun C:XCP (/)

  (SETQ CGPL (LIST));EMPTY CGPL

  (setq prevlayer (getvar "clayer"))
  (setvar "clayer" "Drafting")
  (setq pcount 1)
  

(IF (/= (setq lots (ssget "_X" '((0 . "LWPOLYLINE") (8 . "Lot Definitions")))) nil)(progn

										     
 (setq count 0)
  (repeat (sslength lots)
  
    (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME lots COUNT)))))
    

    	    (SETQ XDATAI (ENTGET EN '("LANDXML")))
	    (SETQ XDATAI (ASSOC -3 XDATAI))
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))

      (if (/= (setq stringpos (vl-string-search "class" xdatai )) nil)(progn
(setq wwpos (vl-string-position 34 xdatai (+ stringpos 7)))(setq lotclass (substr xdatai (+ stringpos 8) (-(- wwpos 1)(+ stringpos 6)))))(setq lotclass ""))
    
(if (and (/= lotclass "Easement")(/= lotclass "Road"))(progn
  

					(setq enlist (entget en))
    ;go through polyline to get points and bugle factors
    (SETQ PTLIST (LIST))
	    (foreach a enlist
	      (if (= 10 (car a))

		(setq PTLIST (append PTLIST (list (cdr a))))
	      )				;IF
	      (if (= 42 (car a))
		(setq PTLIST (append PTLIST (LIST (cdr a))))
		);if
	    )				;FOREACH 			
 
(setq ptlist (append ptlist (list(nth 0 ptlist))))

 (setq count1 0)
 (repeat (- (/ (length ptlist) 2) 1)

   (setq p1 (nth count1 ptlist))
   (setq p1s (strcat (rtos (cadr p1) 2 6) " " (rtos (car p1) 2 6)))
   (setq p2 (nth (+ count1 2) ptlist))
   (setq p2s (strcat (rtos (cadr p2) 2 6) " " (rtos (car p2) 2 6)))
  
   ;get edge names
     (if (/= (setq remlist (member p1s cgpl)) nil)(progn
						  (setq p1n (nth 3 remlist))
						  )
       (progn
	
	 (setq pcount (+ pcount 1))
	 (setq cgpl (append cgpl (list p1s)(list "sideshot")(list "proposed")(list (rtos pcount 2 0))))
         (setq p1n (rtos pcount 2 0))
	 
	 	 ))
     (if (/= (setq remlist (member p2s cgpl)) nil)(progn
						  (setq p2n (nth 3 remlist))
						  )
       (progn;if not found at corner
	 
	 (setq pcount (+ pcount 1))
	 (setq cgpl (append cgpl (list p2s)(list "sideshot")(list "proposed")(list (rtos pcount 2 0))))
         (setq p2n (rtos pcount 2 0))
	 
	 	 ))
    
  (setq count1 (+ count1 2))

   );r length of ptlist
					));if not easement or road
 
  (setq count (+ count 1))
);r length of lots
										    



  (setq count 0)
  (repeat (/ (length cgpl ) 4)
    (setq linetext (nth count cgpl))

(setq spcpos (vl-string-position 32 linetext ))
(setq north (atof (substr linetext 1 (+ spcpos 2 ))))
(setq east (atof (substr linetext (+ spcpos 2) 50)))
    (setq p1 (list east north))
    
    (COMMAND "._INSERT" "POP" "_S" TH (trans p1 0 1) "0");changed for BricsCAD
    (setq count (+ count 4))
    );repeat

  (setvar "clayer" prevlayer)

 ));p&if lots found
)

 


;-----------------------------------------------------------------CREATE ADMIN SHEET-------------------------------
(defun c:XAS (/)DEFUN

  (SETQ ATTDIA (GETVAR "ATTDIA"))
  (SETQ ATTREQ (GETVAR "ATTREQ"))
  (SETVAR "ATTDIA" 0)
  (SETVAR "ATTREQ" 1)

  (SETQ P1 (GETPOINT "\n Select Bottom Left Point to Place Admin Sheet:"))
  (setq prevlayer (getvar "clayer"))
  (setvar "clayer" "Admin Sheet")
  

  (setq dpnum (GetString "\nDP Number:"))
  (if (and (>= (ascii (substr dpnum 1 1)) 48)(<= (ascii (substr dpnum 1 1)) 57))(setq dpnum (strcat "DP" dpnum)));will add dp if you enter only the number

  (setq format (getstring T "\nFormat (eg Standard,Stratum,Strata Schemes etc, Standard is default (* for list)):" ))
(if (= format "")(setq format "Standard"))
  (if (= format "*")
    (progn
		      (setq workingselnum "2")
		      (setq names formatlist)
		      (dbox)
		      (setq format returntype)
		       ));p&if format*


  
  (setq lga (getstring T "\nLGA:" ))
  (setq locality (getstring T "\nLocality:" ))
  (setq Parish (getstring T "\nParish (* for list):"))

  (if (= parish "*")(progn
		      (setq workingselnum "0")
		      (setq names parishlist)
		      (dbox)
		      (setq parishcounty returntype)
		      
		      (setq ,pos1 (vl-string-position 44 parishcounty 0))
                 (setq parish  (substr parishcounty 1 ,pos1))
      		 (setq county  (substr parishcounty (+ ,pos1 2) 50))
		      
		      )
    (setq county (getstring T "\nCounty:"))
    )
(setq surveyor (getstring T "\nSurveyor:" ))
  (setq firm (getstring T "\nFirm/Address:" ))
  (setq dos (getstring T "\nDate of Survey(dd.mm.yyyy):" ))

  (if (/= dos "")(progn

;sort date entrys

  ;replace /,\,. with -
  (setq /pos 0)
	      (while (/=  (setq /pos (vl-string-search "/" dos /pos )) nil) (setq dos (vl-string-subst "-" "/"  dos /pos)
										      /pos (+ /pos 1)))
(setq /pos 0)
	      (while (/=  (setq /pos (vl-string-search "\\" dos /pos )) nil) (setq dos (vl-string-subst "-" "\\"  dos /pos)
										      /pos (+ /pos 2)))
  (setq /pos 0)
	      (while (/=  (setq /pos (vl-string-search "." dos /pos )) nil) (setq dos (vl-string-subst "-" "."  dos /pos)
										      /pos (+ /pos 1)))
  ;NOTE REMOVED REARRANGER, REARRANGER AT EXPORT
  ;(setq minuspos1 (vl-string-position 45 dos 0))
  ;(setq minuspos2 (vl-string-position 45 dos (+ minuspos1 1)))
  ;(if (or (= minuspos1 1)(= minuspos1 2))(progn;rearrage date
;				       (setq day  (substr dos 1 minuspos1));
;				       (if (= (strlen day) 1) (setq day (strcat "0" day)));single digit days
;				       (setq month (substr dos (+ minuspos1 2) (- (- minuspos2 minuspos1) 1)))
;				       (if (= (strlen month) 1) (setq month (strcat "0" month)));single digit days
;				       (setq year  (substr dos (+ minuspos2 2) 50))
;				       (setq dos (strcat year "-" month "-" day))
;				       ));p&if dos round the wrong way

  ));p&if dos not ""

    
(if (/= format "Strata Schemes")(progn		       
  
  (setq urbrur (getstring T "\nUrban/Rural (U/R):" ))
  (if (or (= urbrur "U")(= urbrur "u")(= urbrur "URBAN")(= urbrur "urban"))(setq urbrur "Urban"))
  (if (or (= urbrur "R")(= urbrur "r")(= urbrur "RURAL")(= urbrur "rural"))(setq urbrur "Rural"))
  (setq terrain (getstring T "\nTerrain (Level-Undulating or Steep-Mountainous)(L/S):" ))
  (if (or (= terrain "L")(= terrain "l")(= terrain "LEVEL-UNDULATING")(= terrain "level-undulating"))(setq terrain "Level-Undulating"))
  (if (or (= terrain "S")(= terrain "s")(= terrain "STEEP-MOUNTAINOUS")(= terrain "steep-mountainous"))(setq terrain "Steep-Mountainous"))
))

  (setq survref (getstring T "\nSurveyors Reference:" ))
  (setq planof (getstring T "\nPlan of:" ))
  (setq plansused (getstring T "\nPlans used:" ))
  (setq purpose (getstring T "\nPurpose (* for list):" ))
  (if (= purpose "*")(progn
		      (setq workingselnum "41")
		      (setq names purposelist)
		      (dbox)
		      (setq purpose returntype)
		       ));p&if purpose*
  (setq dor (getstring T "\nDate of Registration:(dd.mm.yyyy)" ))
;sort date entrys
(IF (/= dor "")(progn
  ;replace /,\,. with -
  (setq /pos 0)
	      (while (/=  (setq /pos (vl-string-search "/" dor /pos )) nil) (setq dor (vl-string-subst "-" "/"  dor /pos)
										      /pos (+ /pos 1)))
(setq /pos 0)
	      (while (/=  (setq /pos (vl-string-search "\\" dor /pos )) nil) (setq dor (vl-string-subst "-" "\\"  dor /pos)
										      /pos (+ /pos 2)))
  (setq /pos 0)
	      (while (/=  (setq /pos (vl-string-search "." dor /pos )) nil) (setq dor (vl-string-subst "-" "."  dor /pos)
										      /pos (+ /pos 1)))
  ;NOTE REMOVED REARRANGER, REARRANGER AT EXPORT
 ;(setq minuspos1 (vl-string-position 45 dor 0))
 ; (setq minuspos2 (vl-string-position 45 dor (+ minuspos1 1)))
 ; (if (or (= minuspos1 1)(= minuspos1 2))(progn;rearrage date
;				       (setq day  (substr dor 1 minuspos1))
;				       (if (= (strlen day) 1) (setq day (strcat "0" day)));single digit days
;				       (setq month (substr dor (+ minuspos1 2) (- (- minuspos2 minuspos1) 1)))
;				       (if (= (strlen month) 1) (setq month (strcat "0" month)));single digit days
;				       (setq year  (substr dor (+ minuspos2 2) 50))
;				       (setq dor (strcat year "-" month "-" day))
;				       ));p&if dos round the wrong way
));p&if
    
  (setq plantype (getstring T "\nSurveyed or Compiled (S/C):" ))
  (if (or (= plantype "S")(= plantype "s")(= plantype "SURVEYED")(= plantype "Surveyed"))(setq plantype "surveyed"))
  (if (or (= plantype "C")(= plantype "c")(= plantype "COMPILED")(= plantype "Compiled"))(setq plantype "compiled"))
  (setq jur (getstring T "\nJurisdiction (NSW is default):" ))
  (if (= jur "")(setq jur "New South Wales"))
  
  (setq parcelnotes (getstring T "\nParcel Notes:" ))
  (setq azdatum (getstring T "\nAzimuth Datum (MGA,ISG,MM,Local,TM (* for list):" ))
   (if (= azdatum "*")
    (progn
		      (setq workingselnum "2")
		      (setq names datumlist)
		      (dbox)
		      (setq azdatum returntype)
		       ));p&if format*

  (if (= azdatum "MM")
    (progn
      (setq datumdesc  (getstring T "\nMM datum requires descripton (eg oriented to DP1234):"))
      (if (/= datumdesc "")(setq azdatum (strcat azdatum "~" datumdesc)))
      )
    )
	
  (setq zone (getstring T "\nZone (54-57):" ))
  (setq subnum (getstring T "\nSubdivision Certificate Number:" ))

  (if (= planof "" )(setq planof "Not entered"))
  (if (= plansused "")(setq plansused "none"))
  (if (= parcelnotes "")(setq parcelnotes "none"))
  
  
  ;changed for BricsCAD
  (if (/= format "Strata Schemes")(command "._INSERT" "PLANFORM6" "_S" "1" p1 "0" dpnum lga locality parish county surveyor firm dos urbrur terrain survref planof "" plansused "" purpose dor plantype jur format parcelnotes "" azdatum "Local" "AHD" zone subnum))

  (if (= format "Strata Schemes")(command "._INSERT" "PLANFORM3" "_S" "1" p1 "0" dpnum lga locality parish county surveyor firm dos survref planof "" plansused "" purpose dor plantype jur format parcelnotes "" azdatum "Local" "AHD" zone subnum))
  


  (setvar "clayer" prevlayer)
(SETVAR "ATTDIA" ATTDIA)
(SETVAR "ATTREQ" ATTREQ)
  
  )

 



;----------------------------------------------------------------CREATE LAYOUT------------------------------------------------

(DEFUN C:XLA (/)
(setq prevlayer (getvar "clayer"))
  (setvar "clayer" "Drafting")

  (SETQ ATTDIA (GETVAR "ATTDIA"))
  (SETQ ATTREQ (GETVAR "ATTREQ"))
  (SETVAR "ATTDIA" 0)
  (SETVAR "ATTREQ" 1)


  
(IF (/= (setq adminsheet (ssget "_X" '((0 . "INSERT") (2 . "PLANFORM6,PLANFORM3")))) nil)(progn
		(SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME ADMINSHEET 0)))))
		(SETQ BLOCKNAME (CDR(ASSOC 2 (ENTGET (SSNAME ADMINSHEET 0)))))
		(SETQ INSP (CDR(ASSOC 10 (ENTGET (SSNAME ADMINSHEET 0)))))

		(IF (= BLOCKNAME "PLANFORM6")(PROGN
					       
		(setq count 1)
  (SETQ ATTLIST (LIST))
	    
(setq Obj (vlax-ename->vla-object En))
	(foreach x (vlax-invoke Obj 'GetAttributes)
	  (SETQ ATT (vla-get-textstring X))
	  (if (= att "none") (setq att ""))

	  (setq attlist (append attlist (list att)))

	  )

;store objects


(setq surname  (nth 0 attlist))
(SETQ SHDOS (nth 7 attlist))
 (setq surveyorReference (nth 10 attlist))
		(setq shdesc (nth 11 attlist))
		(setq surpersonel (nth 5 attlist))
		(setq surloc (nth 2 attlist))
		(setq surlga (nth 1 attlist))




		(COMMAND "._INSERT" "PLANFORM2" "_S" (/ SCALE 1000.0) INSP "0" surname surlga surloc surpersonel shdos surveyorreference shdesc "")
		));P&IF PLANFORM 6

	(IF (= BLOCKNAME "PLANFORM3")(PROGN
					       
		(setq count 1)
  (SETQ ATTLIST (LIST))
	    
(setq Obj (vlax-ename->vla-object En))
	(foreach x (vlax-invoke Obj 'GetAttributes)
	  (SETQ ATT (vla-get-textstring X))
	  (if (= att "none") (setq att ""))

	 (setq attlist (append attlist (list att)))

	  )

;store objects
		


 (setq surveyorReference (nth 8 attlist) )
 (setq shdesc (nth 9 attlist) )
 (setq surname (nth 0 attlist))


		(SETQ SHDOS (nth 7 attlist))
                 (setq surpersonel (nth 5 attlist))
		 (setq surloc (nth 2 attlist))
		 (setq surlga (nth 1 attlist))
	



		(COMMAND "._INSERT" "PLANFORM1" "_S" (/ SCALE 1000.0) INSP "0" surname surlga surloc surpersonel shdos surveyorreference shdesc "")
		));P&IF PLANFORM 3
		
		



		;changed for BricsCAD
		
                

		  
		
  )
  (progn
    (SETQ P1 (GETPOINT "\n Select Bottom Right Point to Place Layout Sheet:"))
    (setq blockname (getstring "\nPlanform Type [1/2]:"))
    (if (or (= blockname "2")(= blockname "")(= blockname "planform2"))(setq blockname "PLANFORM2"))
    (if (or (= blockname "1")(= blockname "planform1"))(setq blockname "PLANFORM1"))
  (COMMAND "._INSERT" BLOCKNAME "_S" "1" p1 "0");changed for BricsCAD
    ));P&IF ADMINSHEET EXISTS
  (setvar "clayer" prevlayer)

(SETVAR "ATTDIA" ATTDIA)
(SETVAR "ATTREQ" ATTREQ)

);defun




;----------------------------------------------------------------CREATE ADMINSHEET 2------------------------------------------------

(DEFUN C:XAS2 (/)
(setq prevlayer (getvar "clayer"))
  (setvar "clayer" "Drafting")

  (SETQ ATTDIA (GETVAR "ATTDIA"))
  (SETQ ATTREQ (GETVAR "ATTREQ"))
  (SETVAR "ATTDIA" 0)
  (SETVAR "ATTREQ" 1)


  
(IF (/= (setq adminsheet (ssget "_X" '((0 . "INSERT") (2 . "PLANFORM6,PLANFORM3")))) nil)(progn
		(SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME ADMINSHEET 0)))))
		(SETQ BLOCKNAME (CDR(ASSOC 2 (ENTGET (SSNAME ADMINSHEET 0)))))
		(SETQ INSP (CDR(ASSOC 10 (ENTGET (SSNAME ADMINSHEET 0)))))

		(IF (= BLOCKNAME "PLANFORM6")(PROGN
					       
		(setq count 1)
  (SETQ ATTLIST (LIST))
	    
(setq Obj (vlax-ename->vla-object En))
	(foreach x (vlax-invoke Obj 'GetAttributes)
	  (SETQ ATT (vla-get-textstring X))
	  (if (= att "none") (setq att ""))

	  (setq attlist (append attlist (list att)))

	  )

;store objects


(setq surname  (nth 0 attlist))
;(SETQ SHDOS (nth 7 attlist))
 (setq surveyorReference (nth 10 attlist))
		(setq shdesc (nth 11 attlist))
		;(setq surpersonel (nth 5 attlist))
		(setq subnum (nth 23 attlist))
		;(setq surlga (nth 1 attlist))




		(COMMAND "._INSERT" "PLANFORM6A" "_S" "1" INSP "0" surname shdesc "" subnum surveyorReference )
		));P&IF PLANFORM 6

	(IF (= BLOCKNAME "PLANFORM3")(PROGN
					       
		(setq count 1)
  (SETQ ATTLIST (LIST))
	    
(setq Obj (vlax-ename->vla-object En))
	(foreach x (vlax-invoke Obj 'GetAttributes)
	  (SETQ ATT (vla-get-textstring X))
	  (if (= att "none") (setq att ""))

	 (setq attlist (append attlist (list att)))

	  )

;store objects
		


 (setq surveyorReference (nth 8 attlist) )
 (setq shdesc (nth 9 attlist) )
 (setq surname (nth 0 attlist))


		(SETQ SHDOS (nth 7 attlist))
                 (setq surpersonel (nth 5 attlist))
		 (setq surloc (nth 2 attlist))
		 (setq surlga (nth 1 attlist))
	



		(COMMAND "._INSERT" "PLANFORM1" "_S" (/ SCALE 1000.0) INSP "0" surname surlga surloc surpersonel shdos surveyorreference shdesc "")
		));P&IF PLANFORM 3
		
		



		;changed for BricsCAD
		
                

		  
		
  )
  (progn
    (SETQ P1 (GETPOINT "\n Select Bottom Right Point to Place Layout Sheet:"))
    (setq blockname (getstring "\nPlanform Type [1/2]:"))
    (if (or (= blockname "2")(= blockname "")(= blockname "planform2"))(setq blockname "PLANFORM2"))
    (if (or (= blockname "1")(= blockname "planform1"))(setq blockname "PLANFORM1"))
  (COMMAND "._INSERT" BLOCKNAME "_S" "1" p1 "0");changed for BricsCAD
    ));P&IF ADMINSHEET EXISTS
  (setvar "clayer" prevlayer)

(SETVAR "ATTDIA" ATTDIA)
(SETVAR "ATTREQ" ATTREQ)

);defun

;-------------------------------------------------------------ASSIGN LINE TO XML-----------------------------------
;reworked to include XALN and XALC

(defun C:XAL (/)
  (setq notereq 0)
  (setq compile 0)
  (setq cbrq nil)
  (setq mandist 0)
  (al)
  )
(defun C:XALN (/)
  (setq notereq 1)
  (setq compile 0)
  (setq cbrq nil)
  (setq mandist 0)
  (al)
  )

(defun C:XALC (/)
  (if (/= compile 1) (setq cbrq (getstring "Do you with to show bearings? (y/n):")))
  (if (or (= cbrq "y")(= cbrq "yes")(= cbrq "YES"))(setq cbrq "Y"))
  (if (or (= cbrq "n")(= cbrq "no")(= cbrq "NO"))(setq cbrq "N"))
  (setq compile 1)
  (setq notereq 0)
  (setq mandist 0)
  (al)
  )
(defun C:XALCN (/)
  (if (/= compile 1) (setq cbrq (getstring "Do you with to show bearings? (y/n):")))
  (if (or (= cbrq "y")(= cbrq "yes")(= cbrq "YES"))(setq cbrq "Y"))
  (if (or (= cbrq "n")(= cbrq "no")(= cbrq "NO"))(setq cbrq "N"))
  (setq compile 1)
  (setq notereq 1)
  (setq mandist 0)
  (al)
  )

(defun C:XALS (/)
  (setq cbrq "N")
  (setq compile 2)
  (setq notereq 0)
  (setq mandist 0)
  (al)
  )
(defun C:XALSN (/)
  (setq cbrq "N")
  (setq compile 2)
  (setq notereq 1)
  (setq mandist 0)
  (al)
  )
(defun C:XALSM (/)
  (setq cbrq "N")
  (setq compile 2)
  (setq notereq 0)
  (setq mandist 1)
  (al)
  )

(defun C:XALSMN (/)
  (setq cbrq "N")
  (setq compile 2)
  (setq notereq 1)
  (setq mandist 1)
  (al)
  )


(DEFUN AL (/)

  (setq prevlayer (getvar "CLAYER"))
(SETQ COMMENT "")
 (SETQ LINES (SSGET  '((0 . "LINE"))))

  (SETQ COUNT 0)
(REPEAT (SSLENGTH LINES)
(SETQ P1 (CDR(ASSOC 10 (ENTGET (SSNAME LINES COUNT)))))
  (SETQ P1 (LIST (CAR P1) (CADR P1)));2DISE P1 TO GIVE 2D DISTANCE
  (SETQ P2 (CDR(ASSOC 11 (ENTGET (SSNAME LINES COUNT)))))
  (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME LINES COUNT)))))
  (SETQ LAYER (CDR(ASSOC 8 (ENTGET (SSNAME LINES COUNT)))))

  (SETQ ANG (ANGLE  P1  P2 ))

  (SETQ BEARING (ANGTOS ANG 1 4));REQUIRED FOR ELSE ROUND
  (setq bearing (vl-string-subst "d" (chr 176) bearing));added for BricsCAD changes degrees to "d"
  (SETQ DIST (DISTANCE (LIST (CAR P1)(CADR P1)) P2));REQUIRED FOR ELSE ROUND


    ;check for manual distance
  


  
  (IF (= QROUND "YES")(PROGN

			(SETQ LLEN (DISTANCE (LIST (CAR P1)(CADR P1)) P2))

    ;ASSIGN ROUNDING FOR ANGLES BASED ON DISTANCE
    (IF (< LLEN MAXLEN1) (SETQ ROUND BRND1))
    (IF (AND (> LLEN MAXLEN1)(< LLEN MAXLEN2)) (SETQ ROUND BRND2))
    (IF (> LLEN MAXLEN2)(SETQ ROUND BRND3))			
			
    ;(IF (> LLEN 100) (SETQ ROUND 1))

   
    ;GET ANGLE DELIMIETERS
    (SETQ SANG (ANGTOS ANG 1 4))
    (setq sang (vl-string-subst "d" (chr 176) sang));added for BricsCAD changes degrees to "d"
    (setq CHRDPOS (vl-string-position 100 SANG 0))
    (setq MINPOS (vl-string-position 39 SANG 0))
    (setq SECPOS (vl-string-position 34 SANG 0))

    ;PARSE ANGLE
    (setq DEG  (atof (substr SANG 1  CHRDPOS )))
    (setq MINS  (atof (substr SANG (+ CHRDPOS 2)  (-(- MINPOS CHRDPOS)1))))
    (setq SEC  (atof (substr SANG (+ MINPOS 2)  (-(- SECPOS MINPOS )1))))

   
;ROUND ANGLE, NOTE SECONDS REMOVED
    (IF (and (= ROUND 60)(< SEC 30)) (SETQ SEC 0))
    (IF (and (= ROUND 60)(>= SEC 30)) (SETQ SEC 0
					    MINS (+ MINS 1)))					  
    (IF (/= ROUND 60) (PROGN
			(SETQ SIP (FIX (/ SEC ROUND)))
			(SETQ SFP (- (/  SEC ROUND) SIP))
			(IF (>= SFP 0.5) (SETQ SIP (+ SIP 1)))
			(SETQ SEC (* SIP ROUND))
			)
      )

    ;ROUND DISTANCES

    (IF (< LLEN DISTMAX1) (SETQ DROUND DRND1))
    (IF (AND (> LLEN DISTMAX1)(< LLEN DISTMAX2)) (SETQ DROUND DRND2))
    (IF (> LLEN DISTMAX2)(SETQ DROUND DRND3))
			
    (SETQ LIP (FIX (/ LLEN DROUND)))
    (SETQ LFP (- (/ LLEN DROUND) LIP))
    (IF (>= LFP 0.5 ) (SETQ LIP (+ LIP 1)))
    (SETQ LLEN (* LIP DROUND))

    (SETQ LDIST (RTOS LLEN 2 3))
    
    ;(IF (< LLEN 1) (SETQ DTS (STRCAT "0" DTS)))
      
   
		 
    
;STRING ANGLES
    (SETQ DEG (RTOS DEG 2 0))
    (SETQ MINS (RTOS MINS 2 0))
    (SETQ SEC (RTOS SEC 2 0))
    
;INCREMENT IF SECONDS ROUNDED TO 60
    (IF (= SEC  "60")
      (PROGN
	(SETQ SEC "00")
	(SETQ MINS (RTOS (+ (ATOF MINS ) 1) 2 0))
	)
      )
;INCREMENT IF MINUTES ROUNDED TO 60
    (IF (= MINS "60")
      (PROGN
	(SETQ MINS "00")
	(SETQ DEG (RTOS (+ (ATOF DEG ) 1) 2 0))
	)
      )
;FIX IF INCREMENTING PUSHES DEG PAST 360    
    (IF (= DEG "360")(SETQ DEG "0"))
;ADD ZEROS TO SINGLE NUMBERS	
 (IF (= (STRLEN MINS) 1)(SETQ MINS (STRCAT "0" MINS)))
  (IF (= (STRLEN SEC) 1)(SETQ SEC (STRCAT "0" SEC)))

;TRUNCATE BEARINGS IF 00'S
  (IF (AND (= MINS "00") (= SEC "00")) (SETQ MINSS ""
					     MINS ""
					     SECS ""
					     SEC "")
        (SETQ MINSS(STRCAT MINS "'")
	  SECS (STRCAT SEC "\""))
	  )
    (IF (= SEC "00")(SETQ SECS ""
			    SEC ""))

			

    ;CONCATENATE BEARING
    (SETQ BEARING (STRCAT DEG "d" MINSS SECS ))

			(IF (or (/= sec "")(/= MINS ""))(SETQ DEG (STRCAT DEG ".")))

  (SETQ LBEARING (STRCAT DEG MINS SEC))

			
    

			);P&IF


(PROGN;ELSE

  

  (SETQ DPOS (vl-string-position 100 BEARING 0))
  (setq Wpos (vl-string-position 39 BEARING 0))
  (setq WWpos (vl-string-position 34 BEARING 0))

    (setq DEG (substr BEARING 1 Dpos))
      (setq MINS (substr BEARING (+ Dpos 2) (- (- WPOS DPOS) 1)))
      (setq SEC (substr BEARING (+ Wpos 2) (- (- WWpos Wpos) 1)))

  (IF (= (STRLEN MINS) 1)(SETQ MINS (STRCAT "0" MINS)))
  (IF (= (STRLEN SEC) 1)(SETQ SEC (STRCAT "0" SEC)))
  
  (IF (AND (= MINS "00") (= SEC "00")) (SETQ MINSS ""
					     SECS ""
					     MINS ""
					     SEC "")
    (SETQ MINSS(STRCAT MINS "'")
	  SECS (STRCAT SEC "\""))
	  	  )
  (IF (= SECS "00\"")(SETQ SECS ""
			   SEC ""))
  
  (SETQ BEARING (STRCAT DEG "d" MINSS SECS ))

  	(IF (or (/= sec "")(/= MINS ""))(SETQ DEG (STRCAT DEG ".")))

  
  
  (SETQ LBEARING (STRCAT DEG MINS SEC))
  (SETQ LDIST (RTOS DIST 2 3))

  

  ));PELSE&IF

  (if (= mandist 1)(setq ldist (getstring "\nManual Distance:")))

  (if ( = notereq 1) (setq comment ( getstring T "\nGeometry Note:")))

  (if (= compile 0)(setq distx (strcat "\" horizDistance=\"" ldist "\" distanceType=\"Measured\"")
			 azimuthx (strcat "azimuth=\"" lbearing)))
  
  (if (= compile 1)(setq distx (strcat "horizDistance=\"" ldist"\" distanceType=\"Compiled\"")))
  (if (= compile 2)(setq distx (strcat "horizDistance=\"" ldist"\" distanceType=\"Measured\"")));strata
  
  (if (= cbrq "Y")(setq  azimuthx (strcat "azimuth=\"" lbearing "\" azimuthType=\"Compiled\" ")))
  (if (= cbrq "N")(setq  azimuthx ""))

  

  
  (if (/= comment "")(setq ocomment (strcat "><FieldNote>\"" comment "\"</FieldNote></ReducedObservation>"))(setq ocomment "/>"))

  
  (COMMAND "ERASE" EN "")
  (SETVAR "CLAYER" layer)
  (COMMAND "LINE" (trans P1 0 1)(trans P2 0 1) "")
    
(SETQ BDINFO (STRCAT azimuthx distx ocomment))
  (SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 BDINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)

  (if (= cbrq "N")(setq bearing ""))

  (LBA)

  (SETQ COUNT (+ COUNT 1))

  );R


      (SETVAR "CLAYER" prevlayer)

  );DEFUN
  


;-------------------------------------------------------------ASSIGN ARC TO XML-----------------------------------
(defun C:XAA (/)
    (setq notereq 0)
  (setq compile 0)
  (setq cbrq nil)
  (setq mandist 0)
  (AA)
  )
(defun C:XAAN (/)
  (setq notereq 1)
  (setq compile 0)
  (setq cbrq nil)
  (setq mandist 0)
  (AA)
  )
(defun C:XAAC (/)
   (if (/= compile 1) (setq cbrq (getstring "Do you with to show bearings? (y/n):")))
  (if (or (= cbrq "y")(= cbrq "yes")(= cbrq "YES"))(setq cbrq "Y"))
  (if (or (= cbrq "n")(= cbrq "no")(= cbrq "NO"))(setq cbrq "N"))
  (setq compile 1)
  (setq notereq 0)
  (setq mandist 0)
  (AA)
  )
(defun C:XAACN (/)
   (if (/= compile 1) (setq cbrq (getstring "Do you with to show bearings? (y/n):")))
  (if (or (= cbrq "y")(= cbrq "yes")(= cbrq "YES"))(setq cbrq "Y"))
  (if (or (= cbrq "n")(= cbrq "no")(= cbrq "NO"))(setq cbrq "N"))
  (setq compile 1)
  (setq notereq 1)
  (setq mandist 0)
  (AA)
  )
(defun C:XAAS (/)
  (setq cbrq "N")
  (setq compile 2)
  (setq notereq 0)
  (setq mandist 0)
  (AA)
  )
(defun C:XAASN (/)
  (setq cbrq "N")
  (setq compile 2)
  (setq notereq 1)
  (setq mandist 0)
  (AA)
  )

(DEFUN AA (/)


  (setq prevlayer (getvar "CLAYER"))
(SETQ COMMENT "")
 (SETQ LINES (SSGET  '((0 . "ARC"))))

  (SETQ COUNT 0)
(REPEAT (SSLENGTH LINES)
(SETQ CP (CDR(ASSOC 10 (ENTGET (SSNAME LINES COUNT)))))
  (SETQ RADIUS (CDR(ASSOC 40 (ENTGET (SSNAME LINES COUNT)))))
  (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME LINES COUNT)))))
  (SETQ LAYER (CDR(ASSOC 8 (ENTGET (SSNAME LINES COUNT)))))

  (SETQ ANG1 (CDR(ASSOC 50 (ENTGET (SSNAME LINES COUNT)))))
  (SETQ ANG2 (CDR(ASSOC 51 (ENTGET (SSNAME LINES COUNT)))))

  (SETQ P1 (POLAR CP ANG1 RADIUS))
  (SETQ P2 (POLAR CP ANG2 RADIUS))
  

  ;CONVERT TO WCS
    (SETQ ZA (CDR(ASSOC 210 (ENTGET (SSNAME LINES COUNT)))))
    (SETQ CP (TRANS CP ZA 0))
    (SETQ P1 (TRANS P1 ZA 0))
    (SETQ P2 (TRANS P2 ZA 0))
    (if (< (caddr za) 0)(setq TEMP1 P1
			      P1 P2
			      P2 TEMP1))
    (SETQ ANG (ANGLE P1 P2))
  
(SETQ CURVEROT "ccw")
  ;calc curve midpoint
  (setq a1 (angle CP p1))
  (setq a2 (angle CP p2))
  (if (= curverot "ccw")(setq da (- a2 a1))(setq da (- a1 a2)))
  (if (< da 0)(setq da (+ da (* 2 pi))))
    (SETQ DA (/ DA 2))
    (IF (= CURVEROT "ccw")(setq midb (+ a1 da))(setq midb (+ a2 da)))
  (setq amp (polar CP midb radius))

  (SETQ BEARING (ANGTOS ANG 1 4))
  (setq bearing (vl-string-subst "d" (chr 176) bearing));added for BricsCAD changes degrees to "d"
  (SETQ DIST (DISTANCE (LIST (CAR P1)(CADR P1))P2))

 (IF (= QROUND "YES")(PROGN

			(SETQ LLEN (DISTANCE (LIST (CAR P1)(CADR P1)) P2))

    ;ASSIGN ROUNDING FOR ANGLES BASED ON DISTANCE
      (IF (< LLEN MAXLEN1) (SETQ ROUND BRND1))
    (IF (AND (> LLEN MAXLEN1)(< LLEN MAXLEN2)) (SETQ ROUND BRND2))
    (IF (> LLEN MAXLEN2)(SETQ ROUND BRND3))

   
    ;GET ANGLE DELIMIETERS
    (SETQ SANG (ANGTOS ANG 1 4))
    (setq sang (vl-string-subst "d" (chr 176) sang));added for BricsCAD changes degrees to "d"
    (setq CHRDPOS (vl-string-position 100 SANG 0))
    (setq MINPOS (vl-string-position 39 SANG 0))
    (setq SECPOS (vl-string-position 34 SANG 0))

    ;PARSE ANGLE
    (setq DEG  (atof (substr SANG 1  CHRDPOS )))
    (setq MINS  (atof (substr SANG (+ CHRDPOS 2)  (-(- MINPOS CHRDPOS)1))))
    (setq SEC  (atof (substr SANG (+ MINPOS 2)  (-(- SECPOS MINPOS )1))))

   
;ROUND ANGLE, NOTE SECONDS REMOVED
     (IF (and (= ROUND 60)(< SEC 30)) (SETQ SEC 0))
    (IF (and (= ROUND 60)(>= SEC 30)) (SETQ SEC 0
					    MINS (+ MINS 1)))	
		       
    (IF (/= ROUND 60) (PROGN
			(SETQ SIP (FIX (/ SEC ROUND)))
			(SETQ SFP (- (/  SEC ROUND) SIP))
			(IF (>= SFP 0.5) (SETQ SIP (+ SIP 1)))
			(SETQ SEC (* SIP ROUND))
			)
      )

    (IF (< LLEN DISTMAX1) (SETQ DROUND DRND1))
    (IF (AND (> LLEN DISTMAX1)(< LLEN DISTMAX2)) (SETQ DROUND DRND2))
    (IF (> LLEN DISTMAX2)(SETQ DROUND DRND3))
			
    (SETQ LIP (FIX (/ LLEN DROUND)))
    (SETQ LFP (- (/ LLEN DROUND) LIP))
    (IF (>= LFP 0.5 ) (SETQ LIP (+ LIP 1)))
    (SETQ LLEN (* LIP DROUND))
    
    (SETQ LDIST (RTOS LLEN 2 3))
    ;(IF (< LLEN 1) (SETQ DTS (STRCAT "0" DTS)))
      
   
		 
    
;STRING ANGLES
    (SETQ DEG (RTOS DEG 2 0))
    (SETQ MINS (RTOS MINS 2 0))
    (SETQ SEC (RTOS SEC 2 0))
    
;INCREMENT IF SECONDS ROUNDED TO 60
    (IF (= SEC  "60")
      (PROGN
	(SETQ SEC "00")
	(SETQ MINS (RTOS (+ (ATOF MINS ) 1) 2 0))
	)
      )
;INCREMENT IF MINUTES ROUNDED TO 60
    (IF (= MINS "60")
      (PROGN
	(SETQ MINS "00")
	(SETQ DEG (RTOS (+ (ATOF DEG ) 1) 2 0))
	)
      )
;FIX IF INCREMENTING PUSHES DEG PAST 360    
    (IF (= DEG "360")(SETQ DEG "0"))
;ADD ZEROS TO SINGLE NUMBERS	
 (IF (= (STRLEN MINS) 1)(SETQ MINS (STRCAT "0" MINS)))
  (IF (= (STRLEN SEC) 1)(SETQ SEC (STRCAT "0" SEC)))

;TRUNCATE BEARINGS IF 00'S
  (IF (AND (= MINS "00") (= SEC "00")) (SETQ MINSS ""
					     MINS ""
					     SECS ""
					     SEC "")
    ;ELSE
        (SETQ MINSS(STRCAT MINS "'")
	  SECS (STRCAT SEC "\""))
	  )
    (IF (= SECS "00\"")(SETQ SECS ""
			     SEC ""))

			

    ;CONCATENATE BEARING
    (SETQ BEARING (STRCAT DEG "d" MINSS SECS ))

			(IF (or (/= sec "")(/= MINS ""))(SETQ DEG (STRCAT DEG ".")))

  (SETQ LBEARING (STRCAT DEG MINS SEC))
			
    

			);P&IF ROUNDING


(PROGN;ELSE

  

  (SETQ DPOS (vl-string-position 100 BEARING 0))
  (setq Wpos (vl-string-position 39 BEARING 0))
  (setq WWpos (vl-string-position 34 BEARING 0))

    (setq DEG (substr BEARING 1 Dpos))
      (setq MINS (substr BEARING (+ Dpos 2) (- (- WPOS DPOS) 1)))
      (setq SEC (substr BEARING (+ Wpos 2) (- (- WWpos Wpos) 1)))

  (IF (= (STRLEN MINS) 1)(SETQ MINS (STRCAT "0" MINS)))
  (IF (= (STRLEN SEC) 1)(SETQ SEC (STRCAT "0" SEC)))
  
  (IF (AND (= MINS "00") (= SEC "00")) (SETQ MINSS ""
					     SECS ""
					     MINS ""
					     SEC "")
    (SETQ MINSS(STRCAT MINS "'")
	  SECS (STRCAT SEC "\""))
	  )
  (IF (= SECS "00\"")(SETQ SECS ""
			   SEC ""))
  
  (SETQ BEARING (STRCAT DEG "d" MINSS SECS ))

  	(IF (or (/= sec "")(/= MINS ""))(SETQ DEG (STRCAT DEG ".")))

  (SETQ LBEARING (STRCAT DEG MINS SEC))
  (SETQ LDIST (RTOS DIST 2 3))

  ));PELSE&IF




   (SETQ MAST (SQRT (- (*  RADIUS  RADIUS) (* (/  DIST 2)(/ DIST 2 )))))





  
  ;(SETQ O (* 2 (ATAN (/ (/  DIST 2) MAST))))
  (SETQ O (- ANG2 ANG1))
  (IF (< O 0) (SETQ O (+ O (* PI 2))))
  	   (setq arclength (rtos ( *  radius O) 2 3))



  
  (setq digchaz (angle p1 p2))
    (SETQ O1 (* 2 (ATAN (/ (/ (distance p1 p2) 2) MAST))))
	    (setq remhalfO  (- (* 0.5 pi) (/ O1 2)))
	    (if (and (= curverot "ccw") (<= (atof arclength) (* pi  radius)))(setq raybearing (+  digchaz  remhalfO)))
	    (IF (and (= curverot "cw") (<= (atof arclength) (* pi  radius)))(setq raybearing (-  digchaz  remhalfO)))
	    (IF (and (= curverot "ccw") (> (atof arclength) (* pi  radius)))(setq raybearing (-  digchaz  remhalfO)))
	    (if (and (= curverot "cw") (> (atof arclength) (* pi  radius)))(setq raybearing (+  digchaz  remhalfO)))

  

  
  
(if (= qround "YES")(progn 
 ;ROUND ALL DISTANCES TO 5MM
    (SETQ LIP (FIX (/ (atof ARCLENGTH) DROUND)))
    (SETQ LFP (- (/ (atof ARCLENGTH) DROUND) LIP))
    (IF (>= LFP 0.5 ) (SETQ LIP (+ LIP 1)))
    (SETQ ARCLENGTH (* LIP DROUND))
    
    (SETQ ARCLENGTH (RTOS ARCLENGTH 2 3))
    ))

  (if (= qround "YES")(progn 
 ;ROUND ALL DISTANCES TO 5MM
    (SETQ LIP (FIX (/ radius DROUND)))
    (SETQ LFP (- (/ radius DROUND) LIP))
    (IF (>= LFP 0.5 ) (SETQ LIP (+ LIP 1)))
    (SETQ radius(* LIP DROUND))
    
   
    ))
  


  

  (COMMAND "ERASE" EN "")
  (SETVAR "CLAYER" layer)
  (COMMAND "ARC" "c" (TRANS CP 0 1) (TRANS P1 0 1) (TRANS P2 0 1 ))

  (if (= mandist 1)(setq arclength (getstring "\nManual Chord Distance:")))
  (if (= mandist 1)(setq radius (getstring "\nManual Radius:")))

  (if ( = notereq 1) (setq comment ( getstring T "\nGeometry Note:")))

  (if (= compile 0)(setq distx (strcat "\" length=\"" arclength "\" arcType=\"Measured\"")
			 azimuthx (strcat "chordAzimuth=\"" lbearing)))
  
  (if (= compile 1)(setq distx (strcat "length=\"" arclength"\" arcType=\"Compiled\"")))
  (if (= compile 2)(setq distx (strcat "length=\"" arclength"\" arcType=\"Measured\"")));strata
  
  (if (= cbrq "Y")(setq  azimuthx (strcat "chordAzimuth=\"" lbearing "\" ")))
  (if (= cbrq "N")(setq  azimuthx ""))

  
      (if (/= comment "")(setq ocomment (strcat "><FieldNote>\"" comment "\"</FieldNote></ReducedArcObservation>"))(setq ocomment "/>"))
(SETQ BDINFO (STRCAT azimuthx distx " radius=\"" (RTOS RADIUS 2 3)  "\" rot=\"ccw\" "   ocomment))
 
(SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 BDINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)

      (setq tp1 p1)
      (setq tp2 p2)
   
      (setq lradius (rtos radius 2 3))
    (if (= cbrq "N")(setq bearing ""))
  
(lbarc);label arc using function



  (SETQ COUNT (+ COUNT 1))

  );R


      (SETVAR "CLAYER" prevlayer)

  );DEFUN
  


;-------------------------------------------------------------ASSIGN POLYLINE TO XML-----------------------------------

(DEFUN C:XAP (/)

  
  (setq prevlayer (getvar "CLAYER"))
(setq areapercent nil)
  (if (= plotno nil) (setq plotno "1"))

 (SETQ SENT (CAR (ENTSEL "\nSelect Polyline:")))
  (setq lotc (getpoint "\nSelect Lot Centre (default Centroid):"))
  

  (SETQ SENTLIST (ENTGET SENT))
    ;go through polyline to get points to check for clockwise direction
  (SETQ ZA (CDR (ASSOC 210 SENTLIST)))
    (SETQ CWLIST (LIST))
	    (foreach a SenTlist
	      (if (= 10 (car a))

		(setq CWLIST (append CWLIST (list (TRANS (cdr a) ZA 0))))
	      )				;IF
	      
	    )				;FOREACH 			

  (IF (> (lcw CWLIST) 0) (command "pedit" sent "r" "" ))
  					(SETQ SENTLIST (ENTGET SENT))

  (if (= lotc nil)(calclotc cwlist));calculate lot center if none

 (SETQ lotno (getstring (strcat "\n Lot Number [" plotno "]:")))
  (if (= lotno "") (setq lotno plotno))
       
   (setq area (getstring "\nArea or [C]alculate (mm.dm) (aa.rr.pp.f/p) [Last]:"))
(if (or (= area "l")(= area "L")(= area "LAST")(= area "last"))(setq area "Last"))

  (if (= area "Last" )(setq area arealast))
  (setq arealast area)

  (if (/= area "")
    (progn


  ;deal with imperial areas
  
      
	(setq dotpos1 (vl-string-position 46 area 0))
	(if (= dotpos1 nil)(setq dotpos2 nil)(setq dotpos2 (vl-string-position 46 area (+ dotpos1 1))))
	(if (/= dotpos2 nil)(progn;idenfited as imperial area, must have second dotpos to work
			      
	(if (= dotpos2 nil)(setq dotpos3 nil)(setq dotpos3 (vl-string-position 46 area (+ dotpos2 1))))
	(setq /pos1 (vl-string-position 47 area 0))
	(if (/= /pos1 nil);with factional part
	  (progn
	    (setq den (substr area ( + /pos1 2) 50))
	    (setq num (substr area ( + dotpos3 2) (- (- /pos1 dotpos3) 1)))
	    (setq fperch (/ (atof num) (atof den)))
	    (setq perch (substr area (+ dotpos2 2) (- (- dotpos3 dotpos2) 1)))
	    (setq perch (+ fperch (atof perch)))
	    (setq rood (substr area (+ dotpos1 2) (- (- dotpos2 dotpos1) 1)))
	    (setq perch (+ perch (* (atof rood) 40)))
	    (setq acre (substr area 1  dotpos1 ))
	    (setq perch (+ perch (* (atof acre) 160)))
	    (setq area (rtos (* perch 25.2929538117) 2 9))
	    )
	  )
	(if (and (/= dotpos1 nil)(/= dotpos2 nil)(= /pos1 nil));without fractional part
	  (progn
	    (setq perch (substr area ( + dotpos2 2) 50))
	    (setq perch (atof perch))
	    (setq rood (substr area (+ dotpos1 2) (- (- dotpos2 dotpos1) 1)))
	    (setq perch (+ perch (* (atof rood) 40)))
	    (setq acre (substr area 1  dotpos1 ))
	    (setq perch (+ perch (* (atof acre) 160)))
	    (setq area (rtos (* perch 25.2929538117) 2 9))
	    )
	  )
	
	));p&if imperial area

   
   (SETQ area1 (vlax-get-property (vlax-ename->vla-object sent ) 'area ))

  (setvar "dimzin" 0)
  (IF (or ( = area "C")(= area "c"))
    (progn
      (setq area (rtos area1 2 3))
      (setq area1 (atof (rtos area1 2 3)));deal with recurring 9's

      (if (= ard "YES")
	(progn
      					    (if (> area1 0)(setq textarea (strcat (rtos (* (fix (/ area1 0.001)) 0.001) 2 3) "m�")))
					    (if (> area1 10)(setq textarea (strcat (rtos (* (fix (/ area1 0.01)) 0.01) 2 2) "m�")))
					    (if (> area1 100)(setq textarea (strcat (rtos (* (fix (/ area1 0.1)) 0.1) 2 1) "m�")))
					    (if (> area1 1000)(setq textarea (strcat (rtos (* (fix (/ area1 1)) 1) 2 0) "m�")))
      					    (if (> area1 10000) (setq textarea (strcat (rtos (* (fix (/ (/ area1 10000) 0.001)) 0.001) 2 3) "ha")))
					    (if (> area1 100000) (setq textarea (strcat (rtos (* (fix (/ (/ area1 10000) 0.01)) 0.01) 2 2) "ha")))
					    (if (> area1 1000000) (setq textarea (strcat (rtos (* (fix (/ (/ area1 10000) 0.1)) 0.1) 2 1) "ha")))
					    (if (> area1 10000000) (setq textarea (strcat (rtos (* (fix (/ (/ area1 10000) 1)) 1) 2 0) "ha")))
                                            (if (> area1 100000000) (setq textarea (strcat (rtos (* (fix (/ (/ area1 1000000) 0.1)) 0.1) 2 1) "km�")))
                                            (if (> area1 1000000000) (setq textarea (strcat (rtos (* (fix (/ (/ area1 1000000) 1)) 1) 2 0) "km�")))
	  )
	(progn
	        			    (if (> area1 0)(setq textarea (strcat (rtos   area1 2 3) "m�")))
					    (if (> area1 10)(setq textarea (strcat (rtos   area1  2 2) "m�")))
					    (if (> area1 100)(setq textarea (strcat (rtos  area1  2 1) "m�")))
					    (if (> area1 1000)(setq textarea (strcat (rtos area1  2 0) "m�")))
      					    (if (> area1 10000) (setq textarea (strcat (rtos  (/ area1 10000)  2 3) "ha")))
					    (if (> area1 100000) (setq textarea (strcat (rtos  (/ area1 10000)  2 2) "ha")))
					    (if (> area1 1000000) (setq textarea (strcat (rtos  (/ area1 10000)  2 1) "ha")))
					    (if (> area1 10000000) (setq textarea (strcat (rtos   (/ area1 10000) 2 0) "ha")))
                                            (if (> area1 100000000) (setq textarea (strcat (rtos (/ area1 1000000)  2 1) "km�")))
                                            (if (> area1 1000000000) (setq textarea (strcat (rtos  (/ area1 1000000) 2 0) "km�")))

      ));if ard
      
					    
      )
    (progn
     (setq areapercent (ABS(* (/  (- area1 (ATOF area)) area1) 100)))
     (if (> areapercent 10) (alert (strcat "\nArea different to calulated by " (rtos areapercent 2 0)"%")))
 (if (= ard "YES")
	(progn
                                            (if (> (atof area) 1)(setq textarea (strcat (rtos (atof area) 2 3) "m�")))
      					    (if (> (atof area) 0)(setq textarea (strcat (rtos (* (fix (+(/ (atof area) 0.001)0.00001)) 0.001)  2 3) "m�")))
					    (if (> (atof area) 10)(setq textarea (strcat (rtos (* (fix (+ (/ (atof area) 0.01) 0.00001)) 0.01) 2 2) "m�")))
					    (if (> (atof area) 100)(setq textarea (strcat (rtos (* (fix (+(/ (atof area) 0.1) 0.00001)) 0.1) 2 1) "m�")))
					    (if (> (atof area) 1000)(setq textarea (strcat (rtos (* (fix (+(/ (atof area) 1)0.00001)) 1) 2 0) "m�")))
      					    (if (> (atof area) 10000) (setq textarea (strcat (rtos (* (fix (+(/ (/ (atof area) 10000) 0.001)0.00001)) 0.001) 2 3) "ha")))
					    (if (> (atof area) 100000) (setq textarea (strcat (rtos (* (fix (+(/ (/ (atof area) 10000) 0.01)0.00001)) 0.01) 2 2) "ha")))
					    (if (> (atof area) 1000000) (setq textarea (strcat (rtos (* (fix (+(/ (/ (atof area) 10000) 0.1)0.00001)) 0.1) 2 1) "ha")))
					    (if (> (atof area) 10000000) (setq textarea (strcat (rtos (* (fix (+(/ (/ (atof area) 10000) 1)0.00001)) 1) 2 0) "ha")))
                                            (if (> (atof area) 100000000) (setq textarea (strcat (rtos (* (fix (+ (/ (/ (atof area) 1000000) 0.1)0.00001)) 0.1) 2 1) "km�")))
                                            (if (> (atof area) 1000000000) (setq textarea (strcat (rtos (* (fix (+(/ (/ (atof area) 1000000) 1)0.00001)) 1) 2 0) "km�")))
	  )
   (progn
           			    (if (> area1 0)(setq textarea (strcat (rtos   area 2 3) "m�")))
					    (if (> area1 10)(setq textarea (strcat (rtos   area  2 2) "m�")))
					    (if (> area1 100)(setq textarea (strcat (rtos  area  2 1) "m�")))
					    (if (> area1 1000)(setq textarea (strcat (rtos area  2 0) "m�")))
      					    (if (> area1 10000) (setq textarea (strcat (rtos  (/ area 10000)  2 3) "ha")))
					    (if (> area1 100000) (setq textarea (strcat (rtos  (/ area 10000)  2 2) "ha")))
					    (if (> area1 1000000) (setq textarea (strcat (rtos  (/ area 10000)  2 1) "ha")))
					    (if (> area1 10000000) (setq textarea (strcat (rtos   (/ area 10000) 2 0) "ha")))
                                            (if (> area1 100000000) (setq textarea (strcat (rtos (/ area 1000000)  2 1) "km�")))
                                            (if (> area1 1000000000) (setq textarea (strcat (rtos  (/ area 1000000) 2 0) "km�")))
     ));if ard

     )
    )
      ));if area exists
  (setvar "dimzin" 8)
    (setq lotstate (getstring "\nProposed or Existing (P/E)[P]:"))
  (if (or (= lotstate "p")(= lotstate "P"))(setq lotstate "proposed"))
  (if (or (= lotstate "e")(= lotstate "E"))(setq lotstate "existing"))
  (if (= lotstate "")(setq lotstate "proposed"))

  (if (= (substr lotno 1 2) "PT")(setq pcltype " parcelType=\"Part\""
				     lotno (substr lotno 3 50)
				       desc "\" desc=\"PT"
				       textarea (strcat "(" textarea ")")
				       )
    (setq pcltype " parcelType=\"Single\""
	  desc ""
	  )
    )

  (setq lotc (trans lotc 1 0));convert to world if using UCS

  (if (/= area "")(setq areas (strcat " area=\"" area "\""))(setq areas ""))

    ;<Parcel name="30" class="Lot" state="proposed" parcelType="Single" parcelFormat="Standard" area="951.8">
  (SETQ LTINFO (STRCAT "  <Parcel name=\"" lotno "\" class=\"Lot\" state=\"" lotstate "\"" pcltype " parcelFormat=\"Standard\"" areas ">!" (rtos (cadr lotc) 2 6 ) " " (rtos (car lotc) 2 6)))
(SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 LTINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (SETQ NEWSENTLIST (subst (cons 8 "Lot Definitions")(assoc 8 NEWSENTLIST) NEWSENTLIST ))
  (ENTMOD NEWSENTLIST)

  (if (= desc "\" desc=\"PT")(setq lotnos (strcat "PT" lotno))(setq lotnos  lotno))

(setq lotc (trans lotc 0 1));convert back to UCS if using one

  (SETVAR "CELWEIGHT" 50)
  (SETVAR "CLAYER"  "Drafting" )
  (setq areapos (polar lotc (* 1.5 pi) (* th 2.5)))
  (COMMAND "TEXT" "J" "BC" lotc (* TH 2) "90" lotnos)
  (SETVAR "CELWEIGHT" 35)
  (if (/= area "")(COMMAND "TEXT" "J" "BC" areapos (* TH 1.4) "90"  textarea ))
(SETVAR "CELWEIGHT" -1)
  (if (/= (atof lotno) 0)(setq plotno (rtos (+ (atof lotno) 1) 2 0)))  
  
  (if (/= (atof lotno) 0)(setq plotno (rtos (+ (atof lotno) 1) 2 0)))  

  (COMMAND "DRAWORDER" SENT "" "BACK")

      (SETVAR "CLAYER" prevlayer)

   (IF (/= areapercent NIL)(PRINC (strcat "\nArea different to calulated by " (rtos areapercent 2 0)"%")))
  );DEFUN



;-------------------------------------------------------------ASSIGN ADJOINING POLYLINE TO XML-----------------------------------

(DEFUN C:XJL (/)

  
  (setq prevlayer (getvar "CLAYER"))
(setq areapercent nil)
  (if (= plotno nil) (setq plotno "1"))

 (SETQ SENT (CAR (ENTSEL "\nSelect Polyline:")))
  (setq lotc (getpoint "\nSelect Lot Centre (centroid):"))

  (SETQ SENTLIST (ENTGET SENT))
    ;go through polyline to get points to check for clockwise direction
  (SETQ ZA (CDR (ASSOC 210 SENTLIST)))
    (SETQ CWLIST (LIST))
	    (foreach a SenTlist
	      (if (= 10 (car a))

		(setq CWLIST (append CWLIST (list (TRANS (cdr a) ZA 0))))
	      )				;IF
	      
	    )				;FOREACH 			

  (IF (> (lcw CWLIST) 0) (command "pedit" sent "r" "" ))
  					(SETQ SENTLIST (ENTGET SENT))
(if (= lotc nil)(calclotc cwlist));calculate lot center if none
  
 (SETQ lotno (getstring T (strcat "\n Lot and DPnumber:")))
  (if (/= (setq stringpos (vl-string-search "//" lotno )) nil)(SETQ lotno (vl-string-subst "/" "//" lotno)))
  (if (= lotno "") (setq lotno plotno))
       
   
  
  (setvar "dimzin" 8)
    (setq lotstate "adjoining")
  (if (= lotstate "")(setq lotstate "proposed"))

  (if (= (substr lotno 1 2) "PT")(setq pcltype " parcelType=\"Part\""
				     lotno (substr lotno 3 50)
				       desc "\" desc=\"PT"
				       )
    (setq pcltype " parcelType=\"Single\""
	  desc "")
    )
  (setq lotc (trans lotc 1 0));convert to world if using UCS

    ;<Parcel name="30" class="Lot" state="proposed" parcelType="Single" parcelFormat="Standard" area="951.8">
  (SETQ LTINFO (STRCAT "  <Parcel name=\"" lotno "\" class=\"Lot\" state=\"" lotstate "\"" pcltype " parcelFormat=\"Standard\">!" (rtos (cadr lotc) 2 6 ) " " (rtos (car lotc) 2 6)))
(SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 LTINFO)))))
  
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (SETQ NEWSENTLIST (subst (cons 8 "Adjoining Boundary")(assoc 8 NEWSENTLIST) NEWSENTLIST ))
  (ENTMOD NEWSENTLIST)

  (if (= desc "\" desc=\"PT")(setq lotnos (strcat "PT" lotno))(setq lotnos  lotno))


(setq lotc (trans lotc 0 1));convert to world if using UCS
  (SETVAR "CELWEIGHT" -1)
  (SETVAR "CLAYER"  "Drafting" )
  (COMMAND "TEXT" "J" "BC" lotc (* TH 2) "90" lotnos)
  
  
  (COMMAND "DRAWORDER" SENT "" "BACK")

      (SETVAR "CLAYER" prevlayer)

  );DEFUN






;-----------------------------------------------------------------------------Assign Polyline to XML Easement----------------------------------------------------
(defun C:XAE (/)

  (setq prevlayer (getvar "CLAYER"))
(easecount)
  (if (= plotno nil) (setq plotno "1"))
(easecount)
 (SETQ SENT (CAR (ENTSEL "\nSelect Polyline:")))
  (setq lotc (getpoint "\nSelect Lot Centre(centroid):"))
 
  
  (SETQ SENTLIST (ENTGET SENT))
    ;go through polyline to get points to check for clockwise direction
  (SETQ ZA (CDR (ASSOC 210 SENTLIST)))
    (SETQ CWLIST (LIST))
	    (foreach a SenTlist
	      (if (= 10 (car a))

		(setq CWLIST (append CWLIST (list (TRANS (cdr a) ZA 0))))
	      )				;IF
	      
	    )				;FOREACH 			

  (IF (> (lcw CWLIST) 0) (command "pedit" sent "r" "" ))
  					(SETQ SENTLIST (ENTGET SENT))
(if (= lotc nil)(calclotc cwlist));calculate lot center if none
  
  (SETQ PTLIST (LIST))
				
;CREATE LIST OF POLYLINE POINTS
    (SETQ PTLIST (LIST))
	    (foreach a SENTLIST
	      (if (= 10 (car a))

		(setq PTLIST (append PTLIST (list (cdr a))))
	      )				;IF
	     
	    )				;FOREACH 			)

(setq ptlist (append ptlist (list(nth 0 ptlist))))

  (setq class (getstring T (strcat "Type of Interest (* for list) [" peclass "]:")))
  (if (= class "")(setq class peclass))
    ;execute list finder
  (if (= class "*")(progn
		      (setq workingselnum tselnum)
		      (setq names interestlist)
		      (dbox)
		      (setq class returntype)
		      (setq tselnum workingselnum)
		      )
    )
	(setq peclass class)
  
  
 (SETQ lotno (getstring T (STRCAT "\n Easement Description (" ped "):")))
(if (and (/= ped "")(= lotno ""))(setq lotno ped))
  (SETQ ped lotno)
  
  
  
    (setq lotstate (getstring  "\nProposed/Existing/Adjoining (P/E/A) [P]:"))
  (if (or (= lotstate "p")(= lotstate "P"))(setq lotstate "proposed"))
  (if (or (= lotstate "e")(= lotstate "E"))(setq lotstate "existing"))
  (if (or (= lotstate "a")(= lotstate "A"))(setq lotstate "adjoining"))
  (if (= lotstate "")(setq lotstate "proposed"))
    (setq lotc (trans lotc 1 0));convert to world if using UCS
  (SETQ LTINFO (STRCAT "<Parcel name=\"E" (rtos easecounter 2 0) "\" desc=\"" lotno "\" class=\"" class "\" state=\"" lotstate "\" parcelType=\"Single\" parcelFormat=\"Standard\">!"
		       (rtos (cadr lotc) 2 6 ) " " (rtos (car lotc) 2 6)))
(SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 LTINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (if (or (= lotstate "proposed")(= lotstate "existing"))(progn 
  (SETQ NEWSENTLIST (subst (cons 8 "Lot Definitions")(assoc 8 NEWSENTLIST) NEWSENTLIST ))
  ))
  (if (or (= lotstate "adjoining")(= lotstate "existing"))(progn 
  (SETQ NEWSENTLIST (subst (cons 8 "Adjoining Boundary")(assoc 8 NEWSENTLIST) NEWSENTLIST ))
  (command "change" sent "" "properties" "ltype" "EASEMENT" "")
  ))
  (ENTMOD NEWSENTLIST)

  (setq THF 1)
(setq lotc (trans lotc 0 1));convert back to UCS
  (setq easelabelpos (polar lotc (* 1.5 pi) (* th 1.1)))
  (SETVAR "CLAYER"  "Drafting" )

   (if (= (substr lotno 1 1) "(")(progn
				 (setq cbpos1 (vl-string-position 41 lotno 0))
				 (setq easeletter  (substr lotno 1 (+ cbpos1 1)))
				  (setvar "clayer" "Lot definitions")
				(COMMAND "TEXT" "J" "MC" easelabelpos (* TH 0.75) "90" (strcat  "E" (rtos easecounter)  ))
				 (setvar "clayer" "Drafting")
				 (COMMAND "TEXT" "J" "MC" lotc (* TH 1.4) "90" (strcat easeletter ))
					    
					    )
						 
(COMMAND "TEXT" "J" "MC" lotc (* TH THF) "90" (strcat "E" (rtos easecounter)))
						   );if first character is bracket
       (setq roadname (entget (entlast)))

   (SETVAR "CLAYER" prevlayer)

(setq lotc (trans lotc 1 0));convert to world if using UCS

    
		(setq count 0)
		(setq minoff 100000000000000000000000000000000000000)
(repeat (- (length ptlist)2 )

  (setq op1 (nth count ptlist))
  (setq op2 (nth (+ count 1) ptlist))
  (setq op3 (nth (+ count 2) ptlist))



  ;check line one
;check offset to line
  (SETQ ANG (ANGLE oP1 oP2))
  (SETQ CANG (+ ANG (/ PI 2)))
  (SETQ P4 (POLAR lotc CANG 50))
  (SETQ P6 (POLAR lotc (+ CANG PI) 50))
   
  (IF (SETQ P5 (INTERS oP1 oP2 P6 P4 ))(PROGN
					
 
      (SETQ OFF (DISTANCE lotc P5))

    (if (< OFF (ABS MINOFF))(SETQ minoff (abs off)
				  nearang cang))
     
    
  ));p & if inters

    ;check inside deflection angle
    (setq ang2 (angle op2 op3))
    (setq cang2 (+ ang (/ pi 2)))
    (setq ltopang (angle op2 lotc))
    (setq defl (- ang2 ang))
(if (/= defl 0);check for straight line
  (progn
    (if (< defl pi)(progn
		     (setq ray1 (- ang (/ pi 2)))
		     ;(if (< ray1 0) (setq ray1 (+ ray1 (* 2 pi))))
		     (setq ray2 (- ang2 (/ pi 2)))
		     ;(if (< ray2 0) (setq ray2 (+ ray2 (* 2pi))))
		     ));p and if less than pi
    (if (> defl pi)(progn
		     (setq ray1 (+ ang (/ pi 2)))
		     ;(if (> ray1 (* 2 pi)(setq ray1 (- ray1 (* 2 pi)))))
		     (setq ray2 (+ ang (/ pi 2)))
		     ;(if (> ray2 (* 2 pi)(setq ray2 (- ray2 (* 2 pi)))))
		     ));p and if greater than pi

    (if (or (and (> ltopang ray1) (< ltopang ray2))(and (> ltopang ray2)(< ltopang ray1)));check ot see if inside deflection squares **** needs testing later
      (progn
	(setq off (distance lotc op2))
(if (< OFF (ABS MINOFF))(SETQ minoff (abs off)
				  nearang ltopang)
      );if
	));p and if in defl sqr
   ));p and if not straight line

  (setq count (+ count 1))
    );repeat
      
				;using this info change the road name text rotation to the angle of the line
		(setq rrot (+ nearang (/ pi 2)))
		(if (> rrot (* 2 pi))(setq rrot (- rrot (* 2 pi))))
		(IF (AND (> rrot  (* 0.5 pi)) (< rrot (* 1.5 pi)))(setq rrot (+ rrot pi))) ;if text is upsidedown reverse rotation
					  
		
    
  (SETQ	roadname (subst (cons 50  rrot);SUB IN NEW POINT 2 HEIGHT
		     (assoc 50 roadname)
		     roadname     ) )
  (ENTMOD roadname)
(COMMAND "DRAWORDER" SENT "" "BACK")
  )

;------------------------------------------------------Assign polyline to XML Road----------------------------------------------

(defun C:XAR (/)

 (setq prevlayer (getvar "CLAYER"))

  (if (= plotno nil) (setq plotno "1"))

 (SETQ SENT (CAR (ENTSEL "\nSelect Polyline:")))
  (setq lotc (getpoint "\nSelect Lot Centre (centroid):"))

  
  (SETQ SENTLIST (ENTGET SENT))
    ;go through polyline to get points to check for clockwise direction
  (SETQ ZA (CDR (ASSOC 210 SENTLIST)))
    (SETQ CWLIST (LIST))
	    (foreach a SenTlist
	      (if (= 10 (car a))

		(setq CWLIST (append CWLIST (list (TRANS (cdr a) ZA 0))))
	      )				;IF
	      
	    )				;FOREACH 			

  (IF (> (lcw CWLIST) 0) (command "pedit" sent "r" "" ))
  					(SETQ SENTLIST (ENTGET SENT))
(if (= lotc nil)(calclotc cwlist));calculate lot center if none
  
  (SETQ PTLIST (LIST))
				
;CREATE LIST OF POLYLINE POINTS
    (SETQ PTLIST (LIST))
	    (foreach a SENTLIST
	      (if (= 10 (car a))

		(setq PTLIST (append PTLIST (list (cdr a))))
	      )				;IF
	     
	    )				;FOREACH 			)


  (setq ptlist (append ptlist (list (nth 0 ptlist))))
  
 (SETQ lotno (getstring T"\n Road Name:"))
  
    (setq lotstate (getstring  "\nProposed or Existing (P/E) [P]:"))
  (if (or (= lotstate "p")(= lotstate "P"))(setq lotstate "proposed"))
  (if (or (= lotstate "e")(= lotstate "E"))(setq lotstate "existing"))
  (if (= lotstate "")(setq lotstate "proposed"))


  (setq area (getstring "\nArea or [C]alculate (mm.dm) (aa.rr.pp.f/p) [Last]:"))
(if (or (= area "l")(= area "L")(= area "LAST")(= area "last"))(setq area "Last"))

  (if (= area "Last" )(setq area arealast))
  (SETQ arealast area)



    
(if (/= area "")
  (progn
  ;deal with imperial areas
  
      
	(setq dotpos1 (vl-string-position 46 area 0))
	(if (= dotpos1 nil)(setq dotpos2 nil)(setq dotpos2 (vl-string-position 46 area (+ dotpos1 1))))
	(if (/= dotpos2 nil)(progn;idenfited as imperial area, must have second dotpos to work
			      
	(if (= dotpos2 nil)(setq dotpos3 nil)(setq dotpos3 (vl-string-position 46 area (+ dotpos2 1))))
	(setq /pos1 (vl-string-position 47 area 0))
	(if (/= /pos1 nil);with factional part
	  (progn
	    (setq den (substr area ( + /pos1 2) 50))
	    (setq num (substr area ( + dotpos3 2) (- (- /pos1 dotpos3) 1)))
	    (setq fperch (/ (atof num) (atof den)))
	    (setq perch (substr area (+ dotpos2 2) (- (- dotpos3 dotpos2) 1)))
	    (setq perch (+ fperch (atof perch)))
	    (setq rood (substr area (+ dotpos1 2) (- (- dotpos2 dotpos1) 1)))
	    (setq perch (+ perch (* (atof rood) 40)))
	    (setq acre (substr area 1  dotpos1 ))
	    (setq perch (+ perch (* (atof acre) 160)))
	    (setq area (rtos (* perch 25.2929538117) 2 9))
	    )
	  )
	(if (and (/= dotpos1 nil)(/= dotpos2 nil)(= /pos1 nil));without fractional part
	  (progn
	    (setq perch (substr area ( + dotpos2 2) 50))
	    (setq perch (atof perch))
	    (setq rood (substr area (+ dotpos1 2) (- (- dotpos2 dotpos1) 1)))
	    (setq perch (+ perch (* (atof rood) 40)))
	    (setq acre (substr area 1  dotpos1 ))
	    (setq perch (+ perch (* (atof acre) 160)))
	    (setq area (rtos (* perch 25.2929538117) 2 9))
	    )
	  )
	
	));p&if imperial area
	  




  
   
   (SETQ area1 (vlax-get-property (vlax-ename->vla-object sent ) 'area ))

  (setvar "dimzin" 0)
  (IF (or ( = area "C")(= area "c"))
    (progn
      (setq area (rtos area1 2 3))
      (setq area1 (atof (rtos area1 2 3)));deal with recurring 9's

      (if (= ard "YES")
	(progn
      					    (if (> area1 0)(setq textarea (strcat (rtos (* (fix (/ area1 0.001)) 0.001) 2 3) "m�")))
					    (if (> area1 10)(setq textarea (strcat (rtos (* (fix (/ area1 0.01)) 0.01) 2 2) "m�")))
					    (if (> area1 100)(setq textarea (strcat (rtos (* (fix (/ area1 0.1)) 0.1) 2 1) "m�")))
					    (if (> area1 1000)(setq textarea (strcat (rtos (* (fix (/ area1 1)) 1) 2 0) "m�")))
      					    (if (> area1 10000) (setq textarea (strcat (rtos (* (fix (/ (/ area1 10000) 0.001)) 0.001) 2 3) "ha")))
					    (if (> area1 100000) (setq textarea (strcat (rtos (* (fix (/ (/ area1 10000) 0.01)) 0.01) 2 2) "ha")))
					    (if (> area1 1000000) (setq textarea (strcat (rtos (* (fix (/ (/ area1 10000) 0.1)) 0.1) 2 1) "ha")))
					    (if (> area1 10000000) (setq textarea (strcat (rtos (* (fix (/ (/ area1 10000) 1)) 1) 2 0) "ha")))
                                            (if (> area1 100000000) (setq textarea (strcat (rtos (* (fix (/ (/ area1 1000000) 0.1)) 0.1) 2 1) "km�")))
                                            (if (> area1 1000000000) (setq textarea (strcat (rtos (* (fix (/ (/ area1 1000000) 1)) 1) 2 0) "km�")))
	  )
	(progn
	        			    (if (> area1 0)(setq textarea (strcat (rtos   area1 2 3) "m�")))
					    (if (> area1 10)(setq textarea (strcat (rtos   area1  2 2) "m�")))
					    (if (> area1 100)(setq textarea (strcat (rtos  area1  2 1) "m�")))
					    (if (> area1 1000)(setq textarea (strcat (rtos area1  2 0) "m�")))
      					    (if (> area1 10000) (setq textarea (strcat (rtos  (/ area1 10000)  2 3) "ha")))
					    (if (> area1 100000) (setq textarea (strcat (rtos  (/ area1 10000)  2 2) "ha")))
					    (if (> area1 1000000) (setq textarea (strcat (rtos  (/ area1 10000)  2 1) "ha")))
					    (if (> area1 10000000) (setq textarea (strcat (rtos   (/ area1 10000) 2 0) "ha")))
                                            (if (> area1 100000000) (setq textarea (strcat (rtos (/ area1 1000000)  2 1) "km�")))
                                            (if (> area1 1000000000) (setq textarea (strcat (rtos  (/ area1 1000000) 2 0) "km�")))

      ));if ard
      
					    
      )
    (progn
     (setq areapercent (ABS(* (/  (- area1 (ATOF area)) area1) 100)))
     (if (> areapercent 10) (alert (strcat "\nArea different to calulated by " (rtos areapercent 2 0)"%")))
 (if (= ard "YES")
	(progn
                                            (if (> (atof area) 1)(setq textarea (strcat (rtos (atof area) 2 3) "m�")))
      					    (if (> (atof area) 0)(setq textarea (strcat (rtos (* (fix (+(/ (atof area) 0.001)0.00001)) 0.001)  2 3) "m�")))
					    (if (> (atof area) 10)(setq textarea (strcat (rtos (* (fix (+ (/ (atof area) 0.01) 0.00001)) 0.01) 2 2) "m�")))
					    (if (> (atof area) 100)(setq textarea (strcat (rtos (* (fix (+(/ (atof area) 0.1) 0.00001)) 0.1) 2 1) "m�")))
					    (if (> (atof area) 1000)(setq textarea (strcat (rtos (* (fix (+(/ (atof area) 1)0.00001)) 1) 2 0) "m�")))
      					    (if (> (atof area) 10000) (setq textarea (strcat (rtos (* (fix (+(/ (/ (atof area) 10000) 0.001)0.00001)) 0.001) 2 3) "ha")))
					    (if (> (atof area) 100000) (setq textarea (strcat (rtos (* (fix (+(/ (/ (atof area) 10000) 0.01)0.00001)) 0.01) 2 2) "ha")))
					    (if (> (atof area) 1000000) (setq textarea (strcat (rtos (* (fix (+(/ (/ (atof area) 10000) 0.1)0.00001)) 0.1) 2 1) "ha")))
					    (if (> (atof area) 10000000) (setq textarea (strcat (rtos (* (fix (+(/ (/ (atof area) 10000) 1)0.00001)) 1) 2 0) "ha")))
                                            (if (> (atof area) 100000000) (setq textarea (strcat (rtos (* (fix (+ (/ (/ (atof area) 1000000) 0.1)0.00001)) 0.1) 2 1) "km�")))
                                            (if (> (atof area) 1000000000) (setq textarea (strcat (rtos (* (fix (+(/ (/ (atof area) 1000000) 1)0.00001)) 1) 2 0) "km�")))
	  )
   (progn
           			    (if (> area1 0)(setq textarea (strcat (rtos   area 2 3) "m�")))
					    (if (> area1 10)(setq textarea (strcat (rtos   area  2 2) "m�")))
					    (if (> area1 100)(setq textarea (strcat (rtos  area  2 1) "m�")))
					    (if (> area1 1000)(setq textarea (strcat (rtos area  2 0) "m�")))
      					    (if (> area1 10000) (setq textarea (strcat (rtos  (/ area 10000)  2 3) "ha")))
					    (if (> area1 100000) (setq textarea (strcat (rtos  (/ area 10000)  2 2) "ha")))
					    (if (> area1 1000000) (setq textarea (strcat (rtos  (/ area 10000)  2 1) "ha")))
					    (if (> area1 10000000) (setq textarea (strcat (rtos   (/ area 10000) 2 0) "ha")))
                                            (if (> area1 100000000) (setq textarea (strcat (rtos (/ area 1000000)  2 1) "km�")))
                                            (if (> area1 1000000000) (setq textarea (strcat (rtos  (/ area 1000000) 2 0) "km�")))
     ));if ard

     )
    )
    ));if there is an area
  (setvar "dimzin" 8)


  
  
   (if (/= area "")(setq areas (strcat " area=\"" area "\""))(setq areas ""))



  
    (setq lotc (trans lotc 1 0));convert to world if using UCS
  (SETQ LTINFO (STRCAT "desc=\"" lotno "\" class=\"Road\" state=\"" lotstate "\" parcelType=\"Single\" parcelFormat=\"Standard\"" areas " >!"
		       (rtos (cadr lotc) 2 6 ) " " (rtos (car lotc) 2 6)))
(SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 LTINFO)))))
  
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (SETQ NEWSENTLIST (subst (cons 8 "Lot Definitions")(assoc 8 NEWSENTLIST) NEWSENTLIST ))
  (ENTMOD NEWSENTLIST)

  (setq THF 2)

 (if (= area "") (setq just "MC")(setq just "BC"));if area exists set justification to bottom centre

  (setq lotc (trans lotc 0 1));convert back to UCS
  (SETVAR "CLAYER"  "Drafting" )
	(SETVAR "CELWEIGHT" 50)				
  (COMMAND "TEXT" "J" just lotc (* TH THF) "90" lotno)
       (setq roadname (entget (entlast)))
 
  
(SETVAR "CELWEIGHT" -1)

  

(setq lotc (trans lotc 1 0));convert to world if using UCS
    
		(setq count 0)
		(setq minoff 100000000000000000000000000000000000000)
(repeat (- (length ptlist)2 )

  (setq op1 (nth count ptlist))
  (setq op2 (nth (+ count 1) ptlist))
  (setq op3 (nth (+ count 2) ptlist))



  ;check line one
;check offset to line
  (SETQ ANG (ANGLE oP1 oP2))
  (SETQ CANG (+ ANG (/ PI 2)))
  (SETQ P4 (POLAR lotc CANG 1000))
  (SETQ P6 (POLAR lotc (+ CANG PI) 2000))
  (IF (SETQ P5 (INTERS oP1 oP2 P6 P4 ))(PROGN

					 (SETQ OFF (DISTANCE lotc P5))

    (if (< OFF (ABS MINOFF))(SETQ minoff (abs off)
				  nearang cang)
      );if
    
  ));p & if inters

    ;check inside deflection angle
    (setq ang2 (angle op2 op3))
    (setq cang2 (+ ang (/ pi 2)))
    (setq ltopang (angle op2 lotc))
    (setq defl (- ang2 ang))
(if (/= defl 0);check for straight line
  (progn
    (if (< defl pi)(progn
		     (setq ray1 (- ang (/ pi 2)))
		     ;(if (< ray1 0) (setq ray1 (+ ray1 (* 2 pi))))
		     (setq ray2 (- ang2 (/ pi 2)))
		     ;(if (< ray2 0) (setq ray2 (+ ray2 (* 2pi))))
		     ));p and if less than pi
    (if (> defl pi)(progn
		     (setq ray1 (+ ang (/ pi 2)))
		     ;(if (> ray1 (* 2 pi)(setq ray1 (- ray1 (* 2 pi)))))
		     (setq ray2 (+ ang (/ pi 2)))
		     ;(if (> ray2 (* 2 pi)(setq ray2 (- ray2 (* 2 pi)))))
		     ));p and if greater than pi

    (if (or (and (> ltopang ray1) (< ltopang ray2))(and (> ltopang ray2)(< ltopang ray1)));check ot see if inside deflection squares **** needs testing later
      (progn
	(setq off (distance lotc op2))
(if (< OFF (ABS MINOFF))(SETQ minoff (abs off)
				  nearang ltopang)
      );if
	));p and if in defl sqr
   ));p and if not straight line

  (setq count (+ count 1))
    );repeat
      
				;using this info change the road name text rotation to the angle of the line
		(setq rrot (+ nearang (/ pi 2)))
		(if (> rrot (* 2 pi))(setq rrot (- rrot (* 2 pi))))
		(IF (AND (> rrot  (* 0.5 pi)) (< rrot (* 1.5 pi)))(setq rrot (+ rrot pi))) ;if text is upsidedown reverse rotation
					  
		
    
  (SETQ	roadname (subst (cons 50  rrot);SUB IN NEW POINT 2 HEIGHT
		     (assoc 50 roadname)
		     roadname     ) )
  (ENTMOD roadname)


  
  ;add area if there is one
  (setq areapos (polar lotc (+ (* 1.5 pi) rrot) (* th 2.5)))
  
   (if (/= area "")(COMMAND "TEXT" "J" just areapos (* TH 1.4) (angtos rrot)  textarea ))
(SETVAR "CELWEIGHT" -1)
  
    (SETVAR "CLAYER" prevlayer) 



  
(COMMAND "DRAWORDER" SENT "" "BACK")
  )



;------------------------------------------------------Assign Adjoining polyline to XML Road----------------------------------------------

(defun C:XJR (/)

 (setq prevlayer (getvar "CLAYER"))

  (if (= plotno nil) (setq plotno "1"))

 (SETQ SENT (CAR (ENTSEL "\nSelect Polyline:")))
  (setq lotc (getpoint "\nSelect Lot Centre (centroid):"))

  
 (SETQ SENTLIST (ENTGET SENT))
    ;go through polyline to get points to check for clockwise direction
  (SETQ ZA (CDR (ASSOC 210 SENTLIST)))
    (SETQ CWLIST (LIST))
	    (foreach a SenTlist
	      (if (= 10 (car a))

		(setq CWLIST (append CWLIST (list (TRANS (cdr a) ZA 0))))
	      )				;IF
	      
	    )				;FOREACH 			

  (IF (> (lcw CWLIST) 0) (command "pedit" sent "r" "" ))
  					(SETQ SENTLIST (ENTGET SENT))
(if (= lotc nil)(calclotc cwlist));calculate lot center if none
  
  (SETQ PTLIST (LIST))
				
;CREATE LIST OF POLYLINE POINTS
    (SETQ PTLIST (LIST))
	    (foreach a SENTLIST
	      (if (= 10 (car a))

		(setq PTLIST (append PTLIST (list (cdr a))))
	      )				;IF
	     
	    )				;FOREACH 			)


  (setq ptlist (append ptlist (list (nth 0 ptlist))))
  
 (SETQ lotno (getstring T"\n Road Name:"))
  
    
  (setq lotstate "adjoining")
    (setq lotc (trans lotc 1 0));convert to world if using UCS
  (SETQ LTINFO (STRCAT "desc=\"" lotno "\" class=\"Road\" state=\"" lotstate "\" parcelType=\"Single\" parcelFormat=\"Standard\">!"
		       (rtos (cadr lotc) 2 6 ) " " (rtos (car lotc) 2 6)))
(SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 LTINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (SETQ NEWSENTLIST (subst (cons 8 "Adjoining Boundary")(assoc 8 NEWSENTLIST) NEWSENTLIST ))
  (ENTMOD NEWSENTLIST)

  (setq THF 2)
(setq lotc (trans lotc 0 1));convert back to UCS
  (SETVAR "CLAYER"  "Drafting" )
	(SETVAR "CELWEIGHT" 50)				
  (COMMAND "TEXT" "J" "MC" lotc (* TH THF) "90" lotno)
       (setq roadname (entget (entlast)))
(SETVAR "CELWEIGHT" -1)
   (SETVAR "CLAYER" prevlayer) 


(setq lotc (trans lotc 1 0));convert to world if using UCS
    
		(setq count 0)
		(setq minoff 100000000000000000000000000000000000000)
(repeat (- (length ptlist)2 )

  (setq op1 (nth count ptlist))
  (setq op2 (nth (+ count 1) ptlist))
  (setq op3 (nth (+ count 2) ptlist))



  ;check line one
;check offset to line
  (SETQ ANG (ANGLE oP1 oP2))
  (SETQ CANG (+ ANG (/ PI 2)))
  (SETQ P4 (POLAR lotc CANG 1000))
  (SETQ P6 (POLAR lotc (+ CANG PI) 2000))
  (IF (SETQ P5 (INTERS oP1 oP2 P6 P4 ))(PROGN

					 (SETQ OFF (DISTANCE lotc P5))

    (if (< OFF (ABS MINOFF))(SETQ minoff (abs off)
				  nearang cang)
      );if
    
  ));p & if inters

    ;check inside deflection angle
    (setq ang2 (angle op2 op3))
    (setq cang2 (+ ang (/ pi 2)))
    (setq ltopang (angle op2 lotc))
    (setq defl (- ang2 ang))
(if (/= defl 0);check for straight line
  (progn
    (if (< defl pi)(progn
		     (setq ray1 (- ang (/ pi 2)))
		     ;(if (< ray1 0) (setq ray1 (+ ray1 (* 2 pi))))
		     (setq ray2 (- ang2 (/ pi 2)))
		     ;(if (< ray2 0) (setq ray2 (+ ray2 (* 2pi))))
		     ));p and if less than pi
    (if (> defl pi)(progn
		     (setq ray1 (+ ang (/ pi 2)))
		     ;(if (> ray1 (* 2 pi)(setq ray1 (- ray1 (* 2 pi)))))
		     (setq ray2 (+ ang (/ pi 2)))
		     ;(if (> ray2 (* 2 pi)(setq ray2 (- ray2 (* 2 pi)))))
		     ));p and if greater than pi

    (if (or (and (> ltopang ray1) (< ltopang ray2))(and (> ltopang ray2)(< ltopang ray1)));check ot see if inside deflection squares **** needs testing later
      (progn
	(setq off (distance lotc op2))
(if (< OFF (ABS MINOFF))(SETQ minoff (abs off)
				  nearang ltopang)
      );if
	));p and if in defl sqr
   ));p and if not straight line

  (setq count (+ count 1))
    );repeat
      
				;using this info change the road name text rotation to the angle of the line
		(setq rrot (+ nearang (/ pi 2)))
		(if (> rrot (* 2 pi))(setq rrot (- rrot (* 2 pi))))
		(IF (AND (> rrot  (* 0.5 pi)) (< rrot (* 1.5 pi)))(setq rrot (+ rrot pi))) ;if text is upsidedown reverse rotation
					  
		
    
  (SETQ	roadname (subst (cons 50  rrot);SUB IN NEW POINT 2 HEIGHT
		     (assoc 50 roadname)
		     roadname     ) )
  (ENTMOD roadname)
(COMMAND "DRAWORDER" SENT "" "BACK")
  )




;------------------------------------------------------Assign Adjoining polyline to XML other----------------------------------------------

(defun C:XJO (/)

 (setq prevlayer (getvar "CLAYER"))

  (if (= plotno nil) (setq plotno "1"))
  (setq uop "")

 (SETQ SENT (CAR (ENTSEL "\nSelect Polyline:")))
  (setq lotc (getpoint "\nSelect Lot Centre (centroid):"))
  (setq prmtype rmtype)
  (setq aclass (getstring T (strcat "\nClass [" paclass "](* for list):")))
  (if (= aclass "") (setq aclass paclass))

  ;execute list finder
  (if (= aclass "*")(progn
		      (setq workingselnum tselnum)
		      (setq names alotclasslist)
		      (dbox)
		      (setq aclass returntype)
		      (setq tselnum workingselnum)
		      ))
  (setq paclass aclass)

(if (= aclass "Hydrography")(progn
  (setq uop (getstring T (strcat "\nUse of parcel (* for list):")))
  (if (= uop "*")(progn
		      (setq workingselnum tselnum)
		      (setq names hydrolist)
		      (dbox)
		      (setq uop returntype)
		      (setq tselnum workingselnum)
		      ))
  ));if hydro


  (if (= aclass "Administrative Area")(progn
  (setq uop (getstring T (strcat "\nUse of parcel (* for list):")))
  (if (= uop "*")(progn
		      (setq workingselnum tselnum)
		      (setq names adminlist)
		      (dbox)
		      (setq uop returntype)
		      (setq tselnum workingselnum)
		      ))
  ));if admin area

  (if (= aclass "Lot")(progn
  (setq uop (getstring T (strcat "\nUse of parcel (* for list):")))
  (if (= uop "*")(progn
		      (setq workingselnum tselnum)
		      (setq names lotuoplist)
		      (dbox)
		      (setq uop returntype)
		      (setq tselnum workingselnum)
		      ))
  ));if lot

  

   

  
  (SETQ SENTLIST (ENTGET SENT))
    ;go through polyline to get points to check for clockwise direction
  (SETQ ZA (CDR (ASSOC 210 SENTLIST)))
    (SETQ CWLIST (LIST))
	    (foreach a SenTlist
	      (if (= 10 (car a))

		(setq CWLIST (append CWLIST (list (TRANS (cdr a) ZA 0))))
	      )				;IF
	      
	    )				;FOREACH 			

  (IF (> (lcw CWLIST) 0) (command "pedit" sent "r" "" ))
  					(SETQ SENTLIST (ENTGET SENT))
  (if (= lotc nil)(calclotc cwlist));calculate lot center if none

  (SETQ PTLIST (LIST))
				
;CREATE LIST OF POLYLINE POINTS
    (SETQ PTLIST (LIST))
	    (foreach a SENTLIST
	      (if (= 10 (car a))

		(setq PTLIST (append PTLIST (list (cdr a))))
	      )				;IF
	     
	    )				;FOREACH 			)


  (setq ptlist (append ptlist (list (nth 0 ptlist))))
  
 (SETQ lotno (getstring T"\n Name:"))

  (if (/= uop "") (setq uops (strcat " useOfParcel=\"" uop "\""))(setq uops ""))
    
  (setq lotstate "adjoining")
    (setq lotc (trans lotc 1 0));convert to world if using UCS
  (IF (or (= aclass "Hydrography")(= aclass "Reserved Road"))(setq namedesc "desc=\"")(setq namedesc "<Parcel name=\""));allows for H#/R# assignment on export
  (SETQ LTINFO (STRCAT  namedesc lotno "\" class=\"" aclass "\" state=\"" lotstate "\" parcelType=\"Single\"" uops " parcelFormat=\"Standard\">!"
		       (rtos (cadr lotc) 2 6 ) " " (rtos (car lotc) 2 6)))
(SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 LTINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (SETQ NEWSENTLIST (subst (cons 8 "Adjoining Boundary")(assoc 8 NEWSENTLIST) NEWSENTLIST ))

(ENTMOD NEWSENTLIST)
  (setq prefix "")
  (if (or (= uop "Parish" )(= uop "County")(= uop "Local Government Area")(= aclass "Reserved Road"))(progn
  (if (= uop "Parish")(setq linestyle "PARISH BOUNDARY"
			    prefix "PARISH OF "))
  (if (= uop "County")(setq linestyle "COUNTY BOUNDARY"
			    prefix "COUNTY OF "))
  (if (= uop "Local Government Area")(setq linestyle "LGA BOUNDARY"))
  (if (= aclass "Reserved Road")(setq linestyle "EASEMENT"))
  (command "change" sent "" "properties" "ltype" linestyle "")
  ))
  
  (setq areapos (polar lotc (* 1.5 pi) (* th 3.5)))

  (setq THF 2)
(setq lotc (trans lotc 0 1));convert back to UCS
  (SETVAR "CLAYER"  "Drafting" )
	(SETVAR "CELWEIGHT" 50)				
  (COMMAND "TEXT" "J" "MC" lotc (* TH THF) "90" (strcat prefix (strcase lotno)))
       (setq roadname (entget (entlast)))
  (if (= aclass "Lot")(progn
  (SETVAR "CELWEIGHT" 35)
  (COMMAND "TEXT" "J" "BC" areapos (* TH 1.4) "90" (strcase uop))
  ))
  (SETVAR "CELWEIGHT" -1)
   (SETVAR "CLAYER" prevlayer) 


(setq lotc (trans lotc 1 0));convert to world if using UCS

  (if (/= aclass "Lot")
    (progn
		(setq count 0)
		(setq minoff 100000000000000000000000000000000000000)
(repeat (- (length ptlist)2 )

  (setq op1 (nth count ptlist))
  (setq op2 (nth (+ count 1) ptlist))
  (setq op3 (nth (+ count 2) ptlist))



  ;check line one
;check offset to line
  (SETQ ANG (ANGLE oP1 oP2))
  (SETQ CANG (+ ANG (/ PI 2)))
  (SETQ P4 (POLAR lotc CANG 1000))
  (SETQ P6 (POLAR lotc (+ CANG PI) 2000))
  (IF (SETQ P5 (INTERS oP1 oP2 P6 P4 ))(PROGN

					 (SETQ OFF (DISTANCE lotc P5))

    (if (< OFF (ABS MINOFF))(SETQ minoff (abs off)
				  nearang cang)
      );if
    
  ));p & if inters

    ;check inside deflection angle
    (setq ang2 (angle op2 op3))
    (setq cang2 (+ ang (/ pi 2)))
    (setq ltopang (angle op2 lotc))
    (setq defl (- ang2 ang))
(if (/= defl 0);check for straight line
  (progn
    (if (< defl pi)(progn
		     (setq ray1 (- ang (/ pi 2)))
		     ;(if (< ray1 0) (setq ray1 (+ ray1 (* 2 pi))))
		     (setq ray2 (- ang2 (/ pi 2)))
		     ;(if (< ray2 0) (setq ray2 (+ ray2 (* 2pi))))
		     ));p and if less than pi
    (if (> defl pi)(progn
		     (setq ray1 (+ ang (/ pi 2)))
		     ;(if (> ray1 (* 2 pi)(setq ray1 (- ray1 (* 2 pi)))))
		     (setq ray2 (+ ang (/ pi 2)))
		     ;(if (> ray2 (* 2 pi)(setq ray2 (- ray2 (* 2 pi)))))
		     ));p and if greater than pi

    (if (or (and (> ltopang ray1) (< ltopang ray2))(and (> ltopang ray2)(< ltopang ray1)));check ot see if inside deflection squares **** needs testing later
      (progn
	(setq off (distance lotc op2))
(if (< OFF (ABS MINOFF))(SETQ minoff (abs off)
				  nearang ltopang)
      );if
	));p and if in defl sqr
   ));p and if not straight line

  (setq count (+ count 1))
    );repeat
      
				;using this info change the road name text rotation to the angle of the line
		(setq rrot (+ nearang (/ pi 2)))
		(if (> rrot (* 2 pi))(setq rrot (- rrot (* 2 pi))))
		(IF (AND (> rrot  (* 0.5 pi)) (< rrot (* 1.5 pi)))(setq rrot (+ rrot pi))) ;if text is upsidedown reverse rotation
					  
		
    
  (SETQ	roadname (subst (cons 50  rrot);SUB IN NEW POINT 2 HEIGHT
		     (assoc 50 roadname)
		     roadname     ) )
  (ENTMOD roadname)
(COMMAND "DRAWORDER" SENT "" "BACK")
      ))
  )



;-------------------------------------------------------------ASSIGN STRATA POLYLINE TO XML-----------------------------------

(DEFUN C:XSA (/)

  
  (setq prevlayer (getvar "CLAYER"))
(setq areapercent nil)
  (if (= plotno nil) (setq plotno "1"))
  
(command "-layer" "s" "0"
	 "off" "Drafting"
	 "")

 (SETQ SENT (CAR (ENTSEL "\nSelect Polyline:")))

  (command "-layer" "on" "Drafting"
	  "")
  
  (setq lotc (getpoint "\nSelect Lot Centre (centroid):"))
	 

  (SETQ SENTLIST (ENTGET SENT))
    ;go through polyline to get points to check for clockwise direction
  (SETQ ZA (CDR (ASSOC 210 SENTLIST)))
    (SETQ CWLIST (LIST))
	    (foreach a SenTlist
	      (if (= 10 (car a))

		(setq CWLIST (append CWLIST (list (TRANS (cdr a) ZA 0))))
	      )				;IF
	      
	    )				;FOREACH 			

  (IF (> (lcw CWLIST) 0) (command "pedit" sent "r" "" ))
  					(SETQ SENTLIST (ENTGET SENT))
  (if (= lotc nil)(calclotc cwlist));calculate lot center if none
  

 (SETQ lotno (getstring (strcat "\n Lot Number [" plotno "]:")))
  (if (= lotno "") (setq lotno plotno))

  (if (= (substr lotno 1 8) "BUILDING" )(setq bno (getstring "\nBuilding Street Number:")))
  (if (= (substr lotno 1 8) "BUILDING" )(setq pclclass "Building")(setq pclclass "Lot"))
  (if (= (substr lotno 1 2) "CP")(setq pclclass "Common Property"))
  (if (OR (vl-string-search "DP" lotno)(= (substr lotno 1 2) "SP"))(progn;if adjoining or affected lot detects slash
				     (setq bora (getstring "[B]ase or [A]djoininng Lot:"))
				     (if (or (= bora "b")(= bora "B")(= bora "BASE")(= bora "Base")(= bora "base"))(setq pclclass "Lot"
															 lotstate "affected"
															 pclformat "Standard"))
				     (if (or (= bora "a")(= bora "A")(= bora "ADJOINING")(= bora "Adjoining")(= bora "adjoining"))(setq pclclass "Lot"
															 lotstate "adjoining"
															 pclformat "Standard")
				       ;pcltpye configured further below
				       ))
   (setq pclformat "Strata"
	  lotstate "proposed");else
					)										 
															 
				     
  
   (setq area (getstring "\nArea or [C]alculate or [S]elect Polylines or [N]one (mm.dm) (aa.rr.pp.f/p) [Last]:"))
(if (or (= area "")(= area "l")(= area "L")(= area "LAST")(= area "last"))(setq area "Last"))
(if (or (= area "n")(= area "N")(= area "none")(= area "NONE"))(progn (setq area "")))
								   
(if (or (= area "S")(= area "s"))(progn
(command "-layer" "s" "0"
	 "off" "Drafting"
	   "off" "Lot Definitions"
	   "off" "Connection"
	   "off" "Boundary"
	   ""
	   )
  
 
 
				   (princ "\nSelect Polylines to calc subtotal area:")
				   (setq subpoly (ssget '((0 . "LWPOLYLINE"))))
				   (setq subcount 0)
				   (setq subarea 0)
				   (repeat (sslength subpoly)
				     (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME subpoly subCOUNT)))))
					  (SETQ area2 (vlax-get-property (vlax-ename->vla-object en ) 'area ))
				     (setq fp (- area2 (fix area2 )))
				     (if (> fp 0.7) (setq area2 (+ (fix area2) 1))(setq area2 (fix area2)));truncate using 0.7
				     (setq subarea (+ subarea area2))
				     (setq subcount (+ subcount 1))
				     )
(setq area (rtos  subarea 2 0 ))
 (command "-layer" "on" "Drafting"
	   "on" "Lot Definitions"
	   "on" "Connection"
	   "on" "Boundary"
	   "")
				   ));p&if select

  
  
  (if (= area "Last" )(setq area arealast))
  (setq arealast area)

   (setq desc (getstring t(strcat "\nDescription [N]one [" prevdesc "]:")))
  (if (or (= desc "n")(= desc "N")(= desc "none")(= desc "NONE"))(progn (setq desc "")
								   (setq prevdesc "")))
  (if (= desc "") (setq desc prevdesc)(setq prevdesc desc))
  
  (setq blno (getstring t(strcat "\nBuilding Level [" prevblno "]:")))
  (if (= blno "")(setq blno prevblno)(setq prevblno blno))
		   
  


  ;deal with imperial areas
  
      
	(setq dotpos1 (vl-string-position 46 area 0))
	(if (= dotpos1 nil)(setq dotpos2 nil)(setq dotpos2 (vl-string-position 46 area (+ dotpos1 1))))
	(if (/= dotpos2 nil)(progn;idenfited as imperial area, must have second dotpos to work
			      
	(if (= dotpos2 nil)(setq dotpos3 nil)(setq dotpos3 (vl-string-position 46 area (+ dotpos2 1))))
	(setq /pos1 (vl-string-position 47 area 0))
	(if (/= /pos1 nil);with factional part
	  (progn
	    (setq den (substr area ( + /pos1 2) 50))
	    (setq num (substr area ( + dotpos3 2) (- (- /pos1 dotpos3) 1)))
	    (setq fperch (/ (atof num) (atof den)))
	    (setq perch (substr area (+ dotpos2 2) (- (- dotpos3 dotpos2) 1)))
	    (setq perch (+ fperch (atof perch)))
	    (setq rood (substr area (+ dotpos1 2) (- (- dotpos2 dotpos1) 1)))
	    (setq perch (+ perch (* (atof rood) 40)))
	    (setq acre (substr area 1  dotpos1 ))
	    (setq perch (+ perch (* (atof acre) 160)))
	    (setq area (rtos (* perch 25.2929538117) 2 9))
	    )
	  )
	(if (and (/= dotpos1 nil)(/= dotpos2 nil)(= /pos1 nil));without fractional part
	  (progn
	    (setq perch (substr area ( + dotpos2 2) 50))
	    (setq perch (atof perch))
	    (setq rood (substr area (+ dotpos1 2) (- (- dotpos2 dotpos1) 1)))
	    (setq perch (+ perch (* (atof rood) 40)))
	    (setq acre (substr area 1  dotpos1 ))
	    (setq perch (+ perch (* (atof acre) 160)))
	    (setq area (rtos (* perch 25.2929538117) 2 9))
	    )
	  )
	
	));p&if imperial area

   
   (SETQ area1 (vlax-get-property (vlax-ename->vla-object sent ) 'area ))

  (setvar "dimzin" 0)
  (IF (or ( = area "C")(= area "c"))
    (progn
      (setq area2 area1 )
      ;area 4 sig figs remove - all stratas to integer sqaure metres
      (setq fp (- area2 (fix area2 )))
      (if (> fp 0.7) (setq area2 (+ (fix area2) 1))(setq area2 (fix area2)));truncate using 0.7
      
					    (setq textarea (strcat (rtos (* (fix (/ area2 1)) 1) 2 0) "m�"))
      
					    
      )
    (progn
      (if (/= area1 0)(progn
     (setq areapercent (ABS(* (/  (- area1 (ATOF area)) area1) 100)))
     (if (and (/= area "")(> areapercent 10)) (princ (strcat "\nArea different to calulated by " (rtos areapercent 2 0)"%")))
     ))

       (if (/= area "")(setq textarea (strcat (rtos (* (fix (/ (ATOF area) 1)) 1) 2 0) "m�"))(setq textarea ""))

     )
    )
  (setvar "dimzin" 8)
    
  

  (if (= (substr lotno 1 2) "PT")(setq pcltype " parcelType=\"Part\""
				     lotno (substr lotno 3 50)
				       ;desc "\" desc=\"PT"
				       textarea (strcat "(" textarea ")")
				       )
    (setq pcltype " parcelType=\"Single\"")
    )

    (if (=  lotno "CP")(setq pcltype " parcelType=\"Part\""
				    ;desc "\" desc=\"PT"
				       ))

  
  
  (if (/= desc "")(setq pcldesc (strcat " desc=\"" desc "\""))(setq pcldesc ""))
  (setq pclblno (strcat " buildingLevelNo=\"" blno "\""))
  (if (= pclclass "Building")(setq pclbno (strcat " buildingNo=\"" bno "\""))(setq pclbno ""))
  (setq pclclasss (strcat " class=\""pclclass "\" "))
  (if (/= area "")(setq areas (strcat " area=\"" area "\""))(setq areas ""))

  (setq lotc (trans lotc 1 0));convert to world if using UCS


  (SETQ LTINFO (STRCAT "  <Parcel name=\"" lotno "\" " pcldesc pclclasss " state=\"" lotstate "\"" pcltype " parcelFormat=\"" pclformat "\"" areas  pclblno pclbno " >!" (rtos (cadr lotc) 2 6 ) " " (rtos (car lotc) 2 6)))
(SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 LTINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  ;move polyline to appropriate layer
  (IF (= lotstate "adjoining")(SETQ NEWSENTLIST (subst (cons 8 "Adjoining Boundary")(assoc 8 NEWSENTLIST) NEWSENTLIST ))
  (SETQ NEWSENTLIST (subst (cons 8 "Lot Definitions")(assoc 8 NEWSENTLIST) NEWSENTLIST )))
  (ENTMOD NEWSENTLIST)

         ;strata location plan lots strip number from end of lot number
       (if (and (= blno "0,Location Plan")(= pclclass "Lot")(= lotstate "proposed"))
	 (progn
	   (setq oldlotno lotno)
	 (while (and (> (ascii(substr lotno (strlen lotno) 1)) 47)(< (ascii(substr lotno (strlen lotno) 1)) 58))
	 (setq lotno (substr lotno 1 (- (strlen lotno) 1)))
	   
		     );W
	   (setq LPlotno (STRCAT LOTNO (RTOS (+ (ATOF (substr oldlotno (+ (strlen lotno) 1) 50)) 1) 2 1)));INCREMENT NEXT LOT NO FOR LOCATION PLAN
	 ))
       (if (= (substr lotno 1 2) "CP")(setq lotno "CP"))
  

  (if (AND (/= lotno "CP")(= pcltype " parcelType=\"Part\""))(setq lotnos (strcat "PT" lotno))(setq lotnos  lotno))

(setq lotc (trans lotc 0 1));convert back to UCS if using one

  ;(SETVAR "CELWEIGHT" 50)
  (SETVAR "CLAYER"  "Drafting" )
  (setq areapos (polar lotc (* 1.5 pi) (* th 2)))
  (setq cpdescpos (polar lotc (* 1.5 pi) (* th 1.5)))
  (setq descpos (polar lotc (* 1.5 pi) (* th 3.5)))
  ;(COMMAND "TEXT" "J" "BC" lotc (* TH 2) "90" lotnos)
  ;(SETVAR "CELWEIGHT" 35)
  ;(COMMAND "TEXT" "J" "BC" areapos (* TH 1.4) "90"  textarea )
;(SETVAR "CELWEIGHT" -1)

  (if (and (/= lotno "CP")(/= (substr lotnos 1 2) "PT"))(setq plotno (rtos (+ (atof lotno) 1) 2 0))(setq plotno lotnos))  

;case if desc only eg. vincd balcony
  (if (and (/= pclclass "Building")(/= desc "")(= area "")(/= lotno "CP")(/= blno "0,Location Plan"))(progn
				     (SETVAR "CELWEIGHT" 35)
				     (COMMAND "TEXT" "J" "MC" lotc (* TH 1.4) "90" desc)))
    
;case if no desc and area eg. standard lot
  (if (and (/= pclclass "Building")(= desc "")(/= area ""))(progn
				     (SETVAR "CELWEIGHT" 50)
				     (COMMAND "TEXT" "J" "BC" lotc (* TH 2) "90" lotnos)
				     (SETVAR "CELWEIGHT" 35)
				     (COMMAND "TEXT" "J" "BC" areapos (* TH 1.4) "90" textarea)
				     ))
;case if desc and area eg. car space
  (if (and (/= pclclass "Building")(/= desc "")(/= area ""))(progn
				      (SETVAR "CELWEIGHT" 50)
				      (COMMAND "TEXT" "J" "BC" lotc (* TH 2) "90" lotnos)
				      (SETVAR "CELWEIGHT" 35)
				     (COMMAND "TEXT" "J" "BC" areapos (* TH 1.4) "90" textarea)
				      (COMMAND "TEXT" "J" "BC" descpos (* TH 1) "90" desc)
				      ))
;case if no area or desc eg. normal common property
    (if (and (= pclclass "Common Property")(= desc "")(= area "")(/= blno "0,Location Plan"))(progn
				     (SETVAR "CELWEIGHT" 35)
				     (COMMAND "TEXT" "J" "MC" lotc (* TH 1) "90" lotnos)))
;case if no area and desc and lot no = CP eg. desc common property
      (if (and (= pclclass "Common Property")(/= desc "")(= area "")(= lotno "CP")(/= blno "0,Location Plan"))(progn
				     (SETVAR "CELWEIGHT" 35)
				     (COMMAND "TEXT" "J" "BC" lotc (* TH 1) "90" lotnos)
				     (COMMAND "TEXT" "J" "BC" cpdescpos (* TH 1) "90" desc)))

    ;Case if no area or desc and start of lot no = CP and floor is location plan eg. location plan common property
      (if (and (= (substr lotno 1 2) "CP")(= blno "0,Location Plan"))(progn
								       ;do nothing
				     ))
 

  ;Case if no area or desc and start of lot no in not CP and floor is location plan eg. location plan other lots
      (if (and (/= pclclass "Building")(/= (substr lotno 1 2) "CP")(= blno "0,Location Plan")(/= lotstate "affected")(/= lotstate "adjoining"))(progn
								     (COMMAND "TEXT" "J" "BC" lotc (* TH 1) "90" lotnos)
								     (SETQ PLOTNO LPLOTNO)
								     				     ))

  ;Case if lotstate is adjoining label
      (if (= lotstate "adjoining")(progn
								     (COMMAND "TEXT" "J" "BC" lotc (* TH 2) "90" lotnos)
								     				     ))
  
  
	
  (IF (= pclclass "Building")(PROGN
		;(setq tlp (LIST (+ (CAR LOTC) (* -10 TH)) (+ (CADR lotc) (* 10 TH)) (caddr lotc)))
			    (if (and (> (ascii bno) 47) (< (ascii bno) 57))(setq bno (strcat "No " bno)))
				    (SETQ bldtext (strcat bno (chr 10) desc))
				    (command "-mtext" lotc "j" "mc" "h" (* th 1.4) "c" "n" "w" (* th 20) bldtext "")
				    ))
  
  
  
				    
			 ;  (SETQ PLOTNO LOTNOS)
			 
			   
    	 

  

  (COMMAND "DRAWORDER" SENT "" "BACK")

      (SETVAR "CLAYER" prevlayer)

   (IF (/= areapercent NIL)(PRINC (strcat "\nArea different to calulated by " (rtos areapercent 2 0)"%")))
  );DEFUN


;-------------------------------------------------------------TOTAL STRATA AREAS-----------------------------------

(DEFUN C:XST (/)

  (setq prevlayer (getvar "CLAYER"))
  (setq lalist nil)
  
  (princ "\nSelect Lots to Display Total:")
  (SETQ TENT (SSGET '((0 . "LWPOLYLINE"))))
       

(IF (/= (setq lots (ssget "_X" '((0 . "LWPOLYLINE") (8 . "Lot Definitions")))) nil)(progn

	;check all lots for multipart lots
				(setq mplist nil)				     
			(setq count 0)
  (repeat (sslength lots)
     (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME lots COUNT)))))
    (SETQ P1 (CDR(ASSOC 10 (ENTGET (SSNAME lots COUNT)))))
      	    (SETQ XDATAI (ENTGET EN '("LANDXML")))
	    (IF (= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL) (progn
	      	     (COMMAND "CHANGE" en "" "P" "C" "6" "")
	      (princ (strcat "\nERROR Lot with no XML data at " (rtos (car p1) 2 3) "," (rtos (cadr p1)2 3)))
	     ))
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))

    
 (if (/= (setq stringpos (vl-string-search "parcelType" xdatai )) nil)(progn
(setq wwpos (vl-string-position 34 xdatai (+ stringpos 12)))(setq pcltype (substr xdatai (+ stringpos 13) (-(- wwpos 1)(+ stringpos 11))))))
     (if (/= (setq stringpos (vl-string-search "name" xdatai )) nil)(progn
(setq wwpos (vl-string-position 34 xdatai (+ stringpos 6)))(setq pclname (substr xdatai (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5)))))(setq pclname ""))
     (if (/= (setq stringpos (vl-string-search "area" xdatai )) nil)(progn
(setq wwpos (vl-string-position 34 xdatai (+ stringpos 6)))(setq area (substr xdatai (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5)))))(setq area ""))
    (if (= pcltype "Part")(setq mplist (append mplist (list (strcat pclname "-" area )))))
    (setq count (+ count 1))
    );r
(if (> (length mplist) 0)(progn
			  
			(setq mplist (vl-sort mplist '<))
			(setq count 1)
			(setq alphanum 65)
			(setq pclname (nth 0 mplist))
			
			(setq -pos1 (vl-string-position 45 pclname 0))
			(setq area  (substr pclname (+ -pos1 2) 50))
			(setq areatot area)
                        (setq pclname  (substr pclname 1 -pos1))
			(setq liststart (strcat "  <Parcel name=\""pclname "\" class=\"Lot\" state=\"proposed\" parcelType=\"Multipart\" area=\""))
			(setq listend (strcat "\">" (chr 10) "    <Parcels>" (chr 10) ))
      		        (setq listend (strcat listend "      <Parcel name=\"" pclname (chr alphanum) "\" pclRef=\"" pclname (chr alphanum) "\"/>" (chr 10) ))
			
			(setq mpalist (append mpalist (list pclname)(list (chr alphanum))))
			(setq prevname pclname)
			;sort list
			(repeat (-  (length mplist) 1) 
			  (setq pclname (nth count mplist))
			  (setq -pos1 (vl-string-position 45 pclname 0))
			(setq area  (substr pclname (+ -pos1 2) 50))
			  (setq pclname  (substr pclname 1 -pos1))
			  (if (= pclname prevname)(progn
			    (setq alphanum (+ alphanum 1))
			    (setq listend (strcat listend "      <Parcel name=\"" pclname (chr alphanum) "\" pclRef=\"" pclname (chr alphanum) "\"/>" (chr 10) ))
			    (setq areatot (rtos (+ (atof area) (atof areatot))))
)
			    (progn;else not the same pclname
			      (setq mpolist (append mpolist (list (strcat liststart areatot  listend (chr 10) "    </Parcels>" (chr 10)   "  </Parcel>"))))
			      (setq lalist (append lalist (list (strcat "lot" prevname) areatot)))
			      (setq alphanum 65)
			      (setq areatot area)
			      (setq liststart (strcat "  <Parcel name=\""pclname "\" class=\"Lot\" state=\"proposed\" parcelType=\"Multipart\" area=\""))
			      (setq listend (strcat "\">" (chr 10) "    <Parcels>" (chr 10) ))
			 (setq listend (strcat listend "      <Parcel name=\"" pclname (chr alphanum) "\" pclRef=\"" pclname (chr alphanum) "\"/>" (chr 10) ))
			    )
			    );if
			  
			  (setq mpalist (append mpalist (list pclname)(list (chr alphanum))))
			  (setq prevname pclname)
			  (setq count (+ count 1))
			  );r

			(setq mpolist (append mpolist (list (strcat liststart areatot  listend  "    </Parcels>" (chr 10)   "  </Parcel>"))))
			(setq lalist (append lalist (list (strcat "lot" pclname) areatot)))
			));p&if multipart lots exist
				
));p&if lwpolylines exist

				
(SETQ COUNT 0)				
(REPEAT (SSLENGTH TENT)
  
    (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME tent COUNT)))))
    

    	    (SETQ XDATAI (ENTGET EN '("LANDXML")))
	    (SETQ XDATAI (ASSOC -3 XDATAI))
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))

   

    ;check for mutliplart lot
     (if (/= (setq stringpos (vl-string-search "name" xdatai )) nil)(progn
(setq wwpos (vl-string-position 34 xdatai (+ stringpos 6)))(setq pclname (substr xdatai (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5))))))

    (if (/= (setq remlist (member (strcat "lot" pclname) lalist)) nil)(progn
							   (setq areatotal (strcat (nth 1 remlist) "m�"))
							    )
      )
      
    
     

;seperate centrepoint coord out.
    
     (setq !pos1 (vl-string-position 33 xdatai 0))
                      (setq lotc (substr xdatai (+ !pos1 2) 200))
     (setq spcpos1 (vl-string-position 32 lotc 0))
                      (setq east (atof(substr lotc (+ spcpos1 2) 200)))
                      (setq north  (atof (substr lotc 1 spcpos1)))
  (setq lotc (list east north))
      (SETVAR "CLAYER" "Drafting")
	(setq descpos (polar lotc (* 1.5 pi) (* th 4)))
(COMMAND "TEXT" "J" "BC" descpos (* TH 1.4) "90" areatotal)
    (setq count (+ count 1))
 );repeat   
(setvar "clayer" prevlayer)				
)


  ;-------------------------------------------------------------DRAFT STRATA LINES-----------------------------------

(defun c:xsd (/)
  (setq prevlayer (getvar "CLAYER"))
  (setq offang (* 0.5 PI))
  (setvar "clayer" "Drafting")
  (setq reverseq "n")
  (xsdfunction)
  )
(defun c:xsdr (/)
  (setq prevlayer (getvar "CLAYER"))
  (setq offang (* -0.5 PI))
  (setq width 0.05)
  (setvar "clayer" "Lot Definitions")
  (setq reverseq "y")
  (xsdfunction)
  
  )


  (defun xsdfunction (/)


    
    
  (princ "\nSelect Lots to Draft:")
  (SETQ TENT (SSGET '((0 . "LWPOLYLINE"))))

  ;need clockwise routine
  
  (setq count 0)
  (repeat (sslength tent)

    (setq delstuff (ssadd));clear polylines
    (setq offplset (ssadd));clear polylines
    (setq thin2thick 0)
    (setq widthlist (list))
    (setq pw4l nil);preivious width
    (setq strataline "0");swtich for no xdata for strata class

    (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME tent COUNT)))))
    (SETQ za (CDR(ASSOC 210 (ENTGET (SSNAME tent COUNT)))))
    (SETQ closed (CDR(ASSOC 70 (ENTGET (SSNAME tent COUNT)))))
    (SETQ ENLIST (ENTGET EN))

    ;check to see if object has xdata and if so is it classed as parcel?
     (SETQ XDATAI (ENTGET EN '("LANDXML")))
	    (IF (= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL) (progn
	      	   (setq strataline "1")
	     )
	      (progn
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))
	    (if (/= (setq stringpos (vl-string-search "parcelFormat" xdatai )) nil)(progn
(setq wwpos (vl-string-position 34 xdatai (+ stringpos 14)))(setq parcelformat (substr xdatai (+ stringpos 15) (-(- wwpos 1)(+ stringpos 13)))))(setq parcelformat ""))
	    (if (= parcelformat "Strata")(setq strataline "1"))
	    )
	      );if no xdata or strata format
	    
(if (= strataline "1")(progn
    		(setq enlist (entget en))
    ;go through polyline to get points to check for clockwise direction
    ;(SETQ ZA (CDR (ASSOC 210 SENTLIST)))
    (SETQ CWLIST (LIST))
	    (foreach a enlist
	      (if (= 10 (car a))

		(setq CWLIST (append CWLIST (list (cdr a))))
	      )				;IF
	      
	    )				;FOREACH 			

  (IF (> (lcw CWLIST) 0) (command "pedit" en "r" "" ))

    ;get points, bulge and width from polyline
    (SETQ ENLIST (ENTGET EN))
    (SETQ PTLIST (LIST))
	    (foreach a enlist
	      (if (= 10 (car a))
		(setq PTLIST (append PTLIST (list (TRANS (cdr a) ZA 0))))
	      )				;IF
	      (if (= 42 (car a));bulge
		(setq PTLIST (append PTLIST (LIST (cdr a))))
		);if
	      (if (= 40 (car a));width
(PROGN
		(setq PTLIST (append PTLIST (LIST (cdr a))))
  (if (/= (cdr a) pw4l)
  (setq widthlist(append widthlist (list (cdr a)))
	pw4l (cdr a)));store list of widths
  );p
		);if
	      
	    )				;FOREACH

    ;(princ (strcat "\n0 "(rtos (car (nth 0 ptlist)) 2 9) "," (rtos (cadr (nth 0 ptlist)) 2 9)))
    ;(princ (strcat "\n0 "(rtos (car (nth 3 ptlist)) 2 9) "," (rtos (cadr (nth 3 ptlist)) 2 9)))

    (SETQ ORIGLIST PTLIST)

   

    ;delete duplicates from list
    (setq dupcount 0)
    (setq pp "0")
    (setq ppw "500000")
    (repeat (/ (length ptlist) 3)
      (setq cpp (strcat (rtos (car (nth dupcount ptlist)) 2 9) "," (rtos (cadr (nth dupcount ptlist)) 2 9)))
      (setq cpw (nth (+ dupcount 1) ptlist)) 
      ;(princ (strcat "\n" pp))
      ;(princ (strcat "\n" cpp))
           
      (if  (= pp cpp) (progn
		
	               (setq ptlist (remove_nth ptlist (- dupcount 2 )))
		       (setq ptlist (remove_nth ptlist (- dupcount 2 )))
		       (setq ptlist (remove_nth ptlist (- dupcount 2 )))
		      		    
							      
		       );p if pp = cp
(progn	       		 
	(setq dupcount (+ dupcount 3))
	))
      (setq pp cpp)
	(setq ppw cpw)
		  
      )
;closed doublepoint removal
    (setq cpp (strcat (rtos (car (nth 0 ptlist)) 2 9) "," (rtos (cadr (nth 0 ptlist)) 2 9)))
    ;(princ (strcat "\nstart" pp))
     ; (princ (strcat "\nfinish" cpp))
     (if (= pp cpp) (progn
		       (setq ptlist (remove_nth ptlist (LENGTH PTLIST)))
		       (setq ptlist (remove_nth ptlist (LENGTH PTLIST)))
		       (setq ptlist (remove_nth ptlist (LENGTH PTLIST)))
		      ; (princ (strcat "\nReomved sf" (rtos dupcount 2 0)))
		       ))
		       

(setq cleanlist ptlist)

    
    ;if more than one width cycle to a change of width
    (if (and (> (length widthlist) 1) (or (= closed 1)(= closed 129)))
      (progn
	(while (= (nth 1 ptlist)(nth 4 ptlist))(progn
						 (setq ptlist (append ptlist (list (nth 0 ptlist)  (nth 1 ptlist) (nth 2 ptlist)) ))
						 (setq ptlist (remove_nth ptlist 0))
						 (setq ptlist (remove_nth ptlist 0))
						 (setq ptlist (remove_nth ptlist 0))
						 ;(princ "\nCycling")
						 ))
						 (setq ptlist (append ptlist (list (nth 0 ptlist)  (nth 1 ptlist) (nth 2 ptlist)) ))
						 (setq ptlist (remove_nth ptlist 0))
						 (setq ptlist (remove_nth ptlist 0))
						 (setq ptlist (remove_nth ptlist 0))
						 ;(princ "\nExtra Cycle")
	))

    (if (or (= closed 1)(= closed 129))(setq ptlist (append ptlist (list(nth 0 ptlist) 2.3456789 0))))

    ;set starting values
    (setq count1 0)
    (setq script (list))
    (setq p1 (nth count1 ptlist))
    (setq w1 (nth (+ count1 1) ptlist))
    (setq b1 (nth (+ count1 2) ptlist))
    (setq sw (nth (+ count1 1) ptlist));starting width
    (setq firstrun 0)
    (setq sp nil)

    (if  (= (rtos w1 2 5) "0")(setq width "0"))
    (if (and (= reverseq "n") (/= w1 0))(setq width (/ scale 1000.0)))
    (if (and (= reverseq "y") (/= w1 0))(setq width 0.05))

    (setq p2 (nth (+ count1 3) ptlist))
    (setq w2 (nth (+ count1 4) ptlist))
    (setq b2 (nth (+ count1 5) ptlist))

    ;(if (/= (strcat (rtos (car p1) 2 9) "," (rtos (cadr p1) 2 9)) (strcat (rtos (car p2) 2 9) "," (rtos (cadr p2) 2 9)))(progn;if not the same point
															 
    (if (= b1 0) ;if its a straight line
      (progn
	(setq script (append script  (list "pline" (strcat (rtos (car p1 ) 2 9) "," (rtos (cadr p1 ) 2 9))  "w" width width (strcat(rtos (car p2 ) 2 9) "," (rtos (cadr p2 ) 2 9)))))
(setq coordcount 2)
	)
      (progn ;else
	(setq ang90 (+ (angle p1 p2) (* -0.5 pi)))
	(setq mp (list (/ (+ (car p1) (car p2)) 2)(/ (+ (cadr p1) (cadr p2)) 2)))
	(setq di (distance p1 p2))
	(setq bp (polar mp ang90 (/ (* b1 di) 2)))
	(setq script (append script  (list "pline" (strcat (rtos (car p1 ) 2 9) "," (rtos (cadr p1 ) 2 9))  "w" width width "a"  "s" (strcat(rtos (car bp ) 2 9) "," (rtos (cadr bp ) 2 9)) (strcat(rtos (car p2 ) 2 9) "," (rtos (cadr p2 ) 2 9)) "l")))
	(setq coorcount 2)

	)
      );if

	(setq count1 (+ count1 3))
	(while (< count1  (- (length ptlist) 3)  );while not the end of the ptlist
	  (progn
	    
    (while (and (= w1 w2) (< count1   (- (length ptlist) 3) )) (progn ;while the widths are the same and not end of line

    (setq p1 (nth count1 ptlist))
    (setq w1 (nth (+ count1 1) ptlist))
    (setq b1 (nth (+ count1 2) ptlist))

    
    (if  (= (rtos w1 2 5) "0")(setq width "0"))
    (if (and (= reverseq "n") (/= w1 0))(setq width (/ scale 1000.0)))
    (if (and (= reverseq "y") (/= w1 0))(setq width 0.05))
    

    (setq p2 (nth (+ count1 3) ptlist))
    (setq w2 (nth (+ count1 4) ptlist))
    (setq b2 (nth (+ count1 5) ptlist))

    (if (= b1 0) ;if its a straight line
      (progn
	(setq script (append script (list  (strcat (rtos (car p2 ) 2 9) "," (rtos (cadr p2 ) 2 9)))))
	(setq coordcount (+ coordcount 1))
      )
      (progn ;else a curve
	(setq ang90 (+ (angle p1 p2) (* -0.5 pi)))
	(setq mp (list (/ (+ (car p1) (car p2)) 2)(/ (+ (cadr p1) (cadr p2)) 2)))
	(setq di (distance p1 p2))
	(setq bp (polar mp ang90 (/ (* b1 di) 2)))
	(setq script (append  script (list  "a" "s" (strcat (rtos (car bp ) 2 9) "," (rtos (cadr bp ) 2 9)) (strcat (rtos (car p2 ) 2 9) "," (rtos (cadr p2 ) 2 9)) "l")))
	(setq coordcount (+ coordcount 1))
	)
      );if
    (setq count1 (+ count1 3))
    ));w widths are the same

    
    ;end of same width routine

   
    (if (/= (length script) 2)(progn
        (setq script (append script (list "")))
	(setq script1 script)
    (mapcar 'command script)
    (setq script (list))
	))
    
    
    (if (or(and ;case xsd other width
	     (/= (rtos w1 2 5) "0")
	     (/=  w1 (/ scale 1000.0) )
	     (= reverseq "n"))
	   (and ;case xsdr
	     (= reverseq "y")
	     (/= (rtos w1 2 5) "0")
	     ))
	     



      (progn ;if not 0 or structural centre
										(princ "offset1")
		   (IF (= (RTOS W1 2 5) "0.05378") (PROGN
					(SETQ ORIGOFFANG OFFANG)
					(SETQ OFFANG (+ OFFANG PI))
					));STRUCTURAL LEFT
		   (SETQ RMB (ENTLAST))
		
		   (setq delstuff (ssadd rmb delstuff ))
		   ;(setq p1l (nth 0 ptlist))
		   ;(setq p2l (nth 3 ptlist))
		   (setq mpl (list (/ (+ (car p1)(car p2))2) (/ (+ (cadr p1)(cadr p2))2)))
		   (SETQ ANG90 (+ (angle p1 p2) offang))
		   (setq op1 (polar mpl ang90 w1))
		   (command "offset" (/(/ scale 1000.0)2) rmb op1 "")
		   (IF (= (RTOS W1 2 5) "0.05378") (SETQ OFFANG ORIGOFFANG));RESET STRUCUTRAL LEFT OFFANG

		   ;GET POINTS FROM NEW POLYINE
		   (SETQ OFFPL (ENTLAST))
		   (SETQ ENLIST (ENTGET OFFPL))
	(SETQ offclosed (CDR(ASSOC 70 (ENTGET offpl))))
		   (SETQ PTLIST1 (LIST))
		   
		   (foreach a enlist
	      (if (= 10 (car a))

		(setq PTLIST1 (append PTLIST1 (list (TRANS (cdr a) ZA 0))))
	      )				;IF
	      	      
	    )				;FOREACH
		       (SETQ RMB (ENTLAST))
        (setq offplset (ssadd rmb offplset ))
(if (or (= offclosed 1)(= offclosed 129))(setq ptlist1 (append ptlist1 (list (nth 0 ptlist1)))))
		   	(SETQ lp (nth (- (length ptlist1) 1) ptlist1))
		   (princ (strcat (rtos (car lp) 2 3) "-" (rtos (cadr lp) 2 3)))
		   (if  (= thin2thick 1)(progn
					 (command "pline" fp "w" 0 0  (nth 0 ptlist1) "")
					 (setq thin2thick 0)
					  (SETQ RMB (ENTLAST))
       (setq offplset (ssadd rmb offplset ))
					 
					 ))
						  
		   );p if width not 0
      (progn
			       (SETQ RMB (ENTLAST))
        (setq offplset (ssadd rmb offplset ))
	(setq lp p2)
	);p if width is 0
      
      );if width not 0

    (if (and (= firstrun 0) (/= w1 0)(and (/= w1 (/ scale 1000))(= reverseq "n"))) (progn
							       (setq sp (nth 0 ptlist1);store first offset point for close
								     firstrun 1)
							       
							       ))
    (if (= firstrun 0)
      (setq sp (nth 0 ptlist);store first point
	    firstrun 1)
      )

							       
    
    ;if going from thick to thin add line from last point
     (if  (> w1 w2 )(setq script(append script (list "pline"  (strcat (rtos (car lp ) 2 9) "," (rtos (cadr lp ) 2 9)) "w" "0" "0"))
			 coordcount 1)
       (setq script (append script (list "pline"))
			    coordcount 1)
       );add line from end of thick

    ;if going from thin to thick last point
    (if (and (< w1 w2)(/= (rtos w2 2 7) "2.3456789")) (setq fp p2
			thin2thick 1))

    ;if not end of polyline start writing new line
    (if (/= count1 (- (length ptlist) 3))(progn
    ;start writing new line
      (setq p1 (nth count1 ptlist))
    (setq w1 (nth (+ count1 1) ptlist))
    (setq b1 (nth (+ count1 2) ptlist))
    (if  (= w1 0)(setq width "0"))
    (if (and (= reverseq "n") (/= w1 0))(setq width (/ scale 1000.0)))
    (if (and (= reverseq "y") (/= w1 0))(setq width 0.05))

    (setq p2 (nth (+ count1 3) ptlist))
    (setq w2 (nth (+ count1 4) ptlist))
    (setq b2 (nth (+ count1 5) ptlist))

    (if (= b1 0) ;if its a straight line
      (progn
     (setq script (append script  (list (strcat (rtos (car p1 ) 2 9) "," (rtos (cadr p1 ) 2 9)) "w" width width (strcat(rtos (car p2 ) 2 9) "," (rtos (cadr p2 ) 2 9)))))
     (setq coordcount (+ coordcount 1))
     )
      (progn ;else
	(setq ang90 (+ (angle p1 p2) (* -0.5 pi)))
	(setq mp (list (/ (+ (car p1) (car p2)) 2)(/ (+ (cadr p1) (cadr p2)) 2)))
	(setq di (distance p1 p2))
	(setq bp (polar mp ang90 (/ (* b1 di) 2)))
	(setq script (append script  (list  (strcat (rtos (car p1 ) 2 9) "," (rtos (cadr p1 ) 2 9))
					    "w" width width "a"  "s"
					    (strcat(rtos (car bp ) 2 9) "," (rtos (cadr bp ) 2 9))
					    (strcat(rtos (car p2 ) 2 9) "," (rtos (cadr p2 ) 2 9))
					    "l")))
	(setq coordcount (+ coordcount 1))

	)
      );if
          
		 (setq count1 (+ count1 3))
     ));p&if its not the last point

    
      
    
    ));w&p while not end of polyline

      ;if it is the end of the polyline
    (if (and(/= (length script) 1)
	    (/= (length script) 5)
	    )
	    (progn
 (setq script (append script (list "")))
    (setq script2 script)
    (mapcar 'command script)
 

 ))

     ;run last offset run

    (if (or(and ;case xsd other width
	     (/= (rtos w1 2 5) "0")
	     (/=  w1 (/ scale 1000.0) )
	     (= reverseq "n")
	     (>= (length widthlist) 2)
	     (or (= closed 1)(= closed 129))
	     (= (rtos w2 2 7) "2.3456789")
	     (= (nth 1 ptlist) 0)
	     (= (length script) 7)
	     
	        
	     )
	   (and ;case xsd two point
	     (/= (rtos w1 2 5) "0")
	     (/=  w1 (/ scale 1000.0) )
	     (= reverseq "n")
	     (= (length ptlist) 6)
	     (/= (rtos w2 2 7) "2.3456789")
	     
	     )
	   
	   ;(and ;case xsd other width and next line is closer to thin line
	    ; (/= (rtos w1 2 5) "0")
	     ;(/=  w1 (/ scale 1000.0) )
	     ;(= reverseq "n")
	     ;(> (length widthlist) 2)
	     ;(or (= closed 1)(= closed 129))
	     ;(/= (nth 1 ptlist) 0)
	        
	     ;)
	   
	   
	   (and ;case xsdr more than two points
	     (= reverseq "y")
	     (/= (rtos w1 2 5) "0")
	     (> (length widthlist) 1)
	    ; (/= (rtos w2 2 7) "2.3456789")
	     (princ "all true")
	     )
	   (and ;case xsdr two points
	     (= reverseq "y")
	     (/= (rtos w1 2 5) "0")
	     (= (length ptlist)  6)
	     (/= (rtos w2 2 7) "2.3456789")
	     )

	   )

    
   (progn ;if not 0 or structural centre
										(princ "offset2")
		   (IF (= (RTOS W1 2 5) "0.05378") (PROGN
					(SETQ ORIGOFFANG OFFANG)
					(SETQ OFFANG (+ OFFANG PI))
					));STRUCTURAL LEFT
		   (SETQ RMB (ENTLAST))
		
		   (setq delstuff (ssadd rmb delstuff ))
		   ;(setq p1l (nth 0 ptlist))
		   ;(setq p2l (nth 3 ptlist))
		   (setq mpl (list (/ (+ (car p1)(car p2))2) (/ (+ (cadr p1)(cadr p2))2)))
		   (SETQ ANG90 (+ (angle p1 p2) offang))
		   (setq op1 (polar mpl ang90 w1))
		   (command "offset" (/(/ scale 1000.0)2) rmb op1 "")
		   (IF (= (RTOS W1 2 5) "0.05378") (SETQ OFFANG ORIGOFFANG));RESET STRUCUTRAL LEFT OFFANG

		   ;GET POINTS FROM NEW POLYINE
		   (SETQ OFFPL (ENTLAST))
		   (SETQ ENLIST (ENTGET OFFPL))
	   	(SETQ offclosed (CDR(ASSOC 70 (ENTGET rmb))))

		   (SETQ PTLIST1 (LIST))
		   
		   (foreach a enlist
	      (if (= 10 (car a))

		(setq PTLIST1 (append PTLIST1 (list (TRANS (cdr a) ZA 0))))
	      )				;IF
	      	      
	    )				;FOREACH
		       (SETQ RMB (ENTLAST))
        (setq offplset (ssadd rmb offplset ))

			(if (or (= offclosed 1)(= offclosed 129))(setq ptlist1 (append ptlist1 (list (nth 0 ptlist1)))))

		   	(SETQ lp (nth (- (length ptlist1) 1) ptlist1))
		   
		   (if  (= thin2thick 1)(progn
					  (command "pline" fp "w" 0 0  (nth 0 ptlist1) "")
					 (setq thin2thick 0)
					 (SETQ RMB (ENTLAST))
        (setq offplset (ssadd rmb offplset ))
					 
					 ))
						  
		   );p if width not 0
      (progn;else
			       (SETQ RMB (ENTLAST))
        (setq offplset (ssadd rmb offplset ))
;	(if (> (length widthlist) 1)(SETQ lp (nth (- (length ptlist) 3) ptlist)))
;	(princ "off2else")
	);p if width is 0
      
      );if width not 0
   
   
 
	
   
    
						    			     
    
    (command "pedit" "m" offplset "" "j" "" "")
    (command "erase" delstuff "")

     ;if start and end are not the same add line from start to end
    (if (and (or (= closed 1)(= closed 129))(/= (strcat (rtos (car lp ) 2 9) "," (rtos (cadr lp ) 2 9))  (strcat (rtos (car sp ) 2 9) "," (rtos (cadr sp ) 2 9))))
      (progn
    (command "pedit"  offplset  "c" "")
    ; (SETQ RMB (ENTLAST))
   ;     (setq offplset (ssadd rmb offplset ))
			 ))
    ));if strataline
		   
(setq count (+ count 1))
    );repeat length of ssget polylines

    (setvar "clayer" prevlayer)
  );defun

    
      


;-------------------------------------------------------------ASSIGN POLYLINE AS IRREGULAR BOUNDARY-----------------------------------

(DEFUN C:XAI (/)

  
  (setq prevlayer (getvar "CLAYER"))

 (SETQ select  (ENTSEL "\nSelect Polyline:"))
  (setq dsp (getpoint "\nSelect downstream point (if non tidal):"))
  (setq dsp (trans dsp 1 0))
  ;(if (= dsp nil)(setq dfa "DFAT")(setq dfa "DFANT"))
  (setq sent (car select))
  (setq irbd (gETSTRING T "\nIrregular Boundary Description:"))
  


(setq pltype (cdr (assoc 0 (ENTGET SENT))))
(SETQ SENTLIST (ENTGET SENT))
  
  (if (= pltype "LWPOLYLINE")(PROGN
  
  
  (SETQ PTLIST (LIST))
	    (foreach a sentlist
	      (if (= 10 (car a))

		(setq PTLIST (append PTLIST (list (cdr a))))
	      )				;IF
	      
	    )				;FOREACH 			
)
    );IF LWPOLYLINE

  (if (= pltype "POLYLINE")(PROGN

  (setq enlist (entget SenT))
	    (setq ptList (list));EMPTY LIST
	    (setq en2 (entnext SenT))
	    (setq enlist2 (entget en2))
               
	     (while
	      (not
		(equal (cdr (assoc 0 (entget (entnext en2)))) "SEQEND")
	      )
	      	(if (= (cdr(assoc 70 enlist2)) 16)(progn
	       	 (setq ptList (append ptList (list (cdr (assoc 10 enlist2)))))
		))
		 	       
	       (setq en2 (entnext en2))
	       (setq enlist2 (entget en2))
	       );W
   (setq ptList
			(append ptList (list (cdr (assoc 10 enlist2))))
		 
	       )
  ));IF 2D POLYLINE
			     
  
		 (setq mp1 (nth (- (/ (length ptlist) 2)1) ptlist))
		 (setq mp2 (nth  (/ (length ptlist) 2) ptlist))
  (setq mp1 (trans mp1 0 1))
  (setq mp2 (trans mp2 0 1))
		 (setq mp (list (/ (+ (car mp1)(car mP2)) 2) (/ (+ (cadr mp1)(cadr mp2)) 2)))
		 (setq mprot (angle mp1 mp2))
		 (setq mprot90 (+ mprot (* 0.5 pi)))
  		 (SETQ 1POS (POLAR mp mprot90 (* TH 2)))
                 (SETQ fap (POLAR mp mprot90 (* TH 5)))
                 (IF (AND (> mprot  (* 0.5 pi)) (< mprot (* 1.5 pi)))(setq mprot (+ mprot pi))) ;if text is upsidedown reverse rotation
                 (setvar "clayer" "Drafting")
		 (COMMAND "TEXT" "J" "MC" 1pos TH (ANGTOS mprot 1 4) irbd)
;figure out direction of flow arrow

  (if (/= dsp nil)(setq dspc (strcat (rtos (car dsp) 2 6)","(rtos (cadr dsp) 2 6))))
  (setq plp1 (strcat (rtos (car (nth 0 ptlist)) 2 6)","(rtos (cadr (nth 0 ptlist)) 2 6)))
  (setq plp2 (strcat (rtos (car (nth (- (length ptlist) 1) ptlist)) 2 6)","(rtos (cadr (nth (- (length ptlist) 1) ptlist)) 2 6)))
	
  
(if (= dspc plp1) (setq far (angle mp2 mp1)
			dfapoints (strcat plp2 "!" plp1)
			dfa "DFANT"))
(if (= dspc plp2) (setq far (angle mp1 mp2)
			dfapoints (strcat plp1 "!" plp2)
			dfa "DFANT"))

  (if (and (/= dspc plp1 )(/= dspc plp2))(setq far (angle mp1 mp2)
		                               dfapoints (strcat plp1 "!" plp2)
					       dfa "DFAT"))
					       
                 
                 (command "insert" dfa fap th "" (angtos far))
(SETQ DFAENT (ENTGET (entlast)))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 dfapoints)))))
   (setq NEWSENTLIST (APPEND DFAENT XDATA))
  (ENTMOD NEWSENTLIST)
  
		 (setvar "clayer" prevlayer)
  

  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 irbd)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (SETQ NEWSENTLIST (subst (cons 8 "Irregular Boundary")(assoc 8 NEWSENTLIST) NEWSENTLIST ))
  (ENTMOD NEWSENTLIST)



  ;@@@@@add tool to find middle point and label irregular line or use sp and ep
  
  );DEFUN




;-------------------------------------------------------------ASSIGN LEVEL TO VINCULUM-----------------------------------

(DEFUN C:XVI (/)

  
  (setq prevlayer (getvar "CLAYER"))

   (IF (/= (setq bdyline (ssget  '((0 . "INSERT") (2 . "VINC")))) nil)(progn

									(SETQ LEVEL (GETSTRING "\nBulding Level:" T))

									(setq count 0)
									(REPEAT (SSLENGTH BDYLINE)
									   (SETQ SENT (CDR (ASSOC -1 (ENTGET (SSNAME bdyline COUNT)))))
									  (SETQ SENTLIST (ENTGET SENT))
									  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 LEVEL)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
   (ENTMOD NEWSENTLIST)
									  (setq count (+ count 1))
									  )
									))
  )

;-------------------------------------------------------------ASSIGN LEVEL TO OTHER LOT-----------------------------------

(DEFUN C:XLV (/)

  
  (setq prevlayer (getvar "CLAYER"))

   (IF (/= (setq bdyline (ssget  '((0 . "LWPOLYLINE")))) nil)(progn

									(setq blno (getstring t(strcat "\nBuilding Level [" prevblno "]:")))
  (if (= blno "")(setq blno prevblno)(setq prevblno blno))

    (setq count 0)
    (REPEAT (SSLENGTH BDYLINE)
    (SETQ P1 (CDR(ASSOC 10 (ENTGET (SSNAME bdyline COUNT)))))
    (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME bdyline COUNT)))))

    	    (SETQ XDATAI (ENTGET EN '("LANDXML")))
	    (IF (= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL) (progn
	      	     (COMMAND "CHANGE" en "" "P" "C" "6" "")
	      (princ (strcat "\nObject has not xdata " (rtos (car p1) 2 3) "," (rtos (cadr p1)2 3)))
	     ))
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))



    (if (/= (setq stringpos (vl-string-search "buildingLevelNo" xdatai )) nil)(progn
(setq wwpos (vl-string-position 34 xdatai (+ stringpos 17)))
(setq stringpos1 (- stringpos 1)
       stringpos2 (+ wwpos 2) )
);p
      
(progn

 ;else
    (setq stringpos (vl-string-search ">" xdatai ))
  (setq stringpos1  stringpos 
	stringpos2 (+ stringpos 1) 
	)
  )
      )
  
    
(setq xdatafront (substr xdatai 1  stringpos1 ))
    (setq xdataback (substr xdatai stringpos2 1000))
    (setq xdatai (strcat xdatafront " buildingLevelNo=\"" blno "\"" xdataback))

    (SETQ SENTLIST (ENTGET EN))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 xdatai)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)

    (setq count (+ count 1))
    );r
							     ));if polyline selected
							     
  );defun




;-------------------------------------------------------------ASSIGN POLYLINE AS OCCUPATION-----------------------------------

(DEFUN C:XAO (/)

  
  (setq prevlayer (getvar "CLAYER"))

 (SETQ select  (ENTSEL "\nSelect Object:"))
  (setq sent (car select))
  (setq irbd (gETSTRING T "\nOccupation Description:"))


(setq pltype (cdr (assoc 0 (ENTGET SENT))))
(SETQ SENTLIST (ENTGET SENT))
  
  (if (= pltype "LWPOLYLINE")(PROGN
  
  
  (SETQ PTLIST (LIST))
	    (foreach a sentlist
	      (if (= 10 (car a))

		(setq PTLIST (append PTLIST (list (cdr a))))
	      )				;IF
	      
	    )				;FOREACH 			
)
    );IF LWPOLYLINE

  (if (= pltype "POLYLINE")(PROGN

  (setq enlist (entget SenT))
	    (setq ptList (list));EMPTY LIST
	    (setq en2 (entnext SenT))
	    (setq enlist2 (entget en2))
               
	     (while
	      (not
		(equal (cdr (assoc 0 (entget (entnext en2)))) "SEQEND")
	      )
	      	(if (= (cdr(assoc 70 enlist2)) 16)(progn
	       	 (setq ptList (append ptList (list (cdr (assoc 10 enlist2)))))
		))
		 	       
	       (setq en2 (entnext en2))
	       (setq enlist2 (entget en2))
	       );W
   (setq ptList
			(append ptList (list (cdr (assoc 10 enlist2))))
		 
	       )
  ));IF 2D POLYLINE

   (if (= pltype "LINE")(PROGN

  (setq PTLIST (LIST (cdr (assoc 10 (ENTGET SENT)))))
  (SETQ PTLIST (append ptList (list (cdr (assoc 11 (ENTGET SENT))))))
		 
	       
  ));IF LINE

  (if (= pltype "ARC")(PROGN
			 
(SETQ CP (CDR (assoc 10 (ENTGET SENT))))
  (SETQ RADIUS (CDR (assoc 40 (ENTGET SENT))))
  (SETQ ANG1 (CDR (assoc 50 (ENTGET SENT))))
  (SETQ ANG2 (CDR (assoc 51 (ENTGET SENT))))
  (SETQ P1 (POLAR CP ANG1 RADIUS))
  (SETQ P2 (POLAR CP ANG2 RADIUS))
(SETQ PTLIST (LIST P1))
(SETQ PTLIST (APPEND PTLIST (LIST P2)))
));IF ARC
  
			     
  
		 (setq mp1 (TRANS (nth (- (/ (length ptlist) 2)1) ptlist) 0 1))
		 (setq mp2 (TRANS (nth  (/ (length ptlist) 2) ptlist) 0 1))
		 (setq mp (list (/ (+ (car mp1)(car mP2)) 2) (/ (+ (cadr mp1)(cadr mp2)) 2)))
		 (setq mprot (angle mp1 mp2))
		 (setq mprot90 (+ mprot (* 0.5 pi)))
  		 (SETQ 1POS (POLAR mp mprot90 (* TH 2.5)))
                 (IF (AND (> mprot  (* 0.5 pi)) (< mprot (* 1.5 pi)))(setq mprot (+ mprot pi))) ;if text is upsidedown reverse rotation
                 (setvar "clayer" "Drafting")
		 (COMMAND "TEXT" "J" "MC" 1pos TH (ANGTOS mprot 1 4) irbd)
		 (setvar "clayer" prevlayer)
  

  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 irbd)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
   (ENTMOD NEWSENTLIST)

    
  );DEFUN





;-----------------------------------------------------------CREATE RM BY POINTS----------------------------


(defun C:XAM (/)

    ;GET 1ST LINE INFO
    (graphscr)

  (setq prevlayer (getvar "CLAYER"))
    
    
  (SETQ P2 (GETPOINT "\nSelect Refernce Mark: "))
  (setq p1 (getpoint "\nSelect Corner to Reference: "))
  (SETQ comment (getstring T "\Geometry Comment (eg By me):"))
  (setq p1 (trans p1 1 0))
  (setq p2 (trans p2 1 0))
  (SETQ ANG (ANGLE P2 P1))
  (SETQ BEARING (ANGTOS ANG 1 4))
  (setq bearing (vl-string-subst "d" (chr 176) bearing));added for BricsCAD changes degrees to "d"
  (SETQ DIST (DISTANCE (LIST (CAR P1)(CADR P1))P2))

  (IF (= QROUND "YES")(PROGN

			(SETQ LLEN (DISTANCE (LIST (CAR P1)(CADR P1)) P2))

    ;ASSIGN ROUNDING FOR ANGLES BASED ON DISTANCE
    (IF (< LLEN MAXLEN1) (SETQ ROUND BRND1))
    (IF (AND (> LLEN MAXLEN1)(< LLEN MAXLEN2)) (SETQ ROUND BRND2))
    (IF (> LLEN MAXLEN2)(SETQ ROUND BRND3))


   
    ;GET ANGLE DELIMIETERS
    (SETQ SANG (ANGTOS ANG 1 4))
(setq sang (vl-string-subst "d" (chr 176) sang));added for BricsCAD changes degrees to "d"
    (setq CHRDPOS (vl-string-position 100 SANG 0))
    (setq MINPOS (vl-string-position 39 SANG 0))
    (setq SECPOS (vl-string-position 34 SANG 0))

    ;PARSE ANGLE
    (setq DEG  (atof (substr SANG 1  CHRDPOS )))
    (setq MINS  (atof (substr SANG (+ CHRDPOS 2)  (-(- MINPOS CHRDPOS)1))))
    (setq SEC  (atof (substr SANG (+ MINPOS 2)  (-(- SECPOS MINPOS )1))))

   
;ROUND ANGLE, NOTE SECONDS REMOVED
    (IF (and (= ROUND 60)(< SEC 30)) (SETQ SEC 0))
    (IF (and (= ROUND 60)(>= SEC 30)) (SETQ SEC 0
					    MINS (+ MINS 1)))	
    (IF (/= ROUND 60) (PROGN
			(SETQ SIP (FIX (/ SEC ROUND)))
			(SETQ SFP (- (/  SEC ROUND) SIP))
			(IF (>= SFP 0.5) (SETQ SIP (+ SIP 1)))
			(SETQ SEC (* SIP ROUND))
			)
      )

    ;ROUND ALL DISTANCES TO 5MM
    (IF (< LLEN DISTMAX1) (SETQ DROUND DRND1))
    (IF (AND (> LLEN DISTMAX1)(< LLEN DISTMAX2)) (SETQ DROUND DRND2))
    (IF (> LLEN DISTMAX2)(SETQ DROUND DRND3))
			
    (SETQ LIP (FIX (/ LLEN DROUND)))
    (SETQ LFP (- (/ LLEN DROUND) LIP))
    (IF (>= LFP 0.5 ) (SETQ LIP (+ LIP 1)))
    (SETQ LLEN (* LIP DROUND))
    
    (SETQ LDIST (RTOS LLEN 2 3))
    ;(IF (< LLEN 1) (SETQ DTS (STRCAT "0" DTS)))
      
   
		 
    
;STRING ANGLES
    (SETQ DEG (RTOS DEG 2 0))
    (SETQ MINS (RTOS MINS 2 0))
    (SETQ SEC (RTOS SEC 2 0))
    
;INCREMENT IF SECONDS ROUNDED TO 60
    (IF (= SEC  "60")
      (PROGN
	(SETQ SEC "00")
	(SETQ MINS (RTOS (+ (ATOF MINS ) 1) 2 0))
	)
      )
;INCREMENT IF MINUTES ROUNDED TO 60
    (IF (= MINS "60")
      (PROGN
	(SETQ MINS "00")
	(SETQ DEG (RTOS (+ (ATOF DEG ) 1) 2 0))
	)
      )
;FIX IF INCREMENTING PUSHES DEG PAST 360    
    (IF (= DEG "360")(SETQ DEG "0"))
;ADD ZEROS TO SINGLE NUMBERS	
 (IF (= (STRLEN MINS) 1)(SETQ MINS (STRCAT "0" MINS)))
  (IF (= (STRLEN SEC) 1)(SETQ SEC (STRCAT "0" SEC)))

;TRUNCATE BEARINGS IF 00'S
  (IF (AND (= MINS "00") (= SEC "00")) (SETQ MINSS ""
					     MINS ""
					     SECS ""
					     SEC "")
        (SETQ MINSS(STRCAT MINS "'")
	  SECS (STRCAT SEC "\""))
	  )
    (IF (= SEC "00")(SETQ SECS ""
			    SEC ""))

			

    ;CONCATENATE BEARING
    (SETQ BEARING (STRCAT DEG "d" MINSS SECS ))

			(IF (or (/= sec "")(/= MINS ""))(SETQ DEG (STRCAT DEG ".")))

  (SETQ LBEARING (STRCAT DEG MINS SEC))


    

			);P&IF


(PROGN;ELSE

  

  (SETQ DPOS (vl-string-position 100 BEARING 0))
  (setq Wpos (vl-string-position 39 BEARING 0))
  (setq WWpos (vl-string-position 34 BEARING 0))

    (setq DEG (substr BEARING 1 Dpos))
      (setq MINS (substr BEARING (+ Dpos 2) (- (- WPOS DPOS) 1)))
      (setq SEC (substr BEARING (+ Wpos 2) (- (- WWpos Wpos) 1)))

  (IF (= (STRLEN MINS) 1)(SETQ MINS (STRCAT "0" MINS)))
  (IF (= (STRLEN SEC) 1)(SETQ SEC (STRCAT "0" SEC)))
  
  ;TRUNCATE BEARINGS IF 00'S
  (IF (AND (= MINS "00") (= SEC "00")) (SETQ MINSS ""
					     MINS ""
					     SECS ""
					     SEC "")
        (SETQ MINSS(STRCAT MINS "'")
	  SECS (STRCAT SEC "\""))
	  )
    (IF (= SECS "00\"")(SETQ SECS ""
			    SEC ""))

			

    ;CONCATENATE BEARING
    (SETQ BEARING (STRCAT DEG "d" MINSS SECS ))

			(IF (or (/= sec "")(/= MINS ""))(SETQ DEG (STRCAT DEG ".")))

  (SETQ LBEARING (STRCAT DEG MINS SEC))
  (SETQ LDIST (RTOS DIST 2 3))

  ));PELSE&IF
  
(setq prmtype rmtype)
  (setq rmtype (getstring T (strcat "\nType [" rmtype "](#-comment)(* for list):")))

  ;look for mark comment
  (setq minpos1 (vl-string-position 45 rmtype 0))
	(if (= minpos1 nil)(setq rmcomment "")(progn
					      (setq rmcomment (substr rmtype ( + minpos1 2) 50))
					      (setq rmtype (substr rmtype 1  minpos1 ))
					      )
	  )
  ;execute list finder
  (if (= rmtype "*")(progn
		      (setq workingselnum tselnum)
		      (setq names rmtypelist)
		      (dbox)
		      (setq rmtype returntype)
		      (setq tselnum workingselnum)
		      )
    )
    

  

  
(if (= rmtype "CB" ) (setq rmtype "Conc Block"))
  (if (= rmtype "")(setq rmtype prmtype ))
  (if (= (member rmtype rmtypelist) nil) (progn
					     (alert "\nType not fount, please choose from list" )
					   (setq workingselnum tselnum)
					     (setq names rmtypelist)
		      (dbox)
		      (setq rmtype returntype)
					   (setq tselnum workingselnum)
					     )
    )

  
  (setq prmstate rmstate)
 
  
  (setq rmstate (getstring (strcat "\nState eg Found/Placed[f/p](* for list)(default is placed):")))
(if (or (= rmstate "f") (= rmstate "F")) (setq rmstate "Found"))
(if (or (= rmstate "p") (= rmstate "P") (= rmstate "")) (setq rmstate "Placed"))

  (if (= rmstate "*")(progn
		       (setq workingselnum sselnum)
		      (setq names rmstatelist)
		      (dbox)
		      (setq rmstate returntype)
		       (setq sselnum workingselnum)
		      )
    )
  
  (if (= (member rmstate rmstatelist) nil) (progn
					     (Alert "\nState not fount, please choose from list:" )
					      (setq workingselnum sselnum)
		      (setq names rmstatelist)
		      (dbox)
		      (setq rmstate returntype)
		       (setq sselnum workingselnum)
					     )
    )

;condition removed V1.12
 (setq rmcondition "")
  
(if (/= rmstate "Placed")(progn
   (setq rmrefdp (getstring T(strcat "\nReference DP number (default is nil)(L=Last " lrmrefdp "):")))

     (if (or (= rmrefdp "LAST")(= rmrefdp "Last")(= rmrefdp "L")(= rmrefdp "l")(= rmrefdp "last"))(setq rmrefdp lrmrefdp))
   (setq lrmrefdp rmrefdp)
  (if (= (substr rmrefdp 1 2) "dp") (setq rmrefdp (strcat "DP" ( substr rmrefdp 3 50))))
  (if (= (substr rmrefdp 1 2) "cp") (setq rmrefdp (strcat "CP" ( substr rmrefdp 3 50))))
    (if (and (>= (ascii (substr rmrefdp 1 1)) 48)(<= (ascii (substr rmrefdp 1 1)) 57))(setq rmrefdp (strcat "DP" rmrefdp)));will add dp if you enter only the number
   )
    (setq rmrefdp "")
    )
  

    ;DRAW LINE 1
  (setq prevlayer (getvar "CLAYER"))
(SETVAR "CLAYER"  "RM Connection" )

  (setq p1 (trans p1 0 1))
  (setq p2 (trans p2 0 1))
  (command "line" p2 P1 "")
  
;Add observation data to line as XDATA
  

		   	
(if (/= comment "")(setq ocomment (strcat "><FieldNote>\"" comment "\"</FieldNote></ReducedObservation>"))(setq ocomment "/>"))
(if (/= rmrefdp "")(setq ormrefdpads (strcat " adoptedDistanceSurvey=\"" rmrefdp "\""))(setq ormrefdpads ""))
(SETQ BDINFO (STRCAT "azimuth=\"" lbearing "\" horizDistance=\"" ldist "\" distanceType=\"Measured\"" " distanceAccClass=\"" rmstate "\"" ormrefdpads ocomment))
(SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 BDINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)
 

  ;GET LAST LINE DATA
  (SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
   (setq p1 (CDR(ASSOC 10 sentlist)))
   (setq p2 (CDR(ASSOC 11 sentlist)))
  (setq p1 (trans p1 0 1))
  (setq p2 (trans p2 0 1))

  
(lrm);DRAW DP REF INFO

 


  (SETVAR "CLAYER" "Monument" )
  (COMMAND "POINT" P1)


  ;check for no values and replace with "none"
  (if (= rmrefdp "")(setq rmrefdp "none"))
  (if (= rmcondition "")(setq rmcondition "none"))
  (if (= rmrefdp "")(setq rmrefdp "none"))
  ;(if (or (= rmtype "SSM")(= rmtype "PM")(= rmtype "TS")(= rmtype "MM")(= rmtype "GB")(= rmtype "CP")(= rmtype "CR"))(setq rmcomment (strcat rmcomment "used as reference mark")))
 


     (if (/= rmcomment "")(setq ormcomment (strcat " desc=\"" rmcomment "\""))(setq ormcomment ""))
   (if (/= rmcondition "none")(setq ormcondition (strcat " condition=\"" rmcondition "\""))(setq ormcondition ""))
   (if (/= rmrefdp "none")(setq ormrefdp (strcat " originSurvey=\"" rmrefdp "\""))(setq ormrefdp ""))
  
    (SETQ PTINFO (STRCAT "type=\"" rmtype "\" state=\""  rmstate "\"" ormcondition  ormrefdp  ormcomment " />" ));Note comment for desc in xml added to distance entry seperated by a space
(SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 PTINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)


  
  ;DRAW RM BLOCK AND ADD RM POINT
  (SETVAR "CLAYER" "Drafting" )
  (COMMAND "._INSERT" "RM" "_S" TH P2 "0");changed for BricsCAD
;  (SETQ RMB (ENTLAST))
;  (SETQ ENTSS (SSADD))
;  (SSADD RMB ENTSS)
;(COMMAND "DRAWORDER" ENTSS "" "FRONT")
  


  (setvar "clayer" prevlayer )
)




;-------------------------------------------------------------SHORT LINE TABLE-----------------------------------

(DEFUN C:XSL (/)

  (setq prevlayer (getvar "CLAYER"))
(SETQ COMMENT "")
 (SETQ LINES (SSGET  '((0 . "LINE"))))

  (IF (/= SCLOUNT NIL)  (SETQ PSLCOUNT SLCOUNT)(SETQ SLCOUNT ""
						     PSLCOUNT ""))
  (SETQ SLCOUNT (GETSTRING (STRCAT "\nShort Line Starting Number (" SLCOUNT "):" )))
  (IF (= SLCOUNT "" )(SETQ SLCOUNT PSLCOUNT))

  (IF (= SLTPOS NIL)
    (progn
      (SETQ SLTPOS (GETPOINT "\nShort Line Table Position:"))

        (SETVAR "CLAYER"  "Drafting" )


    			 ;box corners
			 (setq p10 (list (+ (car SLTPOS) 0)(+ (cadr SLTPOS) (* -2.5 th))))
			 (setq p11 (list (+ (car SLTPOS) (* 4 th))(+ (cadr SLTPOS)  0 )))
			 (setq p12 (list (+ (car SLTPOS) (* 13 th))(+ (cadr SLTPOS) (* -2.5 th))))
			 (setq p13 (list (+ (car SLTPOS) (* 21 th))(+ (cadr SLTPOS)  0 )))
			 
			 ;draw boxes
			 (command "rectangle" p10 p11)
			 (command "rectangle" p11 p12)
			 (command "rectangle" p12 p13)
			 
			 ;text insertion points
			 (setq p20 (list (+ (car SLTPOS) (* 2 th))(+ (cadr SLTPOS)  (* -1.25 th ))))
			 (setq p21 (list (+ (car SLTPOS) (* 8.5 th))(+ (cadr SLTPOS)  (* -1.25 th ))))
			 (setq p22 (list (+ (car SLTPOS) (* 17 th))(+ (cadr SLTPOS)  (* -1.25 th ))))
			 
			 ;create text
			 (command "text" "j" "mc" p20 th "90" "NUM")
			 (command "text" "j" "mc" p21 th "90" "BEARING")
			 (command "text" "j" "mc" p22 th "90" "DISTANCE")
			 ;reset pm box mark point
			 (setq SLTPOS p10)
    ));P&IF FIRST BOX MARK
  


    
  

  (SETQ COUNT 0)
(REPEAT (SSLENGTH LINES)
(SETQ P1 (CDR(ASSOC 10 (ENTGET (SSNAME LINES COUNT)))))
  (SETQ P1 (LIST (CAR P1) (CADR P1)));2DISE P1 TO GIVE 2D DISTANCE
  (SETQ P2 (CDR(ASSOC 11 (ENTGET (SSNAME LINES COUNT)))))
  (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME LINES COUNT)))))
  (SETQ LAYER (CDR(ASSOC 8 (ENTGET (SSNAME LINES COUNT)))))
  (SETQ ANG (ANGLE P1 P2))
  (SETQ BEARING (ANGTOS ANG 1 4));REQUIRED FOR ELSE ROUND
  (setq bearing (vl-string-subst "d" (chr 176) bearing));added for BricsCAD using degrees instead of "d"
  (SETQ DIST (DISTANCE (LIST (CAR P1)(CADR P1)) P2));REQUIRED FOR ELSE ROUND


  (IF (= QROUND "YES")(PROGN

			(SETQ LLEN (DISTANCE (LIST (CAR P1)(CADR P1)) P2))

    ;ASSIGN ROUNDING FOR ANGLES BASED ON DISTANCE
    (IF (< LLEN MAXLEN1) (SETQ ROUND BRND1))
    (IF (AND (> LLEN MAXLEN1)(< LLEN MAXLEN2)) (SETQ ROUND BRND2))
    (IF (> LLEN MAXLEN2)(SETQ ROUND BRND3))

   
    ;GET ANGLE DELIMIETERS
    (SETQ SANG (ANGTOS ANG 1 4))
    (setq sang (vl-string-subst "d" (chr 176) sang));added for BricsCAD using degrees instead of "d"
    (setq CHRDPOS (vl-string-position 100 SANG 0))
    (setq MINPOS (vl-string-position 39 SANG 0))
    (setq SECPOS (vl-string-position 34 SANG 0))

    ;PARSE ANGLE
    (setq DEG  (atof (substr SANG 1  CHRDPOS )))
    (setq MINS  (atof (substr SANG (+ CHRDPOS 2)  (-(- MINPOS CHRDPOS)1))))
    (setq SEC  (atof (substr SANG (+ MINPOS 2)  (-(- SECPOS MINPOS )1))))

   
;ROUND ANGLE, NOTE SECONDS REMOVED
     (IF (and (= ROUND 60)(< SEC 30)) (SETQ SEC 0))
    (IF (and (= ROUND 60)(>= SEC 30)) (SETQ SEC 0
					    MINS (+ MINS 1)))	
    (IF (/= ROUND 60) (PROGN
			(SETQ SIP (FIX (/ SEC ROUND)))
			(SETQ SFP (- (/  SEC ROUND) SIP))
			(IF (>= SFP 0.5) (SETQ SIP (+ SIP 1)))
			(SETQ SEC (* SIP ROUND))
			)
      )

    ;ROUND ALL DISTANCES
    (IF (< LLEN DISTMAX1) (SETQ DROUND DRND1))
    (IF (AND (> LLEN DISTMAX1)(< LLEN DISTMAX2)) (SETQ DROUND DRND2))
    (IF (> LLEN DISTMAX2)(SETQ DROUND DRND3))
			
    (SETQ LIP (FIX (/ LLEN DROUND)))
    (SETQ LFP (- (/ LLEN DROUND) LIP))
    (IF (>= LFP 0.5 ) (SETQ LIP (+ LIP 1)))
    (SETQ LLEN (* LIP DROUND))

    (SETQ LDIST (RTOS LLEN 2 3))
   
		 
    
;STRING ANGLES
    (SETQ DEG (RTOS DEG 2 0))
    (SETQ MINS (RTOS MINS 2 0))
    (SETQ SEC (RTOS SEC 2 0))
    
;INCREMENT IF SECONDS ROUNDED TO 60
    (IF (= SEC  "60")
      (PROGN
	(SETQ SEC "00")
	(SETQ MINS (RTOS (+ (ATOF MINS ) 1) 2 0))
	)
      )
;INCREMENT IF MINUTES ROUNDED TO 60
    (IF (= MINS "60")
      (PROGN
	(SETQ MINS "00")
	(SETQ DEG (RTOS (+ (ATOF DEG ) 1) 2 0))
	)
      )
;FIX IF INCREMENTING PUSHES DEG PAST 360    
    (IF (= DEG "360")(SETQ DEG "0"))
;ADD ZEROS TO SINGLE NUMBERS	
 (IF (= (STRLEN MINS) 1)(SETQ MINS (STRCAT "0" MINS)))
  (IF (= (STRLEN SEC) 1)(SETQ SEC (STRCAT "0" SEC)))

;TRUNCATE BEARINGS IF 00'S
  (IF (AND (= MINS "00") (= SEC "00")) (SETQ MINSS ""
					     SECS "")
        (SETQ MINSS(STRCAT MINS "'")
	  SECS (STRCAT SEC "\""))
	  )
    (IF (= SEC "00")(SETQ SECS ""
			    SEC ""))

			

    ;CONCATENATE BEARING
    (SETQ BEARING (STRCAT DEG "d" MINSS SECS ))

			(IF (or (/= sec "00")(/= MINS "00"))(SETQ DEG (STRCAT DEG ".")))

  (SETQ LBEARING (STRCAT DEG MINS SEC))
			
    

			);P&IF


(PROGN;ELSE

  

  (SETQ DPOS (vl-string-position 100 BEARING 0))
  (setq Wpos (vl-string-position 39 BEARING 0))
  (setq WWpos (vl-string-position 34 BEARING 0))

    (setq DEG (substr BEARING 1 Dpos))
      (setq MINS (substr BEARING (+ Dpos 2) (- (- WPOS DPOS) 1)))
      (setq SEC (substr BEARING (+ Wpos 2) (- (- WWpos Wpos) 1)))

  (IF (= (STRLEN MINS) 1)(SETQ MINS (STRCAT "0" MINS)))
  (IF (= (STRLEN SEC) 1)(SETQ SEC (STRCAT "0" SEC)))
  
  (IF (AND (= MINS "00") (= SEC "00")) (SETQ MINSS ""
					     SECS ""
					     MINS ""
					     SEC "")
    (SETQ MINSS(STRCAT MINS "'")
	  SECS (STRCAT SEC "\""))
	  	  )
  (IF (= SECS "00\"")(SETQ SECS ""
			   SEC ""))
  
  (SETQ BEARING (STRCAT DEG "d" MINSS SECS ))

  (IF (/= MINS "")(SETQ DEG (STRCAT DEG ".")))

  
  
  (SETQ LBEARING (STRCAT DEG MINS SEC))
  (SETQ LDIST (RTOS DIST 2 3))

  ));PELSE&IF

  (COMMAND "ERASE" EN "")
  (SETVAR "CLAYER" layer)
  (COMMAND "LINE" (trans P1 0 1)(trans  P2 0 1) "")
  
(SETQ BDINFO (STRCAT "azimuth=\"" lbearing "\" horizDistance=\"" ldist "\" distanceType=\"Measured\"/>"))
 (SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 BDINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)


  (LBS)

  (SETQ COUNT (+ COUNT 1))
  (SETQ SLCOUNT (RTOS (+ (ATOF SLCOUNT) 1) 2 0))

  );R


      (SETVAR "CLAYER" prevlayer)

  );DEFUN




;-------------------------------------------------------------SHORT ARC TABLE-----------------------------------

(DEFUN C:XSC (/)

  (setq prevlayer (getvar "CLAYER"))
(SETQ COMMENT "")
 (SETQ LINES (SSGET  '((0 . "ARC"))))

  (IF (/= slcount NIL)  (SETQ Pslcount slcount)(SETQ slcount ""
						     Pslcount ""))
  (SETQ slcount (GETSTRING (STRCAT "\nShort Arc Starting Number (" slcount "):" )))
  (IF (= slcount "" )(SETQ slcount Pslcount))

  (IF (= SLATPOS NIL)
    (progn
      (SETQ SLATPOS (GETPOINT "\nShort Arc Table Position:"))

        (SETVAR "CLAYER"  "Drafting" )


    			 ;box corners
			 (setq p10 (list (+ (car SLATPOS) 0)(+ (cadr SLATPOS) (* -2.5 th))))
			 (setq p11 (list (+ (car SLATPOS) (* 4 th))(+ (cadr SLATPOS)  0 )))
			 (setq p12 (list (+ (car SLATPOS) (* 13 th))(+ (cadr SLATPOS) (* -2.5 th))))
			 (setq p13 (list (+ (car SLATPOS) (* 21 th))(+ (cadr SLATPOS)  0 )))
                         (setq p14 (list (+ (car SLATPOS) (* 29 th))(+ (cadr SLATPOS)  (* -2.5 th ))))
                         (setq p15 (list (+ (car SLATPOS) (* 37 th))(+ (cadr SLATPOS)  0 )))
      
			 
			 ;draw boxes
			 (command "rectangle" p10 p11)
			 (command "rectangle" p11 p12)
			 (command "rectangle" p12 p13)
                         (command "rectangle" p13 p14)
                         (command "rectangle" p14 p15)
      
			 
			 ;text insertion points
			 (setq p20 (list (+ (car SLATPOS) (* 2 th))(+ (cadr SLATPOS)  (* -1.25 th ))))
			 (setq p21 (list (+ (car SLATPOS) (* 8.5 th))(+ (cadr SLATPOS)  (* -1.25 th ))))
			 (setq p22 (list (+ (car SLATPOS) (* 17 th))(+ (cadr SLATPOS)  (* -1.25 th ))))
                         (setq p23 (list (+ (car SLATPOS) (* 25 th))(+ (cadr SLATPOS)  (* -1.25 th ))))
                         (setq p24 (list (+ (car SLATPOS) (* 33 th))(+ (cadr SLATPOS)  (* -1.25 th ))))
			 
			 ;create text
			 (command "text" "j" "mc" p20 th "90" "NUM")
			 (command "text" "j" "mc" p21 th "90" "BEARING")
			 (command "text" "j" "mc" p22 th "90" "DISTANCE")
                         (command "text" "j" "mc" p23 th "90" "ARC")
                         (command "text" "j" "mc" p24 th "90" "RADIUS")
			 ;reset pm box mark point
			 (setq SLATPOS p10)
    ));P&IF FIRST BOX MARK
  


    
  
  (SETQ COUNT 0)
(REPEAT (SSLENGTH LINES)
(SETQ CP (CDR(ASSOC 10 (ENTGET (SSNAME LINES COUNT)))))
  (SETQ RADIUS (CDR(ASSOC 40 (ENTGET (SSNAME LINES COUNT)))))
  (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME LINES COUNT)))))
  (SETQ LAYER (CDR(ASSOC 8 (ENTGET (SSNAME LINES COUNT)))))

  (SETQ ANG1 (CDR(ASSOC 50 (ENTGET (SSNAME LINES COUNT)))))
  (SETQ ANG2 (CDR(ASSOC 51 (ENTGET (SSNAME LINES COUNT)))))

  (SETQ P1 (POLAR CP ANG1 RADIUS))
  (SETQ P2 (POLAR CP ANG2 RADIUS))
  (SETQ ANG (ANGLE P1 P2))
  
(SETQ CURVEROT "ccw")
  ;calc curve midpoint
  (setq a1 (angle CP p1))
  (setq a2 (angle CP p2))
  (if (= curverot "ccw")(setq da (- a2 a1))(setq da (- a1 a2)))
  (if (< da 0)(setq da (+ da (* 2 pi))))
    (SETQ DA (/ DA 2))
    (IF (= CURVEROT "ccw")(setq midb (+ a1 da))(setq midb (+ a2 da)))
  (setq amp (polar CP midb radius))

  (SETQ BEARING (ANGTOS ANG 1 4))
  (setq bearing (vl-string-subst "d" (chr 176) bearing));added for BricsCAD changes degrees to "d"
  (SETQ DIST (DISTANCE (LIST (CAR P1)(CADR P1))P2))

 (IF (= QROUND "YES")(PROGN

			(SETQ LLEN (DISTANCE (LIST (CAR P1)(CADR P1)) P2))

    ;ASSIGN ROUNDING FOR ANGLES BASED ON DISTANCE
    (IF (< LLEN MAXLEN1) (SETQ ROUND BRND1))
    (IF (AND (> LLEN MAXLEN1)(< LLEN MAXLEN2)) (SETQ ROUND BRND2))
    (IF (> LLEN MAXLEN2)(SETQ ROUND BRND3))

   
    ;GET ANGLE DELIMIETERS
    (SETQ SANG (ANGTOS ANG 1 4))
    (setq sang (vl-string-subst "d" (chr 176) sang));added for BricsCAD changes degrees to "d"
    (setq CHRDPOS (vl-string-position 100 SANG 0))
    (setq MINPOS (vl-string-position 39 SANG 0))
    (setq SECPOS (vl-string-position 34 SANG 0))

    ;PARSE ANGLE
    (setq DEG  (atof (substr SANG 1  CHRDPOS )))
    (setq MINS  (atof (substr SANG (+ CHRDPOS 2)  (-(- MINPOS CHRDPOS)1))))
    (setq SEC  (atof (substr SANG (+ MINPOS 2)  (-(- SECPOS MINPOS )1))))

   
;ROUND ANGLE, NOTE SECONDS REMOVED
     (IF (and (= ROUND 60)(< SEC 30)) (SETQ SEC 0))
    (IF (and (= ROUND 60)(>= SEC 30)) (SETQ SEC 0
					    MINS (+ MINS 1)))	
    (IF (/= ROUND 60) (PROGN
			(SETQ SIP (FIX (/ SEC ROUND)))
			(SETQ SFP (- (/  SEC ROUND) SIP))
			(IF (>= SFP 0.5) (SETQ SIP (+ SIP 1)))
			(SETQ SEC (* SIP ROUND))
			)
      )

    ;ROUND ALL DISTANCES TO 5MM
    (IF (< LLEN DISTMAX1) (SETQ DROUND DRND1))
    (IF (AND (> LLEN DISTMAX1)(< LLEN DISTMAX2)) (SETQ DROUND DRND2))
    (IF (> LLEN DISTMAX2)(SETQ DROUND DRND3))
			
    (SETQ LIP (FIX (/ LLEN DROUND)))
    (SETQ LFP (- (/ LLEN DROUND) LIP))
    (IF (>= LFP 0.5 ) (SETQ LIP (+ LIP 1)))
    (SETQ LLEN (* LIP DROUND))
    (SETQ LDIST (RTOS LLEN 2 3))
   
		 
    
;STRING ANGLES
    (SETQ DEG (RTOS DEG 2 0))
    (SETQ MINS (RTOS MINS 2 0))
    (SETQ SEC (RTOS SEC 2 0))
    
;INCREMENT IF SECONDS ROUNDED TO 60
    (IF (= SEC  "60")
      (PROGN
	(SETQ SEC "00")
	(SETQ MINS (RTOS (+ (ATOF MINS ) 1) 2 0))
	)
      )
;INCREMENT IF MINUTES ROUNDED TO 60
    (IF (= MINS "60")
      (PROGN
	(SETQ MINS "00")
	(SETQ DEG (RTOS (+ (ATOF DEG ) 1) 2 0))
	)
      )
;FIX IF INCREMENTING PUSHES DEG PAST 360    
    (IF (= DEG "360")(SETQ DEG "0"))
;ADD ZEROS TO SINGLE NUMBERS	
 (IF (= (STRLEN MINS) 1)(SETQ MINS (STRCAT "0" MINS)))
  (IF (= (STRLEN SEC) 1)(SETQ SEC (STRCAT "0" SEC)))

;TRUNCATE BEARINGS IF 00'S
  (IF (AND (= MINS "00") (= SEC "00")) (SETQ MINSS ""
					     MINS ""
					     SECS ""
					     SEC "")
    ;ELSE
        (SETQ MINSS(STRCAT MINS "'")
	  SECS (STRCAT SEC "\""))
	  )
    (IF (= SECS "00\"")(SETQ SECS ""
			     SEC ""))

			

    ;CONCATENATE BEARING
    (SETQ BEARING (STRCAT DEG "d" MINSS SECS ))

			(IF (or (/= sec "")(/= MINS ""))(SETQ DEG (STRCAT DEG ".")))

  (SETQ LBEARING (STRCAT DEG MINS SEC))
			
    

			);P&IF ROUNDING


(PROGN;ELSE

  

  (SETQ DPOS (vl-string-position 100 BEARING 0))
  (setq Wpos (vl-string-position 39 BEARING 0))
  (setq WWpos (vl-string-position 34 BEARING 0))

    (setq DEG (substr BEARING 1 Dpos))
      (setq MINS (substr BEARING (+ Dpos 2) (- (- WPOS DPOS) 1)))
      (setq SEC (substr BEARING (+ Wpos 2) (- (- WWpos Wpos) 1)))

  (IF (= (STRLEN MINS) 1)(SETQ MINS (STRCAT "0" MINS)))
  (IF (= (STRLEN SEC) 1)(SETQ SEC (STRCAT "0" SEC)))
  
  (IF (AND (= MINS "00") (= SEC "00")) (SETQ MINSS ""
					     SECS ""
					     MINS ""
					     SEC "")
    (SETQ MINSS(STRCAT MINS "'")
	  SECS (STRCAT SEC "\""))
	  )
  (IF (= SECS "00\"")(SETQ SECS ""
			   SEC ""))
  
  (SETQ BEARING (STRCAT DEG "d" MINSS SECS ))

  	(IF (or (/= sec "")(/= MINS ""))(SETQ DEG (STRCAT DEG ".")))

  (SETQ LBEARING (STRCAT DEG MINS SEC))
  (SETQ LDIST (RTOS DIST 2 3))

  ));PELSE&IF




   (SETQ MAST (SQRT (- (*  RADIUS  RADIUS) (* (/  DIST 2)(/ DIST 2 )))))





  
  ;(SETQ O (* 2 (ATAN (/ (/  DIST 2) MAST))))
  (SETQ O (- ANG2 ANG1))
  (IF (< O 0) (SETQ O (+ O (* PI 2))))
  	   (setq arclength (rtos ( *  radius O) 2 3))



  
  (setq digchaz (angle p1 p2))
    (SETQ O1 (* 2 (ATAN (/ (/ (distance p1 p2) 2) MAST))))
	    (setq remhalfO  (- (* 0.5 pi) (/ O1 2)))
	    (if (and (= curverot "ccw") (<= (atof arclength) (* pi  radius)))(setq raybearing (+  digchaz  remhalfO)))
	    (IF (and (= curverot "cw") (<= (atof arclength) (* pi  radius)))(setq raybearing (-  digchaz  remhalfO)))
	    (IF (and (= curverot "ccw") (> (atof arclength) (* pi  radius)))(setq raybearing (-  digchaz  remhalfO)))
	    (if (and (= curverot "cw") (> (atof arclength) (* pi  radius)))(setq raybearing (+  digchaz  remhalfO)))

  

  
  
(if (= qround "YES")(progn 
 ;ROUND ALL DISTANCES TO 5MM
    (SETQ LIP (FIX (/ (atof ARCLENGTH) DROUND)))
    (SETQ LFP (- (/ (atof ARCLENGTH) DROUND) LIP))
    (IF (>= LFP 0.5 ) (SETQ LIP (+ LIP 1)))
    (SETQ ARCLENGTH (* LIP DROUND))
    
    (SETQ ARCLENGTH (RTOS ARCLENGTH 2 3))
    ))

  (if (= qround "YES")(progn 
 ;ROUND ALL DISTANCES TO 5MM
    (SETQ LIP (FIX (/ radius DROUND)))
    (SETQ LFP (- (/ radius DROUND) LIP))
    (IF (>= LFP 0.5 ) (SETQ LIP (+ LIP 1)))
    (SETQ radius(* LIP DROUND))
    
   
    ))
  


  

  (COMMAND "ERASE" EN "")
  (SETVAR "CLAYER" layer)
  (COMMAND "ARC" "c" (TRANS CP 0 1) (TRANS P1 0 1) (TRANS P2 0 1 ))

  
      (if (/= comment "")(setq ocomment (strcat "><FieldNote>\"" comment "\"</FieldNote></ReducedArcObservation>"))(setq ocomment "/>"))
(SETQ BDINFO (STRCAT "chordAzimuth=\"" Lbearing "\" length=\"" arclength "\" radius=\"" (RTOS RADIUS 2 3)  "\" rot=\"ccw\"  arcType=\"Measured\"" ocomment))
 
(SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 BDINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)

      (setq tp1 p1)
      (setq tp2 p2)
   
      (setq lradius (rtos radius 2 3))
(lbSA);label line if not already labelled;label arc using function



  (SETQ COUNT (+ COUNT 1))
    (SETQ slcount (RTOS (+ (ATOF slcount) 1) 2 0))

  );R


      (SETVAR "CLAYER" prevlayer)

  );DEFUN





;--------------------------------------------------------------LINE LABELLER FUCNTION---------------------------
	    
(defun lba (/)

  
  (SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
   (setq tp1 (CDR(ASSOC 10 sentlist)))
   (setq tp2 (CDR(ASSOC 11 sentlist)))

       
    (SETQ AANG (ANGLE tP1 tP2))
    (SETQ CP1 (TRANS  tP1 0 1))
    (SETQ CP2 (TRANS  tP2 0 1))
    (SETQ ANG (ANGLE CP1 CP2))
    (SETQ DANG (* ANG (/ 180 PI)))

    (IF (AND (> DANG 90) (<= DANG 270)) (PROGN
					 (SETQ CP1 (TRANS tP2 0 1))
					 (SETQ CP2 (TRANS tP1 0 1))
					 (SETQ ANG (ANGLE CP1 CP2))
                                         (SETQ DANG (* ANG (/ 180 PI)))
					 )
      )

  ;REDUCE SIZE ON SMALL LINES

  
  (SETQ THP TH)
  (IF (AND (< (ATOF LDIST) (* 10 th)) (<  (* (ATOF LDIST) 0.1) TH)(= ATHR "Y")(/= LDIST ""))(SETQ TH (* (ATOF LDIST) 0.1)))
  
  
    (SETQ MPE (/ (+ (CAR CP1 ) (CAR CP2)) 2))
    (SETQ MPN (/ (+ (CADR CP1 ) (CADR CP2)) 2))
    (SETQ MP (LIST MPE MPN))
    (SETQ BPOS (POLAR MP (+ ANG (* 0.5 PI)) TH))
    (SETQ DPOS (POLAR MP (- ANG (* 0.5 PI)) TH))
    (if (or (= compile 0) (= cbrq "Y") (/= bearing ""))(SETQ BTS (vl-string-subst  "�" "d" bearing)));if not compile

  (if (/= comment "")(setq comment (strcat " "comment)))

  (setq prevlayer (getvar "CLAYER"))
  (SETVAR "CLAYER"  "Drafting" )
  
  (if (or (= compile 0) (= cbrq "Y") (/= bearing ""))    (COMMAND "TEXT" "J" "MC" BPOS TH (ANGTOS ANG 1 4) BTS));if not compile label bearing

   (if (/= ldist "") (COMMAND "TEXT" "J" "MC" DPOS TH (ANGTOS ANG 1 4) (strcat ldist (strcase comment))))

  
  (if ( = labelyeolddist 1)(progn
			    
(SETQ YODPOS (POLAR MP (- ANG (* 0.5 PI)) (* 2.5 TH)))
  (setq textstyle (getvar "textstyle"))
(SETQ textfont (ENTGET (tblobjname "style" textstyle)))
(setq theElist (subst (cons 50 (* 20 (/ PI 180)))(assoc 50 theElist) textfont));make ye old distances slanty
(entmod theElist)
  (COMMAND "TEXT" "J" "MC" YODPOS TH (ANGTOS ANG 1 4) prevdist )
  (setq theElist (subst (cons 50 0)(assoc 50 theElist) textfont));set slanty back to straight
(entmod theElist)
(setq labelyeolddist 0)

			    
			    ))


	 (SETQ TH THP)
    
    )

;--------------------------------------------------------------ARC LABELLER FUNCTION--------------------------

(DEFUN LBARC (/)

     
    (SETQ AANG (ANGLE tP1 tP2))
    (SETQ CP1 (TRANS  tP1 0 1))
    (SETQ CP2 (TRANS  tP2 0 1))
    (SETQ ANG (ANGLE CP1 CP2))
    (SETQ DANG (* ANG (/ 180 PI)))

    (IF (AND (> DANG 90) (<= DANG 270)) (PROGN
					 (SETQ CP1 (TRANS tP2 0 1))
					 (SETQ CP2 (TRANS tP1 0 1))
					 (SETQ ANG (ANGLE CP1 CP2))
                                         (SETQ DANG (* ANG (/ 180 PI)))
					 )
      )

  ;REDUCE SIZE ON SMALL LINES

  
  (SETQ THP TH)
  (IF (AND (< (ATOF LDIST) (* 10 th)) (<  (* (ATOF LDIST) 0.1) TH)(= ATHR "Y"))(SETQ TH (* (ATOF LDIST) 0.1)))
  
  
    (SETQ MP (TRANS AMP 0 1))
    

  (IF (or (AND (OR (>= AANG (* 1.5 PI))(<= AANG (* 0.5 PI)))( = curverot "ccw"))(AND (<= AANG (* 1.5 PI))(> AANG (* 0.5 PI))( = curverot "cw")))
    (progn
      (setq MP (POLAR MP (+ ANG (* 0.5 PI)) (* TH 6.7)))
      )
    
    )
    (SETQ BPOS (POLAR MP (- ANG (* 0.5 PI))  TH))
    (SETQ DPOS (POLAR MP (- ANG (* 0.5 PI)) (* 2.5 TH)))
    (SETQ APOS (POLAR MP (- ANG (* 0.5 PI)) (* 3.9 TH)))
    (SETQ RPOS (POLAR MP (- ANG (* 0.5 PI)) (* 5.3 TH)))
 
    (SETQ BTS (vl-string-subst  "�" "d" bearing))

  (if (/= comment "")(setq comment (strcat " " comment)))
  
  (setq prevlayer (getvar "CLAYER"))
  (SETVAR "CLAYER" "Drafting")
   (if (or (= compile 0) (= cbrq "Y") (/= bearing ""))    (COMMAND "TEXT" "J" "MC" BPOS TH (ANGTOS ANG 1 4) BTS));if not compile label bearing
   (if (or (= compile 0) (= cbrq "Y") (/= bearing ""))    (COMMAND "TEXT" "J" "MC" DPOS TH (ANGTOS ANG 1 4) (strcat "CH" ldist (strcase comment))))

  (if (or (= compile 2) (= cbrq "N"))(setq APOS BPOS
					RPOS DPOS));move position for strata or bearingless compile
  (IF (and (or (= compile 2) (= cbrq "N"))(/= comment ""))(setq arclength (strcat arclength (strcase comment))))
  
  
    (COMMAND "TEXT" "J" "MC" APOS TH (ANGTOS ANG 1 4) (strcat "ARC" arclength))
    (COMMAND "TEXT" "J" "MC" RPOS TH (ANGTOS ANG 1 4) (strcat "RAD" lradius))

	 (SETQ TH THP)





   ;end of arc labeller
)



;--------------------------------------------------------------SHORT LINE LABELLER FUCNTION---------------------------
	    
(defun lbs (/)

  
  (SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
   (setq tp1 (CDR(ASSOC 10 sentlist)))
   (setq tp2 (CDR(ASSOC 11 sentlist)))

       
    (SETQ AANG (ANGLE tP1 tP2))
    (SETQ CP1 (TRANS  tP1 0 1))
    (SETQ CP2 (TRANS  tP2 0 1))
    (SETQ ANG (ANGLE CP1 CP2))
    (SETQ DANG (* ANG (/ 180 PI)))

    (IF (AND (> DANG 90) (<= DANG 270)) (PROGN
					 (SETQ CP1 (TRANS tP2 0 1))
					 (SETQ CP2 (TRANS tP1 0 1))
					 (SETQ ANG (ANGLE CP1 CP2))
                                         (SETQ DANG (* ANG (/ 180 PI)))
					 )
      )

  ;REDUCE SIZE ON SMALL LINES

  
  (SETQ THP TH)
  ;(IF (AND (< (ATOF LDIST) (* 10 th)) (<  (* (ATOF LDIST) 0.1) TH)(= ATHR "Y"))(SETQ TH (* (ATOF LDIST) 0.1)))
  
  
    (SETQ MPE (/ (+ (CAR CP1 ) (CAR CP2)) 2))
    (SETQ MPN (/ (+ (CADR CP1 ) (CADR CP2)) 2))
    (SETQ MP (LIST MPE MPN))
    (SETQ BPOS (POLAR MP (+ ANG (* 0.5 PI)) (* TH 1.2)))
    (SETQ DPOS (POLAR MP (- ANG (* 0.5 PI)) (* TH 1.2)))
    (SETQ BTS (vl-string-subst  "�" "d" bearing))

  (if (/= comment "")(setq comment (strcat " "comment)))

  (setq prevlayer (getvar "CLAYER"))
  (SETVAR "CLAYER"  "Drafting" )
    (COMMAND "TEXT" "J" "MC" BPOS TH "90" SLCOUNT)
  (COMMAND "CIRCLE" BPOS TH)
    

	 (SETQ TH THP)


  
    			 ;box corners
			 (setq p10 (list (+ (car SLTPOS) 0)(+ (cadr SLTPOS) (* -2.5 th))))
			 (setq p11 (list (+ (car SLTPOS) (* 4 th))(+ (cadr SLTPOS)  0 )))
			 (setq p12 (list (+ (car SLTPOS) (* 13 th))(+ (cadr SLTPOS) (* -2.5 th))))
			 (setq p13 (list (+ (car SLTPOS) (* 21 th))(+ (cadr SLTPOS)  0 )))
			 
			 ;draw boxes
			 (command "rectangle" p10 p11)
			 (command "rectangle" p11 p12)
			 (command "rectangle" p12 p13)
			 
			 ;text insertion points
			 (setq p20 (list (+ (car SLTPOS) (* 2 th))(+ (cadr SLTPOS)  (* -1.25 th ))))
			 (setq p21 (list (+ (car SLTPOS) (* 8.5 th))(+ (cadr SLTPOS)  (* -1.25 th ))))
			 (setq p22 (list (+ (car SLTPOS) (* 17 th))(+ (cadr SLTPOS)  (* -1.25 th ))))
			 
			 ;create text
			 (command "text" "j" "mc" p20 th "90" SLCOUNT)
			 (command "text" "j" "mc" p21 th "90" BTS)
			 (command "text" "j" "mc" p22 th "90" (STRCAT LDIST (strcase COMMENT)))
			 ;reset pm box mark point
			 (setq SLTPOS p10)



  
    
    )




;--------------------------------------------------------------SHORT ARC LABELLER FUNCTION--------------------------

(DEFUN LBSA (/)

  (SETQ AANG (ANGLE tP1 tP2))
    (SETQ CP1 (TRANS  tP1 0 1))
    (SETQ CP2 (TRANS  tP2 0 1))
    (SETQ ANG (ANGLE CP1 CP2))
    (SETQ DANG (* ANG (/ 180 PI)))

    (IF (AND (> DANG 90) (<= DANG 270)) (PROGN
					 (SETQ CP1 (TRANS tP2 0 1))
					 (SETQ CP2 (TRANS tP1 0 1))
					 (SETQ ANG (ANGLE CP1 CP2))
                                         (SETQ DANG (* ANG (/ 180 PI)))
					 )
      )

  ;REDUCE SIZE ON SMALL LINES

  
  (SETQ THP TH)
  (IF (AND (< (ATOF LDIST) (* 10 th)) (<  (* (ATOF LDIST) 0.1) TH)(= ATHR "Y"))(SETQ TH (* (ATOF LDIST) 0.1)))
  
  
    (SETQ MP (TRANS AMP 0 1))
    

  (IF (or (AND (OR (>= AANG (* 1.5 PI))(<= AANG (* 0.5 PI)))( = curverot "ccw"))(AND (<= AANG (* 1.5 PI))(> AANG (* 0.5 PI))( = curverot "cw")))
    (progn
      (setq MP (POLAR MP (+ ANG (* 0.5 PI)) (* TH 6.7)))
      )
    
    )
    (SETQ BPOS (POLAR MP (- ANG (* 0.5 PI))  TH))
    (SETQ DPOS (POLAR MP (- ANG (* 0.5 PI)) (* 2.5 TH)))
    (SETQ APOS (POLAR MP (- ANG (* 0.5 PI)) (* 3.9 TH)))
    (SETQ RPOS (POLAR MP (- ANG (* 0.5 PI)) (* 5.3 TH)))
 
    (SETQ BTS (vl-string-subst  "�" "d" bearing))
  
  (setq prevlayer (getvar "CLAYER"))
  (SETVAR "CLAYER"  "Drafting" )
    (COMMAND "TEXT" "J" "MC" BPOS TH "90" slcount)
  (COMMAND "CIRCLE" BPOS TH)
    

	 (SETQ TH THP)
     
  
    			 ;box corners
			 (setq p10 (list (+ (car SLATPOS) 0)(+ (cadr SLATPOS) (* -2.5 th))))
			 (setq p11 (list (+ (car SLATPOS) (* 4 th))(+ (cadr SLATPOS)  0 )))
			 (setq p12 (list (+ (car SLATPOS) (* 13 th))(+ (cadr SLATPOS) (* -2.5 th))))
			 (setq p13 (list (+ (car SLATPOS) (* 21 th))(+ (cadr SLATPOS)  0 )))
                         (setq p14 (list (+ (car SLATPOS) (* 29 th))(+ (cadr SLATPOS)  (* -2.5 th ))))
                         (setq p15 (list (+ (car SLATPOS) (* 37 th))(+ (cadr SLATPOS)  0 )))
      
			 
			 ;draw boxes
			 (command "rectangle" p10 p11)
			 (command "rectangle" p11 p12)
			 (command "rectangle" p12 p13)
                         (command "rectangle" p13 p14)
                         (command "rectangle" p14 p15)
      
			 
			 ;text insertion points
			 (setq p20 (list (+ (car SLATPOS) (* 2 th))(+ (cadr SLATPOS)  (* -1.25 th ))))
			 (setq p21 (list (+ (car SLATPOS) (* 8.5 th))(+ (cadr SLATPOS)  (* -1.25 th ))))
			 (setq p22 (list (+ (car SLATPOS) (* 17 th))(+ (cadr SLATPOS)  (* -1.25 th ))))
                         (setq p23 (list (+ (car SLATPOS) (* 25 th))(+ (cadr SLATPOS)  (* -1.25 th ))))
                         (setq p24 (list (+ (car SLATPOS) (* 33 th))(+ (cadr SLATPOS)  (* -1.25 th ))))
			 
			 ;create text
			 (command "text" "j" "mc" p20 th "90" slcount)
			 (command "text" "j" "mc" p21 th "90" BTS)
			 (command "text" "j" "mc" p22 th "90" LDIST)
                         (command "text" "j" "mc" p23 th "90" ARCLENGTH)
                         (command "text" "j" "mc" p24 th "90" LRADIUS)
			 ;reset pm box mark point
			 (setq SLATPOS p10)

  
   
   ;end of arc labeller
)


;--------------------------------------------------------------RM LABELLER FUCNTION---------------------------
	    
(defun lrm (/)

  

  (SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
   (setq tp1 (CDR(ASSOC 10 sentlist)))
   (setq tp2 (CDR(ASSOC 11 sentlist)))
  (setq tp1 (trans tp1 0 1))
  (setq tp2 (trans tp2 0 1))

       
    (SETQ AANG (ANGLE tP2 tP1))
      
   
  
    (SETQ BTS (vl-string-subst  "�" "d" bearing))

  (setq rmtypet (strcat " " rmtype ))
  

  
  ;word shorteners
  (IF (= rmtypet "Conc Block" ) (Setq rmtypet "CB"))
  (if (/= rmstate "")(setq rmstatet (strcat " " rmstate))(setq rmstatet ""))
  (IF (= rmstatet " Placed") (setq rmstatet ""))
  (IF (= rmstatet " Existing") (setq rmstatet ""))
  (if (= rmstatet " Found") (setq rmstatet " FD"))
  (if (/= rmcondition "")(setq rmconditiont (strcat  " " rmcondition  ))(setq rmconditiont ""))
  (if (= rmcomment "used as reference mark")(setq rmcomment ""))
  (if (/= rmcomment "")(setq rmcommentt (strcat  " " rmcomment  ))(setq rmcommentt ""))
  
  
  
  (if (=  rmtypet rmstatet) (setq rmstatet ""));deal with not marked not marked etc
  
  (setq 1text (strcat "RM" (strcase rmtypet) (strcase rmstatet) (strcase rmconditiont) (strcase rmcommentt)))
  (setq 2text (strcat bts "-" ldist " "(strcase comment)))
  (setq 3text (strcat "(" rmrefdp ")"))

	   (setq rang (- aang (* 0.25 pi)))
(IF (AND (> rang  (* 0.5 pi)) (< rang (* 1.5 pi)))(progn ;if text is upsidedown reverse justification and rotation
					  (setq rang (+ rang pi))
					  (setq just "TR")
					   (SETQ 3POS (POLAR tP2 AANG (* TH 2)))
    (SETQ 3POS (POLAR 3POS (- AANG (* 0.5 PI)) TH))
   
    (SETQ 2POS (POLAR tP2 AANG TH))
    (SETQ 2POS (POLAR 2POS (- AANG (* 0.5 PI)) (* TH 2)))

    (SETQ 1POS (POLAR tP2 (- AANG (* 0.5 PI)) (* TH 3)))
					  
					  );p
	 (progn ;else normal 
	 (setq just "BL")
	  (SETQ 1POS (POLAR tP2 AANG (* TH 2)))
    (SETQ 1POS (POLAR 1POS (- AANG (* 0.5 PI)) TH))
   
    (SETQ 2POS (POLAR tP2 AANG TH))
    (SETQ 2POS (POLAR 2POS (- AANG (* 0.5 PI)) (* TH 2)))

    (SETQ 3POS (POLAR tP2 (- AANG (* 0.5 PI)) (* TH 3)))
	 );p else
	 );if

  (if (/= comment "")(setq comment (strcat " " comment)))
  
  (SETVAR "CLAYER" "Drafting")
    (COMMAND "TEXT" "J" just 1POS TH (ANGTOS rANG 1 4) 1TEXT)
    (COMMAND "TEXT" "J" just 2POS TH (ANGTOS rANG 1 4) 2TEXT)
  (if (/= rmrefdp "")(COMMAND "TEXT" "J" JUST 3POS TH (ANGTOS rANG 1 4) 3TEXT))
    
    )

;------------------------------------------------------------------Label Corner Mark-----------------------------------------------------
(defun lcm (/)

   ;draw monument info
  ;check for no values and replace with "none"
  
  (if (= rmrefdp "none")(setq rmrefdp ""))
  (if (/= rmrefdp "")(setq rmrefdp (strcat "(" rmrefdp ")")))
  (if (or (= rmcondition "none")(= rmcondition nil))(setq rmcondition ""))
  (if (/= rmstate "")(setq rmstatet (strcat " " rmstate))(setq rmstatet ""))
  (IF (= rmstatet " Placed") (setq rmstatet ""))
  (IF (= rmstatet " Existing") (setq rmstatet ""))
  (if (= rmstatet " Found") (setq rmstatet " FD"))
  (if (/= rmcondition "")(setq rmconditiont (strcat  " " rmcondition  ))(setq rmconditiont ""))
  (if (and  (OR (= rmstate "FD")(= rmstate "Placed")(= rmstate "Existing"))(= rmtype "Occupation"))(setq rmstatet ""))
  (if (= rmtype "Occupation")(setq rmtype ""
				     rmstatet ""))
				     
  ;(if (/= rmcomment "")(setq rmcomment (strcat rmcomment " ")))
    (SETQ AANG (/ pi 2))
  ;(if (and (= rmtype "")(or (= "Gone" rmstate)(= rmstate "Not Found")))(setq rmtype "RM"));trick for RM gone having no type
    (if (/= rmtype "")(setq rmtypet rmtype )(setq rmtypet ""))
 (if (= (strcat " " rmtypet)  rmstatet)(setq rmstatet ""));deal with not marked not marked etc
  (if (= rmornot " RM")(setq rmornot "RM " )) ;label RM gone
  (IF (= rmtypet "Conc Block" ) (Setq rmtypet "CB"))
  (if (/= rmcomment "")(setq rmcommentt (strcat  " " rmcomment  ))(setq rmcommentt ""))

  
  
     (setq 1text (strcat rmornot (strcase rmtypet) (strcase rmstatet) (strcase rmconditiont) (strcase rmcommentt)))


  
	   (setq rang (- aang (* 0.25 pi)))
(IF (AND (> rang  (* 0.5 pi)) (< rang (* 1.5 pi)))(progn ;if text is upsidedown reverse justification and rotation
					  (setq rang (+ rang pi))
					  (setq just "TR")
    (SETQ 1POS (POLAR P1 (- AANG (* 0.5 PI)) (* TH 3)))
					  
					  );p
	 (progn ;else normal 
	 (setq just "BL")
	  (SETQ 1POS (POLAR P1 AANG (* TH 2)))
    (SETQ 1POS (POLAR 1POS (- AANG (* 0.5 PI)) TH))
	 (SETQ 2POS (POLAR P1 AANG TH))
    (SETQ 2POS (POLAR 2POS (- AANG (* 0.5 PI)) (* TH 2)))
   
    	 );p else
	 );if
  (SETVAR "CLAYER"  "Drafting" )
    (COMMAND "TEXT" "J" just 1POS TH (ANGTOS rANG 1 4) 1TEXT)
  (IF (/= rmrefdp "")(COMMAND "TEXT" "J" just 2POS TH (ANGTOS rANG 1 4) rmrefdp))

  
  )



;------------------------------------------------------------------Easement Counter---------------------------------------------------------------------
(defun easecount (/)

(setq easelist (list))
  (setq easelegend (list))
(IF (/= (setq lots (ssget "_X" '((0 . "LWPOLYLINE") (8 . "Lot Definitions,Adjoining Boundary")))) nil)(progn

							     
 (setq count 0)
  (repeat (sslength lots)
  
    (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME lots COUNT)))))
    

    	    (SETQ XDATAI (ENTGET EN '("LANDXML")))
	     (IF (/= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL) (progn
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))

    (if (/= (setq stringpos (vl-string-search "Parcel name" xdatai )) nil)(progn
(setq wwpos (vl-string-position 34 xdatai (+ stringpos 13)))(setq pclname (substr xdatai (+ stringpos 14) (-(- wwpos 1)(+ stringpos 12)))))(setq pclname ""))

	     
	    
    (if (= (substr pclname 1 1) "E")
      (progn
	(setq easelist (append easelist (list (rtos (+ (atof (substr pclname 2 50)) 10000) 2 0))))
	(if (/= (setq stringpos (vl-string-search "desc" xdatai )) nil)(progn
(setq wwpos (vl-string-position 34 xdatai (+ stringpos 6)))(setq pcldesc (substr xdatai (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5)))))(setq pcldesc ""))
		(if (/= (setq stringpos (vl-string-search "class" xdatai )) nil)(progn
(setq wwpos (vl-string-position 34 xdatai (+ stringpos 7)))(setq pclclass (substr xdatai (+ stringpos 8) (-(- wwpos 1)(+ stringpos 6)))))(setq pclclass ""))
	(if (and (= pcldesc "")(= pclclass "Restriction On Use Of Land"))(setq pcldesc "RESTRICTION ON USE OF LAND"))
	;.l,class "Restriction On Use Of Land"))(setq pcl
	
	(setq sortingname (rtos (+ (atof (substr pclname 2 50)) 10000) 2 0))
	    (setq easelegend (append easelegend (list (strcat pcldesc "~" sortingname))))
	));p&if E
      
	
			       
	      
    
    ));if xdata exists
    (setq count (+ count 1))
    );repeat

	       
 (if (> (length easelist) 0)(progn;if easements exist
			       
 (setq easelist  (VL-SORT easelist '<))
 (setq easelegend  (VL-SORT easelegend '<))
 (setq easecounter (- (+  (atof (nth (- (length easelist)1) easelist)) 1) 10000))
 )
   (setq easecounter 1);else
   );easements exist
	       )
(setq easecounter 1);if not lots exist yet defult to 1
  );if lots exist
 
 )

;-----------------------------------------------------------------CREATE EASEMENT LEGEND-----------------------------------------------------------------
(DEFUN C:XEL (/)

  ;note this progam uses a fuction below as the xml importer also uses this tool
  (setq elp (getpoint "Select Location for Easement Legend:"))
(createeaselegend)
  )

(DEFUN createeaselegend (/)

  (easecount)

  
  (setq pdesg "")
  (setq pdesc "")
  (setq desgstring "")
  (setq descstring "")
  (setq minusadded "0")
	
  
  (setq count 0)
  (repeat (length easelegend)

    (setq easedesc (nth count easelegend))
    ;seperate designator and description
    (setq minuspos (vl-string-position 126 easedesc 0))
    (setq desc (substr easedesc 1 minuspos))
    (setq desg (substr easedesc (+ minuspos 3) 50));skip to just past 1 in 10000
    (setq desg (strcat "E" (rtos (atof desg) 2 0)));rebuild E number
				
			  
    (if (= desc pdesc)(progn
			(setq penum (atof (substr pdesg 2 50)))
			(setq enum (atof (substr desg 2 50)))
			(if (= (rtos enum 2 0) (rtos (+ penum 1) 2 0)) (progn;p if consectutive enumbers
						   (setq endnum desg)
						   (if (/= (substr desgstring (strlen desgstring) 1) "-")(setq desgstring (strcat desgstring "-")
													     minusadded "1"));add minus if not already there
						   );p if consectutive enumbers
			  (progn;p if not consectutive enumbers
			    (if (= minusadded "1")(setq desgstring (strcat desgstring endnum)))
			    (setq desgstring (strcat desgstring "," desg))
			    (setq minusadded "0")
			    );else ie not consectutive enumbers
			  );if consective numbers
			);p descriptions are the same

      (progn; else ie descriptions not the same
	;(setq desgstring (substr desgstring 2 1000))
	
				    (if (= minusadded "1")(setq desgstring (strcat desgstring endnum)))
			    	
	(setq printstring (strcat desgstring " " pdesc))
	(SETVAR "CLAYER"  "Drafting" )
	(COMMAND "TEXT" "J" "BL" elp TH "90" PRINTSTRING)
	(SETQ ELP (LIST (CAR ELP)(+ (CADR ELP) (* -1.5 TH))))
	(setq desgstring desg)
	(setq minusadded "0")
	);p else
      );if desc same

    (setq pdesc desc
	  pdesg desg)
	  
      
      (setq count (+ count 1))
    );repeat


   (if (= minusadded "1")(setq desgstring (strcat desgstring endnum)))
  (setq printstring (strcat desgstring " " pdesc))
	(COMMAND "TEXT" "J" "BL" elp TH "90" PRINTSTRING)
	(SETQ ELP (LIST (CAR ELP)(+ (CADR ELP) (* -1.5 TH))))
	(setq desgstring desg)
	(setq minusadded "0")


  
  )

      
    
	   
			
			  
    
   
    

;----------------------------------------------------------------;CHOOSE FROM BOX FUNCTION--------------------------------


    ;;; defun

(defun dbox ()

  
   

  (setq dcl_id (load_dialog "Landxml.dcl"))
  (if (not (new_dialog "landxml" dcl_id))
    (exit)
  )

      (if ( = workingselnum nil)(setq workingselnum "0"))

	      (set_tile "selections" workingselnum)

   

 
  
  (start_list "selections")
  (mapcar 'add_list names)
  (end_list)
  (set_tile "selections" workingselnum)
  
  (action_tile
    "accept"
    (strcat
      "(progn (setq pick (atoi (get_tile \"selections\")))"
      ;"(setq table (atoi (get_tile \"cfs\")))"
      "(setq click \"Accept\")"
      "(done_dialog)(setq userclick T))"
    )
  )

;;;action_tile
  (action_tile "cancel"
    (strcat
      "(done_dialog)(setq userclick nil)"
       
      )
    )
;;;action_tile "cancel"
  (start_dialog)
  (unload_dialog dcl_id)


  (setq returntype (nth pick names))
(setq workingselnum (rtos pick 2 0))
  
);defun

   ;;; defun
;----------------------------------------------------------------;edit Xdata--------------------------------

(defun C:XDE ()

  
   (setq en (car (entsel "\nSelect Object:")))
  (setq count 0)
  
    	    (SETQ XDATAI (ENTGET EN '("LANDXML")))
	   (IF (= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL) (progn
	      	     
	      (princ (strcat "\nObject has no xdata"))
	     ))
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))

    

  (setq dcl_id (load_dialog "Landxml.dcl"))
  (if (not (new_dialog "XDE" dcl_id))
    (exit)
  )

     

	      (set_tile "xdata" xdatai)

 
  
  (action_tile
    "accept"
    (strcat
      "(setq xdatai (get_tile \"xdata\"))"
      ;"(setq table (atoi (get_tile \"cfs\")))"
      "(setq click \"Accept\")"
      "(done_dialog)(setq userclick T))"
    )
  )

;;;action_tile
  (action_tile "cancel"
    (strcat
      "(done_dialog)(setq userclick nil)"
       
      )
    )
;;;action_tile "cancel"
  (start_dialog)
  (unload_dialog dcl_id)

  (SETQ SENTLIST (ENTGET EN))
(SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 xdatai)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)
 
  
);defun

(defun linereader (/)
  ;read the line
   (setq linetext (read-line xmlfile))
  
   ;remove tabs
(while (/=  (setq sybpos (vl-string-search "\t" linetext sybpos )) nil)
		(setq linetext (vl-string-subst "" "\t"  linetext 0)))
  
  
  ;check for comment
  (while (vl-string-search "<!--" linetext )(progn
					   (while (= (vl-string-search "-->" linetext ) nil)(setq linetext (read-line xmlfile)))
					   (setq remstring (substr linetext (+ (vl-string-search "-->" linetext ) 4) ))
					   (if (= remstring"")(setq linetext (read-line xmlfile))(setq linetext remstring)
					       
					       )
					   
  ))
  )
       


;----------------------------------------------------------------BULK EDIT--------------------------------

(defun C:XBE (/)

  ;0. Datum Points
    (princ "\nSelect Data for Bulk Edit")
 (setq bdyline (ssget))

(setq origatt (getstring "\nAttribute to change:" T))
(setq newatt (getstring "\nNew Value:" T))
  (setq count 0)
  (repeat (sslength bdyline)

(setq attlen (strlen origatt))

  (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME bdyline COUNT)))))
 

    	    (SETQ XDATAI (ENTGET EN '("LANDXML")))
	    (IF (/= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL) (progn
	 
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))

	    
     (if (/= (setq stringpos (vl-string-search origatt xdatai )) nil)(progn
(setq wwpos (vl-string-position 34 xdatai (+ stringpos attlen 2)))
(setq ss (substr xdatai 1 (+ stringpos attlen 2)))
(setq es (substr xdatai (+ wwpos 1) 1000))
(setq xdatai (strcat ss newatt es))
       ))
 

  (SETQ SENTLIST (ENTGET EN))
(SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 xdatai)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)
 ));p&if object has xdata
    (setq count (+ count 1))
    );r
  
);defun

       

;----------------------------------------------------------------IMPORT XML--------------------------------------------

(DEFUN C:XIN (/)
(setq importcgpoint "fromfile")
  (setq simplestop "0")
  (xmlimporter)
    )

(defun C:XINO (/)
  (SETQ importcgpoint "fromobs")
  (setq simplestop "0")
  (xmlimporter)
  )

(defun C:XINS (/)
(SETQ importcgpoint "fromobs")
  (SETQ simplestop "1")
  (xmlimporter)
  )

(defun XMLIMPORTER (/)
    (SETQ ATTDIA (GETVAR "ATTDIA"))
  (SETQ ATTREQ (GETVAR "ATTREQ"))
  (SETVAR "ATTDIA" 0)
  (SETVAR "ATTREQ" 1)
   (setq prevlayer (getvar "CLAYER"))
  (SETVAR "CLAYER"  "Lot Definitions" )
  (SETVAR "CECOLOR" "BYLAYER")

  (setq textstyle (getvar "textstyle"))
(SETQ textfont (ENTGET (tblobjname "style" textstyle)))
(setq theElist (subst (cons 40 0)(assoc 40 theElist) textfont))
(entmod theElist)
  


  ;1. clear lists
(setq cgpointlist (list));list of coordinate geometery points
  (setq pmlist (list));list of pms from the monument and cg points list
  (setq drawpmlist (list));list of drawn pms so the same pm is not drawn twice
  (setq levellist (list));list of levels for stata plan
  (setq rmlist (list));list of monuments from monument list
  (setq occlist (list));list of occupation points
  (setq drawnrmlist (list));list of drawn mounments,so the same rm is not drawn twice
  (setq drawnpmlist (list));list of drawn pms so same pm is not drawn twice (eg PM and BM)
  (setq drawndref (list));list of drawn double references,so same dref is not drawn twice
  (setq usedrmlist (list));list of RM's already used (so that it can be used if it's a double reference)
  (setq reflist (list));list of drawn references, to allow the same rm to be referenced twice
  (setq easementlist (list));list of lines which are easement lines
  (setq otherlines (list));list of lot and road lines from lots to remove from easementlist
  (setq finaleaselist (list));list of reduced easement lines
  (setq linelist (list));list of lines which have been drawn
  (setq arclist (list));list of arcs which have been drawn
  (setq poplist (list));list of pops for creation at the end
  (setq islist (list));list of instrument stations for cg point reference
  (setq vertobslist (list))
  (setq pmboxmark nil);reset spot for coordinte box
  (setq bmboxmark nil);reset spot for benchmark box
  (setq hdboxmark nil);reset spot for height difference box
  (setq irlinetestlist nil);list of plotted irlines
  (setq rmornot "");tool for identifying RM gone
  (setq mplist nil);stores multipart names are their areas
  (setq blnorls nil);store levels for strata building level numbers
  (setq currl 0);stores the current building elevation

  ;2. Select File
  (setq xmlfilen (getfiled "Select XML file" "" "xml" 2))
  (setq xmlfile (open xmlfilen "r"))
  (setq linetext "")
  (setq maxeast -100000000000000000000000000000.1)
  (setq mineast  100000000000000000000000000000.1)
  (setq minnorth 10000000000000000000000000000.1)
  (setq daf1 "")


  ;3. CHECK TO MAKE SURE FILE IS LINEFED
  (setq linetext (read-line xmlfile))
  (setq linetext (read-line xmlfile))
  ;check second line for end of xml </LandXML>
  (if (/= (vl-string-search "</LandXML>" linetext) nil)
    (progn
       (setq outfilen (vl-string-subst "_WLF." "." xmlfilen))
  (setq outfile (open outfilen "w"))
      
      (princ (strcat "Non linefed file detected, to allow importing created file at " outfilen ))
(close xmlfile)
(setq xmlfile (open xmlfilen "r"))
(setq linetext (read-line xmlfile))
(write-line linetext outfile)
(setq linetext (read-line xmlfile))     
;add linefeed a every <
						 (setq <pos 1)
	      (while (/=  (setq <pos (vl-string-search "<" linetext <pos )) nil) (setq linetext (vl-string-subst (strcat (chr 10) "<") "<"   linetext <pos)
										      <pos (+ <pos 2)))
							(write-line linetext outfile)
      
      (close outfile)
      (close xmlfile)
      (setq xmlfilen outfilen);set reading file to WLF file
        (setq xmlfile (open xmlfilen "r"))
      (linereader)
      ))

  ;4. CHECK FOR STRATA SCALE VALUE
 (while (and (= (vl-string-search "type=\"Scale\"" linetext) nil)(= (vl-string-search "</LandXML>" linetext) nil))( progn
   (linereader)
   
))
 
  (if (/= (setq stringpos (vl-string-search "desc" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 6)))
(setq scale (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5))))
(setq scale (atof (substr scale 3 200)))
  (setq TH (* 2.5 (/ scale 1000 )))
  (setvar "celtscale" (/ (/ scale 100.0) 2))
(VLAX-LDATA-PUT "LXML4AC" "scale" scale) 
))
  (close xmlfile)
  (setq xmlfile (open xmlfilen "r"))

  
  ;5. XML HEADER
    ;linefeed to coodinate system
  (while (= (vl-string-search "<CoordinateSystem" linetext) nil)( progn
   (linereader)
))
  (if (/= (setq stringpos (vl-string-search "datum" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 7)))(setq datum (substr linetext (+ stringpos 8) (-(- wwpos 1)(+ stringpos 6)))))(setq datum ""))
   (if (/= (setq stringpos (vl-string-search "desc" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 6)))(setq datum (strcat datum "~" (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5)))))))
    (if (/= (setq stringpos (vl-string-search "horizontalDatum" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 17)))(setq hdatum (substr linetext (+ stringpos 18) (-(- wwpos 1)(+ stringpos 16)))))(setq hdatum ""))
  (if (/= (setq stringpos (vl-string-search "verticalDatum" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 15)))(setq vdatum (substr linetext (+ stringpos 16) (-(- wwpos 1)(+ stringpos 14)))))(setq vdatum ""))
  
  
  

  ;6. MONUMENTS--------------------------------------
  ;linefeed to monuments, as they control linetypes and pm and other notation
  
 (while (and (= (vl-string-search "</LandXML>" linetext ) nil) (= (vl-string-search "<Monuments>" linetext ) nil)) ( progn
 (linereader)
 
))

  (if (vl-string-search "<Monuments>" linetext )(progn ;if not end of file
						  
    (linereader)
     (while (= (vl-string-search "</Monuments>" linetext ) nil) ( progn
   (if (/= linetext "" )
     (progn
       (if (/= (setq stringpos (vl-string-search "name" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 6)))(setq monname (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5)))))(setq monname nil))
       (if (/= (setq stringpos (vl-string-search "pntRef" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 8)))(setq moncgp (substr linetext (+ stringpos 9) (-(- wwpos 1)(+ stringpos 7)))))(setq moncgp nil))
       (if (/= (setq stringpos (vl-string-search "type" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 6)))(setq montype (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5)))))(setq montype nil))
       (if (/= (setq stringpos (vl-string-search "desc" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 6)))(setq mondesc (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5)))))(setq mondesc nil))
       (if (/= (setq stringpos (vl-string-search "state" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 7)))(setq monstate (substr linetext (+ stringpos 8) (-(- wwpos 1)(+ stringpos 6)))))(setq monstate nil))
       (if (/= (setq stringpos (vl-string-search "originSurvey" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 14)))(setq monrefdp (substr linetext (+ stringpos 15) (-(- wwpos 1)(+ stringpos 13)))))(setq monrefdp nil))
       (if (/= (setq stringpos (vl-string-search "condition" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 11)))(setq moncond (substr linetext (+ stringpos 12) (-(- wwpos 1)(+ stringpos 9)))))(setq moncond nil))

       ;deal with a state of gone
       
       ;add pms and ssms to pmlist
       (if (or (= montype "PM")(= montype "SSM")(= montype "TS")(= montype "MM")(= montype "GB")(= montype "CP")(= montype "CR"))
	 (setq pmlist (append pmlist (list moncgp)(list linetext)))
	 )
       ;check if pm is also a referece mark
       ;(if (and (or (= montype "PM")(= montype "SSM")) (= desc "used as reference mark"))
;	 (setq rmlist (append rmlist (list moncgp)(list linetext)))
;	 )
       ;add everything other than a pm or ssm to rmlist
       (if (/= montype "Occupation")
	 (setq rmlist (append rmlist (list moncgp)(list linetext)))
	 (setq occlist (append occlist (list moncgp)(list linetext)));else - is an occ
	 )
       
       ));if not linefeed

   (linereader)
   ));while not </Monuments>

));if not end of file monument storer

  ;7. create intrument station list-----------------------------------------------------------
  (close xmlfile)
  (setq xmlfile (open xmlfilen "r"))

  ;linefeed to end of survey header
(linereader)

  (while(= (vl-string-search "</SurveyHeader>" linetext ) nil) ( progn
 (linereader)
))
 
  
  ;instrument stations
 (linereader)
(while (= (vl-string-search "<ObservationGroup" linetext ) nil)( progn
								 (if (vl-string-search "<InstrumentSetup" linetext )(progn
		   (if (/= (setq stringpos (vl-string-search "id" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 4)))(setq isid (substr linetext (+ stringpos 5) (-(- wwpos 1)(+ stringpos 3)))))(setq isid nil))
		   (linereader)
		   (if (/= (setq stringpos (vl-string-search "pntRef" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 8)))(setq iscgp (substr linetext (+ stringpos 9) (-(- wwpos 1)(+ stringpos 7)))))(setq iscgp nil))
		   (setq isid (strcat "IS-" isid));add "is-" to isid just in case someone is stupid enough to use the same id
		   (setq islist (append islist (list isid)(list iscgp)))

		   (linereader);read end of is
		   ))
		   (linereader);read next line
		   
));p&w not observation group



  
(close xmlfile)
   (setq xmlfile (open xmlfilen "r"))


  (if (= importcgpoint "fromfile")
    (progn

  
  ;8. CGPOINTS-------------------------------------


      ;read CGPOINTS and check for code to establish levels in a strata plan
  ;linefeed to cgpoints
 (while (= (vl-string-search "<CgPoints" linetext) nil) ( progn
 (linereader)
))
 
(while (= (vl-string-search "</CgPoints>" linetext) nil) ( progn
     
   (if (/= linetext "" )
     (progn
      
        (if (/= (setq stringpos (vl-string-search "code" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 6)))(setq cgcode (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5)))))(setq cgcode nil))
(if (and (/= cgcode nil)(= (member cgcode levellist) nil)(/= cgcode "0,Location Plan"))(setq levellist (append levellist (list cgcode))))
       

       
     ));p and if not ""
          
(linereader)
  
   );p

  
   );while
(if (/= nil levellist)(progn
 (setq levellist (vl-sort levellist '<))
 (setq lotlevellist (list "Location Plan" "0,Location Plan"))
 (setq count 0)
 (repeat (length levellist)
   (setq blno (nth count levellist))
   (setq ,pos1 (vl-string-position 44 blno 0))
	              (setq sblno (substr blno (+ ,pos1 2) 2000))
   (setq lotlevellist (append lotlevellist (list sblno blno)))
   (setq count (+ count 1))
   )
 ));if lotlist exists

 

(close xmlfile)
   (setq xmlfile (open xmlfilen "r"))
 
      
  ;linefeed to cgpoints
 (while (= (vl-string-search "<CgPoints" linetext) nil) ( progn
 (linereader)
))


  ;get zone if present
  (if (/= (setq stringpos (vl-string-search "zoneNumber" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 12)))(setq zone (substr linetext (+ stringpos 13) (-(- wwpos 1)(+ stringpos 11)))))(setq zone ""))
  
 (linereader)
  ;do until end of cgpoints

 (while (= (vl-string-search "</CgPoints>" linetext) nil) ( progn
     
   (if (/= (vl-string-search "<CgPoint" linetext )nil)
     (progn
       ;store line information
       (if (/= (setq stringpos (vl-string-search "state" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 7)))(setq cgpstate (substr linetext (+ stringpos 8) (-(- wwpos 1)(+ stringpos 6)))))(setq cgpstate nil))
              (if (/= (setq stringpos (vl-string-search "pntSurv" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 9)))(setq cgpntsurv (substr linetext (+ stringpos 10) (-(- wwpos 1)(+ stringpos 8)))))(setq cgpntsurv nil))
              (if (/= (setq stringpos (vl-string-search "name" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 6)))(setq cgpname (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5)))))(setq cgpname nil))
                     (if (/= (setq stringpos (vl-string-search "oID" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 5)))(setq cgpoID (substr linetext (+ stringpos 6) (-(- wwpos 1)(+ stringpos 4)))))(setq cgpoID nil))
       
                            (if (/= (setq stringpos (vl-string-search "desc=" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 6)))(setq cgdesc (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5)))))(setq cgdesc nil))
       ;spaced out DSM Desc
                                   (if (/= (setq stringpos (vl-string-search "desc = " linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 8)))(setq cgdescDSM (substr linetext (+ stringpos 9) (-(- wwpos 1)(+ stringpos 7)))))(setq cgdescDSM nil))
       (if (and (= cgdesc nil)(/= cgdescDSM nil))(setq cgdesc cgdescDSM))

       
        (if (/= (setq stringpos (vl-string-search "code" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 6)))(setq cgcode (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5)))))(setq cgcode nil))

       ;check if point is a pm and store in drawpmlist
       (if (/= cgpoID nil)(progn
			    (if (/= (setq remlist (member cgpname pmlist)) nil) (setq pmline (cadr remlist)));look for details in PM list
			    (if (/= (setq remlist (member cgpname rmlist)) nil) ;look for details in RM list, if exist add to PM list
			      (progn (setq pmline (cadr remlist))
				(setq pmlist (append pmlist (list (car remlist) (cadr remlist))))
				))
			    (if (and (= (member cgpname pmlist) nil)(= (member cgpname rmlist) nil))
			      (progn
				(princ (strcat "\n SCIMS mark " cgpoID " has no corresponding monument for prefix assignment"))
			      (setq pmline nil)
			      ));if point has oid but no monument
			    
			    (if (/= (setq stringpos (vl-string-search "type" pmline)) nil)(progn
			    (setq wwpos (vl-string-position 34 pmline (+ stringpos 6)))(setq pmstart (substr pmline (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5)))))
			      (setq pmstart ""))
			       (if (/= (setq stringpos (vl-string-search "state" pmline)) nil)(progn
			    (setq wwpos (vl-string-position 34 pmline (+ stringpos 7)))(setq pmstate (substr pmline (+ stringpos 8) (-(- wwpos 1)(+ stringpos 6)))))
			      (setq pmstate ""))
				 (setq drawpmlist (APPEND drawpmlist (list cgpname)(list (strcat pmstart cgpoID ))(list pmstate )))
			    )
	 )
              	  
			    
       ;get cgpoint coordintes
                            (if (/= (setq stringpos (vl-string-search ">" linetext )) nil)(progn
(setq <pos (vl-string-position 60 linetext (+ stringpos 2)))
(if (= <pos nil)(setq <pos 2000))
   
(setq spcpos (vl-string-position 32 linetext stringpos))
(setq north (atof (substr linetext (+ stringpos 2) (- spcpos (+ stringpos 1) ))))
(setq east (substr linetext (+ spcpos 2) (- (- <pos 1) spcpos )))
(if (/= (setq spcpos2 (vl-string-position 32 east 1)) nil)(progn
							    (setq height (substr east (+ spcpos2 2) 200))
							    (setq east (substr east 1 (+ spcpos2 2)));if height exists
								)
  (setq height "0"));else
(setq east (atof east))


;check for code(level) and adjust position
(if (and (/= cgcode nil)(/= cgcode "0,Location Plan"))(progn
		   (setq shiftnum (+ 1(- (length levellist)(length (member cgcode levellist)))))
		   (setq north (+ north (* shiftnum 500)))
		  
		   ))

(if (> east maxeast) (setq maxeast east))
(if (< east mineast)(setq mineast east)) 
(if (< north minnorth)(setq minnorth north)) 
(setq east (rtos east 2 6))
(setq north (rtos north 2 6))



(setq cgco (strcat east "," north))
)(setq cgco nil))
       (setq cgpointlist (append cgpointlist (list cgpname) (list cgco)(list (substr cgpntsurv 1 1))(list cgcode)))

       ;if datum point draw datum point and label
(if (and (/= cgdesc "COORDINATE ERROR")(/= cgdesc nil))(progn
		   	 (SETVAR "CLAYER"  "Datum Points" )
		      (COMMAND "POINT" (strcat east "," north "," height))
		 (SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
(SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 cgdesc)))))
		     (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)
       (SETQ TEXTPOS (LIST (- (atof east) TH) (+ (atof north) (* 0.5 TH))(ATOF HEIGHT)))
		 (SETVAR "CLAYER"  "Drafting" )
		     (if (= spcpos2 nil)(progn
		       (IF (OR (= cgdesc "A")(= cgdesc "B"))
  		 (COMMAND "TEXT" "J" "BR"  TEXTPOS (* TH 2) "90" (STRCAT "'" cgdesc "'"));normal datum point
	         (COMMAND "TEXT" "J" "BR"  TEXTPOS (* TH 1.4) "90" (STRCAT "'" cgdesc "'"));non A/B datum points
			 );if a/b
		       )
		       (progn;else stratum datum point
			 (COMMAND "TEXT" "J" "BR"  TEXTPOS (* TH 1.4) "90" (STRCAT "'" cgdesc "'"))
			 (COMMAND "TEXT" "J" "BL"  (LIST (ATOF EAST)(ATOF NORTH)(ATOF HEIGHT)) (* TH 1) "45" (rtos (atof height) 2 3))
			 );P
		       );IF SPCPOS2 NIL
			 
			 
  ));p&if datum


       (if (= cgdesc "COORDINATE ERROR")(setq cgsuffix (strcat "-" cgdesc))(setq cgsuffix ""))
       
       

       ;9. DRAW CG POINTS
       (SETVAR "CLAYER"  "CG Points" )
       (setq p1 (list (atof east) (atof north)))
       (command "point" p1)
       (COMMAND "TEXT" "J" "BL"  P1 (* TH 0.25) "90" (strcat cgpname (substr cgpntsurv 1 1)(substr cgpstate 1 1) cgsuffix ))
       ));p and if not <CgPoint
     
(linereader)
  
   );p
   );while

 ))

  (if (= importcgpoint "fromobs")
    (obsimporter)
    )

  (if ( = simplestop "1") (exit))

  ;10. PARCELS-------------------------------------
    ;linefeed to parcels
 (while (= (vl-string-search "<Parcels>" linetext ) nil) ( progn
  (linereader)
))
(linereader);read parcel info line
  ;do until end of parcels
       (while (= (vl-string-search "</Parcels>" linetext ) nil) ( progn

					    (SETQ ENTSS (SSADD))
					     (SETQ EASESS (SSADD))
					    
  
					  
;get parcel info
       (if (/= (setq stringpos (vl-string-search "name" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 6)))(setq pclname (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5)))))(setq pclname ""))
       (if (/= (setq stringpos (vl-string-search "class" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 7)))(setq pclclass (substr linetext (+ stringpos 8) (-(- wwpos 1)(+ stringpos 6)))))(setq pclclass ""))
       (if (/= (setq stringpos (vl-string-search "state" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 7)))(setq pclstate (substr linetext (+ stringpos 8) (-(- wwpos 1)(+ stringpos 6)))))(setq pclstate ""))
       (if (/= (setq stringpos (vl-string-search "parcelType" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 12)))(setq pcltype (substr linetext (+ stringpos 13) (-(- wwpos 1)(+ stringpos 11)))))(setq pcltype ""))
       (if (/= (setq stringpos (vl-string-search "parcelFormat" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 14)))(setq pclformat (substr linetext (+ stringpos 15) (-(- wwpos 1)(+ stringpos 13)))))(setq pclformat ""))
       (if (/= (setq stringpos (vl-string-search "area" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 6)))(setq pclarea (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5)))))(setq pclarea ""))
       (if (/= (setq stringpos (vl-string-search "desc" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 6)))(setq pcldesc (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5)))))(setq pcldesc ""))
       (if (/= (setq stringpos (vl-string-search "useOfParcel" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 13)))(setq pcluse (substr linetext (+ stringpos 14) (-(- wwpos 1)(+ stringpos 12)))))(setq pcluse ""))
       (if (/= (setq stringpos (vl-string-search "buildingLevelNo" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 17)))(setq pclbln (substr linetext (+ stringpos 18) (-(- wwpos 1)(+ stringpos 16)))))(setq pclbln ""))				    
       (if (/= (setq stringpos (vl-string-search "buildingNo" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 12)))(setq pclbn (substr linetext (+ stringpos 13) (-(- wwpos 1)(+ stringpos 11)))))(setq pclbn ""))				    

					    
					   
										    
										
					    

					    (setq &pos 0)
	      (while (/=  (setq &pos (vl-string-search "&amp;" pcluse &pos )) nil) (setq pcluse (vl-string-subst "&" "&amp;"  pcluse &pos)
										      &pos (+ &pos 1)))
					    (setq quotpos 0)
	(while (/=  (setq quotpos (vl-string-search "&quot;" pcluse quotpos )) nil) (setq pcluse (vl-string-subst "\"" "&quot;"  pcluse 	quotpos)
										      quotpos (+ quotpos 1)))
					      (setq apos 0)
	(while (/=  (setq apos (vl-string-search "&apos;" pcluse apos )) nil) (setq pcluse (vl-string-subst "'" "&apos;"  pcluse apos)
										      apos (+ apos 1)))
					    (setq &pos 0)
					    
	      (while (/=  (setq &pos (vl-string-search "&amp;" pcldesc &pos )) nil) (setq pcldesc (vl-string-subst "&" "&amp;"  pcldesc &pos)
										      &pos (+ &pos 1)))
					    (setq quotpos 0)
	(while (/=  (setq quotpos (vl-string-search "&quot;" pcldesc quotpos )) nil) (setq pcldesc (vl-string-subst "\"" "&quot;"  pcldesc 	quotpos)
										      quotpos (+ quotpos 1)))
					      (setq apos 0)
	(while (/=  (setq apos (vl-string-search "&apos;" pcldesc apos )) nil) (setq pcldesc (vl-string-subst "'" "&apos;"  pcldesc apos)
										      apos (+ apos 1)))

					    ;deal with multi parts
					    (if (= pcltype "Multipart")(progn
(if (/= (setq stringpos (vl-string-search "name" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 6)))(setq mpname (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5)))))(setq mpname ""))
(if (/= (setq stringpos (vl-string-search "area" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 6)))(setq mparea (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5)))))(setq mparea ""))

					    (if (/= "" mparea) (progn
					    (setq area (atof mparea))

					     (if (= ard "YES")
	(progn
      					    (if (> area1 0)(setq mpareas (strcat (rtos (* (fix (/ area1 0.001)) 0.001) 2 3) "m�")))
					    (if (> area1 10)(setq mpareas (strcat (rtos (* (fix (/ area1 0.01)) 0.01) 2 2) "m�")))
					    (if (> area1 100)(setq mpareas (strcat (rtos (* (fix (/ area1 0.1)) 0.1) 2 1) "m�")))
					    (if (> area1 1000)(setq mpareas (strcat (rtos (* (fix (/ area1 1)) 1) 2 0) "m�")))
      					    (if (> area1 10000) (setq mpareas (strcat (rtos (* (fix (/ (/ area1 10000) 0.001)) 0.001) 2 3) "ha")))
					    (if (> area1 100000) (setq mpareas (strcat (rtos (* (fix (/ (/ area1 10000) 0.01)) 0.01) 2 2) "ha")))
					    (if (> area1 1000000) (setq mpareas (strcat (rtos (* (fix (/ (/ area1 10000) 0.1)) 0.1) 2 1) "ha")))
					    (if (> area1 10000000) (setq mpareas (strcat (rtos (* (fix (/ (/ area1 10000) 1)) 1) 2 0) "ha")))
                                            (if (> area1 100000000) (setq mpareas (strcat (rtos (* (fix (/ (/ area1 1000000) 0.1)) 0.1) 2 1) "km�")))
                                            (if (> area1 1000000000) (setq mpareas (strcat (rtos (* (fix (/ (/ area1 1000000) 1)) 1) 2 0) "km�")))
	  )
	(progn
	        			    (if (> area1 0)(setq mpareas (strcat (rtos   area1 2 3) "m�")))
					    (if (> area1 10)(setq mpareas (strcat (rtos   area1  2 2) "m�")))
					    (if (> area1 100)(setq mpareas (strcat (rtos  area1  2 1) "m�")))
					    (if (> area1 1000)(setq mpareas (strcat (rtos area1  2 0) "m�")))
      					    (if (> area1 10000) (setq mpareas (strcat (rtos  (/ area1 10000)  2 3) "ha")))
					    (if (> area1 100000) (setq mpareas (strcat (rtos  (/ area1 10000)  2 2) "ha")))
					    (if (> area1 1000000) (setq mpareas (strcat (rtos  (/ area1 10000)  2 1) "ha")))
					    (if (> area1 10000000) (setq mpareas (strcat (rtos   (/ area1 10000) 2 0) "ha")))
                                            (if (> area1 100000000) (setq mpareas (strcat (rtos (/ area1 1000000)  2 1) "km�")))
                                            (if (> area1 1000000000) (setq mpareas (strcat (rtos  (/ area1 1000000) 2 0) "km�")))

      ));if ard
				    );p



					     

					      
      					 
					      (SETQ MPAREAS ""))

					     
					    

(IF (/= MPAREAS "")(setq mplist (append mplist (list mpname (strcat mpareas )))))
 						 
							      (while(= (vl-string-search "</Parcel>" linetext ) nil)( progn
														      (linereader)
														      ));p&w

(linereader);get next parcel info
							      							  )
					      (progn ;else continue on - not multipart
							     
					    (setq irtextlist nil)
					    (setq irplotlist nil)
					      
       (linereader);read centrepoint line
					    
					      
														      
															 

        (if (and (/= (vl-string-search "<Center" linetext ) nil)(/= (setq stringpos (vl-string-search "pntRef" linetext )) nil))(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 8)))
(setq lotc (substr linetext (+ stringpos 9) (-(- wwpos 1)(+ stringpos 7))))
(setq pos1 (vl-position lotc cgpointlist))
(setq lotc (nth (+ pos1 1) cgpointlist))
(setq ,pos1 (vl-string-position 44 lotc 0))
(setq east (atof (substr lotc 1 ,pos1)))
(setq north (atof (substr lotc (+ ,pos1 2) 50)))
(setq lotc (list east north ))
(linereader);get cogeo name
)(setq lotc nil))
       

					   (if (/= pclstate "adjoining") (SETVAR "CLAYER"  "Lot Definitions" )(setvar "CLAYER" "Adjoining Boundary"))
       (IF (and (= pclstate "adjoining")(/= (member pclclass interestlist) nil))(setvar "CELTYPE" "EASEMENT"))



      ;(linereader);coord geometery name - not needed yet - removed to deal with parcels with no centre point

       ;do until end of parcel
      (linereader);line,arc or irregular
       (setq ptlist nil)
       (while(= (vl-string-search "</CoordGeom>" linetext ) nil)( progn


								  
 (if (/= (vl-string-search "<IrregularLine" linetext ) nil)(progn

							     
							     
		 (if (/= (setq stringpos (vl-string-search "desc" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 6)))
(setq irdesc (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5))))
)(setq irdesc ""))

		 

		 
		 (linereader);start point
		 (if (/= (setq stringpos (vl-string-search "pntRef" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 8)))
(setq lp1 (substr linetext (+ stringpos 9) (-(- wwpos 1)(+ stringpos 7))))))


		 
		(linereader);end point
		  (if (/= (setq stringpos (vl-string-search "pntRef" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 8)))
(setq lp2 (substr linetext (+ stringpos 9) (-(- wwpos 1)(+ stringpos 7))))))

		 (setq irlinetest (strcat lp1 "-" lp2))
		 (setq irlinetestrev (strcat lp2 "-" lp1))
		 (setq irplotted "N")
		 (if (or (/= (vl-position irlinetest irlinetestlist) nil)(/= (vl-position irlinetestrev irlinetestlist)nil))(setq irplotted "Y"))

		 
		 (linereader);2d point list

		  (if (= importcgpoint "fromobs")(progn
		    
		    ;MAKE SHIFT BASED ON START POINT
		    (setq pos1 (vl-position lp1 cgpointlist))
		    (setq lp1c (nth (+ pos1 1) cgpointlist))
                    
		    	(setq ,pos1 (vl-string-position 44 lp1c 0))
                 (setq speast (atof (substr lp1c 1 ,pos1)))
      		 (setq spnorth (atof (substr lp1c (+ ,pos1 2) 50)))
		    		    
	        ))

		 (setq 2dpntlist "")
		 (setq >pos (vl-string-position 62 linetext))
		 (if (= (setq <pos (vl-string-position 60 linetext >pos)) nil)(progn
										
		 (while (= (setq <pos (vl-string-position 60 linetext (+ >pos 1))) nil)(progn
										(setq 2dpntlist (strcat 2dpntlist (substr linetext (+ >pos 2) ) " "))
										(linereader)
										(setq >pos -1)
										));while no <
		 (if (/= <pos 0)(setq 2dpntlist (strcat 2dpntlist (substr linetext 1 (- <pos 1)))))
         	 (setq 2dpntlist (strcat 2dpntlist " "))

										);p if no <
		 (progn
		 (setq 2dpntlist (strcat (substr linetext (+ >pos 2) (- (- <pos >pos) 1))))
		 ));if is < in line 1
         	 (setq 2dpntlist (strcat 2dpntlist " "))

		  ;get rid of tabs
	

		 (setq l2dpntlist "A")
		(while (/= l2dpntlist 2dpntlist) (setq l2dpntlist 2dpntlist
							2dpntlist (vl-string-subst " " "\t" 2dpntlist 1)))

		 	 
		 ;get rid of double spaces

		 (setq l2dpntlist "A")

		 (while (/= l2dpntlist 2dpntlist) (setq l2dpntlist 2dpntlist
							2dpntlist (vl-string-subst " " "  " 2dpntlist 1)))

		 
							
		 (setq spcpos -1)
		 (setq spcpos1 1)
		 (setq ircolist (list))
		 (while (/=  (setq spcpos1 (vl-string-search " " 2dpntlist spcpos1 )) nil)
		   (progn
		   (setq ircolist (append ircolist (list (substr 2dpntlist (+ spcpos 2) (- (- spcpos1 spcpos) 1)))))
		   (setq spcpos spcpos1 )
		   (setq spcpos1 (+ spcpos1 1))
		   ));p and while space found 

		   (setq p1n (nth 0 ircolist))
		   (setq p1e (nth 1 ircolist))

(if (= importcgpoint "fromobs")(progn
				 (setq shifte (- speast (atof p1e)))
				 (setq shiftn (- spnorth (atof p1n)))
				 )
;else make shift 0
  (setq shifte 0
	shiftn 0)
  )
  



		 (setq lp1c (strcat (rtos (+ shifte (atof p1e)) 2 9) "," (rtos (+ shiftn (atof p1n)) 2 9)))
		 
		 (if (and (/= pclclass "Road")(= (member pclclass interestlist) nil)(/= pclstate "adjoining")(= (member lp1c poplist) nil))(setq poplist (append poplist (list lp1c))))


		 (setq irplotlist (append irplotlist (list ircolist)(list irplotted)))

		 
		     
(if (> (length ircolist) 4)(progn;if list is more than 2 points		
(setq mpcount (+ (* 2 (fix (/ (/ (length ircolist) 2) 2))) 1))
		 (setq mp1e (nth mpcount ircolist))
		 (setq mp1n (nth (- mpcount 1)ircolist))
		 (setq mp2n (nth (+ mpcount 1)ircolist))
		 (setq mp2e (nth (+ mpcount 2)ircolist))
		 (setq mp1 (list (+ (atof mp1e) shifte) (+ (atof mp1n) shiftn)))
		 (setq mp2 (list (+ (atof mp2e) shifte) (+ (atof mp2n) shiftn)))
		 (setq mp (list (/ (+ (car mp1)(car mP2)) 2) (/ (+ (cadr mp1)(cadr mp2)) 2)))
)
  (progn;else
    		 (setq mp1e (nth 1 ircolist))
		 (setq mp1n (nth 0 ircolist))
		 (setq mp2n (nth (- (length ircolist) 2) ircolist))
		 (setq mp2e (nth (- (length ircolist) 1) ircolist))
		 (setq mp1 (list (+ (atof mp1e) shifte) (+ (atof mp1n) shiftn)))
		 (setq mp2 (list (+ (atof mp2e) shifte) (+ (atof mp2n) shiftn)))
		 (setq mp (list (/ (+ (car mp1)(car mP2)) 2) (/ (+ (cadr mp1)(cadr mp2)) 2)))
))
    
		 (setq mprot (angle mp1 mp2))
		 (setq mprot90 (+ mprot (* 0.5 pi)))
		 (if (/= lotc nil)(progn
				    (setq lotcext (polar lotc mprot90 100))
				    (setq p5 (inters mp1 mp2 lotc lotcext nil))
				    (setq mprot90 (angle lotc p5))
				    ))
						 
		
		 (if (= pclstate "adjoining")(setq textoff -2)(setq textoff 2));always put outside proposed lot
		 (SETQ 1POS (POLAR mp mprot90 (* TH textoff)))
                 (IF (AND (> mprot  (* 0.5 pi)) (< mprot (* 1.5 pi)))(setq mprot (+ mprot pi))) ;if text is upsidedown reverse rotation


		     (setq irtextlist (append irtextlist (list 1pos )(list mprot)(list irdesc)(list irplotted)))
                 ;(SETVAR "CLAYER"  "Drafting" )
		 ;(COMMAND "TEXT" "J" "MC" 1pos TH (ANGTOS mprot 1 4) irdesc)
                 ;(if (/= pclstate "adjoining") (SETVAR "CLAYER"  "Lot Definitions" )(setvar "CLAYER" "Adjoining Boundary"))
(SETQ 1POS (POLAR mp mprot90 (* TH 5)))

		     (SETQ irlinetestlist (APPEND irlinetestlist (LIST irlinetest) 1pos (list (angle mp1 mp2)) (LIST irlinetestrev) 1pos (list (angle mp2 mp1))))
		 
		    	
		   
;irregular plotter and labeller moved to after lot import due to entlast problems

		    
		   
	 (setq ircount 0)
		 (repeat (- (/ (length ircolist) 2) 1)
		   (setq p1n (atof (nth ircount ircolist)))
		   (setq p1e (atof (nth (+ ircount 1) ircolist)))
		   (setq p2n (atof (nth (+ ircount 2) ircolist)))
		   (setq p2e (atof (nth (+ ircount 3) ircolist)))
		   (setq p1 (list (+ shifte p1e)(+ shiftn p1n)))
		   (setq p2 (list (+ shifte p2e)(+ shiftn p2n)))

		    (command "pline" p1 p2 "")
		     (SETQ RMB (ENTLAST))
		     (SSADD RMB ENTSS)
		   
		   (setq ircount (+ ircount 2))
		   );R

		 
                  (linereader);read irregular line end
		  
		 ));p and if irregular line

								  
       

       (if (/= (vl-string-search "<Line" linetext ) nil)(progn

							  ;check for strata wall
							  
(if (/=  (vl-string-search "desc=\"NS\"" linetext ) nil)(setvar "plinewid" 0));non structural
(if (/=  (vl-string-search "desc=\"SR\"" linetext ) nil)(setvar "plinewid" 0.05));structural right
(if (/=  (vl-string-search "desc=\"SC\"" linetext ) nil)(setvar "plinewid"  (/ scale 1000.0)));structural left
(if (/=  (vl-string-search "desc=\"S\"" linetext ) nil)(setvar "plinewid"  (/ scale 1000.0)));structural center common property
(if (/=  (vl-string-search "desc=\"SL\"" linetext ) nil)(setvar "plinewid"  0.05378));structural left
(if (=  (vl-string-search "desc=\"S" linetext ) nil)(setvar "plinewid"  0));normal boundary line with no discription
							  
							  
							  (linereader)
							   (if (/= (setq stringpos (vl-string-search "pntRef" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 8)))
(setq lp1 (substr linetext (+ stringpos 9) (-(- wwpos 1)(+ stringpos 7))))
(setq pos1 (vl-position lp1 cgpointlist))
(setq lp1c (nth (+ pos1 1) cgpointlist)) 
(setq lp1l (nth (+ pos1 1) cgpointlist)) ;create the same but without RL for lists
(setq ptlist (append ptlist (list lp1c)))
(if (and (/= pclclass "Road")(= (member pclclass interestlist) nil)(/= pclstate "adjoining")(= (member lp1c poplist) nil))(setq poplist (append poplist (list lp1c))))
))
							   (linereader)
							   (if (/= (setq stringpos (vl-string-search "pntRef" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 8)))
(setq lp2 (substr linetext (+ stringpos 9) (-(- wwpos 1)(+ stringpos 7))))
(setq pos2 (vl-position lp2 cgpointlist))
(setq lp2c (nth (+ pos2 1) cgpointlist))
))

(if (/= (member pclclass interestlist) nil)(setq easementlist (append easementlist (list (strcat lp1l "," lp2c))(list (strcat lp2c "," lp1l)))));add line and reverse to easementlist
(if (= (member pclclass interestlist) nil)(setq otherlines (append otherlines (list (strcat lp1l "," lp2c))(list (strcat lp2c "," lp1l)))));add line and reverse to otherlines
;(if (= pclclass "Lot")(setq otherlines (append otherlines (list (strcat lp1l "," lp2c))(list (strcat lp2c "," lp1l)))));add line and reverse to otherlines							  


							 (linereader);</line>

                                                     	;DRAW EXISTING EASEMENT ON LOT AS POLYLINE
							  (if (and (/= (member pclclass interestlist) nil) (= pclstate "existing"))
   							(progn
     							(setvar "clayer" "Easement")
     							(command "pline" lp1c lp2c "")
     							(SETQ RMBE (ENTLAST))
     							(SSADD RMBE EASESS)
							(if (/= pclstate "adjoining") (SETVAR "CLAYER"  "Lot Definitions" )(setvar "CLAYER" "Adjoining Boundary"))
     							))

							  ;draw a polyline
                                                     
							  (command "pline" lp1c lp2c "")
							  (SETQ RMB (ENTLAST))
							  (SSADD RMB ENTSS)

						

							  
							  ));p and if line
 
   

      (if (/= (vl-string-search "<Curve" linetext ) nil)(progn
							  ;check for strata wall
							  
(if (/=  (vl-string-search "desc=\"NS\"" linetext ) nil)(setvar "plinewid" 0));non structural
(if (/=  (vl-string-search "desc=\"SR\"" linetext ) nil)(setvar "plinewid" 0.05));structural right
(if (/=  (vl-string-search "desc=\"SC\"" linetext ) nil)(setvar "plinewid"  (/ scale 1000.0)));structural left
(if (/=  (vl-string-search "desc=\"S\"" linetext ) nil)(setvar "plinewid"  (/ scale 1000.0)));structural center common property
(if (/=  (vl-string-search "desc=\"SL\"" linetext ) nil)(setvar "plinewid"  0.05378));structural left
(if (=  (vl-string-search "desc=\"S" linetext ) nil)(setvar "plinewid"  0));normal boundary line with no discription
  
							   (if (/= (setq stringpos (vl-string-search "rot" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 5)))(setq curverot (substr linetext (+ stringpos 6) (-(- wwpos 1)(+ stringpos 4))))))
							 (if (/= (setq stringpos (vl-string-search "radius" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 8)))(setq radius (substr linetext (+ stringpos 9) (-(- wwpos 1)(+ stringpos 7))))))
							  (linereader)
							   (if (/= (setq stringpos (vl-string-search "pntRef" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 8)))
(setq cp1 (substr linetext (+ stringpos 9) (-(- wwpos 1)(+ stringpos 7))))
(setq pos1 (vl-position cp1 cgpointlist))
(setq lp1c (nth (+ pos1 1) cgpointlist))
(setq ptlist (append ptlist (list lp1c)))
(if (and (/= pclclass "Road")(= (member pclclass interestlist) nil)(/= pclstate "adjoining")(= (member lp1c poplist) nil))(setq poplist (append poplist (list lp1c))))
))
							   (linereader)
							   (if (/= (setq stringpos (vl-string-search "pntRef" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 8)))
(setq curvecen (substr linetext (+ stringpos 9) (-(- wwpos 1)(+ stringpos 7))))
(setq pos1 (vl-position curvecen cgpointlist))
(setq curvecenc (nth (+ pos1 1) cgpointlist))
))
							  (linereader)
							   (if (/= (setq stringpos (vl-string-search "pntRef" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 8)))
(setq cp2 (substr linetext (+ stringpos 9) (-(- wwpos 1)(+ stringpos 7))))
(setq pos2 (vl-position cp2 cgpointlist))
(setq lp2c  (nth (+ pos2 1) cgpointlist))
))
							  (linereader)

		(setq ,pos1 (vl-string-position 44 lp1c 0))
                 (setq east (atof (substr lp1c 1 ,pos1)))
      		 (setq north (atof (substr lp1c (+ ,pos1 2) 50)))
					   (setq tp1 (list east north))
                                           (setq p1 (list east north))
  (setq ,pos1 (vl-string-position 44 lp2c 0))
                 (setq east (atof (substr lp2c 1 ,pos1)))
      		 (setq north (atof (substr lp2c (+ ,pos1 2) 50)))
					   (setq tp2 (list east north))
                                           (setq p2 (list east north))

(setq ,pos1 (vl-string-position 44 curvecenc 0))
                 (setq east (atof (substr curvecenc 1 ,pos1)))
      		 (setq north (atof (substr curvecenc (+ ,pos1 2) 50)))
					   (setq cc1 (list east north))
                                           (setq c1 (list east north))

							  (setq ang1 (angle cc1 p1))
							  (setq ang2 (angle cc1 p2))
							  (if (= curverot "cw")(setq O (- ANG1 ANG2)))
							  (if (= curverot "ccw")(setq O (- ANG2 ANG1)))
							  
  (IF (< O 0) (SETQ O (+ O (* PI 2))))
  	   (setq arclength (rtos ( *  (atof radius) O) 2 3))
							  
	    (setq digchaz (angle p1 p2))

;calc arc internal angle
	       (SETQ MAST (SQRT (- (* (atof RADIUS) (atof RADIUS)) (* (/ (distance p1 p2) 2)(/ (distance p1 p2) 2 )))))
  (SETQ O (* 2 (ATAN (/ (/ (distance p1 p2) 2) MAST))))
	    (setq remhalfO  (- (* 0.5 pi) (/ O 2)))
	    ;calc bearing from p1 to arc centre (watching for bulbous arcs)
	    (if (and (= curverot "ccw") (<= (atof arclength) (* pi (atof radius))))(setq raybearing (+  digchaz  remhalfO)))
	    (IF (and (= curverot "cw") (<= (atof arclength) (* pi (atof radius))))(setq raybearing (-  digchaz  remhalfO)))
	    (IF (and (= curverot "ccw") (> (atof arclength) (* pi (atof radius))))(setq raybearing (-  digchaz  remhalfO)))
	    (if (and (= curverot "cw") (> (atof arclength) (* pi (atof radius))))(setq raybearing (+  digchaz  remhalfO)))
	    
	      ;CONVERT TO ANTI CLOCKWISE AND EAST ANGLE
  ;(SETQ raybearing (+ (* -1 raybearing) (* 0.5 PI)))

	       ;calc curve centre point
	    (setq curvecen (polar p1 raybearing (atof radius)))
	    (setq curvecenc (strcat (rtos (car curvecen) 2 9) "," (rtos (cadr curvecen) 2 9 ) ))

(if (/= (member pclclass interestlist) nil)(setq easementlist (append easementlist (list (strcat lp1c "," lp2c))(list (strcat lp2c "," lp1c)))));add line and reverse to easementlist
(if (= pclclass "Road")(setq otherlines (append otherlines (list (strcat lp1c "," lp2c))(list (strcat lp2c "," lp1c)))));add line and reverse to not eassementlist
(if (= pclclass "Lot")(setq otherlines (append otherlines (list (strcat lp1c "," lp2c))(list (strcat lp2c "," lp1c)))));add line and reverse to not easementlist							  

;(if (= curverot "ccw" )(setq lp1c (strcat lp1c "," (rtos blnrl 2 3)))(setq lp2c (strcat lp2c (strcat "," (rtos blnrl 2 3)))))

							  ;DRAW LINES FOR EXISTING EASEMENT
							  (if (and (/= (member pclclass interestlist) nil) (= pclstate "existing"))
   							(progn
     							(setvar "clayer" "Easement")
     							(if (= curverot "ccw") (command "pline" lp1c "a" "ce" curvecenc  lp2c "")(command "pline" lp2c "a" "ce" curvecenc lp1c ""))
     							(SETQ RMBE (ENTLAST))
     							(SSADD RMBE EASESS)
							 (if (/= pclstate "adjoining") (SETVAR "CLAYER"  "Lot Definitions" )(setvar "CLAYER" "Adjoining Boundary"))
     							))
							  
							 (if (= curverot "ccw") (command "pline" lp1c "a" "ce" curvecenc  lp2c "")(command "pline" lp2c "a" "ce" curvecenc lp1c ""))
							  (SETQ RMB (ENTLAST))
							  (SSADD RMB ENTSS)

							 


							  

							  
							 ));p and if curve

	(IF (and (= pclstate "adjoining")(/= (member pclclass interestlist) nil))(setvar "CELTYPE" "ByLayer"));reset variable for adjoining lots

					    (linereader);read line curve or end of coordinate geometery



       	));p and while </CoordGeom>					  

								  (setq ptlist (append ptlist (list lp2c)))

       ;join all exsiting easements into a polyline so they dont get exported
       (if (and (/= (member pclclass interestlist) nil) (= pclstate "existing"))(command "pedit" "m" easess "" "j" "" ""))

        ;join all plotted lot defintions in to a polyline
					    (command "pedit" "m" entss "" "j" "" "")


       

      
  ;calc lot centre if not specified
       (if (= lotc nil)(progn
			 (setq easttot 0)
			 (setq northtot 0)
			 (if (= (nth 0 ptlist)(nth (- (length ptlist) 1) ptlist))(setq n (- (length ptlist) 1))(setq n (length ptlist)));make repeat for closed or unclosed list

			 (setq avgcnt 0)
			 (repeat n
			   (setq pnt (nth avgcnt ptlist))
        (setq ,pos1 (vl-string-position 44 pnt 0))
    (setq east  (substr pnt 1 ,pos1 ))
    (setq north  (substr pnt (+ ,pos1 2) 500))
			   (setq easttot (+ easttot (atof east)))
			   (setq northtot (+ northtot (atof north)))
			   (setq avgcnt (+ avgcnt 1))
			   )
			 (setq lotc (list (/ easttot n)(/ northtot n)))
			 
			 ));p&if no lot centre

              ;multipart lot
       (if (= (substr pclname 1 2) "CP")(setq pclname "CP"))
       
                     (if (and (= pcltype "Part")(/= pclname "CP")) (progn
				(setq lotdesc (strcat "PT" (substr pclname 1 (- (strlen pclname) 1))))
				(setq pclname (substr pclname 1 (- (strlen pclname) 1)));need to fix to deal with multi letter part numbers
				)
		       (setq lotdesc pclname);else standard lot)
		       )


              ;road or easement lot check for and-&
       (if (or (= pclclass "Road")(/= (member pclclass interestlist) nil)(= pclclass "Hydrography")) (progn
                                     (setq &pos 0)
	      (while (/=  (setq &pos (vl-string-search "&amp;" pcldesc &pos )) nil) (setq pcldesc (vl-string-subst "&" "&amp;"  pcldesc &pos)
										      &pos (+ &pos 1)))
				     				    (setq quotpos 0)
	(while (/=  (setq quotpos (vl-string-search "&quot;" pcldesc quotpos )) nil) (setq pcldesc (vl-string-subst "\"" "&quot;"  pcldesc 	quotpos)
										      quotpos (+ quotpos 1)))
					      (setq apos 0)
	(while (/=  (setq apos (vl-string-search "&apos;" pcldesc apos )) nil) (setq pcldesc (vl-string-subst "'" "&apos;"  pcldesc apos)
										      apos (+ apos 1)))
				; (setq lotdesc pcldesc)
				 
				 ))
	;if blno add number prefix
             (if (/= pclbln "")(progn
				 (setq pclbln (cadr (member pclbln lotlevellist)))
				 (setq blns (strcat " buildingLevelNo=\"" pclbln "\"")))
				 (setq blns ""))
       
       (if (/= pcldesc "")(setq pcldescs (strcat " desc=\"" pcldesc "\""))(setq pcldescs ""))
       (if (/= pclarea "")(setq areas (strcat " area=\"" pclarea "\""))(setq areas ""))
 
       (if (/= pclbn "")(setq bns (strcat " buildingNo=\"" pclbn "\""))(setq bns ""))
       (if (/= pcluse "")(setq pcluses (strcat " useOfParcel=\"" pcluse "\""))(setq pcluses ""))
       
  (SETQ LTINFO (STRCAT "  <Parcel name=\"" pclname "\"" pcldescs  " class=\"" pclclass "\" state=\"" pclstate "\" parcelType=\"" pcltype "\" parcelFormat=\""
		       pclformat "\"" areas pcluses blns bns ">!" (rtos (cadr lotc) 2 6 ) " " (rtos (car lotc) 2 6)))
(SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 LTINFO)))))


       (SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 LTINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)
					    
(SETQ prefix "")
 (if (or (= pcluse "Parish" )(= pcluse "County")(= pcluse "Local Government Area")(= pclclass "Reserved Road"))(progn
  (if (= pcluse "Parish")(setq linestyle "PARISH BOUNDARY"
			       prefix "PARISH OF "))
  (if (= pcluse "County")(setq linestyle "COUNTY BOUNDARY"
			       prefix "COUNTY OF "))
  (if (= pcluse "Local Government Area")(setq linestyle "LGA BOUNDARY"
					      prefix "LGA OF "))
  (if (= pclclass "Reserved Road")(setq linestyle "EASEMENT"))
  (command "change" sent "" "properties" "ltype" linestyle "")
  ))
 (if (and (/= (vl-position pclclass interestlist) nil) (= pclstate "existing"))(command "draworder" sent "" "b"))
             

      

			;plot irregular lines
					    (setq ircount1 0)
		(repeat (/ (length irplotlist) 2)
		  
		  (setq ircolist (nth ircount1 irplotlist))
		  (setq irplotted (nth (+ ircount1 1)  irplotlist))
		 (setq irss (ssadd))
		 (setq ircount 0)
		 (repeat (- (/ (length ircolist) 2) 1)
		   (setq p1n (atof (nth ircount ircolist)))
		   (setq p1e (atof (nth (+ ircount 1) ircolist)))
		   (setq p2n (atof (nth (+ ircount 2) ircolist)))
		   (setq p2e (atof (nth (+ ircount 3) ircolist)))
		   (setq p1 (list (+ shifte p1e)(+ shiftn p1n)))
		   (setq p2 (list (+ shifte p2e)(+ shiftn p2n)))

		  

		   (IF (= IRPLOTTED "N")(PROGN
		   (setvar "clayer" "Irregular Boundary")
		   (IF (= pclstate "adjoining" )(SETVAR "CELWEIGHT" 25))
		   (command "pline" p1 p2 "")
		   (IF (= pclstate "adjoining" )(SETVAR "CELWEIGHT" -1))
		       (SETQ RMB (ENTLAST))
		     (SSADD RMB irss)
		   (if (and (/= (vl-position pclclass interestlist) nil) (= pclstate "existing"))
   							(progn
     							(setvar "clayer" "Easement")
     							(command "line" p1 p2 "")
     							(SETQ RMB (ENTLAST))
     							(SSADD RMB EASESS)	      
     							))
		   ))
		   
		   (setq ircount (+ ircount 2))
		   );R
		 (IF (= IRPLOTTED "N")
		   (PROGN
		     (IF (> (LENGTH IRCOLIST) 4)
		       (command "pedit" "m" irss "" "j" "" "s" "");longer than 2 verticies make spline
		       )
		       
		       
		       
		     

		  (SETQ LTINFO irdesc)
(SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 LTINFO)))))
     (SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)
		     
 
		   ));p&if plotted
		  (setq ircount1 (+ ircount1 2)) 
		  );r

					     (SETVAR "CLAYER"  "Drafting" )
					    
					    ;plot all irregualar line labels
					    (setq ircount 0)
					    (repeat (/ (length irtextlist) 4)
					      (if (= (nth (+ ircount 3) irtextlist) "N")(COMMAND "TEXT" "J" "MC" (nth ircount irtextlist) TH (ANGTOS (nth (+ ircount 1) irtextlist) 1 4) (nth (+ ircount 2) irtextlist)))
					      (setq ircount (+ ircount 4))
					      )


					    
                
    
      
			      

       
;label lot centre with lot and area etc.

					    
       (setvar "dimzin" 0)
					    
					    ;make area to 4 significant figures
					    (if (/= "" pclarea) (progn
					    (setq area (atof pclarea))

					     (if (= ard "YES")
	(progn
      					    (if (> area1 0)(setq pclareas (strcat (rtos (* (fix (/ area1 0.001)) 0.001) 2 3) "m�")))
					    (if (> area1 10)(setq pclareas (strcat (rtos (* (fix (/ area1 0.01)) 0.01) 2 2) "m�")))
					    (if (> area1 100)(setq pclareas (strcat (rtos (* (fix (/ area1 0.1)) 0.1) 2 1) "m�")))
					    (if (> area1 1000)(setq pclareas (strcat (rtos (* (fix (/ area1 1)) 1) 2 0) "m�")))
      					    (if (> area1 10000) (setq pclareas (strcat (rtos (* (fix (/ (/ area1 10000) 0.001)) 0.001) 2 3) "ha")))
					    (if (> area1 100000) (setq pclareas (strcat (rtos (* (fix (/ (/ area1 10000) 0.01)) 0.01) 2 2) "ha")))
					    (if (> area1 1000000) (setq pclareas (strcat (rtos (* (fix (/ (/ area1 10000) 0.1)) 0.1) 2 1) "ha")))
					    (if (> area1 10000000) (setq pclareas (strcat (rtos (* (fix (/ (/ area1 10000) 1)) 1) 2 0) "ha")))
                                            (if (> area1 100000000) (setq pclareas (strcat (rtos (* (fix (/ (/ area1 1000000) 0.1)) 0.1) 2 1) "km�")))
                                            (if (> area1 1000000000) (setq pclareas (strcat (rtos (* (fix (/ (/ area1 1000000) 1)) 1) 2 0) "km�")))
	  )
	(progn
	        			    (if (> area1 0)(setq pclareas (strcat (rtos   area1 2 3) "m�")))
					    (if (> area1 10)(setq pclareas (strcat (rtos   area1  2 2) "m�")))
					    (if (> area1 100)(setq pclareas (strcat (rtos  area1  2 1) "m�")))
					    (if (> area1 1000)(setq pclareas (strcat (rtos area1  2 0) "m�")))
      					    (if (> area1 10000) (setq pclareas (strcat (rtos  (/ area1 10000)  2 3) "ha")))
					    (if (> area1 100000) (setq pclareas (strcat (rtos  (/ area1 10000)  2 2) "ha")))
					    (if (> area1 1000000) (setq pclareas (strcat (rtos  (/ area1 10000)  2 1) "ha")))
					    (if (> area1 10000000) (setq pclareas (strcat (rtos   (/ area1 10000) 2 0) "ha")))
                                            (if (> area1 100000000) (setq pclareas (strcat (rtos (/ area1 1000000)  2 1) "km�")))
                                            (if (> area1 1000000000) (setq pclareas (strcat (rtos  (/ area1 1000000) 2 0) "km�")))

      ));if ard

					    

					    (setq areapos (polar lotc (* 1.5 pi) (* th 2.5)))
					    (if (= pclformat "Strata") (setq pclareas (strcat (rtos area 2 0) "m�")));integer if strata area
					    (if (= pcltype "Part" ) (setq pclareas (strcat "(" pclareas ")")))
					    (SETVAR "CELWEIGHT" 35)
					    ;(COMMAND "TEXT" "J" "BC" areapos (* TH 1.4) "90"  pclareas )
					    
					    );p
					      
					      (setq pclareas "");else
					      );if pclarea
       (setvar "dimzin" 8)
					    
					    ;draw lot info




       
       (if (and (= pclstate "proposed")(= pcltype "Part")(= pcldesc ""))(progn;label first lot with no parcel description with total area
						   
						    (if (/= (setq listpos (vl-position pclname mplist)) nil)(progn
							    (setq totarea (nth (+ listpos 1) mplist));use pcl as area labeller
							    (if (= pclformat "Strata") (setq totarea (strcat (rtos (atof totarea) 2 0) "m�")));integer if strata area
							    (setq mplist (remove_nth mplist (+ listpos 1)))
							    (setq mplist (remove_nth mplist listpos ))
							    (setq THF 1.2)
							    (setq totareapos (polar lotc (* 1.5 pi) (* th 4)))
			   (COMMAND "TEXT" "J" "BC" totareapos (* TH 1.4) "90" totarea)
							    ))
						   ));p&if part with no desc


       

(setq THF 2)
       (SETQ CELLWEIGHT 50)
       (if (= pclclass "Easement")(progn  (setq THF 1)
					(setq CELLWEIGHT -1)
				    
				     ; (setq lotdesc pclname)
				      
				  );p easement
	 
    
	 (setq THF 2 ;else
	       CELLWEIGHT 50)
	 );if easement

       (if (= pclstate "adjoining") (setq cellweight -1))

      
       ;strata location plan lots strip number from end of lot number
       (if (and (= pclbln "0,Location Plan")(= pclclass "Lot")(= pclstate "proposed"))
	 (while (and (> (ascii(substr lotdesc (strlen lotdesc) 1)) 47)(< (ascii(substr lotdesc (strlen lotdesc) 1)) 58))
	 (setq lotdesc (substr lotdesc 1 (- (strlen lotdesc) 1)))
		     )
	 )
       
       

      ; (if (and (/= pclclass "Building")(/= pclstate "affected"))

   ;    (progn ;else standard lot labeller

;	(SETVAR "CELWEIGHT" CELLWEIGHT)
   ;      (COMMAND "TEXT" "J" "BC" lotc (* TH THF) "90" lotdesc)
;	));p&if not building or affected
       
;use labeller removed.  I cant remember why I put it in.
    ;   (if (/= pcluse "")(progn
;			   (setq usepos (polar lotc (* 1.5 pi) (* th 5.5)))
;			   (COMMAND "TEXT" "J" "BC" usepos (* TH 1.4) "90" pcluse)
;			   )
;	 )
       
       ;desc labeller
   ;    (if (/= desc "")(progn
			   ;(setq descpos (polar lotc (* 1.5 pi) (* th 5.5)))
			   ;(COMMAND "TEXT" "J" "BC" descpos (* TH 1.4) "90" desc)
			   ;)
	 ;)

			   



  
  (setq areapos (polar lotc (* 1.5 pi) (* th 2)))
  (setq cpdescpos (polar lotc (* 1.5 pi) (* th 1.5)))
  (setq descpos (polar lotc (* 1.5 pi) (* th 4)))
  (setq easelabelpos (polar lotc (* 1.5 pi) (* th 1.1)))					    
       
  

;1. case if desc only eg. vincd balcony - also road and other object labeller
  (if (and (/= pclstate "affected")(/= pclclass "Building")(/= pcldesc "")(= pclarea "")(/= lotdesc "CP")(= (member pclclass interestlist) nil))(progn

				;	(COMMAND "COLOR" "1")											    (SETVAR "CELWEIGHT" 35)
				     (if (or (= pclclass "Road")(= pclclass "Railway")(= pclclass "Administrative Area")(= pclclass "Hydrography"))(setq thn 2)(setq thn 1.4))
				       
				     (COMMAND "TEXT" "J" "MC" lotc (* TH thn) "90" (strcase pcldesc))
				     ))
    
;2. case if desc-no and area-yes eg. standard lot - THIS IS ALSO THE NON STRATA LOT LABELLER
  (if (and (/= pclstate "affected")(/= pclclass "Building")(= pcldesc "")(/= pclarea ""))(progn
											  ; (COMMAND "COLOR" "2")
				     (SETVAR "CELWEIGHT" 50)
				     (COMMAND "TEXT" "J" "BC" lotc (* TH 2) "90" lotdesc)
				     (SETVAR "CELWEIGHT" 35)
				     (COMMAND "TEXT" "J" "BC" areapos (* TH 1.4) "90" pclareas)

				      (IF (/= (member pcluse lotuoplist) nil )(progn
									      (SETVAR "CELWEIGHT" 35)
				     (COMMAND "TEXT" "J" "BC" descpos (* TH 1.4) "90" (strcase pcluse))
									     ))
				     
				     ))
					    
;3. case if desc-yes and area-yes eg. car space
  (if (and (= pclformat "Strata")(/= pclstate "affected")(/= pclclass "Building")(/= pcldesc "")(/= pclarea ""))(progn
											   ; (COMMAND "COLOR" "3")
				      (SETVAR "CELWEIGHT" 50)
				      (COMMAND "TEXT" "J" "BC" lotc (* TH 2) "90" lotdesc)
				      (SETVAR "CELWEIGHT" 35)
				     (COMMAND "TEXT" "J" "BC" areapos (* TH 1.4) "90" pclareas)
				      (SETVAR "CELWEIGHT" 25)
				      (COMMAND "TEXT" "J" "BC" descpos (* TH 1) "90" pcldesc)
				      ))
					    
;4. case if area-no or desc-no eg. normal common property
    (if (and (= pclformat "Strata")(= pclclass "Common Property")(= pcldesc "")(= pclarea "")(/= pclbln "0,Location Plan"))(progn
												  ;   (COMMAND "COLOR" "4")
				     (SETVAR "CELWEIGHT" 35)
				     (COMMAND "TEXT" "J" "MC" lotc (* TH 1) "90" lotdesc)))
;5. case if area-no and desc-yes and lot no = CP eg. desc common property
      (if (and (= pclformat "Strata")(= pclclass "Common Property")(/= pcldesc "")(= pclarea "")(= lotdesc "CP")(/= pclbln "0,Location Plan"))(progn
														;	(COMMAND "COLOR" "5")
				     (SETVAR "CELWEIGHT" 35)
				     (COMMAND "TEXT" "J" "BC" lotc (* TH 1) "90" lotdesc)
				     (COMMAND "TEXT" "J" "BC" cpdescpos (* TH 1) "90" pcldesc)))

  ;6. Case if area-no and desc-no and start of lot no = CP and floor is location plan eg. location plan common property
      (if (and (= pclformat "Strata")(= (substr lotdesc 1 2) "CP")(= pclbln "0,Location Plan"))(progn
									 
								       ;do nothing
				     ))
         ;7. Case if area-no or desc-no and start of lot no not CP and floor is location plan eg. location plan other lots
      (if (and (= pclformat "Strata")(/= pclclass "Building")(/= (substr lotdesc 1 2) "CP")(= pclbln "0,Location Plan")(/= pclstate "affected")(/= pclstate "adjoining" ))(progn
																		  ;  (COMMAND "COLOR" "7")
								      (COMMAND "TEXT" "J" "BC" lotc (* TH 1) "90" lotdesc)
				     ))



       ;8.If class is building
  (IF (= pclclass "Building")(PROGN
			      ; (COMMAND "COLOR" "8")
		;(setq tlp (LIST (+ (CAR LOTC) (* -10 TH)) (+ (CADR lotc) (* 10 TH)) (caddr lotc)))
			    (if (and (> (ascii pclbn) 47) (< (ascii pclbn) 57))(setq pclbn (strcat "No " pclbn)))
				    (SETQ bldtext (strcat pclbn (chr 10) pcldesc))
				    (command "-mtext" lotc "j" "mc" "h" (* th 1.4) "c" "n" "w" (* th 20) bldtext "")
				    ))

       ;9 Case for easements where the easement number is labelled
    (IF (/= (member pclclass interestlist) nil)(PROGN
				; (COMMAND "COLOR" "9")
						 (SETVAR "CELWEIGHT" 35)
						 ;if description starts with ( draw letter and label easement in lot definitons layer
						 (if (= (substr pcldesc 1 1) "(")(progn
										 (setq cbpos1 (vl-string-position 41 pcldesc 0))
										 (setq easeletter  (substr pcldesc 1 (+ cbpos1 1)))
										 (setvar "clayer" "Lot definitions")
										 (COMMAND "TEXT" "J" "MC" easelabelpos (* TH 0.75) "90" (strcat  lotdesc  ))
										 (setvar "clayer" "Drafting")
										 (COMMAND "TEXT" "J" "MC" lotc (* TH 1.4) "90" (strcat easeletter ))
										 
					    
					    )
						 
(COMMAND "TEXT" "J" "BC" lotc (* TH 1.4) "90" (strcat "(" lotdesc ")" ))
						   );if first character is bracket

						   ));if easement

       ;10 Case for adjoining lots
					    ;(COMMAND "COLOR" "10")
       (if (and (= pclstate "adjoining")(= pcldesc ""))(progn
							     (SETVAR "CELWEIGHT" 50)
				      (COMMAND "TEXT" "J" "BC" lotc (* TH 2) "90" (strcat prefix lotdesc))
							 (IF (/= (member pcluse lotuoplist) nil )(progn
									      (SETVAR "CELWEIGHT" 35)
				     (COMMAND "TEXT" "J" "BC" areapos (* TH 1.4) "90" (strcase pcluse))
									     ))
							     ))
	
					    

		;(COMMAND "COLOR" "BYLAYER")
					    
;11. Road with area
  (if (and (= pclclass "Road")(/= pclarea ""))(progn

				;	(COMMAND "COLOR" "1")											    (SETVAR "CELWEIGHT" 35)
				     (setq thn 2)
				       (COMMAND "TEXT" "J" "BC" areapos (* TH 1.4) "90" pclareas)
				     (COMMAND "TEXT" "J" "MC" lotc (* TH thn) "90" (strcase pcldesc))
				     
				     ))


    
  (SETVAR "CELWEIGHT" -1);reset cellweight


       
			   
       (if (or (= pclclass "Road")(/= (vl-position pclclass interestlist) nil)(= pclclass "Hydrography"))  (setq roadname (entget (entlast))))
				 

       
  
       


       


       
       ;road name rotator
       (if (or (= pclclass "Road")(/= (vl-position pclclass interestlist) nil))(progn
		(setq nearang pi)					    
		(setq count 0)
		(setq minoff 100000000000000000000000000000000000000)
		(setq ptlist (append ptlist (list(nth 0 ptlist))))
(repeat (- (length ptlist)2 )

  (setq op1 (nth count ptlist))
  (setq op2 (nth (+ count 1) ptlist))
  (setq op3 (nth (+ count 2) ptlist))

  (setq ,pos1 (vl-string-position 44 op1 0))
(setq op1 (list (atof (substr op1 1 ,pos1)) (atof (substr op1 (+ ,pos1 2) 50))))
  (setq ,pos1 (vl-string-position 44 op2 0))
(setq op2 (list (atof (substr op2 1 ,pos1)) (atof (substr op2 (+ ,pos1 2) 50))))
  (setq ,pos1 (vl-string-position 44 op3 0))
(setq op3 (list (atof (substr op3 1 ,pos1)) (atof (substr op3 (+ ,pos1 2) 50))))

  ;check line one
;check offset to line
  (SETQ ANG (ANGLE oP1 oP2))
  (SETQ CANG (+ ANG (/ PI 2)))
  (SETQ P4 (POLAR lotc CANG 1000))
  (SETQ P6 (POLAR lotc (+ CANG PI) 2000))
  (IF (SETQ P5 (INTERS oP1 oP2 P6 P4 ))(PROGN

					 (SETQ OFF (DISTANCE lotc P5))

    (if (< OFF (ABS MINOFF))(SETQ minoff (abs off)
				  nearang cang)
      );if
    
  ));p & if inters


  

    ;check to see if point is inside deflection angle (on the outside of a line bending away)
    
    (setq ang2 (angle op2 op3))
    (setq cang2 (+ ang (/ pi 2)))
    (setq ltopang (angle op2 lotc))
    (setq defl (- ang2 ang))
(if (/= defl 0);check for straight line
  (progn
    (if (< defl pi)(progn
		     (setq ray1 (- ang (/ pi 2)))
		     ;(if (< ray1 0) (setq ray1 (+ ray1 (* 2 pi))))
		     (setq ray2 (- ang2 (/ pi 2)))
		     ;(if (< ray2 0) (setq ray2 (+ ray2 (* 2pi))))
		     ));p and if less than pi
    (if (> defl pi)(progn
		     (setq ray1 (+ ang (/ pi 2)))
		     ;(if (> ray1 (* 2 pi)(setq ray1 (- ray1 (* 2 pi)))))
		     (setq ray2 (+ ang (/ pi 2)))
		     ;(if (> ray2 (* 2 pi)(setq ray2 (- ray2 (* 2 pi)))))
		     ));p and if greater than pi

    (if (or (and (> ltopang ray1) (< ltopang ray2))(and (> ltopang ray2)(< ltopang ray1)));check to see if inside deflection squares **** needs testing later
      (progn
	(setq off (distance lotc op2))
(if (< OFF (ABS MINOFF))(SETQ minoff (abs off)
				  nearang ltopang)
      );if
	));p and if in defl sqr
   ));p and if not straight line

  (setq count (+ count 1))
  
    );repeat
      
				;using this info change the road name text rotation to the angle of the line
		(setq rrot (+ nearang (/ pi 2)))
		(if (> rrot (* 2 pi))(setq rrot (- rrot (* 2 pi))))
		(IF (AND (> rrot  (* 0.5 pi)) (< rrot (* 1.5 pi)))(setq rrot (+ rrot pi))) ;if text is upsidedown reverse rotation
					  
		
    
  (SETQ	roadname (subst (cons 50  rrot);SUB IN NEW POINT 2 HEIGHT
		     (assoc 50 roadname)
		     roadname
	      )
  )
  
		  (SETQ	roadname (subst (cons 73  2);SUB IN NEW POINT 2 HEIGHT
		     (assoc 73 roadname)
		     roadname
	      )
  )
  (ENTMOD roadname)

				));p & if road
       


				
					   (linereader);read </Parcel>
					    (linereader);read next parcel or end of parcels

							       ));p & if multipart
       
   ));p and while not </Parcels>


  ;Sort out the easment line list by comparing the road and boundary lines to the easement lines
  (setq count 0)
  (if (> (length easementlist) 0)(progn
				 (repeat (length easementlist)
    (setq checkline (nth count easementlist))
    (if  (= (vl-position checkline otherlines) nil) (setq finaleaselist (append finaleaselist (list checkline))))
    (setq count (+ count 1))
    )
				 );p
    (setq finaleaselist easementlist);else

    );if length of otherlines


  

  ;11. read PLAN FEATURES if they exist-----------------------------------------------------------------


  (close xmlfile)
   (setq xmlfile (open xmlfilen "r"))
(linereader)

  ;linefeed to planfeatures
 (while (and (= (vl-string-search "</LandXML>" linetext) nil)(= (vl-string-search "<PlanFeatures" linetext) nil)) ( progn 
 (linereader)
))
  (if (= (vl-string-search "</LandXML>" linetext) nil)(progn ;catch for no plan features
  (if (or (=  linetext "<PlanFeatures name=\"Occupation\">")
	  (=  linetext "<PlanFeatures name=\"occupation\">")
	  (=  linetext "<PlanFeatures name=\"occupations\">")
	  (=  linetext "<PlanFeatures name=\"Occupations\">"))(progn

(linereader);read feature info line
  ;do until end of parcels
       (while (= (vl-string-search "</PlanFeatures>" linetext ) nil) ( progn

  
					  
;get parcel info
       (if (/= (setq stringpos (vl-string-search "name" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 6)))(setq pclname (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5)))))(setq pclname ""))
       (if (/= (setq stringpos (vl-string-search "desc" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 6)))(setq pcldesc (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5)))))(setq pcldesc ""))
(setq &pos 0)
  	      (while (/=  (setq &pos (vl-string-search "&amp;" pcldesc &pos )) nil) (setq pcldesc (vl-string-subst "&" "&amp;"  pcldesc &pos)
   										      &pos (+ &pos 1)))
       (setq quotpos 0)
	(while (/=  (setq quotpos (vl-string-search "&quot;" pcldesc quotpos )) nil) (setq pcldesc (vl-string-subst "\"" "&quot;"  pcldesc 	quotpos)
										      quotpos (+ quotpos 1)))
					      (setq apos 0)
	(while (/=  (setq apos (vl-string-search "&apos;" pcldesc apos )) nil) (setq pcldesc (vl-string-subst "'" "&apos;"  pcldesc apos)
										      apos (+ apos 1)))
;figure out layer
       (SETQ pclname (strcase pclname))
		(if (= (substr pclname 1 4) "WALL")(setq layer "Occupation Walls"))
		(if (= (substr pclname 1 4) "FENC")(setq layer "Occupation Fences"))
		(if (= (substr pclname 1 4) "KERB")(setq layer "Occupation Kerbs"))
		(if (= (substr pclname 1 4) "BUIL")(setq layer "Occupation Buildings"))			    
		(if (= (substr pclname 1 4) "OFFS")(setq layer "Occupations"))
					    
  
					   (SETVAR "CLAYER"  layer )

       (linereader);coord geometery name - not needed yet

       ;do until end of parcel
      (linereader);line or arc
       (setq ptlist nil)
	 (setq geolength 0)
         (SETQ ENTSS (SSADD))
       
					    
       (while(= (vl-string-search "</CoordGeom>" linetext ) nil)( progn

								  
       

       (if (/= (vl-string-search "<Line" linetext ) nil)(progn
							   
							 (linereader)
							  
							   (if (/= (setq stringpos (vl-string-search "pntRef" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 8)))
(setq lp1 (substr linetext (+ stringpos 9) (-(- wwpos 1)(+ stringpos 7))))
(setq pos1 (vl-position lp1 cgpointlist))
(setq lp1c (nth (+ pos1 1) cgpointlist))
(setq ptlist (append ptlist (list lp1c)))
))
							   (linereader)
							   (if (/= (setq stringpos (vl-string-search "pntRef" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 8)))
(setq lp2 (substr linetext (+ stringpos 9) (-(- wwpos 1)(+ stringpos 7))))
(setq pos2 (vl-position lp2 cgpointlist))
(setq lp2c (nth (+ pos2 1) cgpointlist))
))



							 (linereader);</line>
							  
							  ;for the time being draw a line
							  (command "line" lp1c lp2c "")
							  (SETQ RMB (ENTLAST))
							  (SSADD RMB ENTSS)
							  (setq geolength (+ geolength 1))
(SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
   (setq p1 (CDR(ASSOC 10 sentlist)))
   (setq p2 (CDR(ASSOC 11 sentlist)))

							  ));p and if line

      (if (/= (vl-string-search "<Curve" linetext ) nil)(progn
							   (if (/= (setq stringpos (vl-string-search "rot" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 5)))(setq curverot (substr linetext (+ stringpos 6) (-(- wwpos 1)(+ stringpos 4))))))
							 (if (/= (setq stringpos (vl-string-search "radius" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 8)))(setq radius (substr linetext (+ stringpos 9) (-(- wwpos 1)(+ stringpos 7))))))
							  
							  (linereader)
							   (if (/= (setq stringpos (vl-string-search "pntRef" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 8)))
(setq cp1 (substr linetext (+ stringpos 9) (-(- wwpos 1)(+ stringpos 7))))
(setq pos1 (vl-position cp1 cgpointlist))
(setq lp1c (nth (+ pos1 1) cgpointlist))
(setq ptlist (append ptlist (list lp1c)))
))
							   (linereader)
							   (if (/= (setq stringpos (vl-string-search "pntRef" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 8)))
(setq curvecen (substr linetext (+ stringpos 9) (-(- wwpos 1)(+ stringpos 7))))
(setq pos1 (vl-position curvecen cgpointlist))
(setq curvecenc (nth (+ pos1 1) cgpointlist))
))
							   (linereader)
							   (if (/= (setq stringpos (vl-string-search "pntRef" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 8)))
(setq cp2 (substr linetext (+ stringpos 9) (-(- wwpos 1)(+ stringpos 7))))
(setq pos2 (vl-position cp2 cgpointlist))
(setq lp2c (nth (+ pos2 1) cgpointlist))
))
							   (linereader)

		(setq ,pos1 (vl-string-position 44 lp1c 0))
                 (setq east (atof (substr lp1c 1 ,pos1)))
      		 (setq north (atof (substr lp1c (+ ,pos1 2) 50)))
					   (setq tp1 (list east north))
                                           (setq p1 (list east north))
  (setq ,pos1 (vl-string-position 44 lp2c 0))
                 (setq east (atof (substr lp2c 1 ,pos1)))
      		 (setq north (atof (substr lp2c (+ ,pos1 2) 50)))
					   (setq tp2 (list east north))
                                           (setq p2 (list east north))
	    (setq digchaz (angle p1 p2))

;calc arc internal angle
	      (SETQ MAST (SQRT (- (* (atof RADIUS) (atof RADIUS)) (* (/ (distance p1 p2) 2)(/ (distance p1 p2) 2 )))))
  (SETQ O (* 2 (ATAN (/ (/ (distance p1 p2) 2) MAST))))
	    (setq remhalfO (/ (- pi O) 2))
	    ;calc bearing from p1 to arc centre
	    (if (= curverot "ccw")(setq raybearing (+  digchaz  remhalfO))(setq raybearing (-  digchaz  remhalfO)))
	    
	      ;CONVERT TO ANTI CLOCKWISE AND EAST ANGLE
  ;(SETQ raybearing (+ (* -1 raybearing) (* 0.5 PI)))

	       ;calc curve centre point
	    (setq curvecen (polar p1 raybearing (atof radius)))
	    (setq curvecenc (strcat (rtos (car curvecen) 2 9) "," (rtos (cadr curvecen) 2 9)))
							  

							 (if (= curverot "ccw") (command "arc" "c" curvecenc lp1c lp2c)(command "arc" "c" curvecenc lp2c lp1c))
							 (SETQ RMB (ENTLAST))
							  (SSADD RMB ENTSS)
							  (setq geolength (+ geolength 1))
							 ));p and if curve

	

					    (linereader);read line curve or end of coordinate geometery



       	));p and while </CoordGeom>					  

								  (setq ptlist (append ptlist (list lp2c)))

							  ;create polyline if plan feature is more than one object
							  (if (> geolength 1)(command "pedit" "m" entss "" "y" "j" "" ""))
							  ;if object is offset draw offset informaton
							  (if  (or (= (substr pclname 1 4) "Offs")(= (substr pclname 1 4) "OFFS"))(progn
										    (setq mp (list (/ (+ (car p1)(car p2)) 2)(/ (+ (cadr p1)(cadr p2))2 )))
										    (setq ang (angle p1 p2))
										    (if (and (> ang  (* 0.5 pi))(< ang (* 1.5 pi)))(setq ang (- ang pi)))
  (if (< ang 0)(setq ang (+ ang (* 2 pi))))
										    (setq off (atof (substr pcldesc 2 500)))
										    (if (> off (* th 5))(setq tpos mp
			    just "BC"))

					  (if (and (< off (* th 7))(>= (angle p1 p2) (* 0.5 pi))(<= (angle p1 p2)(* 1.5 pi)))(setq tpos p2
																	 just "BR"))
					  (if (and (< off (* th 7))(or(<= (angle p1 p2) (* 0.5 pi))(>= (angle p1 p2)(* 1.5 pi))))(setq tpos p2
																	 just "BL"))

										    (SETQ BDINFO (STRCAT "<PlanFeature name=\"Offset\" desc=\"" pcldesc "\">"))
 (SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 BDINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)
	(setvar "clayer" "Drafting")
	(COMMAND "TEXT" "J" JUST TPOS TH (ANGTOS ANG 1 4) (STRCASE pcldesc))
										    
	)
							    (progn ;else

							   
 (SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 pcldesc)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)
	
		 (setq mp1 (nth (- (/ (length ptlist) 2)1) ptlist))
		 (setq mp2 (nth  (/ (length ptlist) 2) ptlist))
 
		(setq ,pos1 (vl-string-position 44 mp1 0))
                 (setq east (atof (substr mp1 1 ,pos1)))
      		 (setq north (atof (substr mp1 (+ ,pos1 2) 50)))
					   (setq mp1 (list east north))
 
		(setq ,pos1 (vl-string-position 44 mp2 0))
                 (setq east (atof (substr mp2 1 ,pos1)))
      		 (setq north (atof (substr mp2 (+ ,pos1 2) 50)))
					   (setq mp2 (list east north))
 
		 (setq mp (list (/ (+ (car mp1)(car mP2)) 2) (/ (+ (cadr mp1)(cadr mp2)) 2)))
		 (setq mprot (angle mp1 mp2))
		 (setq mprot90 (- mprot (* 0.5 pi)))
  		 (SETQ 1POS (POLAR mp mprot90 (* TH 2.5)))
                 (IF (AND (> mprot  (* 0.5 pi)) (< mprot (* 1.5 pi)))(setq mprot (+ mprot pi))) ;if text is upsidedown reverse rotation
 (if (AND (/= pcldesc "Wall")(/= pcldesc "Fence")(/= pcldesc "Building")(/= pcldesc "Kerb"))(progn ;only label if detailed description
											      
                 (setvar "clayer" "Drafting")
		 (COMMAND "TEXT" "J" "MC" 1pos TH (ANGTOS mprot 1 4) (strcase pcldesc))
		 (setvar "clayer" prevlayer)
		 ))

 );else


							    );p&if is an offset
       
            
       				
					    (linereader);read </PlanFeature>
      
					    (linereader);read next feature or end of features
       

							       
       
   ));p and while not </PlanFeatures>
	
));if plan features
  ));if plan features exist
;---------------------------------------------------------End if PLAN FEATURES

;12.--------------------------------------------------------SURVEY HEADER---------------------------------------

   (close xmlfile)
   (setq xmlfile (open xmlfilen "r"))
(linereader)

  ;linefeed to planfeatures
 (while (= (vl-string-search "<Survey" linetext) nil) ( progn
 (linereader)
))
 
;Else -ie no plan feautres and is survey
  ;(progn
  
  (linereader);read (Survey Header
  

    (if (/= (setq stringpos (vl-string-search "name" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 6)))(setq shname (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5)))))(setq shname nil))
   (if (/= (setq stringpos (vl-string-search "jurisdiction" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 14)))(setq shjur (substr linetext (+ stringpos 15) (-(- wwpos 1)(+ stringpos 13)))))(setq shjur nil))
   (if (/= (setq stringpos (vl-string-search "desc" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 6)))(setq shdesc (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5))))
)(setq shdesc nil))
   (if (/= (setq stringpos (vl-string-search "surveyorFirm" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 14)))(setq shfirm (substr linetext (+ stringpos 15) (-(- wwpos 1)(+ stringpos 13)))))(setq shfirm nil))
   (if (/= (setq stringpos (vl-string-search "surveyorReference" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 19)))(setq shref (substr linetext (+ stringpos 20) (-(- wwpos 1)(+ stringpos 18)))))(setq shref nil))
  (if (/= (setq stringpos (vl-string-search "surveyFormat" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 14)))(setq shformat (substr linetext (+ stringpos 15) (-(- wwpos 1)(+ stringpos 13)))))(setq shformat nil))
  (if (/= (setq stringpos (vl-string-search "type" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 6)))(setq shtype (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5)))))(setq shtype nil))

  (linereader);read first header line
  (setq shpurpose nil)
  (setq shdos nil
	shdol nil
	shdor nil
	shdoi nil
	shpu nil
	shpln ""
	shsurveyor nil
	shpurpose nil
	shlocality nil
	shlga nil
	shparish nil
	shcounty nil
	shsurveyregion nil
	shterrain nil
	subnum nil
	);reset all variable variables
	 
  (while (= (vl-string-search "</SurveyHeader>" linetext ) nil)( progn
;dates-----------------------------------
	  (if (and (/= (vl-string-search "<AdministrativeDate" linetext ) nil)(/= (vl-string-search "adminDateType=\"Date Of Survey\"" linetext ) nil))
	    (progn
	    (setq stringpos (vl-string-search "adminDate=" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 11)))
	    (setq shdos (substr linetext (+ stringpos 12) (-(- wwpos 1)(+ stringpos 10))))
	    ))
	  	  (if (and (/= (vl-string-search "<AdministrativeDate" linetext ) nil)(/= (vl-string-search "adminDateType=\"Date Of Compilation\"" linetext ) nil))
	    (progn
	    (setq stringpos (vl-string-search "adminDate=" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 11)))
	    (setq shdos (substr linetext (+ stringpos 12) (-(- wwpos 1)(+ stringpos 10))))
	    ))
	  (if (and (/= (vl-string-search "<AdministrativeDate" linetext ) nil)(/= (vl-string-search "adminDateType=\"Lodgement Date\"" linetext ) nil))
	    (progn
	    	    (setq stringpos (vl-string-search "adminDate=" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 11)))
	    (setq shdol (substr linetext (+ stringpos 12) (-(- wwpos 1)(+ stringpos 10))))
	    ))
	  (if (and (/= (vl-string-search "<AdministrativeDate" linetext ) nil)(/= (vl-string-search "adminDateType=\"Registration Date\"" linetext ) nil))
	    (progn
	    (setq stringpos (vl-string-search "adminDate=" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 11)))
	    (setq shdor (substr linetext (+ stringpos 12) (-(- wwpos 1)(+ stringpos 10))))
	    ))
	  (if (and (/= (vl-string-search "<AdministrativeDate" linetext ) nil)(/= (vl-string-search "adminDateType=\"Image Date\"" linetext ) nil))
	    (progn
	    (setq stringpos (vl-string-search "adminDate=" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 11)))
	    (setq shdoi (substr linetext (+ stringpos 12) (-(- wwpos 1)(+ stringpos 10))))
	    ))
	  ;personel-------------------------------
	   (if (/= (vl-string-search "<Personnel" linetext ) nil)
	    (progn
	    (setq stringpos (vl-string-search "name" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 6)))
	    (setq shsurveyor (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5))))
	    ))
	  ;Annotation------------@@@@@other annotation types need to be added later
	  (if (and (/= (vl-string-search "<Annotation" linetext ) nil)(/= (vl-string-search "type=\"Plans Used\"" linetext ) nil))
	    (progn
	    (setq stringpos (vl-string-search "name" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 6)))
	    (setq shpuname (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5))))
	    (setq stringpos (vl-string-search "desc" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 6)))
	    (setq shpu (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5))))
	    (setq shpu2 (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5))))
            ))
	  (if (and (/= (vl-string-search "<Annotation" linetext ) nil)(/= (vl-string-search "type=\"Parcel Note\"" linetext ) nil))
	    (progn
	    (setq stringpos (vl-string-search "name" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 6)))
	    (setq shpnname (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5))))
	    (setq stringpos (vl-string-search "desc" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 6)))
	    (setq shpcln (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5))))
	    ))
	   (if (and (/= (vl-string-search "<Annotation" linetext ) nil)(/= (vl-string-search "type=\"Plan Note\"" linetext ) nil))
	    (progn
	    (setq stringpos (vl-string-search "name" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 6)))
	    (setq shpnname (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5))))
	    (setq stringpos (vl-string-search "desc" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 6)))
	    (if (/= shpln "")(setq linefeed(chr 10))(setq linefeed ""))
	    (setq shpln (strcat shpln linefeed linefeed (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5)))))
	    ))
	   (if (and (/= (vl-string-search "<Annotation" linetext ) nil)(/= (vl-string-search "type=\"Subdivision Number\"" linetext ) nil))
	    (progn
	    (setq stringpos (vl-string-search "name" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 6)))
	    (setq subnumname (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5))))
	    (setq stringpos (vl-string-search "desc" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 6)))
	    (setq subnum (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5))))
	    ))
	  (if (and (/= (vl-string-search "<Annotation" linetext ) nil)(/= (vl-string-search "type=\"Direction Of Flow Non Tidal\"" linetext ) nil))
	    (progn
	      (setvar "clayer" "Adjoining Boundary")
	    (setq stringpos (vl-string-search "name" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 6)))
	    (setq faname (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5))))
	    (setq stringpos (vl-string-search "type" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 6)))
	    (setq fatype (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5))))
	    (setq stringpos (vl-string-search "desc" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 6)))
	    (setq facg (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5))))

	     (setq ,pos1 (vl-string-position 44 facg 0))
                 (setq fap1  (substr facg 1 ,pos1))
      		 (setq fap2  (substr facg (+ ,pos1 2) 50))
	      (if (= (substr fap2 1 1) " ")(setq fap2 (substr fap2 2 50)))
	      (setq testlist (strcat fap1 "-" fap2))
	      (if (/= (setq remlist (member testlist irlinetestlist)) nil)(progn
									    (setq fap (list (nth 1 remlist)(nth 2 remlist)))
									    (setq far (nth 3 remlist))
									    (command "insert" "DFANT" fap th "" (angtos far))
									    
		
									    
	    (setq pos1 (vl-position fap1 cgpointlist))
            (setq fap1c (nth (+ pos1 1) cgpointlist))
	    (setq pos2 (vl-position fap2 cgpointlist))
            (setq fap2c  (nth (+ pos2 1) cgpointlist))

									    ;record fap coords
	(SETQ BDINFO (STRCAT fap1c "!" fap2c))
(SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 BDINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)



									    ));p&if points are ends of a irregualr line
	    
	    	     
	    ));p&if annot DFANT
	  (if (and (/= (vl-string-search "<Annotation" linetext ) nil)(/= (vl-string-search "type=\"Direction Of Flow Tidal\"" linetext ) nil))
	    (progn
	      (setvar "clayer" "Adjoining Boundary")
	    (setq stringpos (vl-string-search "name" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 6)))
	    (setq faname (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5))))
	    (setq stringpos (vl-string-search "type" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 6)))
	    (setq fatype (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5))))
	    (setq stringpos (vl-string-search "desc" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 6)))
	    (setq facg (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5))))

	     (setq ,pos1 (vl-string-position 44 facg 0))
                 (setq fap1  (substr facg 1 ,pos1))
      		 (setq fap2  (substr facg (+ ,pos1 2) 50))
	      (if (= (substr fap2 1 1) " ")(setq fap2 (substr fap2 2 50)))
	      (setq testlist (strcat fap1 "-" fap2))
	      (if (/= (setq remlist (member testlist irlinetestlist)) nil)(progn
									    (setq fap (list (nth 1 remlist)(nth 2 remlist)))
									    (setq far (nth 3 remlist))
									    (command "insert" "DFAT" fap th "" (angtos far))
									    
		
									    
	    (setq pos1 (vl-position fap1 cgpointlist))
            (setq fap1c (nth (+ pos1 1) cgpointlist))
	    (setq pos2 (vl-position fap2 cgpointlist))
            (setq fap2c (nth (+ pos2 1) cgpointlist))

									    ;record fap coords
	(SETQ BDINFO (STRCAT fap1c "!" fap2c))
(SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 BDINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)



									    ));p&if points are ends of a irregualr line
	    
	    	     
	    ));p&if annot DFANT



	   (if (and (/= (vl-string-search "<Annotation" linetext ) nil)(/= (vl-string-search "type=\"Vinculum\"" linetext ) nil))
	    (progn
	      (setvar "clayer" "Drafting")
	    (setq stringpos (vl-string-search "name" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 6)))
	    (setq faname (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5))))
	    (setq stringpos (vl-string-search "type" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 6)))
	    (setq fatype (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5))))
	    (setq stringpos (vl-string-search "desc" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 6)))
	    (setq facg (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5))))

	     (setq ,pos1 (vl-string-position 44 facg 0))
                 (setq fap1  (substr facg 1 ,pos1))
      		 (setq fap2  (substr facg (+ ,pos1 2) 50))
	    (setq pos1 (vl-position fap1 cgpointlist))
            (setq fap1c (nth (+ pos1 1) cgpointlist))
	    (setq pos2 (vl-position fap2 cgpointlist))
            (setq fap2c (nth (+ pos2 1) cgpointlist))
	      (setq code (nth 3 remainlist))
	    
	     (setq ,pos1 (vl-string-position 44 fap1c 0))
                 (setq fap1ce (atof (substr fap1c 1 ,pos1)))
      		 (setq fap1cn (atof (substr fap1c (+ ,pos1 2) 50)))
	    (setq fap1l (list fap1ce fap1cn))

	    (setq ,pos1 (vl-string-position 44 fap2c 0))
                 (setq fap2ce (atof (substr fap2c 1 ,pos1)))
      		 (setq fap2cn (atof (substr fap2c (+ ,pos1 2) 50)))
	    (setq fap2l (list fap2ce fap2cn))
	      (setq fapmp (list (/ (+ fap1ce fap2ce) 2)(/ (+ fap1cn fap2cn)2 )))

	    (command "insert" "VINC" fapmp (rtos (/(/  (DISTANCE fap1l fap2l) 2  )0.0018875) 2 3) (angtos (+ (angle fap1l fap2l) (* 0.5 pi))))

	      (SETQ BDINFO code);assign level to vinc
(SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 BDINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)
	    ))

	  
	  ;Purpose-------------------- note mulitples are joined together with commas
	  (if (/= (vl-string-search "<PurposeOfSurvey" linetext ) nil)
	    (progn
	      
	    (setq stringpos (vl-string-search "name" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 6)))
	    (if (= shpurpose nil)
	    (setq shpurpose (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5))))
	     (setq shpurpose (strcat  (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5)))"," shpurpose))
	      )
	    	    ))
	   ;Administrative area
	  (if (and (/= (vl-string-search "<AdministrativeArea" linetext ) nil)(/= (vl-string-search "adminAreaType=\"Locality\"" linetext ) nil))
	    (progn
	    (setq stringpos (vl-string-search "adminAreaName" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 15)))
	    (if (= shlocality nil)
	    (setq shlocality (substr linetext (+ stringpos 16) (-(- wwpos 1)(+ stringpos 14))))
	      (setq shlocality (strcat shlocality "/" (substr linetext (+ stringpos 16) (-(- wwpos 1)(+ stringpos 14)))))
	      )		    
	    ))
	  (if (and (/= (vl-string-search "<AdministrativeArea" linetext ) nil)(/= (vl-string-search "adminAreaType=\"Local Government Area\"" linetext ) nil))
	    (progn
	    (setq stringpos (vl-string-search "adminAreaName" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 15)))
	     (if (= shlga nil)
	    (setq shlga (substr linetext (+ stringpos 16) (-(- wwpos 1)(+ stringpos 14))))
	       (setq shlga (strcat shlga "/" (substr linetext (+ stringpos 16) (-(- wwpos 1)(+ stringpos 14)))))
	       )	    
	    ))
	  (if (and (/= (vl-string-search "<AdministrativeArea" linetext ) nil)(/= (vl-string-search "adminAreaType=\"Parish\"" linetext ) nil))
	    (progn
	    (setq stringpos (vl-string-search "adminAreaName" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 15)))
	    (if (= shparish nil)
	    (setq shparish (substr linetext (+ stringpos 16) (-(- wwpos 1)(+ stringpos 14))))
	      (setq shparish (strcat shparish "/" (substr linetext (+ stringpos 16) (-(- wwpos 1)(+ stringpos 14)))))
	      )
	    ))
	  (if (and (/= (vl-string-search "<AdministrativeArea" linetext ) nil)(/= (vl-string-search "adminAreaType=\"County\"" linetext ) nil))
	    (progn
	    (setq stringpos (vl-string-search "adminAreaName" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 15)))
	    (if (= shcounty nil)
	    (setq shcounty (substr linetext (+ stringpos 16) (-(- wwpos 1)(+ stringpos 14))))
	      (setq shcounty (strcat shcounty "/" (substr linetext (+ stringpos 16) (-(- wwpos 1)(+ stringpos 14)))))
	      )
	    ))
	  (if (and (/= (vl-string-search "<AdministrativeArea" linetext ) nil)(/= (vl-string-search "adminAreaType=\"Survey Region\"" linetext ) nil))
	    (progn
	    (setq stringpos (vl-string-search "adminAreaName" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 15)))
	    (setq shsurveyregion (substr linetext (+ stringpos 16) (-(- wwpos 1)(+ stringpos 14))))
	    ))
	  	  (if (and (/= (vl-string-search "<AdministrativeArea" linetext ) nil)(/= (vl-string-search "adminAreaType=\"Terrain\"" linetext ) nil))
	    (progn
	    (setq stringpos (vl-string-search "adminAreaName" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 15)))
	    (setq shterrain (substr linetext (+ stringpos 16) (-(- wwpos 1)(+ stringpos 14))))
	    ))

	   (linereader)
	  
	  					    
  ));p & while not </surveyheader>

  ;check results
  (if (= shname nil)(setq shname ""))
  (if (= shlga nil)(setq shlga ""))
  (if (= shlocality nil)(setq shlocality ""))
  (if (= shparish nil)(setq shparish ""))
  (if (= shcounty nil)(setq shcounty ""))
  (if (= shsurveyor nil)(setq shsurveyor ""))
  (if (= shfirm nil)(setq shfirm ""))
  (setq &pos 0)
	      (while (/=  (setq &pos (vl-string-search "&amp;" shfirm &pos )) nil) (setq shfirm (vl-string-subst "&" "&amp;"  shfirm &pos)
										      &pos (+ &pos 1)))
  (setq quotpos 0)
	(while (/=  (setq quotpos (vl-string-search "&quot;" shfirm quotpos )) nil) (setq shfirm (vl-string-subst "\"" "&quot;"  shfirm 	quotpos)
										      quotpos (+ quotpos 1)))
					      (setq apos 0)
	(while (/=  (setq apos (vl-string-search "&apos;" shfirm apos )) nil) (setq shfirm (vl-string-subst "'" "&apos;"  shfirm apos)
										      apos (+ apos 1)))
   (setq crlfpos 0)
	   (while (/=  (setq crlfpos (vl-string-search "&#xA;" shfirm crlfpos )) nil) (setq shfirm (vl-string-subst "\P" "&#xA;"  shfirm crlfpos)
										      crlfpos (+ crlfpos 2)))				 
  (if (= shdos nil)(setq shdos ""))
  (if (= shsurveyregion nil)(setq shsurveyregion ""))
  (if (= shterrain nil)(setq shterrain ""))
  (if (= shref nil)(setq shref ""))
  (if (= shdesc nil)(setq shdesc "none"))
    (setq &pos 0)
  	      (while (/=  (setq &pos (vl-string-search "&amp;" shdesc &pos )) nil) (setq shdesc (vl-string-subst "&" "&amp;"  shdesc &pos)
											 
   										      &pos (+ &pos 1)))
  (setq crlfpos 0)
	   (while (/=  (setq crlfpos (vl-string-search "&#xA;" shdesc crlfpos )) nil) (setq shdesc (vl-string-subst "\P" "&#xA;"  shdesc crlfpos)
										      crlfpos (+ crlfpos 2)))	
  (if (= shpu nil)(setq shpu "none"))
  (setq crlfpos 0)
	   (while (/=  (setq crlfpos (vl-string-search "&#xA;" shpu crlfpos )) nil) (setq shpu (vl-string-subst "\\P" "&#xA;"  shpu crlfpos)
										      crlfpos (+ crlfpos 2)))	
    (if (= shpurpose nil)(setq shpurpose ""))
  (if (= shdor nil)(setq shdor ""))
  (if (= shdos nil)(setq shdos ""))
  (if (= shtype nil)(setq shtype ""))
  (if (= shjur nil)(setq shjur ""))
  (if (= shformat nil)(setq shformat ""))
  (if (/= shformat "Strata Schemes" )(setq shname (strcat "DP" shname)))
   (if (= shformat "Strata Schemes")(setq shname (strcat "SP" shname )))
  (if (= shpln "")(setq shpln " "))

  (setq &pos 0)
  	      (while (/=  (setq &pos (vl-string-search "&amp;" shpln &pos )) nil) (setq shpln (vl-string-subst "&" "&amp;"  shpln &pos)
   										      &pos (+ &pos 1)))
  (setq quotpos 0)
	(while (/=  (setq quotpos (vl-string-search "&quot;" shpln quotpos )) nil) (setq shpln (vl-string-subst "\"" "&quot;"  shpln 	quotpos)
										      quotpos (+ quotpos 1)))
					      (setq apos 0)
	(while (/=  (setq apos (vl-string-search "&apos;" shpln apos )) nil) (setq shpln (vl-string-subst "'" "&apos;"  shpln apos)
										      apos (+ apos 1)))
  (setq crlfpos 0)
	   (while (/=  (setq crlfpos (vl-string-search "&#xA;" shpln crlfpos )) nil) (setq shpln (vl-string-subst "\\P" "&#xA;"  shpln crlfpos)
										      crlfpos (+ crlfpos 2)))	
  
  
  (if (= subnum nil)(setq subnum ""))
  ;@@@@@date of image and londgement not used, couldnt find it on the exisiting plans.

  (setq tbinsertpoint (list (+ maxeast 10) minnorth))

    (if (/= shdor "")(progn  
	    ;rearrage shdor to dd.mm.yyyy format for text output
  (setq minuspos1 (vl-string-position 45 shdor 0))
  (setq minuspos2 (vl-string-position 45 shdor (+ minuspos1 1)))
  (if  (= minuspos1 4)(progn;rearrage date to year last
				       (setq year  (substr shdor 1 minuspos1))
				       (if (= (strlen year) 1) (setq year (strcat "0" year)));single digit days
				       (setq month (substr shdor (+ minuspos1 2) (- (- minuspos2 minuspos1) 1)))
				       (if (= (strlen month) 1) (setq month (strcat "0" month)));single digit days
				       (setq day  (substr shdor (+ minuspos2 2) 50))
				       (setq shdor (strcat day "-" month "-" year))
				       ));p&if
  ));if dor not ""

  (if (/= shdos "")(progn 
  	    ;rearrage shdos to dd.mm.yyyy format for text output
  (setq minuspos1 (vl-string-position 45 shdos 0))
  (setq minuspos2 (vl-string-position 45 shdos (+ minuspos1 1)))
  (if  (= minuspos1 4)(progn;rearrage date to year last
				       (setq year  (substr shdos 1 minuspos1))
				       (if (= (strlen year) 1) (setq year (strcat "0" year)));single digit days
				       (setq month (substr shdos (+ minuspos1 2) (- (- minuspos2 minuspos1) 1)))
				       (if (= (strlen month) 1) (setq month (strcat "0" month)));single digit days
				       (setq day  (substr shdos (+ minuspos2 2) 50))
				       (setq shdos (strcat day "-" month "-" year))
				       ));p&if
  ));if dos not ""

  
  
  (SETVAR "CLAYER"  "Admin Sheet" )
  ;insert titleblock
;changed for BricsCAD
  (if (/= shformat "Strata Schemes") 
  (COMMAND "._INSERT" "PLANFORM6" "_S" "1" tbinsertpoint "0" shname shlga shlocality shparish shcounty shsurveyor shfirm shdos shsurveyregion shterrain shref shdesc "" shpu "" shpurpose shdor shtype shjur shformat  shpln "" datum hdatum vdatum zone subnum)
  )
  (if (= shformat "Strata Schemes")
  (COMMAND "._INSERT" "PLANFORM3" "_S" "1" tbinsertpoint "0" shname shlga shlocality shparish shcounty shsurveyor shfirm shdos  shref shdesc "" shpu "" shpurpose shdor shtype shjur shformat  shpln "" datum hdatum vdatum zone subnum)
)
    
  ;instrument stations
;  (setq linetext (read-line xmlfile))
;(while (= (vl-string-search "<ObservationGroup" linetext ) nil)( progn
;		   (if (/= (setq stringpos (vl-string-search "id" linetext )) nil)(progn
;(setq wwpos (vl-string-position 34 linetext (+ stringpos 4)))(setq isid (substr linetext (+ stringpos 5) (-(- wwpos 1)(+ stringpos 3)))))(setq isid nil))
		   ;(setq linetext (read-line xmlfile))
		   ;(if (/= (setq stringpos (vl-string-search "pntRef" linetext )) nil)(progn
;(setq wwpos (vl-string-position 34 linetext (+ stringpos 8)))(setq iscgp (substr linetext (+ stringpos 9) (-(- wwpos 1)(+ stringpos 7)))))(setq iscgp nil))
;		   (setq isid (strcat "IS-" isid));add "is-" to isid just in case someone is stupid enough to use the same id
;		   (setq islist (append islist (list isid)(list iscgp)))
;
;		   (setq linetext (read-line xmlfile));read end of is
;		   (setq linetext (read-line xmlfile));read next line
		   
;));p&w not observation group



  ;13. OBERSVATIONS


  ;READ OBSERVATIONS TO DISCOVER DOUBLE REFERENCES


   (close xmlfile)
   (setq xmlfile (open xmlfilen "r"))
(linereader)

  ;linefeed to obs
 (while (= (vl-string-search "<ObservationGroup" linetext) nil) ( progn
 (linereader)
))

  (linereader)
  
  (setq SREF (LIST))
  (SETQ DREF (LIST))
  
(while (= (vl-string-search "</ObservationGroup>" linetext ) nil)( progn
								  
		;line observation--------------------------------------------------------------------------------------------------
		(if (/= (vl-string-search "<ReducedObservation" linetext ) nil)
	    (progn
	      	      
	    (setq stringpos (vl-string-search "setupID" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 9)))
            (setq setupids (strcat "IS-" (substr linetext (+ stringpos 10) (-(- wwpos 1)(+ stringpos 8)))))
	    (setq pos1 (vl-position setupids islist))
	    (setq setupid (nth (+ pos1 1) islist))

	    (setq stringpos (vl-string-search "targetSetupID" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 15)))
            (setq targetid (strcat "IS-" (substr linetext (+ stringpos 16) (-(- wwpos 1)(+ stringpos 14)))))
	    (setq pos1 (vl-position targetid islist))
	    (setq targetid (nth (+ pos1 1) islist))

	    (if (/= (setq stringpos (vl-string-search "azimuth" linetext )) nil)(progn
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 9)))
            (setq bearing (substr linetext (+ stringpos 10) (-(- wwpos 1)(+ stringpos 8))))
	    (setq xbearing bearing)
	    )(setq bearing ""
		   xbearing ""));azimuth may be missing eg compile or strata

	    (if (/= (setq stringpos (vl-string-search "horizDistance" linetext )) nil)(progn
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 15)))
            (setq dist (substr linetext (+ stringpos 16) (-(- wwpos 1)(+ stringpos 14)))))
		    (setq dist "")
	      );dist may be missing eg trig obs

	       (if (/= (setq stringpos (vl-string-search "<FieldNote>" linetext )) nil)(progn
											   
(if (setq wwpos (vl-string-position 34 linetext (+ stringpos 12)))
  (progn;if field not contains ""s
    (setq comment (substr linetext (+ stringpos 13) (-(- wwpos 1)(+ stringpos 11))))
    )
  (progn; else use the < to get other end of field note
    (setq <pos (vl-string-position 60 linetext (+ stringpos 11)))
    (setq comment (substr linetext (+ stringpos 12) (-(- <pos 1)(+ stringpos 10))))
    )
  )
)
  (setq comment ""))
	    

	    (setq pos1 (vl-position setupid cgpointlist))
            (setq lp1c (nth (+ pos1 1) cgpointlist))
	    (setq p1type (nth (+ pos1 2) cgpointlist))
	    (setq pos2 (vl-position targetid cgpointlist))
            (setq lp2c (nth (+ pos2 1) cgpointlist))
	    (setq p2type (nth (+ pos2 2) cgpointlist))

	    (if (= p1type "r")(progn
				(IF (/= (setq pos1 (vl-position (STRCAT bearing "-" targetid) SREF)) nil)
				  (progn
				    (setq 1dist (nth (+ pos1 1) SREF))
				    (setq 1setupid (nth (+ pos1 2) SREF))
				    (setq 1targetid (nth (+ pos1 3) SREF))
				    (setq 1comment (nth (+ pos1 4) SREF))
				    (setq ddist (list (strcat 1dist 1comment "&" dist comment))) 
				    (SETQ DREF (APPEND DREF (LIST (strcat setupid "-" targetid)) ddist (LIST (strcat 1setupid "-" 1targetid)) ddist))
				    )
				  )
				
				(SETQ SREF (APPEND SREF (LIST (STRCAT bearing "-" TARGETID)) (LIST dist)  (LIST setupid) (LIST targetid)  (LIST comment)))
				)
	      );IF "r"

	    
	    ));if line
		(linereader)
	    ));if not obs group



  ;CLOSE FILE AND READ TO OBSERVATION GROUP AGAIN

  (close xmlfile)
   (setq xmlfile (open xmlfilen "r"))

   (while (= (vl-string-search "<ObservationGroup" linetext) nil) ( progn
 (linereader)
))


  

  (linereader)
  
(while (= (vl-string-search "</ObservationGroup>" linetext ) nil)( progn

								   (setq rmline 0);reset trigger for rmline with monument at other end.

		;line observation--------------------------------------------------------------------------------------------------
		(if (/= (vl-string-search "<ReducedObservation" linetext ) nil)
	    (progn
	      
	      
	    (setq stringpos (vl-string-search "desc" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 6)))
            (setq rolayer (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5))))
	    ;DSM height difference
	    (if (= rolayer "HeightDifference")(setq rolayer "Height Difference"))
	    (if (= rolayer "IrregularLine") (progn
					      (setq rolayer "Irregular Right Lines")
					      (princ "\nNon-schema use of desc enumertion - Irrregularline, please report to LRS")
					      ))
	    (if (= rolayer "natural boundary") (progn
					      (setq rolayer "Irregular Right Lines")
					      ))

	    (setq stringpos (vl-string-search "setupID" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 9)))
            (setq setupids (strcat "IS-" (substr linetext (+ stringpos 10) (-(- wwpos 1)(+ stringpos 8)))))
	    (setq pos1 (vl-position setupids islist))
	    (setq setupid (nth (+ pos1 1) islist))

	    
	    (setq stringpos (vl-string-search "targetSetupID" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 15)))
            (setq targetid (strcat "IS-" (substr linetext (+ stringpos 16) (-(- wwpos 1)(+ stringpos 14)))))
	    (setq pos1 (vl-position targetid islist))
	    (setq targetid (nth (+ pos1 1) islist))
	    

	    (if (/= (setq stringpos (vl-string-search "azimuth=" linetext )) nil)(progn
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 9)))
            (setq bearing (substr linetext (+ stringpos 10) (-(- wwpos 1)(+ stringpos 8))))
	    (setq xbearing bearing)
	    )(setq bearing ""
		   xbearing ""));azimuth may be missing eg compile or strata
	    
	    (if (/= (setq stringpos (vl-string-search "horizDistance" linetext ))nil)(progn
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 15)))
            (setq dist (substr linetext (+ stringpos 16) (-(- wwpos 1)(+ stringpos 14)))))
		    (setq dist "")
	      );dist may be missing eg trig obs

	    (if (/= (setq stringpos (vl-string-search "distanceType=" linetext ))nil)(progn
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 14)))
            (setq distancetype (strcat " distanceType=\"" (substr linetext (+ stringpos 15) (-(- wwpos 1)(+ stringpos 13))) "\" ")))(setq distancetype ""))

	    (if (/= (setq stringpos (vl-string-search "azimuthType=" linetext ))nil)(progn
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 13)))
            (setq azimuthtype (strcat " azimuthType=\"" (substr linetext (+ stringpos 14) (-(- wwpos 1)(+ stringpos 12))) "\" ")))(setq azimuthtype ""))

	    (if (/= (setq stringpos (vl-string-search "distanceAccClass=" linetext ))nil)(progn
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 18)))
            (setq distanceAccClass (strcat " distanceAccClass=\"" (substr linetext (+ stringpos 19) (-(- wwpos 1)(+ stringpos 17))) "\" ")))(setq distanceAccClass ""))

	    (if (/= (setq stringpos (vl-string-search "adoptedDistanceSurvey=" linetext ))nil)(progn
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 23)))
            (setq adoptedDistanceSurvey (strcat " adoptedDistanceSurvey=\"" (substr linetext (+ stringpos 24) (-(- wwpos 1)(+ stringpos 22))) "\" ")))(setq adoptedDistanceSurvey ""))

	    (if (/= (setq stringpos (vl-string-search "distanceAdoptionFactor" linetext )) nil)(progn
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 24)))
            (setq daf (substr linetext (+ stringpos 25) (-(- wwpos 1)(+ stringpos 23))))
	    (if (/= daf "")(setq daf1 daf)))(setq daf ""))

	    ;vertical observations
	    (if (/= (setq stringpos (vl-string-search "vertDistance=" linetext )) nil)(progn
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 14)))
            (setq vertdistance (substr linetext (+ stringpos 15) (-(- wwpos 1)(+ stringpos 13)))))(setq vertdistance ""))

	    (if (/= (setq stringpos (vl-string-search "vertDistance =" linetext )) nil)(progn
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 15)))
            (setq vertdistanceDSM (substr linetext (+ stringpos 16) (-(- wwpos 1)(+ stringpos 14)))))(setq vertdistanceDSM ""))
	    (if (and (= vertdistance "")(/= vertdistanceDSM ""))(setq vertdistance vertdistanceDSM))

	    
	    
	    (if (/= (setq stringpos (vl-string-search "MSLDistance=" linetext )) nil)(progn
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 13)))
            (setq MSLdistance  (substr linetext (+ stringpos 14) (-(- wwpos 1)(+ stringpos 12)))))(setq MSLdistance ""))


	       (if (/= vertDistance "")
	      (progn
	(setq spm (cadr (member setupid drawpmlist)))
	(setq tpm (cadr (member targetid drawpmlist)))
	(setq vertobslist (append vertobslist (list spm tpm vertdistance msldistance)))
	))

	     


	    

	    (if (/= (setq stringpos (vl-string-search "<FieldNote>" linetext )) nil)(progn
											   

    (setq <pos (vl-string-position 60 linetext (+ stringpos 11)))
    (setq comment (substr linetext (+ stringpos 12) (-(- <pos 1)(+ stringpos 10))))
    )
  (setq comment ""))

	    	    ;case if fieldnote is linefed
	      (if (and (=  (vl-string-search "/>" linetext ) nil)(=  (vl-string-search "</ReducedObservation>" linetext ) nil))(progn
									     (linereader)
			(if (/= (setq stringpos (vl-string-search "<FieldNote>" linetext )) nil)(progn
												  
			(setq >pos (vl-string-position 62 linetext))
			
		 (while (= (setq <pos (vl-string-position 60 linetext (+ >pos 1))) nil)(progn
										(setq comment (strcat comment (substr linetext (+ >pos 2) ) " "))
										(linereader)
										(setq >pos -1)
										));while no <
		 (if (/= <pos 0)(setq comment (strcat comment (substr linetext (+ stringpos 12) (- <pos 11)))))
			));if fieldnote
         	 

										));p if no <


	    ;remove ""
	    (setq wwpos 0)
	      (while (/=  (setq wwpos (vl-string-search "\"" comment wwpos )) nil) (setq comment (vl-string-subst "" "\""  comment wwpos)))
										      
									     


	    

	

								

								
(setq &pos 0)
	      (while (/=  (setq &pos (vl-string-search "&amp;" comment &pos )) nil) (setq comment (vl-string-subst "&" "&amp;"  comment &pos)
										      &pos (+ &pos 1)))
	    (setq quotpos 0)
	(while (/=  (setq quotpos (vl-string-search "&quot;" comment quotpos )) nil) (setq comment (vl-string-subst "\"" "&quot;"  comment 	quotpos)
										      quotpos (+ quotpos 1)))
					      (setq apos 0)
	(while (/=  (setq apos (vl-string-search "&apos;" comment apos )) nil) (setq comment (vl-string-subst "'" "&apos;"  comment apos)
										      apos (+ apos 1)))
	    (setq apos 0)
	    	(while (/=  (setq apos (vl-string-search "&#176;" comment apos )) nil) (setq comment (vl-string-subst "�" "&#176;"  comment apos)
										      apos (+ apos 1)))
	    
	    

	    (setq pos1 (vl-position setupid cgpointlist))
            (setq lp1c (nth (+ pos1 1) cgpointlist))
	    (setq p1type (nth (+ pos1 2) cgpointlist))
	    (setq pos2 (vl-position targetid cgpointlist))
            (setq lp2c (nth (+ pos2 1) cgpointlist))
	    (setq p2type (nth (+ pos2 2) cgpointlist))
	    ;add reverse of line to arclist
	    (setq linelist (append linelist (list (strcat lp2c","lp1c "," rolayer))))
	    (setq linedrawn nil)

	    (if (and (or (= p1type "n")(= p2type "n"))(/= p1type "r"))(setq rolayer "Irregular Right Lines"))
	    
	    
	    (if (or (vl-position (strcat lp1c "," lp2c) finaleaselist) (vl-position (strcat lp2c "," lp1c) finaleaselist)) (setq rolayer "Easement"));check if line is a easement line

	    


	    ;dont label if a vertical distance obs
	    (if (and (= dist "")(= bearing ""))


	    	      (progn ;is a vert obs only

		(SETVAR "CLAYER"  rolayer )

		(setq eccount 0)
		(repeat (length errorcodelist)
		  (setq errorcode (nth eccount errorcodelist))
		  (if (and (vl-string-search errorcode (strcase comment ))(= (getvar "CECOLOR") "BYLAYER"))(setvar "CECOLOR" "30"))
		(setq eccount (+ eccount 1))
		  )



		
           (command "line" lp1c lp2c "")
		(if (/= (getvar "CECOLOR") "BYLAYER") (setvar "CECOLOR" "BYLAYER"))
		

		 (if (/= comment "")(setq ocomment (strcat "><FieldNote>\"" comment "\"</FieldNote></ReducedObservation>"))(setq ocomment "/>"))
		  (if (/= vertdistance "")(setq overtdist (strcat " vertDistance=\"" vertdistance "\" "))(setq overtdist ""))
  (if (/= MSLdistance "")(setq oMSLdist (strcat " MSLDistance=\"" MSLdistance "\" "))(setq oMSLdist ""))
		
(SETQ BDINFO (STRCAT overtdist oMSLdist ocomment))
		(SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 BDINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)

		)


	    (progn; else normal obs

	    

	       ;APPLY ALL CORRECTIONS AND EXTRACT INFORMATION FROM USER INPUT
(if (/= (vl-string-position 46 bearing 0) nil ) (PROGN
  (setq dotpt1 (vl-string-position 46 bearing 0))
  (setq deg  (substr bearing 1  dotpt1 ))
  (SETQ mins   (substr bearing (+ dotpt1 2) 2) )
  (if (= (strlen mins) 1)(setq mins (strcat  mins "0")));fix problem with truncating zeros on minutes and seconds
  (setq mins (strcat mins "'"))
  (setq sec  (substr bearing (+ dotpt1 4) 10))
  (if (= (strlen sec) 1) (setq sec (strcat sec "0")))

  
  (if (> (strlen sec) 2) (setq sec (strcat (substr sec 1 2) "." (substr sec 3 10))))
  (if (= (strlen sec) 0) (setq sec "") (setq sec (strcat sec (chr 34))))
  
  );P
	(progn
	  (setq deg bearing)
	  (setq mins "")
	  (setq sec "")
	  );p else
  
  );IF

      
(if (/= bearing "")(setq bearing (strcat  deg "d" mins sec)))
   (if (/= dist "")(setq dist (rtos (atof dist)2 3)));remove trailing zeros
	    
  (setq ldist (strcat dist ))

	 






	    
;DOUBLE RM ON POINT ONE

	    (if (and (setq pos1 (vl-position setupid rmlist))(SETQ pos2 (vl-position (strcat setupid "-" targetid) dref)))
	      (progn

		
		(setq ddist (nth (+ pos2 1) dref))																  
						    					    
(setq monline (nth (+ pos1 1) rmlist))

 (if (/= (setq stringpos (vl-string-search "type" monline )) nil)(progn
(setq stringpos (vl-string-search "type" monline ))(setq wwpos (vl-string-position 34 monline (+ stringpos 6)))(setq rmtype (substr monline (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5))))
(if (/= (setq stringpos (vl-string-search "&amp;" rmtype )) nil) (setq rmtype (vl-string-subst "&" "&amp;" rmtype)))
)(setq rmtype ""))
 (if (/= (setq stringpos (vl-string-search "state" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 7)))(setq rmstate (substr monline (+ stringpos 8) (-(- wwpos 1)(+ stringpos 6)))))(setq rmstate ""))
(if (/= (setq stringpos (vl-string-search "condition" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 11)))(setq rmcondition (substr monline (+ stringpos 12) (-(- wwpos 1)(+ stringpos 10)))))(setq rmcondition ""))
(if (/= (setq stringpos (vl-string-search "desc" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 6)))(setq rmcomment (substr monline (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5)))))(setq rmcomment ""))
(setq &pos 0)
	      (while (/=  (setq &pos (vl-string-search "&amp;" rmcomment &pos )) nil) (setq rmcomment (vl-string-subst "&" "&amp;"  rmcomment &pos)
										      &pos (+ &pos 1)))
(if (/= (setq stringpos (vl-string-search "originSurvey" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 14)))(setq rmrefdp (substr monline (+ stringpos 15) (-(- wwpos 1)(+ stringpos 13)))))(setq rmrefdp ""))

(if (= (vl-position (strcat setupid "-" xbearing "-"dist) reflist) nil)(progn
					  
 
 
(SETVAR "CLAYER"  "RM Connection" )

		(setq eccount 0)
		(repeat (length errorcodelist)
		  (setq errorcode (nth eccount errorcodelist))
		  (if (and (vl-string-search errorcode (strcase comment ))(= (getvar "CECOLOR") "BYLAYER"))(setvar "CECOLOR" "30"))
		(setq eccount (+ eccount 1))
		  )

  (command "line" lp1c lp2c "")
(setq linedrawn "1");tick line drawn
(if (/= xbearing "")(setq bearings (STRCAT "azimuth=\"" xbearing "\" "))(setq bearings ""))
(if (/= vertdistance "")(setq overtdist (strcat " vertDistance=\"" vertdistance "\" "))(setq overtdist ""))
(if (/= MSLdistance "")(setq oMSLdist (strcat " MSLDistance=\"" MSLdistance "\" "))(setq oMSLdist ""))
  
  
;Add observation data to line as XDATA
 (if (/= comment "")(setq ocomment (strcat "><FieldNote>\"" comment "\"</FieldNote></ReducedObservation>"))(setq ocomment "/>"))
(SETQ BDINFO (STRCAT bearings "horizDistance=\"" dist "\"" distanceType azimuthtype overtdist oMSLdist adoptedDistanceSurvey distanceAccClass ocomment))
(SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 BDINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)


  ;GET LAST LINE DATA
  (SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
   (setq p1 (CDR(ASSOC 10 sentlist)))
   (setq p2 (CDR(ASSOC 11 sentlist)))

(setq ldist ddist)

(if (= (vl-position (strcat setupid "-" targetid ) drawndref) nil)
  (progn
(lrm);DRAW DP REF INFO
	(if (/= (getvar "CECOLOR") "BYLAYER") (setvar "CECOLOR" "BYLAYER"))
  (setq drawndref (append drawndref (list (strcat setupid "-" targetid))))
)
  )

  (SETVAR "CLAYER"  "Monument")
  (COMMAND "POINT" p1)

  ;check for no values and replace with "none"
  ;check for no values and replace with "none"
     (if (/= rmrefdp "")(setq ormrefdp (strcat " originSurvey=\"" rmrefdp "\""))(setq ormrefdp ""))
  (if (/= rmcondition "")(setq ormcondition ( strcat " condition=\"" rmcondition "\""))(setq ormcondition ""))
  (if (/= rmtype "")(setq ormtype ( strcat "type=\"" rmtype "\" "))(setq ormtype ""))

    (if (/= rmcomment "")(setq rmcomments (strcat " desc=\"" rmcomment "\""))(setq rmcomments ""))
    (SETQ PTINFO (STRCAT ormtype "state=\""  rmstate "\""  ormrefdp  ormcondition rmcomments " />" ));Note comment for desc in xml added to distance entry seperated by a space
(SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 PTINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)


        
  ;DRAW RM BLOCK AND ADD RM POINT
  (SETVAR "CLAYER" "Drafting" )
  (COMMAND "._INSERT" "RM" "_S" TH lP2c "0");changed for BricsCAD
;  (SETQ RMB (ENTLAST))
;  (SETQ ENTSS (SSADD))
;  (SSADD RMB ENTSS)
;(COMMAND "DRAWORDER" ENTSS "" "FRONT")

(setq drawnrmlist (append drawnrmlist (list (strcat setupid "-" rmtype))));add to list of placed rm
(setq reflist (append reflist (list (strcat setupid"-"xbearing"-"dist))));create a secondary list in case someone used the same refernce point twice Mr Bill Currie! (DP1191367)

;tool to remove drawn rm (in case there are two marks on the same point (yes it happens i.e. gone & non peg corner mark)
(setq rmnth (vl-position setupid rmlist))
(setq usedrmlist (append usedrmlist (list setupid monline)))
(setq rmlist (remove_nth rmlist  rmnth ))
(setq rmlist (remove_nth rmlist  rmnth ))


(setq rmline 1);trigger for rmline with monument at cnr end not to draw.
  );p
  
    
    );p and if not in drawnrmlist

));p & if double RM





	    

	    ;if PM at either end of the line
	    (if (or (and (setq pos1 (vl-position setupid pmlist)) (= rolayer "Connection")(= p1type "c"))(and (setq pos1 (vl-position targetid pmlist)) (= rolayer "Connection")(= p2type "c")))(progn

(setq monline (nth (+ pos1 1) pmlist))

 (if (/= (setq stringpos (vl-string-search "type" monline )) nil)(progn
(setq stringpos (vl-string-search "type" monline ))(setq wwpos (vl-string-position 34 monline (+ stringpos 6)))(setq rmtype (substr monline (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5))))
(if (/= (setq stringpos (vl-string-search "&amp;" rmtype )) nil) (setq rmtype (vl-string-subst "&" "&amp;" rmtype)))
)(setq rmtype ""))
 (if (/= (setq stringpos (vl-string-search "state" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 7)))(setq rmstate (substr monline (+ stringpos 8) (-(- wwpos 1)(+ stringpos 6)))))(setq rmstate ""))
(if (/= (setq stringpos (vl-string-search "condition" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 11)))(setq rmcondition (substr monline (+ stringpos 12) (-(- wwpos 1)(+ stringpos 10)))))(setq rmcondition ""))
(if (/= (setq stringpos (vl-string-search "desc" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 6)))(setq rmcomment (substr monline (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5)))))(setq rmcomment ""))
(setq &pos 0)
	      (while (/=  (setq &pos (vl-string-search "&amp;" rmcomment &pos )) nil) (setq rmcomment (vl-string-subst "&" "&amp;"  rmcomment &pos)
										      &pos (+ &pos 1)))
(setq quotpos 0)
	(while (/=  (setq quotpos (vl-string-search "&quot;" rmcomment quotpos )) nil) (setq rmcomment (vl-string-subst "\"" "&quot;"  rmcomment 	quotpos)
										      quotpos (+ quotpos 1)))
					      (setq apos 0)
	(while (/=  (setq apos (vl-string-search "&apos;" rmcomment apos )) nil) (setq rmcomment (vl-string-subst "'" "&apos;"  rmcomment apos)
										      apos (+ apos 1)))

(if (/= (setq stringpos (vl-string-search "originSurvey" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 14)))(setq rmrefdp (substr monline (+ stringpos 15) (-(- wwpos 1)(+ stringpos 13)))))(setq rmrefdp ""))
   

      (SETVAR "CLAYER"  "PM Connection" )

(if (vl-position  (strcat lp1c ","lp2c "," rolayer) linelist)()
  (progn
    
    (setq eccount 0)
		(repeat (length errorcodelist)
		  (setq errorcode (nth eccount errorcodelist))
		  (if (and (vl-string-search errorcode (strcase comment ))(= (getvar "CECOLOR") "BYLAYER"))(setvar "CECOLOR" "30"))
		(setq eccount (+ eccount 1))
		  )
    
      (command "line" lp1c lp2c "")
    (setq linedrawn "1");tick line drawn

    
  ;GET LAST LINE DATA
  (SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
   (setq p1 (CDR(ASSOC 10 sentlist)))
   (setq p2 (CDR(ASSOC 11 sentlist)))

    (if (/= vertdistance "")(setq overtdist (strcat " vertDistance=\"" vertdistance "\" "))(setq overtdist ""))
(if (/= MSLdistance "")(setq oMSLdist (strcat " MSLDistance=\"" MSLdistance "\" "))(setq oMSLdist ""))
   
   
      
  (if (/= comment "")(setq ocomment (strcat "><FieldNote>\"" comment "\"</FieldNote></ReducedObservation>"))(setq ocomment "/>"))
(if (/= daf "")(setq daf (strcat " distanceAdoptionFactor=\"" daf "\"")))
(SETQ BDINFO (STRCAT "azimuth=\"" xbearing "\" horizDistance=\"" dist "\"" distanceType azimuthtype daf overtdist oMSLdist adoptedDistanceSurvey distanceAccClass ocomment))
(SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 BDINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)
    
 (if (/= (vl-position (strcat lp1c "," lp2c "," rolayer) linelist)nil)()(lba));else label line if not already labelled
     (if (/= (getvar "CECOLOR") "BYLAYER") (setvar "CECOLOR" "BYLAYER"))
  ))

;SPECIAL CASE WHERE PM IS A REFERENCE MARK

(IF (and (setq pos1 (vl-position setupid rmlist))(= (vl-position (strcat setupid "-" rmtype) drawnrmlist) nil)(or (= p2type "t")(= p2type "b")))(progn
					       (setq monline (nth (+ pos1 1) rmlist))
					       
					       
		 (if (/= (setq stringpos (vl-string-search "type" monline )) nil)(progn
(setq stringpos (vl-string-search "type" monline ))(setq wwpos (vl-string-position 34 monline (+ stringpos 6)))(setq rmtype (substr monline (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5))))
(if (/= (setq stringpos (vl-string-search "&amp;" rmtype )) nil) (setq rmtype (vl-string-subst "&" "&amp;" rmtype)))
)(setq rmtype ""))
 (if (/= (setq stringpos (vl-string-search "state" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 7)))(setq rmstate (substr monline (+ stringpos 8) (-(- wwpos 1)(+ stringpos 6)))))(setq rmstate ""))
(if (/= (setq stringpos (vl-string-search "condition" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 11)))(setq rmcondition (substr monline (+ stringpos 12) (-(- wwpos 1)(+ stringpos 10)))))(setq rmcondition ""))
(if (/= (setq stringpos (vl-string-search "desc" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 6)))(setq rmcomment (substr monline (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5)))))(setq rmcomment ""))
(setq &pos 0)
	      (while (/=  (setq &pos (vl-string-search "&amp;" rmcomment &pos )) nil) (setq rmcomment (vl-string-subst "&" "&amp;"  rmcomment &pos)
										      &pos (+ &pos 1)))
					       (setq quotpos 0)
	(while (/=  (setq quotpos (vl-string-search "&quot;" rmcomment quotpos )) nil) (setq rmcomment (vl-string-subst "\"" "&quot;"  rmcomment 	quotpos)
										      quotpos (+ quotpos 1)))
					      (setq apos 0)
	(while (/=  (setq apos (vl-string-search "&apos;" rmcomment apos )) nil) (setq rmcomment (vl-string-subst "'" "&apos;"  rmcomment apos)
										      apos (+ apos 1)))

(if (/= (setq stringpos (vl-string-search "originSurvey" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 14)))(setq rmrefdp (substr monline (+ stringpos 15) (-(- wwpos 1)(+ stringpos 13)))))(setq rmrefdp ""))


	(if (and (= rmcomment "used as reference mark")(<= (atof dist) 30))
	  (progn


											 (SETVAR "CLAYER"  "RM Connection" )
											(setq rolayer "RM Connecion")

;change layer of last line
 
	    ;(setq sentlist (subst (cons 8 "RM Connection")(assoc 8 sentlist) sentlist))
	    ;(entmod sentlist)
		 (SETQ ERASELINE (ENTLAST))
	    
	    (setq eccount 0)
		(repeat (length errorcodelist)
		  (setq errorcode (nth eccount errorcodelist))
		  (if (and (vl-string-search errorcode (strcase comment ))(= (getvar "CECOLOR") "BYLAYER"))(setvar "CECOLOR" "30"))
		(setq eccount (+ eccount 1))
		  )
	    
	     (command "line" lp1c lp2c "")
	    

(setq rmcomment "");delete comment for RM drafting	    
(lrm)
	    (if (/= (getvar "CECOLOR") "BYLAYER") (setvar "CECOLOR" "BYLAYER"))
(setq rmcomment "used as reference mark");remake comment for xdata
	    (COMMAND "ERASE" ERASELINE "")
	     ;DRAW RM BLOCK AND ADD RM POINT
  (SETVAR "CLAYER" "Drafting" )
  (COMMAND "._INSERT" "RM" "_S" TH lP2c "0");changed for BricsCAD
;  (SETQ RMB (ENTLAST))
;  (SETQ ENTSS (SSADD))
;  (SSADD RMB ENTSS)
;(COMMAND "DRAWORDER" ENTSS "" "FRONT")
											 
       											
  (SETVAR "CLAYER" "Monument" )
  (COMMAND "POINT" lp1c)

  ;check for no values and replace with "none"
    (if (/= rmrefdp "")(setq ormrefdp (strcat " originSurvey=\"" rmrefdp "\""))(setq ormrefdp ""))
  (if (/= rmcondition "")(setq ormcondition ( strcat " condition=\"" rmcondition "\""))(setq ormcondition ""))
  (if (/= rmtype "")(setq ormtype ( strcat "type=\"" rmtype "\" "))(setq ormtype ""))

    (if (/= rmcomment "")(setq rmcomments (strcat " desc=\"" rmcomment "\""))(setq rmcomments ""))
    (SETQ PTINFO (STRCAT ormtype "state=\""  rmstate "\"" ormrefdp  ormcondition rmcomments " />" ));Note comment for desc in xml added to distance entry seperated by a space
(SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 PTINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)

  
					       (setq drawnrmlist (append drawnrmlist (list (strcat setupid "-" rmtype))))
					       
					       
  
	   

	  ));if PM us used as reference point
					       );p PM is RM on point 1			     
					      
);if PM is RM on point 1			     


 

      );p

    );if pm connection





	    ;if PM being used as a reference mark post recipe V8.0
	    (if (and (setq pos1 (vl-position setupid pmlist)) (= rolayer "Reference")(= p1type "c"))
	      (progn

(setq monline (nth (+ pos1 1) pmlist))

 (if (/= (setq stringpos (vl-string-search "type" monline )) nil)(progn
(setq stringpos (vl-string-search "type" monline ))(setq wwpos (vl-string-position 34 monline (+ stringpos 6)))(setq rmtype (substr monline (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5))))
(if (/= (setq stringpos (vl-string-search "&amp;" rmtype )) nil) (setq rmtype (vl-string-subst "&" "&amp;" rmtype))))(setq rmtype ""))
 (if (/= (setq stringpos (vl-string-search "state" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 7)))(setq rmstate (substr monline (+ stringpos 8) (-(- wwpos 1)(+ stringpos 6)))))(setq rmstate ""))
(if (/= (setq stringpos (vl-string-search "condition" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 11)))(setq rmcondition (substr monline (+ stringpos 12) (-(- wwpos 1)(+ stringpos 10)))))(setq rmcondition ""))
(if (/= (setq stringpos (vl-string-search "desc" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 6)))(setq rmcomment (substr monline (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5)))))(setq rmcomment ""))
(setq &pos 0)
	      (while (/=  (setq &pos (vl-string-search "&amp;" rmcomment &pos )) nil) (setq rmcomment (vl-string-subst "&" "&amp;"  rmcomment &pos)
										      &pos (+ &pos 1)))
(setq quotpos 0)
	(while (/=  (setq quotpos (vl-string-search "&quot;" rmcomment quotpos )) nil) (setq rmcomment (vl-string-subst "\"" "&quot;"  rmcomment 	quotpos)
										      quotpos (+ quotpos 1)))
					      (setq apos 0)
	(while (/=  (setq apos (vl-string-search "&apos;" rmcomment apos )) nil) (setq rmcomment (vl-string-subst "'" "&apos;"  rmcomment apos)
										      apos (+ apos 1)))

(if (/= (setq stringpos (vl-string-search "originSurvey" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 14)))(setq rmrefdp (substr monline (+ stringpos 15) (-(- wwpos 1)(+ stringpos 13)))))(setq rmrefdp ""))
   

      (SETVAR "CLAYER"  "RM Connection" )

(if (/= (vl-position  (strcat lp1c ","lp2c "," rolayer) linelist) nil)()
  (progn
    
   (setq eccount 0)
		(repeat (length errorcodelist)
		  (setq errorcode (nth eccount errorcodelist))
		  (if (and (vl-string-search errorcode (strcase comment ))(= (getvar "CECOLOR") "BYLAYER"))(setvar "CECOLOR" "30"))
		(setq eccount (+ eccount 1))
		  )
   
      (command "line" lp1c lp2c "")
    
    (setq linedrawn "1");tick line drawn

    (if (/= vertdistance "")(setq overtdist (strcat " vertDistance=\"" vertdistance "\" "))(setq overtdist ""))
(if (/= MSLdistance "")(setq oMSLdist (strcat " MSLDistance=\"" MSLdistance "\" "))(setq oMSLdist ""))
    
   
      
  (if (/= comment "")(setq ocomment (strcat "><FieldNote>\"" comment "\"</FieldNote></ReducedObservation>"))(setq ocomment "/>"))
(if (/= daf "")(setq daf (strcat " distanceAdoptionFactor=\"" daf "\"")))
(SETQ BDINFO (STRCAT "azimuth=\"" xbearing "\" horizDistance=\"" dist "\"" distanceType azimuthtype daf overtdist oMSLdist adoptedDistanceSurvey distanceAccClass ocomment))
(SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 BDINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)
    
 
(lrm)
   (if (/= (getvar "CECOLOR") "BYLAYER") (setvar "CECOLOR" "BYLAYER")) 
	     ;DRAW RM BLOCK AND ADD RM POINT
  (SETVAR "CLAYER" "Drafting" )
  (COMMAND "._INSERT" "RM" "_S" TH lP2c "0");changed for BricsCAD
;  (SETQ RMB (ENTLAST))
;  (SETQ ENTSS (SSADD))
;  (SSADD RMB ENTSS)
;(COMMAND "DRAWORDER" ENTSS "" "FRONT")
											 
       											
  (SETVAR "CLAYER" "Monument" )
  (COMMAND "POINT" lp1c)

  ;check for no values and replace with "none"
    (if (/= rmrefdp "")(setq ormrefdp (strcat " originSurvey=\"" rmrefdp "\""))(setq ormrefdp ""))
  (if (/= rmcondition "")(setq ormcondition ( strcat " condition=\"" rmcondition "\""))(setq ormcondition ""))
  (if (/= rmtype "")(setq ormtype ( strcat "type=\"" rmtype "\" "))(setq ormtype ""))

    (if (/= rmcomment "")(setq rmcomments (strcat " desc=\"" rmcomment "\""))(setq rmcomments ""))
    (SETQ PTINFO (STRCAT ormtype "state=\""  rmstate "\"" ormrefdp  ormcondition rmcomments " />" ));Note comment for desc in xml added to distance entry seperated by a space
(SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 PTINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)

  
					       (setq drawnrmlist (append drawnrmlist (list (strcat setupid "-" rmtype))))
					       
					       
  ));if line not already drawn
	   

	  ));if PM us used as reference point
	  




	    
  	      
	    ;RM on point one (normal format RM)-----------------------------------------------------------------------
	    (if (and (or (setq remmonlist (member setupid usedrmlist))(setq remmonlist (member setupid rmlist)))(or (= rolayer "Connection")(= rolayer "Reference"))(= p1type "r"))(progn

					    
(setq monline (cadr remmonlist))

 (if (/= (setq stringpos (vl-string-search "type" monline )) nil)(progn
(setq stringpos (vl-string-search "type" monline ))(setq wwpos (vl-string-position 34 monline (+ stringpos 6)))(setq rmtype (substr monline (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5))))
(if (/= (setq stringpos (vl-string-search "&amp;" rmtype )) nil) (setq rmtype (vl-string-subst "&" "&amp;" rmtype)))
)(setq rmtype ""))
 (if (/= (setq stringpos (vl-string-search "state" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 7)))(setq rmstate (substr monline (+ stringpos 8) (-(- wwpos 1)(+ stringpos 6)))))(setq rmstate ""))
(if (/= (setq stringpos (vl-string-search "condition" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 11)))(setq rmcondition (substr monline (+ stringpos 12) (-(- wwpos 1)(+ stringpos 10)))))(setq rmcondition ""))
(if (/= (setq stringpos (vl-string-search "desc" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 6)))(setq rmcomment (substr monline (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5)))))(setq rmcomment ""))
(setq &pos 0)
	      (while (/=  (setq &pos (vl-string-search "&amp;" rmcomment &pos )) nil) (setq rmcomment (vl-string-subst "&" "&amp;"  rmcomment &pos)
										      &pos (+ &pos 1)))
 (setq quotpos 0)
	(while (/=  (setq quotpos (vl-string-search "&quot;" rmcomment quotpos )) nil) (setq rmcomment (vl-string-subst "\"" "&quot;"  rmcomment 	quotpos)
										      quotpos (+ quotpos 1)))
					      (setq apos 0)
	(while (/=  (setq apos (vl-string-search "&apos;" rmcomment apos )) nil) (setq rmcomment (vl-string-subst "'" "&apos;"  rmcomment apos)
										      apos (+ apos 1)))

(if (/= (setq stringpos (vl-string-search "originSurvey" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 14)))(setq rmrefdp (substr monline (+ stringpos 15) (-(- wwpos 1)(+ stringpos 13)))))(setq rmrefdp ""))

(if (= (vl-position (strcat setupid "-" xbearing "-"dist) reflist) nil)(progn
					  
 
 
(SETVAR "CLAYER"  "RM Connection" )

(setq eccount 0)
		(repeat (length errorcodelist)
		  (setq errorcode (nth eccount errorcodelist))
		  (if (and (vl-string-search errorcode (strcase comment ))(= (getvar "CECOLOR") "BYLAYER"))(setvar "CECOLOR" "30"))
		(setq eccount (+ eccount 1))
		  )


  (command "line" lp1c lp2c "")
(setq linedrawn "1");tick line drawn

  (if (/= xbearing "")(setq bearings (STRCAT "azimuth=\"" xbearing "\" "))(setq bearings ""))
  
  
;Add observation data to line as XDATA
 (if (/= comment "")(setq ocomment (strcat "><FieldNote>\"" comment "\"</FieldNote></ReducedObservation>"))(setq ocomment "/>"))
(SETQ BDINFO (STRCAT bearings "horizDistance=\"" dist "\"" distanceType azimuthtype adoptedDistanceSurvey distanceAccClass ocomment))
(SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 BDINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)


  ;GET LAST LINE DATA
  (SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
   (setq p1 (CDR(ASSOC 10 sentlist)))
   (setq p2 (CDR(ASSOC 11 sentlist)))
  
(lrm);DRAW DP REF INFO
(if (/= (getvar "CECOLOR") "BYLAYER") (setvar "CECOLOR" "BYLAYER"))

(if (= (vl-position setupid usedrmlist) nil)
  (progn
  (SETVAR "CLAYER"  "Monument")
  (COMMAND "POINT" p1)

  ;check for no values and replace with "none"
  ;check for no values and replace with "none"
     (if (/= rmrefdp "")(setq ormrefdp (strcat " originSurvey=\"" rmrefdp "\""))(setq ormrefdp ""))
  (if (/= rmcondition "")(setq ormcondition ( strcat " condition=\"" rmcondition "\""))(setq ormcondition ""))
  (if (/= rmtype "")(setq ormtype ( strcat "type=\"" rmtype "\" "))(setq ormtype ""))

    (if (/= rmcomment "")(setq rmcomments (strcat " desc=\"" rmcomment "\""))(setq rmcomments ""))
    (SETQ PTINFO (STRCAT ormtype "state=\""  rmstate "\""  ormrefdp  ormcondition rmcomments " />" ));Note comment for desc in xml added to distance entry seperated by a space
(SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 PTINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)


        
  ;DRAW RM BLOCK AND ADD RM POINT
  (SETVAR "CLAYER" "Drafting" )
  (COMMAND "._INSERT" "RM" "_S" TH lP2c "0");changed for BricsCAD
 ; (SETQ RMB (ENTLAST))
 ; (SETQ ENTSS (SSADD))
 ; (SSADD RMB ENTSS)
;(COMMAND "DRAWORDER" ENTSS "" "FRONT")
  ));p&if not in used rm list

(setq drawnrmlist (append drawnrmlist (list (strcat setupid "-" rmtype))));add to list of placed rm
(setq reflist (append reflist (list (strcat setupid"-"xbearing"-"dist))));create a secondary list in case someone used the same refernce point twice Mr Bill Currie! (DP1191367)

;tool to remove drawn rm (in case there are two marks on the same point (yes it happens i.e. gone & non peg corner mark)
(if (= (vl-position setupid usedrmlist) nil)
  (progn
(setq rmnth (vl-position setupid rmlist))
(setq rmlist (remove_nth rmlist  rmnth ))
(setq rmlist (remove_nth rmlist  rmnth ))
))
(setq usedrmlist (append usedrmlist (list setupid monline)))

(setq rmline 1);trigger for rmline with monument at cnr end not to draw.
  );p
  
  

    
    );p and if not in drawnrmlist


));p & if RM
	    
;draw line if monument on either end of the line
	     (if (and (=(vl-position setupid pmlist) nil)(= (vl-position targetid pmlist) nil)(or (and (setq pos1 (member setupid rmlist))(or (= p1type "b")(= p1type "t")))(and (vl-position targetid rmlist)(or (= p2type "b")(= p2type "t")))))
	       (progn
(if (= rmline 0)(progn
		  (if (= rolayer "Reference")(setq rolayer "RM Connection"))
(SETVAR "CLAYER"  rolayer )

(if (/= (vl-position  (strcat lp1c ","lp2c "," rolayer) linelist)nil)()
  (progn

    (setq eccount 0)
		(repeat (length errorcodelist)
		  (setq errorcode (nth eccount errorcodelist))
		  (if (and (vl-string-search errorcode (strcase comment ))(= (getvar "CECOLOR") "BYLAYER"))(setvar "CECOLOR" "30"))
		(setq eccount (+ eccount 1))
		  )

    
  (command "line" lp1c lp2c "")
  (setq linedrawn "1");tick line drawn
  (if (/= xbearing "")(setq bearings (STRCAT "azimuth=\"" xbearing "\" "))(setq bearings ""))
  (if (/= vertdistance "")(setq overtdist (strcat " vertDistance=\"" vertdistance "\" "))(setq overtdist ""))
  (if (/= MSLdistance "")(setq oMSLdist (strcat " MSLDistance=\"" MSLdistance "\" "))(setq oMSLdist ""))
  
;Add observation data to line as XDATA
 (if (/= comment "")(setq ocomment (strcat "><FieldNote>\"" comment "\"</FieldNote></ReducedObservation>"))(setq ocomment "/>"))
(SETQ BDINFO (STRCAT bearings "horizDistance=\"" dist "\"" distanceType azimuthtype overtdist oMSLdist ocomment))
(SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 BDINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)
 
  

  ;GET LAST LINE DATA
  (SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
   (setq p1 (CDR(ASSOC 10 sentlist)))
   (setq p2 (CDR(ASSOC 11 sentlist)))

(if (/= (vl-position (strcat lp1c "," lp2c "," rolayer) linelist) nil)()(lba));label line if not already labelledin reverse
    (if (/= (getvar "CECOLOR") "BYLAYER") (setvar "CECOLOR" "BYLAYER"))
  ))
));p&if rmline
));p&if monument on either end of the line

	    
	      
	    ;If MONUMENT on end of line at P1------------------------------------------------------------------------------
	    (if (and (setq pos1 (vl-position setupid rmlist))(or (= p1type "b")(= p1type "t")))(progn

												    

												  
												  
(setq monline (nth (+ pos1 1) rmlist))

 (if (/= (setq stringpos (vl-string-search "type" monline )) nil)(progn
(setq stringpos (vl-string-search "type" monline ))(setq wwpos (vl-string-position 34 monline (+ stringpos 6)))(setq rmtype (substr monline (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5))))
(if (/= (setq stringpos (vl-string-search "&amp;" rmtype )) nil) (setq rmtype (vl-string-subst "&" "&amp;" rmtype)))
)(setq rmtype ""))
 (if (/= (setq stringpos (vl-string-search "state" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 7)))(setq rmstate (substr monline (+ stringpos 8) (-(- wwpos 1)(+ stringpos 6)))))(setq rmstate ""))
(if (/= (setq stringpos (vl-string-search "condition" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 11)))(setq rmcondition (substr monline (+ stringpos 12) (-(- wwpos 1)(+ stringpos 10)))))(setq rmcondition ""))
(if (/= (setq stringpos (vl-string-search "desc" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 6)))(setq rmcomment (substr monline (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5)))))(setq rmcomment ""))
(setq &pos 0)
	      (while (/=  (setq &pos (vl-string-search "&amp;" rmcomment &pos )) nil) (setq rmcomment (vl-string-subst "&" "&amp;"  rmcomment &pos)
										      &pos (+ &pos 1)))
 (setq quotpos 0)
	(while (/=  (setq quotpos (vl-string-search "&quot;" rmcomment quotpos )) nil) (setq rmcomment (vl-string-subst "\"" "&quot;"  rmcomment 	quotpos)
										      quotpos (+ quotpos 1)))
					      (setq apos 0)
	(while (/=  (setq apos (vl-string-search "&apos;" rmcomment apos )) nil) (setq rmcomment (vl-string-subst "'" "&apos;"  rmcomment apos)
										      apos (+ apos 1)))

(if (/= (setq stringpos (vl-string-search "originSurvey" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 14)))(setq rmrefdp (substr monline (+ stringpos 15) (-(- wwpos 1)(+ stringpos 13)))))(setq rmrefdp ""))

(if (= (vl-position (strcat setupid "-" rmtype) drawnrmlist) nil)(progn
					  
 
   
    ;draw monument info
    
    
  

  
  (SETVAR "CLAYER" "Monument" )
  (COMMAND "POINT" p1)

  ;check for no values and replace with "none"
    (if (/= rmrefdp "")(setq ormrefdp (strcat " originSurvey=\"" rmrefdp "\""))(setq ormrefdp ""))
  (if (/= rmcondition "")(setq ormcondition ( strcat " condition=\"" rmcondition "\""))(setq ormcondition ""))
  (if (/= rmtype "")(setq ormtype ( strcat "type=\"" rmtype "\" "))(setq ormtype ""))

    (if (/= rmcomment "")(setq rmcomments (strcat " desc=\"" rmcomment "\""))(setq rmcomments ""))
    (SETQ PTINFO (STRCAT ormtype "state=\""  rmstate "\"" ormrefdp  ormcondition rmcomments " />" ));Note comment for desc in xml added to distance entry seperated by a space
(SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 PTINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)

  ;deal with RM in corner mark description
  (if (vl-string-search " RM" rmcomment )(progn
					   (setq rmornot " RM")
					   (setq rmcomment (vl-string-subst "" "RM" rmcomment))

					   )
    (setq rmornot ""); if not rm corner mark make nil
    )
					   
						
 
        
 
(setq drawnrmlist (append drawnrmlist (list (strcat setupid "-" rmtype))));add to list of placed rm @@@@@write code to check for unreferenced rms maybe???
  ;tool to remove drawn rm (in case there are two rms on the same point (yes it happens i.e. gone & non peg corner mark)
(setq rmnth (vl-position setupid rmlist))
(setq rmlist (remove_nth rmlist  rmnth ))
(setq rmlist (remove_nth rmlist  rmnth ))

  
  
 (lcm)
  
  
)
  

    
    );if not in drawnrmlist

));p & if mon on P1




	       ;If MONUMENT on end of line at P2-----------------------------------------------------------------------
	    (if (and (setq pos1 (vl-position targetid rmlist))(or (= p2type "b")(= p2type "t")))(progn
(setq monline (nth (+ pos1 1) rmlist))

 (if (/= (setq stringpos (vl-string-search "type" monline )) nil)(progn
(setq stringpos (vl-string-search "type" monline ))(setq wwpos (vl-string-position 34 monline (+ stringpos 6)))(setq rmtype (substr monline (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5))))
(if (/= (setq stringpos (vl-string-search "&amp;" rmtype )) nil) (setq rmtype (vl-string-subst "&" "&amp;" rmtype)))
)(setq rmtype ""))
 (if (/= (setq stringpos (vl-string-search "state" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 7)))(setq rmstate (substr monline (+ stringpos 8) (-(- wwpos 1)(+ stringpos 6)))))(setq rmstate ""))
(if (/= (setq stringpos (vl-string-search "condition" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 11)))(setq rmcondition (substr monline (+ stringpos 12) (-(- wwpos 1)(+ stringpos 10)))))(setq rmcondition ""))
(if (/= (setq stringpos (vl-string-search "desc" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 6)))(setq rmcomment (substr monline (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5)))))(setq rmcomment ""))
(setq &pos 0)
	      (while (/=  (setq &pos (vl-string-search "&amp;" rmcomment &pos )) nil) (setq rmcomment (vl-string-subst "&" "&amp;"  rmcomment &pos)
										      &pos (+ &pos 1)))
 (setq quotpos 0)
	(while (/=  (setq quotpos (vl-string-search "&quot;" rmcomment quotpos )) nil) (setq rmcomment (vl-string-subst "\"" "&quot;"  rmcomment 	quotpos)
										      quotpos (+ quotpos 1)))
					      (setq apos 0)
	(while (/=  (setq apos (vl-string-search "&apos;" rmcomment apos )) nil) (setq rmcomment (vl-string-subst "'" "&apos;"  rmcomment apos)
										      apos (+ apos 1)))

(if (/= (setq stringpos (vl-string-search "originSurvey" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 14)))(setq rmrefdp (substr monline (+ stringpos 15) (-(- wwpos 1)(+ stringpos 13)))))(setq rmrefdp ""))

(if (= (vl-position (strcat targetid "-" rmtype) drawnrmlist) nil)(progn
					  
 
  (SETVAR "CLAYER"  "Monument" )
  (COMMAND "POINT" lp2c)

 ;check for no values and replace with "none"
     (if (/= rmrefdp "")(setq ormrefdp (strcat " originSurvey=\"" rmrefdp "\""))(setq ormrefdp ""))
  (if (/= rmcondition "")(setq ormcondition ( strcat " condition=\"" rmcondition "\""))(setq ormcondition ""))
  (if (/= rmtype "")(setq ormtype ( strcat "type=\"" rmtype "\" "))(setq ormtype ""))

    (if (/= rmcomment "")(setq rmcomments (strcat " desc=\"" rmcomment "\""))(setq rmcomments ""))
    (SETQ PTINFO (STRCAT ormtype "state=\""  rmstate "\"" ormrefdp  ormcondition rmcomments " />" ));Note comment for desc in xml added to distance entry seperated by a space
(SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 PTINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)

  (setq p1 p2)
        
 (if (vl-string-search " RM" rmcomment )(progn
					   (setq rmornot " RM")
					   (setq rmcomment (vl-string-subst "" "RM" rmcomment))

					   )
    (setq rmornot ""); if not rm corner mark make nil
    )

(setq drawnrmlist (append drawnrmlist (list (strcat targetid "-" rmtype))));add to list of placed rm @@@@@write code to check for unreferenced rms maybe???

  ;tool to remove drawn rm (in case there are two rms on the same point (yes it happens i.e. gone & non peg corner mark)
(setq rmnth (vl-position targetid rmlist))
(setq rmlist (remove_nth rmlist  rmnth ))
(setq rmlist (remove_nth rmlist  rmnth ))


  
  (lcm)
  
)
  
 
    
    );if not in drawnrmlist

));p & if mon on P2






	        ;if nothing at either end of line
	    (if (= (or (vl-position setupid pmlist)(vl-position targetid pmlist)(vl-position targetid rmlist)(vl-position setupid rmlist)(= linedrawn "1")) nil)(progn

		(if (= rolayer "Reference")(setq rolayer "RM Connection"))
      (SETVAR "CLAYER"  rolayer )
      (if (/= (vl-position  (strcat lp1c ","lp2c "," rolayer) linelist) nil)()
  (progn

    (setq eccount 0)
		(repeat (length errorcodelist)
		  (setq errorcode (nth eccount errorcodelist))
		  (if (and (vl-string-search errorcode (strcase comment ))(= (getvar "CECOLOR") "BYLAYER"))(setvar "CECOLOR" "30"))
		(setq eccount (+ eccount 1))
		  )


    
      (command "line" lp1c lp2c "")
    
(if (/= xbearing "")(setq bearings (STRCAT "azimuth=\"" xbearing "\" "))(setq bearings ""))
    (if (/= vertdistance "")(setq overtdist (strcat " vertDistance=\"" vertdistance "\" "))(setq overtdist ""))
(if (/= MSLdistance "")(setq oMSLdist (strcat " MSLDistance=\"" MSLdistance "\" "))(setq oMSLdist ""))
  
  
;Add observation data to line as XDATA
 (if (/= comment "")(setq ocomment (strcat "><FieldNote>\"" comment "\"</FieldNote></ReducedObservation>"))(setq ocomment "/>"))
(SETQ BDINFO (STRCAT bearings "horizDistance=\"" dist "\"" distanceType azimuthtype overtdist oMSLdist ocomment))
    
(SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 BDINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)

      (if (/= (vl-position (strcat lp1c "," lp2c "," rolayer) linelist) nil)()(lba));label line if not already labelled
    (if (/= (getvar "CECOLOR") "BYLAYER") (setvar "CECOLOR" "BYLAYER"))
    ))
      );p
	

    );if nothing at either end of line


);p if not a vert obs only
);if vert not obs only
      
  
	          (setq linelist (append linelist (list (strcat lp1c","lp2c "," rolayer))))
  

	    	    ));pif line


;------------arc observation-------------------------------------------------------------------------------------------------


		(if (/= (vl-string-search "<ReducedArcObservation" linetext ) nil)
	    (progn
	      
	      
	    (setq stringpos (vl-string-search "desc" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 6)))
            (setq rolayer (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5))))

	    (setq stringpos (vl-string-search "setupID" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 9)))
            (setq setupids (strcat "IS-" (substr linetext (+ stringpos 10) (-(- wwpos 1)(+ stringpos 8)))))
	    (setq pos1 (vl-position setupids islist))
	    (setq setupid (nth (+ pos1 1) islist))

	    (setq stringpos (vl-string-search "targetSetupID" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 15)))
            (setq targetid (strcat "IS-" (substr linetext (+ stringpos 16) (-(- wwpos 1)(+ stringpos 14)))))
	    (setq pos1 (vl-position targetid islist))
	    (setq targetid (nth (+ pos1 1) islist))

	    (if (/=  (setq stringpos (vl-string-search "chordAzimuth" linetext )) nil)(progn
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 14)))
            (setq bearing (substr linetext (+ stringpos 15) (-(- wwpos 1)(+ stringpos 13))))
	    (setq xbearing bearing)
	    (setq cbrq "Y");setq cbrq for lbarc
	    )(setq bearing ""
		   cbrq "N"));set cbrq for lbarc when no azimuth
	    
	    

	    (setq stringpos (vl-string-search "length" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 8)))
            (setq arclength (substr linetext (+ stringpos 9) (-(- wwpos 1)(+ stringpos 7))))
	    (setq arclength (rtos (atof arclength)2 3));remove trailing zeros

	    (setq stringpos (vl-string-search "radius" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 8)))
            (setq radius (substr linetext (+ stringpos 9) (-(- wwpos 1)(+ stringpos 7))))
	    

	    (setq stringpos (vl-string-search "rot" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 5)))
            (setq curverot (substr linetext (+ stringpos 6) (-(- wwpos 1)(+ stringpos 4))))

	    (if (/= (setq stringpos (vl-string-search "arcType" linetext )) nil)(progn
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 9)))
            (setq arcType (strcat " arcType=\"" (substr linetext (+ stringpos 10) (-(- wwpos 1)(+ stringpos 8))) "\"")))(setq arcType ""))

	       (if (/= (setq stringpos (vl-string-search "<FieldNote>" linetext )) nil)(progn
											   

    (setq <pos (vl-string-position 60 linetext (+ stringpos 11)))
    (setq comment (substr linetext (+ stringpos 12) (-(- <pos 1)(+ stringpos 10))))
    )
  (setq comment ""))

	    	    ;case if fieldnote is linefed
	      (if (and (=  (vl-string-search "/>" linetext ) nil)(=  (vl-string-search "</ReducedArcObservation>" linetext ) nil))(progn
									     (linereader)
			(if (/= (setq stringpos (vl-string-search "<FieldNote>" linetext )) nil)(progn
												  
			(setq >pos (vl-string-position 62 linetext))
			
		 (while (= (setq <pos (vl-string-position 60 linetext (+ >pos 1))) nil)(progn
										(setq comment (strcat comment (substr linetext (+ >pos 2) ) " "))
										
										(linereader)
										(setq >pos -1)
										));while no <
		 (if (/= <pos 0)(setq comment (strcat comment (substr linetext (+ stringpos 12) (- <pos 11)))))
			));if fieldnote
         	 

										));p if no <


	    ;remove ""
	    (setq wwpos 0)
	      (while (/=  (setq wwpos (vl-string-search "\"" comment wwpos )) nil) (setq comment (vl-string-subst "" "\""  comment wwpos)))
									     
									     
									     
	    
	    (setq &pos 0)
	      (while (/=  (setq &pos (vl-string-search "&amp;" comment &pos )) nil) (setq comment (vl-string-subst "&" "&amp;"  comment &pos)
										      &pos (+ &pos 1)))
	    (setq quotpos 0)
	(while (/=  (setq quotpos (vl-string-search "&quot;" comment quotpos )) nil) (setq comment (vl-string-subst "\"" "&quot;"  comment 	quotpos)
										      quotpos (+ quotpos 1)))
					      (setq apos 0)
	(while (/=  (setq apos (vl-string-search "&apos;" comment apos )) nil) (setq comment (vl-string-subst "'" "&apos;"  comment apos)
										      apos (+ apos 1)))


	    (setq pos1 (vl-position setupid cgpointlist))
            (setq lp1c (nth (+ pos1 1) cgpointlist))
	    (setq pos2 (vl-position targetid cgpointlist))
            (setq lp2c (nth (+ pos2 1) cgpointlist))


	    (if (or (vl-position (strcat lp1c "," lp2c) finaleaselist)(vl-position (strcat lp2c "," lp1c) finaleaselist))(setq rolayer "Easement")) ;check if line is an easement line

  (setq ,pos1 (vl-string-position 44 lp1c 0))
                 (setq east (atof (substr lp1c 1 ,pos1)))
      		 (setq north (atof (substr lp1c (+ ,pos1 2) 50)))
					   (setq tp1 (list east north))
                                           (setq p1 (list east north))
  (setq ,pos1 (vl-string-position 44 lp2c 0))
                 (setq east (atof (substr lp2c 1 ,pos1)))
      		 (setq north (atof (substr lp2c (+ ,pos1 2) 50)))
					   (setq tp2 (list east north))
                                           (setq p2 (list east north))
	    (setq digchaz (angle p1 p2))

;calc arc internal angle
	      (SETQ MAST (SQRT (- (* (atof RADIUS) (atof RADIUS)) (* (/ (distance p1 p2) 2)(/ (distance p1 p2) 2 )))))
  (SETQ O (* 2 (ATAN (/ (/ (distance p1 p2) 2) MAST))))
	    (setq remhalfO  (- (* 0.5 pi) (/ O 2)))
	    ;calc bearing from p1 to arc centre (watching for bulbous arcs)
	    (if (and (= curverot "ccw") (<= (atof arclength) (* pi (atof radius))))(setq raybearing (+  digchaz  remhalfO)))
	    (IF (and (= curverot "cw") (<= (atof arclength) (* pi (atof radius))))(setq raybearing (-  digchaz  remhalfO)))
	    (IF (and (= curverot "ccw") (> (atof arclength) (* pi (atof radius))))(setq raybearing (-  digchaz  remhalfO)))
	    (if (and (= curverot "cw") (> (atof arclength) (* pi (atof radius))))(setq raybearing (+  digchaz  remhalfO)))

	    
	      ;CONVERT TO ANTI CLOCKWISE AND EAST ANGLE
  ;(SETQ raybearing (+ (* -1 raybearing) (* 0.5 PI)))

	       ;calc curve centre point
	    (setq curvecen (polar p1 raybearing (atof radius)))
	    (setq curvecenc (strcat (rtos (car curvecen) 2 9) "," (rtos (cadr curvecen) 2 9)))

	    ;calc curve midpoint
  (setq a1 (angle curvecen p1))
  (setq a2 (angle curvecen p2))
  (if (= curverot "ccw")(setq da (- a2 a1))(setq da (- a1 a2)))
  (if (< da 0)(setq da (+ da (* 2 pi))))
    (SETQ DA (/ DA 2))
    (IF (= CURVEROT "ccw")(setq midb (+ a1 da))(setq midb (+ a2 da)))
  (setq amp (polar curvecen midb (atof radius)))
	    
	    (setq arclist (append arclist (list (strcat lp2c"," curvecenc "," lp1c "," rolayer))))
	    
  					   
;calc chord distance, note using string values not digital values
	    (setq stringO (/ (atof arclength) (atof radius)));arc internal angle based on string values
	    (setq dist (rtos (* 2 (atof radius) (sin (/ stringO 2))) 2 3))

	       ;APPLY ALL CORRECTIONS AND EXTRACT INFORMATION FROM USER INPUT
(if (/= (vl-string-position 46 bearing 0) nil ) (PROGN
   (setq dotpt1 (vl-string-position 46 bearing 0))
  (setq deg  (substr bearing 1  dotpt1 ))
  (SETQ mins   (substr bearing (+ dotpt1 2) 2) )
  (if (= (strlen mins) 1)(setq mins (strcat  mins "0")));fix problem with truncating zeros on minutes and seconds
  (setq mins (strcat mins "'"))
  (setq sec  (substr bearing (+ dotpt1 4) 10))
  (if (= (strlen sec) 1) (setq sec (strcat sec "0")))

 

  
  (if (> (strlen sec) 2) (setq sec (strcat (substr sec 1 2) "." (substr sec 3 10))))
  (if (= (strlen sec) 0) (setq sec "") (setq sec (strcat sec (chr 34))))

  );P
	(progn
	  (setq deg bearing)
	  (setq mins "")
	  (setq sec "")
	  );p else
  
  );IF

      
(setq bearing (strcat  deg "d" mins sec))
    ;(setq lbearing bearing)'
	     (setq dist (rtos (atof dist)2 3));remove trailing zeros
  (setq ldist dist )
	    (setq radius (rtos (atof radius)2 3));remove trailing zeros
    (setq lradius radius)


;DELETED ARC AS AN RM REFERENCE - SHOULD NEVER HAPPEN
	    
	      
	    ;If MONUMENT on end of line at P1 ARC------------------------------------------------------------------------------
	    (if (and (setq pos1 (vl-position setupid rmlist))(or (= p1type "b")(= p1type "t")))(progn

												  
(SETVAR "CLAYER"  rolayer )
      ;draw arc
(if (vl-position  (strcat lp1c "," curvecenc "," lp2c "," rolayer) arclist)()
  (progn

    (setq eccount 0)
		(repeat (length errorcodelist)
		  (setq errorcode (nth eccount errorcodelist))
		  (if (and (vl-string-search errorcode (strcase comment ))(= (getvar "CECOLOR") "BYLAYER"))(setvar "CECOLOR" "30"))
		(setq eccount (+ eccount 1))
		  )


    
	     (if (= curverot "ccw") (command "arc" "c" curvecenc lp1c lp2c)(command "arc" "c" curvecenc lp2c lp1c))
  (setq linedrawn 1)
;Add observation data to line as XDATA
 (if (/= comment "")(setq ocomment (strcat "><FieldNote>\"" comment "\"</FieldNote></ReducedArcObservation>"))(setq ocomment "/>"))
(SETQ BDINFO (STRCAT "chordAzimuth=\"" xbearing "\" length=\"" arclength "\" radius=\"" radius  "\" rot=\"" curverot "\""   arcType ocomment))
(SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 BDINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)
 
  (if (member (strcat lp1c "," curvecenc "," lp2c "," rolayer) arclist)()(lbarc));label line if not already labelled;label arc using function
(if (/= (getvar "CECOLOR") "BYLAYER") (setvar "CECOLOR" "BYLAYER"))
 ;GET LAST LINE DATA
  (SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
))
												  
(setq monline (nth (+ pos1 1) rmlist))
(setq linedrawn 0)
 (if (/= (setq stringpos (vl-string-search "type" monline )) nil)(progn
(setq stringpos (vl-string-search "type" monline ))(setq wwpos (vl-string-position 34 monline (+ stringpos 6)))(setq rmtype (substr monline (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5))))
(if (/= (setq stringpos (vl-string-search "&amp;" rmtype )) nil) (setq rmtype (vl-string-subst "&" "&amp;" rmtype)))
)(setq rmtype ""))
 (if (/= (setq stringpos (vl-string-search "state" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 7)))(setq rmstate (substr monline (+ stringpos 8) (-(- wwpos 1)(+ stringpos 6)))))(setq rmstate ""))
(if (/= (setq stringpos (vl-string-search "condition" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 11)))(setq rmcondition (substr monline (+ stringpos 12) (-(- wwpos 1)(+ stringpos 10)))))(setq rmcondition ""))
(if (/= (setq stringpos (vl-string-search "desc" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 6)))(setq rmcomment (substr monline (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5)))))(setq rmcomment ""))
(setq &pos 0)
	      (while (/=  (setq &pos (vl-string-search "&amp;" rmcomment &pos )) nil) (setq rmcomment (vl-string-subst "&" "&amp;"  rmcomment &pos)
										      &pos (+ &pos 1)))
 (setq quotpos 0)
	(while (/=  (setq quotpos (vl-string-search "&quot;" rmcomment quotpos )) nil) (setq rmcomment (vl-string-subst "\"" "&quot;"  rmcomment 	quotpos)
										      quotpos (+ quotpos 1)))
					      (setq apos 0)
	(while (/=  (setq apos (vl-string-search "&apos;" rmcomment apos )) nil) (setq rmcomment (vl-string-subst "'" "&apos;"  rmcomment apos)
										      apos (+ apos 1)))


(if (/= (setq stringpos (vl-string-search "originSurvey" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 14)))(setq rmrefdp (substr monline (+ stringpos 15) (-(- wwpos 1)(+ stringpos 13)))))(setq rmrefdp ""))

(if (= (vl-position (strcat setupid "-" rmtype) drawnrmlist) nil)(progn
					  
 
  
  (SETVAR "CLAYER"  "Monument" )
  (COMMAND "POINT" p1)

 ;check for no values and replace with "none"
    (if (/= rmrefdp "")(setq ormrefdp (strcat " originSurvey=\"" rmrefdp "\""))(setq ormrefdp ""))
  (if (/= rmcondition "")(setq ormcondition ( strcat " condition=\"" rmcondition "\""))(setq ormcondition ""))
  (if (/= rmtype "")(setq ormtype ( strcat "type=\"" rmtype "\" "))(setq ormtype ""))

    (if (/= rmcomment "")(setq rmcomments (strcat " desc=\"" rmcomment "\""))(setq rmcomments ""))
    (SETQ PTINFO (STRCAT ormtype "state=\""  rmstate "\"" ormrefdp  ormcondition rmcomments " />" ));Note comment for desc in xml added to distance entry seperated by a space
(SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 PTINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)
        (if (vl-string-search " RM" rmcomment )(progn
					   (setq rmornot " RM")
					   (setq rmcomment (vl-string-subst "" "RM" rmcomment))

					   )
    (setq rmornot ""); if not rm corner mark make nil
    )
 
(setq drawnrmlist (append drawnrmlist (list (strcat setupid "-" rmtype))));add to list of placed rm @@@@@write code to check for unreferenced rms maybe???
  ;tool to remove drawn rm (in case there are two rms on the same point (yes it happens i.e. gone & non peg corner mark)
(setq rmnth (vl-position setupid rmlist))
(setq rmlist (remove_nth rmlist  rmnth ))
(setq rmlist (remove_nth rmlist  rmnth ))

(LCM)

  



)
  
 
    
    );if not in drawnrmlist

));p & if mon on P1




	       ;If MONUMENT on end of line at P2 - ARC-----------------------------------------------------------------------
	    (if (and (setq pos1 (vl-position targetid rmlist))(or (= p2type "b")(= p2type "t")))(progn
(setq monline (nth (+ pos1 1) rmlist))

 (if (/= (setq stringpos (vl-string-search "type" monline )) nil)(progn
(setq stringpos (vl-string-search "type" monline ))(setq wwpos (vl-string-position 34 monline (+ stringpos 6)))(setq rmtype (substr monline (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5))))
(if (/= (setq stringpos (vl-string-search "&amp;" rmtype )) nil) (setq rmtype (vl-string-subst "&" "&amp;" rmtype)))
)(setq rmtype ""))
 (if (/= (setq stringpos (vl-string-search "state" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 7)))(setq rmstate (substr monline (+ stringpos 8) (-(- wwpos 1)(+ stringpos 6)))))(setq rmstate ""))
(if (/= (setq stringpos (vl-string-search "condition" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 11)))(setq rmcondition (substr monline (+ stringpos 12) (-(- wwpos 1)(+ stringpos 10)))))(setq rmcondition ""))
(if (/= (setq stringpos (vl-string-search "desc" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 6)))(setq rmcomment (substr monline (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5)))))(setq rmcomment ""))
(setq &pos 0)
	      (while (/=  (setq &pos (vl-string-search "&amp;" rmcomment &pos )) nil) (setq rmcomment (vl-string-subst "&" "&amp;"  rmcomment &pos)
										      &pos (+ &pos 1)))
(setq quotpos 0)
	(while (/=  (setq quotpos (vl-string-search "&quot;" rmcomment quotpos )) nil) (setq rmcomment (vl-string-subst "\"" "&quot;"  rmcomment 	quotpos)
										      quotpos (+ quotpos 1)))
					      (setq apos 0)
	(while (/=  (setq apos (vl-string-search "&apos;" rmcomment apos )) nil) (setq rmcomment (vl-string-subst "'" "&apos;"  rmcomment apos)
										      apos (+ apos 1)))

(if (/= (setq stringpos (vl-string-search "originSurvey" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 14)))(setq rmrefdp (substr monline (+ stringpos 15) (-(- wwpos 1)(+ stringpos 13)))))(setq rmrefdp ""))

(if (= (vl-position (strcat targetid "-" rmtype) drawnrmlist) nil)(progn
					  
      
  (SETVAR "CLAYER"  "Monument" )
  (COMMAND "POINT" p2)

  ;check for no values and replace with "none"
     (if (/= rmrefdp "")(setq ormrefdp (strcat " originSurvey=\"" rmrefdp "\""))(setq ormrefdp ""))
  (if (/= rmcondition "")(setq ormcondition ( strcat " condition=\"" rmcondition "\""))(setq ormcondition ""))
  (if (/= rmtype "")(setq ormtype ( strcat "type=\"" rmtype "\" "))(setq ormtype ""))

    (if (/= rmcomment "")(setq rmcomments (strcat " desc=\"" rmcomment "\""))(setq rmcomments ""))
    (SETQ PTINFO (STRCAT ormtype "state=\""  rmstate "\"" ormrefdp  ormcondition rmcomments " />" ));Note comment for desc in xml added to distance entry seperated by a space
(SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 PTINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)
   

(setq p1 p2)
  
 (if (vl-string-search " RM" rmcomment )(progn
					   (setq rmornot " RM")
					   (setq rmcomment (vl-string-subst "" "RM" rmcomment))

					   )
    (setq rmornot ""); if not rm corner mark make nil
    )
        
 
(setq drawnrmlist (append drawnrmlist (list (strcat targetid "-" rmtype))));add to list of placed rm @@@@@write code to check for unreferenced rms maybe???
  ;tool to remove drawn rm (in case there are two rms on the same point (yes it happens i.e. gone & non peg corner mark)
(setq rmnth (vl-position targetid rmlist))
(setq rmlist (remove_nth rmlist  rmnth ))
(setq rmlist (remove_nth rmlist  rmnth ))
  
  (lcm)
  
)
  
     
    );if not in drawnrmlist

));p & if mon on P2




	    

	    ;if PM at either end of the line
	    (if (or (and (setq pos1 (vl-position setupid pmlist))(= rolayer "Connection")(= p1type "c"))(and (setq pos1 (vl-position targetid pmlist))(= rolayer "Connection")(= p2type "c")))(progn

(setq monline (nth (+ pos1 1) pmlist))

 (if (/= (setq stringpos (vl-string-search "type" monline )) nil)(progn
(setq stringpos (vl-string-search "type" monline ))(setq wwpos (vl-string-position 34 monline (+ stringpos 6)))(setq rmtype (substr monline (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5))))
(if (/= (setq stringpos (vl-string-search "&amp;" rmtype )) nil) (setq rmtype (vl-string-subst "&" "&amp;" rmtype)))
)(setq rmtype ""))
 (if (/= (setq stringpos (vl-string-search "state" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 7)))(setq rmstate (substr monline (+ stringpos 8) (-(- wwpos 1)(+ stringpos 6)))))(setq rmstate ""))
(if (/= (setq stringpos (vl-string-search "condition" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 11)))(setq rmcondition (substr monline (+ stringpos 12) (-(- wwpos 1)(+ stringpos 10)))))(setq rmcondition ""))
(if (/= (setq stringpos (vl-string-search "desc" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 6)))(setq rmcomment (substr monline (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5)))))(setq rmcomment ""))
(setq &pos 0)
	      (while (/=  (setq &pos (vl-string-search "&amp;" rmcomment &pos )) nil) (setq rmcomment (vl-string-subst "&" "&amp;"  rmcomment &pos)
										      &pos (+ &pos 1)))
(setq quotpos 0)
	(while (/=  (setq quotpos (vl-string-search "&quot;" rmcomment quotpos )) nil) (setq rmcomment (vl-string-subst "\"" "&quot;"  rmcomment 	quotpos)
										      quotpos (+ quotpos 1)))
					      (setq apos 0)
	(while (/=  (setq apos (vl-string-search "&apos;" rmcomment apos )) nil) (setq rmcomment (vl-string-subst "'" "&apos;"  rmcomment apos)
										      apos (+ apos 1)))


(if (/= (setq stringpos (vl-string-search "originSurvey" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 14)))(setq rmrefdp (substr monline (+ stringpos 15) (-(- wwpos 1)(+ stringpos 13)))))(setq rmrefdp ""))
   

      (SETVAR "CLAYER"  "PM Connection" )

(if (/= (vl-position  (strcat lp1c "," curvecenc "," lp2c "," rolayer) arclist) nil)()
  (progn
    
(setq eccount 0)
		(repeat (length errorcodelist)
		  (setq errorcode (nth eccount errorcodelist))
		  (if (and (vl-string-search errorcode (strcase comment ))(= (getvar "CECOLOR") "BYLAYER"))(setvar "CECOLOR" "30"))
		(setq eccount (+ eccount 1))
		  )

       (if (= curverot "ccw") (command "arc" "c" curvecenc lp1c lp2c)(command "arc" "c" curvecenc lp2c lp1c))
      
 (if (/= comment "")(setq ocomment (strcat "><FieldNote>\"" comment "\"</FieldNote></ReducedArcObservation>"))(setq ocomment "/>"))
(SETQ BDINFO (STRCAT "chordAzimuth=\"" xbearing "\" length=\"" arclength "\" radius=\"" radius  "\" rot=\"" curverot "\"" arcType ocomment))
(SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 BDINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)

     
(if (/= (vl-position (strcat lp1c "," curvecenc "," lp2c "," rolayer) arclist) nil)()(lbarc));label line if not already labelled;label arc using function
(if (/= (getvar "CECOLOR") "BYLAYER") (setvar "CECOLOR" "BYLAYER"))
    ))

      ;SPECIAL CASE WHERE PM IS A MONUMENT

(IF (and (setq pos1 (vl-position setupid rmlist))(= (member (strcat setupid "-" rmtype) drawnrmlist) nil))(progn
					       (setq monline (nth (+ pos1 1) rmlist))
					       
					       
		 (if (/= (setq stringpos (vl-string-search "type" monline )) nil)(progn
(setq stringpos (vl-string-search "type" monline ))(setq wwpos (vl-string-position 34 monline (+ stringpos 6)))(setq rmtype (substr monline (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5))))
(if (/= (setq stringpos (vl-string-search "&amp;" rmtype )) nil) (setq rmtype (vl-string-subst "&" "&amp;" rmtype)))
)(setq rmtype ""))
 (if (/= (setq stringpos (vl-string-search "state" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 7)))(setq rmstate (substr monline (+ stringpos 8) (-(- wwpos 1)(+ stringpos 6)))))(setq rmstate ""))
(if (/= (setq stringpos (vl-string-search "condition" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 11)))(setq rmcondition (substr monline (+ stringpos 12) (-(- wwpos 1)(+ stringpos 10)))))(setq rmcondition ""))
(if (/= (setq stringpos (vl-string-search "desc" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 6)))(setq rmcomment (substr monline (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5)))))(setq rmcomment ""))
(setq &pos 0)
	      (while (/=  (setq &pos (vl-string-search "&amp;" rmcomment &pos )) nil) (setq rmcomment (vl-string-subst "&" "&amp;"  rmcomment &pos)
										      &pos (+ &pos 1)))
					       (setq quotpos 0)
	(while (/=  (setq quotpos (vl-string-search "&quot;" rmcomment quotpos )) nil) (setq rmcomment (vl-string-subst "\"" "&quot;"  rmcomment 	quotpos)
										      quotpos (+ quotpos 1)))
					      (setq apos 0)
	(while (/=  (setq apos (vl-string-search "&apos;" rmcomment apos )) nil) (setq rmcomment (vl-string-subst "'" "&apos;"  rmcomment apos)
										      apos (+ apos 1)))

(if (/= (setq stringpos (vl-string-search "originSurvey" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 14)))(setq rmrefdp (substr monline (+ stringpos 15) (-(- wwpos 1)(+ stringpos 13)))))(setq rmrefdp ""))
			       
  (SETVAR "CLAYER"  "Monument" )
  (COMMAND "POINT" lp1c)

  ;check for no values and replace with "none"
     (if (/= rmrefdp "")(setq ormrefdp (strcat " originSurvey=\"" rmrefdp "\""))(setq ormrefdp ""))
  (if (/= rmcondition "")(setq ormcondition ( strcat " condition=\"" rmcondition "\""))(setq ormcondition ""))
  (if (/= rmtype "")(setq ormtype ( strcat "type=\"" rmtype "\" "))(setq ormtype ""))

    (if (/= rmcomment "")(setq rmcomments (strcat " desc=\"" rmcomment "\""))(setq rmcomments ""))
    (SETQ PTINFO (STRCAT ormtype "state=\""  rmstate "\"" ormrefdp  ormcondition rmcomments " />" ));Note comment for desc in xml added to distance entry seperated by a space
(SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 PTINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)

					       (setq drawnrmlist (append drawnrmlist (list (strcat setupid "-" rmtype))))
					       
					       ;tool to remove drawn rm (in case there are two rms on the same point (yes it happens i.e. gone & non peg corner mark)
(setq rmnth (vl-position setupid rmlist))
(setq rmlist (remove_nth rmlist  rmnth ))
(setq rmlist (remove_nth rmlist  rmnth ))
					       
));pand if PM is RM on point 1			     



(IF (and (setq pos1 (vl-position targetid rmlist))(= (member (strcat targetid "-" rmtype) drawnrmlist) nil))(progn
					       (setq monline (nth (+ pos1 1) rmlist))
					       
					       
		 (if (/= (setq stringpos (vl-string-search "type" monline )) nil)(progn
(setq stringpos (vl-string-search "type" monline ))(setq wwpos (vl-string-position 34 monline (+ stringpos 6)))(setq rmtype (substr monline (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5))))
(if (/= (setq stringpos (vl-string-search "&amp;" rmtype )) nil) (setq rmtype (vl-string-subst "&" "&amp;" rmtype)))
)(setq rmtype ""))
 (if (/= (setq stringpos (vl-string-search "state" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 7)))(setq rmstate (substr monline (+ stringpos 8) (-(- wwpos 1)(+ stringpos 6)))))(setq rmstate ""))
(if (/= (setq stringpos (vl-string-search "condition" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 11)))(setq rmcondition (substr monline (+ stringpos 12) (-(- wwpos 1)(+ stringpos 10)))))(setq rmcondition ""))
(if (/= (setq stringpos (vl-string-search "desc" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 6)))(setq rmcomment (substr monline (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5)))))(setq rmcomment ""))
(setq &pos 0)
	      (while (/=  (setq &pos (vl-string-search "&amp;" rmcomment &pos )) nil) (setq rmcomment (vl-string-subst "&" "&amp;"  rmcomment &pos)
										      &pos (+ &pos 1)))
					       (setq quotpos 0)
	(while (/=  (setq quotpos (vl-string-search "&quot;" rmcomment quotpos )) nil) (setq rmcomment (vl-string-subst "\"" "&quot;"  rmcomment 	quotpos)
										      quotpos (+ quotpos 1)))
					      (setq apos 0)
	(while (/=  (setq apos (vl-string-search "&apos;" rmcomment apos )) nil) (setq rmcomment (vl-string-subst "'" "&apos;"  rmcomment apos)
										      apos (+ apos 1)))

(if (/= (setq stringpos (vl-string-search "originSurvey" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 14)))(setq rmrefdp (substr monline (+ stringpos 15) (-(- wwpos 1)(+ stringpos 13)))))(setq rmrefdp ""))
			       
  (SETVAR "CLAYER" "Monument" )
  (COMMAND "POINT" lp2c)

  ;check for no values and replace with "none"
  (if (/= rmrefdp "")(setq ormrefdp (strcat " originSurvey=\"" rmrefdp "\""))(setq ormrefdp ""))
  (if (/= rmcondition "")(setq ormcondition ( strcat " condition=\"" rmcondition "\""))(setq ormcondition ""))
  (if (/= rmtype "")(setq ormtype ( strcat "type=\"" rmtype "\" "))(setq ormtype ""))

    (if (/= rmcomment "")(setq rmcomments (strcat " desc=\"" rmcomment "\""))(setq rmcomments ""))
    (SETQ PTINFO (STRCAT ormtype "state=\""  rmstate "\"" ormrefdp  ormcondition rmcomments " />" ));Note comment for desc in xml added to distance entry seperated by a space
(SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 PTINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)

					       (setq drawnrmlist (append drawnrmlist (list (strcat targetid "-" rmtype))))

					       ;tool to remove drawn rm (in case there are two rms on the same point (yes it happens i.e. gone & non peg corner mark)
(setq rmnth (vl-position targetid rmlist))
(setq rmlist (remove_nth rmlist  rmnth ))
(setq rmlist (remove_nth rmlist  rmnth ))
					       
));pand if PM is RM on point 2			     




      );p

    );if pm connection

	  


	        ;if nothing at either end of line
	    (if (= (or (vl-position setupid pmlist)(vl-position targetid pmlist)(vl-position targetid rmlist)(vl-position setupid rmlist)) nil)(progn

      (SETVAR "CLAYER" rolayer )
      (if (vl-position  (strcat lp1c "," curvecenc "," lp2c "," rolayer) arclist)()
  (progn

    (setq eccount 0)
		(repeat (length errorcodelist)
		  (setq errorcode (nth eccount errorcodelist))
		  (if (and (vl-string-search errorcode (strcase comment ))(= (getvar "CECOLOR") "BYLAYER"))(setvar "CECOLOR" "30"))
		(setq eccount (+ eccount 1))
		  )
    

    
       (if (= curverot "ccw") (command "arc" "c" curvecenc lp1c lp2c)(command "arc" "c" curvecenc lp2c lp1c))
      
  (if (/= comment "")(setq ocomment (strcat "><FieldNote>\"" comment "\"</FieldNote></ReducedArcObservation>"))(setq ocomment "/>"))
(SETQ BDINFO (STRCAT "chordAzimuth=\"" xbearing "\" length=\"" arclength "\" radius=\"" radius  "\" rot=\"" curverot "\""  arcType ocomment))
(SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 BDINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)

     
      
(if (vl-position (strcat lp1c "," curvecenc "," lp2c "," rolayer) arclist)()(lbarc));label line if not already labelled;label arc using function
(if (/= (getvar "CECOLOR") "BYLAYER") (setvar "CECOLOR" "BYLAYER"))
))


      
      );p

    );if nothing at either end of line
     (setq arclist (append arclist (list (strcat lp1c"," curvecenc "," lp2c "," rolayer))))

	    	    ));pif arc


;------------------------------------------------------------------------------POINT--------------------
	(if (/= (vl-string-search "<RedHorizontalPosition" linetext ) nil)
	    (progn
	      
	      

	    (setq stringpos (vl-string-search "setupID" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 9)))
            (setq setupids (strcat "IS-" (substr linetext (+ stringpos 10) (-(- wwpos 1)(+ stringpos 8)))))
	    (setq pos1 (vl-position setupids islist))
	    (setq setupid (nth (+ pos1 1) islist))

	    (setq stringpos (vl-string-search "latitude" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 10)))
            (setq latitude (substr linetext (+ stringpos 11) (-(- wwpos 1)(+ stringpos 9))))

	    (setq stringpos (vl-string-search "longitude" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 11)))
            (setq longitude (substr linetext (+ stringpos 12) (-(- wwpos 1)(+ stringpos 10))))

	    (setq stringpos (vl-string-search "class" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 7)))
            (setq class (substr linetext (+ stringpos 8) (-(- wwpos 1)(+ stringpos 6))))

	    (if (setq stringpos (vl-string-search "order" linetext ))(progn
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 7)))
            (setq order (substr linetext (+ stringpos 8) (-(- wwpos 1)(+ stringpos 6))))
	    )
	      (setq order nil)
	      )

	    (if (setq stringpos (vl-string-search "positionalUncertainty" linetext ))(progn
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 23)))
            (setq punc (substr linetext (+ stringpos 24) (-(- wwpos 1)(+ stringpos 22))))
	    )
	      (setq punc nil)
	      )

	    (if (and (= order nil)(= punc nil))(setq punc "N/A"))

	    (setq stringpos (vl-string-search "currencyDate" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 14)))
            (setq currencydate (substr linetext (+ stringpos 15) (-(- wwpos 1)(+ stringpos 13))))

  	    (if (setq stringpos (vl-string-search "horizontalFix=" linetext ))(progn
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 15)))
            (setq horizontalFix (substr linetext (+ stringpos 16) (-(- wwpos 1)(+ stringpos 14)))))(setq horizontalFix nil))

	    ;Spaced out DSM type
  	    (if (setq stringpos (vl-string-search "horizontalFix = " linetext ))(progn
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 17)))
            (setq horizontalFixDSM (substr linetext (+ stringpos 18) (-(- wwpos 1)(+ stringpos 16)))))(setq horizontalFixDSM nil))
	    (if (and (= horizontalFix nil)(/= horizontalFixDSM nil))(setq horizontalFix horizontalFixDSM))
	    

   	    (if (setq stringpos (vl-string-search "horizontalDatum=" linetext ))(progn
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 17)))
            (setq horizontalDatum (substr linetext (+ stringpos 18) (-(- wwpos 1)(+ stringpos 16)))))(setq horizontalDatum nil))

	    ;Spaced out DSM type
  	    (if (setq stringpos (vl-string-search "horizontalDatum = " linetext ))(progn
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 19)))
            (setq horizontalDatumDSM (substr linetext (+ stringpos 20) (-(- wwpos 1)(+ stringpos 18)))))(setq horizontalDatumDSM nil))
	    (if (and (= horizontalDatum nil)(/= horizontalFixDSM nil))(setq horizontalDatum horizontalDatumDSM))
    
	      (if (/= (setq stringpos (vl-string-search "<FieldNote>" linetext )) nil)(progn
											   
(if (setq wwpos (vl-string-position 34 linetext (+ stringpos 12)))
  (progn;if field not contains ""s
    (setq comment (substr linetext (+ stringpos 13) (-(- wwpos 1)(+ stringpos 11))))
    )
  (progn; else use the < to get other end of field note
    (setq <pos (vl-string-position 60 linetext (+ stringpos 11)))
    (setq comment (substr linetext (+ stringpos 12) (-(- <pos 1)(+ stringpos 10))))
    )
  )
)
		
  (setq comment ""))

	     ;case if fieldnote is linefed
	     (if (and (=  (vl-string-search "/>" linetext ) nil)(=  (vl-string-search "</RedHorizontalPosition>" linetext ) nil))(progn
									     (linereader)
									     

(if (/= (setq stringpos (vl-string-search "<FieldNote>" linetext )) nil)(progn
											   
(if (setq wwpos (vl-string-position 34 linetext (+ stringpos 12)))
  (progn;if field not contains ""s
    (setq comment (substr linetext (+ stringpos 13) (-(- wwpos 1)(+ stringpos 11))))
    )
  (progn; else use the < to get other end of field note
    (setq <pos (vl-string-position 60 linetext (+ stringpos 11)))
    (setq comment (substr linetext (+ stringpos 12) (-(- <pos 1)(+ stringpos 10))))
    )
  )

))
									     
									     ))

	    (setq &pos 0)

	    
(while (/=  (setq &pos (vl-string-search "&amp;" comment &pos )) nil) (setq comment (vl-string-subst "&" "&amp;"  comment &pos)
										      &pos (+ &pos 1)))
	    (setq quotpos 0)
	(while (/=  (setq quotpos (vl-string-search "&quot;" comment quotpos )) nil) (setq comment (vl-string-subst "\"" "&quot;"  comment 	quotpos)
										      quotpos (+ quotpos 1)))
					      (setq apos 0)
	(while (/=  (setq apos (vl-string-search "&apos;" comment apos )) nil) (setq comment (vl-string-subst "'" "&apos;"  comment apos)
										      apos (+ apos 1)))
	    

	    
	    (setq pos1 (vl-position setupid cgpointlist))
            (setq lp1c (nth (+ pos1 1) cgpointlist))

	    (setq pos2 (vl-position setupid drawpmlist))
	    (setq pmnum (nth (+ pos2 1) drawpmlist))
	    (setq pmstate (nth (+ pos2 2) drawpmlist))
		  
	    (SETVAR "CLAYER"  "PM" )
	    
	    (setq ,pos1 (vl-string-position 44 lp1c 0))
                 (setq east (atof (substr lp1c 1 ,pos1)))
      		 (setq north (atof (substr lp1c (+ ,pos1 2) 50)))
					   (setq lp1c (list east north))

	      (COMMAND "POINT" lp1c)

	     (if (/= order nil)(setq ordertype "\"  order=\""
				     ordero order))
	    (if (/= punc nil) (setq ordertype "\" positionalUncertainty=\""
		    ordero punc))
	    (if (= punc "N/A")(setq ordertype ""
				   ordero ""))
	    

		 (SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
	    (if (/= comment "")(setq ocomment (strcat "><FieldNote>\"" comment "\"</FieldNote></RedHorizontalPosition>"))(setq ocomment "/>"))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 (strcat pmnum ",latitude=\"" latitude "\" longitude=\"" longitude "\" class=\""class ordertype ordero "\" horizontalFix=\"" horizontalFix "\" horizontalDatum=\"" horizontaldatum "\" currencyDate=\"" currencydate "\"" ocomment "!"pmstate))))));@@@@change to xml format
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)

	    
	    ;rearrage currency date to dd.mm.yyyy format for text output
  (setq minuspos1 (vl-string-position 45 currencydate 0))
  (setq minuspos2 (vl-string-position 45 currencydate (+ minuspos1 1)))
  (if  (= minuspos1 4)(progn;rearrage date to year last
				       (setq year  (substr currencydate 1 minuspos1))
				       (if (= (strlen year) 1) (setq year (strcat "0" year)));single digit days
				       (setq month (substr currencydate (+ minuspos1 2) (- (- minuspos2 minuspos1) 1)))
				       (if (= (strlen month) 1) (setq month (strcat "0" month)));single digit days
				       (setq day  (substr currencydate (+ minuspos2 2) 50))
				       (setq currencydate (strcat day "-" month "-" year))
				       ));p&if

	    

(SETVAR "CLAYER"  "Drafting" )
	    (if (= daf1 "")(setq daf1 "N/A"))
	    (if (= horizontalDatum "")(setq horizontalDatum "N/A")) 

	     (if (= pmboxmark nil)(progn
			 (setq pmboxmark (list (+ maxeast (* 10 th)) (- minnorth (* 2 th))))
			 (setq p10 (list (+ (car pmboxmark) (* 97 th))(+ (cadr pmboxmark) (* -2.5 th))))
			 (setq p11 (list (+ (car pmboxmark) 0)(+ (cadr pmboxmark) (* -2.5 th))))
			 (setq p12 (list (+ (car pmboxmark) (* th 48.5))(+ (cadr pmboxmark) (* -1.25 th))))
			 (command "rectangle" pmboxmark p10)
			 (command "text" "j" "mc" p12 th "90" "COORDINATE SCHEDULE")
			 (setq pmboxmark p11)

			 (setq p10 (list (+ (car pmboxmark) (* 97 th))(+ (cadr pmboxmark) (* -2.5 th))))
			 (setq p11 (list (+ (car pmboxmark) 0)(+ (cadr pmboxmark) (* -2.5 th))))
			 (setq p122 (list (+ (car pmboxmark) (* th 48.5))(+ (cadr pmboxmark) (* -1.25 th))))
			 (command "rectangle" pmboxmark p10)
			 ;removed coordinate info box and put at end
			 (setq pmboxmark p11)
			 ;box corners
			 (setq p10 (list (+ (car pmboxmark) 0)(+ (cadr pmboxmark) (* -2.5 th))))
			 (setq p11 (list (+ (car pmboxmark) (* 12 th))(+ (cadr pmboxmark)  0 )))
			 (setq p12 (list (+ (car pmboxmark) (* 25 th))(+ (cadr pmboxmark) (* -2.5 th))))
			 (setq p13 (list (+ (car pmboxmark) (* 39 th))(+ (cadr pmboxmark)  0 )))
			 (setq p14 (list (+ (car pmboxmark) (* 45 th))(+ (cadr pmboxmark) (* -2.5 th))))
			 (setq p15 (list (+ (car pmboxmark) (* 51 th))(+ (cadr pmboxmark)  0 )))
			 (setq p16 (list (+ (car pmboxmark) (* 69 th))(+ (cadr pmboxmark) (* -2.5 th))))
			 (setq p17 (list (+ (car pmboxmark) (* 77 th))(+ (cadr pmboxmark)  0 )))
			 (setq p18 (list (+ (car pmboxmark) (* 87 th))(+ (cadr pmboxmark) (* -2.5 th))))
                         (setq p19 (list (+ (car pmboxmark) (* 97 th))(+ (cadr pmboxmark) 0)))
			 
			 ;draw boxes
			 (command "rectangle" p10 p11)
			 (command "rectangle" p11 p12)
			 (command "rectangle" p12 p13)
			 (command "rectangle" p13 p14)
			 (command "rectangle" p14 p15)
			 (command "rectangle" p15 p16)
			 (command "rectangle" p16 p17)
			 (command "rectangle" p17 p18)
			 (command "rectangle" p18 p19)
			 
			 ;text insertion points
			 (setq p20 (list (+ (car pmboxmark) (* 6 th))(+ (cadr pmboxmark)  (* -1.25 th ))))
			 (setq p21 (list (+ (car pmboxmark) (* 18.5 th))(+ (cadr pmboxmark)  (* -1.25 th ))))
			 (setq p22 (list (+ (car pmboxmark) (* 32 th))(+ (cadr pmboxmark)  (* -1.25 th ))))
			 (setq p23 (list (+ (car pmboxmark) (* 42 th))(+ (cadr pmboxmark)  (* -1.25 th ))))
			 (setq p24 (list (+ (car pmboxmark) (* 48 th))(+ (cadr pmboxmark)  (* -1.25 th ))))
			 (setq p25 (list (+ (car pmboxmark) (* 60 th))(+ (cadr pmboxmark)  (* -1.25 th ))))
			 (setq p26 (list (+ (car pmboxmark) (* 73 th))(+ (cadr pmboxmark)  (* -1.25 th ))))
			 (setq p27 (list (+ (car pmboxmark) (* 82 th))(+ (cadr pmboxmark)  (* -1.25 th ))))
                         (setq p28 (list (+ (car pmboxmark) (* 92 th))(+ (cadr pmboxmark)  (* -1.25 th ))))
			 
			 ;create text
			 (command "text" "j" "mc" p20 th "90" "MARK")
			 (command "text" "j" "mc" p21 th "90" "EAST")
			 (command "text" "j" "mc" p22 th "90" "NORTH")
			 (command "text" "j" "mc" p23 th "90" "CLASS")
			 (if (/= order nil)(command "text" "j" "mc" p24 th "90" "ORDER"))
			 (if (/= punc nil)(command "text" "j" "mc" p24 th "90" "PU"))
			 (command "text" "j" "mc" p25 th "90" "METHOD")
			 (command "text" "j" "mc" p26 th "90" "DATUM")
			 (command "text" "j" "mc" p27 th "90" "DATE")
			 (command "text" "j" "mc" p28 th "90" "STATE")
			 ;reset pm box mark point
			 (setq pmboxmark p10)
			 ));p&if no boxmark


  
  			;box corners
			 (setq p10 (list (+ (car pmboxmark) 0)(+ (cadr pmboxmark) (* -2.5 th))))
			 (setq p11 (list (+ (car pmboxmark) (* 12 th))(+ (cadr pmboxmark)  0 )))
			 (setq p12 (list (+ (car pmboxmark) (* 25 th))(+ (cadr pmboxmark) (* -2.5 th))))
			 (setq p13 (list (+ (car pmboxmark) (* 39 th))(+ (cadr pmboxmark)  0 )))
			 (setq p14 (list (+ (car pmboxmark) (* 45 th))(+ (cadr pmboxmark) (* -2.5 th))))
			 (setq p15 (list (+ (car pmboxmark) (* 51 th))(+ (cadr pmboxmark)  0 )))
			 (setq p16 (list (+ (car pmboxmark) (* 69 th))(+ (cadr pmboxmark) (* -2.5 th))))
			 (setq p17 (list (+ (car pmboxmark) (* 77 th))(+ (cadr pmboxmark)  0 )))
			 (setq p18 (list (+ (car pmboxmark) (* 87 th))(+ (cadr pmboxmark) (* -2.5 th))))
                         (setq p19 (list (+ (car pmboxmark) (* 97 th))(+ (cadr pmboxmark) 0)))
			 
			 ;draw boxes
			 (command "rectangle" p10 p11)
			 (command "rectangle" p11 p12)
			 (command "rectangle" p12 p13)
			 (command "rectangle" p13 p14)
			 (command "rectangle" p14 p15)
			 (command "rectangle" p15 p16)
			 (command "rectangle" p16 p17)
			 (command "rectangle" p17 p18)
	                 (command "rectangle" p18 p19)
			 
			 ;text insertion points
			 (setq p20 (list (+ (car pmboxmark) (* 6 th))(+ (cadr pmboxmark)  (* -1.25 th ))))
			 (setq p21 (list (+ (car pmboxmark) (* 18.5 th))(+ (cadr pmboxmark)  (* -1.25 th ))))
			 (setq p22 (list (+ (car pmboxmark) (* 32 th))(+ (cadr pmboxmark)  (* -1.25 th ))))
			 (setq p23 (list (+ (car pmboxmark) (* 42 th))(+ (cadr pmboxmark)  (* -1.25 th ))))
			 (setq p24 (list (+ (car pmboxmark) (* 48 th))(+ (cadr pmboxmark)  (* -1.25 th ))))
			 (setq p25 (list (+ (car pmboxmark) (* 60 th))(+ (cadr pmboxmark)  (* -1.25 th ))))
			 (setq p26 (list (+ (car pmboxmark) (* 73 th))(+ (cadr pmboxmark)  (* -1.25 th ))))
			 (setq p27 (list (+ (car pmboxmark) (* 82 th))(+ (cadr pmboxmark)  (* -1.25 th ))))
                         (setq p28 (list (+ (car pmboxmark) (* 92 th))(+ (cadr pmboxmark)  (* -1.25 th ))))
			 
			 ;create text
			 (command "text" "j" "mc" p20 th "90" pmnum)
			 (command "text" "j" "mc" p21 th "90" (rtos (atof longitude) 2 3))
			 (command "text" "j" "mc" p22 th "90" (rtos (atof latitude) 2 3))
			 (command "text" "j" "mc" p23 th "90" class)
	    
			 (if (/= order nil)(command "text" "j" "mc" p24 th "90" order))
	                 (if (/= punc nil)(command "text" "j" "mc" p24 th "90" punc))
			 (command "text" "j" "mc" p25 th "90" horizontalfix)
			 (command "text" "j" "mc" p26 th "90" horizontaldatum)
			 (command "text" "j" "mc" p27 th "90" currencydate)
	                 (command "text" "j" "mc" p28 th "90" pmstate)
			 ;reset pm box mark point
			 (setq pmboxmark p10)

	    (if (= (vl-position pmnum drawnpmlist) nil)(progn
						    
	    (SETQ PMPOS LP1C)
	  (SETQ TEXTPOS (LIST (+ (CAR PMPOS) TH) (+ (CADR PMPOS) (* 0.5 TH))))

  (IF (= PMSTATE "Found")(SETQ PMNUMS (STRCAT PMNUM " FD")))
	    (IF (= PMSTATE "Placed")(SETQ PMNUMS (STRCAT PMNUM " PL")))
	    
		 (COMMAND "TEXT" "J" "BL"  TEXTPOS (* TH 1.4) "90" PMNUMS)
  

	    (setq drawnpmlist (append drawnpmlist (list pmnum)))
   ))
	    
	    (SETQ TEXTPOS (LIST (+ (CAR PMPOS) TH) (+ (CADR PMPOS) (* -1.25 TH))))
  (IF (and (/= class "U") (or (= horizontalfix "SCIMS" )(= horizontalfix "From SCIMS")))(COMMAND "TEXT" "J" "BL"  TEXTPOS (* TH 1.4) "90" "(EST)"))


	    ));p&if reduced point observation


		
;------------------------------------------------------------------------------BENCHMARK--------------------
	(if (/= (vl-string-search "<RedVerticalObservation" linetext ) nil)
	    (progn
	      
	      

	    (setq stringpos (vl-string-search "setupID" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 9)))
            (setq setupids (strcat "IS-" (substr linetext (+ stringpos 10) (-(- wwpos 1)(+ stringpos 8)))))
	    (setq pos1 (vl-position setupids islist))
	    (setq setupid (nth (+ pos1 1) islist))

	    (setq stringpos (vl-string-search "height" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 8)))
            (setq pmheight (substr linetext (+ stringpos 9) (-(- wwpos 1)(+ stringpos 7))))
	   
	    (setq stringpos (vl-string-search "class" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 7)))
            (setq pmclass (substr linetext (+ stringpos 8) (-(- wwpos 1)(+ stringpos 6))))
	    
	    (if (setq stringpos (vl-string-search "order" linetext ))(progn
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 7)))
            (setq order (substr linetext (+ stringpos 8) (-(- wwpos 1)(+ stringpos 6))))
	    )
	      (setq order nil)
	      )

	    (if (setq stringpos (vl-string-search "positionalUncertainty" linetext ))(progn
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 23)))
            (setq punc (substr linetext (+ stringpos 24) (-(- wwpos 1)(+ stringpos 22))))
	    )
	      (setq punc nil)
	      )

	    (if (and (= order nil)(= punc nil))(setq punc "N/A"))
	    
	    (if (/= (setq stringpos (vl-string-search "verticalFix" linetext )) nil)(progn
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 13)))
            (setq pmvalid (substr linetext (+ stringpos 14) (-(- wwpos 1)(+ stringpos 12)))))(setq pmvalid ""))

	    (if (/= (setq stringpos (vl-string-search "date" linetext )) nil)(progn
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 6)))
            (setq pmdate (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5)))))(setq pmdate ""))
	    
	    (setq stringpos (vl-string-search "verticalDatum" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 15)))
            (setq pmDatum (substr linetext (+ stringpos 16) (-(- wwpos 1)(+ stringpos 14))))
    
	      (if (/= (setq stringpos (vl-string-search "<FieldNote>" linetext )) nil)(progn
											   
(if (setq wwpos (vl-string-position 34 linetext (+ stringpos 12)))
  (progn;if field not contains ""s
    (setq comment (substr linetext (+ stringpos 13) (-(- wwpos 1)(+ stringpos 11))))
    )
  (progn; else use the < to get other end of field note
    (setq <pos (vl-string-position 60 linetext (+ stringpos 11)))
    (setq comment (substr linetext (+ stringpos 12) (-(- <pos 1)(+ stringpos 10))))
    )
  )
)
		
  (setq comment ""))

	     ;case if fieldnote is linefed
	     (if (and (=  (vl-string-search "/>" linetext ) nil)(=  (vl-string-search "</RedVerticalObservation>" linetext ) nil))(progn
									     (linereader)
									     

(if (/= (setq stringpos (vl-string-search "<FieldNote>" linetext )) nil)(progn
											   
(if (setq wwpos (vl-string-position 34 linetext (+ stringpos 12)))
  (progn;if field not contains ""s
    (setq comment (substr linetext (+ stringpos 13) (-(- wwpos 1)(+ stringpos 11))))
    )
  (progn; else use the < to get other end of field note
    (setq <pos (vl-string-position 60 linetext (+ stringpos 11)))
    (setq comment (substr linetext (+ stringpos 12) (-(- <pos 1)(+ stringpos 10))))
    )
  )

))
									     
									     ))

	    (setq &pos 0)

	    
(while (/=  (setq &pos (vl-string-search "&amp;" comment &pos )) nil) (setq comment (vl-string-subst "&" "&amp;"  comment &pos)
										      &pos (+ &pos 1)))
	    (setq quotpos 0)
	(while (/=  (setq quotpos (vl-string-search "&quot;" comment quotpos )) nil) (setq comment (vl-string-subst "\"" "&quot;"  comment 	quotpos)
										      quotpos (+ quotpos 1)))
					      (setq apos 0)
	(while (/=  (setq apos (vl-string-search "&apos;" comment apos )) nil) (setq comment (vl-string-subst "'" "&apos;"  comment apos)
										      apos (+ apos 1)))
	    

	    
	    (setq pos1 (vl-position setupid cgpointlist))
            (setq lp1c (nth (+ pos1 1) cgpointlist))

	    (setq pos2 (vl-position setupid drawpmlist))
	    (setq pmnum (nth (+ pos2 1) drawpmlist))
	    (setq pmstate (nth (+ pos2 2) drawpmlist))
		  
	    (SETVAR "CLAYER"  "PM" )
	    
	    (setq ,pos1 (vl-string-position 44 lp1c 0))
                 (setq east (atof (substr lp1c 1 ,pos1)))
      		 (setq north (atof (substr lp1c (+ ,pos1 2) 50)))
					   (setq lp1c (list east north))

	      (COMMAND "POINT" lp1c)

	     (if (/= order nil)(setq ordertype "\"  order=\""
		    ordero order))
	    (if (/= punc nil) (setq ordertype "\" positionalUncertainty=\""
		    ordero punc))
	    (if (= punc "N/A")(setq ordertype ""
				   ordero ""))
	    
	    (if (/= pmvalid "")(setq pmvalido (strcat "\" verticalFix=\"" pmvalid ))(setq pmvalido ""))
	    (if (/= pmdate "")(setq pmdates (strcat "\" date=\"" pmdate))(setq pmdates ""))
	    

		 (SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
	    (if (/= comment "")(setq ocomment (strcat "><FieldNote>\"" comment "\"</FieldNote></RedVerticalObservation>"))(setq ocomment "/>"))
 (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 (strcat pmnum ",height=\"" pmheight "\" class=\"" pmclass ordertype ordero pmvalido  "\" verticalDatum=\"" pmdatum pmdates "\"/>!"pmstate))))));@@@@change to xml format
  (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)

(if (/= pmdate "")
  (progn
	     ;rearrage currency date to dd.mm.yyyy format for text output
  (setq minuspos1 (vl-string-position 45 pmdate 0))
  (setq minuspos2 (vl-string-position 45 pmdate (+ minuspos1 1)))
  (if  (= minuspos1 4)(progn;rearrage date to year last
				       (setq year  (substr pmdate 1 minuspos1))
				       (if (= (strlen year) 1) (setq year (strcat "0" year)));single digit days
				       (setq month (substr pmdate (+ minuspos1 2) (- (- minuspos2 minuspos1) 1)))
				       (if (= (strlen month) 1) (setq month (strcat "0" month)));single digit days
				       (setq day  (substr pmdate (+ minuspos2 2) 50))
				       (setq pmdateo (strcat day "-" month "-" year))
				       ));p&if
  ))


  
  
(SETVAR "CLAYER"  "Drafting" )
  (if (= bmboxmark nil)(progn

			 
			 (setq bmboxmark (list (+ maxeast (* 110 th)) (- minnorth (* 2 th))))
			 (setq p10 (list (+ (car bmboxmark) (* 76 th))(+ (cadr bmboxmark) (* -5 th))))
			 (setq p11 (list (+ (car bmboxmark) 0)(+ (cadr bmboxmark) (* -5 th))))
			 (setq p12 (list (+ (car bmboxmark) (* th 38))(+ (cadr bmboxmark) (* -1.25 th))))
			 (setq p13 (list (+ (car bmboxmark) (* th 38))(+ (cadr bmboxmark) (* -3.75 th))))
			 (command "rectangle" bmboxmark p10)
			 (command "text" "j" "mc" p12 th "90" "HEIGHT SCHEDULLE")
			 (command "text" "j" "mc" p13 th "90" "HEIGHT DATUM: AHD71")
			 (setq bmboxmark p11)
                         
			 ;box corners
			 (setq p10 (list (+ (car bmboxmark) 0)(+ (cadr bmboxmark) (* -2.5 th))))
			 (setq p11 (list (+ (car bmboxmark) (* 12 th))(+ (cadr bmboxmark)  0 )))
			 (setq p12 (list (+ (car bmboxmark) (* 20 th))(+ (cadr bmboxmark) (* -2.5 th))))
			 (setq p13 (list (+ (car bmboxmark) (* 26 th))(+ (cadr bmboxmark)  0 )))
			 (setq p14 (list (+ (car bmboxmark) (* 32 th))(+ (cadr bmboxmark) (* -2.5 th))))
			 (setq p15 (list (+ (car bmboxmark) (* 59 th))(+ (cadr bmboxmark)  0 )))
			 (setq p16 (list (+ (car bmboxmark) (* 68 th))(+ (cadr bmboxmark) (* -2.5 th))))
			 (setq p17 (list (+ (car bmboxmark) (* 76 th))(+ (cadr bmboxmark)  0 )))
			 
			 ;draw boxes
			 (command "rectangle" p10 p11)
			 (command "rectangle" p11 p12)
			 (command "rectangle" p12 p13)
			 (command "rectangle" p13 p14)
			 (command "rectangle" p14 p15)
			 (command "rectangle" p15 p16)
			 (command "rectangle" p16 p17)
			 
			 ;text insertion points
			 (setq p20 (list (+ (car bmboxmark) (* 6 th))(+ (cadr bmboxmark)  (* -1.25 th ))))
			 (setq p21 (list (+ (car bmboxmark) (* 16 th))(+ (cadr bmboxmark)  (* -1.25 th ))))
			 (setq p22 (list (+ (car bmboxmark) (* 23 th))(+ (cadr bmboxmark)  (* -1.25 th ))))
			 (setq p23 (list (+ (car bmboxmark) (* 29 th))(+ (cadr bmboxmark)  (* -1.25 th ))))
			 (setq p24 (list (+ (car bmboxmark) (* 45.5 th))(+ (cadr bmboxmark)  (* -1.25 th ))))
			 (setq p25 (list (+ (car bmboxmark) (* 63.5 th))(+ (cadr bmboxmark)  (* -1.25 th ))))
			 (setq p26 (list (+ (car bmboxmark) (* 72 th))(+ (cadr bmboxmark)  (* -1.25 th ))))
			 
			 ;create text
			 (command "text" "j" "mc" p20 th "90" "MARK")
			 (command "text" "j" "mc" p21 th "90" "HEIGHT")
			 (command "text" "j" "mc" p22 th "90" "CLASS")
			 (if (/= order nil)(command "text" "j" "mc" p23 th "90" "ORDER"))
			 (if (/= punc nil)(command "text" "j" "mc" p23 th "90" "PU"))
			 (command "text" "j" "mc" p24 th "90" "HEIGHT DATUM VALIDATION")
			 (command "text" "j" "mc" p25 th "90" "STATE")
			 (command "text" "j" "mc" p26 th "90" "DATE")
			 ;reset pm box mark point
			 (setq bmboxmark p10)
			 ));p&if no boxmark


  
  			;box corners
			 (setq p10 (list (+ (car bmboxmark) 0)(+ (cadr bmboxmark) (* -2.5 th))))
			 (setq p11 (list (+ (car bmboxmark) (* 12 th))(+ (cadr bmboxmark)  0 )))
			 (setq p12 (list (+ (car bmboxmark) (* 20 th))(+ (cadr bmboxmark) (* -2.5 th))))
			 (setq p13 (list (+ (car bmboxmark) (* 26 th))(+ (cadr bmboxmark)  0 )))
			 (setq p14 (list (+ (car bmboxmark) (* 32 th))(+ (cadr bmboxmark) (* -2.5 th))))
			 (setq p15 (list (+ (car bmboxmark) (* 59 th))(+ (cadr bmboxmark)  0 )))
			 (setq p16 (list (+ (car bmboxmark) (* 68 th))(+ (cadr bmboxmark) (* -2.5 th))))
                         (setq p17 (list (+ (car bmboxmark) (* 76 th))(+ (cadr bmboxmark)  0 )))
			 
			 ;draw boxes
			 (command "rectangle" p10 p11)
			 (command "rectangle" p11 p12)
			 (command "rectangle" p12 p13)
			 (command "rectangle" p13 p14)
			 (command "rectangle" p14 p15)
                         (command "rectangle" p15 p16)
                         (command "rectangle" p16 p17)
			 
			 ;text insertion points
			 (setq p20 (list (+ (car bmboxmark) (* 6 th))(+ (cadr bmboxmark)  (* -1.25 th ))))
			 (setq p21 (list (+ (car bmboxmark) (* 16 th))(+ (cadr bmboxmark)  (* -1.25 th ))))
			 (setq p22 (list (+ (car bmboxmark) (* 23 th))(+ (cadr bmboxmark)  (* -1.25 th ))))
			 (setq p23 (list (+ (car bmboxmark) (* 29 th))(+ (cadr bmboxmark)  (* -1.25 th ))))
			 (setq p24 (list (+ (car bmboxmark) (* 45.5 th))(+ (cadr bmboxmark)  (* -1.25 th ))))
                         (setq p25 (list (+ (car bmboxmark) (* 63.5 th))(+ (cadr bmboxmark)  (* -1.25 th ))))
                         (setq p26 (list (+ (car bmboxmark) (* 72 th))(+ (cadr bmboxmark)  (* -1.25 th ))))
			 
			 ;create text
			 (command "text" "j" "mc" p20 th "90" pmnum)
			 (command "text" "j" "mc" p21 th "90" pmheight)
			 (command "text" "j" "mc" p22 th "90" pmclass)
			 (if (/= order nil)(command "text" "j" "mc" p23 th "90" order))
	                 (if (/= punc nil)(command "text" "j" "mc" p23 th "90" punc))
	    (if (= pmvalid "Null")(setq pmvalid ""))
			 (command "text" "j" "mc" p24 th "90" (strcase pmvalid))
                         (command "text" "j" "mc" p25 th "90" (strcase pmstate))
                         (if (/= pmdate "")(command "text" "j" "mc" p26 th "90" pmdateo))
  
			 ;reset pm box mark point
			 (setq bmboxmark p10)

			 
			 ;reset pm box mark point
			 (setq bmboxmark p10)


	    (if (= (vl-position pmnum drawnpmlist) nil)(progn
  (SETQ PMPOS LP1C)
	  (SETQ TEXTPOS (LIST (+ (CAR PMPOS) TH) (+ (CADR PMPOS) (* 0.5 TH))))

	    
  (IF (= PMSTATE "Found")(SETQ PMNUMS (STRCAT PMNUM " FD")))
	    (IF (= PMSTATE "Placed")(SETQ PMNUMS (STRCAT PMNUM " PL")))
	    
		 (COMMAND "TEXT" "J" "BL"  TEXTPOS (* TH 1.4) "90" PMNUMS)
  (SETQ TEXTPOS (LIST (+ (CAR PMPOS) TH) (+ (CADR PMPOS) (* -1.25 TH))))
  (IF (and (/= pmclass "U") (vl-string-search "SCIMS" pmvalid ))(COMMAND "TEXT" "J" "BL"  TEXTPOS (* TH 1.4) "90" "(EST)"))

	    (setq drawnpmlist (append drawnpmlist (list pmnum)))
))
   


	    ));p&if reduced vertical observation

								   

	    

		(linereader)
				));p and while not end of observation				 
;);p and if else i.e. <Survey>

;draw height difference box

		  (setq hdcount 0)
  
(SETVAR "CLAYER"  "Drafting" )
		  (repeat (/ (length vertobslist) 4)

		  


  (if (= hdboxmark nil)(progn

			 
			 (setq hdboxmark (list (+ maxeast (* 189 th)) (- minnorth (* 2 th))))
			 (setq p10 (list (+ (car hdboxmark) (* 61 th))(+ (cadr hdboxmark) (* -5 th))))
			 (setq p11 (list (+ (car hdboxmark) 0)(+ (cadr hdboxmark) (* -5 th))))
			 (setq p12 (list (+ (car hdboxmark) (* th 30.5))(+ (cadr hdboxmark) (* -1.25 th))))
			 (setq p13 (list (+ (car hdboxmark) (* th 30.5))(+ (cadr hdboxmark) (* -3.75 th))))
			 (command "rectangle" hdboxmark p10)
			 (command "text" "j" "mc" p12 th "90" "HEIGHT DIFFERENCE SCHEDULE")
			 (command "text" "j" "mc" p13 th "90" "HEIGHT DATUM: AHD71")
			 (setq hdboxmark p11)
                         
			 ;box corners
			 (setq p10 (list (+ (car hdboxmark) 0)(+ (cadr hdboxmark) (* -2.5 th))))
			 (setq p11 (list (+ (car hdboxmark) (* 12 th))(+ (cadr hdboxmark)  0 )))
			 (setq p12 (list (+ (car hdboxmark) (* 24 th))(+ (cadr hdboxmark) (* -2.5 th))))
			 (setq p13 (list (+ (car hdboxmark) (* 40 th))(+ (cadr hdboxmark)  0 )))
			 (setq p14 (list (+ (car hdboxmark) (* 61 th))(+ (cadr hdboxmark) (* -2.5 th))))
			 
			 
			 ;draw boxes
			 (command "rectangle" p10 p11)
			 (command "rectangle" p11 p12)
			 (command "rectangle" p12 p13)
			 (command "rectangle" p13 p14)
			 
			 
			 ;text insertion points
			 (setq p20 (list (+ (car hdboxmark) (* 6 th))(+ (cadr hdboxmark)  (* -1.25 th ))))
			 (setq p21 (list (+ (car hdboxmark) (* 18 th))(+ (cadr hdboxmark)  (* -1.25 th ))))
			 (setq p22 (list (+ (car hdboxmark) (* 32 th))(+ (cadr hdboxmark)  (* -1.25 th ))))
			 (setq p23 (list (+ (car hdboxmark) (* 50.5 th))(+ (cadr hdboxmark)  (* -1.25 th ))))
			 
			 
			 ;create text
			 (command "text" "j" "mc" p20 th "90" "FROM")
			 (command "text" "j" "mc" p21 th "90" "TO")
			 (command "text" "j" "mc" p22 th "90" "HEIGHT DIFFERENCE")
			 (command "text" "j" "mc" p23 th "90" "METHOD")
			 
			 ;reset pm box mark point
			 (setq hdboxmark p10)
			 ));p&if no boxmark


		    (setq p1pm (nth hdcount vertobslist))
		    (setq p2pm (nth (+ hdcount 1) vertobslist))
		    (setq hd (nth (+ hdcount 2) vertobslist))
		    (setq hdt (nth (+ hdcount 3) vertobslist))
  
  			;box corners
			(setq p10 (list (+ (car hdboxmark) 0)(+ (cadr hdboxmark) (* -2.5 th))))
			 (setq p11 (list (+ (car hdboxmark) (* 12 th))(+ (cadr hdboxmark)  0 )))
			 (setq p12 (list (+ (car hdboxmark) (* 24 th))(+ (cadr hdboxmark) (* -2.5 th))))
			 (setq p13 (list (+ (car hdboxmark) (* 40 th))(+ (cadr hdboxmark)  0 )))
			 (setq p14 (list (+ (car hdboxmark) (* 61 th))(+ (cadr hdboxmark) (* -2.5 th))))
			 
			 ;draw boxes
			 (command "rectangle" p10 p11)
			 (command "rectangle" p11 p12)
			 (command "rectangle" p12 p13)
			 (command "rectangle" p13 p14)
			
			 
			 ;text insertion points
			 (setq p20 (list (+ (car hdboxmark) (* 6 th))(+ (cadr hdboxmark)  (* -1.25 th ))))
			 (setq p21 (list (+ (car hdboxmark) (* 18 th))(+ (cadr hdboxmark)  (* -1.25 th ))))
			 (setq p22 (list (+ (car hdboxmark) (* 32 th))(+ (cadr hdboxmark)  (* -1.25 th ))))
			 (setq p23 (list (+ (car hdboxmark) (* 50.5 th))(+ (cadr hdboxmark)  (* -1.25 th ))))
			 
			 
			 ;create text
			 (command "text" "j" "mc" p20 th "90" P1PM)
			 (command "text" "j" "mc" p21 th "90" P2PM)
			 (command "text" "j" "mc" p22 th "90" hd)
			 (command "text" "j" "mc" p23 th "90" hdt)
			 
			 ;reset pm box mark point
			 (setq hdboxmark p10)

		    (setq hdcount (+ hdcount 4))
		    )


		  
  
;14. Add all monument point offsets
					    
(setq count 1)
  (if (> (length occlist) 0)(progn
(repeat (/ (length occlist)2)
  (setq mon (nth count occlist))
  (setq pnum (nth (- count 1) occlist))
  ;get type
  (setq stringpos (vl-string-search "type" mon ))
	    (setq wwpos (vl-string-position 34 mon (+ stringpos 6)))
            (setq rmtype (substr mon (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5))))
;get state if it exists
  (if (/= (setq stringpos (vl-string-search "state" mon )) nil)(progn
(setq wwpos (vl-string-position 34 mon (+ stringpos 7)))(setq rmstate (substr mon (+ stringpos 8) (-(- wwpos 1)(+ stringpos 6)))))(setq rmstate ""))
  ;get condition if it exists
  (if (/= (setq stringpos (vl-string-search "condition" mon )) nil)(progn
(setq wwpos (vl-string-position 34 mon (+ stringpos 11)))(setq rmcondition (substr mon (+ stringpos 12) (-(- wwpos 1)(+ stringpos 10)))))(setq rmcondition ""))
;get redef
 (if (/= (setq stringpos (vl-string-search "originSurvey" mon )) nil)(progn
(setq wwpos (vl-string-position 34 mon (+ stringpos 14)))(setq rmrefdp (substr mon (+ stringpos 15) (-(- wwpos 1)(+ stringpos 13))))
   (setq &pos 0)
	      (while (/=  (setq &pos (vl-string-search "&amp;" rmrefdp &pos )) nil) (setq rmrefdp (vl-string-subst "&" "&amp;"  rmrefdp &pos)
										      &pos (+ &pos 1)))
(setq quotpos 0)
	(while (/=  (setq quotpos (vl-string-search "&quot;" rmrefdp quotpos )) nil) (setq rmrefdp (vl-string-subst "\"" "&quot;"  rmrefdp 	quotpos)
										      quotpos (+ quotpos 1)))
					      (setq apos 0)
	(while (/=  (setq apos (vl-string-search "&apos;" rmrefdp apos )) nil) (setq rmrefdp (vl-string-subst "'" "&apos;"  rmrefdp apos)
										      apos (+ apos 1)))
)

   (setq rmrefdp ""))

			       ;get description
			       (setq stringpos (vl-string-search "desc" mon ))
			        (setq wwpos (vl-string-position 34 mon (+ stringpos 6)))
            (setq rmdesc (substr mon (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5))))
  
(setq pos1 (vl-position pnum cgpointlist))
            (setq lp1c (nth (+ pos1 1) cgpointlist))
	    (setq ,pos1 (vl-string-position 44 lp1c 0))
                 (setq east (atof (substr lp1c 1 ,pos1)))
      		 (setq north (atof (substr lp1c (+ ,pos1 2) 50)))
					   (setq occpnt (list east north))

  (if (= (substr rmdesc 1 2) "( ")(setq rmdesc (strcat (substr rmdesc 1 1)(substr rmdesc 3 ))));fix odd space in Landmark occupation offset
			       
			       (if (or (and (>= (ascii rmdesc) 48)(<= (ascii rmdesc) 57))(and (= (substr rmdesc 1 1) "(")(>= (ascii (substr rmdesc 2 1)) 48)(<= (ascii (substr rmdesc 2 1)) 57)))
				 (progn;is normal offset either number of bracketted number

				   (if (setq ,pos1 (vl-string-position 44 rmdesc 0))(progn;look for road offset type

						(setq  offset1   (substr rmdesc 1 ,pos1 ))
						(setq  offset2   (substr rmdesc (+ ,pos1 2) 200 ))
				   (setq 2textpos (polar occpnt (* 1.5 pi)  (* th 1.2) ))
						(setvar "clayer" "Occupations")
	(command "point" lp1c)
	(if (/= rmrefdp "")(setq ormrefdp (strcat "\" originSurvey=\"" rmrefdp "\" "))(setq ormrefdp ""))
	(if (/= rmcondition "")(setq ormcondition (strcat "\" condition=\"" rmcondition "\" "))(setq ormcondition ""))
  	(SETQ BDINFO (STRCAT "type=\"Occupation\" state=\"" rmstate "\" desc=\"" rmdesc "\"" ormrefdp ormcondition"/>"))
 (SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 BDINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)

				  

					  (setvar "clayer" "Drafting")
	(COMMAND "TEXT" "J" "BL" lp1c TH "90" offset1)
				   (COMMAND "TEXT" "J" "BL" 2textpos TH "90" offset2)

										       
										       );p
				     (progn;else - i.e. standard offset
	   
				   (setvar "clayer" "Occupations")
				   	(command "point" occpnt)
				   (if (/= rmrefdp "")(setq ormrefdp (strcat "\" originSurvey=\"" rmrefdp "\" "))(setq ormrefdp ""))
				   (if (/= rmcondition "")(setq ormcondition (strcat "\" condition=\"" rmcondition "\" "))(setq ormcondition ""))
  	(SETQ BDINFO (STRCAT "type=\"Occupation\" state=\"" rmstate "\" desc=\"" rmdesc "\"" ormrefdp ormcondition"/>"))
  	
 (SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 BDINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)
				   ;search line list to find the line or arc which is the offset is a closest match
				   (if (= (ascii rmdesc) 40)(progn
							    (setq rmdesc (vl-string-subst  "" "(" rmdesc))
							    (setq rmdesc (vl-string-subst  "" ")" rmdesc ))
							    ));remove brackets
				   (setq offset (atof rmdesc))
				   (setq offsetdiff 100000000000000000000000000000000000000000000.0)
				   (setq lcount 0)
				   
				   (repeat (length linelist)
				     (setq line (nth lcount linelist))
				     (setq ,pos1 (vl-string-position 44 line 0))
                                     (setq ,pos2 (vl-string-position 44 line (+ ,pos1 1)))
                                     (setq ,pos3 (vl-string-position 44 line (+ ,pos2 1)))
				     (setq ,pos4 (vl-string-position 44 line (+ ,pos3 1)))

				     (setq  x1   (atof(substr line 1 ,pos1 )))
      (setq  y1   (atof(substr line (+ ,pos1 2) (- (- ,pos2 ,pos1) 1)) ))
      (setq  x2  (atof(substr line (+ ,pos2 2) (- (- ,pos3 ,pos2) 1)) ))
      (setq  y2  (atof(substr line (+ ,pos3 2) (- (- ,pos4 ,pos3) 1)) ))
				     (setq p1 (list x1 y1))
				     (setq p2 (list x2 y2))

				     (SETQ LANG (ANGLE P1 P2))
  (SETQ CANG (+ LANG (/ PI 2)))
  (SETQ P4 (POLAR occpnt CANG 50))
  (SETQ P6 (POLAR occpnt (+ CANG PI) 50))
   
   (SETQ interpnt (INTERS P1 P2 P6 P4 nil))					
 
      (SETQ offsetdiffcheck (abs (- (DISTANCE occpnt interpnt) offset)))
				     (if (< offsetdiffcheck offsetdiff)(progn
      (setq p5 interpnt)
  (setq mp (list (/ (+ (car occpnt)(car p5)) 2)(/ (+ (cadr occpnt)(cadr p5)) 2)))
  (setq ang (angle occpnt p5))
  (if (and (> ang  (* 0.5 pi))(< ang (* 1.5 pi)))(setq ang (- ang pi)))
  (if (< ang 0)(setq ang (+ ang (* 2 pi))))
      

  (setq offsetdiff offsetdiffcheck)
  
  ));p&if offsetdiffcheck
				     (setq lcount (+ lcount 1))
  );repeat linelist length

		(setq lcount 0)		   
				    (repeat (length arclist)
				     (setq line (nth lcount arclist))
				     (setq ,pos1 (vl-string-position 44 line 0))
                                     (setq ,pos2 (vl-string-position 44 line (+ ,pos1 1)))
                                     (setq ,pos3 (vl-string-position 44 line (+ ,pos2 1)))
				     (setq ,pos4 (vl-string-position 44 line (+ ,pos3 1)))
				     (setq ,pos5 (vl-string-position 44 line (+ ,pos4 1)))

				     (setq  x1   (atof(substr line 1 ,pos1 )))
      (setq  y1   (atof(substr line (+ ,pos1 2) (- (- ,pos2 ,pos1) 1)) ))
      (setq  cx  (atof(substr line (+ ,pos2 2) (- (- ,pos3 ,pos2) 1)) ))
      (setq  cy  (atof(substr line (+ ,pos3 2) (- (- ,pos4 ,pos3) 1)) ))
      
				     (setq p1 (list x1 y1))
				     (setq cp (list cx cy))
				      (setq offsetdiffcheck (abs(- (abs (- (distance cp occpnt)(distance cp p1)))offset)));check distance from point to cp and p1

				     					
 
      
				     (if (< offsetdiffcheck offsetdiff)(progn
  (setq p5 (polar cp (angle cp occpnt) (distance cp p1)))
  (setq mp (list (/ (+ (car occpnt)(car p5)) 2)(/ (+ (cadr occpnt)(cadr p5)) 2)))
  (setq ang (angle p5 occpnt))
 
  (if (and (> ang  (* 0.5 pi))(< ang (* 1.5 pi)))(setq ang (- ang pi)))
  (if (< ang 0)(setq ang (+ ang (* 2 pi))))
    

  (setq offsetdiff offsetdiffcheck)
  
  

));p&if offsetdiffcheck
				      (setq lcount (+ lcount 1))
  );repeat arclist length


				   
				   				   		(if (> offset (* th 7))(setq tpos mp
													  just "MC"))

					  (if (and (< offset (* th 7))(>= (angle occpnt p5) (* 0.5 pi))(<= (angle occpnt p5)(* 1.5 pi)))(setq tpos p5
																	 just "MR"))
					  (if (and (< offset (* th 7))(or(<= (angle occpnt p5) (* 0.5 pi))(>= (angle occpnt p5)(* 1.5 pi))))(setq tpos p5
																	 just "ML"))
					  (setvar "clayer" "Drafting")

				   (if (/= (setq stringpos (vl-string-search "Clear" rmdesc )) nil) (setq rmdesc (vl-string-subst "Cl" "Clear" rmdesc)))
				   (if (/= (setq stringpos (vl-string-search "Over" rmdesc )) nil) (setq rmdesc (vl-string-subst "Ov" "Over" rmdesc)))
				     
	(COMMAND "TEXT" "J" just tpos TH (ANGTOS ANG 1 4) (strcat "(" (strcase rmdesc) ")"))
				   ));p else &if comma found
					  );p



				 
				 (progn;else queensland style or on point
				     (setvar "clayer" "Occupations")
				   	(command "point" lp1c)
				   (if (/= rmrefdp "")(setq ormrefdp (strcat "\" originSurvey=\"" rmrefdp "\" "))(setq ormrefdp ""))
				(if (/= rmcondition "")(setq ormcondition (strcat "\" condition=\"" rmcondition "\" "))(setq ormcondition ""))
  	(SETQ BDINFO (STRCAT "type=\"Occupation\" state=\"" rmstate "\" desc=\"" rmdesc "\"" ormrefdp ormcondition"/>"))
  	
 (SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 BDINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)

	(setq p1 occpnt
	      rmcomment rmdesc)
	
(lcm)
				   
					  ));p&if 48<ascii<57
			       

  (setq count (+ count 2)) 
  );repeat
	));if occlist exists

  (IF (> (LENGTH DRAWPMLIST) 0)(PROGN
;add line of text about coordinate system to coord box
  (SETVAR "CLAYER" "Drafting" )
  (command "text" "j" "mc" p122 th "90" (strcat  horizontalDatum " COORDINATES ZONE " zone " CSF: " daf1))
))

  (if (/= shpurpose "Strata Plan")(progn
  ;15. add pops-------------------------
    (SETVAR "CLAYER" "Drafting" )
(setq count 0)
  (repeat (length poplist)
    (setq ppt (nth count poplist))
   (COMMAND "._INSERT" "POP" "_S" TH ppt "0");changed for BricsCAD
;  (SETQ RMB (ENTLAST))
;  (SETQ ENTSS (SSADD))
;  (SSADD RMB ENTSS)
;(COMMAND "DRAWORDER" ENTSS "" "FRONT")
  (setq count (+ count 1))
    );repeat

    ))

  ;16. add pms--------------------------
  (setq count 0)
  (if (> (length drawpmlist) 0)(progn
  (repeat (/ (length drawpmlist)3)
    (setq PPT (nth count drawpmlist))
    
      (setq pos1 (vl-position PPT cgpointlist))
            (setq PMPOS (nth (+ pos1 1) cgpointlist))
 (setq ,pos1 (vl-string-position 44 PMPOS 0))
                 (setq east (atof (substr PMPOS 1 ,pos1)))
      		 (setq north (atof (substr PMPOS (+ ,pos1 2) 50)))
					   (setq PMPOS (list east north))
    
     (setq PMNUM (nth (+ count 1) drawpmlist))

       
  ;DRAW PM BLOCK AND ADD PM TEXT (NOTE POINT IS INSERTED WITH REDUCED POSITION OBSERVATION)
    
   (COMMAND "._INSERT" "PM" "_S" TH pmpos "0");edited for Bricscad courtesy of CAD concepts 
;  (SETQ RMB (ENTLAST))
;  (SETQ ENTSS (SSADD))
;  (SSADD RMB ENTSS)
;(COMMAND "DRAWORDER" ENTSS "" "FRONT")
 
    
  (setq count (+ count 3))
    );repeat
  ));p&if drawpmlist


  ;17. check for any remaining RM's that are not connected to the survey, for example RM gone on adjoining boundary.
(setq count 0)
  (repeat (/(length rmlist) 2)
    
    (setq setupid (nth count rmlist))
    (setq pos1 (vl-position setupid rmlist))

  	    (setq pos2 (vl-position setupid cgpointlist))
            (setq lp1c (nth (+ pos2 1) cgpointlist))
	    (setq p1type (nth (+ pos2 2) cgpointlist))
											  
												  
(setq monline (nth (+ pos1 1) rmlist))

 (if (/= (setq stringpos (vl-string-search "type" monline )) nil)(progn
(setq stringpos (vl-string-search "type" monline ))(setq wwpos (vl-string-position 34 monline (+ stringpos 6)))(setq rmtype (substr monline (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5))))
(if (/= (setq stringpos (vl-string-search "&amp;" rmtype )) nil) (setq rmtype (vl-string-subst "&" "&amp;" rmtype)))
)(setq rmtype ""))

    (if (and (/= rmtype "PM")(/= rmtype "SSM")) (progn
    
 (if (/= (setq stringpos (vl-string-search "state" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 7)))(setq rmstate (substr monline (+ stringpos 8) (-(- wwpos 1)(+ stringpos 6)))))(setq rmstate ""))
(if (/= (setq stringpos (vl-string-search "condition" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 11)))(setq rmcondition (substr monline (+ stringpos 12) (-(- wwpos 1)(+ stringpos 10)))))(setq rmcondition ""))
(if (/= (setq stringpos (vl-string-search "desc" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 6)))(setq rmcomment (substr monline (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5)))))(setq rmcomment ""))
(setq &pos 0)
	      (while (/=  (setq &pos (vl-string-search "&amp;" rmcomment &pos )) nil) (setq rmcomment (vl-string-subst "&" "&amp;"  rmcomment &pos)
										      &pos (+ &pos 1)))
 (setq quotpos 0)
	(while (/=  (setq quotpos (vl-string-search "&quot;" rmcomment quotpos )) nil) (setq rmcomment (vl-string-subst "\"" "&quot;"  rmcomment 	quotpos)
										      quotpos (+ quotpos 1)))
					      (setq apos 0)
	(while (/=  (setq apos (vl-string-search "&apos;" rmcomment apos )) nil) (setq rmcomment (vl-string-subst "'" "&apos;"  rmcomment apos)
										      apos (+ apos 1)))

(if (/= (setq stringpos (vl-string-search "originSurvey" monline )) nil)(progn
(setq wwpos (vl-string-position 34 monline (+ stringpos 14)))(setq rmrefdp (substr monline (+ stringpos 15) (-(- wwpos 1)(+ stringpos 13)))))(setq rmrefdp ""))


					  
 
   
    ;draw monument info
    
    
  

  
  (SETVAR "CLAYER" "Monument" )

 (setq ,pos1 (vl-string-position 44 lp1c 0))
                 (setq lp1ce (atof (substr lp1c 1 ,pos1)))
      		 (setq lp1cn (atof (substr lp1c (+ ,pos1 2) 50)))
	    (setq p1 (list lp1ce lp1cn))
 
  (COMMAND "POINT" p1)

  ;check for no values and replace with "none"
    (if (/= rmrefdp "")(setq ormrefdp (strcat " originSurvey=\"" rmrefdp "\" "))(setq ormrefdp ""))
  (if (/= rmcondition "")(setq ormcondition ( strcat " condition=\"" rmcondition "\" "))(setq ormcondition ""))
  (if (/= rmtype "")(setq ormtype ( strcat "type=\"" rmtype "\" "))(setq ormtype ""))

    (if (/= rmcomment "")(setq rmcomments (strcat " desc=\"" rmcomment "\""))(setq rmcomments ""))
    (SETQ PTINFO (STRCAT ormtype "state=\""  rmstate "\"" ormrefdp  ormcondition rmcomments " />" ));Note comment for desc in xml added to distance entry seperated by a space
(SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 PTINFO)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)

 (if (vl-string-search " RM" rmcomment )(progn
					   (setq rmornot " RM")
					   (setq rmcomment (vl-string-subst "" "RM" rmcomment))

					   )
    (setq rmornot ""); if not rm corner mark make nil
    )
        
 

  
 (lcm)  




));p&if not a PM or SSM


      
(setq count (+ count 2))
      
     );repeat



  ;18. CREATE EASEMENT LEGEND
  (setq elp (list (+ maxeast (* th 0 )) (- minnorth 50)))
  (createeaselegend)

  ;19. ADD STRATA DATUM POINTS
  (IF (> (LENGTH LEVELLIST) 0)(PROGN
				
  (SETQ LCP (LIST (- MINEAST 10) (- MINNORTH 10)))

;place location plan point
		(SETVAR "CLAYER"  "Datum Points" )
     (COMMAND "POINT" lcp)
	 (SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
(SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 "0,Location Plan")))))
  (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)
(SETQ TEXTPOS (LIST (- (CAR lcp) TH) (+ (CADR lcp) (* 0.5 TH))))
		 (SETVAR "CLAYER"  "Drafting" )
		 (COMMAND "TEXT" "J" "BR"  TEXTPOS (* TH 2) "90" "Location Plan" )
;place other datum points
  (setq count 0)
  (repeat (length levellist)
    (setq cgcode (nth count levellist))
    (setq shiftnum (+ 1(- (length levellist)(length (member cgcode levellist)))))
    (setq dpp (list (car lcp)(+ (cadr lcp) (* shiftnum 500))))

    (SETVAR "CLAYER"  "Datum Points" )
    (COMMAND "POINT" dpp)
	 (SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
(SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 cgcode)))))
  (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)
(SETQ TEXTPOS (LIST (- (CAR dpp) TH) (+ (CADR dpp) (* 0.5 TH))))
    (setq ,pos (vl-string-position 44 cgcode 0))
          	 (setq cgcode  (substr cgcode (+ ,pos 2) 5000))
    		 (SETVAR "CLAYER"  "Drafting" )
		 (COMMAND "TEXT" "J" "BR"  TEXTPOS (* TH 2) "90" cgcode )
  (setq count (+ count 1))
    )
  ));p&if levellist

  

  (setvar "clayer" prevlayer )
  (command "zoom" "extents")
(close xmlfile)


(SETVAR "ATTDIA" ATTDIA)
(SETVAR "ATTREQ" ATTREQ)


  
  );defun


;-------------------------------------------------------------------------------EXPORT XML---------------------------------------------------------------


;(vlax-remove-cmd "XOUT")
;(VLAX-ADD-CMD "XOUT" "XOUT" "XOUT")


(DEFUN C:XOUT (/)
       (XOUT)
  )

  (defun XOUT (/)
    
(setq prevlayer (getvar "CLAYER"))
    
    (setq cgpl (list));EMPTY CGPOINTLIST
  (setq rolist (list));EMPTY Reference list
  (setq obslist (list));empty observation list
  (setq monlist (list));Empty Monument list
  (setq lotlist (list));Empty lot definition list
  (setq arclist (list));empty observed arc list
  (setq dpl (List));empty datum point list
  (setq pmlist (list));empty pm list
  (setq mplist (list));empty multipartlist
  (setq mpalist (list));empty mulitplart assignment list
  (setq mpolist (list));empty multipart output list
  (setq pflist (list));empty plan features list
  (setq pcount 0);set point number count to 0
  (setq rocount 0);set ro count to 0
  (setq moncount 0);set monument count to 0
  (setq cogeocount 1);set corrd geom to 0
  (setq pfwcount 1);set plan features wall count to 1
  (setq pfkcount 1);set plan features kerb count to 1
  (setq pffcount 1);set plan features fence count to 1
  (setq pfbcount 1);set plan features building count to 1
  (setq iblselist (list));irregular boundary start and end points
  (setq ibllist (list));irregular boundary line list for polyline shuffler
  (setq islist (list));instrument station list
  (setq flowarrows "")  
  (setq Roadcount 1)
  (setq Easecounta 1)
  (setq Hydrocount 1)
  (setq annocount 1)
  (setq cgplevel (list));strata position level list
  (setq sdpl (list));strata datum point list
  (setq sdps (list));strata datum point shift list
  (setq annolist (list))
  (setq stratumswitch "N")  

  ;possibly add cgpoints before boundary points

  ;Heirachy
  ;1. Determine Floors  
  ;2. Datum Points
  ;3. Road lines
  ;4. Road Arcs
  ;5. Boundary lines
  ;6. Boundary Arcs
  ;7. Irregular Boundaries
  ;8. Irregular Right Lines
  ;9. Adjoining lots 
  ;10. Easement lines
  ;11. Easement Arcs
  ;12. PM's
  ;13. Connection lines
  ;14. Connection arcs
  ;15. PM connection lines
  ;16. Monument points
  ;17. Monument connection lines
  ;17a Height Differene connection lines
  ;18. Plan features, fence, line
  ;19. Plan features, fence, arc
  ;20. Plan features, wall, line
  ;21. Plan features, wall, arc
  ;22. Plan features, kerb, line
  ;23. Plan features, kerb, arc
  ;24. Plan features, building, line
  ;25. Plan features, building,  arc
  ;26. Plan features, fence, polyline
  ;27. Plan features, wall, polyline
  ;28. Plan features, kerbs, polyline
  ;29. Plan features, buildings, polyline
  ;30. Plan features, occupation lines
  ;31. Occupation points
  ;32. Flow Arrows
  ;33. Vinculumns
  ;34. Lots definitons
  





    ;1 gather all lots to determine floors for cgpoints and count roads

    
(IF (/= (setq lots (ssget "_X" '((0 . "LWPOLYLINE") (8 . "Lot Definitions,Adjoining Boundary")))) nil)(progn

 (setq count 0)
  (repeat (sslength lots)
  
    (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME lots COUNT)))))
    (SETQ ZA (CDR(ASSOC 210 (ENTGET (SSNAME lots COUNT))))) ;DEFAULT POLYLINE WIDTH
    (SETQ DEFWIDTH (CDR(ASSOC 40 (ENTGET (SSNAME lots COUNT))))) ;DEFAULT POLYLINE WIDTH
    (SETQ CLOSED (CDR(ASSOC 70 (ENTGET (SSNAME lots COUNT))))) ;DEFAULT POLYLINE WIDTH

    (SETQ XDATAI (ENTGET EN '("LANDXML")))
	    (IF (= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL) (progn
	      	     (COMMAND "CHANGE" en "" "P" "C" "6" "")
	      ;(princ (strcat "\nERROR Lot with no XML data at " (rtos (car p1) 2 3) "," (rtos (cadr p1)2 3)))
	     )
	      (PROGN ;ELSE
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))
    

;check for stratum lot
	    (if (/= (setq stringpos (vl-string-search "parcelFormat" xdatai )) nil)(progn
(setq wwpos (vl-string-position 34 xdatai (+ stringpos 14)))(setq pclformat (substr xdatai (+ stringpos 15) (-(- wwpos 1)(+ stringpos 13)))))(setq pclformat ""))
	    (if (= pclformat "Stratum")(setq stratumswitch "Y"))

    	   
    
   
      
;get building level number 
(if (/= (setq stringpos (vl-string-search "buildingLevelNo" xdatai )) nil)(progn
(setq wwpos (vl-string-position 34 xdatai (+ stringpos 17)))(setq blno (substr xdatai (+ stringpos 18) (-(- wwpos 1)(+ stringpos 16)))))(setq blno ""))

    (if (/= blno "")(progn

		      ;get centrepoint
		           (setq !pos1 (vl-string-position 33 xdatai 0))
                      (setq lotc (substr xdatai (+ !pos1 2) 200))

		      (setq cgplevel (append cgplevel (list lotc) (list blno)))
		      

					(setq enlist (entget en))
    ;go through polyline to get points 
    
	    (foreach a enlist
	      (if (= 10 (car a))

		(setq cgplevel (append cgplevel (list (strcat (rtos (cadr (TRANS (cdr a) ZA 0)) 2 6) " " (rtos (car (TRANS (cdr a) ZA 0)) 2 6))) (list blno)))
	      )				;IF
	      
	      
	    )				;FOREACH 			
 ));if blno

;search for numbers of existing road and increment roadcount as 1 higher than the highest
	    (if (/= (setq stringpos (vl-string-search "class" xdatai )) nil)(progn
(setq wwpos (vl-string-position 34 xdatai (+ stringpos 7)))(setq lotclass (substr xdatai (+ stringpos 8) (-(- wwpos 1)(+ stringpos 6)))))(setq lotclass ""))
    (if (and (or (= lotclass "Road")(= lotclass "Reserved Road"))(/= (substr xdatai 1 4 ) "desc"))
	     (progn
	       (if (/= (setq stringpos (vl-string-search "name=" xdatai )) nil)(progn
(setq wwpos (vl-string-position 34 xdatai (+ stringpos 7)))(setq roadname  (substr xdatai (+ stringpos 8) (-(- wwpos 1)(+ stringpos 6)))))(setq roadname "0"))
	       			     (if (> (atof roadname) roadcount) (setq roadcount (+ (atof roadname) 1)))
	       )
      )
	    
	    
	    ));IF XDATA EXISTS
    (setq count (+ count 1))
	    
    );repeat
 ));lots



    

  
  ;2. Datum Points
    (princ "\nProcessing Datum Points")
(IF (/= (setq bdyline (ssget "_X" '((0 . "POINT") (8 . "Datum Points")))) nil)(progn 
  (setq count 0)
  (repeat (sslength bdyline)


(SETQ P1 (CDR(ASSOC 10 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ ZA (CDR (ASSOC 210 (ENTGET (SSNAME bdyline COUNT)))))
    (SETQ P1 (TRANS P1 ZA 0))
 
    
    	    (SETQ XDATAI (ENTGET EN '("LANDXML")))
	    (IF (= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL) (progn
	      	     (COMMAND "CHANGE" en "" "P" "C" "6" "")
	      (princ (strcat "\nERROR Datum Point with no XML data at " (rtos (car p1) 2 3) "," (rtos (cadr p1)2 3)))
	     )
	      (PROGN ;ELSE
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))

    
 ;check for strata level words from list
(setq stratalevel "N")
  (setq CWcount 0)
  (repeat (length stratadpwl)
    (setq checkword (nth CWcount stratadpwl))
    (if (/= (vl-string-search checkword xdatai ) nil)(setq stratalevel "Y"))
      (setq CWcount (+ CWcount 1))
    )
;check datum point for strata level
    

    (if (= stratalevel "N")  (PROGN
				
				   (setq p1s (strcat (rtos (cadr p1) 2 6) " " (rtos (car p1) 2 6)))
				   ;if stratum
				 
    (if (= (member p1s dpl) nil)
      (progn
	(if (and (= stratumswitch "Y")(/= (caddr p1) 0))
	(setq dpl (append dpl (list p1s)(list xdatai)(list (rtos (caddr p1) 2 6))));if Stratum and rl exists
	(setq dpl (append dpl (list p1s)(list xdatai)(list "NORL")));normal datum point
	  );if stratumswitch
       	));p&if member
    );p normal datum point

      
      (progn ;else strata plan datumpoint
(setq sdpl (append sdpl (list xdatai) (list p1)))
));p&if DP or strata datum point
	));IF XDATA EXISTS
(SETQ COUNT (+ COUNT 1))
    );r

;sort out datum point list for strata plan
  (if (/= (length sdpl) 0)(progn
			    
(setq locshift (cadr (member "0,Location Plan" sdpl)))
(setq sdplcount 0)
(repeat (/ (length sdpl) 2)
  (setq cldp (nth (+ sdplcount 1) sdpl))
  (setq sdps (append sdps (list (nth sdplcount sdpl))(list (- (car locshift)(car cldp))(- (cadr locshift)(cadr cldp)))))
  (setq sdplcount (+ sdplcount 2))
   );r

  ));p&if sdpl
  )
  (PRINC "\nWARNING No Datum Points found in Project")

  );if datum points found

 
  ;3.get road lines

    (princ "\nProcessing Road Lines  ")

  
(IF (/= (setq bdyline (ssget "_X" '((0 . "LINE") (8 . "Road")))) nil)(progn 
  (setq count 0)
  (repeat (sslength bdyline)
  (SETQ P1 (CDR(ASSOC 10 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ P2 (CDR(ASSOC 11 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME bdyline COUNT)))))

    	    (SETQ XDATAI (ENTGET EN '("LANDXML")))
	   (IF (= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL) (progn
	      	     (COMMAND "CHANGE" en "" "P" "C" "6" "")
	      (princ (strcat "\nERROR Road Line with no XML data at " (rtos (car p1) 2 3) "," (rtos (cadr p1)2 3)))
	     )
	     (PROGN ;ELSE
    
     (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))

(symbolreplace)
    	
	  	  
    

    (setq p1s (strcat (rtos (cadr p1) 2 6) " " (rtos (car p1) 2 6)))
    (setq p2s (strcat (rtos (cadr p2) 2 6) " " (rtos (car p2) 2 6)))

    ;look for strata level
    (setq code "")
    (if (/= (vl-position p1s cgplevel) nil)(setq code (cadr (member p1s cgplevel))))
    (if (/= (vl-position p2s cgplevel) nil)(setq code (cadr (member p2s cgplevel))))

    (if (= (setq pos1 (vl-position p1s cgpl)) nil)(progn
				   (setq pcount (+ pcount 1))
				   (setq is1 (rtos pcount 2 0))
				   (setq cgpl (append cgpl (list p1s)(list "boundary")(list "proposed")(list (rtos pcount 2 0))(list code)))
				   );p
;else
      (setq is1 (nth (+ pos1 3) cgpl))
       );&if
				   
     (if (= (setq pos2 (vl-position p2s cgpl)) nil)(progn
				   (setq pcount (+ pcount 1))
				   (setq is2 (rtos pcount 2 0))
				   (setq cgpl (append cgpl (list p2s)(list "boundary")(list "proposed")(list (rtos pcount 2 0))(list code)))
				   );p
;else
     (setq is2 (nth (+ pos2 3) cgpl))
       );&if

    (setq rocount (+ rocount 1))
    (setq roline (strcat "<ReducedObservation name=\"" (rtos rocount 2 0) "\" desc=\"Road\" setupID=\"IS" is1 "\" targetSetupID=\"IS" is2 "\" " xdatai))
    (setq rolist (append rolist (list roline)))
    (setq obslist (append obslist (list (strcat is1 "-" is2))(list ( strcat is2 "-" is1))))
    (setq islist (append islist (list is1 is2)))
     ));;IF XDATA EXISTS
(setq count (+ count 1))
    );r
  );p
  (PRINC "\nNo Road Lines found in Project")
  );&if road

    

;4.get road arcs
 
  (princ "\nProcessing Road Arcs ")
(IF (/= (setq bdyline (ssget "_X" '((0 . "ARC") (8 . "Road")))) nil)(progn 
  (setq count 0)
  (repeat (sslength bdyline)


(SETQ CP (CDR(ASSOC 10 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ RADIUS (CDR(ASSOC 40 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ ANG1 (CDR(ASSOC 50 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ ANG2 (CDR(ASSOC 51 (ENTGET (SSNAME bdyline COUNT)))))

  (SETQ P1 (POLAR CP ANG1 RADIUS))
  (SETQ P2 (POLAR CP ANG2 RADIUS))

    ;CONVERT TO WCS
    (SETQ ZA (CDR(ASSOC 210 (ENTGET (SSNAME bdyline COUNT)))))
    (SETQ CP (TRANS CP ZA 0))
    (SETQ P1 (TRANS P1 ZA 0))
    (SETQ P2 (TRANS P2 ZA 0))
    (if (< (caddr za) 0)(setq TEMP1 P1
			      P1 P2
			      P2 TEMP1))
    
    
    ;get xdata
  (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME bdyline COUNT)))))

    	    (SETQ XDATAI (ENTGET EN '("LANDXML")))
	    (IF (= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL) (progn
	      	     (COMMAND "CHANGE" en "" "P" "C" "6" "")
	      (princ (strcat "\nERROR Road Arc with no XML data at " (rtos (car p1) 2 3) "," (rtos (cadr p1)2 3)))
	     )
	      (PROGN ;ELSE
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))
    
       (symbolreplace)
      

 
    (setq p1s (strcat (rtos (cadr p1) 2 6) " " (rtos (car p1) 2 6)))
    (setq p2s (strcat (rtos (cadr p2) 2 6) " " (rtos (car p2) 2 6)))
    (setq cps (strcat (rtos (cadr cp) 2 6) " " (rtos (car cp) 2 6)))

    (setq code "")
    (if (/= (vl-position p1s cgplevel) nil)(setq code (cadr (member p1s cgplevel))))
    (if (/= (vl-position p2s cgplevel) nil)(setq code (cadr (member p2s cgplevel))))

  
;centre of arc
    (if (= (setq remlist (member cps cgpl)) nil)
      (progn
	(setq pcount (+ pcount 1))
	(setq cpn (rtos pcount 2 0))
	(setq cgpl (append cgpl (list cps)(list "sideshot")(list "proposed")(list (rtos pcount 2 0))(list code)))
	)
     (setq cpn (nth 3 remlist))
     )

   
  
    

    (if (= (setq pos1 (vl-position p1s cgpl)) nil)(progn
				   (setq pcount (+ pcount 1))
				   (setq is1 (rtos pcount 2 0))
				   (setq cgpl (append cgpl (list p1s)(list "boundary")(list "proposed")(list (rtos pcount 2 0))(list code)))
				   );p
;else
      (setq is1 (nth (+ pos1 3) cgpl))
       );&if
				   
     (if (= (setq pos2 (vl-position p2s cgpl)) nil)(progn
				   (setq pcount (+ pcount 1))
				   (setq is2 (rtos pcount 2 0))
				   (setq cgpl (append cgpl (list p2s)(list "boundary")(list "proposed")(list (rtos pcount 2 0))(list code)))
				   );p
;else
      (setq is2 (nth (+ pos2 3) cgpl))
       );&if

     (if (/= (setq stringpos (vl-string-search "rot" xdatai )) nil)(progn
(setq wwpos (vl-string-position 34 xdatai (+ stringpos 5)))(setq rot (substr xdatai (+ stringpos 6) (-(- wwpos 1)(+ stringpos 4))))))

    (if (= rot "cw")(progn
		      (setq is1r is1
			is1 is2
			is2 is1r)
		      
      ))
      

    
    (setq rocount (+ rocount 1))
    (setq roline (strcat "<ReducedArcObservation name=\"" (rtos rocount 2 0) "\" desc=\"Road\" setupID=\"IS" is1 "\" targetSetupID=\"IS" is2 "\" " xdatai))
    (setq rolist (append rolist (list roline)))
    (setq obslist (append obslist (list (strcat is1 "-" is2))(list ( strcat is2 "-" is1))))
    (setq islist (append islist (list is1 is2)))
     (setq arclist (append arclist (list (strcat is1 "-" is2))(list cpn) (list (strcat is2 "-" is1))(list cpn)))
    
));IF XDATA EXISTS
    (setq count (+ count 1))
    );r
  );p
  (PRINC "\nNo Road Arcs found in Project")
  );if

    
  
  ;3a.get road extent lines

    (princ "\nProcessing Road Extent Lines  ")
  
  
  
(IF (/= (setq bdyline (ssget "_X" '((0 . "LINE") (8 . "Road Extent")))) nil)(progn 
  (setq count 0)
  (repeat (sslength bdyline)
  (SETQ P1 (CDR(ASSOC 10 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ P2 (CDR(ASSOC 11 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME bdyline COUNT)))))

    	    (SETQ XDATAI (ENTGET EN '("LANDXML")))
	   (IF (= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL) (progn
	      	     (COMMAND "CHANGE" en "" "P" "C" "6" "")
	      (princ (strcat "\nERROR Road Line with no XML data at " (rtos (car p1) 2 3) "," (rtos (cadr p1)2 3)))
	     )
	     (PROGN ;ELSE
    
     (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))

(symbolreplace)
    	
	  	  
    

    (setq p1s (strcat (rtos (cadr p1) 2 6) " " (rtos (car p1) 2 6)))
    (setq p2s (strcat (rtos (cadr p2) 2 6) " " (rtos (car p2) 2 6)))

    ;look for strata level
    (setq code "")
    (if (/= (vl-position p1s cgplevel) nil)(setq code (cadr (member p1s cgplevel))))
    (if (/= (vl-position p2s cgplevel) nil)(setq code (cadr (member p2s cgplevel))))

    (if (= (setq pos1 (vl-position p1s cgpl)) nil)(progn
				   (setq pcount (+ pcount 1))
				   (setq is1 (rtos pcount 2 0))
				   (setq cgpl (append cgpl (list p1s)(list "boundary")(list "proposed")(list (rtos pcount 2 0))(list code)))
				   );p
;else
      (setq is1 (nth (+ pos1 3) cgpl))
       );&if
				   
     (if (= (setq pos2 (vl-position p2s cgpl)) nil)(progn
				   (setq pcount (+ pcount 1))
				   (setq is2 (rtos pcount 2 0))
				   (setq cgpl (append cgpl (list p2s)(list "boundary")(list "proposed")(list (rtos pcount 2 0))(list code)))
				   );p
;else
      (setq is2 (nth (+ pos2 3) cgpl))
       );&if

    (setq rocount (+ rocount 1))
    (setq roline (strcat "<ReducedObservation name=\"" (rtos rocount 2 0) "\" desc=\"Road Extent\" setupID=\"IS" is1 "\" targetSetupID=\"IS" is2 "\" " xdatai))
    (setq rolist (append rolist (list roline)))
    (setq obslist (append obslist (list (strcat is1 "-" is2))(list ( strcat is2 "-" is1))))
    (setq islist (append islist (list is1 is2)))
     ));;IF XDATA EXISTS
(setq count (+ count 1))
    );r
  );p
  (PRINC "\nNo Road Extent Lines found in Project")
  );&if road

    

;4.get road extent arcs
 
  (princ "\nProcessing Road Arcs ")
(IF (/= (setq bdyline (ssget "_X" '((0 . "ARC") (8 . "Road Extent")))) nil)(progn 
  (setq count 0)
  (repeat (sslength bdyline)


(SETQ CP (CDR(ASSOC 10 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ RADIUS (CDR(ASSOC 40 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ ANG1 (CDR(ASSOC 50 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ ANG2 (CDR(ASSOC 51 (ENTGET (SSNAME bdyline COUNT)))))

  (SETQ P1 (POLAR CP ANG1 RADIUS))
  (SETQ P2 (POLAR CP ANG2 RADIUS))

    ;CONVERT TO WCS
    (SETQ ZA (CDR(ASSOC 210 (ENTGET (SSNAME bdyline COUNT)))))
    (SETQ CP (TRANS CP ZA 0))
    (SETQ P1 (TRANS P1 ZA 0))
    (SETQ P2 (TRANS P2 ZA 0))
    (if (< (caddr za) 0)(setq TEMP1 P1
			      P1 P2
			      P2 TEMP1))
    
    
    ;get xdata
  (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME bdyline COUNT)))))

    	    (SETQ XDATAI (ENTGET EN '("LANDXML")))
	    (IF (= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL) (progn
	      	     (COMMAND "CHANGE" en "" "P" "C" "6" "")
	      (princ (strcat "\nERROR Road Arc with no XML data at " (rtos (car p1) 2 3) "," (rtos (cadr p1)2 3)))
	     )
	      (PROGN ;ELSE
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))
    
       (symbolreplace)
      

 
    (setq p1s (strcat (rtos (cadr p1) 2 6) " " (rtos (car p1) 2 6)))
    (setq p2s (strcat (rtos (cadr p2) 2 6) " " (rtos (car p2) 2 6)))
    (setq cps (strcat (rtos (cadr cp) 2 6) " " (rtos (car cp) 2 6)))

    (setq code "")
    (if (/= (vl-position p1s cgplevel) nil)(setq code (cadr (member p1s cgplevel))))
    (if (/= (vl-position p2s cgplevel) nil)(setq code (cadr (member p2s cgplevel))))

  
;centre of arc
    (if (= (setq pos3 (member cps cgpl)) nil)
      (progn
	(setq pcount (+ pcount 1))
	(setq cpn (rtos pcount 2 0))
	(setq cgpl (append cgpl (list cps)(list "sideshot")(list "proposed")(list (rtos pcount 2 0))(list code)))
	)
     (setq cpn (nth (+ pos3 3) cgpl))
     )

   
  
    

    (if (= (setq pos1 (vl-position p1s cgpl)) nil)(progn
				   (setq pcount (+ pcount 1))
				   (setq is1 (rtos pcount 2 0))
				   (setq cgpl (append cgpl (list p1s)(list "boundary")(list "proposed")(list (rtos pcount 2 0))(list code)))
				   );p
;else
      (setq is1 (nth (+ pos1 3) cgpl))
       );&if
				   
     (if (= (setq pos2 (vl-position p2s cgpl)) nil)(progn
				   (setq pcount (+ pcount 1))
				   (setq is2 (rtos pcount 2 0))
				   (setq cgpl (append cgpl (list p2s)(list "boundary")(list "proposed")(list (rtos pcount 2 0))(list code)))
				   );p
;else
      (setq is2 (nth (+ pos2 3) cgpl))
       );&if

     (if (/= (setq stringpos (vl-string-search "rot" xdatai )) nil)(progn
(setq wwpos (vl-string-position 34 xdatai (+ stringpos 5)))(setq rot (substr xdatai (+ stringpos 6) (-(- wwpos 1)(+ stringpos 4))))))

    (if (= rot "cw")(progn
		      (setq is1r is1
			is1 is2
			is2 is1r)
		      
      ))
      

    
    (setq rocount (+ rocount 1))
    (setq roline (strcat "<ReducedArcObservation name=\"" (rtos rocount 2 0) "\" desc=\"Road Extent\" setupID=\"IS" is1 "\" targetSetupID=\"IS" is2 "\" " xdatai))
    (setq rolist (append rolist (list roline)))
    (setq obslist (append obslist (list (strcat is1 "-" is2))(list ( strcat is2 "-" is1))))
    (setq islist (append islist (list is1 is2)))
     (setq arclist (append arclist (list (strcat is1 "-" is2))(list cpn) (list (strcat is2 "-" is1))(list cpn)))
    
));IF XDATA EXISTS
    (setq count (+ count 1))
    );r
  );p
  (PRINC "\nNo Road Extent Arcs found in Project")
  );if


    ;5.get boundary lines
    (princ "\nProcessing Boundary Lines ")
 
(IF (/= (setq bdyline (ssget "_X" '((0 . "LINE") (8 . "Boundary")))) nil)(progn 
  (setq count 0)
  (repeat (sslength bdyline)
  (SETQ P1 (CDR(ASSOC 10 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ P2 (CDR(ASSOC 11 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME bdyline COUNT)))))

    	    (SETQ XDATAI (ENTGET EN '("LANDXML")))
	   (IF (= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL) (progn
	      	     (COMMAND "CHANGE" en "" "P" "C" "6" "")
	      (princ (strcat "\nBoundary Line with no XML data at " (rtos (car p1) 2 3) "," (rtos (cadr p1)2 3)))
	     )
	     (PROGN ;ELSE
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))
       (symbolreplace)
     
	  	  

    (setq p1s (strcat (rtos (cadr p1) 2 6) " " (rtos (car p1) 2 6)))
    (setq p2s (strcat (rtos (cadr p2) 2 6) " " (rtos (car p2) 2 6)))

    (setq code "")
    (if (/= (vl-position p1s cgplevel) nil)(setq code (cadr (member p1s cgplevel))))
    (if (/= (vl-position p2s cgplevel) nil)(setq code (cadr (member p2s cgplevel))))



    (if (= (setq pos1 (vl-position p1s cgpl)) nil)(progn
				   (setq pcount (+ pcount 1))
				   (setq is1 (rtos pcount 2 0))
				   (setq cgpl (append cgpl (list p1s)(list "boundary")(list "proposed")(list (rtos pcount 2 0))(list code)))
				   );p
;else
      (setq is1 (nth (+ pos1 3) cgpl))
       );&if
				   
     (if (= (setq pos2 (vl-position p2s cgpl)) nil)(progn
				   (setq pcount (+ pcount 1))
				   (setq is2 (rtos pcount 2 0))
				   (setq cgpl (append cgpl (list p2s)(list "boundary")(list "proposed")(list (rtos pcount 2 0))(list code)))
				   );p
;else
      (setq is2 (nth (+ pos2 3) cgpl))
       );&if

    (setq rocount (+ rocount 1))
    (setq roline (strcat "<ReducedObservation name=\"" (rtos rocount 2 0) "\" desc=\"Boundary\" setupID=\"IS" is1 "\" targetSetupID=\"IS" is2 "\" " xdatai))
    (setq rolist (append rolist (list roline)))
    (setq obslist (append obslist (list (strcat is1 "-" is2))(list ( strcat is2 "-" is1))))
    (setq islist (append islist (list is1 is2)))
));IF XDATA EXISTS
	    (setq count (+ count 1))
	    
    );r
  );p
  (PRINC "\nWARNING No Boundary Lines found in Project")
  );if

;6.get boundary arcs
  (princ "\nProcessing Boundary Arcs ")
(IF (/= (setq bdyline (ssget "_X" '((0 . "ARC") (8 . "Boundary")))) nil)(progn 
 

    (setq count 0)
  (repeat (sslength bdyline)


(SETQ CP (CDR(ASSOC 10 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ RADIUS (CDR(ASSOC 40 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ ANG1 (CDR(ASSOC 50 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ ANG2 (CDR(ASSOC 51 (ENTGET (SSNAME bdyline COUNT)))))

  (SETQ P1 (POLAR CP ANG1 RADIUS))
  (SETQ P2 (POLAR CP ANG2 RADIUS))
;CONVERT TO WCS
    (SETQ ZA (CDR(ASSOC 210 (ENTGET (SSNAME bdyline COUNT)))))
    (SETQ CP (TRANS CP ZA 0))
    (SETQ P1 (TRANS P1 ZA 0))
    (SETQ P2 (TRANS P2 ZA 0))
    (if (< (caddr za) 0)(setq TEMP1 P1
			      P1 P2
			      P2 TEMP1))
    

    ;get xdata
    (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME bdyline COUNT)))))

    	    (SETQ XDATAI (ENTGET EN '("LANDXML")))
	    (IF (= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL) (progn
	      	     (COMMAND "CHANGE" en "" "P" "C" "6" "")
	      (princ (strcat "\nERROR Boundary Arc with no XML data at " (rtos (car p1) 2 3) "," (rtos (cadr p1)2 3)))
	     )
	      (PROGN ;ELSE
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))
      (symbolreplace)
     
	  	  

 
    (setq p1s (strcat (rtos (cadr p1) 2 6) " " (rtos (car p1) 2 6)))
    (setq p2s (strcat (rtos (cadr p2) 2 6) " " (rtos (car p2) 2 6)))
    (setq cps (strcat (rtos (cadr cp) 2 6) " " (rtos (car cp) 2 6)))

    (setq code "")
    (if (/= (vl-position p1s cgplevel) nil)(setq code (cadr (member p1s cgplevel))))
    (if (/= (vl-position p2s cgplevel) nil)(setq code (cadr (member p2s cgplevel))))
    
    

;centre of arc
   (if (= (setq pos3 (vl-position cps cgpl)) nil)
      (progn
	(setq pcount (+ pcount 1))
	(setq cpn (rtos pcount 2 0))
	(setq cgpl (append cgpl (list cps)(list "sideshot")(list "proposed")(list (rtos pcount 2 0))(list code)))

	)
      (setq cpn (nth (+ pos3 3) cgpl))
     )
  
    

    (if (= (setq pos1 (vl-position p1s cgpl)) nil)(progn
				   (setq pcount (+ pcount 1))
				   (setq is1 (rtos pcount 2 0))
				   (setq cgpl (append cgpl (list p1s)(list "boundary")(list "proposed")(list (rtos pcount 2 0))(list code)))
				   );p
;else
      (setq is1 (nth (+ pos1 3) cgpl))
       );&if
				   
     (if (= (setq pos2 (vl-position p2s cgpl)) nil)(progn
				   (setq pcount (+ pcount 1))
				   (setq is2 (rtos pcount 2 0))
				   (setq cgpl (append cgpl (list p2s)(list "boundary")(list "proposed")(list (rtos pcount 2 0))(list code)))
				   );p
;else
      (setq is2 (nth (+ pos2 3) cgpl))
       );&if

     (if (/= (setq stringpos (vl-string-search "rot" xdatai )) nil)(progn
(setq wwpos (vl-string-position 34 xdatai (+ stringpos 5)))(setq rot (substr xdatai (+ stringpos 6) (-(- wwpos 1)(+ stringpos 4))))))

    (if (= rot "cw")(progn
		      (setq is1r is1
			is1 is2
			is2 is1r)
		      
      ))
      

    (setq rocount (+ rocount 1))
    (setq roline (strcat "<ReducedArcObservation name=\"" (rtos rocount 2 0) "\" desc=\"Boundary\" setupID=\"IS" is1 "\" targetSetupID=\"IS" is2 "\" " xdatai))
    (setq rolist (append rolist (list roline)))
    (setq obslist (append obslist (list (strcat is1 "-" is2))(list ( strcat is2 "-" is1))))
    (setq islist (append islist (list is1 is2)))
    (setq arclist (append arclist (list (strcat is1 "-" is2))(list cpn) (list (strcat is2 "-" is1))(list cpn)))
	    
    ));IF XDATA EXSITS

    (setq count (+ count 1))
    
    );r
    );p
  (PRINC "\nNo Boundary Arcs found in Project")
  );if








  ;7. Irregular Boundary

 ;POLYLINES

    (princ "\nProcessing Irregular Boundaries")
     
 (IF (/= (SETQ LOTS (ssget "_X" '((0 . "LWPOLYLINE") (8 . "Irregular Boundary")))) nil)(progn
(setq count 0)
  (repeat (sslength lots)
    (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME lots COUNT)))))
    (SETQ P1 (CDR(ASSOC 10 (ENTGET (SSNAME lots COUNT)))))

     (SETQ XDATAI (ENTGET EN '("LANDXML")))
	    (IF (= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL) (progn
	      	     (COMMAND "CHANGE" en "" "P" "C" "6" "")
	      (princ (strcat "\nERROR Irregular Boundary Polyline with no XML data at " (rtos (car p1) 2 3) "," (rtos (cadr p1)2 3)))
	     )
	      (PROGN ;ELSE
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))
       (symbolreplace)
      
	  	  
    
;write to list
  
  (setq cogeocount (+ cogeocount 1))
					(setq enlist (entget en))
    ;go through polyline to get points 
    (SETQ PTLIST (LIST))
	    (foreach a enlist
	      (if (= 10 (car a))

		(setq PTLIST (append PTLIST (list (cdr a))))
	      )				;IF
	     
	    )				;FOREACH



    

    ;delete duplicates from list
    (setq dupcount 0)
    (setq pp "0")
    (setq ppw "500000")
    (repeat  (length ptlist) 
      (setq cpp (strcat (rtos (car (nth dupcount ptlist)) 2 9) "," (rtos (cadr (nth dupcount ptlist)) 2 9)))
      (setq cpw (nth (+ dupcount 1) ptlist)) 
      ;(princ (strcat "\n" pp))
      ;(princ (strcat "\n" cpp))
           
      (if  (= pp cpp) (progn
		
	               (setq ptlist (remove_nth ptlist  dupcount ))
		       
		      		    
							      
		       );p if pp = cp
(progn	       		 
	(setq dupcount (+ dupcount 1))
	))
      (setq pp cpp)
	(setq ppw cpw)
		  
      )



    

;add start and end point to start end ibl start end list list
    (setq psp (nth 0 ptlist))
   (setq psps (strcat (rtos (cadr psp) 2 6) " " (rtos (car psp) 2 6)))
    (setq p2p (nth 1 ptlist))
    (setq p2ps (strcat (rtos (cadr p2p) 2 6) " " (rtos (car p2p) 2 6)))
    (setq pep (nth (- (length ptlist) 1) ptlist))
   (setq peps (strcat (rtos (cadr pep) 2 6) " " (rtos (car pep) 2 6)))
    (setq p2lastp (nth (- (length ptlist) 2) ptlist))
   (setq p2lastps (strcat (rtos (cadr p2lastp) 2 6) " " (rtos (car p2lastp) 2 6)))
    
    (setq iblselist (append iblselist (list (strcat psps "-" p2ps))(list  xdatai)(list (strcat peps " "))))
    (setq iblselist (append iblselist (list (strcat peps "-" p2lastps))(list  xdatai)(list (strcat psps " "))));reverse of irregular line

	     


	    
 (setq count1 0)
 (repeat (length ptlist)
   (setq p1 (nth count1 ptlist))
   (setq p1s (strcat (rtos (cadr p1) 2 6) " " (rtos (car p1) 2 6)))

    ;(if (= (setq remlist(member p1s cgpl)) nil)(progn
;				   (setq pcount (+ pcount 1))
;				   (setq cgpl (append cgpl (list p1s)(list "sideshot")(list "proposed")(list (rtos pcount 2 0))))
;				   );p
 ;     );&if
   
   (if (and (/= count1 0) (/= count1 (- (length ptlist)1)))(setq ibllist (append ibllist (list p1s))));add points on line to irregular boundary shuffler
  
  (setq count1 (+ count1 1))
   );r length of ptlist
	    ));IF XDATA EXISTS
  (setq count (+ count 1))
  (setq pffcount (+ pffcount 1))
	    
);r length of irregular boundaries
));and if irregular boundary



    
 ;2D & 3DPOLYLINES

     
 (IF (/= (SETQ LOTS (ssget "_X" '((0 . "POLYLINE") (8 . "Irregular Boundary")))) nil)(progn
(setq count 0)
  (repeat (sslength lots)
    (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME lots COUNT)))))
    (SETQ P1 (CDR(ASSOC 10 (ENTGET (SSNAME lots COUNT)))))

     (SETQ XDATAI (ENTGET EN '("LANDXML")))
	    (IF (= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL) (progn
	      	     (COMMAND "CHANGE" en "" "P" "C" "6" "")
	      (princ (strcat "\nERROR Irregular Boundary Polyline with no XML data at " (rtos (car p1) 2 3) "," (rtos (cadr p1)2 3)))
	     )
	      (PROGN
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))
     (symbolreplace)
    
	  	  
    
;write to list
  
  (setq cogeocount (+ cogeocount 1))
					;(setq enlist (entget en))
    ;go through polyline to get points 
 ;   (SETQ PTLIST (LIST))
;	    (foreach a enlist
;	      (if (= 10 (car a))
;
;		(setq PTLIST (append PTLIST (list (cdr a))))
;	      )				;IF
	     
;	    )				;FOREACH

   	    
	    (setq enlist (entget en))
	    (setq ptList (list));EMPTY LIST
	    (setq en2 (entnext en))
	    (setq enlist2 (entget en2))
               
	     (while
	      (not
		(equal (cdr (assoc 0 (entget (entnext en2)))) "SEQEND")
	      )
	      	(if (= (cdr(assoc 70 enlist2)) 16)(progn
	       	 (setq ptList (append ptList (list (cdr (assoc 10 enlist2)))))
		))
		 	       
	       (setq en2 (entnext en2))
	       (setq enlist2 (entget en2))
	       );W
   (setq ptList
			(append ptList (list (cdr (assoc 10 enlist2))))
		 
	       )
    




	    
    ;delete duplicates from list
    (setq dupcount 0)
    (setq pp "0")
    (setq ppw "500000")
    (repeat  (length ptlist) 
      (setq cpp (strcat (rtos (car (nth dupcount ptlist)) 2 9) "," (rtos (cadr (nth dupcount ptlist)) 2 9)))
      (setq cpw (nth (+ dupcount 1) ptlist)) 
      ;(princ (strcat "\n" pp))
      ;(princ (strcat "\n" cpp))
           
      (if  (= pp cpp) (progn
		
	               (setq ptlist (remove_nth ptlist  dupcount ))
		       
		      		    
							      
		       );p if pp = cp
(progn	       		 
	(setq dupcount (+ dupcount 1))
	))
      (setq pp cpp)
	(setq ppw cpw)
		  
      )

    

;add start and end point to start end ibl list
    (setq psp (nth 0 ptlist))
   (setq psps (strcat (rtos (cadr psp) 2 6) " " (rtos (car psp) 2 6)))
    (setq p2p (nth 1 ptlist))
    (setq p2ps (strcat (rtos (cadr p2p) 2 6) " " (rtos (car p2p) 2 6)))
    (setq pep (nth (- (length ptlist) 1) ptlist))
   (setq peps (strcat (rtos (cadr pep) 2 6) " " (rtos (car pep) 2 6)))
    (setq p2lastp (nth (- (length ptlist) 2) ptlist))
   (setq p2lastps (strcat (rtos (cadr p2lastp) 2 6) " " (rtos (car p2lastp) 2 6)))
    
    (setq iblselist (append iblselist (list (strcat psps "-" p2ps))(list  xdatai)(list (strcat peps " "))))
    (setq iblselist (append iblselist (list (strcat peps "-" p2lastps))(list  xdatai)(list (strcat psps " "))));reverse of irregular line
        
 (setq count1 0)
 (repeat (length ptlist)
   (setq p1 (nth count1 ptlist))
   (setq p1s (strcat (rtos (cadr p1) 2 6) " " (rtos (car p1) 2 6)))

    ;(if (= (setq remlist(member p1s cgpl)) nil)(progn
;				   (setq pcount (+ pcount 1))
;				   (setq cgpl (append cgpl (list p1s)(list "sideshot")(list "proposed")(list (rtos pcount 2 0))))
;				   );p
 ;     );&if
   
   (if (and (/= count1 0) (/= count1 (- (length ptlist)1)))(setq ibllist (append ibllist (list p1s))));add points on line to irregular boundary shuffler
  
  (setq count1 (+ count1 1))
   );r length of ptlist
	    ));IF XDATA EXISTS
  (setq count (+ count 1))
  (setq pffcount (+ pffcount 1))
	    
);r length of irregular boundaries
));and if irregular boundary




    

 ;8. Irregular Right Lines
 (princ "\nProcessing Irregular Right Lines")
(IF (/= (setq bdyline (ssget "_X" '((0 . "LINE") (8 . "Irregular Right Lines")))) nil)(progn 
   (setq count 0)
  (repeat (sslength bdyline)
  (SETQ P1 (CDR(ASSOC 10 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ P2 (CDR(ASSOC 11 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME bdyline COUNT)))))

    	    (SETQ XDATAI (ENTGET EN '("LANDXML")))
	    (IF (= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL) (progn
	      	     (COMMAND "CHANGE" en "" "P" "C" "6" "")
	      (princ (strcat "\nERROR Irregular Right line with no XML data at " (rtos (car p1) 2 3) "," (rtos (cadr p1)2 3)))
	     )
	      (PROGN ;ELSE
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))
        (symbolreplace)
      
	  	  

    (setq p1s (strcat (rtos (cadr p1) 2 6) " " (rtos (car p1) 2 6)))
    (setq p2s (strcat (rtos (cadr p2) 2 6) " " (rtos (car p2) 2 6)))

        (setq code "")
    (if (/= (vl-position p1s cgplevel) nil)(setq code (cadr (member p1s cgplevel))))
    (if (/= (vl-position p2s cgplevel) nil)(setq code (cadr (member p2s cgplevel))))

	    
    (if (= (setq pos1 (vl-position p1s cgpl)) nil)(progn
				   (setq pcount (+ pcount 1))
				   (setq is1 (rtos pcount 2 0))
				   (setq cgpl (append cgpl (list p1s)(list "natural boundary")(list "proposed")(list (rtos pcount 2 0))(list code)));changed version 8 of schema was shideshot
				 
				   );p
;else
      (setq is1 (nth (+ pos1 3) cgpl))
       );&if
				   
     (if (= (setq pos2 (vl-position p2s cgpl)) nil)(progn
				   (setq pcount (+ pcount 1))
				   (setq is2 (rtos pcount 2 0))
				   (setq cgpl (append cgpl (list p2s)(list "natural boundary")(list "proposed")(list (rtos pcount 2 0))(list code)));changed version 8 of schema was shideshot
				   );p
;else
     (setq is2 (nth (+ pos2 3) cgpl))
       );&if

    (setq rocount (+ rocount 1))
    (setq roline (strcat "<ReducedObservation name=\"" (rtos rocount 2 0) "\" desc=\"Connection\" setupID=\"IS" is1 "\" targetSetupID=\"IS" is2 "\" " xdatai));changed version 8 of schema was boundary
    (setq rolist (append rolist (list roline)))
    (setq obslist (append obslist (list (strcat is1 "-" is2))(list ( strcat is2 "-" is1))))
    (setq islist (append islist (list is1 is2)))
	    ));IF XDATA EXISTS
    (setq count (+ count 1))
    );r
   );p
  (PRINC "\nNo Irregular right lines found in Project")
  );if



    
;9.---------------------------Get Ajoining Lots--------------------------------------------------------
(princ "\nProcessing Adjoining Boundaries")
    (IF (/= (setq lots (ssget "_X" '((0 . "LWPOLYLINE") (8 . "Adjoining Boundary")))) nil)(progn


;CHECK FOR MULTIPfART RE-ADDED REV1.9
											    								     
			(setq count 0)
  (repeat (sslength lots)
     (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME lots COUNT)))))
    (SETQ P1 (CDR(ASSOC 10 (ENTGET (SSNAME lots COUNT)))))
      	    (SETQ XDATAI (ENTGET EN '("LANDXML")))
	    (IF (= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL) (progn
	      	     (COMMAND "CHANGE" en "" "P" "C" "6" "")
	      ;(princ (strcat "\nERROR Lot with no XML data at " (rtos (car p1) 2 3) "," (rtos (cadr p1)2 3)))
	     )
	      (PROGN
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))



     (setq !pos1 (vl-string-position 33 xdatai 0))
                      (setq lotc (substr xdatai (+ !pos1 2) 200))
    
         (symbolreplace)
    
 (if (/= (setq stringpos (vl-string-search "parcelType" xdatai )) nil)(progn
(setq wwpos (vl-string-position 34 xdatai (+ stringpos 12)))(setq pcltype (substr xdatai (+ stringpos 13) (-(- wwpos 1)(+ stringpos 11))))))
	     (if (/= (setq stringpos (vl-string-search "parcelFormat" xdatai )) nil)(progn
(setq wwpos (vl-string-position 34 xdatai (+ stringpos 14)))(setq parcelformat (substr xdatai (+ stringpos 15) (-(- wwpos 1)(+ stringpos 13))))))
     (if (/= (setq stringpos (vl-string-search "name" xdatai )) nil)(progn
(setq wwpos (vl-string-position 34 xdatai (+ stringpos 6)))(setq pclname (substr xdatai (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5)))))(setq pclname ""))

	    
	    
    ;area removed
    (if (= pcltype "Part")(setq mplist (append mplist (list (strcat pclname "-" lotc )))))
	    ));IF XDATA EXISTS
    (setq count (+ count 1))
    );r
(if (> (length mplist) 0)(progn
			  
			(setq mplist (vl-sort mplist '<))
			(setq count 1)
			(setq alphanum 65)
			(setq pclname (nth 0 mplist))
			
			(setq -pos1 (vl-string-position 45 pclname 0))
			;area removed
                        (setq pclname  (substr pclname 1 -pos1))
			(setq liststart (strcat "  <Parcel name=\""pclname "\" class=\"Lot\" state=\"adjoining\" parcelType=\"Multipart\" parcelFormat=\"" parcelFormat "\"" ))
			(setq listend (strcat ">" (chr 10) "    <Parcels>" (chr 10) ))
      		        (setq listend (strcat listend "      <Parcel name=\"" pclname (chr alphanum) "\" pclRef=\"" pclname (chr alphanum) "\"/>" (chr 10) ))
			
			(setq mpalist (append mpalist (list pclname)(list (chr alphanum))))
			(setq prevname pclname)
			;sort list
			(repeat (-  (length mplist) 1) 
			  (setq pclname (nth count mplist))
			  (setq -pos1 (vl-string-position 45 pclname 0))
			
			  (setq pclname  (substr pclname 1 -pos1))
			  (if (= pclname prevname)(progn
			    (setq alphanum (+ alphanum 1))
			    (setq listend (strcat listend "      <Parcel name=\"" pclname (chr alphanum)"\" pclRef=\"" pclname (chr alphanum) "\"/>" (chr 10) ))
			    
)
			    (progn;else not the same pclname
			      (setq mpolist (append mpolist (list (strcat liststart  listend (chr 10) "    </Parcels>" (chr 10)   "  </Parcel>"))))
			      
			      (setq alphanum 65)
			      (setq liststart (strcat "  <Parcel name=\""pclname "\" class=\"Lot\" state=\"adjoining\" parcelType=\"Multipart\" parcelFormat=\"" parcelformat"\"" ))
			      (setq listend (strcat ">" (chr 10) "    <Parcels>" (chr 10) ))
			 (setq listend (strcat listend "      <Parcel name=\"" pclname (chr alphanum)"\" pclRef=\"" pclname (chr alphanum) "\"/>" (chr 10) ))
			    )
			    );if
			  
			  (setq mpalist (append mpalist (list pclname)(list (chr alphanum))))
			  (setq prevname pclname)
			  
			  (setq count (+ count 1))
			  );r

			(setq mpolist (append mpolist (list (strcat liststart  listend  "    </Parcels>" (chr 10)   "  </Parcel>"))))
			));p&if multipart lots exist

			
											  
 (setq count 0)
	      
  (repeat (sslength lots)
  
    (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME lots COUNT)))))
    (SETQ CLOSED (CDR(ASSOC 70 (ENTGET (SSNAME lots COUNT)))))
    (SETQ P1 (CDR(ASSOC 10 (ENTGET (SSNAME lots COUNT)))))
    

    	    (SETQ XDATAI (ENTGET EN '("LANDXML")))
    (IF (= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL) (progn
	      	     (COMMAND "CHANGE" en "" "P" "C" "6" "")
	      (princ (strcat "\nERROR Adjoining Lot with no XML data at " (rtos (car p1) 2 3) "," (rtos (cadr p1)2 3)))
	     )
      (PROGN;ELSE
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))
(if (= (substr xdatai 1 4) "desc")(progn

				    ;Check for easement or road lots note an imported road lot will not have "desc" as the first four letters and not need assignment as below
    (if (/= (setq stringpos (vl-string-search "class" xdatai )) nil)(progn
(setq wwpos (vl-string-position 34 xdatai (+ stringpos 7)))(setq lotclass (substr xdatai (+ stringpos 8) (-(- wwpos 1)(+ stringpos 6)))))(setq lotclass ""))
    (if (= lotclass "Road")(progn
			     (setq xdatai (strcat "  <Parcel name=\"R" (rtos roadcount 2 0) "\" " xdatai))
			     (setq roadcount (+ roadcount 1))
			     )
      )
    (if (= lotclass "Reserved Road")(progn
			     (setq xdatai (strcat "  <Parcel name=\"R" (rtos roadcount 2 0) "\" " xdatai))
			     (setq roadcount (+ roadcount 1))
			     )
      )
    (if (= lotclass "Easement")(progn
				 (setq xdatai (strcat "  <Parcel name=\"E" (rtos easecounta 2 0) "\" " xdatai))
				 (setq easecounta (+ easecounta 1))
				 )
      )
     (if (= lotclass "Hydrography")(progn
				 (setq xdatai (strcat "  <Parcel name=\"H" (rtos hydrocount 2 0) "\" " xdatai))
				 (setq hydrocount (+ hydrocount 1))
				 )
      )
    ));p& if desc

    ;check for mutliplart lot
    
   ;CHECK FOR MULTIPART RE-ADDED REV1.9
      
       (if (/= (setq stringpos (vl-string-search "name" xdatai )) nil)(progn
(setq wwpos (vl-string-position 34 xdatai (+ stringpos 6)))(setq pclname (substr xdatai (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5))))))

    (if (/= (setq listpos (vl-position pclname mpalist)) nil)(progn
							    (setq alpha (nth (+ listpos 1) mpalist))
							    (setq pclname (strcat pclname alpha))
							    (setq mpalist (remove_nth mpalist (+ listpos 1)))
							    (setq mpalist (remove_nth mpalist listpos ))
							    (setq xdatai (strcat (substr xdatai 1 (+ stringpos 6)) pclname (substr xdatai (+ wwpos 1) 1000)))
							    )
      )

	;get blno and strip number and comma to make it more inconsistent for LRS
(if (/= (setq stringpos (vl-string-search "buildingLevelNo" xdatai )) nil)(progn
(setq wwpos (vl-string-position 34 xdatai (+ stringpos 17)))(setq blno (substr xdatai (+ stringpos 18) (-(- wwpos 1)(+ stringpos 16))))

	    (setq ,pos1 (vl-string-position 44 blno 0))
	              (setq sblno (substr blno (+ ,pos1 2) 2000))
	    (setq xdatai (vl-string-subst (strcat "buildingLevelNo=\"" sblno "\"" ) (strcat "buildingLevelNo=\"" blno "\"" ) xdatai))
	    
)(setq blno ""))
      

     

;seperate centrepoint coord out.
    
     (setq !pos1 (vl-string-position 33 xdatai 0))
                      (setq lotc (substr xdatai (+ !pos1 2) 200))
                      (setq xdatai  (substr xdatai 1 !pos1))
  

    (symbolreplace)
	  	  
    
  
  (setq code "")
(setq pcount (+ pcount 1))
  (if (/= (vl-position lotc cgplevel) nil)(setq code (cadr (member lotc cgplevel))))
  (setq cgpl (append cgpl (list lotc)(list "sideshot")(list "existing")(list (rtos pcount 2 0))(list code)))

  
;write to list

  
  (setq lotlist (append lotlist (list xdatai)))
  (setq lotlist (append lotlist (list (strcat "    <Center pntRef=\"" (rtos pcount 2 0)"\"/>"))))
  (setq lotlist (append lotlist (list (strcat "    <CoordGeom name=\"" (rtos cogeocount 2 0) "\">"))))
  (setq cogeocount (+ cogeocount 1))
  
  
		(setq enlist (entget en))
    ;go through polyline to get points to check for clockwise direction
    (SETQ CWLIST (LIST))
	    (foreach a enlist
	      (if (= 10 (car a))

		(setq CWLIST (append CWLIST (list (cdr a))))
	      )				;IF
	      
	    )				;FOREACH 			

  (IF (> (lcw CWLIST) 0) (command "pedit" en "r" "" ))
  
    
					(setq enlist (entget en))
    ;go through polyline to get points and bugle factors
    (SETQ PTLIST (LIST))
	    (foreach a enlist
	      (if (= 10 (car a))

		(setq PTLIST (append PTLIST (list (cdr a))))
	      )				;IF
	      (if (= 42 (car a))
		(setq PTLIST (append PTLIST (LIST (cdr a))))
		);if
	    )				;FOREACH
    (IF (or (= CLOSED 1)(= CLOSED 129))(SETQ PTLIST (APPEND PTLIST (LIST(NTH 0 PTLIST))(LIST(NTH 1 PTLIST)))))
 


    ;SHUFFLER REMOVED - Highly unlikley there will be a Irregular Adjoining Boundary, and if there is make it a normal adjoining bounday REV 1.1
   

    ;(setq ptlist (append ptlist (list(nth 0 ptlist))(list (nth 1 ptlist))));add last point to list to close lot
	

 (setq count1 0)
    (setq repeater (/ (length ptlist) 2))
 (while (/= repeater 1)
   (progn

   (setq p1 (nth count1 ptlist))
   (setq p1s (strcat (rtos (cadr p1) 2 6) " " (rtos (car p1) 2 6)))
   (setq p2 (nth (+ count1 2) ptlist))
   (setq p2s (strcat (rtos (cadr p2) 2 6) " " (rtos (car p2) 2 6)))
   (setq bf (nth (+ count1 1) ptlist))

   ;look for irregular line
   (if (/= (setq remiblselist (member (strcat p1s "-" p2s) iblselist)) nil)
     (progn

       (setq xdatai (nth 1 remiblselist))
        (setq lotlist (append lotlist (list (strcat "      <IrregularLine desc=\"" xdatai "\">"))))
       (setq irbl "")
       (setq pps "")
       (setq iblcount 0)
       (while (/= pps (nth 2 remiblselist))
	 (progn
	 (setq p (nth count1 ptlist))
   (setq ps (strcat (rtos (cadr p) 2 6) " " (rtos (car p) 2 6) " "))
	 (if (/= ps pps)(setq irbl (strcat irbl ps)))
	 (setq pps ps)
	 (setq count1 (+ count1 2))
	 (setq iblcount (+ iblcount 1))
	 (if (and (= count1 (length ptlist))(/= pps (nth 2 remiblselist)) )(progn
					  (setq spcpos1 (vl-string-position 32 (nth 2 remiblselist) 0))
			      (setq eeast (atof(substr  (nth 2 remiblselist) (+ spcpos1 2) 200)))
                              (setq enorth  (atof (substr  (nth 2 remiblselist) 1 spcpos1)))
					 (setq endpoint (list eeast enorth))
	   (princ (strcat "\nError - Lot " pclname " - Not finding end of irregular between " (rtos (car p1) 2 3) "," (rtos (cadr p1) 2 3)
					      " and " (rtos eeast 2 3) ","  (rtos enorth 2 3) " orange line placed" ))
	   (command "color" "30" "line" p1 endpoint "" "color" "bylayer")
	   ))
	 ));p&w
       
     (setq ep (strcat (rtos (cadr p) 2 6) " " (rtos (car p) 2 6)))


                   (setq code "")
    (if (member p1s cgplevel)(setq code (cadr (member p1s cgplevel))))
    (if (member ep cgplevel)(setq code (cadr (member ep cgplevel))))
    ;(if (member lotc cgplevel)(setq code (cadr (member lotc cgplevel))))

       ; (setq cgpl (append cgpl (list lotc)(list "sideshot")(list "existing")(list (rtos pcount 2 0))(list code)))
       
      (if (/= (setq remlist (member p1s cgpl)) nil)(progn
						  (setq p1n (nth 3 remlist))
						  )
       (progn
	 ;(princ (strcat"\n Lot corner not defined by geometery at " (rtos (car p1) 2 6) "," (rtos (cadr p1) 2 6) " orange point placed"))
	 (setq pcount (+ pcount 1))
	 ;(command "color" "30" "point" p1 "color" "bylayer")
	 	 (setq cgpl (append cgpl (list p1s)(list "boundary")(list "existing")(list (rtos pcount 2 0))(list code)))
         (setq p1n (rtos pcount 2 0))
	 
	 	 ))
      (if (/= (setq remlist (member ep cgpl)) nil)(progn
						  (setq epn (nth 3 remlist))
						  )
       (progn
	 ;(princ (strcat"\n Lot corner not defined by geometery at " (rtos (car p) 2 6) "," (rtos (cadr p) 2 6) " orange point placed"))
	 (setq pcount (+ pcount 1))
	 ;(command "color" "30" "point" p "color" "bylayer")
	 	 (setq cgpl (append cgpl (list ep)(list "boundary")(list "existing")(list (rtos pcount 2 0))(list code)))
         (setq epn (rtos pcount 2 0))
	 
	 	 ))

     		   (setq lotlist (append lotlist (list (strcat "        <Start pntRef=\""p1n"\"/>"))))
		   (setq lotlist (append lotlist (list (strcat "        <End pntRef=\""epn"\"/>"))))
		(setq lotlist (append lotlist (list (strcat "        <PntList2D>" irbl "</PntList2D>"))))
             (setq lotlist (append lotlist (list "      </IrregularLine>")))
     (setq repeater (- repeater (- iblcount 1)))
       (setq count1 (- count1 2))
   
       )
     (progn;else

   ;get edge names
     (if (/= (setq pos1 (vl-position p1s cgpl)) nil)(progn
						 (setq p1n (nth (+ pos1 3) cgpl))
						  )
       (progn
	 ;(princ (strcat"\n Lot corner not defined by geometery at " (rtos (car p1) 2 6) "," (rtos (cadr p1) 2 6) " orange point placed"))
	 (setq pcount (+ pcount 1))
	 ;(command "color" "30" "point" p1 "color" "bylayer")
	 	 (setq cgpl (append cgpl (list p1s)(list "boundary")(list "existing")(list (rtos pcount 2 0))(list code)))
         (setq p1n (rtos pcount 2 0))
	 
	 	 ))
     (if (/= (setq pos2 (vl-position p2s cgpl)) nil)(progn
						  (setq p2n (nth (+ pos2 3) cgpl))
						  )
       (progn;if not found at corner
	 ;(princ (strcat "\n Lot corner not defined by geometery at" (rtos (car p2) 2 6) "," (rtos (cadr p2) 2 6)" orange point placed"))
	 ;(command "color" "30" "point" p2 "color" "bylayer")
	 (setq pcount (+ pcount 1))
	 (setq cgpl (append cgpl (list p2s)(list "boundary")(list "existing")(list (rtos pcount 2 0))(list code)))
         (setq p2n (rtos pcount 2 0))
	 
	 	 ))
(if (/= p1n p2n)(progn ;is not the same point

		  (if (= (member (strcat p1n "-" p2n) obslist) nil)
		    (progn ;check if lot line has edge observation
		     ; (princ (strcat "\n Lot edge not defined by observation from " (rtos (car p1) 2 3) "," (rtos (cadr p1) 2 3) " to " (rtos (car p2) 2 3) "," (rtos (cadr p2) 2 3) " orange line placed, suggest checking"))
		;	(command "color" "30" "line" p1 p2"" "color" "bylayer")
		      ));p & if no observation
		  
   (if  (= bf 0.0)(progn ;is a line
		   (setq lotlist (append lotlist (list "      <Line>")))
		   (setq lotlist (append lotlist (list (strcat "        <Start pntRef=\""p1n"\"/>"))))
		   (setq lotlist (append lotlist (list (strcat "        <End pntRef=\""p2n"\"/>"))))
		   (setq lotlist (append lotlist (list "      </Line>")))
		   );p
     (progn;is an arc

       
       ;FIGURE OUT centrePOINT
       
               (setq DI (DISTANCE P1 P2))
               (SETQ AZ (ANGLE P1 P2))
                (SETQ MP (POLAR P1 AZ (/ DI 2)))
       		(SETQ H (/ (* BF DI) 2))
		(SETQ AMP (POLAR MP (+ AZ (* 1.5 PI)) H))
		(SETQ X1 (CAR P1))
		(SETQ Y1 (CADR P1))
		(SETQ X2 (CAR AMP))
		(SETQ Y2 (CADR AMP))
		(SETQ X3 (CAR P2))
		(SETQ Y3 (CADR P2))
		(SETQ MA (/ (- Y2 Y1) (- X2 X1)))
		(SETQ MB (/ (- Y3 Y2) (- X3 X2)))
		(SETQ  RPX (/ (- (+ (* MA MB (- Y1 Y3)) (* MB (+ X1 X2)))  (* MA (+ X2 X3)) )(* 2 (- MB MA))))
		(SETQ  RPY (+ (* (* (/ 1 MA) -1) (- RPX (/ (+ X1 X2) 2)))  (/ (+ Y1 Y2) 2)))
       (setq radius (distance amp (list rpx rpy)))
       (SETQ CP (LIST RPX RPY))
		(SETQ CPS (STRCAT (RTOS (CAdR CP) 2 6) " " (RTOS (CAR CP) 2 6)))

    
;note all that work to create the centerpoint should be redundant, as there should be an observation over this arc so....
;       (if (or (setq remlist (member (strcat p1n "-" p2n) arclist))(setq remlist (member (strcat p2n "-" p1n) arclist)))
;  (progn
;    (setq cpn (cadr remlist))
;    )
;  (progn
 ;   (princ (strcat "\n Arc not defined by observation from " (rtos (car p1) 2 3) "," (rtos (cadr p1) 2 3) " to " (rtos (car p2) 2 3) "," (rtos (cadr p2) 2 3) " orange line placed, suggest checking"))
;	(command "color" "30" "line" p1 p2"" "color" "bylayer")

       ;GET centrePPOINT NUMBER
(if (/= (setq pos3 (vl-position CPS cgpl)) nil)(progn
						  (setq cpn (nth (+ pos3 3) cgpl))
						  )
  
      (progn
	 ;(princ (strcat "\n Arc centre not yet defined by geometery at " CPS))
	 (setq pcount (+ pcount 1))
	 (setq cgpl (append cgpl (list CPS)(list "sideshot")(list "existing")(list (rtos pcount 2 0))(list code)))
         (setq CPn (rtos pcount 2 0))
	 
	 	 ))

    
     ;  	)
;	 );if
       
(if (> bf 0)(setq rot "ccw")(setq rot "cw"))
       
       		   (setq lotlist (append lotlist (list (strcat"      <Curve radius=\"" (rtos radius 2 6) "\" rot=\"" rot "\">"))))
		   (setq lotlist (append lotlist (list (strcat "        <Start pntRef=\""p1n"\"/>"))))
                   (setq lotlist (append lotlist (list (strcat "        <Center pntRef=\""cpn"\"/>"))))
		   (setq lotlist (append lotlist (list (strcat "        <End pntRef=\""p2n"\"/>"))))
		   (setq lotlist (append lotlist (list "      </Curve>")))


       );p
     );if LINE OR ARC
		 
		  
		  
   ));p&if p1n is not p2n

       (setq count1 (+ count1 2))
      (setq repeater (- repeater 1))
     
     ));end else and if not irregular
     

    

     
   ));while repeater length of ptlist
  (setq lotlist (append lotlist (list "    </CoordGeom>")))
  (setq lotlist (append lotlist (list "  </Parcel>")))
	));IF XDATA EXISTS
  (setq count (+ count 1))
);r length of lots
);p
  (PRINC "\nWARNING No Adjoining Lots found in Project")
  );if
 
  ;if lots found





  


     ;10.get easement lines
  (princ "\nProcessing Easement Lines")
(IF (/= (setq bdyline (ssget "_X" '((0 . "LINE") (8 . "Easement")))) nil)(progn 
   (setq count 0)
  (repeat (sslength bdyline)
  (SETQ P1 (CDR(ASSOC 10 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ P2 (CDR(ASSOC 11 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME bdyline COUNT)))))

    	    (SETQ XDATAI (ENTGET EN '("LANDXML")))
	    (IF (= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL) (progn
	      	     (COMMAND "CHANGE" en "" "P" "C" "6" "")
	      (princ (strcat "\nERROR Easement Line with no XML data at " (rtos (car p1) 2 3) "," (rtos (cadr p1)2 3)))
	     )
	      (PROGN
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))
    
       (symbolreplace)
     
	  	  

    (setq p1s (strcat (rtos (cadr p1) 2 6) " " (rtos (car p1) 2 6)))
    (setq p2s (strcat (rtos (cadr p2) 2 6) " " (rtos (car p2) 2 6)))

        (setq code "")
    (if (/= (vl-position p1s cgplevel) nil)(setq code (cadr (member p1s cgplevel))))
    (if (/= (vl-position p2s cgplevel) nil)(setq code (cadr (member p2s cgplevel))))

    (if (= (setq pos1 (vl-position p1s cgpl)) nil)(progn
				   (setq pcount (+ pcount 1))
				   (setq is1 (rtos pcount 2 0))
				   (setq cgpl (append cgpl (list p1s)(list "boundary")(list "proposed")(list (rtos pcount 2 0))(list code)))
				   );p
;else
      (setq is1 (nth (+ pos1 3) cgpl))
       );&if
				   
     (if (= (setq pos2 (vl-position p2s cgpl)) nil)(progn
				   (setq pcount (+ pcount 1))
				   (setq is2 (rtos pcount 2 0))
				   (setq cgpl (append cgpl (list p2s)(list "boundary")(list "proposed")(list (rtos pcount 2 0))(list code)))
				   );p
;else
      (setq is2 (nth (+ pos2 3) cgpl))
       );&if

    (setq rocount (+ rocount 1))
    (setq roline (strcat "<ReducedObservation name=\"" (rtos rocount 2 0) "\" desc=\"Boundary\" setupID=\"IS" is1 "\" targetSetupID=\"IS" is2 "\" " xdatai))
    (setq rolist (append rolist (list roline)))
    (setq obslist (append obslist (list (strcat is1 "-" is2))(list ( strcat is2 "-" is1))))
    (setq islist (append islist (list is1 is2)))
	    ));IF XDATA EXISTS
    (setq count (+ count 1))
    );r
   );p
  (PRINC "\nNo Easement Lines found in Project")
  );if
  

;11.get easement arcs
 (princ "\nProcessing Easement Arcs")
(IF (/=  (setq bdyline (ssget "_X" '((0 . "ARC") (8 . "Easement")))) nil)(progn 
 
   (setq count 0)
  (repeat (sslength bdyline)


(SETQ CP (CDR(ASSOC 10 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ RADIUS (CDR(ASSOC 40 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ ANG1 (CDR(ASSOC 50 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ ANG2 (CDR(ASSOC 51 (ENTGET (SSNAME bdyline COUNT)))))
    

  (SETQ P1 (POLAR CP ANG1 RADIUS))
  (SETQ P2 (POLAR CP ANG2 RADIUS))
;CONVERT TO WCS
    (SETQ ZA (CDR(ASSOC 210 (ENTGET (SSNAME bdyline COUNT)))))
    (SETQ CP (TRANS CP ZA 0))
    (SETQ P1 (TRANS P1 ZA 0))
    (SETQ P2 (TRANS P2 ZA 0))
    (if (< (caddr za) 0)(setq TEMP1 P1
			      P1 P2
			      P2 TEMP1))
    

    
    ;get xdata
  (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME bdyline COUNT)))))

    	    (SETQ XDATAI (ENTGET EN '("LANDXML")))
	   (IF (= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL) (progn
	      	     (COMMAND "CHANGE" en "" "P" "C" "6" "")
	      (princ (strcat "\nERROR Easement Arc with no XML data at " (rtos (car p1) 2 3) "," (rtos (cadr p1)2 3)))
	     )
	     (PROGN ;ELSE
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))
    
       (symbolreplace)
	  	  

 
    (setq p1s (strcat (rtos (cadr p1) 2 6) " " (rtos (car p1) 2 6)))
    (setq p2s (strcat (rtos (cadr p2) 2 6) " " (rtos (car p2) 2 6)))
    (setq cps (strcat (rtos (cadr cp) 2 6) " " (rtos (car cp) 2 6)))

            (setq code "")
   (if (/= (vl-position p1s cgplevel) nil)(setq code (cadr (member p1s cgplevel))))
    (if (/= (vl-position p2s cgplevel) nil)(setq code (cadr (member p2s cgplevel))))

;centre of arc
    (if (= (setq pos3 (vl-position cps cgpl)) nil)
      (progn
	(setq pcount (+ pcount 1))
	(setq cpn (rtos pcount 2 0))
	(setq cgpl (append cgpl (list cps)(list "sideshot")(list "proposed")(list (rtos pcount 2 0))(list code)))

	)
      (setq cpn (nth (+ pos3 3) cgpl))
     )

  
    

    (if (= (setq pos1 (vl-position p1s cgpl)) nil)(progn
				   (setq pcount (+ pcount 1))
				   (setq is1 (rtos pcount 2 0))
				   (setq cgpl (append cgpl (list p1s)(list "boundary")(list "proposed")(list (rtos pcount 2 0))(list code)))
				   );p
;else
      (setq is1 (nth (+ pos1 3) cgpl))
       );&if
				   
     (if (= (setq pos2 (vl-position p2s cgpl)) nil)(progn
				   (setq pcount (+ pcount 1))
				   (setq is2 (rtos pcount 2 0))
				   (setq cgpl (append cgpl (list p2s)(list "boundary")(list "proposed")(list (rtos pcount 2 0))(list code)))
				   );p
;else
      (setq is2 (nth (+ pos2 3) cgpl))
       );&if

     (if (/= (setq stringpos (vl-string-search "rot" xdatai )) nil)(progn
(setq wwpos (vl-string-position 34 xdatai (+ stringpos 5)))(setq rot (substr xdatai (+ stringpos 6) (-(- wwpos 1)(+ stringpos 4))))))

    (if (= rot "cw")(progn
		      (setq is1r is1
			is1 is2
			is2 is1r)
		      
      ))
      

    (setq rocount (+ rocount 1))
    (setq roline (strcat "<ReducedArcObservation name=\"" (rtos rocount 2 0) "\" desc=\"Boundary\" setupID=\"IS" is1 "\" targetSetupID=\"IS" is2 "\" " xdatai))
    (setq rolist (append rolist (list roline)))
    (setq obslist (append obslist (list (strcat is1 "-" is2))(list ( strcat is2 "-" is1))))
    (setq islist (append islist (list is1 is2)))
    (setq arclist (append arclist (list (strcat is1 "-" is2))(list cpn) (list (strcat is2 "-" is1))(list cpn)))
	    ));IF XDATA EXISTS
(setq count (+ count 1))
    );r
   );p
  (PRINC "\nNo Easement Arcs found in Project")
  );if


    ;12.get control points
  (princ "\nProcessing Control Points")
(IF (/= (setq bdyline (ssget "_X" '((0 . "POINT") (8 . "PM")))) nil)(progn 
  (setq count 0)
  (repeat (sslength bdyline)


(SETQ P1 (CDR(ASSOC 10 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME bdyline COUNT)))))
    (SETQ ZA (CDR (ASSOC 210 (ENTGET (SSNAME bdyline COUNT)))))
    (SETQ P1 (TRANS P1 ZA 0))

    	    (SETQ XDATAI (ENTGET EN '("LANDXML")))
	    (IF (= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL) (progn
	      	     (COMMAND "CHANGE" en "" "P" "C" "6" "")
	      (princ (strcat "\nERROR Control point with no XML data at " (rtos (car p1) 2 3) "," (rtos (cadr p1)2 3)))
	     )
	      (PROGN ;ELSE
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))
    (symbolreplace)

     

    ;cut pm number from xdata
      (setq ,pos1 (vl-string-position 44 xdatai 0))
    (setq pmnum  (substr xdatai 1 ,pos1 ))
    (setq xdatai  (substr xdatai (+ ,pos1 2) 500))
    ;cut state from xdata

    (if (/= (setq !pos1 (vl-string-position 33 xdatai 0)) nil)(progn
                      (setq pmstate (substr xdatai (+ !pos1 2) 200))
                      (setq xdatai  (substr xdatai 1 !pos1))
		      )
      (setq pmstate "Found")
      )
 
    (setq p1s (strcat (rtos (cadr p1) 2 6) " " (rtos (car p1) 2 6)))

                (setq code "")
    (if (/= (vl-position p1s cgplevel) nil)(setq code (cadr (member p1s cgplevel))))


    (if (= (setq pos1 (vl-position p1s cgpl)) nil)
      (progn

	(setq pcount (+ pcount 1))
(setq is1 (rtos pcount 2 0))
	(setq cgpl (append cgpl (list p1s)(list "control")(list "existing")(list (rtos pcount 2 0))(list code)))
(IF (vl-string-search "latitude" xdatai )
  (setq  rocount (+ rocount 1)
    rolist (append rolist ( list (strcat "<RedHorizontalPosition name=\"" (rtos rocount 2 0) "\" setupID=\"IS" (rtos pcount 2 0) "\" " xdatai)))));horiz
(IF (vl-string-search "height" xdatai )	
  (setq  rocount (+ rocount 1)
	 rolist (append rolist ( list (strcat "<RedVerticalObservation name=\"" (rtos rocount 2 0) "\" setupID=\"IS" (rtos pcount 2 0) "\" " xdatai)))));vertical
  
  (setq pmlist (append pmlist (list p1s ) (list pmnum)))

    
	);if new point

      (progn;write redueced obs regarless of whether the point is new or not (to allow redvert and redhoriz)
(setq is1 (nth (+ pos1 3) cgpl))
	(setq epcount (atof (nth 3 (member p1s cgpl))))
	
	(IF (vl-string-search "latitude" xdatai )
  (setq rocount (+ rocount 1)
    rolist (append rolist ( list (strcat "<RedHorizontalPosition name=\"" (rtos rocount 2 0) "\" setupID=\"IS" (rtos epcount 2 0) "\" " xdatai)))));horiz
(IF (vl-string-search "height" xdatai )	
  (setq rocount (+ rocount 1)
    rolist (append rolist ( list (strcat "<RedVerticalObservation name=\"" (rtos rocount 2 0) "\" setupID=\"IS" (rtos epcount 2 0) "\" " xdatai)))));vertical

		
	)

      );p&if not member of cgpl

    (setq pntref (rtos pcount 2 0))

    ;add pm to monument list

(setq ormtype "")
        (if (= (substr pmnum 1 2) "PM")(setq ormtype ( strcat "type=\"PM\" ")))
  (if (= (substr pmnum 1 2) "TS")(setq ormtype ( strcat "type=\"TS\" ")))
  (if (= (substr pmnum 1 2) "MM")(setq ormtype ( strcat "type=\"MM\" ")))
  (if (= (substr pmnum 1 2) "GB")(setq ormtype ( strcat "type=\"GB\" ")))
  (if (= (substr pmnum 1 2) "CP")(setq ormtype ( strcat "type=\"CP\" ")))
  (if (= (substr pmnum 1 2) "CR")(setq ormtype ( strcat "type=\"CR\" ")))
  (if (= (substr pmnum 1 3) "SSM")(setq ormtype ( strcat "type=\"SSM\" ")))
    
  


    (SETQ xdatai (STRCAT ormtype "state=\""pmstate"\"/>" ));Note comment for desc in xml added to distance entry seperated by a space

	    (if (/= ormtype "")(progn;if control point a SCIMS type mark store in monuments
    (setq moncount (+ moncount 1))
    (setq monline (strcat "<Monument name=\"" (rtos moncount 2 0) "\" pntRef=\"" pntref  "\" " xdatai))
    (if (= (vl-position pntref monlist) nil)(setq monlist (append monlist (list pntref) (list monline))))
    ));if scims type mark
	    (setq islist (append islist (list is1 )))
));IF XDATA EXISTS
	    (setq count (+ count 1))
    );r
  );p
  (PRINC "\nWARNING No Control Points (PM/SSM's) found in Project")
  );if

    

   ;13.get connection lines
  (princ "\nProcessing Connection Lines")
(IF (/= (setq bdyline (ssget "_X" '((0 . "LINE") (8 . "Connection")))) nil)(progn 
   (setq count 0)
  (repeat (sslength bdyline)
  (SETQ P1 (CDR(ASSOC 10 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ P2 (CDR(ASSOC 11 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME bdyline COUNT)))))

    	    (SETQ XDATAI (ENTGET EN '("LANDXML")))
	    (IF (= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL) (progn
	      	     (COMMAND "CHANGE" en "" "P" "C" "6" "")
	      (princ (strcat "\nERROR Connection Line with no XML data at " (rtos (car p1) 2 3) "," (rtos (cadr p1)2 3)))
	     )
	      (PROGN ;ELSE
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))
       (symbolreplace)

    (setq p1s (strcat (rtos (cadr p1) 2 6) " " (rtos (car p1) 2 6)))
    (setq p2s (strcat (rtos (cadr p2) 2 6) " " (rtos (car p2) 2 6)))

    
        (setq code "")
    (if (/= (vl-position p1s cgplevel) nil)(setq code (cadr (member p1s cgplevel))))
    (if (/= (vl-position p2s cgplevel) nil)(setq code (cadr (member p2s cgplevel))))

    (if (= (setq pos1 (vl-position p1s cgpl)) nil)(progn
				   (setq pcount (+ pcount 1))
				   (setq is1 (rtos pcount 2 0))
				   (setq cgpl (append cgpl (list p1s)(list "traverse")(list "proposed")(list (rtos pcount 2 0))(list code)))
				   );p
;else
      (setq is1 (nth (+ pos1 3) cgpl))
       );&if
				   
     (if (= (setq pos2 (vl-position p2s cgpl)) nil)(progn
				   (setq pcount (+ pcount 1))
				   (setq is2 (rtos pcount 2 0))
				   (setq cgpl (append cgpl (list p2s)(list "traverse")(list "proposed")(list (rtos pcount 2 0))(list code)))
				   );p
;else
      (setq is2 (nth (+ pos2 3) cgpl))
       );&if

    (setq rocount (+ rocount 1))
    (setq roline (strcat "<ReducedObservation name=\"" (rtos rocount 2 0) "\" desc=\"Connection\" setupID=\"IS" is1 "\" targetSetupID=\"IS" is2 "\" " xdatai))
    (setq rolist (append rolist (list roline)))
    (setq islist (append islist (list is1 is2)))
	    ));IF XDATA EXISTS
    (setq count (+ count 1))
    );r
   );p
  (PRINC "\nWARNING No Connection Lines found in Project")
  );if

;14.get Connection arcs
  (princ "\nProcessing Connection Arcs")
(IF (/= (setq bdyline (ssget "_X" '((0 . "ARC") (8 . "Connection")))) nil)(progn 
   (setq count 0)
  (repeat (sslength bdyline)


(SETQ CP (CDR(ASSOC 10 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ RADIUS (CDR(ASSOC 40 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ ANG1 (CDR(ASSOC 50 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ ANG2 (CDR(ASSOC 51 (ENTGET (SSNAME bdyline COUNT)))))

  (SETQ P1 (POLAR CP ANG1 RADIUS))
  (SETQ P2 (POLAR CP ANG2 RADIUS))
;CONVERT TO WCS
    (SETQ ZA (CDR(ASSOC 210 (ENTGET (SSNAME bdyline COUNT)))))
    (SETQ CP (TRANS CP ZA 0))
    (SETQ P1 (TRANS P1 ZA 0))
    (SETQ P2 (TRANS P2 ZA 0))
    (if (< (caddr za) 0)(setq TEMP1 P1
			      P1 P2
			      P2 TEMP1))
    

 
    ;get xdata
  (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME bdyline COUNT)))))

    	    (SETQ XDATAI (ENTGET EN '("LANDXML")))
	    (IF (= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL) (progn
	      	     (COMMAND "CHANGE" en "" "P" "C" "6" "")
	      (princ (strcat "\nERROR Connection Arc with no XML data at " (rtos (car p1) 2 3) "," (rtos (cadr p1)2 3)))
	     )
	      (PROGN;ELSE
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))
       (symbolreplace)
 
    (setq p1s (strcat (rtos (cadr p1) 2 6) " " (rtos (car p1) 2 6)))
    (setq p2s (strcat (rtos (cadr p2) 2 6) " " (rtos (car p2) 2 6)))
    (setq cps (strcat (rtos (cadr cp) 2 6) " " (rtos (car cp) 2 6)))

                (setq code "")
    (if (/= (vl-position p1s cgplevel) nil)(setq code (cadr (member p1s cgplevel))))
    (if (/= (vl-position p2s cgplevel) nil)(setq code (cadr (member p2s cgplevel))))

  

    (if (= (setq pos1 (vl-position p1s cgpl)) nil)(progn
				   (setq pcount (+ pcount 1))
				   (setq is1 (rtos pcount 2 0))
				   (setq cgpl (append cgpl (list p1s)(list "traverse")(list "proposed")(list (rtos pcount 2 0))(list code)))
				   );p
;else
      (setq is1 (nth (+ pos1 3) cgpl))
       );&if
				   
     (if (= (setq pos2 (vl-position p2s cgpl)) nil)(progn
				   (setq pcount (+ pcount 1))
				   (setq is2 (rtos pcount 2 0))
				   (setq cgpl (append cgpl (list p2s)(list "traverse")(list "proposed")(list (rtos pcount 2 0))(list code)))
				   );p
;else
      (setq is2 (nth (+ pos2 3) cgpl))
       );&if

     (if (/= (setq stringpos (vl-string-search "rot" xdatai )) nil)(progn
(setq wwpos (vl-string-position 34 xdatai (+ stringpos 5)))(setq rot (substr xdatai (+ stringpos 6) (-(- wwpos 1)(+ stringpos 4))))))

    (if (= rot "cw")(progn
		      (setq is1r is1
			is1 is2
			is2 is1r)
		      
      ))
      

    (setq rocount (+ rocount 1))
    (setq roline (strcat "<ReducedArcObservation name=\"" (rtos rocount 2 0) "\" desc=\"Connection\" setupID=\"IS" is1 "\" targetSetupID=\"IS" is2 "\" " xdatai))
    (setq rolist (append rolist (list roline)))
    (setq islist (append islist (list is1 is2)))
  ));IF XDATA EXISTS
    (setq count (+ count 1))

    );r
   );p
  (PRINC "\nNo Conection Arcs found in Project")
  );if

    ;15.get PM connection lines
  (princ "\nProcessing PM Connection Lines")
(IF (/= (setq bdyline (ssget "_X" '((0 . "LINE") (8 . "PM Connection")))) nil)(progn 
  (setq count 0)
  (repeat (sslength bdyline)
  (SETQ P1 (CDR(ASSOC 10 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ P2 (CDR(ASSOC 11 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME bdyline COUNT)))))

    	    (SETQ XDATAI (ENTGET EN '("LANDXML")))
	    (IF (= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL) (progn
	      	     (COMMAND "CHANGE" en "" "P" "C" "6" "")
	      (princ (strcat "\nERROR PM Connection Line with no XML data at " (rtos (car p1) 2 3) "," (rtos (cadr p1)2 3)))
	     )
	      (PROGN
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))
       (symbolreplace)

    (setq p1s (strcat (rtos (cadr p1) 2 6) " " (rtos (car p1) 2 6)))
    (setq p2s (strcat (rtos (cadr p2) 2 6) " " (rtos (car p2) 2 6)))

                    (setq code "")
    (if (/= (vl-position p1s cgplevel) nil)(setq code (cadr (member p1s cgplevel))))
    (if (/= (vl-position p2s cgplevel) nil)(setq code (cadr (member p2s cgplevel))))
    

    (if (= (setq pos1 (vl-position p1s cgpl)) nil)(progn
				   (setq pcount (+ pcount 1))
				   (setq is1 (rtos pcount 2 0))
				   (setq cgpl (append cgpl (list p1s)(list "traverse")(list "proposed")(list (rtos pcount 2 0))(list code)))
				   );p
;else
      (setq is1 (nth (+ pos1 3) cgpl))
       );&if
				   
     (if (= (setq pos2 (vl-position p2s cgpl)) nil)(progn
				   (setq pcount (+ pcount 1))
				   (setq is2 (rtos pcount 2 0))
				   (setq cgpl (append cgpl (list p2s)(list "traverse")(list "proposed")(list (rtos pcount 2 0))(list code)))
				   );p
;else
      (setq is2 (nth (+ pos2 3) cgpl))
       );&if

    (setq rocount (+ rocount 1))
    (setq roline (strcat "<ReducedObservation name=\"" (rtos rocount 2 0) "\" desc=\"Connection\" setupID=\"IS" is1 "\" targetSetupID=\"IS" is2 "\" " xdatai))
    (setq rolist (append rolist (list roline)))
    (setq islist (append islist (list is1 is2)))
	    ));IF XDATA EXISTS
    (setq count (+ count 1))
    );r
  );p
  (PRINC "\nWARNING No PM connections found in Project")
  );if



     ;16.get RM points
  (princ "\nProcessing RM's")
(IF (/= (setq bdyline (ssget "_X" '((0 . "POINT") (8 . "Monument")))) nil)(progn 
  (setq count 0)
  (repeat (sslength bdyline)


(SETQ P1 (CDR(ASSOC 10 (ENTGET (SSNAME bdyline COUNT)))))
(SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME bdyline COUNT)))))
    (SETQ ZA (CDR (ASSOC 210 (ENTGET (SSNAME bdyline COUNT)))))
    (SETQ P1 (TRANS P1 ZA 0))

    	    (SETQ XDATAI (ENTGET EN '("LANDXML")))
	    (IF (= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL) (progn
	      	     (COMMAND "CHANGE" en "" "P" "C" "6" "")
	      (princ (strcat "\nERROR RM point with no XML data at " (rtos (car p1) 2 3) "," (rtos (cadr p1)2 3)))
	     )
	      (PROGN
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))
       (symbolreplace)

     (if (/= (setq stringpos (vl-string-search "state" xdatai )) nil)(progn
	(setq wwpos (vl-string-position 34 xdatai (+ stringpos 7)))(setq rmstate (substr xdatai (+ stringpos 8) (-(- wwpos 1)(+ stringpos 6)))))(setq rmstate ""))


    (if (/= (setq stringpos (vl-string-search "type" xdatai )) nil)(progn
	(setq wwpos (vl-string-position 34 xdatai (+ stringpos 6)))(setq rmtype (substr xdatai (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5)))))(setq rmtype ""))

    
 
 
    
    (setq p1s (strcat (rtos (cadr p1) 2 6) " " (rtos (car p1) 2 6)))

                        (setq code "")
    (if (/= (vl-position p1s cgplevel) nil)(setq code (cadr (member p1s cgplevel))))
    

    (if (= (setq pos1 (vl-position p1s cgpl)) nil)(progn
				    (setq pcount (+ pcount 1))
    (setq cgpl (append cgpl (list p1s)(list "reference")))
    (if (or (= rmstate "Placed")(= rmstate "New"))(setq cgpl (append cgpl (list "proposed")(list (rtos pcount 2 0))(list code)));if new
    (setq cgpl (append cgpl (list "existing")(list (rtos pcount 2 0))(list code))));else
				   (setq pntref (rtos pcount 2 0))
				   );if not member
      (progn;else i.e. found in list i.e. mark on corner
(setq pntref (nth (+ pos1 3) cgpl))
	))

    (if (and (or (= rmtype "SSM")(= rmtype "PM")(= rmtype "TS")(= rmtype "MM")(= rmtype "GB")(= rmtype "CP")(= rmtype "CR"))
	     (setq pmnth (vl-position pntref monlist)))
      (progn
	(setq monlist (remove_nth  monlist pmnth))
	(setq monlist (remove_nth monlist pmnth ))
	)
      )
	
	   
    (setq moncount (+ moncount 1))
    (setq monline (strcat "<Monument name=\"" (rtos moncount 2 0) "\" pntRef=\"" pntref  "\" " xdatai))
    (setq monlist (append monlist (list pntref)(list monline)))

    
  ));IF XDATA EXISTS
    (setq count (+ count 1))

    );r
  );p
  (PRINC "\nWARNING No Reference Marks found in Project")
  );if

     ;17.get RM connection lines
  (princ "\nProcessing RM connections")
(IF (/= (setq bdyline (ssget "_X" '((0 . "LINE") (8 . "RM Connection")))) nil)(progn 
  (setq count 0)
  (repeat (sslength bdyline)
  (SETQ P1 (CDR(ASSOC 10 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ P2 (CDR(ASSOC 11 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME bdyline COUNT)))))

    	    (SETQ XDATAI (ENTGET EN '("LANDXML")))
	    (IF (= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL) (progn
	      	     (COMMAND "CHANGE" en "" "P" "C" "6" "")
	      (princ (strcat "\nERROR RM Connection with no XML data at " (rtos (car p1) 2 3) "," (rtos (cadr p1)2 3)))
	     )
	      (PROGN;ELSE
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))
       (symbolreplace)

    (setq p1s (strcat (rtos (cadr p1) 2 6) " " (rtos (car p1) 2 6)))
    (setq p2s (strcat (rtos (cadr p2) 2 6) " " (rtos (car p2) 2 6)))

                    (setq code "")
     (if (/= (vl-position p1s cgplevel) nil)(setq code (cadr (member p1s cgplevel))))
    (if (/= (vl-position p2s cgplevel) nil)(setq code (cadr (member p2s cgplevel))))

	    
    (if (= (setq pos1 (vl-position p1s cgpl)) nil)(progn
				   (setq pcount (+ pcount 1))
				   (setq is1 (rtos pcount 2 0))
				   (setq cgpl (append cgpl (list p1s)(list "traverse")(list "proposed")(list (rtos pcount 2 0))(list code)))
				   );p
;else
      (setq is1 (nth (+ pos1 3) cgpl))
       );&if
				   
     (if (= (setq pos2 (vl-position p2s cgpl)) nil)(progn
				   (setq pcount (+ pcount 1))
				   (setq is2 (rtos pcount 2 0))
				   (setq cgpl (append cgpl (list p2s)(list "traverse")(list "proposed")(list (rtos pcount 2 0))(list code)))
				   );p
;else
      (setq is2 (nth (+ pos2 3) cgpl))
       );&if

    (setq rocount (+ rocount 1))
    (setq roline (strcat "<ReducedObservation name=\"" (rtos rocount 2 0) "\" desc=\"Reference\" setupID=\"IS" is1 "\" targetSetupID=\"IS" is2 "\" " xdatai))
    (setq rolist (append rolist (list roline)))
    (setq islist (append islist (list is1 is2)))
	    ));IF XDATA EXISTS
    (setq count (+ count 1))
    );r
  );p
  (PRINC "\nWARNING No Refernce Mark Connections found in Project")
  );if

     ;17a. get Height Difference connection lines
  (princ "\nProcessing Height Difference connections")
(IF (/= (setq bdyline (ssget "_X" '((0 . "LINE") (8 . "Height Difference")))) nil)(progn 
  (setq count 0)
  (repeat (sslength bdyline)
  (SETQ P1 (CDR(ASSOC 10 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ P2 (CDR(ASSOC 11 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME bdyline COUNT)))))

    	    (SETQ XDATAI (ENTGET EN '("LANDXML")))
	    (IF (= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL) (progn
	      	     (COMMAND "CHANGE" en "" "P" "C" "6" "")
	      (princ (strcat "\nERROR Height Difference with no XML data at " (rtos (car p1) 2 3) "," (rtos (cadr p1)2 3)))
	     )
	      (PROGN;ELSE
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))
       (symbolreplace)

    (setq p1s (strcat (rtos (cadr p1) 2 6) " " (rtos (car p1) 2 6)))
    (setq p2s (strcat (rtos (cadr p2) 2 6) " " (rtos (car p2) 2 6)))

                    (setq code "")
    (if (/= (vl-position p1s cgplevel) nil)(setq code (cadr (member p1s cgplevel))))
    (if (/= (vl-position p2s cgplevel) nil)(setq code (cadr (member p2s cgplevel))))

    (if (= (setq pos1 (member p1s cgpl)) nil)(progn
				   (setq pcount (+ pcount 1))
				   (setq is1 (rtos pcount 2 0))
				   (setq cgpl (append cgpl (list p1s)(list "traverse")(list "proposed")(list (rtos pcount 2 0))(list code)))
				   );p
;else
      (setq is1 (nth (+ pos1 3) cgpl))
       );&if
				   
     (if (= (setq pos2 (member p2s cgpl)) nil)(progn
				   (setq pcount (+ pcount 1))
				   (setq is2 (rtos pcount 2 0))
				   (setq cgpl (append cgpl (list p2s)(list "traverse")(list "proposed")(list (rtos pcount 2 0))(list code)))
				   );p
;else
      (setq is2 (nth (+ pos2 3) cgpl))
       );&if

    (setq rocount (+ rocount 1))
    (setq roline (strcat "<ReducedObservation name=\"" (rtos rocount 2 0) "\" desc=\"Height Difference\" setupID=\"IS" is1 "\" targetSetupID=\"IS" is2 "\" " xdatai))
    (setq rolist (append rolist (list roline)))
    (setq islist (append islist (list is1 is2)))
	    ));IF XDATA EXISTS
    (setq count (+ count 1))
    );r
  );p
  (PRINC "\nNote - No Height Connections lines found in Project")
  );if

   ;18.Plan features - Fences,Walls,Kerbs,Buildings - Lines
(princ "\nProcessing Plan Features, Occupation Lines, ")
  (IF (/= (setq bdyline (ssget "_X" '((0 . "LINE") (8 . "Occupation Fences,Occupation Walls,Occupation Kerbs,Occupation Buildings")))) nil)
    (progn 
  (setq count 0)
  (repeat (sslength bdyline)
  (SETQ P1 (CDR(ASSOC 10 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ P2 (CDR(ASSOC 11 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME bdyline COUNT)))))
    (SETQ LAYER (CDR(ASSOC 8 (ENTGET (SSNAME bdyline COUNT)))))

    (setq occtype  (substr layer 12 (- (strlen layer) 12 )))

      (SETQ XDATAI (ENTGET EN '("LANDXML")))
	    (IF (= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL)(SETQ XDATAI occtype)
    (PROGN
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))))
    (setq xdatai (strcat "desc=\"" xdatai "\""))
       (symbolreplace)
    
    (setq p1s (strcat (rtos (cadr p1) 2 6) " " (rtos (car p1) 2 6)))
    (setq p2s (strcat (rtos (cadr p2) 2 6) " " (rtos (car p2) 2 6)))

    (setq code "")
    (if (/= (vl-position p1s cgplevel) nil)(setq code (cadr (member p1s cgplevel))))
    (if (/= (vl-position p2s cgplevel) nil)(setq code (cadr (member p2s cgplevel))))

    (if (= (setq pos1 (vl-position p1s cgpl)) nil)(progn
				   (setq pcount (+ pcount 1))
				   (setq p1n (rtos pcount 2 0))
				   (setq cgpl (append cgpl (list p1s)(list "sideshot")(list "proposed")(list (rtos pcount 2 0))(list code)))
				   );p
      (setq p1n (nth (+ pos1 3) cgpl))

       );&if
     (if (= (setq pos2 (vl-position p2s cgpl)) nil)(progn
				   (setq pcount (+ pcount 1))
				   (setq p2n (rtos pcount 2 0))
				   (setq cgpl (append cgpl (list p2s)(list "sideshot")(list "proposed")(list (rtos pcount 2 0))(list code)))
				   );p
       (setq p2n (nth (+ pos2 3) cgpl))
       );&if

    

    (setq pflist (append pflist (list (strcat"  <PlanFeature name=\"" occtype (rtos pffcount 2 0) "\" " xdatai ">"))
			 (list (strcat "    <CoordGeom name=\""(rtos cogeocount 2 0) "\">"))
			 (list "      <Line>")
			 (list (strcat "      <Start pntRef=\""p1n"\"/>"))
			 (list (strcat "      <End pntRef=\""p2n"\"/>"))
			 (list "      </Line>")
			 (list "    </CoordGeom>")
			 (list "  </PlanFeature>")
			 ))
	    (setq pffcount (+ pffcount 1))
	    (setq cogeocount (+ cogeocount 1))
	    (setq count (+ count 1))
    );r
  );p
     );if


     ;19.Plan features - Fences,Walls,Kerbs,Buildings - Arcs
(princ "Occupation Arcs, ")
  (IF (/= (setq bdyline (ssget "_X" '((0 . "ARC") (8 . "Occupation Fences,Occupation Walls,Occupation Kerbs,Occupation Buildings")))) nil)(progn
 (setq count 0)
  (repeat (sslength bdyline)
(SETQ CP (CDR(ASSOC 10 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ RADIUS (CDR(ASSOC 40 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ ANG1 (CDR(ASSOC 50 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ ANG2 (CDR(ASSOC 51 (ENTGET (SSNAME bdyline COUNT)))))
    (setq layer (CDR(ASSOC 8 (ENTGET (SSNAME bdyline COUNT)))))

    (setq occtype  (substr layer 12 (- (strlen layer) 12 )))
  
  (SETQ P1 (POLAR CP ANG1 RADIUS))
  (SETQ P2 (POLAR CP ANG2 RADIUS))
;CONVERT TO WCS
    (SETQ ZA (CDR(ASSOC 210 (ENTGET (SSNAME bdyline COUNT)))))
    (SETQ CP (TRANS CP ZA 0))
    (SETQ P1 (TRANS P1 ZA 0))
    (SETQ P2 (TRANS P2 ZA 0))
    (if (< (caddr za) 0)(setq TEMP1 P1
			      P1 P2
			      P2 TEMP1))
    
       

    (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME bdyline COUNT)))))
(SETQ XDATAI (ENTGET EN '("LANDXML")))
	    (IF (= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL)(SETQ XDATAI occtype)
    (PROGN
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))))
    (setq xdatai (strcat "desc=\"" xdatai "\""))
        (symbolreplace)

    
    (setq p1s (strcat (rtos (cadr p1) 2 6) " " (rtos (car p1) 2 6)))
    (setq p2s (strcat (rtos (cadr p2) 2 6) " " (rtos (car p2) 2 6)))
    (setq cps (strcat (rtos (cadr cp) 2 6) " " (rtos (car cp) 2 6)))

        (setq code "")
    
(if (/= (vl-position p1s cgplevel) nil)(setq code (cadr (member p1s cgplevel))))
(if (/= (vl-position p2s cgplevel) nil)(setq code (cadr (member p2s cgplevel))))    
;centre of arc
    
    (if (= (setq pos3 (vl-position cps cgpl)) nil)
      (progn
	(setq pcount (+ pcount 1))
	(setq cpn (rtos pcount 2 0))
	(setq cgpl (append cgpl (list cps)(list "sideshot")(list "proposed")(list (rtos pcount 2 0))(list code)))
	)
      (setq cpn (nth (+ pos3 3) cgpl))
      )
    (if (= (setq pos1 (vl-position p1s cgpl)) nil)(progn
				   (setq pcount (+ pcount 1))
				   (setq p1n (rtos pcount 2 0))
				   (setq cgpl (append cgpl (list p1s)(list "sideshot")(list "proposed")(list (rtos pcount 2 0))(list code)))
				   );p
      (setq p1n (nth (+ pos1 3) cgpl))
      );&if
     (if (= (setq pos2(vl-position p2s cgpl)) nil)(progn
				   (setq pcount (+ pcount 1))
				   (setq p2n (rtos pcount 2 0))
				   (setq cgpl (append cgpl (list p2s)(list "sideshot")(list "proposed")(list (rtos pcount 2 0))(list code)))
				   );p
       (setq p2n (nth (+ pos2 3) cgpl))
       );&if

    
     

    
    (setq pflist (append pflist (list (strcat"  <PlanFeature name=\"" occtype (rtos pffcount 2 0) "\" "  xdatai ">"))
			 (list (strcat "    <CoordGeom name=\""(rtos cogeocount 2 0) "\">"))
			 (list (strcat"      <Curve radius=\"" (rtos radius 2 6) "\" rot=\"ccw\">"))
			 (list (strcat "      <Start pntRef=\""p1n"\"/>"))
			 (list (strcat "      <Center pntRef=\""cpn"\"/>"))
			 (list (strcat "      <End pntRef=\""p2n"\"/>"))
			 (list "      </Curve>")
			 (list "    </CoordGeom>")
			 (list "  </PlanFeature>")
			 ))
	    (setq pffcount (+ pffcount 1))
	    (setq cogeocount (+ cogeocount 1))
	    (setq count (+ count 1))
    )));r

  
   ;26.Plan features - Fences,Walls,Kerbs,Buildings - Polyline
    (princ "Occupation PolyLines ")
 (IF (/= (setq lots (ssget "_X" '((0 . "LWPOLYLINE") (8 . "Occupation Fences,Occupation Walls,Occupation Kerbs,Occupation Buildings")))) nil)(progn
(setq count 0)
  (repeat (sslength lots)
    (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME lots COUNT)))))
     (setq layer (CDR(ASSOC 8 (ENTGET (SSNAME lots COUNT)))))

    (setq occtype  (substr layer 12 (- (strlen layer) 12 )))
    
   (SETQ XDATAI (ENTGET EN '("LANDXML")))
	    (IF (= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL)(SETQ XDATAI occtype)
    (PROGN
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))))
    (setq xdatai (strcat "desc=\"" xdatai "\""))
       (symbolreplace)
    (SETQ CLOSED (CDR(ASSOC 70 (ENTGET (SSNAME lots COUNT)))))
;write to list
  (setq pflist (append pflist (list (strcat"  <PlanFeature name=\"" occtype (rtos pffcount 2 0) "\" " xdatai ">"))))
  (setq pflist (append pflist (list (strcat "    <CoordGeom name=\"" (rtos cogeocount 2 0) "\">"))))
  (setq cogeocount (+ cogeocount 1))
					(setq enlist (entget en))
    ;go through polyline to get points and bugle factors
    (SETQ PTLIST (LIST))
	    (foreach a enlist
	      (if (= 10 (car a))

		(setq PTLIST (append PTLIST (list (cdr a))))
	      )				;IF
	      (if (= 42 (car a))
		(setq PTLIST (append PTLIST (LIST (cdr a))))
		);if
	    )				;FOREACH 			
(IF (or (= CLOSED 1)(= closed 129))(SETQ PTLIST (APPEND PTLIST (LIST(NTH 0 PTLIST))(LIST(NTH 1 PTLIST)))))

    (setq count1 0)
 (repeat (- (/ (length ptlist) 2) 1)
   (setq p1 (nth count1 ptlist))
   (setq p1s (strcat (rtos (cadr p1) 2 6) " " (rtos (car p1) 2 6)))
   (setq p2 (nth (+ count1 2) ptlist))
   (setq p2s (strcat (rtos (cadr p2) 2 6) " " (rtos (car p2) 2 6)))

       (setq code "")
  (if (/= (vl-position p1s cgplevel) nil)(setq code (cadr (member p1s cgplevel))))
  (if (/= (vl-position p2s cgplevel) nil)(setq code (cadr (member p2s cgplevel)))) 
   
   (setq bf (nth (+ count1 1) ptlist))
   ;get edge names
     (if (/= (setq pos1 (vl-position p1s cgpl)) nil)(progn
						 (setq p1n (nth (+ pos1 3) cgpl))
						  )
       (progn
	 ;(princ (strcat"\n Lot corner not defined by geometery at " p1s))
         (setq pcount (+ pcount 1))
	 (setq cgpl (append cgpl (list p1s)(list "sideshot")(list "proposed")(list (rtos pcount 2 0))(list code)))
         (setq p1n (rtos pcount 2 0))
	 	 ))
     (if (/= (setq pos2 (vl-position p2s cgpl)) nil)(progn
						  (setq p2n (nth (+ pos2 3) cgpl))
						  )
       (progn;if not found at corner
	 ;(princ (strcat "\n Lot corner yet not defined by geometery at " p2s))
	 (setq pcount (+ pcount 1))
	 (setq cgpl (append cgpl (list p2s)(list "sideshot")(list "proposed")(list (rtos pcount 2 0))(list code)))
         (setq p2n (rtos pcount 2 0))
	 	 ))
   (if (= bf 0.0)(progn ;is a line
		   (setq pflist (append pflist (list "      <Line>")))
		   (setq pflist (append pflist (list (strcat "        <Start pntRef=\""p1n"\"/>"))))
		   (setq pflist (append pflist (list (strcat "        <End pntRef=\""p2n"\"/>"))))
		   (setq pflist (append pflist (list "      </Line>")))
		   );p
     (progn;is an arc
       ;FIGURE OUT centrePOINT
               (setq DI (DISTANCE P1 P2))
               (SETQ AZ (ANGLE P1 P2))
                (SETQ MP (POLAR P1 AZ (/ DI 2)))
       		(SETQ H (/ (* BF DI) 2))
		(SETQ AMP (POLAR MP (+ AZ (* 1.5 PI)) H))
		(SETQ X1 (CAR P1))
		(SETQ Y1 (CADR P1))
		(SETQ X2 (CAR AMP))
		(SETQ Y2 (CADR AMP))
		(SETQ X3 (CAR P2))
		(SETQ Y3 (CADR P2))
		(SETQ MA (/ (- Y2 Y1) (- X2 X1)))
		(SETQ MB (/ (- Y3 Y2) (- X3 X2)))
		(SETQ  RPX (/ (- (+ (* MA MB (- Y1 Y3)) (* MB (+ X1 X2)))  (* MA (+ X2 X3)) )(* 2 (- MB MA))))
		(SETQ  RPY (+ (* (* (/ 1 MA) -1) (- RPX (/ (+ X1 X2) 2)))  (/ (+ Y1 Y2) 2)))
       (setq radius (distance amp (list rpx rpy)))
       (SETQ CP (LIST RPX RPY))
		(SETQ CPS (STRCAT (RTOS (CAdR CP) 2 6) " " (RTOS (CAR CP) 2 6)))
       ;GET centrePPOINT NUMBER
(if (/= (setq pos3 (vl-position CPS cgpl)) nil)(progn
						  (setq cpn (nth (+ pos3 3) cgpl))
						  )
       (progn
	 ;(princ (strcat "\n Arc centre not yet defined by geometery at " CPS))
	 (setq pcount (+ pcount 1))
	 (setq cgpl (append cgpl (list CPS)(list "sideshot")(list "proposed")(list (rtos pcount 2 0))(list code)))
         (setq CPn (rtos pcount 2 0))
	 	 ))
(if (> bf 0)(setq rot "ccw")(setq rot "cw"))
       		   (setq pflist (append pflist (list (strcat"      <Curve radius=\"" (rtos radius 2 6) "\" rot=\"" rot "\">"))))
		   (setq pflist (append pflist (list (strcat "        <Start pntRef=\""p1n"\"/>"))))
                   (setq pflist (append pflist (list (strcat "        <Center pntRef=\""cpn"\"/>"))))
		   (setq pflist (append pflist (list (strcat "        <End pntRef=\""p2n"\"/>"))))
		   (setq pflist (append pflist (list "      </Curve>")))
       );p
     );if LINE OR ARC
  (setq count1 (+ count1 2))
   );r length of ptlist
  (setq pflist (append pflist (list "    </CoordGeom>")))
  (setq pflist (append pflist (list "  </PlanFeature>")))
  (setq count (+ count 1))
  (setq pffcount (+ pffcount 1))
);r length of lots
										    ));p&if lots found



  
      ;30. Occupation Offsets
  (princ "\nProcessing Occupation Offsets")
(IF (/= (setq bdyline (ssget "_X" '((0 . "LINE") (8 . "Occupations")))) nil)(progn 
  (setq count 0)
  (repeat (sslength bdyline)
  (SETQ P1 (CDR(ASSOC 10 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ P2 (CDR(ASSOC 11 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME bdyline COUNT)))))

    	    (SETQ XDATAI (ENTGET EN '("LANDXML")))
	  (IF (= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL) (progn
	      	     (COMMAND "CHANGE" en "" "P" "C" "6" "")
	      (princ (strcat "\nERROR Occupation Line with no XML data at " (rtos (car p1) 2 3) "," (rtos (cadr p1)2 3)))
	     )
	    (PROGN
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))
       (symbolreplace)

    (setq p1s (strcat (rtos (cadr p1) 2 6) " " (rtos (car p1) 2 6)))
    (setq p2s (strcat (rtos (cadr p2) 2 6) " " (rtos (car p2) 2 6)))

    (setq code "")
  (if (/= (vl-position p1s cgplevel) nil)(setq code (cadr (member p1s cgplevel))))
  (if (/= (vl-position p2s cgplevel) nil)(setq code (cadr (member p2s cgplevel))))
	    
    (if (= (setq pos1 (vl-position p1s cgpl)) nil)(progn
				   (setq pcount (+ pcount 1))
				   (setq p1n (rtos pcount 2 0))
				   (setq cgpl (append cgpl (list p1s)(list "sideshot")(list "proposed")(list (rtos pcount 2 0))(list code)))
				   
				   );p
      (setq p1n (nth (+ pos1 3) cgpl))      
       );&if
				   
     (if (= (setq pos2 (vl-position p2s cgpl)) nil)(progn
				   (setq pcount (+ pcount 1))
				   (setq p2n (rtos pcount 2 0))
				   (setq cgpl (append cgpl (list p2s)(list "sideshot")(list "proposed")(list (rtos pcount 2 0))(list code)))
				  
				   );p
       (setq p2n (nth (+ pos2 3) cgpl))
       );&if
         
    (setq pflist (append pflist (list xdatai)
			 (list (strcat "    <CoordGeom name=\""(rtos cogeocount 2 0) "\">"))
			 (list (strcat"      <Line>"))
			 (list (strcat "      <Start pntRef=\""p1n"\"/>"))
			 (list (strcat "      <End pntRef=\""p2n"\"/>"))
			 (list "      </Line>")
			 (list "    </CoordGeom>")
			 (list "  </PlanFeature>")
			 ))
	    
	    (setq cogeocount (+ cogeocount 1))
	    ));IF XDATA EXISTS
	    (setq count (+ count 1))
    )));r

     ;31. get Occupation points
  (princ "\nProcessing Occupation Points")
(IF (/= (setq bdyline (ssget "_X" '((0 . "POINT") (8 . "Occupations")))) nil)(progn 
  (setq count 0)
  (repeat (sslength bdyline)


(SETQ P1 (CDR(ASSOC 10 (ENTGET (SSNAME bdyline COUNT)))))
(SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME bdyline COUNT)))))
    (SETQ ZA (CDR (ASSOC 210 (ENTGET (SSNAME bdyline COUNT)))))
    (SETQ P1 (TRANS P1 ZA 0))

    	    (SETQ XDATAI (ENTGET EN '("LANDXML")))
	    (IF (= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL) (progn
	      	     (COMMAND "CHANGE" en "" "P" "C" "6" "")
	      (princ (strcat "\nOccupation Point with no XML data at " (rtos (car p1) 2 3) "," (rtos (cadr p1)2 3)))
	     )
	      (PROGN
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))

     (if (/= (setq stringpos (vl-string-search "state" xdatai )) nil)(progn
	(setq wwpos (vl-string-position 34 xdatai (+ stringpos 7)))(setq rmstate (substr xdatai (+ stringpos 8) (-(- wwpos 1)(+ stringpos 6)))))(setq rmstate ""))
 
    (setq p1s (strcat (rtos (cadr p1) 2 6) " " (rtos (car p1) 2 6)))
    
(setq code "")
    (if (/= (vl-position p1s cgplevel) nil)(setq code (cadr (member p1s cgplevel))))
    
    
    (if (= (setq pos1 (vl-position p1s cgpl)) nil)(progn
				    (setq pcount (+ pcount 1))
				   
    (setq cgpl (append cgpl (list p1s)(list "sideshot") (list "existing")(list (rtos pcount 2 0))(list code)))
 
				   (setq pntref (rtos pcount 2 0))
				   );if not member
      (progn;else i.e. found in list i.e. mark on corner
(setq pntref (nth (+ pos1 3) cgpl))
	))
				   
       (symbolreplace)

				   
    (setq moncount (+ moncount 1))
    (setq monline (strcat "<Monument name=\"" (rtos moncount 2 0) "\" pntRef=\"" pntref  "\" " xdatai))
    (setq monlist (append monlist (list pntref)(list monline)))
	    ));IF XDATA EXISTS
				    
    (setq count (+ count 1))
    

    )));r

;32.------------------------FLOW ARROWS---------------------------------------------  
  (princ "\nProcessing Flow Arrows")
     (IF (/= (setq bdyline (ssget "_X" '((0 . "INSERT") (2 . "DFAT")))) nil)
	     (progn
	       
  (setq count 0)
  (setq fac 1)
  (repeat (sslength bdyline)

    (setq NAME (CDR(ASSOC 2 (ENTGET (SSNAME bdyline COUNT)))))
    (SETQ EN (CDR (ASSOC -1 (ENTGET (SSNAME bdyline COUNT)))))
    (SETQ P1 (CDR (ASSOC 10 (ENTGET (SSNAME bdyline COUNT)))))
      	    (SETQ XDATAI (ENTGET EN '("LANDXML")))
	  (IF (= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL) (progn
	      	     (COMMAND "CHANGE" en "" "P" "C" "6" "")
	      (princ (strcat "\nERROR Flow Arrow with no XML data at " (rtos (car p1) 2 3) "," (rtos (cadr p1)2 3)))
	     )
	    (PROGN
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))
    (symbolreplace)

    (setq !pos1 (vl-string-position 33 xdatai 0))
                      (setq P1S (substr xdatai (+ !pos1 2) 200))
                      (setq P2S  (substr xdatai 1 !pos1))

    		 (setq ,pos1 (vl-string-position 44 P1S 0))
                 (SETQ P1S (STRCAT (substr P1S (+ ,pos1 2) 50) " " (substr P1S 1 ,pos1)))
                 (setq ,pos1 (vl-string-position 44 P2S 0))
                 (SETQ P2S (STRCAT (substr P2S (+ ,pos1 2) 50) " " (substr P2S 1 ,pos1)))
    
       (setq code "")
  (if (/= (vl-position p1s cgplevel) nil)(setq code (cadr (member p1s cgplevel))))
  (if (/= (vl-position p2s cgplevel) nil)(setq code (cadr (member p2s cgplevel))))
    

    (if (= (setq pos1(vl-position p1s cgpl)) nil)(progn
				   (setq pcount (+ pcount 1))
				   (setq p1n (rtos pcount 2 0))
				   (setq cgpl (append cgpl (list p1s)(list "sideshot")(list "proposed")(list (rtos pcount 2 0))(list code)))
				   );p
      (setq p1n (nth (+ pos1 3) cgpl))

       );&if
     (if (= (setq pos2(vl-position p2s cgpl)) nil)(progn
				   (setq pcount (+ pcount 1))
				   (setq p2n (rtos pcount 2 0))
				   (setq cgpl (append cgpl (list p2s)(list "sideshot")(list "proposed")(list (rtos pcount 2 0))(list code)))
				   );p
       (setq p2n (nth (+ pos2 3) cgpl))
       );&if

       
(if (= name "DFAT")(setq name "Direction Of Flow Tidal"))
    (if (= name "DFANT")(setq name "Direction Of Flow Non Tidal"))
    (setq flowarrows (strcat flowarrows "    <Annotation type=\"" name "\" name=\"" (rtos annocount 2 0) "\" desc=\""p1n ", "p2n"\"/>" (chr 10)))
			
	   (setq annocount (+ annocount 1))
	    
));IF XDATA EXISTS
	    (setq count (+ count 1))
  
    );r
  );p
     );if

    (IF  (/= (setq bdyline (ssget "_X" '((0 . "INSERT") (2 . "DFANT")))) nil)
	     (progn
	       
  (setq count 0)
  (setq fac 1)
  (repeat (sslength bdyline)

    (setq NAME (CDR(ASSOC 2 (ENTGET (SSNAME bdyline COUNT)))))
    (SETQ EN (CDR (ASSOC -1 (ENTGET (SSNAME bdyline COUNT)))))
    (SETQ P1 (CDR (ASSOC 10 (ENTGET (SSNAME bdyline COUNT)))))
      	    (SETQ XDATAI (ENTGET EN '("LANDXML")))
	  (IF (= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL) (progn
	      	     (COMMAND "CHANGE" en "" "P" "C" "6" "")
	      (princ (strcat "\nFlow Arrow with no XML data at " (rtos (car p1) 2 3) "," (rtos (cadr p1)2 3)))
	     )
	    (PROGN
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))

    (setq !pos1 (vl-string-position 33 xdatai 0))
                      (setq P1S  (substr xdatai 1 !pos1))
                      (setq P2S (substr xdatai (+ !pos1 2) 200))
                      

  
    		 (setq ,pos1 (vl-string-position 44 P1S 0))
                 (SETQ P1S (STRCAT (substr P1S (+ ,pos1 2) 50) " " (substr P1S 1 ,pos1)))
                 (setq ,pos1 (vl-string-position 44 P2S 0))
                 (SETQ P2S (STRCAT (substr P2S (+ ,pos1 2) 50) " " (substr P2S 1 ,pos1)))
           (setq code "")
  (if (/= (vl-position p1s cgplevel) nil)(setq code (cadr (member p1s cgplevel))))
  (if (/= (vl-position p2s cgplevel) nil)(setq code (cadr (member p2s cgplevel))))
		      
    

     (if (= (setq pos1(vl-position p1s cgpl)) nil)(progn
				   (setq pcount (+ pcount 1))
				   (setq cgpl (append cgpl (list p1s)(list "sideshot")(list "proposed")(list (rtos pcount 2 0))(list code)))
				   );p
      (setq p1n (nth (+ pos1 3) cgpl))

       );&if
     (if (= (setq pos2(vl-position p2s cgpl)) nil)(progn
				   (setq pcount (+ pcount 1))
				   (setq cgpl (append cgpl (list p2s)(list "sideshot")(list "proposed")(list (rtos pcount 2 0))(list code)))
				   );p
       (setq p2n (nth (+ pos2 3) cgpl))
       );&if

        
(if (= name "DFAT")(setq name "Direction Of Flow Tidal"))
    (if (= name "DFANT")(setq name "Direction Of Flow Non Tidal"))
    (setq flowarrows (strcat flowarrows "    <Annotation type=\"" name "\" name=\"" (rtos annocount 2 0) "\" desc=\""p1n ", "p2n"\"/>" (chr 10)))
			
	   (setq annocount (+ annocount 1))
	    

	    (setq count (+ count 1))
	    ));IF XDATA EXISTS
  
    );r
  );p
     );if


    
;33.------------------------VINCULUM---------------------------------------------  
  

     (IF (/= (setq bdyline (ssget "_X" '((0 . "INSERT") (2 . "VINC")))) nil)(progn 
  (setq count 0)
  (setq fac 1)
  (repeat (sslength bdyline)
  (SETQ MP (CDR(ASSOC 10 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ SC (CDR(ASSOC 41 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ ROT (CDR(ASSOC 50 (ENTGET (SSNAME bdyline COUNT)))))
    (setq NAME (CDR(ASSOC 2 (ENTGET (SSNAME bdyline COUNT)))))
    (SETQ ZA (CDR (ASSOC 210 (ENTGET (SSNAME bdyline COUNT)))))
    (SETQ MP (TRANS MP ZA 0))

    (SETQ EN (CDR (ASSOC -1 (ENTGET (SSNAME bdyline COUNT)))))
     (SETQ XDATAI (ENTGET EN '("LANDXML")))
	  (IF (= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL) (progn
	      	     (COMMAND "CHANGE" en "" "P" "C" "6" "")
	      (princ (strcat "\nERROR Vinculum with no xdata at " (rtos (car mp) 2 3) "," (rtos (cadr mp)2 3)))
	     )
	    (PROGN
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))
    

    (IF  (= NAME "VINC")(PROGN
    
    (SETQ P1 (POLAR MP (+ ROT (* 0.5 pi)) (* SC 0.0018875)))
     (SETQ P2 (POLAR MP (- ROT (* 0.5 PI)) (* SC 0.0018875)))
    
    (setq p1s (strcat (rtos (cadr p1) 2 6) " " (rtos (car p1) 2 6)))
    (setq p2s (strcat (rtos (cadr p2) 2 6) " " (rtos (car p2) 2 6)))


      (setq code xdatai)
       

     (if (= (setq pos1(vl-position p1s cgpl)) nil)(progn
				   (setq pcount (+ pcount 1))
				   (setq p1n (rtos pcount 2 0))
				   (setq cgpl (append cgpl (list p1s)(list "sideshot")(list "proposed")(list (rtos pcount 2 0))(list code)))
				   );p
      (setq p1n (nth (+ pos1 3) cgpl))

       );&if
     (if (= (setq pos2(vl-position p2s cgpl)) nil)(progn
				   (setq pcount (+ pcount 1))
				   (setq p2n (rtos pcount 2 0))
				   (setq cgpl (append cgpl (list p2s)(list "sideshot")(list "proposed")(list (rtos pcount 2 0))(list code)))
				   );p
       (setq p2n (nth (+ pos2 3) cgpl))
       );&if
    
(if (= name "VINC")(setq name "Vinculum"))
    (setq flowarrows (strcat flowarrows "    <Annotation type=\"" name "\" name=\"" (rtos annocount 2 0) "\" desc=\""p1n ","p2n"\"/>" (chr 10)))
			
	   (setq annocount (+ annocount 1))
	    
  ));P&IF NAME IS VINC
	    (setq count (+ count 1))
	    ));IF XDATA EXISTS
  
    );r
  );p
     );if
    
    

;34.------------Proposed lots----------------------------

  
(princ "\nProcessing Proposed Lots")

(IF (/= (setq lots (ssget "_X" '((0 . "LWPOLYLINE") (8 . "Lot Definitions")))) nil)(progn

	;check all lots for multipart lots
				(setq mplist nil)				     
			(setq count 0)
  (repeat (sslength lots)
     (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME lots COUNT)))))
    (SETQ P1 (CDR(ASSOC 10 (ENTGET (SSNAME lots COUNT)))))
    
      	    (SETQ XDATAI (ENTGET EN '("LANDXML")))
	    (IF (= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL) (progn
	      	     (COMMAND "CHANGE" en "" "P" "C" "6" "")
	      ;(princ (strcat "\nERROR Lot with no XML data at " (rtos (car p1) 2 3) "," (rtos (cadr p1)2 3)))
	     )
	      (PROGN
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))
        (symbolreplace)
    
 (if (/= (setq stringpos (vl-string-search "parcelType" xdatai )) nil)(progn
(setq wwpos (vl-string-position 34 xdatai (+ stringpos 12)))(setq pcltype (substr xdatai (+ stringpos 13) (-(- wwpos 1)(+ stringpos 11))))))
(if (/= (setq stringpos (vl-string-search "parcelFormat" xdatai )) nil)(progn
(setq wwpos (vl-string-position 34 xdatai (+ stringpos 14)))(setq parcelformat (substr xdatai (+ stringpos 15) (-(- wwpos 1)(+ stringpos 13))))))
	    (if (/= (setq stringpos (vl-string-search "name" xdatai )) nil)(progn
(setq wwpos (vl-string-position 34 xdatai (+ stringpos 6)))(setq pclname (substr xdatai (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5)))))(setq pclname ""))
     (if (/= (setq stringpos (vl-string-search "area" xdatai )) nil)(progn
(setq wwpos (vl-string-position 34 xdatai (+ stringpos 6)))(setq area (substr xdatai (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5)))))(setq area ""))
    (if (= pcltype "Part")(setq mplist (append mplist (list (strcat pclname "-" area )))))
	    ));IF XDATA EXISTS
    (setq count (+ count 1))
    );r
(if (> (length mplist) 0)(progn
			  
			(setq mplist (vl-sort mplist '<))
			(setq count 1)
			(setq prealphanum "00000000")
			(setq preletters "")
			(setq alphanum 65)
			(setq pclname (nth 0 mplist))
			
			(setq -pos1 (vl-string-position 45 pclname 0))
			(setq area  (substr pclname (+ -pos1 2) 50))
			(setq areatot area)
                        (setq pclname  (substr pclname 1 -pos1))
			(setq liststart (strcat "  <Parcel name=\""pclname "\" class=\"Lot\" state=\"proposed\" parcelType=\"Multipart\" parcelFormat=\"" parcelformat "\""))
			(setq listend (strcat ">" (chr 10) "    <Parcels>" (chr 10) ))
      		        (setq listend (strcat listend "      <Parcel name=\"" pclname preletters (chr alphanum) "\" pclRef=\"" pclname preletters (chr alphanum) "\"/>" (chr 10) ))
			
			(setq mpalist (append mpalist (list pclname)(list (strcat preletters(chr alphanum)))))
			(setq prevname pclname)
			;sort list
			(repeat (-  (length mplist) 1) 
			  (setq pclname (nth count mplist))
			  (setq -pos1 (vl-string-position 45 pclname 0))
			(setq area  (substr pclname (+ -pos1 2) 50))
			  (setq pclname  (substr pclname 1 -pos1))
			  (if (= pclname prevname)(progn
			    (setq alphanum (+ alphanum 1))
			    (if (= alphanum 91) (progn 
						  ;allow up to 308 million alpha combos
						  (setq pa1 (atof (substr prealphanum 1 2)))
						  (setq pa2 (atof (substr prealphanum 3 2)))
						  (setq pa3 (atof (substr prealphanum 5 2)))
						  (setq pa4 (atof (substr prealphanum 7 2)))

						  (if (= pa1 0) (setq pa1 64))
						  (setq pa1 (+ pa1 1))
						  (if (= pa1 91) (progn
								   (if (= pa2 0)(setq pa2 64))
								   (setq pa2 (+ pa2 1)
								       pa1 65)))
						  (if (= pa2 91) (progn
								   (if (= pa3 0)(setq pa3 64))
								   (setq pa3 (+ pa3 1)
								       pa2 65
								       pa1 65)))
						  (if (= pa3 91) (progn
								   (if (= pa4 0)(setq pa4 64))
								   (setq pa4 (+ pa4 1)
									 pa3 65
								         pa2 65
								         pa1 65)))
						  (if (= pa1 0) (setq pa1 "00")(setq pa1 (rtos pa1 2 0)))
						  (if (= pa2 0) (setq pa2 "00")(setq pa1 (rtos pa2 2 0)))
						  (if (= pa3 0) (setq pa3 "00")(setq pa1 (rtos pa3 2 0)))
						  (if (= pa4 0) (setq pa4 "00")(setq pa1 (rtos pa4 2 0)))
						  (setq alphanum 65)
						  (setq prealphanum (strcat pa1 pa2 pa3 pa4))
						  ))
			    (setq preletters (strcat (chr (atoi (substr prealphanum 1 2)))
						     (chr (atoi (substr prealphanum 3 2)))
						     (chr (atoi (substr prealphanum 5 2)))
						     (chr (atoi (substr prealphanum 7 2)))))
			      
						  
						  
			    (setq listend (strcat listend "      <Parcel name=\"" pclname preletters (chr alphanum) "\" pclRef=\"" pclname preletters (chr alphanum) "\"/>" (chr 10) ))
			    
			    (setq areatot (rtos (+ (atof area) (atof areatot))))
)
			    (progn;else not the same pclname
			      (if (/= areatot "0") (setq areatots (strcat " area=\"" areatot "\""))(setq areatots ""))
			      (setq mpolist (append mpolist (list (strcat liststart areatots  listend (chr 10) "    </Parcels>" (chr 10)   "  </Parcel>"))))

			      (IF (= (strcat preletters (chr alphanum)) "A")(princ (strcat"\nPart Parcel with only one part - " pclname)))
			      (setq alphanum 65)
			      (setq prealphanum "00000000")
			      
			      (setq preletters "")
			      (setq areatot area)
			      (setq liststart (strcat "  <Parcel name=\""pclname "\" class=\"Lot\" state=\"proposed\" parcelType=\"Multipart\" parcelFormat=\"" parcelformat "\" "))
			      (setq listend (strcat ">" (chr 10) "    <Parcels>" (chr 10) ))
			 (setq listend (strcat listend "      <Parcel name=\"" pclname preletters (chr alphanum) "\" pclRef=\"" pclname preletters (chr alphanum) "\"/>" (chr 10) ))
			      
			    )
			    );if
			  
			  (setq mpalist (append mpalist (list pclname)(list (strcat preletters (chr alphanum)))))
			  (setq prevname pclname)
			  
			  (setq count (+ count 1))
			  );r

			;close last multipart
			
			(if (/= areatot "0") (setq areatots (strcat " area=\"" areatot "\""))(setq areatots ""))
			(setq mpolist (append mpolist (list (strcat liststart areatots  listend  "    </Parcels>" (chr 10)   "  </Parcel>"))))
			));p&if multipart lots exist

										     
 (setq count 0)
  (repeat (sslength lots)
  
    (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME lots COUNT)))))
    (SETQ ZA (CDR(ASSOC 210 (ENTGET (SSNAME lots COUNT))))) ;extrusion
    (SETQ DEFWIDTH (CDR(ASSOC 40 (ENTGET (SSNAME lots COUNT))))) ;DEFAULT POLYLINE WIDTH
    (SETQ CLOSED (CDR(ASSOC 70 (ENTGET (SSNAME lots COUNT))))) ;CLOSED FLAG
    (SETQ P1 (CDR(ASSOC 10 (ENTGET (SSNAME lots COUNT)))))
    

    	    

     (SETQ XDATAI (ENTGET EN '("LANDXML")))
	    (IF (= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL) (progn
	      	     (COMMAND "CHANGE" en "" "P" "C" "6" "")
	      (princ (strcat "\nERROR Lot with no XML data at " (rtos (car p1) 2 3) "," (rtos (cadr p1)2 3)))
	     )
	      (PROGN
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))

	    ;look for & or � symbol and replace

	     (setq �pos 0)
	   (while (/=  (setq �pos (vl-string-search "�" xdatai &pos )) nil) (setq xdatai (vl-string-subst "&sup2;" "�"  xdatai �pos)
										      �pos (+ �pos 5)))

	     (setq &pos 0)
	   (while (/=  (setq &pos (vl-string-search "&" att &pos )) nil) (setq att (vl-string-subst "&amp;" "&"  att &pos)
										      &pos (+ &pos 4)))

    (if (= (substr xdatai 1 4) "desc")(progn

				    ;Check for easement or road lots note an imported road lot will not have "desc" as the first four letters and not need assignment as below
    (if (/= (setq stringpos (vl-string-search "class" xdatai )) nil)(progn
(setq wwpos (vl-string-position 34 xdatai (+ stringpos 7)))(setq lotclass (substr xdatai (+ stringpos 8) (-(- wwpos 1)(+ stringpos 6)))))(setq lotclass ""))
    (if (= lotclass "Road")(progn
			     (setq xdatai (strcat "  <Parcel name=\"R" (rtos roadcount 2 0) "\" " xdatai))
			     (setq roadcount (+ roadcount 1))
			     )
      )
    (if (= lotclass "Reserved Road")(progn
			     (setq xdatai (strcat "  <Parcel name=\"R" (rtos roadcount 2 0) "\" " xdatai))
			     (setq roadcount (+ roadcount 1))
			     )
      )
    
    (if (= lotclass "Easement")(progn
				 (setq xdatai (strcat "  <Parcel name=\"E" (rtos easecounta 2 0) "\" " xdatai))
				 (setq easecounta (+ easecounta 1))
				 )
      )
    (if (= lotclass "Hydrography")(progn
				 (setq xdatai (strcat "  <Parcel name=\"H" (rtos hydrocount 2 0) "\" " xdatai))
				 (setq hydrocount (+ hydrocount 1))
				 )
      )
    ));p& if desc

    ;check for mutliplart lot
     (if (/= (setq stringpos (vl-string-search "name" xdatai )) nil)(progn
(setq wwpos (vl-string-position 34 xdatai (+ stringpos 6)))(setq pclname (substr xdatai (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5))))))

    (if (/= (setq listpos (vl-position pclname mpalist)) nil)(progn
							    (setq alpha (nth (+ listpos 1) mpalist))
							    (setq pclname (strcat pclname alpha))
							    (setq mpalist (remove_nth mpalist (+ listpos 1)))
							    (setq mpalist (remove_nth mpalist listpos ))
							    (setq xdatai (strcat (substr xdatai 1 (+ stringpos 6)) pclname (substr xdatai (+ wwpos 1) 1000)))
							    )
      )
      
      
;get pcl state so exsiting lots dont get checked for geometery      
(if (/= (setq stringpos (vl-string-search "state" xdatai )) nil)(progn
(setq wwpos (vl-string-position 34 xdatai (+ stringpos 7)))(setq pclstate (substr xdatai (+ stringpos 8) (-(- wwpos 1)(+ stringpos 6)))))(setq pclstate ""))

;get pcl format for identification of strata lots
(if (/= (setq stringpos (vl-string-search "parcelFormat" xdatai )) nil)(progn
(setq wwpos (vl-string-position 34 xdatai (+ stringpos 14)))(setq pclformat (substr xdatai (+ stringpos 15) (-(- wwpos 1)(+ stringpos 13)))))(setq pclformat ""))

;get pcl format for identification of strata lots
(if (/= (setq stringpos (vl-string-search "class" xdatai )) nil)(progn
(setq wwpos (vl-string-position 34 xdatai (+ stringpos 7)))(setq pclclass (substr xdatai (+ stringpos 8) (-(- wwpos 1)(+ stringpos 6)))))(setq pclclass ""))

;get blno and strip number and comma to make it more inconsistent for LRS
(if (/= (setq stringpos (vl-string-search "buildingLevelNo" xdatai )) nil)(progn
(setq wwpos (vl-string-position 34 xdatai (+ stringpos 17)))(setq blno (substr xdatai (+ stringpos 18) (-(- wwpos 1)(+ stringpos 16))))

	    (setq ,pos1 (vl-string-position 44 blno 0))
	              (setq sblno (substr blno (+ ,pos1 2) 2000))
	    (setq xdatai (vl-string-subst (strcat "buildingLevelNo=\"" sblno "\"" ) (strcat "buildingLevelNo=\"" blno "\"" ) xdatai))
)(setq blno ""))
                      
	    

;seperate centrepoint coord out.
    
     (setq !pos1 (vl-string-position 33 xdatai 0))
                      (setq lotc (substr xdatai (+ !pos1 2) 200))
                      (setq xdatai  (substr xdatai 1 !pos1))

    

(symbolreplace)
    
  
  
(setq pcount (+ pcount 1))
    (setq code "")
    (if (/= (vl-position lotc cgplevel) nil)(setq code (cadr (member lotc cgplevel))))
  (setq cgpl (append cgpl (list lotc)(list "sideshot")(list pclstate)(list (rtos pcount 2 0))(list code)))

  
;write to list

  
  (setq lotlist (append lotlist (list xdatai)))
  (setq lotlist (append lotlist (list (strcat "    <Center pntRef=\"" (rtos pcount 2 0)"\"/>"))))
  (setq lotlist (append lotlist (list (strcat "    <CoordGeom name=\"" (rtos cogeocount 2 0) "\">"))))
  (setq cogeocount (+ cogeocount 1))
  

   

  
					(setq enlist (entget en))
    ;go through polyline to get points to check for clockwise direction
    (SETQ CWLIST (LIST))
	    (foreach a enlist
	      (if (= 10 (car a))

		(setq CWLIST (append CWLIST (list (TRANS (cdr a) ZA 0))))
	      )				;IF
	      
	    )				;FOREACH 			

  (IF (> (lcw CWLIST) 0) (command "pedit" en "r" "" ))
  

    

					(setq enlist (entget en))
    ;go through polyline to get points and bugle factors
    (SETQ PTLIST (LIST))
	    (foreach a enlist
	      (if (= 10 (car a))

		(setq PTLIST (append PTLIST (list (TRANS (cdr a) ZA 0))))
	      )				;IF
	      (if (= 42 (car a));bulge
		(setq PTLIST (append PTLIST (LIST (cdr a))))
		);if
	      (if (= 40 (car a));width
		(setq PTLIST (append PTLIST (LIST (cdr a))))
		);if
	      
	    )				;FOREACH 			
 


    ;shuffle the list until one of the irregular line point isnt at the start
    (while (member (strcat (rtos (cadr (nth 0 ptlist)) 2 6) " " (rtos (car (nth 0 ptlist)) 2 6)) ibllist)
      (progn
	(setq minilist (list (nth 0 ptlist)(nth 1 ptlist)(nth 2 ptlist)))
	(setq ptlist (remove_nth ptlist 0))
	(setq ptlist (remove_nth ptlist 0))
	(setq ptlist (remove_nth ptlist 0))      
	(setq ptlist (append ptlist minilist))
	)
      )

   (IF (OR (= CLOSED 1)(= CLOSED 129)) (setq ptlist (append ptlist (list(nth 0 ptlist))(list (nth 1 ptlist))(list (nth 2 ptlist)))))
	

 (setq count1 0)
    (setq repeater (/ (length ptlist) 3))
 (while (/= repeater 1)
   (progn

   (setq p1 (nth count1 ptlist))
   (setq p1s (strcat (rtos (cadr p1) 2 6) " " (rtos (car p1) 2 6)))
   (setq p2 (nth (+ count1 3) ptlist))
   (setq p2s (strcat (rtos (cadr p2) 2 6) " " (rtos (car p2) 2 6)))
   (setq bf (nth (+ count1 2) ptlist))

    (setq code "")
      (if (/= (vl-position p1s cgplevel) nil)(setq code (cadr (member p1s cgplevel))))
      (if (/= (vl-position p2s cgplevel) nil)(setq code (cadr (member p2s cgplevel))))

    


   
   ;look for irregular line
   (if (/= (setq remiblselist (member (strcat p1s "-" p2s) iblselist)) nil)
     (progn

       (setq xdatai (nth 1 remiblselist))
        (setq lotlist (append lotlist (list (strcat "      <IrregularLine desc=\"" xdatai "\">"))))
       (setq irbl "")
       (setq pps "")
       (setq iblcount 0)
       (while (/= pps (nth 2 remiblselist))
	 (progn
	 (setq p (nth count1 ptlist))
   (setq ps (strcat (rtos (cadr p) 2 6) " " (rtos (car p) 2 6) " "))
	 (if (/= ps pps)(setq irbl (strcat irbl ps)))
	 (setq pps ps)
	 (setq count1 (+ count1 3))
	 (setq iblcount (+ iblcount 1))
	 (if (and (= count1 (length ptlist))(/= pps (nth 2 remiblselist)) )(progn
					  (setq spcpos1 (vl-string-position 32 (nth 2 remiblselist) 0))
			      (setq eeast (atof(substr  (nth 2 remiblselist) (+ spcpos1 2) 200)))
                              (setq enorth  (atof (substr  (nth 2 remiblselist) 1 spcpos1)))
					 (setq endpoint (list eeast enorth))
	   (princ (strcat "\nError - Lot " pclname " - Not finding end of irregular between " (rtos (car p1) 2 3) "," (rtos (cadr p1) 2 3)
					      " and " (rtos eeast 2 3) ","  (rtos enorth 2 3) " orange line placed" ))
	   (command "color" "30" "line" p1 endpoint "" "color" "bylayer")
	   ))
	 ));p&w
       
     (setq ep (strcat (rtos (cadr p) 2 6) " " (rtos (car p) 2 6)))
     
      (if (/= (setq pos1 (vl-position p1s cgpl)) nil)(progn
						  (setq p1n (nth (+ pos1 3) cgpl))
						  ;replace pntsurv for iregular list (for irregular easements)
						  (setq cgpl (replaceitem (+ pos1 2) "boundary" cgpl))

						  
						  )
      (progn
	 
	 (setq pcount (+ pcount 1))
	 	 (setq cgpl (append cgpl (list p1s)(list "boundary")(list pclstate)(list (rtos pcount 2 0))(list code)))
         (setq p1n (rtos pcount 2 0))
	 
	 	 ))
     (if  (/= (setq pos2 (vl-position ep cgpl)) nil)(progn
						  (setq epn (nth (+ pos2 3) cgpl))
						  ;replace pntsurv for iregular list (for irregular easements)
						  (setq cgpl (replaceitem (+ pos2 2) "boundary" cgpl))
						  )
       (progn
	 
	 (setq pcount (+ pcount 1))
	 	 (setq cgpl (append cgpl (list ep)(list "boundary")(list pclstate)(list (rtos pcount 2 0))(list code)))
         (setq epn (rtos pcount 2 0))
	 
	 	 ))

       (setq irbl (substr irbl 1 (- (strlen irbl) 1)))
     		   (setq lotlist (append lotlist (list (strcat "        <Start pntRef=\""p1n"\"/>"))))
		   (setq lotlist (append lotlist (list (strcat "        <End pntRef=\""epn"\"/>"))))
		(setq lotlist (append lotlist (list (strcat "        <PntList2D>" irbl "</PntList2D>"))))
             (setq lotlist (append lotlist (list "      </IrregularLine>")))
     (setq repeater (- repeater (- iblcount 1)))
       (setq count1 (- count1 3))
   
       )
     (progn;else

   ;get edge names
     (if (/= (setq pos1 (vl-position p1s cgpl)) nil)(progn
						  (setq p1n (nth (+ pos1 3) cgpl))
						  )
       (progn
	 (if (and (/= pclformat "Strata")(= pclstate "proposed"))(progn
	 (princ (strcat"\nERROR Lot corner not defined by geometery at " (rtos (car p1) 2 6) "," (rtos (cadr p1) 2 6) " orange point placed"))
	 (command "color" "30" "point" p1 "color" "bylayer")
	 ))
	 (setq pcount (+ pcount 1))
	 	 (setq cgpl (append cgpl (list p1s)(list "boundary")(list pclstate)(list (rtos pcount 2 0))(list code)))
         (setq p1n (rtos pcount 2 0))
	 
	 	 ))
     (if  (/= (setq pos2 (vl-position p2s cgpl)) nil)(progn
						  (setq p2n (nth (+ pos2 3) cgpl))
						  )
       (progn;if not found at corner
	 (if (and (/= pclformat "Strata")(= pclstate "proposed"))(progn
	 (princ (strcat "\nERROR Lot corner not defined by geometery at" (rtos (car p2) 2 6) "," (rtos (cadr p2) 2 6)" orange point placed"))
	 (command "color" "30" "point" p2 "color" "bylayer")
	 ))
	 (setq pcount (+ pcount 1))
	 (setq cgpl (append cgpl (list p2s)(list "boundary")(list pclstate)(list (rtos pcount 2 0))(list code)))
         (setq p2n (rtos pcount 2 0))
	 
	 	 ))
(if (/= p1n p2n)(progn ;is not the same point

		  (if (and (= pclstate "proposed")(= (vl-position (strcat p1n "-" p2n) obslist) nil)(/= pclformat "Strata"))
		    (progn ;check if lot line has edge observation
		      (princ (strcat "\nLot edge not defined by observation from " (rtos (car p1) 2 3) "," (rtos (cadr p1) 2 3) " to " (rtos (car p2) 2 3) "," (rtos (cadr p2) 2 3) " orange line placed, suggest checking"))
			(command "color" "30" "line" p1 p2"" "color" "bylayer")
		      ));p & if no observation
		  
		  (setq linedesc "")
		  ;deal with strata widths
		  (if (= pclformat "Strata")(progn
					      (setq width (nth (+ count1 1) ptlist))
(if (or (/= (rtos width 2 5) "0")(/= (rtos width 2 5) (rtos (/ scale 1000) 2 5))(/= (rtos width 2 5) "0.05378")) (setq linedesc " desc=\"SR\""));structual right - any other width but the correct one or 0.05378(SL)
(if (= (rtos width 2 5) "0")(setq linedesc " desc=\"NS\""));non structural
(if (= (rtos width 2 5) "0.05378") (setq linedesc " desc=\"SL\""));structural left - specal width
(if (= (rtos width 2 5) (rtos (/ scale 1000) 2 5)) (setq linedesc " desc=\"SC\""));structural centre 
					      
));if strata
		  
   (if  (= bf 0.0)(progn ;is a line
		   (setq lotlist (append lotlist (list (strcat "      <Line" linedesc ">"))))
		   (setq lotlist (append lotlist (list (strcat "        <Start pntRef=\""p1n"\"/>"))))
		   (setq lotlist (append lotlist (list (strcat "        <End pntRef=\""p2n"\"/>"))))
		   (setq lotlist (append lotlist (list "      </Line>")))
		   );p
     (progn;is an arc

       
       ;FIGURE OUT centrePOINT
       
               (setq DI (DISTANCE P1 P2))
               (SETQ AZ (ANGLE P1 P2))
                (SETQ MP (POLAR P1 AZ (/ DI 2)))
       		(SETQ H (/ (* BF DI) 2))
		(SETQ AMP (POLAR MP (+ AZ (* 1.5 PI)) H))
		(SETQ X1 (CAR P1))
		(SETQ Y1 (CADR P1))
		(SETQ X2 (CAR AMP))
		(SETQ Y2 (CADR AMP))
		(SETQ X3 (CAR P2))
		(SETQ Y3 (CADR P2))
		(SETQ MA (/ (- Y2 Y1) (- X2 X1)))
		(SETQ MB (/ (- Y3 Y2) (- X3 X2)))
		(SETQ  RPX (/ (- (+ (* MA MB (- Y1 Y3)) (* MB (+ X1 X2)))  (* MA (+ X2 X3)) )(* 2 (- MB MA))))
		(SETQ  RPY (+ (* (* (/ 1 MA) -1) (- RPX (/ (+ X1 X2) 2)))  (/ (+ Y1 Y2) 2)))
       (setq radius (distance amp (list rpx rpy)))
       (SETQ CP (LIST RPX RPY))
		(SETQ CPS (STRCAT (RTOS (CAdR CP) 2 6) " " (RTOS (CAR CP) 2 6)))

    
;note all that work to create the centerpoint should be redundant, as there should be an observation over this arc so....
       (if (or (setq remlist (member (strcat p1n "-" p2n) arclist))(setq remlist (member (strcat p2n "-" p1n) arclist)))
  (progn;is proposed and found in arc list
    (setq cpn (cadr remlist))
    )
  (progn;is not
    (if (and (/= pclformat "Strata")(= pclstate "proposed"))(progn
    (princ (strcat "\nERROR Arc not defined by observation from " (rtos (car p1) 2 3) "," (rtos (cadr p1) 2 3) " to " (rtos (car p2) 2 3) "," (rtos (cadr p2) 2 3) " orange line placed, suggest checking"))
	(command "color" "30" "line" p1 p2"" "color" "bylayer")
    ))

       ;GET centrePPOINT NUMBER
(if (/= (setq pos3 (vl-position CPS cgpl)) nil)(progn
						  (setq CPn (nth (+ pos3 3) cgpl))
						  )
  
      (progn
	 ;(princ (strcat "\n Arc centre not yet defined by geometery at " CPS))
	 (setq pcount (+ pcount 1))
	 (setq cgpl (append cgpl (list CPS)(list "sideshot")(list pclstate)(list (rtos pcount 2 0))(list code)))
         (setq CPn (rtos pcount 2 0))
	 
	 	 ))

    
       	)
	 );if
       
(if (> bf 0)(setq rot "ccw")(setq rot "cw"))
       
       		   (setq lotlist (append lotlist (list (strcat"      <Curve radius=\"" (rtos radius 2 6) "\" rot=\"" rot "\"" linedesc ">"))))
		   (setq lotlist (append lotlist (list (strcat "        <Start pntRef=\""p1n"\"/>"))))
                   (setq lotlist (append lotlist (list (strcat "        <Center pntRef=\""cpn"\"/>"))))
		   (setq lotlist (append lotlist (list (strcat "        <End pntRef=\""p2n"\"/>"))))
		   (setq lotlist (append lotlist (list "      </Curve>")))


       );p
     );if LINE OR ARC
		 
		  
		  
   ));p&if p1n is not p2n

       (setq count1 (+ count1 3))
      (setq repeater (- repeater 1))
     
     ));end else and if not irregular
     

    

     
   ));while repeater length of ptlist
  (setq lotlist (append lotlist (list "    </CoordGeom>")))
  (setq lotlist (append lotlist (list "  </Parcel>")))
	    ));IF XDATA EXISTS
  (setq count (+ count 1))
);r length of lots
);p
  (PRINC "\nNo Lots found in Project")
  );if
 
  ;if lots found




  

  ;get metadata

    (princ "\nProcessing Admin Sheet")

(IF (/= (setq adminsheet (ssget "_X" '((0 . "INSERT") (2 . "PLANFORM6,PLANFORM3")))) nil)(progn
		(SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME ADMINSHEET 0)))))
		(SETQ BLOCKNAME (CDR(ASSOC 2 (ENTGET (SSNAME ADMINSHEET 0))))) 

		(IF (= BLOCKNAME "PLANFORM6")(PROGN
					       
		(setq count 1)
  (SETQ ATTLIST (LIST))
	    
(setq Obj (vlax-ename->vla-object En))
	(foreach x (vlax-invoke Obj 'GetAttributes)
	  (SETQ ATT (vla-get-textstring X))
	  (if (= att "none") (setq att ""))

	  (setq &pos 0)
	   (while (/=  (setq &pos (vl-string-search "&" att &pos )) nil) (setq att (vl-string-subst "&amp;" "&"  att &pos)
										      &pos (+ &pos 4)))
	  
	  (setq crlfpos 0)
	   (while (/=  (setq crlfpos (vl-string-search "\\P" att crlfpos )) nil) (setq att (vl-string-subst "&#xA;" "\\P"  att crlfpos)
										      crlfpos (+ crlfpos 5)))
	             (setq crlfpos 0)
	   (while (/=  (setq crlfpos (vl-string-search "\n" att crlfpos )) nil) (setq att (vl-string-subst "&#xA;" "\n"  att crlfpos)
										      crlfpos (+ crlfpos 5)))


	  (setq attlist (append attlist (list att)))

	  )

;store objusts
		
(if (/= (nth 22 attlist) "")(setq zone (strcat "zoneNumber=\"" (nth 22 attlist) "\""))(setq zone ""))
(setq datum (nth 19 attlist))
    (if (/= (setq stringpos (vl-string-search "~" datum )) nil)(progn
     
                      (setq datumdesc (strcat " desc=\""(substr datum (+ stringpos 2) 1000) "\" "))
                      (setq datum (substr datum 1 stringpos))
		      )(setq datumdesc "")
      )		
(if (= (nth 6 attlist) "")(setq surfirm "")(setq surfirm (strcat " surveyorFirm=\"" (nth 6 attlist) "\" ")))
  (if (= (nth 10 attlist) "")(setq surveyorReference "")(setq surveyorReference (strcat " surveyorReference=\"" (nth 10 attlist) "\" ")))
  (if (= (nth 11 attlist) "")(setq shdesc "")(setq shdesc (strcat " desc=\"" (nth 11 attlist) "\" ")))
(setq surname (substr (nth 0 attlist) 3 50))
(setq surjur (nth 16 attlist))
(setq surformat (nth 17 attlist))
(setq surtype (nth 15 attlist))

		(SETQ DOS (nth 7 attlist))
  (if (/= dos "")(progn

;sort date entrys
  ;replace /,\,. with -
  (setq /pos 0)
	      (while (/=  (setq /pos (vl-string-search "/" dos /pos )) nil) (setq dos (vl-string-subst "-" "/"  dos /pos)
										      /pos (+ /pos 1)))
(setq /pos 0)
	      (while (/=  (setq /pos (vl-string-search "\\" dos /pos )) nil) (setq dos (vl-string-subst "-" "\\"  dos /pos)
										      /pos (+ /pos 2)))
  (setq /pos 0)
	      (while (/=  (setq /pos (vl-string-search "." dos /pos )) nil) (setq dos (vl-string-subst "-" "."  dos /pos)
										      /pos (+ /pos 1)))
    (setq minuspos1 (vl-string-position 45 dos 0))
  (setq minuspos2 (vl-string-position 45 dos (+ minuspos1 1)))
  (if (or (= minuspos1 1)(= minuspos1 2))(progn;rearrage date
				       (setq day  (substr dos 1 minuspos1))
				       (if (= (strlen day) 1) (setq day (strcat "0" day)));single digit days
				       (setq month (substr dos (+ minuspos1 2) (- (- minuspos2 minuspos1) 1)))
				       (if (= (strlen month) 1) (setq month (strcat "0" month)));single digit days
				       (setq year  (substr dos (+ minuspos2 2) 50))
				       (setq dos (strcat year "-" month "-" day))
				       ));p&if dos round the wrong way
  ));p&if dos not ""

 (SETQ DOR (nth 14 attlist))
  (if (/= DOR "")(progn

;sort date entrys
  ;replace /,\,. with -
  (setq /pos 0)
	      (while (/=  (setq /pos (vl-string-search "/" DOR /pos )) nil) (setq DOR (vl-string-subst "-" "/"  DOR /pos)
										      /pos (+ /pos 1)))
(setq /pos 0)
	      (while (/=  (setq /pos (vl-string-search "\\" DOR /pos )) nil) (setq DOR (vl-string-subst "-" "\\"  DOR /pos)
										      /pos (+ /pos 2)))
  (setq /pos 0)
	      (while (/=  (setq /pos (vl-string-search "." DOR /pos )) nil) (setq DOR (vl-string-subst "-" "."  DOR /pos)
										      /pos (+ /pos 1)))
    (setq minuspos1 (vl-string-position 45 DOR 0))
  (setq minuspos2 (vl-string-position 45 DOR (+ minuspos1 1)))
  (if (or (= minuspos1 1)(= minuspos1 2))(progn;rearrage date
				       (setq day  (substr DOR 1 minuspos1))
				       (if (= (strlen day) 1) (setq day (strcat "0" day)));single digit days
				       (setq month (substr DOR (+ minuspos1 2) (- (- minuspos2 minuspos1) 1)))
				       (if (= (strlen month) 1) (setq month (strcat "0" month)));single digit days
				       (setq year  (substr DOR (+ minuspos2 2) 50))
				       (setq DOR (strcat year "-" month "-" day))
				       ));p&if DOR round the wrong way
  ));p&if DOR not ""


		(setq surpersonel (nth 5 attlist))
		(setq surpos (nth 13 attlist))
		(setq surps (nth 12 attlist))
		(setq subnum (nth 23 attlist))
		(setq surpn (nth 18 attlist))
		(setq surregion (nth 8 attlist))
		(setq surloc (nth 2 attlist))
		(setq surlga (nth 1 attlist))
		(setq surparish (nth 3 attlist))
		(setq surcounty (nth 4 attlist))
		(setq surterrain (nth 9 attlist))
		(setq hdatum (nth 20 attlist))
		(setq vdatum (nth 21 attlist))

		));P&IF PLANFORM 6

	(IF (= BLOCKNAME "PLANFORM3")(PROGN
					       
		(setq count 1)
  (SETQ ATTLIST (LIST))
	    
(setq Obj (vlax-ename->vla-object En))
	(foreach x (vlax-invoke Obj 'GetAttributes)
	  (SETQ ATT (vla-get-textstring X))
	  (if (= att "none") (setq att ""))

	  (setq &pos 0)
	   (while (/=  (setq &pos (vl-string-search "&" att &pos )) nil) (setq att (vl-string-subst "&amp;" "&"  att &pos)
										      &pos (+ &pos 4)))
	  
	  (setq crlfpos 0)
	   (while (/=  (setq crlfpos (vl-string-search "\\P" att crlfpos )) nil) (setq att (vl-string-subst "&#xA;" "\\P"  att crlfpos)
										      crlfpos (+ crlfpos 5)))
           (setq crlfpos 0)
	   (while (/=  (setq crlfpos (vl-string-search "\n" att crlfpos )) nil) (setq att (vl-string-subst "&#xA;" "\n"  att crlfpos)
										      crlfpos (+ crlfpos 5)))


	  (setq attlist (append attlist (list att)))

	  )

;store objects
		
(if (/= (nth 20 attlist) "")(setq zone (strcat "zoneNumber=\"" (nth 20 attlist) "\""))(setq zone ""))
(setq datum (nth 17 attlist))
    (if (/= (setq stringpos (vl-string-search "~" datum )) nil)(progn
     
                      (setq datumdesc (strcat " desc=\""(substr datum (+ stringpos 2) 1000) "\" "))
                      (setq datum (substr datum 1 stringpos))
		      )(setq datumdesc "")
      )		
(if (= (nth 6 attlist) "")(setq surfirm "")(setq surfirm (strcat " surveyorFirm=\"" (nth 6 attlist) "\" ")))
  (if (= (nth 8 attlist) "")(setq surveyorReference "")(setq surveyorReference (strcat " surveyorReference=\"" (nth 8 attlist) "\" ")))
  (if (= (nth 9 attlist) "")(setq shdesc "")(setq shdesc (strcat " desc=\"" (nth 9 attlist) "\" ")))
(setq surname (substr (nth 0 attlist) 3 50))
(setq surjur (nth 14 attlist))
(setq surformat (nth 15 attlist))
(setq surtype (nth 13 attlist))

		(SETQ DOS (nth 7 attlist))
  (if (/= dos "")(progn

;sort date entrys
  ;replace /,\,. with -
  (setq /pos 0)
	      (while (/=  (setq /pos (vl-string-search "/" dos /pos )) nil) (setq dos (vl-string-subst "-" "/"  dos /pos)
										      /pos (+ /pos 1)))
(setq /pos 0)
	      (while (/=  (setq /pos (vl-string-search "\\" dos /pos )) nil) (setq dos (vl-string-subst "-" "\\"  dos /pos)
										      /pos (+ /pos 2)))
  (setq /pos 0)
	      (while (/=  (setq /pos (vl-string-search "." dos /pos )) nil) (setq dos (vl-string-subst "-" "."  dos /pos)
										      /pos (+ /pos 1)))
    (setq minuspos1 (vl-string-position 45 dos 0))
  (setq minuspos2 (vl-string-position 45 dos (+ minuspos1 1)))
  (if (or (= minuspos1 1)(= minuspos1 2))(progn;rearrage date
				       (setq day  (substr dos 1 minuspos1))
				       (if (= (strlen day) 1) (setq day (strcat "0" day)));single digit days
				       (setq month (substr dos (+ minuspos1 2) (- (- minuspos2 minuspos1) 1)))
				       (if (= (strlen month) 1) (setq month (strcat "0" month)));single digit days
				       (setq year  (substr dos (+ minuspos2 2) 50))
				       (setq dos (strcat year "-" month "-" day))
				       ));p&if dos round the wrong way
  ));p&if dos not ""

 (SETQ DOR (nth 12 attlist))
  (if (/= DOR "")(progn

;sort date entrys
  ;replace /,\,. with -
  (setq /pos 0)
	      (while (/=  (setq /pos (vl-string-search "/" DOR /pos )) nil) (setq DOR (vl-string-subst "-" "/"  DOR /pos)
										      /pos (+ /pos 1)))
(setq /pos 0)
	      (while (/=  (setq /pos (vl-string-search "\\" DOR /pos )) nil) (setq DOR (vl-string-subst "-" "\\"  DOR /pos)
										      /pos (+ /pos 2)))
  (setq /pos 0)
	      (while (/=  (setq /pos (vl-string-search "." DOR /pos )) nil) (setq DOR (vl-string-subst "-" "."  DOR /pos)
										      /pos (+ /pos 1)))
    (setq minuspos1 (vl-string-position 45 DOR 0))
  (setq minuspos2 (vl-string-position 45 DOR (+ minuspos1 1)))
  (if (or (= minuspos1 1)(= minuspos1 2))(progn;rearrage date
				       (setq day  (substr DOR 1 minuspos1))
				       (if (= (strlen day) 1) (setq day (strcat "0" day)));single digit days
				       (setq month (substr DOR (+ minuspos1 2) (- (- minuspos2 minuspos1) 1)))
				       (if (= (strlen month) 1) (setq month (strcat "0" month)));single digit days
				       (setq year  (substr DOR (+ minuspos2 2) 50))
				       (setq DOR (strcat year "-" month "-" day))
				       ));p&if DOR round the wrong way
  ));p&if DOR not ""


		(setq surpersonel (nth 5 attlist))
		(setq surpos (nth 11 attlist))
		(setq surps (nth 10 attlist))
		(setq subnum (nth 21 attlist))
		(setq surpn (nth 16 attlist))
		(setq surregion "")
		(setq surloc (nth 2 attlist))
		(setq surlga (nth 1 attlist))
		(setq surparish (nth 3 attlist))
		(setq surcounty (nth 4 attlist))
		(setq surterrain "")
		(setq hdatum (nth 18 attlist))
		(setq vdatum (nth 19
				  attlist))

		));P&IF PLANFORM 3
		
		
		
		
		
		
		
		
	      
  );p admin sheet
  (princ "\nERROR No Admin Sheet Found")
  );P&IF ADMINSHEET EXISTS

 




  

  ;GET XML FILE
 (setq outfile (getfiled "Output File" "" "XML" 1))
  (setq outfile (open outfile "w"))
  
  ;WRITE XML HEADER

   
     (setq d (rtos (getvar "CDATE") 2 6))
     (setq date1 (strcat (substr d 3 2)  "-" (substr d 5 2) "-" (substr d 7 2)))
     (setq time1 (strcat (substr d 10 2) ":" (substr d 12 2) ":" (substr d 14 2)))
  (if (= (strlen time1 ) 7) (setq time1 (strcat time1 "0")));fix trailing zeros removed on tens of seconds
  (if (= (substr time1 7 2) "60") (setq time1 (strcat (substr time1 1 6 ) "00")))
  (if (= (substr time1 7 2) "") (setq time1 (strcat (substr time1 1 6 ) "00")))

    
  (princ "\nWriting File Header")
  (write-line "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" outfile)
(write-line (strcat "<LandXML version=\"1.0\" date=\"20" date1 "\" time=\"" time1 "\"" ) outfile)
(write-line  "xmlns=\"http://www.landxml.org/schema/LandXML-1.2\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.landxml.org/schema/LandXML-1.2 http://www.landxml.org/schema/LandXML-1.2/LandXML-1.2.xsd\">" outfile)
(write-line "<Units>" outfile)
  (write-line "<Metric linearUnit=\"meter\" temperatureUnit=\"celsius\" volumeUnit=\"cubicMeter\" areaUnit=\"squareMeter\" pressureUnit=\"milliBars\" angularUnit=\"decimal dd.mm.ss\" directionUnit=\"decimal dd.mm.ss\" />" outfile)
(write-line "</Units>" outfile)
(write-line (strcat "<CoordinateSystem" datumdesc " datum=\""datum "\" horizontalDatum=\"" hdatum "\" verticalDatum=\"" vdatum "\" />") outfile)
(write-line "" outfile)
(write-line (strcat "<Application name=\"Landxml for Autocad\" version=\"" version "\" >") outfile)
    (write-line "<Author createdBy=\"Lodged\" />" outfile)
    (write-line "</Application>" outfile)

    (if (= datum "MGA")
      (progn
	(write-line "<FeatureDictionary name=\"ReferenceDataContext\" version=\"NSW-101013\" >" outfile)
(write-line "<DocFileRef name=\"au-gov-nsw-icsm-cif-enumerated-types.xsd\" location=\"http://www.nswlrs.com.au/__data/assets/xml_file/0010/137368/xml-gov-au-nsw-icsm-eplan-cif-referencedata-101013.xml\" />" outfile)
(write-line "</FeatureDictionary>" outfile)
)
     (progn
(write-line "<FeatureDictionary name=\"xml-gov-au-nsw-icsm-eplan-cif-protocol\" version=\"4.0\"/>" outfile)
))
;(write-line "<DocFileRef name=\"au-gov-nsw-icsm-cif-enumerated-types.xsd\" location=\"http://www.nswlrs.com.au/__data/assets/xml_file/0010/137368/xml-gov-au-nsw-icsm-eplan-cif-referencedata-101013.xml\" />" outfile)
;(write-line "</FeatureDictionary>" outfile)
  
  ;@@@@Write cg points while checking for pms and datum points
    (princ "\nWriting CG points")
  
(write-line (strcat "<CgPoints " zone ">") outfile)
    

    
			     
    
(setq count 0)
  (repeat (/ (length cgpl) 5)
    (setq p1s (nth count cgpl))
    (setq pntSurv (nth (+ count 1) cgpl))
    (setq state (nth (+ count 2) cgpl))
    (setq name (nth (+ count 3) cgpl))
    (setq code (nth (+ count 4) cgpl))
    (if (= state "affected" )(setq state "proposed"))

    ;check for levels and shift if necessary
    (if (> (length sdps) 0)(progn
			     (setq spcpos1 (vl-string-position 32 p1s 0))
			      (setq eeast (atof(substr p1s (+ spcpos1 2) 200)))
                              (setq enorth  (atof (substr p1s 1 spcpos1)))
		
			     (if (= (member code sdps) nil)
			       (progn
				 (princ (strcat "\n Point with no concurrent datum point level at " (rtos eeast 2 3) "," (rtos enorth 2 3)))
				 )
			       (progn ;else
                     			 
			     (setq shifte (cadr (member code sdps)))
			     (setq shiftn (caddr (member code sdps)))
		
		(setq p1s (strcat (rtos (+ enorth shiftn) 2 6) " " (rtos (+ eeast shifte) 2 6)));semi colon this out for no-stacking
			     ));p&if code found in sdps
			     ));p&if sdps > 0
      

    (if (/= (setq datumpoint (cadr (member p1s dpl))) nil)(setq desc (strcat "desc=\""datumpoint "\" "))(setq desc ""))
    (if (and (/= (cadr (member p1s dpl)) nil)(/= (caddr (member p1s dpl)) "NORL"))(setq p1s (strcat p1s  " " (caddr (member p1s dpl)))))
    (if (/= (setq pmnum (cadr (member p1s pmlist))) nil)(progn
							  (setq oid "")
							  (if (= (substr pmnum 1 3) "SSM")(setq oid (strcat "oID=\""(substr pmnum 4 50) "\" ")))
							  (if (= (substr pmnum 1 2) "PM")(setq oid (strcat "oID=\""(substr pmnum 3 50) "\" ")))
							  (if (= (substr pmnum 1 2) "TS")(setq oid (strcat "oID=\""(substr pmnum 3 50) "\" ")))
							  (if (= (substr pmnum 1 2) "MM")(setq oid (strcat "oID=\""(substr pmnum 3 50) "\" ")))
							  (if (= (substr pmnum 1 2) "GB")(setq oid (strcat "oID=\""(substr pmnum 3 50) "\" ")))
							  (if (= (substr pmnum 1 2) "CR")(setq oid (strcat "oID=\""(substr pmnum 3 50) "\" ")))
							  (if (= (substr pmnum 1 2) "CP")(setq oid (strcat "oID=\""(substr pmnum 3 50) "\" ")))
							  (if (= oid "")(progn
									  (setq wpos (vl-string-position 39 pmnum 0))
									    (setq oid (strcat "oID=\"" (substr pmnum (+ wpos 1)) "\" "))))
								)
      
      (setq oid "")
      )
    (setq count (+ count 5))

    (if (/= code "")(setq code (strcat " code=\"" code "\"")))
     
    (write-line (strcat "  <CgPoint state=\""state"\" pntSurv=\"" pntsurv "\" " oid desc "name=\"" name "\"" code ">" p1s  "</CgPoint>") outfile)
    );r
(write-line "</CgPoints>" outfile)
  (write-line "" outfile)
    (princ "\nWriting Parcels")
  (write-line "<Parcels>" outfile)

  (setq count 0)
  (repeat (length mpolist)
    
    (write-line (nth count mpolist) outfile)
    (setq count (+ count 1))
    )
  (setq count 0)
  (repeat (length lotlist)
    (write-line (nth count lotlist) outfile)
    (setq count (+ count 1))
    )
  
  
  
    (write-line "</Parcels>" outfile)

  ;plan features
    (princ "\nWriting Plan Features")
  (if (> (length pflist) 0)(progn
		    (write-line "<PlanFeatures name=\"Occupation\">" outfile)
	    (setq count 0)
  (repeat (length pflist)
    (write-line (nth count pflist) outfile)
    (setq count (+ count 1))
    );r
		    (write-line "</PlanFeatures>" outfile)
		    )
    )
   (princ "\nWriting Survey Header")

  

  
  ;write survey header  
  ;@@@@surveyorf firm extra "
  (write-line "<Survey>" outfile)
(write-line (strcat "  <SurveyHeader name=\"" surname "\" jurisdiction=\"" surjur "\"" shdesc surfirm surveyorReference " surveyFormat=\"" surformat "\" type=\"" surtype "\">") outfile)
 

  
 
(if ( = surtype "surveyed")(setq dostype "Survey")(setq dostype "Compilation"))
 (if (/= DOS "")(write-line (strcat "    <AdministrativeDate adminDateType=\"Date Of "dostype"\" adminDate=\"" DOS "\" />") outfile))

  
  
    (if (/= dor "")(write-line (strcat "    <AdministrativeDate adminDateType=\"Registration Date\" adminDate=\"" dor "\"/>") outfile))
    (if (/= surpersonel "")(write-line (strcat "    <Personnel name=\"" surpersonel "\" />") outfile))
    (if (/= surpos "")(write-line (strcat "    <PurposeOfSurvey name=\"" surpos "\"/>") outfile))
        (if (/= flowarrows "")(write-line flowarrows outfile))
    (if (/= surps "")(progn
				  (write-line (strcat "    <Annotation type=\"Plans Used\" name=\"" (rtos annocount 2 0) "\" desc=\"" surps "\"/>") outfile)
				  (setq annocount (+ annocount 1))))
    (if (/= subnum "")(progn
				  (write-line (strcat "    <Annotation type=\"Subdivision Number\" name=\"" (rtos annocount 2 0) "\" desc=\"" subnum "\"/>")outfile)
				  (setq annocount (+ 1 annocount))))
    (if (= surformat "Strata Schemes")(progn
					(write-line (strcat "    <Annotation type=\"Scale\" name=\"" (rtos annocount 2 0) "\" desc=\"1:" (rtos scale 2 0) "\"/>")outfile)
				  (setq annocount (+ 1 annocount))))

   ;write annotation to list
    (setq crlfpos 0)
    (while (/=  (setq crlfpos (vl-string-search "&#xA;" surpn )) nil)
      (progn
	
	(if (= crlfpos 0) (setq surpn (substr surpn 6 10000));if it starts with a linefeed
	  (progn;else
	(setq frontstring (substr surpn 1 crlfpos))
	(setq annolist (append annolist (list frontstring)))
	(setq surpn (substr surpn (+ crlfpos 6) 10000))
	));p if linefeed
	  
	));p&while
    (if (and (> (strlen surpn) 0)(/= surpn " "))(setq annolist (append annolist (list surpn))))
         (setq ancount 0)
    (repeat (length annolist)
      (setq surpn1 ( nth ancount annolist))   
(write-line  (strcat "    <Annotation type=\"Plan Note\" name=\""(rtos annocount 2 0) "\" desc=\"" surpn1 "\"/>")outfile)
  (setq annocount (+ annocount 1))
      (setq ancount (+ ancount 1))
  )
      
	

  
    (if (/= nil (vl-string-position 47 surlga  1))
      (progn
	(while (/= nil (setq /pos (vl-string-position 47 surlga 1)))
	  (progn
	    (setq surlgas (substr surlga 1 /pos))
	    (setq surlga (substr surlga (+ /pos 2) 5000))
	    (if (/= surlga "")(write-line (strcat "    <AdministrativeArea adminAreaType=\"Local Government Area\" adminAreaName=\"" surlgas "\"/>") outfile))
	    ))))
    (if (/= surlga "")(write-line (strcat "    <AdministrativeArea adminAreaType=\"Local Government Area\" adminAreaName=\"" surlga "\"/>") outfile))
    
(if (/= nil (vl-string-position 47  surloc 1))
      (progn
	(while (/= nil (setq /pos (vl-string-position 47  surloc 1)))
	  (progn
	    (setq surlocs (substr surloc 1 /pos))
	    (setq surloc (substr surloc (+ /pos 2) 5000))
	    (if (/= surloc "")(write-line (strcat "    <AdministrativeArea adminAreaType=\"Locality\" adminAreaName=\"" surlocs "\"/>") outfile))
	    ))))
    (if (/= surloc "")(write-line (strcat "    <AdministrativeArea adminAreaType=\"Locality\" adminAreaName=\"" surloc "\"/>") outfile))
    
(if (/= nil (vl-string-position 47  surparish 1))
      (progn
	(while (/= nil (setq /pos (vl-string-position 47  surparish 1)))
	  (progn
	    (setq surparishs (substr surparish 1 /pos))
	    (setq surparish (substr surparish (+ /pos 2) 5000))
	    (if (/= surparish "")(write-line (strcat "    <AdministrativeArea adminAreaType=\"Parish\" adminAreaName=\"" surparishs "\"/>") outfile))
	    ))))
    (if (/= surparish "")(write-line (strcat "    <AdministrativeArea adminAreaType=\"Parish\" adminAreaName=\"" surparish "\"/>") outfile))

    (if (/= nil (vl-string-position 47  surcounty 1))
      (progn
	(while (/= nil (setq /pos (vl-string-position 47  surcounty 1)))
	  (progn
	    (setq surcountys (substr surcounty 1 /pos))
	    (setq surcounty (substr surcounty (+ /pos 2) 5000))
	    (if (/= surcounty "")(write-line (strcat "    <AdministrativeArea adminAreaType=\"County\" adminAreaName=\"" surcountys "\"/>") outfile))
	    ))))    
    (if (/= surcounty "")(write-line (strcat "    <AdministrativeArea adminAreaType=\"County\" adminAreaName=\"" surcounty "\"/>") outfile))
    
     (if (/= surregion "")(write-line (strcat "    <AdministrativeArea adminAreaType=\"Survey Region\" adminAreaName=\"" surregion "\"/>") outfile))
    (if (/= surterrain "")(write-line (strcat "    <AdministrativeArea adminAreaType=\"Terrain\" adminAreaName=\"" surterrain "\"/>") outfile))
  (write-line "  </SurveyHeader>" outfile)

;Write instrument stations to file
    (princ "\nWriting Instrument Stations")
(setq count 0)
  (repeat (/ (length cgpl) 5)
    (setq name (nth (+ count 3) cgpl))

    
    (if (member name islist) (progn
(write-line (strcat "  <InstrumentSetup id=\"IS" name "\" stationName=\"" name "\" instrumentHeight=\"0\">") outfile)
        (write-line (strcat "<InstrumentPoint pntRef=\"" name "\"/>") outfile)
   (write-line "</InstrumentSetup>" outfile)
));p&if
    (setq count (+ count 5))
    );r
(princ "\nWriting Observations")
  ;write reference observations    
(write-line "<ObservationGroup id=\"OG-1\">" outfile)

  (setq count 0)
  (repeat (length rolist)
    (write-line (strcat "  "(nth count rolist)) outfile)
    (setq count (+ count 1))
    );r
  (write-line "</ObservationGroup>" outfile)
  (write-line "</Survey>" outfile)
    (princ "\nWriting Monuments")
    (IF ( /= monlist nil)(progn
  (write-line "<Monuments>" outfile)

  (setq count 1)
    (repeat (/(length monlist)2)
(write-line (strcat "  "(nth count monlist)) outfile)
      (setq count (+ count 2))
      );r

  (write-line "</Monuments>" outfile)
  ))
(write-line "</LandXML>" outfile)
    (princ "\nClosing File")
(close outfile)

    ;add cgpoints to to drawing

    (princ "\nAdding CG points labels to drawing")
(IF (/= (setq oldcgp (ssget "_X"  '((8 . "CG Points")))) nil)(command "erase" oldcgp ""))

(setvar "clayer" "CG Points")
(setq count 0)
(repeat (/ (length cgpl) 5)
  (setq coord (nth count cgpl))
  (setq text (strcat (nth (+ count 3) cgpl)(substr (nth (+ count 1) cgpl) 1 1)(substr (nth (+ count 2) cgpl) 1 1)))
  (setq spcpos1 (vl-string-position 32 coord 0))
  (setq spcpos2 (vl-string-position 32 coord spcpos1))
  (if (/= spcpos2 nil)(setq height (substr coord (+ spcpos2 2) 200)) ;if a height
    (setq spcpos2 200
	  height "0");else store as 200
    )
(setq north   (substr coord 1  spcpos1  ))
(setq east   (substr coord (+ spcpos1 2) spcpos2))
(setq coord (LIST (ATOF east) (ATOF  north) (atof height)))
  (setq coord (trans coord 0 1))
  ;(command "point" coord) removed caused confusion of points
  (COMMAND "TEXT" "J" "BL"  coord (* TH 0.25) "90" text)
(setq count (+ count 5))
  )


    
    (princ "\nChecking for close vicinity points")
(setq roundlist (list))
    (setq exactlist (list))
    (setq rnd 0.010)
    (setq cvpf "N")
    (setq count 0)
    (repeat (/ (length cgpl) 5)
      (setq pntsurv (nth (+ count 1) cgpl))
      (if (/= pntsurv "sideshot")
	(progn
  (setq coord (nth count cgpl))
    (setq spcpos (vl-string-position 32 coord 0))
(setq north   (atof (substr coord 1  spcpos  )))
(setq east   (atof (substr coord (+ spcpos 2) )))

  ;create rounded values
(setq rnorth (/ north rnd))
    (setq fp (- rnorth (fix rnorth)))
  (if (>= fp 0.5)(setq rnorth (* (+ (fix rnorth) 1) rnd))(setq rnorth (* (fix rnorth) rnd)))
  (setq reast (/ east rnd))
  (setq fp (- reast (fix reast)))
  (if (>= fp 0.5)(setq reast (* (+ (fix reast) 1) rnd))(setq reast (* (fix reast) rnd)))

   (if (and (member (strcat (rtos reast 2 6) "," (rtos rnorth 2 6)) roundlist)(= (member (strcat (rtos east 2 6) "," (rtos north 2 6)) exactlist) nil))
	(progn
    
  (if (= cvpf "N") (progn
			     (setq cvpf "Y")
			     (princ "\nWarning - close points found:")
			     ))
	(princ (strcat " " (rtos east 2 3) "," (rtos  north 2 3)))
	)
	)
  (setq exactlist (append exactlist (list (strcat (rtos east 2 6) "," (rtos north 2 6)))))
  (setq roundlist (append roundlist (list (strcat (rtos reast 2 6) "," (rtos rnorth 2 6)))))
     
  
      ));if sideshot
       (setq count ( + count 5))
      )



    
    (setvar "clayer" prevlayer )
(princ "\nExport Complete")
    
    );defun

(setq purposelist (list"Additional Sheet For Community Title Plan" "Boundary Adjustment Plan For Community Title Plan" "Building Alteration Plan" "Building Alteration Plan - Leasehold" "Building Stratum Subdivision"
"Building Stratum Subdivision" "Coal Definition" "Community Plan" "Community Plan Of Consolidation" "Community Plan Of Subdivision" "Consolidation" "Crown Folio Creation" "Delimitation" "Departmental"
"Easement" "Ex-Survey Plan" "Lease"  "Limited Folio Creation" "Neighbourhood Plan" "Neighbourhood Plan Of Consolidation" "Neighbourhood Plan Of Subdivision" "Oyster Lease" "Part Strata" "Pipelines Act, 1967"
"Precinct Plan" "Precinct Plan Of Consolidation" "Precinct Plan Of Subdivision" "Primary Application" "Redefinition" "Replacement Sheet For Community Title Plan" "Resumption Or Acquisition" "Road Or Motorway"
"Roads Act, 1993" "Strata Plan" "Strata Plan - Leasehold" "Strata Plan Of Consolidation" "Strata Plan Of Consolidation - Leasehold" "Strata Plan Of Subdivision" "Strata Plan Of Subdivision - Leasehold" "Staged Strata Plan"
"Staged Strata Plan Of Subdivision" "Subdivision" "Surrender" "Survey Information Only"))

(setq formatlist (list "Community Schemes" "Examination Survey" "Standard" "Stratum" "Strata Schemes" "Survey Information Only"))
(setq datumlist (list "Local" "MGA" "MGA94" "MGA2020" "MM" "ISG" "TM" ))

(setq errorcodelist (list "ILLEGIBLE TEXT ON PLAN" "BEARING DERIVED BY EP" "BEARING SUPPLIED BY DPXML" "BEARING ADOPTED FROM DP" "CROSSED OUT BEARING USED" "2 BEARINGS SHOWN" "ILLEGIBLE BEARING"
"DISTANCE MISSING" "DISTANCE DERIVED BY EP" "DISTANCE SUPPLIED BY DPXML" "DISTANCE ADOPTED FROM DP" "2 DISTANCES SHOWN" "ILLEGIBLE DISTANCE" "BEARING AND DISTANCE DERIVED BY EP"
"BEARING AND DISTANCE SUPPLIED BY DPXML" "ADOPTED FROM DP" "ILLEGIBLE BEARING AND DISTANCE" "ARC MISSING" "ARC LENGTH DERIVED BY EP" "ARC SUPPLIED BY DPXML"
"BEARING AND ARC SUPPLIED BY DPXML" "BEARING AND ARC ADOPTED FROM DP" "RADIUS SUPPLIED BY DPXML" "RADIUS ADOPTED FROM DP" "RADIUS NOT SHOWN ON PLAN - ARC"
"ARC AND RADIUS SUPPLIED BY DPXML" "BEARING AND RADIUS SUPPLIED BY DPXML" "BEARING ARC AND RADIUS SUPPLIED BY DPXML" "BEARING DISTANCE AND ARC SUPPLIED BY DPXML"
"CHORD SUPPLIED BY DPXML" "BEARING AND CHORD SUPPLIED BY DPXML" "CURVED LINE CHORD AND RADIUS NOT SHOWN" "PARCEL NUMBER SUPPLIED BY DPXML" "CLASS AND ORDER SUPPLIED BY DPXML"
"MARK TYPE ADOPTED FROM DP" "MARK TYPE PROVIDED BY DPXML" "MARK TYPE NOT SPECIFIED" "PLAN IN ERROR" "INCORRECT SETUP OR TARGET" "COORDINATE ERROR"
"SSM NUMBER REFERRED FROM SIX MAPS BY EP" "DUPLICATE DATUM LABELS" "AREA CALCULATED" "MULTIPART LOT � ALL PARTS COULD NOT BE CAPTURED" "ROAD WIDENING"
"GEOREFERENCED" "FALSE CONNECTION LINE"))
      
		    

(setq parishlist (list
"Abbotsford,Waljeers" "Abena,Windeyer" "Aberbaldie,Vernon" "Abercorn,Westmoreland" "Abercrombie,Beresford" "Abercrombie,Burnett" "Abercrombie,Georgiana" "Abercrombie,Waradgery" "Aberfoil,Bathurst" "Aberfoyle,Clarke" "Aberfoyle,Leichhardt" "Abington,Hardinge" "Abington,Wallace" "Acacia,Buller" "Aconite,Hardinge" "Adaminiby,Wallace" "Adams,Burnett" "Adams,Mouramba" "Adams,Stapylton" "Adderley,Westmoreland"
"Addicumbene,Wallace" "Addison,Clive" "Adelong,Wynyard" "Adelyne,Lincoln" "Adjungbilly,Buccleuch" "Adowa,Arrawatta" "Ailsa,Brisbane" "Ainsley,Parry" "Airly,Roxburgh" "Akolia,Narran" "Albemarle,Livingstone" "Albert,Delalah" "Albert,Drake" "Albert,Kennedy" "Albert,Macquarie" "Albert,Rankin" "Albert,Sandon" "Albert,St Vincent" "Albert,Yancowinna" "Albert,Yantara"
"Alberta,Farnell" "Albinia,Booroondarra" "Albury,Goulburn" "Albyn,Mouramba" "Aldborough,Yancowinna" "Alder,Gresham" "Alexander,Wellesley" "Alexandria,Cumberland" "Alfred,Darling" "Alfred,Gloucester" "Alfred,Westmoreland" "Algalah,Narromine" "Algie,Yantara" "Alice,Drake" "Allamurgoola,Ewenmar" "Allan,Fitzroy" "Allandale,Northumberland" "Allans Water,Fitzroy" "Alleyne,Sturt" "Allgomera,Raleigh"
"Allingham,Clarke" "Allison,Napier" "Allundy,Ularara" "Allyn,Durham" "Alma,Brisbane" "Alma,Waljeers" "Alma,Yancowinna" "Alnwick,Northumberland" "Alpine,Arrawatta" "Althorpe,Durham" "Alto,Fitzgerald" "Alton,King" "Amoilla,Nicholson" "Amoilla North,Nicholson" "Amoona,Manara" "Amos,Leichhardt" "Amoskeag South,Tara" "Amphitheatre,Robinson" "Amungula,Murray" "Anderson,Arrawatta"
"Anderson,Culgoa" "Anderson,Gough" "Anderson,Murchison" "Andy,Vernon" "Angoperran,Clive" "Angorawa,Hunter" "Anna,Parry" "Annan,Clyde" "Annan,Waljeers" "Annand,Wentworth" "Annandale,Clive" "Annandale,Cowper" "Anson,Bathurst" "Antares,Canbelego" "Antimony,Buller" "Antita,Windeyer" "Antonio,Westmoreland" "Appin,Cumberland" "Apsley,Bathurst" "Apsley,Vernon"
"Arabi,Killara" "Arable,Wallace" "Arajoel,Mitchell" "Arakoon,Macquarie" "Araluen,St Vincent" "Ardennes,Young" "Ardfert,Irrara" "Ardgowan,Courallie" "Arding,Sandon" "Ardlethan,Bourke" "Argoon,Boyd" "Ariah,Bourke" "Ariah,Cooper" "Aripilis,Gunderbooka" "Arkell,Bathurst" "Arlington,Livingstone" "Armatree,Ewenmar" "Armidale,Sandon" "Arndell,Hunter" "Arnheim,Evelyn"
"Arrarownie,White" "Arrawatta,Waljeers" "Arthur,Phillip" "Arthurs Seat,Arrawatta" "Arumpo,Wentworth" "Arvid,Gough" "Ashbourne,Livingstone" "Ashbridge,Bourke" "Ashby,Arrawatta" "Ashby,Clarence" "Ashcroft,Mitchell" "Ashford,Arrawatta" "Ashton,Irrara" "Ashton,Wellesley" "Astley,Arrawatta" "Astolat,Perry" "Aston,Hardinge" "Athol,Arrawatta" "Attunga,Inglis" "Auburn,Northumberland"
"Auburn Vale,Hardinge" "Auckland,Durham" "Audrey,Franklin" "Austen,Murchison" "Avenal,Durham" "Avenel,Farnell" "Avisford,Wellington" "Avoca,Wentworth" "Avon,Gloucester" "Avondale,Clarke" "Avondale,Waljeers" "Awaba,Northumberland" "Baan Baa,Pottinger" "Babathnil,Kennedy" "Babbinboon,Buckland" "Babego,Flinders" "Babinda,Flinders" "Baby,Gowen" "Babyil,Rous" "Bachelor,Gloucester"
"Back Creek,Bland" "Back Creek,Goulburn" "Back Roto,Blaxland" "Back Wallandra,Blaxland" "Back Whoey,Blaxland" "Back Willoi,Clyde" "Backalum,Wallace" "Backwater,Narromine" "Baden Park,Woore" "Badham,Baradine" "Badham,Windeyer" "Badja,Dampier" "Badjerrigarn,Farnell" "Baeda,Franklin" "Baerami,Hunter" "Bagawa,Fitzroy" "Bago,Wynyard" "Bagot,Clarke" "Bagot,Finch" "Bahpunga,Caira"
"Baillie,Sturt" "Bajimba,Clive" "Baker,Hardinge" "Bala,King" "Bala,Northumberland" "Balabla,Bland" "Balaclava,Gough" "Balah,Robinson" "Balala,Hardinge" "Balara,Killara" "Balcombe,Oxley" "Bald Blair,Clarke" "Bald Hill,Lincoln" "Bald Nob,Gough" "Baldon,Wakool" "Baldwin,Darling" "Baldwin,Hardinge" "Balerang,Benarba" "Balfour,Burnett" "Balfour,Westmoreland"
"Balgay,Flinders" "Balladoran,Ewenmar" "Ballah,Caira" "Ballalla,Benarba" "Ballallaba,Murray" "Ballanbillian,Narran" "Ballandean,Clive" "Ballaree,Clyde" "Ballengarra,Macquarie" "Ballimore,Lincoln" "Ballina,Rous" "Ballingall,Sturt" "Ballycastle,Barrona" "Ballyroe,Georgiana" "Balmoral,Durham" "Baloo,Buccleuch" "Baloon,Finch" "Balpool,Wakool" "Balranald,Caira" "Balumbridal,Gowen"
"Bama,Cadell" "Bambilla,Woore" "Banandra,Boyd" "Banangalite,Townsend" "Banar,Gipps" "Banarway,Benarba" "Bandamora,Roxburgh" "Bandi Bandi,Dudley" "Bando,Pottinger" "Bandon,Forbes" "Bandulla,Gowen" "Bang Bang,Forbes" "Banga,Cowper" "Bangadilly,Camden" "Bangaroo,Bathurst" "Bangheet,Murchison" "Bango,King" "Bangus,Wynyard" "Banjah,Yantara" "Banksia,Camden"
"Bankstown,Cumberland" "Bannaby,Argyle" "Bannah,Gregory" "Bannan,Canbelego" "Bannockburn,Arrawatta" "Bannockburn,Narran" "Banny,Woore" "Banshea,Westmoreland" "Bantry,Irrara" "Banyabba,Clarence" "Bara,Phillip" "Baradine,Baradine" "Baraneal,Denham" "Baratta,Cunningham" "Barbigal,Lincoln" "Barbingal,Bland" "Barbston,Young" "Barcham,Woore" "Barcoola,Landsborough" "Barden,Arrawatta"
"Bardool,Fitzroy" "Bardsley,Fitzroy" "Barellan,Cooper" "Barford,Durham" "Bargo,Camden" "Barham,Wakool" "Barigan,Phillip" "Baring,Westmoreland" "Barlow,Hardinge" "Barlow,Windeyer" "Barmedman,Bland" "Barnard,Hawes" "Barnard,Macquarie" "Barnbah,Finch" "Barnet,Murray" "Barneto,Booroondarra" "Barnett,King" "Barney Downs,Clive" "Baroma,Burnett" "Baronne,Leichhardt"
"Barooga,Denison" "Barool,Gresham" "Baroona,Benarba" "Baroora,Robinson" "Baroorangee,Young" "Barraba,Darling" "Barrabu,Wakool" "Barraganyatti,Dudley" "Barrajin,Ashburnham" "Barralong,Cooper" "Barrangeel,Finch" "Barrara,Perry" "Barratta,Townsend" "Barrawanga,Richmond" "Barrawanna,Windeyer" "Barrier,Yancowinna" "Barrigan,Mossgiel" "Barrington,Gloucester" "Barringun,Culgoa" "Barritt,Perry"
"Barrow,Flinders" "Barry,Hawes" "Barry,Tara" "Barry,Windeyer" "Barton,Ashburnham" "Barton,Cook" "Barton,Courallie" "Barton,Cowper" "Barton,Mouramba" "Barton,Narromine" "Barwon,Baradine" "Barwon,Denham" "Barwon,Finch" "Basin Bank,Rankin" "Bateman,St Vincent" "Bates,Clive" "Bathurst,Bathurst" "Batlow,Wynyard" "Batthing,Killara" "Baw Baw,Argyle"
"Baxter,Monteagle" "Bayly,Phillip" "Baymore,Manara" "Beablebar,Oxley" "Beabula,Sturt" "Beabula,Waradgery" "Beaconsfield,Bourke" "Beaconsfield,Kennedy" "Beaconsfield,Nicholson" "Bearbong,Gowen" "Beardina,Oxley" "Beardy Plains,Gough" "Beargamil,Ashburnham" "Beaufort,Bathurst" "Beaumont,Selwyn" "Beauport,Blaxland" "Beaury,Buller" "Bebo,Arrawatta" "Bebri,Flinders" "Bebrue,Gregory"
"Bective,Parry" "Bedarbidgal,Waradgery" "Bedgerabong,Cunningham" "Bedulluck,Murray" "Bee,Robinson" "Beean Beean,Gloucester" "Beecroft,St Vincent" "Beefwood,Yungnulgra" "Beela,Perry" "Beelban,Oxley" "Beemarang,Georgiana" "Beemery,Clyde" "Beemunnel,Ewenmar" "Bega,Auckland" "Beggan Beggan,Harden" "Belah,Flinders" "Belaimong,Caira" "Belaley,Nicholson" "Belalie,Culgoa" "Belanglo,Camden"
"Belar,Caira" "Belar,Gowen" "Belar,Gregory" "Belar,Jamison" "Belar,Wentworth" "Belarbone,Gregory" "Belardery,Kennedy" "Belars,Cowper" "Belbora,Gloucester" "Belbrook,Narran" "Beleringar,Oxley" "Belford,Northumberland" "Belimebung,Bland" "Bell,Ashburnham" "Bell,Perry" "Bellaleppa,Bligh" "Bellangry,Macquarie" "Bellar,Tandora" "Bellatherie,Franklin" "Bellbrook,Dudley"
"Bellingerambil,Nicholson" "Bellingerambil East,Nicholson" "Bellingerambil South,Nicholson" "Belltrees,Durham" "Belmore,Darling" "Belmore,Georgiana" "Belmore,Gordon" "Belmore,Raleigh" "Belmore,Tara" "Belmore,Townsend" "Belmore,Wakool" "Belmore,White" "Belmore,Wynyard" "Beloka,Wallace" "Beloura,Mouramba" "Belowra,Dampier" "Belubula,Ashburnham" "Belubula,Bathurst" "Bemboka,Auckland" "Ben Bullen,Roxburgh"
"Ben Lomond,Gough" "Bena,Gipps" "Bena,Gregory" "Benandarah,St Vincent" "Benanee,Taila" "Benanimie,Waljeers" "Benarca,Cadell" "Bendemeer,Inglis" "Bendermere,Clyde" "Bendick Murrell,Monteagle" "Bendigo,Sturt" "Benditi,Vernon" "Bendoura,St Vincent" "Benduck North,Waradgery" "Benduck South,Waradgery" "Benelabri,Pottinger" "Benelkay,Manara" "Benelkay,Waljeers" "Beneree,Bathurst" "Benerembah,Sturt"
"Bengalla,Arrawatta" "Bengallow,Taila" "Bengerang,Stapylton" "Bengoro,Mootwingee" "Beni,Lincoln" "Benjee,Wakool" "Benkanyah,Booroondarra" "Benn,Denham" "Bennett,Mossgiel" "Benolong,Gordon" "Benongal,Caira" "Benson,Stapylton" "Bentinck,Kennedy" "Benya,Gordon" "Berambong,Wakool" "Berangabah,Livingstone" "Berangabah,Woore" "Berangerine,Nicholson" "Beranghi,Macquarie" "Berawinia,Delalah"
"Berawinia,Thoulcanna" "Berawinnia,Irrara" "Beremabere,Cooper" "Beremagaa,Franklin" "Beremegad,Wakool" "Berendebba,Bland" "Berenderry,Bligh" "Beresford,Waradgery" "Berewombenia,Cunningham" "Bergalia,Dampier" "Bergan,Denham" "Bergen Op Zoom,Vernon" "Bergo,Gregory" "Beri,Culgoa" "Berida,Ewenmar" "Berigan,Denison" "Berigerie,Baradine" "Bermagui,Dampier" "Berowra,Cumberland" "Berrembed,Bourke"
"Berrico,Gloucester" "Berrigan,Bland" "Berriganbam,Mossgiel" "Berrima,Camden" "Berrioye,Nandewar" "Berry,Canbelego" "Berry Jerry,Bourke" "Berry Jerry,Mitchell" "Berryabar,Denham" "Berrybah,Baradine" "Berrygill,Courallie" "Berthong,Bland" "Bertram,Perry" "Bertram,Taila" "Berwick,Rous" "Beryan,Gloucester" "Bethungra,Clarendon" "Bettowynd,St Vincent" "Betts,Urana" "Beugamel,Kennedy"
"Beurina,Wallace" "Bevan,Mossgiel" "Bexhill,Rous" "Bherwerre,St Vincent" "Biala,King" "Biamble,Napier" "Bibbejibbery,Gregory" "Bibbijolee,Gipps" "Bibble,Benarba" "Bibil,Jamison" "Bibildoolie,Gunderbooka" "Bickanbeenie,Lincoln" "Biddi,Wellesley" "Bidura,Caira" "Bidura,Kilfera" "Bidura West,Taila" "Big Badja,Beresford" "Big Hill,Clarke" "Bigga,Georgiana" "Bilbil,Narran"
"Bilbo,Rankin" "Bilda,Clarendon" "Billa Bulla,Cowper" "Billabah,Mossgiel" "Billabong,Townsend" "Billabong,Waljeers" "Billabong Forest,Hume" "Billaboo,Jamison" "Billaboo South,Jamison" "Billabulla,Gregory" "Billabung,Clarendon" "Billabung,Goulburn" "Billagoe,Robinson" "Billibah,Manara" "Billilingra,Beresford" "Billilla,Livingstone" "Billilla,Werunda" "Billimari,Bathurst" "Billinudgel,Rous" "Billitong,Livingstone"
"Billybingbone,Clyde" "Billyena,Nandewar" "Billyrambija,Argyle" "Bilpin,Cook" "Bimbalingel,Dowling" "Bimbeen,Gipps" "Bimbella,Bland" "Bimbella,Cunningham" "Bimber,Finch" "Bimbera,Yanda" "Bimberi,Cowley" "Bimbi,Bland" "Bimbil,Dowling" "Bimble,Leichhardt" "Bimlow,Westmoreland" "Bimmil,Auckland" "Bimpia,Mootwingee" "Bimpia,Perry" "Binalong,Harden" "Binaroo,Tongowoko"
"Binbinette,Wakool" "Binda,Forbes" "Binda,Georgiana" "Binda Binda,Mossgiel" "Bindayah,Narran" "Bindera,Gloucester" "Bindi,Livingstone" "Bindo,Westmoreland" "Bindogundra,Ashburnham" "Bingagong,Urana" "Bingal,Rous" "Bingalong,Windeyer" "Bingar,Cooper" "Bingara,Murchison" "Bingellibunbi,Townsend" "Bingerry,Windeyer" "Bingham,Georgiana" "Binghi,Clive" "Bingle,Pottinger" "Bingoo,Wentworth"
"Bingunyah,Booroondarra" "Biniguy,Courallie" "Binjura,Beresford" "Binnaway,Napier" "Binnia,Napier" "Binny,Clive" "Binpooker,Killara" "Bintullia,Menindee" "Binya,Cooper" "Biparo,Landsborough" "Biraganbil,Wellington" "Biralbung,Gowen" "Birangan,Forbes" "Birben,Finch" "Birganbigil,Townsend" "Biridoo,Narromine" "Biroo,Benarba" "Birrah,Finch" "Birrawarra,Irrara" "Birrego,Mitchell"
"Birrema,Harden" "Birrigan,Flinders" "Birrimba,Gregory" "Birruma,Narran" "Black Camp,Drake" "Black Jack,Pottinger" "Blackcamp,Gloucester" "Blackheath,Cook" "Blackheath,Lincoln" "Blackman,Georgiana" "Blacknote,Sandon" "Blackwater,Hunter" "Blackwood,Finch" "Blackwood,Poole" "Blackwood,Townsend" "Blain,Clive" "Blair Hill,Gough" "Blairgowrie,Dowling" "Blairmont,Gregory" "Blake,Bathurst"
"Blake,Narran" "Blake,White" "Blakebrook,Rous" "Blakefield,Wallace" "Blakney,King" "Blanch,Wynyard" "Blanche,Young" "Blantyre,Narran" "Blarney,Barrona" "Blaxland,Fitzroy" "Blaxland,Mouramba" "Blaxland,Northumberland" "Bledger,Burnett" "Blenalben,Livingstone" "Blenalben,Manara" "Blenalben,Perry" "Blenheim,Livingstone" "Blenheim,Westmoreland" "Blicks,Fitzroy" "Bligh,Bligh"
"Bligh,Farnell" "Bligh,Fitzroy" "Blloonbah,Arrawatta" "Bloomfield,Inglis" "Bloomfield,Wallace" "Blow Clear,Gipps" "Blowan,Clyde" "Blowering,Buccleuch" "Bloxsome,Clive" "Bloxsome,Finch" "Bloxsome,Gough" "Blue Nobby,Burnett" "Blue Nobby,Stapylton" "Bluebush,Windeyer" "Bluff,Booroondarra" "Bluff,Caira" "Bluff Land,Clive" "Blumenthal,Young" "Blythe,Clarke" "Boambolo,Murray"
"Bobadeen,Bligh" "Bobarah,Ewenmar" "Bobbara,Harden" "Bobbiwaa,Jamison" "Bobin,Macquarie" "Boblegigbie,Bourke" "Bobo,Fitzroy" "Bobundara,Wallace" "Boco,Farnell" "Boco,Wellesley" "Bocobidgle,Ashburnham" "Bocoble,Roxburgh" "Bodalla,Dampier" "Bodangora,Lincoln" "Boduldura,Wellington" "Boebung,Ewenmar" "Bogalo,Blaxland" "Bogalo South,Blaxland" "Bogamildi,Burnett" "Bogan,Clyde"
"Bogan,Cowper" "Bogandillon,Gipps" "Bogandyera,Selwyn" "Bogeira,Narran" "Bogewang,Leichhardt" "Boggabilla,Stapylton" "Boggabri,Nandewar" "Boggabri,Pottinger" "Boggibri,Brisbane" "Bogia,Nicholson" "Boginderra,Bland" "Bogolong,Cooper" "Bogolong,Forbes" "Bogong,Buccleuch" "Bogra,Finch" "Bogree,Courallie" "Bogwarra,Narran" "Bohena,White" "Bohnock,Gloucester" "Boiga,Wellington"
"Boingadah,Woore" "Bokamore,Gregory" "Bolagamy,Gipps" "Bolaira,Wallace" "Bolaira,Yancowinna" "Bolaro,Cooper" "Bolaro,Lincoln" "Bolaro,Mossgiel" "Bolaro,St Vincent" "Bolcarol,Jamison" "Bolderogery,Gordon" "Boliva,Livingstone" "Bolivia,Clive" "Bollol,Nandewar" "Bolong,Georgiana" "Bolton,Nicholson" "Bolton,Urana" "Bolton,Westmoreland" "Bolungerai,Bland" "Bolwarry,Tongowoko"
"Bomangaldy,Yancowinna" "Bomarthong,Kilfera" "Bombah,Georgiana" "Bombah,Narran" "Bombala,Wellesley" "Bombell,Courallie" "Bomera,Pottinger" "Bomgadah,Mootwingee" "Bomobbin,Cunningham" "Bon Bon,Finch" "Bonalbo,Buller" "Bondi,Auckland" "Bondi,Cooper" "Bone Bone,Gowen" "Boneda,Culgoa" "Bong Bong,Camden" "Bongongalong,Harden" "Bonita,Yanda" "Bonley,Young" "Bonny,Killara"
"Bonshaw,Arrawatta" "Bonton,Manara" "Bonuna,Manara" "Bonville,Raleigh" "Boo Boo,Courallie" "Booabula,Townsend" "Boobah,Burnett" "Boobera,Stapylton" "Booberoi,Blaxland" "Boobooran,Mossgiel" "Booborowie,Rankin" "Boocathan,Caira" "Booda,Cowper" "Boogenderra,Narran" "Boogledie,Phillip" "Book Book,Wynyard" "Booka,Gunderbooka" "Bookambone,Cowper" "Bookham,Harden" "Bookit,Wakool"
"Bookookoorara,Buller" "Boolaboolka,Livingstone" "Boolambayte,Gloucester" "Booligal,Nicholson" "Booligurra,Yantara" "Boolijah,St Vincent" "Boolmuckledi,Benarba" "Boolonkeena,Tara" "Boolooroo,Courallie" "Boomagrill,Gregory" "Booman Gabar,Narran" "Boomanoomana,Denison" "Boomery,Irrara" "Boomery,Livingstone" "Boomey,Wellington" "Boomi,Benarba" "Boomi,Buller" "Boomi,Murchison" "Boomley,Lincoln" "Boona,Boyd"
"Boona,Kennedy" "Boona East,Cunningham" "Boona West,Cunningham" "Boonabah,Bland" "Boonabilla,Durham" "Boonal,Stapylton" "Boonaldoon,Benarba" "Boonanga,Stapylton" "Boonangar,Benarba" "Boonanghi,Dudley" "Boondara,Waljeers" "Boonderra,Narran" "Boonditti,Livingstone" "Boonerey,Benarba" "Boongunnyarra,Irrara" "Boonoke,Townsend" "Boonoo Boonoo,Buller" "Boonoona,Benarba" "Boonoona,Livingstone" "Boonun,Gregory"
"Booraba,Stapylton" "Boorabee,Rous" "Booraboonara,Mootwingee" "Boorah,Jamison" "Booral,Gloucester" "Booramine,Courallie" "Boorara,Finch" "Boorga,Townsend" "Boorimah,Baradine" "Boorla,Mootwingee" "Boorobil,Nandewar" "Boorolong,Sandon" "Boorong,Taila" "Boorongagil,Bland" "Booroo,Clive" "Booroobanilly,Urana" "Boorook,Buller" "Boorooma,Finch" "Booroominia,Culgoa" "Booroomugga,Robinson"
"Booroondara,Yanda" "Booroondarra,Robinson" "Booroorban,Townsend" "Boorowa,King" "Bootawa,Gloucester" "Booth,Mouramba" "Bootheragandra,Nicholson" "Boothingalla,Livingstone" "Boothumble,Blaxland" "Bootoowa,Dowling" "Bootra,Ularara" "Booyamurna,Bligh" "Bora,Arrawatta" "Borah,Darling" "Borah,Finch" "Borah,White" "Boraig,Buccleuch" "Boral,White" "Borambil,Bligh" "Borambil,Buckland"
"Borambula,Wynyard" "Boranel,Gloucester" "Borapine,Dowling" "Border,Delalah" "Border,Farnell" "Boree,Canbelego" "Boree,Clarendon" "Boree,Flinders" "Boree,Townsend" "Boree,Windeyer" "Boree Cabonne,Ashburnham" "Boree Creek,Urana" "Boree Nyrang,Ashburnham" "Boreegerry,Urana" "Borenore,Wellington" "Borgara,Leichhardt" "Borimbadal,St Vincent" "Borinde,Darling" "Boro,Argyle" "Boro,Oxley"
"Boronga,Benarba" "Boroo,Benarba" "Borrina,Fitzgerald" "Bostobrick,Fitzroy" "Boston,Lincoln" "Botany,Cumberland" "Botfields,Cunningham" "Bothadoola,Gunderbooka" "Botobolar,Phillip" "Bouka Bouka,Clyde" "Boulka,Evelyn" "Boulton,Vernon" "Bourbah,Culgoa" "Bourbah,Ewenmar" "Bourbah,Gregory" "Bourinawarrina,Cowper" "Bourke,Argyle" "Bourke,Bourke" "Bourke,Cooper" "Bourke,Cowper"
"Bournda,Auckland" "Bouverie,Westmoreland" "Bouyaree,Nicholson" "Bowan,Ashburnham" "Bowen,Cook" "Bowen,Tara" "Bowerabine,Nicholson" "Bowman,Arrawatta" "Bowman,Bligh" "Bowman,Courallie" "Bowna,Goulburn" "Bowna,Townsend" "Bowning,Harden" "Bowra,Raleigh" "Boyanga,Benarba" "Boyanga,Burnett" "Boyben,Gowen" "Boyd,Auckland" "Boyd,Boyd" "Boyd,Forbes"
"Boyd,Gough" "Boyd,Gresham" "Boyd,Wakool" "Boyeo,Townsend" "Boyle,St Vincent" "Boyne,St Vincent" "Boyong,Gunderbooka" "Boyong,Waradgery" "Braalghy,Kennedy" "Bracebridge,Bathurst" "Bradley,Wallace" "Bragla,Narran" "Braidwood,St Vincent" "Brainerd,Livingstone" "Braltchee,Narran" "Bramah,King" "Bramina,Buccleuch" "Brandis,Gunderbooka" "Branga,Vernon" "Brangalgan,Bourke"
"Bransby,Beresford" "Branxton,Northumberland" "Brassbutt,Waljeers" "Brassey,Vernon" "Brassi,Townsend" "Braulin,Forbes" "Brawboy,Brisbane" "Bray,Yancowinna" "Braylesford,Gresham" "Breadalbane,Argyle" "Bredbendoura,Auckland" "Bredbo,Beresford" "Breelong,Ewenmar" "Breelong,Gowen" "Breelong,Lincoln" "Breelong South,Lincoln" "Breeza,Pottinger" "Brenda,Culgoa" "Brennan,Pottinger" "Brentry,Nandewar"
"Brest,Beresford" "Brewan,Leichhardt" "Brewang,Wentworth" "Brewarrena,Mitchell" "Brewarrina,Clyde" "Brewer,Dowling" "Briarie,Clyde" "Bribaree,Bland" "Bribaree,Monteagle" "Briery,Narran" "Brigalow,Benarba" "Brigalow,Jamison" "Brigalow,Pottinger" "Brigalow,White" "Bright,Yanda" "Brigstocke,Mouramba" "Brindibella,Cowley" "Bringagee,Sturt" "Bringan,Cooper" "Bringellet,Bathurst"
"Bringelly,Cumberland" "Bringenbrong,Selwyn" "Broadmeadows,Gresham" "Broadwater,Rous" "Brobenah,Cooper" "Brock,Hawes" "Brocklesby,Hume" "Brogheda,Brisbane" "Brogo,Auckland" "Broke,Northumberland" "Broken Bay,Cumberland" "Brolga,Culgoa" "Brolga,Gipps" "Brolgan,Ashburnham" "Bronte,Auckland" "Bronte,Durham" "Brooke,Taila" "Brookong,Urana" "Brookong,Yanda" "Brookong North,Urana"
"Broombee,Wellington" "Broome,Urana" "Brotheroney,Dowling" "Brothers,Pottinger" "Brougham,Durham" "Brougham,Mossgiel" "Brougham,Woore" "Brougham,Young" "Broughton,Camden" "Broughton,Durham" "Broughton,Evelyn" "Broughton,Young" "Broula,Forbes" "Broulee,St Vincent" "Brown,Clarke" "Brown,Pottinger" "Browne,Denham" "Browne,Stapylton" "Bruah,Lincoln" "Bruce,Narran"
"Bruce,St Vincent" "Bruinbun,Roxburgh" "Brundah,Monteagle" "Brungle,Buccleuch" "Brunker,Farnell" "Brunker,Livingstone" "Brunswick,Rous" "Brush,Waradgery" "Bryanungra,Stapylton" "Brymedura,Ashburnham" "Brymur,Bland" "Buangla,St Vincent" "Bubalahla,Georgiana" "Bubbogullion,Inglis" "Buccambone,Cowper" "Buccarumbi,Gresham" "Buccleuch,Selwyn" "Buchanan,Hardinge" "Buchanan,Leichhardt" "Buckalow,Menindee"
"Buckalow,Windeyer" "Buckalow East,Menindee" "Buckalow West,Menindee" "Buckambool,Mouramba" "Buckambool,Robinson" "Buckargingah,Hume" "Buckenbowra,St Vincent" "Buckenderra,Wallace" "Buckinbah,Gordon" "Buckinbe,Rankin" "Buckinbong,Mitchell" "Buckinguy,Clyde" "Buckinguy,Gregory" "Buckle,Auckland" "Buckley,Arrawatta" "Buckley,Blaxland" "Buckley,Sturt" "Bucknel,Benarba" "Buckonyong,Waljeers" "Buckra Bendinni,Raleigh"
"Buckwaroon,Robinson" "Buckwaroon,Yanda" "Bucumba,Georgiana" "Budawang,St Vincent" "Budda,Rankin" "Buddabadah,Oxley" "Buddah,Finch" "Buddah,Narromine" "Budden,Phillip" "Buddigower,Bourke" "Buddong,Selwyn" "Budgee,Waradgery" "Budgeon,Leichhardt" "Budgerie,Caira" "Budgery,Flinders" "Budtha,Flinders" "Bugabada,Ewenmar" "Bugaldie,Baradine" "Buggee,Finch" "Bugilbone,Denham"
"Bugindear,Narran" "Bugong,Camden" "Bukkulla,Arrawatta" "Bukkulla,Finch" "Bulahdelah,Gloucester" "Bulalgee,Wynyard" "Bulbodney,Kennedy" "Bulbodny,Flinders" "Bulee,St Vincent" "Buleek,Narran" "Bulga,Bligh" "Bulga,Flinders" "Bulga,Hunter" "Bulga,Macquarie" "Bulga,Pottinger" "Bulgah,Leichhardt" "Bulgala,Gregory" "Bulgan,Clarendon" "Bulgandramine,Narromine" "Bulgandry,Hume"
"Bulgarbugerygam,Waljeers" "Bulgarra,White" "Bulgarres,Westmoreland" "Bulgary,Mitchell" "Bulgeraga,Gregory" "Bulgo,Cumberland" "Bulgogar,Leichhardt" "Bulgoo,Booroondarra" "Bulgoo,Robinson" "Bulgundara,Wallace" "Bulgundramine,Beresford" "Bulgura,Nicholson" "Bull Plain,Denison" "Bulla,Woore" "Bulla Bulla,Rankin" "Bulladoran,Lincoln" "Bullagreen,Ewenmar" "Bullala,Burnett" "Bullamunta,Gunderbooka" "Bullanamang,Beresford"
"Bullanmong,Wentworth" "Bullarora,Leichhardt" "Bullatella,Townsend" "Bullawa,Nandewar" "Bullberry,Woore" "Bullenbalong,Wallace" "Bullenbung,Mitchell" "Buller,Buller" "Bullerana,Courallie" "Bullerawa,Baradine" "Bullia,Evelyn" "Bullimball,Parry" "Bullinda,Lincoln" "Bullinda,Napier" "Bullio,Camden" "Bulliwy,Baradine" "Bullogal,Waljeers" "Bullongong,Murray" "Bulloo,Delalah" "Bulpunga,Tara"
"Bulubula,Wentworth" "Bulyeroi,Jamison" "Bumbaldry,Flinders" "Bumbaldry,Monteagle" "Bumballa,Camden" "Bumbalong,Cowley" "Bumberra,Phillip" "Bumberry,Ashburnham" "Bumble,Courallie" "Bumble,Finch" "Bumbo,Dampier" "Bumbo West,Dampier" "Bummaroo,Georgiana" "Bunal,Arrawatta" "Bunarba,Benarba" "Bunberra,Camden" "Bunchie,Taila" "Bunda,Nicholson" "Bunda East,Nicholson" "Bunda North,Nicholson"
"Bundabarrina,Finch" "Bundabulla,Narran" "Bundaburra,Cunningham" "Bundaburrah,Forbes" "Bundah,Finch" "Bundaleear,Culgoa" "Bundaline,Yanda" "Bundamutta,Mossgiel" "Bundanoon,Camden" "Bundar,Gough" "Bundarbo,Buccleuch" "Bundarra,Darling" "Bundarra,Hardinge" "Bundawarrah,Bland" "Bundella,Pottinger" "Bundemar,Ewenmar" "Bundidgerry,Cooper" "Bundijoe,Ewenmar" "Bundill,Baradine" "Bundilla,Ewenmar"
"Bundobering,Ewenmar" "Bundock,Richmond" "Bundoowithidie,Courallie" "Bundori,Benarba" "Bundunglong,Franklin" "Bundure,Blaxland" "Bundure,Urana" "Bundure North,Urana" "Bundure South,Blaxland" "Bundyulumblah,Wakool" "Bungaba,Bligh" "Bungabah,Napier" "Bungabbee,Rous" "Bungadool,Killara" "Bungalong,Monteagle" "Bungambil,Bourke" "Bunganbil,Cooper" "Bungarby,Wellesley" "Bungaroo,Young" "Bungarry,Waljeers"
"Bungawalbin,Richmond" "Bungee,Wellesley" "Bungey,Ewenmar" "Bunghill,Finch" "Bungiebomar,Lincoln" "Bungle Gully,Baradine" "Bunglega,Cowper" "Bungongo,Buccleuch" "Bungonia,Argyle" "Bungooka,Townsend" "Bungowannah,Hume" "Bungunyah,Wakool" "Bunna,Jamison" "Bunna Bunna,Benarba" "Bunna Bunna,Narran" "Bunnaloo,Cadell" "Bunnawanna,Narran" "Bunneringee,Wentworth" "Buntawarrara,Culgoa" "Buntiara,Barrona"
"Buntiara,Ularara" "Bunton,King" "Bunumburt,Caira" "Bunyah,Jamison" "Bunyan,Beresford" "Bunyip,Narran" "Buona,Yantara" "Buppe,Mouramba" "Buraguy,Wentworth" "Buraja,Hume" "Buramilong,Ewenmar" "Burbagadah,Wakool" "Burbah,Finch" "Burburgate,Nandewar" "Burcarroll,Jamison" "Burdekin,Inglis" "Burdenda,Kennedy" "Bureen,Hunter" "Burgess,Buller" "Burgess,Evelyn"
"Burgess,Farnell" "Burgess,Nicholson" "Burgoon,Gordon" "Burgundy,Arrawatta" "Buriembri,Denham" "Burke,Camden" "Burke,Inglis" "Burke,Mitchell" "Burke,Perry" "Burke,Tandora" "Burkett,Taila" "Burkett North,Manara" "Burnaby,Manara" "Burnayto,Tandora" "Burndoo,Livingstone" "Burnett,Burnett" "Burnima,Wellesley" "Burra,Dampier" "Burra,Flinders" "Burra,Harden"
"Burra,Kennedy" "Burra,Murray" "Burra,Selwyn" "Burrabadine,Narromine" "Burrabebe,Finch" "Burrabijong,Bland" "Burrabogie,Waradgery" "Burraga,Georgiana" "Burragate,Auckland" "Burragillo,Benarba" "Burragong,Dudley" "Burragorang,Camden" "Burragurra,Northumberland" "Burralow,Cook" "Burramunda,Monteagle" "Burran Burran,Finch" "Burranbah,Courallie" "Burrandana,Mitchell" "Burrandoon,Benarba" "Burrandown,Finch"
"Burrangong,Hume" "Burrangong,Monteagle" "Burrawan,Macquarie" "Burrawandool,Finch" "Burrawang,Camden" "Burrawang,Wakool" "Burrawong,Cunningham" "Burrawong,Gordon" "Burrell,Narran" "Burrell,Rous" "Burren,Jamison" "Burren East,Jamison" "Burrendah,Gowen" "Burrendong,Jamison" "Burrendong,Wellington" "Burrenyinah,Mossgiel" "Burridgee,Georgiana" "Burrie,Wentworth" "Burrill,Kennedy" "Burrill,St Vincent"
"Burrimbucco,Wellesley" "Burrinyanni,Mossgiel" "Burroway,Ewenmar" "Burrowoury,Roxburgh" "Burrumbelong,Phillip" "Burrumbury,Cadell" "Burrumbuttock,Hume" "Burry Gurry,Landsborough" "Burt,Boyd" "Burta,Menindee" "Burthong,Blaxland" "Burthong South,Blaxland" "Burton,Cowper" "Burton,Northumberland" "Burtundy,Wentworth" "Busby,Richmond" "Bute,Clarendon" "Butheroo,Napier" "Butherwa,Urana" "Butler,Sandon"
"Butmaroo,Murray" "Butra,Yantara" "Buttabone,Gregory" "Butterleaf,Clive" "Butterwick,Durham" "Byadbo,Wellesley" "Byar,Nandewar" "Byco Birra,Killara" "Bye,Cowper" "Byerawering,Narran" "Bygalorie,Gipps" "Bygoo,Cooper" "Byjerk,Barrona" "Byjerkerno,Farnell" "Bylong,Phillip" "Bymue,Wakool" "Byng,Bathurst" "Byngnano,Mootwingee" "Byong,Cunningham" "Byron,Arrawatta"
"Byron,Mouramba" "Byron,Rous" "Bywong,Murray" "Caaba,Franklin" "Caari,Menindee" "Cabramatta,Cumberland" "Cabramurra,Wallace" "Cabul,Denham" "Cadalgulee,Gipps" "Caddigat,Wallace" "Cadell,Urana" "Cadgee,Dampier" "Cadjangarry,Dampier" "Cadogan,Bathurst" "Cadow,Gipps" "Cagellico,Blaxland" "Cahirnane,Barrona" "Caidmurra,Benarba" "Caigan,Gowen" "Cairncross,Macquarie"
"Cajaldura,Sturt" "Cajildry,Oxley" "Cal Lal,Tara" "Calala,Parry" "Calala,Pottinger" "Calamia,Clarence" "Calathunda,Tongowoko" "Calcoo,Werunda" "Calderwood,Camden" "Caldwell,Cadell" "Caledonia,Lincoln" "Calga,Leichhardt" "Califat,Wynyard" "Callaghan,Beresford" "Callaghan,Parry" "Callangoan,Gowen" "Callanyn,Buller" "Callindra,Killara" "Calmuldi,Finch" "Caloma,Gordon"
"Caloma,Narromine" "Caloola,Cadell" "Caloola,Delalah" "Caloola,Farnell" "Caloola,Mootwingee" "Calpacaira,Killara" "Caltigeenaa,Werunda" "Calvert,Bathurst" "Calytria,Blaxland" "Calytria,Mossgiel" "Calytria South,Mossgiel" "Camarooka,Cooper" "Cambalong,Wellesley" "Cambara,Leichhardt" "Cambellia,Menindee" "Cambellia,Yancowinna" "Cambewarra,Camden" "Cambo Cambo,Finch" "Camden,Camden" "Camden Haven,Macquarie"
"Camelback,Gresham" "Camelot,Perry" "Cameron,Flinders" "Cameron,Hardinge" "Cameron,Mossgiel" "Cameron,Young" "Camira,Richmond" "Campamooka,Landsborough" "Campbell,Arrawatta" "Campbell,Brisbane" "Campbell,Courallie" "Campbell,Farnell" "Campbell,Finch" "Campbell,Gough" "Campbell,Hawes" "Campbell,Leichhardt" "Campbell,Mootwingee" "Campbell,Townsend" "Campbell,Waljeers" "Campbell,Young"
"Canary,Stapylton" "Canbelego,Mouramba" "Canbelego,Robinson" "Candelo,Auckland" "Candole,Clarence" "Cangai,Drake" "Cangan,Wakool" "Caninganima,Nicholson" "Canning,Wellington" "Canobolas,Ashburnham" "Canomodine,Ashburnham" "Canonba,Gregory" "Canonba North,Gregory" "Canoulam,Clarence" "Canowindra,Bathurst" "Canpadore,Yanda" "Caoura,Camden" "Capeen,Buller" "Capel,Murchison" "Capertee,Cook"
"Capertee,Hunter" "Capertee,Roxburgh" "Capoompeta,Clive" "Capp,White" "Carabobala,Goulburn" "Carabost,Goulburn" "Carabost,Wynyard" "Caragabal,Bland" "Caragabal,Gipps" "Caraghnan,Gowen" "Cararbury,Boyd" "Carawandool,Gipps" "Carbeenbri,Benarba" "Carcool,Narran" "Cardington,Gordon" "Careunga,Stapylton" "Careunga North,Stapylton" "Cargelligo,Dowling" "Cargo,Ashburnham" "Carilla,Dowling"
"Carilla,Fitzgerald" "Carilla,Nicholson" "Carinda,Clyde" "Caringy,Taila" "Carisbrook,Dowling" "Carlisle,Mouramba" "Carlisle,Napier" "Carlo,Baradine" "Carlton,Bathurst" "Carlyle,Denison" "Carnbilly,Canbelego" "Carnerney,Urana" "Carngham,Waljeers" "Carnham,Drake" "Caro,Canbelego" "Caroda,Murchison" "Carolina,Kennedy" "Caroonboon,Wakool" "Caroora,Hunter" "Carore,Courallie"
"Carowra,Mossgiel" "Carraa,Benarba" "Carrabear,Leichhardt" "Carrathool,Sturt" "Carrawa,Georgiana" "Carrawabbity,Ashburnham" "Carrego,Sturt" "Carrigan,Ewenmar" "Carrington,Gloucester" "Carrington,Woore" "Carrington,Yancowinna" "Carroboblin,Cunningham" "Carroby,Stapylton" "Carroll,Buckland" "Carroll,Buller" "Carroll,Wellington" "Carroonboon,Townsend" "Carroonboon North,Townsend" "Carrow,Durham" "Carse,Townsend"
"Carter,Mossgiel" "Carual,Oxley" "Carumbi,Bland" "Carwell,Gregory" "Carwell,Leichhardt" "Carwoola,Murray" "Caryapundy,Tongowoko" "Casey,Manara" "Cashmere,Clyde" "Castle Hill,Cumberland" "Castle Sempill,Brisbane" "Castlereagh,Cumberland" "Castlereagh,Leichhardt" "Castlestead,Hume" "Castleton,Roxburgh" "Cataract,Buller" "Cathcart,Wellesley" "Cathcart,Yancowinna" "Cathkin,Woore" "Cathundril,Narromine"
"Cato,Narran" "Catombal,Delalah" "Catombal,Gordon" "Cavan,Cowley" "Cavendish,Clive" "Cavendish,Kennedy" "Cawndilla,Menindee" "Cedia,Culgoa" "Ceelnoy,Baradine" "Cessnock,Northumberland" "Chadwick,Caira" "Chaelundi,Gresham" "Chalmers,Durham" "Chamberlain,Farnell" "Chambers,Waradgery" "Chambigne,Fitzroy" "Champagne,Arrawatta" "Chance,Werunda" "Chandler,Clarke" "Chandler,Gresham"
"Chapman,Arrawatta" "Chapman,Clarence" "Chapman,Hardinge" "Charlemont,Tandora" "Charlemont,Yancowinna" "Charlton,Clyde" "Charlton,Killara" "Charlton,Yungnulgra" "Chaucer,Bathurst" "Chaucer,Mouramba" "Chauvel,Drake" "Cherson,Brisbane" "Chesney,Robinson" "Chigwell,Hardinge" "Childowla,Buccleuch" "Childowla,Harden" "Chillichill,Caira" "Chillingham,Rous" "Chippendale,Wallace" "Chirnside,Nicholson"
"Chirnside,Werunda" "Chnowa,Kilfera" "Chowar,Wakool" "Christie,Denham" "Churchill,Drake" "Churriga,Poole" "Churriga,Tongowoko" "Citgathen,Townsend" "Clandulla,Roxburgh" "Clanricard,Brisbane" "Clapton,Wallace" "Clare,Burnett" "Clare,Hardinge" "Claremont,Cumberland" "Clarence,Buller" "Clarendon,Bathurst" "Clarenza,Clarence" "Claribell,Buller" "Claris,Clarendon" "Clarke,Clarke"
"Clarke,Dudley" "Clarke,Pottinger" "Clarke,Rankin" "Clayton,Young" "Clear Hill,Selwyn" "Clear Hill,Urana" "Clear Ridge,Gipps" "Clear Water,Thoulcanna" "Clements,Clyde" "Clements,Jamison" "Clerk,Hardinge" "Clerkness,Hardinge" "Clermiston,Bourke" "Clevedon,Sandon" "Clifden,Clarence" "Clifford,Beresford" "Clifford,Boyd" "Clifford,Livingstone" "Cliffs,Dudley" "Cliffs,Wentworth"
"Clift,Buckland" "Clift,Pottinger" "Clifton,Clarke" "Clifton,Clive" "Clifton,Gough" "Clifton,Yantara" "Clinton,Bathurst" "Clive,Buccleuch" "Clive,Gough" "Clive,Urana" "Clowery,Dowling" "Clunes,Rous" "Cluny,Waradgery" "Clutha,Franklin" "Clwydd,Cook" "Clybucca,Dudley" "Clyde,St Vincent" "Clyde,Urana" "Clyde,Wallace" "Coaldale,Clarence"
"Coallie,Yantara" "Coally,Evelyn" "Coan,Blaxland" "Coba,Monteagle" "Cobar,Robinson" "Cobb,Hawes" "Cobbadah,Murchison" "Cobbinbil,Gowen" "Cobboco,Ewenmar" "Cobbora,Lincoln" "Cobham,Yantara" "Cobra,Auckland" "Cobrabald,Vernon" "Cobram,Blaxland" "Cobran,Narran" "Cobrauraguy,Lincoln" "Cobrilla,Killara" "Cobrilla,Young" "Cobwell,Wakool" "Cocaboy,White"
"Cochran,Cowley" "Cochrane,Vernon" "Cockburn,Sturt" "Cockellireena,Culgoa" "Cockerminia,Cowper" "Cocketgedong,Urana" "Cockran,Wakool" "Cockulby,Yantara" "Coco,Roxburgh" "Cocomingla,Monteagle" "Cocoparra,Cooper" "Codrington,Burnett" "Coeypolly,Buckland" "Coff,Fitzroy" "Coffin Rock,Mitchell" "Coggan,Phillip" "Coghill,St Vincent" "Coghill,White" "Cogie,Mossgiel" "Cogo,Macquarie"
"Cohn,Robinson" "Colaine,Thoulcanna" "Colane,Gregory" "Colaragang,Cooper" "Colchester,Cooper" "Coldstream,Clarence" "Cole,Bathurst" "Coleambally,Boyd" "Coleridge,Bathurst" "Colimo,Townsend" "Colinton,Beresford" "Colkmannan,Urana" "Collarindabri,Finch" "Collaroy,Bligh" "Collector,Argyle" "Collemburrawang,Ewenmar" "Collendina,Hume" "Collett,Ashburnham" "Collie,Ewenmar" "Collieblue,Bligh"
"Collier,Bligh" "Collinouie,Leichhardt" "Collombatti,Dudley" "Collyburl,Gregory" "Collymongle,Benarba" "Collyu,Benarba" "Collywarry,Narran" "Colmia,Leichhardt" "Colo,Camden" "Colo,Cook" "Colo,Hunter" "Colombo,Auckland" "Colombo,Urana" "Colomy,Leichhardt" "Colong,Westmoreland" "Colongon,Buller" "Colonna,Durham" "Colville,Bathurst" "Colvin,Wakool" "Comara,Dudley"
"Comarto,Young" "Combadelo,Courallie" "Combadery,Finch" "Combaning,Bland" "Combermere,Urana" "Comboyne,Macquarie" "Comer,Hume" "Comiala,Phillip" "Comlaroi,Fitzroy" "Conapaira,Cooper" "Conapaira East,Cooper" "Conapaira South,Cooper" "Conargo,Townsend" "Concord,Cumberland" "Concord,Narran" "Condobolin,Cunningham" "Condon,Flinders" "Condong,Rous" "Condoulpe,Wakool" "Congarinni,Raleigh"
"Congera,Monteagle" "Congewai,Northumberland" "Congi,Inglis" "Congo,Dampier" "Congou,Bland" "Congrou,Booroondarra" "Conimbia,Leichhardt" "Conimbla,Forbes" "Conjola,St Vincent" "Connargee,Wentworth" "Connibong,Ewenmar" "Connor,Nandewar" "Connulpie,Delalah" "Connulpie,Livingstone" "Connulpie,Tongowoko" "Conoble,Mossgiel" "Conolly,Livingstone" "Conolly,Windeyer" "Conroy,Irrara" "Contarlo,Dowling"
"Cooba,Clarendon" "Cooba,Cook" "Coobah,Narran" "Coobeinda,Narran" "Coobool,Wakool" "Coobung,Narran" "Coocook,Goulburn" "Coocoran,Finch" "Cooeyah Warrah,Leichhardt" "Coogal,Pottinger" "Coogarah,Finch" "Cook,Benarba" "Cook,Cook" "Cook,Cumberland" "Cook,Farnell" "Cook,Hunter" "Cook,Stapylton" "Cook,White" "Cookabingie,Napier" "Cookaburragong,Gipps"
"Cookadini,Yanda" "Cookamidgera,Ashburnham" "Cookamilerie,Booroondarra" "Cookandoon,Oxley" "Cookardinia,Goulburn" "Cookbundoon,Argyle" "Cookenmabourne,Mossgiel" "Cookeys Plains,Cunningham" "Cookopie,Kennedy" "Coolac,Harden" "Coolagali,Townsend" "Coolah,Napier" "Coolamatong,Wallace" "Coolambil,Townsend" "Coolamigal,Roxburgh" "Coolamin,Northumberland" "Coolamin,Wellington" "Coolamon,Bourke" "Coolamon,Gunderbooka" "Coolanbilla,Pottinger"
"Coolanga,Stapylton" "Coolangatta,Camden" "Coolangoola,Baradine" "Coolangubra,Auckland" "Coolaree,Clyde" "Coolatai,Burnett" "Coolbaggie,Ewenmar" "Coolbaggie,Lincoln" "Coolcalwin,Phillip" "Coolcumba,Hawes" "Coolegong,Monteagle" "Cooleman,Buccleuch" "Cooleman,Cowley" "Coolena,Taila" "Coolga,Jamison" "Coolibah,Booroondarra" "Coolibah,Flinders" "Coolibar,Cowper" "Coolibar,Culgoa" "Coolmara,Werunda"
"Coolongolook,Gloucester" "Cooloobong,Benarba" "Coolpooka,Landsborough" "Coolringdon,Beresford" "Coolumbooka,Wellesley" "Coolumburra,St Vincent" "Cooma,Beresford" "Cooma,White" "Coomassie,Cook" "Coombadjha,Drake" "Coombah,Windeyer" "Coombarra,Yancowinna" "Coombell,Richmond" "Coombes,Rankin" "Coombie,Mossgiel" "Coomoo Coomoo,Pottinger" "Coomore,Baradine" "Coomore South,Baradine" "Coonabarabran,Gowen" "Coonalgra,Benarba"
"Coonalhugga,Menindee" "Coonamble,Leichhardt" "Coonambro,Ashburnham" "Coonamit,Wakool" "Coonamoona,Leichhardt" "Coonartha,Manara" "Coonavittra,Werunda" "Coonbaralba,Farnell" "Coonbaralba,Hunter" "Coonbaralla,Yancowinna" "Coonbilly,Irrara" "Cooncoonburra,Caira" "Coondella,Dampier" "Cooney,Harden" "Cooney,Sandon" "Coongbar,Drake" "Coonghan,Narran" "Coonhoonbula,Wallace" "Cooning,Gunderbooka" "Coonong,Landsborough"
"Coonong,Perry" "Coonong,Urana" "Coonoolcra,Werunda" "Coonoon,Waradgery" "Coonpa,Wentworth" "Coonumberto,Robinson" "Coopayandra,Evelyn" "Cooper,Baradine" "Cooper,Gunderbooka" "Cooper,Hardinge" "Cooper,Wellesley" "Cooper,Wellington" "Cooplacurripa,Hawes" "Coorabur,Clyde" "Cooraldooral,Drake" "Coorallie,Barrona" "Cooridoon,Buckland" "Coorilla,Cowper" "Coormore,White" "Coorong,Jamison"
"Coorongooba,Hunter" "Cooroobongatti,Dudley" "Cooruba,Woore" "Coorumbung,Northumberland" "Coota,Bathurst" "Cootamundra,Harden" "Cootawundy,Yungnulgra" "Cootnite,Wakool" "Cootralantra,Wallace" "Coowerrawine,Nicholson" "Cooyal,Phillip" "Cooyarunda,Perry" "Copar,Wentworth" "Cope,Bligh" "Cope,Fitzroy" "Cope,Yungnulgra" "Copes Creek,Hardinge" "Copmanhurst,Clarence" "Coppabella,Goulburn" "Coppabella,Harden"
"Copper Hill,Wellington" "Copperhannia,Georgiana" "Coppymurrumbill,Stapylton" "Coradgerie,Ewenmar" "Coradgery,Kennedy" "Coradgery West,Kennedy" "Coraki,Rous" "Corang,St Vincent" "Cordeaux,Camden" "Coree,Blaxland" "Coree,Cowley" "Coree,Mouramba" "Coree North,Urana" "Coree South,Urana" "Coreen,Canbelego" "Coreen West,Denison" "Corega,Young" "Coreinbob,Wynyard" "Corella,Culgoa" "Corella,Cunningham"
"Coricudgy,Hunter" "Corindi,Fitzroy" "Cornalla,Townsend" "Cornelia,Cumberland" "Corobimilla,Mitchell" "Coromerry,Young" "Corona,Farnell" "Corona,Finch" "Coronga,Cowper" "Coronga,Robinson" "Corowa,Hume" "Corrabare,Northumberland" "Corridgery,Cunningham" "Corringle,Gipps" "Corriwelpie,Delalah" "Corrong,Waljeers" "Corrowong,Wellesley" "Corry,Buller" "Corry,Wakool" "Coryah,Nandewar"
"Cosgrove,Beresford" "Cosgrove,Northumberland" "Cottadidda,Denison" "Cottee,Bourke" "Couatwong,Hawes" "Coubal,Benarba" "Cougal,Rous" "Coulson,Brisbane" "Coultra,Menindee" "Countegany,Dampier" "Courabyra,Wynyard" "Courallie,Gunderbooka" "Courebone,Canbelego" "Couridjah,Camden" "Coutts,Buller" "Covan,Argyle" "Coveney,Livingstone" "Coventry,Clarke" "Cowabbie,Bourke" "Cowabee,Clyde"
"Cowal,Clyde" "Cowal,Gipps" "Cowal,Narromine" "Cowallah,White" "Cowan,Cumberland" "Cowan,Gresham" "Cowan,Northumberland" "Cowangara,Macquarie" "Coward,Culgoa" "Cowary,Livingstone" "Cowary,Werunda" "Cowcumbala,Harden" "Coweambah,Gloucester" "Cowelba,Finch" "Cowga,Clyde" "Cowga,Narran" "Cowimangarah,Jamison" "Cowl,Booroondarra" "Cowl,Wentworth" "Cowmerton,Benarba"
"Cowper,Clive" "Cowra,Bathurst" "Cowra,Selwyn" "Cowrajago,Buccleuch" "Cox,Arrawatta" "Cox,Baradine" "Cox,Burnett" "Cox,Clyde" "Cox,Cook" "Cox,Mitchell" "Cox,White" "Coyurunda,Mootwingee" "Crackenback,Wallace" "Cranbourne,Brisbane" "Cranbrook,Narran" "Craven,Gloucester" "Craven,Selwyn" "Crawley,Murchison" "Crawney,Brisbane" "Crawney,Parry"
"Creamy Hills,Blaxland" "Creewah,Wellesley" "Creighton,Hume" "Cremorne,Oxley" "Crete,Westmoreland" "Crinoline,Benarba" "Crokee,Caira" "Crommelin,Urana" "Cromwell,Buccleuch" "Croobyar,St Vincent" "Crookwell,King" "Croombimbie,Ularara" "Crosbie,Gloucester" "Crosby,King" "Crowie,Flinders" "Crowie,White" "Crowl,Mouramba" "Crown Camp,Gipps" "Crozier,Tara" "Crudine,Roxburgh"
"Cryon,Denham" "Cuba,Cooper" "Cuba,Waradgery" "Cubbaroo,Jamison" "Cubbaroo North,Jamison" "Cubbo,Baradine" "Cuckaroo,Booroondarra" "Cucumber,Arrawatta" "Cudal,Ashburnham" "Cuddell,Mitchell" "Cuddie,Clyde" "Cuddyong,Georgiana" "Cudgel,Cooper" "Cudgelong,Forbes" "Cudgen,Rous" "Cudgildool,Benarba" "Cudgymaguntry,Monteagle" "Cudjello,Cooper" "Cudmirrah,St Vincent" "Cudmore,Wentworth"
"Cudoc,Townsend" "Cuerindi,Darling" "Culingerai,Bland" "Cullamulcha,Delalah" "Cullarin,King" "Cullen,Gordon" "Cullen Bullen,Roxburgh" "Cullendore,Buller" "Cullinga,Harden" "Cullivel,Urana" "Cullulla,Argyle" "Culnooy,Baradine" "Culparling,Waljeers" "Culpataro,Waljeers" "Culpaterong,Kilfera" "Culpaulin,Livingstone" "Culpaulin,Young" "Cultee,Farnell" "Cultogerie,Booroondarra" "Cultowa,Werunda"
"Cumbamurra,Harden" "Cumbedore,Yanda" "Cumberdoon,Baradine" "Cumbertine,Camden" "Cumbijowa,Forbes" "Cumbil,Baradine" "Cumbine,Flinders" "Cumble,Ashburnham" "Cumblegubinbah,Narran" "Cumbo,Phillip" "Cumbooka,Gunderbooka" "Cumborah,Finch" "Cumboroona,Goulburn" "Cummings,Wellington" "Cundle,Macquarie" "Cunellie,Fitzgerald" "Cunglebung,Gresham" "Cunjegong,Harden" "Cunna,Bligh" "Cunnawarra,Clarke"
"Cunnianna,Finch" "Cunningar,Harden" "Cunningdroo,Wynyard" "Cunningham,Harden" "Cunningham,Wellington" "Cunninyeuk,Wakool" "Cuppacumbalong,Cowley" "Curlewis,Pottinger" "Curmulee,Dampier" "Curnoo,Wentworth" "Curra,Gordon" "Currabenya,Thoulcanna" "Currabubula,Buckland" "Currabunganung,Townsend" "Curraburrama,Bland" "Curracabundi,Hawes" "Curragh,Barrona" "Curragurra,Wellington" "Currah,Benarba" "Currah,Gipps"
"Currajong,Ashburnham" "Currajong,Flinders" "Currajong,Goulburn" "Currall,Finch" "Currambene,Dampier" "Currambene,St Vincent" "Currandooly,Murray" "Currangandi,Murchison" "Curranyale,Livingstone" "Curranyale,Werunda" "Currawallah,Blaxland" "Currawananna,Bourke" "Currawang,Argyle" "Currawong,Canbelego" "Currawong,Dowling" "Currawong,Harden" "Currawynnia,Cowper" "Curreeki,Gloucester" "Currency,Cook" "Curriba,Dowling"
"Curricabark,Hawes" "Currikabakh,Dowling" "Currindule,Culgoa" "Currock,St Vincent" "Currotha,Benarba" "Currowan,St Vincent" "Currowong,Forbes" "Currpool,Wakool" "Currumbah,Stapylton" "Curryall,Bligh" "Currygundi,Benarba" "Curtis,Oxley" "Curumbenya,Ashburnham" "Cuthero,Windeyer" "Cuthowara,Young" "Cuttabulla,Culgoa" "Cuttabulloo,Gowen" "Cuttagullyaroo,Robinson" "Cyclops,Westmoreland" "Dabee,Phillip"
"Dahomey,Leichhardt" "Dahwilly,Townsend" "Dalby,Cowper" "Dale,Clarke" "Daley,Lincoln" "Dalglish,Napier" "Dalglish,Young" "Dallas,Cooper" "Dalmorton,Gresham" "Dalton,King" "Dalton,Northumberland" "Dampier,White" "Dananbilla,Monteagle" "Danberry,Wakool" "Dandahra,Drake" "Dandaloo,Kennedy" "Dandaloo,Narromine" "Dandry,Baradine" "Dangar,Baradine" "Dangar,Benarba"
"Dangar,Brisbane" "Dangar,Jamison" "Dangar,White" "Dangarsleigh,Sandon" "Dangelong,Beresford" "Danglemah,Inglis" "Danjera,St Vincent" "Dapper,Lincoln" "Daraaba,Finch" "Darbalara,Buccleuch" "Darby,Hardinge" "Darbysleigh,Hardinge" "Darchy,Perry" "Darcoola,Waradgery" "Dargals,Selwyn" "Dargle,Barrona" "Darke,Richmond" "Darling,Culgoa" "Darling,Darling" "Darling,Gunderbooka"
"Darling,Rankin" "Darling,Wentworth" "Darling,Yanda" "Darling,Young" "Darlington,Durham" "Darlot,Wakool" "Darnick,Manara" "Darouble,Oxley" "Darwin,Manara" "Daubeny,Young" "Daubeny,Yungnulgra" "Davidson,Bourke" "Davidson,Cowper" "Davidson,Sandon" "Davies,Robinson" "Davis,Dowling" "Davis,Thoulcanna" "Davison,Kennedy" "Davison,Thoulcanna" "Davy,Caira"
"Dawes,Yungnulgra" "Dawson,Macquarie" "Day,Clarke" "Dealwarraldi,Jamison" "Dean,Wentworth" "Debenham,Macquarie" "Dederang,Cowper" "Deepwater,Gough" "Delalah,Delalah" "Delalah South,Delalah" "Delatite,Cowper" "Delby,Flinders" "Delegate,Wellesley" "Delingera,Murchison" "Delta,Landsborough" "Delungra,Murchison" "Demondrille,Harden" "Dendrobium,Camden" "Denebry,Stapylton" "Denevoli,Baradine"
"Denham,Denham" "Denham,Jamison" "Deniehy,Rankin" "Denison,Denison" "Denison,Pottinger" "Denison,Raleigh" "Denison,Tara" "Denison West,Pottinger" "Denman,Brisbane" "Denman,Narran" "Denne,Vernon" "Denny,Sturt" "Denobollie,White" "Denuleroi,Denham" "Denver,Buckland" "Derale,Phillip" "Deriah,Nandewar" "Deribong,Narromine" "Dering,Farnell" "Deringulla,Gowen"
"Derinum,Caira" "Deripas,Finch" "Deriringa,Ularara" "Derra,Benarba" "Derra Derra,Murchison" "Derri Derri,Clyde" "Derribong,Kennedy" "Derrina,Yanda" "Derringullen,King" "Derriwong,Cunningham" "Derrulaman,Townsend" "Derry,Bourke" "Desailly,Young" "Deua,Dampier" "Devlin,Bourke" "Devon,Killara" "Devon,Leichhardt" "Devon,Mouramba" "Devon,Sandon" "Devon,Townsend"
"Dewar,Lincoln" "Dewhurst,Denham" "Dewhurst,Jamison" "Dewhurst,White" "Dewitt,Hawes" "Dhoon,Yancowinna" "Dickens,Young" "Dickenson,Narran" "Dickson,Clive" "Diehard,Gough" "Diemunga,Culgoa" "Digby,Pottinger" "Dight,Arrawatta" "Dight,Buckland" "Dijoe,Cowper" "Dilga,Gordon" "Dilkoosha,Killara" "Dilkoosha,Yungnulgra" "Dilly,Gowen" "Dimboola,Waljeers"
"Dinawirindi,Darling" "Dindierna,Benarba" "Dinga Dingi,Bland" "Dingle,Raleigh" "Dingo,Culgoa" "Dingo,Murchison" "Dinoa,Leichhardt" "Dinoga,Murchison" "Dinwoodie,Tara" "Direlmabildi,Benarba" "Ditmas,Gough" "Dixon,King" "Djallah,Sturt" "Dobie,Richmond" "Dobikin,Jamison" "Dolondundale,Dampier" "Dolora,Killara" "Donald,Cowper" "Donald,Sandon" "Donald,Werunda"
"Donald Plain,Rankin" "Donaldson,Buller" "Donaldson,Clive" "Donaldson,Mouramba" "Donaldson,Richmond" "Donalroe,Rankin" "Donelly,Lincoln" "Donnelly,Mootwingee" "Donovan,Dampier" "Doon,Durham" "Doon,Menindee" "Doona,Pottinger" "Doonside,Narromine" "Doorabeeba,Benarba" "Dooral,Clyde" "Dooran,Oxley" "Dootheboy,Yanda" "Dora,Northumberland" "Dora Dora,Goulburn" "Doradilla,Cowper"
"Doubleduke,Clarence" "Doubleduke,Richmond" "Doughboy,Clarke" "Douglas,Harden" "Douglas,Urana" "Doulagunmala,Bligh" "Douro,Stapylton" "Dow,Boyd" "Dowe,Darling" "Dowling,Ashburnham" "Dowling,Cooper" "Dowling,Dowling" "Dowling,Mouramba" "Dowling,Waradgery" "Downey,Sturt" "Downs,Courallie" "Downs,Delalah" "Doyle,Baradine" "Doyle,Hunter" "Doyle,Jamison"
"Draggy,Narromine" "Drake,Drake" "Draway,Gordon" "Dreewa,Gregory" "Driel,Ewenmar" "Drildool,Jamison" "Drillwarrina,Ewenmar" "Drogheda,Westmoreland" "Dromore,Livingstone" "Drouin,Cowper" "Druid,Clyde" "Drumdelang,Narran" "Drummond,Hardinge" "Drummond,Murchison" "Drumston,Bourke" "Dry Forest,Denison" "Dry Lake,Young" "Dryburgh,Gregory" "Dryden,Mouramba" "Drysdale,Townsend"
"Dubbleda,Pottinger" "Dubbo,Baradine" "Dubbo,Gordon" "Dubbo,Lincoln" "Duckan Duckan,Fitzroy" "Duckhole,Courallie" "Duckmaloi,Westmoreland" "Dudauman,Bland" "Duderbang,Boyd" "Dudley,Dudley" "Dudley,Raleigh" "Duffity,Gregory" "Dulabree,Roxburgh" "Dulah,Bourke" "Dulhunty,Cunningham" "Dulladerry,Ashburnham" "Dulverton,Townsend" "Dumaresq,Arrawatta" "Dumaresq,Clive" "Dumaresq,Gough"
"Dumaresq,Sandon" "Dumboy,Murchison" "Dunbar,Drake" "Dunbible,Rous" "Duncan,Beresford" "Dundaga,Ularara" "Dundoo,Clarence" "Dundunga,Benarba" "Dunedoo,Lincoln" "Dungalear,Finch" "Dungarvan,Irrara" "Dungary,Narromine" "Dungell,Finch" "Dungeree,Phillip" "Dungog,Durham" "Dungowan,Parry" "Dunkeld,Townsend" "Dunleary,Bathurst" "Dunlop,Landsborough" "Dunlop,Yanda"
"Dunnee,Murchison" "Dunoon,Rous" "Dunoon,Werunda" "Dunstan,Mouramba" "Dunumbral,Finch" "Dunwerian,Baradine" "Durabeba,Finch" "Duramana,Roxburgh" "Durham,Murchison" "Durran Durra,St Vincent" "Durridgere,Bligh" "Durrisdeer,Nandewar" "Dutzon,Wynyard" "Duval,Sandon" "Dwight,Irrara" "Dwyer,Cowper" "Dyke,Clarke" "Dynong,Gregory" "Dyraaba,Rous" "Dyrring,Durham"
"Eales,Burnett" "Eales,Finch" "East Bourke,Cowper" "East Casino,Richmond" "East Gilgunnia,Blaxland" "East Goodradigbee,Cowley" "East Gundurimba,Rous" "East Marowie,Nicholson" "East Nelligen,St Vincent" "East Waradgery,Waradgery" "East Yetman,Arrawatta" "Eastern Water,Clive" "Eastlake,Denham" "Eastlake,Sandon" "Eaton,Clarence" "Eckerboon,Tandora" "Eckersley,Cumberland" "Eckford,Finch" "Eckford,Jamison" "Eden,Auckland"
"Eden,Gough" "Eden Forest,Argyle" "Edenhope,Cowper" "Edgar,Townsend" "Edgar,Yancowinna" "Edgehill,Mitchell" "Edgeroi,Cowper" "Edgeroi,Jamison" "Edgeroi,Leichhardt" "Edinburgh,Ashburnham" "Edon,Cooper" "Eeramaran,Blaxland" "Effluence,Barrona" "Effluence,Irrara" "Egbert,Bathurst" "Egelabra,Oxley" "Egeria,Flinders" "Egerton,Arrawatta" "Eglington,Northumberland" "Eildon,Manara"
"Eildon,Mossgiel" "Eilginbah,Boyd" "Eilginbah,Oxley" "Eiraban,Ewenmar" "Elder,Yungnulgra" "Elderbury,Hardinge" "Eldon,Gloucester" "Elengerah,Oxley" "Eli Elwah,Waradgery" "Elie,Mossgiel" "Ella,Vernon" "Ellalong,Northumberland" "Elland,Clarence" "Ellangowan,Richmond" "Ellenborough,Macquarie" "Ellenden,Murray" "Ellerslie,Buller" "Ellerslie,Cunningham" "Ellerslie,Mouramba" "Ellerslie,Windeyer"
"Ellerslie,Wynyard" "Ellerston,Brisbane" "Elliott,Bourke" "Elliott,Nicholson" "Ellis,Arrawatta" "Ellis,Brisbane" "Ellis,Burnett" "Ellis,Courallie" "Ellis,Leichhardt" "Ellis,Mouramba" "Ellisland,Waljeers" "Ellon,Bourke" "Elong Elong,Lincoln" "Elongery,Leichhardt" "Elphinstone,Finch" "Elrington,St Vincent" "Elsinora,Delalah" "Elsmore,Cunningham" "Elsmore,Gough" "Elti,Yancowinna"
"Elton,Sandon" "Elutha,Yanda" "Embagga,Franklin" "Embie,Gregory" "Emerald,Woore" "Emogandry,Ewenmar" "Emu,Buller" "Emu,Ewenmar" "Emu,Vernon" "Emu,Wentworth" "Emu,Yanda" "Emu Hill,Culgoa" "Emu Plains,Cunningham" "Ena,Arrawatta" "Enaweena,Gregory" "Endrick,St Vincent" "Enerweena,Narromine" "Enfield,Vernon" "Enid,Perry" "Enmore,Menindee"
"Enmore,Narromine" "Enmore,Sandon" "Enmore,Yancowinna" "Enngonia,Culgoa" "Erasa,Forbes" "Ercildoune,Sturt" "Eribendery,Blaxland" "Erimeran,Mouramba" "Eringanerin,Gowen" "Ermington,Fitzroy" "Ernoo,Yungnulgra" "Erreman,Windeyer" "Errol,Bathurst" "Erskine,Lincoln" "Erudgere,Wellington" "Esk,Richmond" "Eskdale,Roxburgh" "Esperance,Clyde" "Essie,Evelyn" "Ethelberg,Clyde"
"Eton,Canbelego" "Eton,Denham" "Etoo,Baradine" "Ettrema,St Vincent" "Ettrick,Rous" "Etty,Rankin" "Euabalong,Blaxland" "Euadera,Wynyard" "Eualdrie,Forbes" "Eubindal,Harden" "Euchabil,Kennedy" "Euchara,Booroondarra" "Euchla,Perry" "Eucumbene,Wallace" "Euglo,Gipps" "Euglo South,Gipps" "Eugowra,Ashburnham" "Eula,Gregory" "Eulah,Leichhardt" "Eulah,Nandewar"
"Eulamoga,Gregory" "Eulan,Finch" "Euligal,Baradine" "Eulo,Boyd" "Eulowrie,Murchison" "Euminbah,Finch" "Eumungerie,Ewenmar" "Eumur,Darling" "Eunanbrennan,Boyd" "Eunanoreenya,Clarendon" "Euola,Killara" "Eura,Ewenmar" "Eurabba,Bland" "Euratha,Cooper" "Euratha South,Cooper" "Eurawin,Finch" "Eurella,Nicholson" "Eurie Eurie,Denham" "Eurilla,Tara" "Eurimbula,Gordon"
"Euringilly,Clarke" "Euroa,Cowper" "Eurobodalla,Dampier" "Euroka,Bland" "Euroka,Leichhardt" "Euroka,Townsend" "Euroley,Townsend" "Eurolie,Waradgery" "Eurombedah,Ewenmar" "Eurongilly,Clarendon" "Europambela,Vernon" "Eurugabah,Nicholson" "Eurugabah,Woore" "Eurunderee,Gloucester" "Eurundury,Phillip" "Eusdale,Roxburgh" "Euston,Taila" "Euther,Gloucester" "Evan,Buckland" "Evans,Baradine"
"Evans,Buller" "Evans,Gloucester" "Evans,Mouramba" "Evans,Murchison" "Evans,Richmond" "Evelyn,Thoulcanna" "Evelyn,Young" "Everett,Hardinge" "Ewingar,Drake" "Exmouth,Sandon" "Faed,Urana" "Fairfield,Drake" "Fairy Hill,Yancowinna" "Fairy Meadow,Murray" "Fairy Mount,Rous" "Faithfull,Mitchell" "Falconer,Sandon" "Falls,Clarke" "Falnash,Cook" "Falnash,Roxburgh"
"Far West,Killara" "Farmcoat,Yancowinna" "Farnell,Clive" "Farnell,Cowper" "Farnham,St Vincent" "Faulkland,Gloucester" "Feehan,Thoulcanna" "Fennel,Bourke" "Fens,Gloucester" "Fenton,Fitzroy" "Fenwick,Vernon" "Ferrier,Buckland" "Ferryman,Sandon" "Fiby,Fitzgerald" "Field Of Mars,Cumberland" "Finch,Finch" "Finchley,Northumberland" "Findon,Rous" "Fingal,Durham" "Finlay,Cowper"
"Finlay,Townsend" "Finlay,Urana" "Finley,Booroondarra" "Finley,Denham" "Finley,Denison" "Finley,Finch" "Finley,Georgiana" "Finley,Stapylton" "Firbank,Flinders" "Firebrace,Wakool" "Fisher,Caira" "Fisher,Mouramba" "Fitzgerald,Phillip" "Fitzroy,Darling" "Fitzroy,Gloucester" "Fitzroy,Kennedy" "Fitzroy,Tara" "Fitzroy,Vernon" "Fladbury,Gough" "Flagstone,Gough"
"Fleming,Darling" "Fletcher,Courallie" "Fletcher,Gough" "Fletcher,Vernon" "Flinders,Beresford" "Flinders,Mouramba" "Flood,Thoulcanna" "Floods Creek,Farnell" "Florabel,Franklin" "Florida,Canbelego" "Forbes,Ashburnham" "Forbes,Macquarie" "Forbes,Wellington" "Fords Bridge,Gunderbooka" "Forest Creek,Goulburn" "Forest Land,Clive" "Forrest,Mootwingee" "Forster,Gloucester" "Fort Grey,Poole" "Fort Otway,Mootwingee"
"Foster,Flinders" "Foster,Tara" "Fosterton,Gloucester" "Foveaux,Tara" "Fowlers Gap,Farnell" "Fox,Nicholson" "Foy,Durham" "Franklin,Gunderbooka" "Franklin,Tara" "Frazer,Arrawatta" "Frazer,Clive" "Frederick,Cumberland" "Freemantle,Bathurst" "Fromes Creek,Poole" "Frost,Narromine" "Fulton,Mouramba" "Furber,Murchison" "Gabramatta,Wallace" "Gadara,Wynyard" "Gainbill,Dowling"
"Gairdners Creek,Mootwingee" "Galambine,Phillip" "Galar,Clyde" "Galar,Gunderbooka" "Galathera,Jamison" "Galbraith,Bathurst" "Galloway,Benarba" "Galloway,White" "Galong,Harden" "Galore,Urana" "Galwadgere,Wellington" "Gamalally,Finch" "Gamba,Lincoln" "Gambool,Yungnulgra" "Gamboola,Wellington" "Ganalgang,Oxley" "Ganaway,Caira" "Ganbenang,Westmoreland" "Gandymungydel,Gregory" "Gangarry,Clyde"
"Gangerang,Westmoreland" "Ganguddy,Roxburgh" "Ganmain,Bourke" "Gannawarra,Narran" "Ganoo,Gordon" "Gara,Sandon" "Gardiner,Gregory" "Garfield,Cowper" "Garfield,Oxley" "Garland,Young" "Garnet,Buccleuch" "Garnet,Taila" "Garnpung,Perry" "Garoo,Parry" "Garoolgan,Cooper" "Garrawilla,Pottinger" "Garrett,Clive" "Garrynian,Georgiana" "Garryowen,Dowling" "Garule,Oxley"
"Garway,King" "Gayer,Evelyn" "Gayer,Narran" "Gecar,Wellesley" "Geegullalong,Monteagle" "Geehi,Selwyn" "Geelnoy,Leichhardt" "Geelooma,Dowling" "Geera,Clyde" "Geerigan,Gregory" "Gehan,Jamison" "Gelam,Waradgery" "Gelambula,Leichhardt" "Gellabudda,Yanda" "Gemini,Livingstone" "Genanaguy,Kennedy" "Genaren,Kennedy" "Geneva,Rous" "Genoa,Auckland" "Genoe,Wakool"
"George,Clarke" "Gerabbit,Wakool" "Geraki,Caira" "Geraldra,Bland" "Geralgumbone,Gregory" "Gerar,Gregory" "Gerathula,Manara" "Gereldery,Denison" "Germano,Yungnulgra" "Gerogery,Goulburn" "Gerwa,Gregory" "Geurie,Lincoln" "Gewah,Ewenmar" "Geweroo,Flinders" "Ghoolendaadi,Pottinger" "Gibberagee,Richmond" "Gibbs,Cooper" "Gibraltar,Clive" "Gibrigal,Gipps" "Gibson,Hume"
"Gibson,Irrara" "Gidalambone,Canbelego" "Gidda,Robinson" "Gidgee,Evelyn" "Gidgell,Boyd" "Gidgenbar,Baradine" "Gidgerah,Clyde" "Gidgerygah,Leichhardt" "Gidgie,Robinson" "Gidgiegalumba,Rankin" "Gidgier,Narran" "Gidginbilla,Leichhardt" "Gidgingidginbung,Bland" "Gidley,Cumberland" "Gigel,Killara" "Gil Gil,Benarba" "Gil Gil,Stapylton" "Gilbert,Townsend" "Giles,Farnell" "Gilgai,Flinders"
"Gilgal,Gordon" "Gilgies,Canbelego" "Gilgoen,Gregory" "Gilgoenbon,Canbelego" "Gilgooma,Leichhardt" "Gilguldry,Leichhardt" "Gilgunnia,Blaxland" "Gilgunnia,Mouramba" "Gilgurry,Buller" "Gilgwapla,Yantara" "Gill,Burnett" "Gill,Clarke" "Gill,Inglis" "Gill,Parry" "Gill,Pottinger" "Gill,Vernon" "Gillenbah,Mitchell" "Gillenbine,Cunningham" "Gillenbine,Kennedy" "Gillgi,Narran"
"Gillindich,Georgiana" "Gilmandyke,Georgiana" "Gilmore,Wynyard" "Gilmour,Narromine" "Gilwarny,Leichhardt" "Gin,Benarba" "Gin Gin,Narromine" "Gindantherie,Cook" "Gindoono,Cunningham" "Ginee,Baradine" "Gineroi,Burnett" "Ginge,Clyde" "Gingham,Benarba" "Ginghet,Clyde" "Gingie,Finch" "Ginnewandinia,Yanda" "Ginninderra,Murray" "Girard,Buller" "Giro,Hawes" "Girralong,Gregory"
"Gladstone,Beresford" "Gladstone,Darling" "Gladstone,Raleigh" "Glass,Denham" "Glass,Murchison" "Glatherindi,Finch" "Gleena,Barrona" "Glen Alice,Hunter" "Glen Elgin,Clive" "Glen Emu,Caira" "Glen Innes,Gough" "Glen Lyon,Clive" "Glen Morrison,Vernon" "Glen Nevis,Gresham" "Glenalvon,Burnett" "Glenample,Irrara" "Glenariff,Canbelego" "Glenariff,Cowper" "Glenbog,Wellesley" "Glendon,Durham"
"Glenelg,Irrara" "Glengalla,Boyd" "Glengarry,Georgiana" "Glenken,Selwyn" "Glenlogan,Bathurst" "Glenmore,Farnell" "Glenroy,Selwyn" "Glenstal,Perry" "Glespin,Fitzgerald" "Gloucester,Gloucester" "Gnalta,Yungnulgra" "Gnomery,Narran" "Gnuie,Wakool" "Gnupa,Auckland" "Goally,Pottinger" "Goalonga,Burnett" "Goan,Narromine" "Goangra,Baradine" "Goba,St Vincent" "Gobabla,Oxley"
"Gobarralong,Harden" "Gobbagaula,Mitchell" "Gobbagombalin,Clarendon" "Gobollion,Clyde" "Gobondry,Kennedy" "Gobram,Townsend" "Godfrey,Waradgery" "Gogeldrie,Cooper" "Goimbla,Ashburnham" "Gol Gol,Manara" "Gol Gol,Wentworth" "Goldson,Gunderbooka" "Goldspink,Wynyard" "Golgothrie,Franklin" "Gommel,Jamison" "Gonawarra,Townsend" "Gonella,Yanda" "Gongolgon,Cowper" "Gonn,Blaxland" "Gonn,Wakool"
"Gonowlia,Franklin" "Gonowlia,Nicholson" "Gooan,Blaxland" "Gooandra,Wallace" "Goobabone,Gregory" "Goobang,Ashburnham" "Goobang,Cunningham" "Goobarragandra,Buccleuch" "Goobarralong,Buccleuch" "Goobothery,Gipps" "Goocalla,Benarba" "Good Good,Beresford" "Goode,Young" "Goodiman,Bligh" "Googong,Murray" "Goolagoola,Gregory" "Goolagunni,Franklin" "Goolamanger,Clive" "Goold,Mouramba" "Goolgowi,Nicholson"
"Goolgowi South,Nicholson" "Goolgowi West,Nicholson" "Goolgumbla,Landsborough" "Goolgumbla,Urana" "Goollooinboin,Cook" "Goolma,Bligh" "Gooloogong,Forbes" "Goombalie,Barrona" "Goombargana,Hume" "Goona,White" "Goona Warra,Waljeers" "Goonaburra,Mossgiel" "Goonalgaa,Werunda" "Goondoola,Manara" "Goonery,Barrona" "Goongal,Roxburgh" "Goonian,Arrawatta" "Goonie,Yanda" "Goonigal,Forbes" "Gooninbar,Rous"
"Gooningeri,Finch" "Goonoo,Lincoln" "Goonoo,Narran" "Goonoo Goonoo,Parry" "Goonumbla,Ashburnham" "Goorabil,Burnett" "Goorah,Manara" "Gooramma,Harden" "Goorangoola,Durham" "Goorara,Stapylton" "Gooraway,Finch" "Goorianawa,Baradine" "Goorianawa,Leichhardt" "Gooribun,Gregory" "Goorooyarroo,Murray" "Goorpooka,Killara" "Gooruba,Mootwingee" "Gooyan,Auckland" "Gora,Baradine" "Goragilla,Pottinger"
"Goran,Pottinger" "Gordon,Arrawatta" "Gordon,Courallie" "Gordon,Cumberland" "Gordon,Dudley" "Gordon,Finch" "Gordon,Gough" "Gordon,Hume" "Gordon,Killara" "Gordon,Livingstone" "Gordon,Narran" "Gordon,Wallace" "Gore,Buller" "Goreetabah,Booroondarra" "Gorian,Denham" "Gorie Gorie,Finch" "Gorman,Benarba" "Gorman,White" "Gormans Hill,Gipps" "Gorton,Cooper"
"Gorton,Gloucester" "Gosford,Northumberland" "Gosforth,Northumberland" "Gostwyck,Sandon" "Gotha,Cadell" "Gotha,Durham" "Gotha,Townsend" "Gothog,Cadell" "Goulburn,Argyle" "Goulburn,Brisbane" "Goulburn,Cowper" "Gould,Farnell" "Gounelgerie,Blaxland" "Gournama,Burnett" "Gouron,Murchison" "Govett,Cook" "Govett South,Cook" "Gowang,Gowen" "Goyder,Canbelego" "Grabben Gullen,King"
"Grabine,Georgiana" "Graddell,Gregory" "Graddle,Kennedy" "Gradell,Narromine" "Gradgery,Gregory" "Graeme,Macquarie" "Grafton,Gresham" "Gragin,Burnett" "Graham,Bathurst" "Graham,Clive" "Graham,Jamison" "Graham,Killara" "Graham,King" "Grahway,Flinders" "Grahway,Gregory" "Grahweed,Canbelego" "Gralga,Cowper" "Gralwin,Clyde" "Graman,Arrawatta" "Grandool,Clyde"
"Grandoonbone,Clyde" "Grange,Gresham" "Grant,Gloucester" "Grant,Taila" "Grant,Waradgery" "Grantham,Bathurst" "Granville,Hume" "Grassmere,Irrara" "Grattai,Wellington" "Gravesend,Burnett" "Grawin,Finch" "Grawlin,Robinson" "Gray,Hume" "Gray,Perry" "Grayrigg,Flinders" "Gre Gre,Waradgery" "Great Marlow,Clarence" "Greaves,Benarba" "Greaves,Finch" "Green,Finch"
"Greenaway,Benarba" "Greenbah,Courallie" "Greenbah,Gowen" "Greenock,Cunningham" "Greenough,Rankin" "Greenough,Werunda" "Greg Greg,Selwyn" "Gregado,Wynyard" "Gregory,Waljeers" "Gregra,Ashburnham" "Gregson,Buckland" "Greig,Gunderbooka" "Grenfell,Buckland" "Grenville,Wellesley" "Gresford,Durham" "Greville,Young" "Griffin,Manara" "Griffiths,Nicholson" "Griffiths,Young" "Grindie,Culgoa"
"Grong Grong,Cooper" "Grono,Hunter" "Grose,Cook" "Grose,Tara" "Grose,Wallace" "Groveland,Georgiana" "Growee,Phillip" "Grubben,Mitchell" "Gruie,Narran" "Gruyere,Cowper" "Guagong,Blaxland" "Guagong,Dowling" "Guan Gua,Brisbane" "Guapa,Blaxland" "Guapa West,Blaxland" "Gueraleh,Fitzgerald" "Gugumburra,Burnett" "Guinea,Dampier" "Guineacor,Argyle" "Guineacor,Westmoreland"
"Gulargambone,Ewenmar" "Gulargambone,Gowen" "Gulgin,Wellesley" "Gulgo,Cunningham" "Gulgong,Phillip" "Gullengambel,Gordon" "Gulligal,Darling" "Gulligal,Pottinger" "Gullongulong,Hunter" "Gullungutta,Burnett" "Gulmarrad,Clarence" "Gulpa,Cadell" "Gulph,Dampier" "Gulthul,Taila" "Gum Flat,Murchison" "Gumbagunda,Dowling" "Gumblebogie,Boyd" "Gumhall,Yanda" "Gumin,Gowen" "Gumly Gumly,Wynyard"
"Gummanaldi,Finch" "Gunambill,Urana" "Gunarramby,Manara" "Gunathera,Benarba" "Gundabloui,Finch" "Gundabooka,Yanda" "Gundadaline,Boyd" "Gundaine,Gloucester" "Gundamulda,Murchison" "Gundar,Fitzroy" "Gundare,Napier" "Gundaroo,Murray" "Gundary,Argyle" "Gundawarra,Cowper" "Gundemain,Jamison" "Gunderwerrie,Clyde" "Gundi,Gowen" "Gundibindyal,Bland" "Gundong,Narromine" "Gundy,Gordon"
"Gundy Gundy,Brisbane" "Gungalman,Leichhardt" "Gungalman North,Leichhardt" "Gungalwa,Hunter" "Gungarlin,Wallace" "Gungartan,Selwyn" "Gungewalla,Monteagle" "Gungoandra,Beresford" "Gunna,Leichhardt" "Gunnabonna,Mossgiel" "Gunnadilly,Buckland" "Gunnagi,Blaxland" "Gunnagia,Mossgiel" "Gunnary,King" "Gunnedah,Pottinger" "Gunnee,Burnett" "Gunnell,Gregory" "Gunnenbeme,Nandewar" "Gunning,Cunningham" "Gunning,King"
"Gunning Grach,Wellesley" "Gunningba,Oxley" "Gunningbland,Ashburnham" "Gunningbland,Cunningham" "Gunnyanna,Stapylton" "Gunpanoola,Perry" "Guntawang,Phillip" "Gununah,Evelyn" "Gunyulka,Werunda" "Gurangully,Dowling" "Gurilly,Finch" "Gurleigh,White" "Gurley,Courallie" "Gurley,Finch" "Gurnang,Georgiana" "Guroba,Bligh" "Gurragong,Cooper" "Gurrangora,Cowley" "Gurrera,Culgoa" "Gurriwarra,Culgoa"
"Gurriwarra,Gunderbooka" "Gurrundah,Argyle" "Gurrygedah,Courallie" "Guthega,Wallace" "Gutpy,Wentworth" "Guy Fawkes,Clarke" "Gwabegar,Baradine" "Gwynne,Clarendon" "Gwynne,Mouramba" "Gwynne,Wakool" "Gyan,Courallie" "Gygederick,Wallace" "Gynong,Wakool" "Haddon Rig,Gregory" "Hadleigh,Burnett" "Hadyn,Franklin" "Haines,Mossgiel" "Hall,Baradine" "Hall,Brisbane" "Hall,Canbelego"
"Hall,Clarke" "Hall,Darling" "Hall,Hawes" "Hall,Murchison" "Hallam,Arrawatta" "Halloran,Darling" "Halloran,Vernon" "Halscot,Brisbane" "Ham Common,Cumberland" "Hamilton,Benarba" "Hamilton,Drake" "Hamilton,Gough" "Hammond,Narran" "Hampton,Bathurst" "Hanging Rock,Mitchell" "Hanging Rock,Rous" "Haning,Inglis" "Hann,Woore" "Happy Valley,Landsborough" "Haradon,Clyde"
"Harden,Clive" "Harden,Harden" "Hardie,Culgoa" "Hardie,Urana" "Hargrave,Sandon" "Hargraves,Wellington" "Haribel,Livingstone" "Harley,Perry" "Harnham,Sandon" "Harold,Townsend" "Harrington,Macquarie" "Harris,Farnell" "Harrowby,Northumberland" "Hartington,Kennedy" "Hartley,Cook" "Hartung,Tandora" "Hartwood,Mouramba" "Hartwood,Townsend" "Harvey,Courallie" "Harvey,Stapylton"
"Harwood,Clarence" "Hassan,Drake" "Hastings,Hawes" "Hastings,Kennedy" "Hastings,Urana" "Hathaway,Mouramba" "Hawarden,Kennedy" "Hawes,Hawes" "Hawkesbury,Hunter" "Hawkins,Phillip" "Hawthorne,Arrawatta" "Hay,Killara" "Hay,Northumberland" "Hay,Selwyn" "Hay,Waradgery" "Hay,Woore" "Hay South,Waradgery" "Hayden,Wellesley" "Haynes,Evelyn" "Hazelwood,Cowper"
"Headford,Denison" "Healy,Ewenmar" "Hearne,Roxburgh" "Heathcote,Cumberland" "Hebden,Cooper" "Hebden,Townsend" "Hebden,Ularara" "Hebden,Urana" "Heddon,Northumberland" "Helebah,Jamison" "Henry,Gresham" "Henty,Hume" "Henty,Urana" "Herbert,Gough" "Herbert,Tandora" "Herbert,Yantara" "Herborn,Raleigh" "Hermitage,Canbelego" "Hermitage,Flinders" "Hermitage,Tongowoko"
"Hermitage Plains,Flinders" "Hernani,Fitzroy" "Herschell,Durham" "Hervey,Narromine" "Hervey,Sturt" "Hetherington,Arrawatta" "Hewong,Gloucester" "Hexham,Northumberland" "Hiawatha,Gipps" "Hiawatha,Waradgery" "Hickey,Dudley" "Higgins,Clyde" "Highland Home,Gough" "Hill,Benarba" "Hill,Beresford" "Hillas,Georgiana" "Hillas,Wynyard" "Hillcrest,Clive" "Hillgrove,Sandon" "Hillsborough,Cowper"
"Hillston,Robinson" "Hindmarsh,Hume" "Hindmarsh,Wakool" "Hindmarsh,Wynyard" "Hobden,Darling" "Hogarth,Arrawatta" "Hogarth,Fitzgerald" "Hogarth,Richmond" "Holbrook,Goulburn" "Holdfast,Arrawatta" "Holland,Beresford" "Hollingsworth,Burnett" "Holmes,Arrawatta" "Holmes,Stapylton" "Holsworthy,Cumberland" "Holybon,Gregory" "Holywell,Durham" "Honeybugle,Flinders" "Honeysuckle,Hardinge" "Hongkong,Drake"
"Honuna,Nicholson" "Honuna North,Nicholson" "Hooke,Bourke" "Hopwood,Nicholson" "Hora,Landsborough" "Horton,Gloucester" "Horton,Murchison" "Hoskins,Robinson" "Houghton,Durham" "Houlaghan,Clarendon" "Houlong,Sturt" "Houston,Kennedy" "Hovell,Hume" "Hovell,King" "Howard,Brisbane" "Howatson,Waljeers" "Howe,Auckland" "Howell,Boyd" "Howell,Clarke" "Howell,Urana"
"Howes Hill,Pottinger" "Howgill,Flinders" "Howick,Durham" "Howitt,Perry" "Howlong,Hume" "Howqua,Cowper" "Huco,Livingstone" "Hudson,Buckland" "Hudson,Livingstone" "Hughes,Yancowinna" "Hulong,Cooper" "Hume,Goulburn" "Hume,Mouramba" "Hume,Murray" "Hume,Selwyn" "Hume,Tandora" "Humphrey,White" "Humula,Wynyard" "Hungerford,Finch" "Hungerford,Hunter"
"Huntawong,Nicholson" "Hunter,Hunter" "Hunters Hill,Cumberland" "Huntley,Bathurst" "Huntly,Cowper" "Huon,Goulburn" "Hurley,Clarendon" "Hyandra,Blaxland" "Hyandra,Gordon" "Hyde Park,Sturt" "Hylaman,Landsborough" "Hyland,Fitzroy" "Iandra,Monteagle" "Ideraway,Franklin" "Ilginbah,Waradgery" "Ilgindrie,Gipps" "Illalong,Harden" "Illaroo,Camden" "Illawla,Windeyer" "Illewong,Blaxland"
"Illewong West,Blaxland" "Illilawa,Waradgery" "Illingerry,Wentworth" "Illingrammindi,Stapylton" "Illunie,Monteagle" "Imbergee,Finch" "Imbergee,Narran" "Imlay,Auckland" "Impimi,Caira" "Ina,Blaxland" "Ina,Gipps" "Ina,Waradgery" "Indi,Selwyn" "Indi,Ularara" "Ingalba,Bourke" "Ingalba,Raleigh" "Ingebirah,Wallace" "Ingeegoodbee,Wallace" "Ingleba,Vernon" "Inglega,Gregory"
"Ini,Franklin" "Inkerman,Yancowinna" "Innes,Hunter" "Innes,Macquarie" "Inverary,Argyle" "Inverell,Gough" "Irby,Clive" "Iredale,White" "Irene,Westmoreland" "Ironbark,Darling" "Ironbarks,Wellington" "Ironbong,Clarendon" "Ironmungy,Wellesley" "Irralong,Gloucester" "Irrara,Irrara" "Irrewarra,Cowper" "Irvine,Cook" "Isabella,Georgiana" "Isis,Brisbane" "Ita,Menindee"
"Ivanhoe,Mossgiel" "Ivanhoe,Nicholson" "Ivor,Clarendon" "Ivory,Hunter" "Jackadgery,Gresham" "Jagumba,Selwyn" "Jagungal,Selwyn" "Jamalong,Baradine" "Jamberoo,Camden" "Jamieson,Culgoa" "Jamieson,Killara" "Jamieson,Mouramba" "Jamieson,Yancowinna" "Jamison,Cook" "Jamison,Hunter" "Jamison,Jamison" "Jandra,Cowper" "Jarara,Cowper" "Jardine,Fitzroy" "Jasper,Macquarie"
"Jasper,Rous" "Jedburgh,Roxburgh" "Jeffrey,Clive" "Jeir,Murray" "Jellalabad,Waradgery" "Jellore,Camden" "Jemalong,Forbes" "Jemalong West,Gipps" "Jennings,Young" "Jenny Lind,Buller" "Jenolan,Westmoreland" "Jeogla,Clarke" "Jeralgambeth,Clarendon" "Jeraly,Caira" "Jereel,Denham" "Jeremy,Georgiana" "Jergyle,Goulburn" "Jerilderie North,Urana" "Jerilderie South,Urana" "Jerra Jerra,Goulburn"
"Jerralong,Argyle" "Jerrara,Argyle" "Jerrara,King" "Jerrawa,King" "Jerrawangala,St Vincent" "Jerricknorra,St Vincent" "Jerrong,Georgiana" "Jerula,Cunningham" "Jesse,Roxburgh" "Jettiba,Wellesley" "Jibeen,Buccleuch" "Jiggi,Rous" "Jillaga,Dampier" "Jillett,Bourke" "Jillimatong,Beresford" "Jimaringle,Wakool" "Jimberoo,Dowling" "Jimenbuen,Wallace" "Jindalee,Harden" "Jinden,Dampier"
"Jindera,Goulburn" "Jinderboine,Wallace" "Jinero,Murray" "Jingellic,Goulburn" "Jingellic East,Selwyn" "Jingerangle,Bland" "Jinglemoney,Murray" "Jinjera,Murray" "Jippay,Caira" "Joadja,Camden" "Jocelyn,Westmoreland" "Johns River,Macquarie" "Johnston,Mouramba" "Johnston,Pottinger" "Jondaryan,Cooper" "Jondol,Clive" "Jooriland,Westmoreland" "Jounama,Buccleuch" "Juanbung,Caira" "Juanbung,Kilfera"
"Jugiong,Harden" "Julandery,Cunningham" "Julong,Georgiana" "Jumbah,Booroondarra" "Jumbuck,Narran" "Jumbuck,Waradgery" "Junction,Vernon" "Jundrie,Blaxland" "Junee,Clarendon" "Jung Jung,Landsborough" "Jung Jung,Townsend" "Jurambula,Boyd" "Kabarabarabejal,Boyd" "Kadina,Kennedy" "Kahibah,Northumberland" "Kaiwilta,Cowper" "Kajuligah,Mossgiel" "Kalateenee,Dudley" "Kalinga,Cunningham" "Kalingan,Gipps"
"Kalistha,Narran" "Kalkite,Wallace" "Kallerakay,Booroondarra" "Kaloe,Gresham" "Kaloogleguy,Robinson" "Kamandra,Ashburnham" "Kambula,Killara" "Kambula,Young" "Kameruka,Auckland" "Kamilaroi,Benarba" "Kandie,Yungnulgra" "Kandra,Perry" "Kangaloolah,Georgiana" "Kangaloon,Camden" "Kangaroo,Buller" "Kangaroo,Clarke" "Kangaroo Flat,Vernon" "Kangarooby,Forbes" "Kangerong,Mouramba" "Kanimbla,Cook"
"Kaniva,Cowper" "Kanoonah,Auckland" "Kantappa,Farnell" "Kapiti,Landsborough" "Kara,Mootwingee" "Karpakora,Perry" "Kars,Cunningham" "Kars,Tandora" "Karuah,Gloucester" "Kasserhill,Manara" "Katabritoi,Manara" "Katambone,Denham" "Katarah,Mossgiel" "Kayrunnera,Mootwingee" "Keadool,Leichhardt" "Keajura,Wynyard" "Keats,Culgoa" "Kedumba,Cook" "Kee Kee,Finch" "Keelo,Benarba"
"Keelo,Finch" "Keenan,Flinders" "Keepit,Darling" "Keera,Jamison" "Keera,Murchison" "Keewong,Mossgiel" "Keewong,Murray" "Keginni,Blaxland" "Keilmoi,Finch" "Keilor,Rankin" "Keira,Mouramba" "Keirangunyah,Yanda" "Keiss,Werunda" "Kekeelbon,Hunter" "Keleela,Mossgiel" "Kelena,Booroondarra" "Kelgoola,Phillip" "Kelley,Canbelego" "Kelly,Thoulcanna" "Kelso,Roxburgh"
"Kelvedon,Narran" "Kember,King" "Kembla,Camden" "Kemp,Dudley" "Kempfield,Georgiana" "Kempsey,Macquarie" "Kendal,Franklin" "Kendale,Westmoreland" "Kendall,Rankin" "Kendall,Urana" "Kenebri,Baradine" "Kenilworth,Bathurst" "Kenindee,Yanda" "Kenmare,Irrara" "Kennedy,Finch" "Kennedy,Tara" "Kentucky,Hume" "Kentucky,Sandon" "Kenyu,King" "Kerewong,Macquarie"
"Kergunyah,Cowper" "Kerie,Yanda" "Kerkeri,Wakool" "Kerndombie,Yungnulgra" "Kerno,Yungnulgra" "Kerpa,Woore" "Kerr,Wellington" "Kerrabee,Phillip" "Kerranakoon,Townsend" "Kerrawary,Argyle" "Kerribree,Irrara" "Kerrininna,Thoulcanna" "Kerrish,Caira" "Kertne,Windeyer" "Ketelghay,Raleigh" "Keverstone,Georgiana" "Kew,Woore" "Keybarbin,Drake" "Khancoban,Selwyn" "Khartoum,Manara"
"Khatambuhl,Macquarie" "Ki,Taila" "Kia,Caira" "Kiah,Auckland" "Kialla,Cowper" "Kiama,Camden" "Kiamba,Mouramba" "Kiamma,Georgiana" "Kiandra,Wallace" "Kiantharillany,Robinson" "Kiargathur,Cunningham" "Kickabil,Ewenmar" "Kickerbell,Pottinger" "Kidgar,Leichhardt" "Kidgery,Canbelego" "Kieeta,Caira" "Kiengal,Narran" "Kiga,Burnett" "Kigwigil,Finch" "Kikiamah,Monteagle"
"Kikoira,Dowling" "Kildare,King" "Kildary,Bourke" "Kilfera,Irrara" "Kilfera,Manara" "Kilgowla,Wynyard" "Kilkoobwal,Mossgiel" "Killara,Killara" "Killarney,Nandewar" "Killawarra,Dowling" "Killawarra,Macquarie" "Killawarrah,Camden" "Killeen,Blaxland" "Killeen South,Blaxland" "Killen,Delalah" "Killendoo,Waradgery" "Killendoon,Ewenmar" "Killimicat,Buccleuch" "Killoe,Brisbane" "Killowen,Irrara"
"Kilnyana,Denison" "Kilon,Windeyer" "Kilpara,Evelyn" "Kilpara,Yantara" "Kimbriki,Gloucester" "Kimo,Clarendon" "Kinchega,Menindee" "Kinchela,Macquarie" "Kinchelsea,Mouramba" "Kincumber,Northumberland" "Kindarun,Hunter" "Kindee,Macquarie" "Kindra,Bourke" "King,Canbelego" "King,Courallie" "King,Evelyn" "King,Murchison" "King,Perry" "King,Selwyn" "King,Young"
"Kingi,Caira" "Kings Plains,Arrawatta" "Kingsgate,Gough" "Kingswell,Waljeers" "Kinilibah,Bourke" "Kinnear,Flinders" "Kinnear,Mouramba" "Kinnimo,Stapylton" "Kioloa,St Vincent" "Kippara,Macquarie" "Kirban,Gowen" "Kirindi,Franklin" "Kirk,Yungnulgra" "Kirkingle,Rankin" "Kirrabirri,Wakool" "Kitchela,Cowper" "Kitcho,Kilfera" "Kitcho,Waljeers" "Knorrit,Macquarie" "Knowla,Gloucester"
"Knox,Mouramba" "Kockibitoo,Bourke" "Kokoboreeka,Auckland" "Kokomerican,Macquarie" "Kolkilbertoo,Cooper" "Kolkilbertoo East,Cooper" "Kolkilbertoo South,Cooper" "Konangaroo,Westmoreland" "Kongong,Franklin" "Konowogan,Narran" "Kooba,Sturt" "Kooltoo,Yantara" "Koonburra,Mootwingee" "Koonyaboothie,Tongowoko" "Koorakee,Taila" "Kooree,Northumberland" "Koorinya,Woore" "Koorningbirry,Mootwingee" "Koorooman,Cowper" "Kooroongal,Sturt"
"Kootooloomondoo,Yantara" "Kopago,Young" "Koree,Macquarie" "Koreelah,Buller" "Kornga,Gloucester" "Koroit,Cowper" "Korri,Delalah" "Kosciuszko,Selwyn" "Kosciuszko,Wallace" "Koukandowie,Fitzroy" "Kowmung,Westmoreland" "Krawarree,Murray" "Kremnos,Fitzroy" "Kruge,Mouramba" "Krui,Benarba" "Kudgee,Windeyer" "Kulki,Woore" "Kulkyne,Barrona" "Kullatine,Dudley" "Kunderang,Vernon"
"Kundibakh,Gloucester" "Kungerbil,Oxley" "Kunghur,Rous" "Kunopia,Benarba" "Kurawillia,Tongowoko" "Kurragong,Finch" "Kurrajong,Cook" "Kyalite,Wakool" "Kybeyan,Beresford" "Kydra,Beresford" "Kyeamba,Wynyard" "Kyle,Gloucester" "Kynnumboon,Rous" "Kyogle,Rous" "Lachlan,Bourke" "Lachlan,Dowling" "Lachlan,Mootwingee" "Lachlan,Nicholson" "Lagan,Waljeers" "Laggan,Georgiana"
"Lagune,Clarke" "Laidley,Menindee" "Lake,Gipps" "Lake,Urana" "Lake,Wallace" "Lake George,Murray" "Lake Gunbar,Nicholson" "Lalalty,Denison" "Lallal,Franklin" "Lamb,Townsend" "Lambrigg,Flinders" "Lambrigg,Robinson" "Lammunnia,Booroondarra" "Lampton,King" "Landale,Wakool" "Lands End,Gough" "Lang,Poole" "Lang,Waradgery" "Langawirra,Mootwingee" "Langboyde,Narran"
"Langcalcal,Mossgiel" "Langdale,Westmoreland" "Langi-Kal-Kal,Bourke" "Langloh,Finch" "Langmore,Clyde" "Langtree,Canbelego" "Langtree,Nicholson" "Langunya,Denison" "Langwell,Rous" "Lanitza,Clarence" "Lansdowne,Macquarie" "Lanty,Woore" "Lara,Waradgery" "Larbert,Murray" "Lardner,Clarence" "Largoh,Mossgiel" "Largs,Waljeers" "Larnaca,Waljeers" "Larras Lake,Wellington" "Laura,Hardinge"
"Laurie,Taila" "Lavadia,Clarence" "Lawrence,Caira" "Lawrence,Clarence" "Lawrence,Rankin" "Lawrence,Sandon" "Lawson,Clive" "Lawson,Oxley" "Lawson,Pottinger" "Lawson,Wellesley" "Lay Green,Stapylton" "Lea,Selwyn" "Leard,Nandewar" "Learmonth,Sturt" "Ledknapper,Gunderbooka" "Lee,Cowper" "Lee,Phillip" "Leibnitz,Westmoreland" "Leichhardt,Windeyer" "Leigh,Fitzroy"
"Leighwood,Georgiana" "Leila,Gunderbooka" "Leitch,Mitchell" "Lemington,Hunter" "Lenakka,Yanda" "Lennox,Bathurst" "Lennox,Phillip" "Lerida,King" "Lerida,Robinson" "Leslie,Arrawatta" "Leslie,Baradine" "Lestrange,Fitzgerald" "Letheroe,Wentworth" "Lethington,Sturt" "Lett,Cook" "Lette,Caira" "Lette,Taila" "Leura,Manara" "Leura,Waradgery" "Lewes,Cooper"
"Lewinsbrook,Durham" "Lewis,Clive" "Lewis,Macquarie" "Lewis,Wellington" "Lewis,Yancowinna" "Liberty Plains,Cumberland" "Liddell,Durham" "Liddell,Livingstone" "Lidsdale,Cook" "Liebeg,Durham" "Liewa,Wakool" "Lignum,Narran" "Lila,Tara" "Lillicro,Narran" "Limebon,Stapylton" "Limestone,Arrawatta" "Limestone,Clive" "Limestone,Gloucester" "Limestone,Kennedy" "Linbee,Manara"
"Linbee,Perry" "Linchiden,Narran" "Lincoln,Brisbane" "Lincoln,Caira" "Lincoln,Canbelego" "Lincoln,Lincoln" "Lincoln,Macquarie" "Linden,Cook" "Lindesay,Murchison" "Lindesay,Nandewar" "Lindsay,Bathurst" "Lindsay,Buller" "Lindsay,Clyde" "Lindsay,Tara" "Linton,Robinson" "Lintot,Wakool" "Lismore,Irrara" "Lismore,Rous" "Lismore South,Irrara" "Lissan,Wentworth"
"Lissington,Culgoa" "Little,Cowper" "Little Billabung,Goulburn" "Little Forest,St Vincent" "Little Plain,Murchison" "Livingstone,Gipps" "Livingstone,Sturt" "Livingstone,Wynyard" "Llangothlin,Gough" "Llanillo,Finch" "Lloyd,White" "Loadstone,Rous" "Loch,Townsend" "Loch,Vernon" "Lockerby,Arrawatta" "Lockhart,Urana" "Lockyer,Northumberland" "Loder,Buckland" "Loder,White" "Loftus,Cowper"
"Loftus,Dudley" "Loftus,Parry" "Loftus,Tara" "Loftus,White" "Loftus,Young" "Lolah,Narran" "Lolleep,Finch" "Londonderry,Cumberland" "Long Plain,Cowley" "Long Point,Denham" "Long Point,Jamison" "Longside,Barrona" "Lonsdale,Tara" "Looanga,Inglis" "Loocalle,Caira" "Looden,Gunderbooka" "Lookout,Clarke" "Loombah,Gordon" "Loomberah,Parry" "Loorica,Caira"
"Lorimer,Bligh" "Lorne,Arrawatta" "Lorne,Macquarie" "Lorraine,Waradgery" "Louee,Phillip" "Loughnan,Nicholson" "Louis,Gough" "Louth,Robinson" "Louth,Yanda" "Lowan,Mossgiel" "Lowan,Taila" "Lowan,Waljeers" "Lowe,Napier" "Lowes,Hume" "Lowry,Bathurst" "Lowry,Darling" "Lowry,Hawes" "Lowther,Westmoreland" "Loxton,Culgoa" "Lucan,Bathurst"
"Lucas,Beresford" "Lulawar,Narran" "Lupton,Bourke" "Lyle,Wakool" "Lynch,Canbelego" "Lynch,Clyde" "Lyndhurst,Bathurst" "Macdonald,Hunter" "Macintyre,Arrawatta" "Macintyre,Gough" "Macintyre,Murchison" "Mackay,Cowper" "Mackay,Hawes" "Mackay,Macquarie" "Mackenzie,Baradine" "Mackenzie,Brisbane" "Mackenzie,Hardinge" "Mackenzie,Young" "Maclean,Clive" "Maclean,Mitchell"
"Macleay,Boyd" "Macleay,Dudley" "Macleay,Vernon" "Macpherson,Caira" "Macpherson,Killara" "Macpherson,Rankin" "Macquarie,Lincoln" "Macquarie,Macquarie" "Macquarie,Roxburgh" "Macqueen,Brisbane" "Madson,Cowper" "Maffra,Cowper" "Maffra,Wellesley" "Magdala,Cook" "Magenta,Kilfera" "Maggarie,Finch" "Maghera,Barrona" "Magnolia,Waradgery" "Magometon,Leichhardt" "Maharatta,Wellesley"
"Maharatta,Yancowinna" "Mahonga,Hume" "Mahonga Forest,Hume" "Mahurangi,Blaxland" "Mahurangi East,Blaxland" "Maiden,Sturt" "Maiden,Tandora" "Mair,Sturt" "Mairjimmy,Urana" "Maitland,Northumberland" "Majura,Murray" "Makingah,Livingstone" "Makunagoona,Booroondarra" "Malagadery,Mossgiel" "Malakoff,Tandora" "Malara,Drake" "Malcolm,Napier" "Malebo,Clarendon" "Maleeja,Bland" "Maley,Boyd"
"Malgoolie,Culgoa" "Mallallee,White" "Mallambray,Yungnulgra" "Mallan,Wakool" "Mallara,Werunda" "Mallara,Windeyer" "Mallara,Woore" "Mallee,Mossgiel" "Mallee,Tara" "Mallee,Townsend" "Mallee,Wakool" "Mallee Cliffs,Taila" "Mallowa,Benarba" "Malmsbury,Bathurst" "Malongulli,Bathurst" "Malta,Tandora" "Mamanga,Caira" "Mamaran,Durham" "Mamre,Cunningham" "Manamoi,Jamison"
"Manara,Manara" "Manara,Werunda" "Manara,Woore" "Manatoo,Irrara" "Manatoo West,Irrara" "Manbus,Brisbane" "Mandagery,Ashburnham" "Mandamah,Bland" "Mandamah,Bourke" "Mandellman,Manara" "Mandle,Buller" "Mandoe,Arrawatta" "Mandoe,Burnett" "Mandolong,Northumberland" "Mandy,Livingstone" "Manfred,Manara" "Manfred,Mossgiel" "Mangamore,Argyle" "Mangoplah,Mitchell" "Mangrove,Northumberland"
"Manie,Taila" "Maniette,Taila" "Manildra,Ashburnham" "Manilla,Darling" "Manilla,Denham" "Manjar,Selwyn" "Manly Cove,Cumberland" "Mann,Gough" "Manna,Gipps" "Manning,Finch" "Mannus,Selwyn" "Manobalai,Brisbane" "Manopa,Blaxland" "Manton,King" "Manum,White" "Manwanga,Cowper" "Mapenny,Perry" "Mara,Gregory" "Maragle,Selwyn" "Marah,Cadell"
"Maranoa,Yanda" "Marara,Gresham" "Marara West,Gresham" "Marbella,Gregory" "Marbunga,Bland" "March,Wellington" "Marcoonia,Tara" "Marea,Mossgiel" "Marebone,Gregory" "Maremley,Caira" "Marengo,Clarke" "Marengo,Gresham" "Marfield,Woore" "Marina,Monteagle" "Marinebone,Gregory" "Markdale,Georgiana" "Markham,Benarba" "Markham,Jamison" "Marlborough,Livingstone" "Marle,Livingstone"
"Marlee,Macquarie" "Marlowe,St Vincent" "Marma,Taila" "Marobee,Blaxland" "Marobee East,Blaxland" "Marong,Cowper" "Marooba,Blaxland" "Maroona,Cowper" "Maroopna,Mossgiel" "Maroota,Cumberland" "Maropinna,Mootwingee" "Maror,Clarendon" "Marowan,Gough" "Marowie,Franklin" "Marowie,Waljeers" "Marowrie,Bland" "Marra,Killara" "Marracoota,Evelyn" "Marramarra,Cumberland" "Marrangaroo,Cook"
"Marrar,Bourke" "Marributa,Mossgiel" "Marrinumbla,Wallace" "Mars,Cadell" "Marsden,Gipps" "Marsh,Buller" "Marsh,Macquarie" "Marsh,Richmond" "Marthaguy,Gregory" "Martin,Ashburnham" "Martin,Fitzroy" "Martindale,Hunter" "Marulan,Argyle" "Marwood,Durham" "Mary,Rankin" "Maryland,Buller" "Maryvale,Clarence" "Massie,Waljeers" "Mataganah,Auckland" "Matakana,Blaxland"
"Matakana South,Blaxland" "Matalong,Taila" "Matamong,Waljeers" "Mate,Selwyn" "Mate,Wynyard" "Matheson,Manara" "Mathoura,Cadell" "Matong,Bourke" "Matong,Wallace" "Matong,Wentworth" "Matong,Yancowinna" "Matouree,Leichhardt" "Maude,Waradgery" "Maudry,Forbes" "Maybah,Mossgiel" "Mayne,Stapylton" "Mayo,Hardinge" "Mcdonald,Arrawatta" "Mcdonald,Phillip" "Mcfarlane,Baradine"
"Mcgregor,Mouramba" "Mckinnon,Murchison" "Mclean,Hunter" "Mea Mia,Nicholson" "Mea Mia North,Nicholson" "Mea Mia South,Nicholson" "Mead,Roxburgh" "Meadows,Booroondarra" "Meadows,Yancowinna" "Meangora,St Vincent" "Mearimb,Buller" "Mebea,Finch" "Medgun,Courallie" "Medhurst,Hunter" "Mediwah,Hunter" "Medlow,Raleigh" "Medway,Cowper" "Medway,Lincoln" "Meehan,Cook" "Meei,Benarba"
"Meero,Benarba" "Meerschaum,Rous" "Meeson,Canbelego" "Megalong,Cook" "Meglo,Georgiana" "Mehi,Murchison" "Meilman,Taila" "Mein,Finch" "Mein,Wakool" "Meit,Baradine" "Mejum,Cooper" "Mekai,Waljeers" "Melbergen,Nicholson" "Melbergen South,Nicholson" "Melbourne,Brisbane" "Meldior,Blaxland" "Meldrum Downs,Fitzroy" "Mellburra,Jamison" "Melleallina,Stapylton" "Mellelea,Blaxland"
"Mellerstain,Gregory" "Mellong,Hunter" "Mellool,Wakool" "Melrose,Cunningham" "Melrose,Gregory" "Melrose,Roxburgh" "Melrose,Waradgery" "Melville,Cumberland" "Melville,Pottinger" "Melyra,Forbes" "Mema,Pottinger" "Memagong,Bland" "Menadool,Courallie" "Menamurtee,Yungnulgra" "Menangle,Cumberland" "Menderie,Yantara" "Mendook,Taila" "Mendooran,Napier" "Mepunga,Canbelego" "Merah,Jamison"
"Merah North,Jamison" "Meranda,Clyde" "Merche,Wentworth" "Mere,Barrona" "Merebene,Baradine" "Meriah,Jamison" "Merigan,Murray" "Merilba,Kennedy" "Merimborough,Baradine" "Merinda,Wellington" "Meringo,Auckland" "Meringo,Narromine" "Meringo,Wellesley" "Meriti,Arrawatta" "Merlin,Westmoreland" "Merno,Wentworth" "Mernot,Hawes" "Meroe,Benarba" "Meroo,Windeyer" "Merotherie,Bligh"
"Merowa,Taila" "Merran,Wakool" "Merrere,Yanda" "Merri,Canbelego" "Merri,Gregory" "Merri Merrigal,Dowling" "Merriangaah,Wellesley" "Merribooka,Gipps" "Merricumbene,Dampier" "Merrigal,Ewenmar" "Merrigalah,Sandon" "Merriganowry,Forbes" "Merrigula,Pottinger" "Merrilba,Flinders" "Merrill,King" "Merrimajeel,Waljeers" "Merrimarotherie,Gipps" "Merrimba,Gregory" "Merrimerriwa,Blaxland" "Merrinele,Gregory"
"Merrita,Irrara" "Merrita South,Barrona" "Merrita West,Barrona" "Merritombea,Baradine" "Merriwa,Brisbane" "Merriwa,Stapylton" "Merroo,Cook" "Merrumbulo,Wellesley" "Merry,Werunda" "Merrybundinah,Clarendon" "Merrygoen,Napier" "Merrylegai,Raleigh" "Merrywinebone,Denham" "Merungle,Franklin" "Merv,Franklin" "Merwin,Wakool" "Meryla,Camden" "Meryon,Ewenmar" "Meryula,Kennedy" "Methul,Bourke"
"Metz,Sandon" "Meutherra,Yanda" "Mevna,Caira" "Mia Mia,Courallie" "Mia Mia,Wakool" "Mialora,Cowper" "Miamley North,Flinders" "Miandetta,Flinders" "Micabil,Cunningham" "Micalong,Cowley" "Michelago,Beresford" "Micketymulga,Lincoln" "Mickibri,Kennedy" "Mickimill,Kennedy" "Middlehope,Durham" "Middlesex,Mouramba" "Middlingbank,Wallace" "Midgecleugh,Waradgery" "Midgee,Baradine" "Midgehope,Perry"
"Miendetta,Cowper" "Mihi,Nandewar" "Mihi,Sandon" "Mila,Wellesley" "Milang,Windeyer" "Milbang,Argyle" "Milbee,Gipps" "Milbrodale,Northumberland" "Milbrulong,Mitchell" "Milburn,Bathurst" "Milchomi,Baradine" "Milda,Ewenmar" "Mildil,Gipps" "Mildool,Narran" "Milford,Beresford" "Milkengay,Wentworth" "Millah Murrah,Roxburgh" "Millebee,Benarba" "Millenbong,Wellington" "Miller,Baradine"
"Milleu,Wakool" "Millfield,Northumberland" "Milli,Gloucester" "Millie,Jamison" "Millie,Pottinger" "Millie,Wentworth" "Millpillbury,Rankin" "Mills,Sturt" "Milner,White" "Milo,St Vincent" "Milong,Bland" "Milparinka,Evelyn" "Milpose,Ashburnham" "Milpose,Cunningham" "Milpulling,Ewenmar" "Milrea,Finch" "Milring,Evelyn" "Milroy,Narran" "Milroy West,Culgoa" "Miltara,Yantara"
"Miltara,Yungnulgra" "Mimi,Gloucester" "Mimi,Wentworth" "Mimmilinji,Mossgiel" "Mimosa,Bourke" "Mimosa,Mitchell" "Minalong,Flinders" "Mindelwul,Wentworth" "Minden,Livingstone" "Mingah,Waradgery" "Mingan,Stapylton" "Mingelo,Kennedy" "Mingelo,Narromine" "Mingerong,Kennedy" "Mingoola,Clive" "Minijary,Bland" "Minjary,Wynyard" "Minna,Narran" "Minnaminane,Courallie" "Minnon,Baradine"
"Minore,Narromine" "Minto,Cumberland" "Miparo,Mossgiel" "Miranda,Wakool" "Mirannie,Durham" "Mirboo,Cowper" "Mirrie,Hunter" "Mirrie,Lincoln" "Mirrool,Sturt" "Missabotti,Raleigh" "Mitchell,Burnett" "Mitchell,Clarke" "Mitchell,Gough" "Mitchell,Goulburn" "Mitchell,Lincoln" "Mitchell,Perry" "Mitchell,Wallace" "Mitchell,Yanda" "Mitchell,Young" "Mitta,Menindee"
"Mitta Mitta,Clarendon" "Mittagong,Camden" "Moama,Cadell" "Moama,Werunda" "Moama,Woore" "Moan,Bligh" "Moan,Buckland" "Moangola,Wentworth" "Mobala,Gregory" "Mobbindry,Stapylton" "Moco Barungha,Irrara" "Moema,Jamison" "Mogendoura,St Vincent" "Mogil,Leichhardt" "Mogil Mogul,Finch" "Mogila,Auckland" "Mogila,Narran" "Mogille,Flinders" "Mogille Plain,Flinders" "Moglewit,Baradine"
"Mogong,Ashburnham" "Mogood,St Vincent" "Mogundale,Flinders" "Mohenia,Narran" "Moira,Cadell" "Moira,Cowper" "Moira,Werunda" "Mokely,Poole" "Mokely,Tongowoko" "Mokoreeka,Auckland" "Molesworth,Franklin" "Molesworth,Nicholson" "Molle,Clyde" "Mollee,White" "Mollieroi,White" "Mologone,Dowling" "Molong,Ashburnham" "Molonglo,Murray" "Molroy,Murchison" "Momba,Ularara"
"Momble,Yanda" "Momo,Narromine" "Momolong,Denison" "Moncton,Nicholson" "Moneybung,Dowling" "Monga,St Vincent" "Mongarlowe,St Vincent" "Mongogarie,Richmond" "Mongyer,Benarba" "Monimail,Townsend" "Monkellan,Canbelego" "Monkellan,Murray" "Monkem,Caira" "Monkerai,Gloucester" "Monolon,Fitzgerald" "Monomie,Cunningham" "Monsoon,Burnett" "Montagu,Beresford" "Monundilla,Hunter" "Monwonga,Cunningham"
"Mooball,Rous" "Moodana,Cowper" "Moodana,Kennedy" "Moodana South,Kennedy" "Moodarnong,Waljeers" "Mooee,Courallie" "Moogem,Clive" "Mookalimbirria,Yanda" "Mookerwah,Auckland" "Mooki,Buckland" "Mookima,Drake" "Moolah,Mossgiel" "Moolamanda,Booroondarra" "Moolambong,Leichhardt" "Moolarben,Phillip" "Moolbong,Franklin" "Mooley,Windeyer" "Moollattoo,Camden" "Moollawoolka,Fitzgerald" "Moolook,Evelyn"
"Mooloolerie,Perry" "Moolort,Irrara" "Moolpa,Wakool" "Moolunmoola,Parry" "Moombooldool,Cooper" "Moombooldool North,Cooper" "Moomin,Benarba" "Moon Moon,Nicholson" "Moona,Vernon" "Moonamurtie,Yungnulgra" "Moonan,Durham" "Moonbi,Inglis" "Moonbia,Gipps" "Moonbill,Nandewar" "Moonbria,Townsend" "Moonbucca,Bland" "Moonee,Fitzroy" "Mooney Mooney,Harden" "Moongoola,Mossgiel" "Moongoonoola,Narran"
"Moongulla,Finch" "Mooni,Finch" "Moonpar,Fitzroy" "Moonul,Ewenmar" "Moora,Blaxland" "Moora,Leichhardt" "Moora Moora,Gipps" "Mooraback,Vernon" "Moorabark,Macquarie" "Moorabin,Young" "Moorambilla,Leichhardt" "Mooramia,Gunderbooka" "Moorangoorang,Napier" "Moorara,Perry" "Moorguinnia,Young" "Moorina,Benarba" "Moorkaie,Yancowinna" "Moorna,Tara" "Moornanyah,Manara" "Moorongatta,Wakool"
"Mooroo,Finch" "Mooroonowa,Irrara" "Moorowara,Parry" "Moorpa,Wentworth" "Moorquong,Fitzgerald" "Moorwatha,Hume" "Mootcha,Cowper" "Moothumbool,Mouramba" "Mopone,Robinson" "Moppin,Stapylton" "Moppity,Harden" "Moquilamba,Robinson" "Moquilamba,Yanda" "Morabilla,Narran" "Morago,Townsend" "Moramina,Finch" "Morangarell,Bland" "Morden,Mootwingee" "Mordie,Blaxland" "Morebringer,Hume"
"Moredevil,Pottinger" "Moredun,Hardinge" "Moree,Courallie" "Morella,Narran" "Morella,Stapylton" "Morendah,Finch" "Morgan,Jamison" "Morisset,Northumberland" "Morla,Clyde" "Morongla,Forbes" "Morotherie,Ularara" "Morris,Caira" "Morriset,Young" "Morse,Hardinge" "Morthong,Perry" "Morton,Fitzgerald" "Morton,Macquarie" "Morton,Townsend" "Morton Plains,Culgoa" "Moruben,Northumberland"
"Morundah,Urana" "Morundah South,Urana" "Morundurey,Roxburgh" "Moruya,Dampier" "Morven,Clive" "Morven,Hume" "Morven,Napier" "Morwell,Cowper" "Mossgiel,Mouramba" "Mossgiel,Waljeers" "Mouin,Cook" "Moulamein,Wakool" "Moulamein South,Wakool" "Moultrassie,Townsend" "Mount Allen,Blaxland" "Mount Blackwood,Evelyn" "Mount Foster,Gregory" "Mount George,Gloucester" "Mount Gipps,Yancowinna" "Mount Hope,Blaxland"
"Mount Jack,Killara" "Mount King,Poole" "Mount Lawson,Georgiana" "Mount Mitchell,Gough" "Mount Nobby,Cunningham" "Mount Pleasant,Bathurst" "Mount Pleasant,Stapylton" "Mount Poole,Poole" "Mount Ross,Clarke" "Mount Royal,Durham" "Mount Solitary,Blaxland" "Mount Stuart,Tongowoko" "Mount Trooper,Wellesley" "Mount Wood,Tongowoko" "Mountain Creek,Goulburn" "Moura,Ashburnham" "Moura,Cooper" "Mourabie,Leichhardt" "Mouramba,Blaxland" "Mouramba,Mouramba"
"Mourquong,Wentworth" "Mourte,Livingstone" "Mowabla,Cunningham" "Mowamba,Wallace" "Mowle,Clarke" "Mowlma,Leichhardt" "Moyangul,Wallace" "Mozart,Westmoreland" "Mucca Mucca,Pottinger" "Muckee,Caira" "Muckerawea,Narran" "Muckerwa,Wellington" "Mucra,Urana" "Mucruss,Irrara" "Mudall,Oxley" "Mudelooromun,Culgoa" "Mudgee,Wellington" "Mueller,Perry" "Mugga,Bland" "Mugincoble,Ashburnham"
"Muir,Gough" "Mukki,Hawes" "Mukudjeroo,Irrara" "Mulberrygong,Boyd" "Mulbring,Northumberland" "Mulburruga,Boyd" "Mulcatcha,Farnell" "Mulcawee,Mootwingee" "Mulchara,Booroondarra" "Mulga,Blaxland" "Mulga,Canbelego" "Mulga,Cowper" "Mulga,Gipps" "Mulga,Gunderbooka" "Mulga,Rankin" "Mulga,Robinson" "Mulga,Tandora" "Mulga,Windeyer" "Mulga,Yanda" "Mulga,Young"
"Mulga Downs,Booroondarra" "Mulga Gaari,Tandora" "Mulgawarrina,Cowper" "Mulgoa,Cumberland" "Mulgowrie,Georgiana" "Mulgunnia,Georgiana" "Mulguthrie,Cunningham" "Mulholland,Cowper" "Mulla,Parry" "Mulla Mulla,Nicholson" "Mulla Mulla,Oxley" "Mullah,Flinders" "Mullah,Narromine" "Mullah Back,Narromine" "Mullendaree,St Vincent" "Mullengandra,Goulburn" "Mullengudgery,Oxley" "Mullengullenga,Argyle" "Mullimut,Robinson" "Mullingowba,Finch"
"Mullion,Cowley" "Mullion,Nicholson" "Mulloga,Waljeers" "Mullojama,Windeyer" "Mulloon,Murray" "Mullumbimby,Rous" "Multagoona,Irrara" "Muluerindie,Inglis" "Mulurula,Manara" "Mulwala,Denison" "Mulwaree,Argyle" "Mulya,Yanda" "Mulyah,Landsborough" "Mulyan,Forbes" "Mulyan,Wellington" "Mulyandry,Forbes" "Mulyenery,Young" "Mumbedah,Napier" "Mumbidgle,Ashburnham" "Mumbil,Wellington"
"Mumblebone,Gregory" "Mumbowanna,Robinson" "Mumbrabah,Oxley" "Mumbulla,Auckland" "Mummel,Argyle" "Mummel,Hawes" "Mummulgum,Rous" "Mumpber,Gunderbooka" "Munbunya,Rankin" "Mundadoo,Clyde" "Mundar,Gowen" "Mundare,Leichhardt" "Mundarlo,Wynyard" "Mundawaddery,Mitchell" "Mundawah,Clyde" "Munderoo,Selwyn" "Mundi Mundi,Yancowinna" "Mundiwa,Townsend" "Mundonah,Taila" "Mundongo,Buccleuch"
"Mundoo,Finch" "Mundoonen,King" "Mundowey,Darling" "Mundowy,Mitchell" "Munduburra,Cooper" "Mundy,Livingstone" "Mundybah,Menindee" "Mungabarina,Goulburn" "Mungadal,Waradgery" "Mungerarra,Denham" "Mungeribar,Oxley" "Mungerie,Kennedy" "Mungery,Leichhardt" "Mungi,Benarba" "Mungie Bundie,Courallie" "Mungiladh,Narran" "Mungle,Stapylton" "Mungo,Perry" "Mungo,Taila" "Mungrada,Narran"
"Mungundi,Fitzgerald" "Mungunyah,Gunderbooka" "Munmorah,Northumberland" "Munmurra,Bligh" "Munna,Wellington" "Munna Munna,Leichhardt" "Munro,Murchison" "Munro,Sturt" "Munro,Yungnulgra" "Muntawa,Killara" "Munyabla,Urana" "Munyang,Selwyn" "Munyang,Wallace" "Munye,Mootwingee" "Murchison,Young" "Murda,Cunningham" "Mureabun,Finch" "Murga,Ashburnham" "Murga,Cunningham" "Murga,Wakool"
"Murgo,Burnett" "Muriel,Canbelego" "Murkadool,Denham" "Murnia,Waljeers" "Murnowella,Wentworth" "Murpa,Fitzgerald" "Murra,Waljeers" "Murra Murra,Denham" "Murrabrine,Dampier" "Murrabudda,Flinders" "Murrabung,Dowling" "Murraguldrie,Wynyard" "Murrah,Dampier" "Murraiman,Leichhardt" "Murray,Cowley" "Murray,Goulburn" "Murray,Hawes" "Murray,Selwyn" "Murrengenburg,St Vincent" "Murrengreen,Gipps"
"Murrimba,Camden" "Murrimboola,Harden" "Murringo,Monteagle" "Murringo North,Monteagle" "Murringobunni,Mossgiel" "Murroo,Wallace" "Murroon,Parry" "Murruin,Westmoreland" "Murrulebale,Bourke" "Murrumbateman,Murray" "Murrumbidgerie,Lincoln" "Murrumbo,Phillip" "Murrumbogie,Cunningham" "Murrumbucca,Beresford" "Murrungal,Monteagle" "Murrungundie,Lincoln" "Murrurah,Mossgiel" "Murrurundi,Brisbane" "Murtee,Werunda" "Murulla,Brisbane"
"Murwillumbah,Rous" "Muscle,Burnett" "Musgrave,Killara" "Musgrave,Tara" "Mutlow,Tandora" "Mutmutbilly,Argyle" "Muttama,Baradine" "Muttama,Harden" "Myack,Wallace" "Myali,Killara" "Myall,Arrawatta" "Myall,Benarba" "Myall,Denham" "Myall,Gloucester" "Myall,Hawes" "Myall,Killara" "Myall,Macquarie" "Myall,Murchison" "Myall,Richmond" "Myall,Townsend"
"Myall Camp,Narromine" "Myall Cowall,Flinders" "Myall Hollow,Jamison" "Myalla,Burnett" "Myalla,Wallace" "Myalla,Yancowinna" "Myallwirrie,Denham" "Myamyn,Franklin" "Mycotha,Boyd" "Mylatchie,Taila" "Mylora,Harden" "Myra,Hawes" "Myrabluan,Brisbane" "Myrtle,Hunter" "Myrtle,Richmond" "Mythe,Perry" "Nacki Nacki,Wynyard" "Nadbuck,Tandora" "Nadbuck,Windeyer" "Nadbuck,Yancowinna"
"Nadgigomar,Argyle" "Nagora,Bligh" "Nalbaugh,Auckland" "Nalim,Windeyer" "Nallam,Cadell" "Nallam,Townsend" "Naloira,Menindee" "Nalticomebee,Landsborough" "Naman,Gowen" "Nambucca,Raleigh" "Nambucurra,Perry" "Namoi,Darling" "Nanami,Ashburnham" "Nanangroe,Buccleuch" "Nanda,Perry" "Nandabah,Richmond" "Nandewar,Darling" "Nandi,Gowen" "Nandoura,Bligh" "Nandum,Waljeers"
"Nanegai,Clarence" "Nanga,Wentworth" "Nangahrah,Darling" "Nangar,Ashburnham" "Nangerybone,Flinders" "Nangunia,Denison" "Nangus,Clarendon" "Nangutyah,Manara" "Nania,Perry" "Nanima,Bligh" "Nanima,Forbes" "Nanima,Murray" "Nantomoko,Poole" "Nap Nap,Caira" "Napier,Bathurst" "Napier,Buccleuch" "Napier,Napier" "Napier,Urana" "Napier,Wallace" "Naradhan,Dowling"
"Naradhun,Nicholson" "Naradin,Yancowinna" "Narahquong,Caira" "Narangarie,Napier" "Narara,Northumberland" "Narden,Dowling" "Nardoo,Evelyn" "Nardoo,Flinders" "Nardoo,Narran" "Nardoo,Thoulcanna" "Nardoo,Townsend" "Nardoo,Ularara" "Narellan,Cumberland" "Narira,Dampier" "Narnumpy,Yantara" "Narooma,Dampier" "Narra Narra Wa,Goulburn" "Narrabarba,Auckland" "Narrabeen,Cumberland" "Narrabone,Gregory"
"Narrabri,Nandewar" "Narraburra,Bland" "Narragal,Gordon" "Narragamba,Bligh" "Narragan,Cowper" "Narragon,Gregory" "Narragudgil,Bland" "Narralin,Franklin" "Narrallen,Monteagle" "Narrama,Canbelego" "Narrama,Townsend" "Narran,Finch" "Narran,Lincoln" "Narran,Yancowinna" "Narrandera,Cooper" "Narrandool,Narran" "Narrangarril,Argyle" "Narrangullen,Cowley" "Narrar,Oxley" "Narratigah,Leichhardt"
"Narratoola,Townsend" "Narrawa,King" "Narrawall,Benarba" "Narrawidgery,Waradgery" "Narri,Robinson" "Narriah,Cooper" "Narriah,Dowling" "Narromine,Narromine" "Narromine,Oxley" "Narrow Plains,Denison" "Narrowa,Yungnulgra" "Narroweema,Ewenmar" "Narumerpy,Ularara" "Narwarre,Yanda" "Nattai,Camden" "Nattery,Argyle" "Nattung,Cowley" "Natue,Waljeers" "Naunton,Cooper" "Navina,Clyde"
"Naylor,Hawes" "Nea,Pottinger" "Neargo,Benarba" "Nearroongaroo,Wakool" "Nebea,Leichhardt" "Nedgera,Leichhardt" "Neerim,Townsend" "Neible,Napier" "Neila,Forbes" "Neiley,Canbelego" "Neilpo,Wentworth" "Neinby,Gregory" "Neinby,Leichhardt" "Nekarboo,Booroondarra" "Nekarboo,Woore" "Nelanglo,King" "Nelgowrie,Leichhardt" "Nelia,Perry" "Nelia Gaari,Tandora" "Nelia Gaari,Young"
"Nellys Springs,Gunderbooka" "Nellywanna,Franklin" "Nelson,Cumberland" "Nelson,Narromine" "Nelson,Wellesley" "Nelungalong,Ashburnham" "Nemina,Cowper" "Nemingha,Parry" "Neobine,Nicholson" "Neon,Ularara" "Nepean,Cook" "Nepickallina,Courallie" "Nerang,Waradgery" "Nerang Cowal,Gipps" "Nerobingabla,Brisbane" "Nerong,Gloucester" "Nerrada,Mossgiel" "Nerrigundah,Dampier" "Nerrimunga,Argyle" "Netallie,Young"
"Nettlegoe,Menindee" "Neurea,Gordon" "Never Never,Clarke" "Never Never,Phillip" "Never Never,Raleigh" "Nevertire,Oxley" "Neville,Bathurst" "Neville,Drake" "New Valley,Hardinge" "Newbold,Gresham" "Newcastle,Benarba" "Newcastle,Northumberland" "Newcome,Livingstone" "Newfoundland,Landsborough" "Newham,King" "Newland,Killara" "Newland,Thoulcanna" "Newman,Baradine" "Newry,Darling" "Newry,Raleigh"
"Newrybar,Rous" "Newstead,Gough" "Newton Boyd,Gresham" "Nialia,Tara" "Nicholson,Caira" "Nidgerie,Gunderbooka" "Nidgery,Cowper" "Niemur,Wakool" "Nimbia,Leichhardt" "Nimbin,Rous" "Nimbo,Buccleuch" "Nimming,Caira" "Nimmitabel,Wellesley" "Nimmo,Wallace" "Ningadhun,Nandewar" "Ningear,Leichhardt" "Ninia,Gregory" "Ninmegate,Narran" "Nintie,Mossgiel" "Nirranda,Canbelego"
"Nocoleche,Ularara" "Nocotunga,Delalah" "Nombi,Pottinger" "Nombinnie,Blaxland" "Noona,Courallie" "Noonah,Benarba" "Noonbah,Gregory" "Noonbar,Leichhardt" "Noonthorangee,Mootwingee" "Noora,Benarba" "Noorong,Wakool" "Nootumbulla,Mootwingee" "Norrong,Argyle" "North Barraba,Darling" "North Bellingen,Raleigh" "North Bolaro,Cooper" "North Bourke,Gunderbooka" "North Bringagee,Sturt" "North Casino,Rous" "North Codrington,Rous"
"North Colah,Cumberland" "North Conargo,Townsend" "North Cowl,Wentworth" "North Creek,Raleigh" "North Currabunganung,Townsend" "North Deniliquin,Townsend" "North Gunambill,Urana" "North Gundagai,Clarendon" "North Hyandra,Blaxland" "North Lismore,Rous" "North Moonbria,Townsend" "North Mundonah,Taila" "North Nullamanna,Arrawatta" "North Peak,Blaxland" "North Uardry,Sturt" "North Wagga Wagga,Clarendon" "North Zara,Townsend" "Northcote,Bourke" "Northcote,Gregory" "Norton,Vernon"
"Norway,Westmoreland" "Nowendoc,Hawes" "Nowland,Clarke" "Nowley,Jamison" "Nowong,Taila" "Nowra,St Vincent" "Nowranie,Urana" "Nuable,White" "Nuandle,Hardinge" "Nubba,Harden" "Nubrigyn,Wellington" "Nuccalo,Perry" "Nugal,Leichhardt" "Nulla Nulla,Dudley" "Nulla Nulla,Yungnulgra" "Nullama,Gresham" "Nullamanna,Arrawatta" "Nullawarra,Canbelego" "Nullawong,Caira" "Nullica,Auckland"
"Nullo,Hunter" "Nullo,Phillip" "Nullum,Rous" "Nullum,Wakool" "Nulty,Gunderbooka" "Numbaa,St Vincent" "Numbla,Wallace" "Numbugga,Auckland" "Numby,King" "Numby Numby,Benarba" "Numeralla,Beresford" "Nummo,Barrona" "Numurkah,Cowper" "Nundi,Jamison" "Nundialla,Camden" "Nundle,Parry" "Nundrower,Wentworth" "Nunga Nunga,Burnett" "Nungar,Wallace" "Nungatta,Auckland"
"Nungo,Ularara" "Nunnagoyt,Wakool" "Nurathulla,Cowper" "Nurenmerenmong,Selwyn" "Nurung,Harden" "Nyanda,Waljeers" "Nyang,Wakool" "Nyangay,Townsend" "Nymagee,Mouramba" "Nymboida,Fitzroy" "Nyngan,Oxley" "Nyngan,Robinson" "Nyrang,Ashburnham" "Oakes,Raleigh" "Oakleigh,Cowper" "Oakley,Bathurst" "Oakvale,Cowper" "Oakwood,Gresham" "Oallen,Argyle" "Oban,Clarke"
"Oberne,Wynyard" "Oberon,Flinders" "Oberon,Westmoreland" "Oberwells,Manara" "Obley,Gordon" "Obley,Narromine" "O'brien,Sturt" "Odonnell,Thoulcanna" "Officer,Townsend" "Ogilvie,Drake" "Ogro,Wentworth" "Ogunbil,Parry" "Ohio,Vernon" "Oldbuck,Westmoreland" "Oldcastle,Durham" "Olive,Tongowoko" "Oliver,Cowper" "Ollalulla,Murray" "Ollera,Hardinge" "Olney,King"
"Olney,Northumberland" "Omadale,Durham" "Omura,Delalah" "Omura,Yantara" "Oneida,Blaxland" "Onslow,Beresford" "Oolambeyan,Boyd" "Ooma,Forbes" "Ooranook,Auckland" "Oorundunby,Vernon" "Ootootwa,Tara" "Ootoowa,Windeyer" "Opal,Culgoa" "Ophara,Yancowinna" "Oporto,Wentworth" "Opton,King" "Orandelbinia,Gowen" "Orange,Bathurst" "Orange,Wellington" "Orara,Fitzroy"
"Orara,Tara" "Orara,Windeyer" "Oreel,Benarba" "Oreel,Jamison" "Oreen,Dudley" "Oregon,Burnett" "Orion,Canbelego" "Ormond,Taila" "Ormonde,Kennedy" "Oronmear,Murray" "Orr,Baradine" "Orr,Evelyn" "Orr,White" "Osaca,Delalah" "Osaca,Ularara" "Osborne,Bathurst" "Osborne,Denison" "Osborne,Hume" "Osborne,Mitchell" "Osborne,Urana"
"Ossory,Kennedy" "Otako,Barrona" "Ottley,Burnett" "Oura,Clarendon" "Oural,Leichhardt" "Ourendumbee,Boyd" "Ourimbah,Northumberland" "Ournie,Selwyn" "Ovingham,Northumberland" "Oxley,Brisbane" "Oxley,Cooper" "Oxley,Cowper" "Oxley,Gordon" "Oxley,Macquarie" "Oxley,Waljeers" "Oxley,Waradgery" "Oxley North,Cunningham" "Oxley South,Cunningham" "Pabral,Cowley" "Packsaddle,Evelyn"
"Paddington,Booroondarra" "Pagan,Denham" "Page,Brisbane" "Paika,Caira" "Paine,Stapylton" "Paka,Gunderbooka" "Paldrumata,Yantara" "Palerang,Murray" "Paleranga,Stapylton" "Paleroo,Murchison" "Palinor,Windeyer" "Palinyewah,Wentworth" "Palisthan,Cunningham" "Pallal,Murchison" "Palmer,Gunderbooka" "Palmer,Townsend" "Palmer,Urana" "Palmer,Waradgery" "Palmerston,Beresford" "Palmerston,Macquarie"
"Palmyra,Mossgiel" "Palomorang,Hunter" "Pamamaroo,Tandora" "Pambula,Auckland" "Pampara,Yungnulgra" "Pan Ban,Perry" "Pangee,Flinders" "Pangee,Mouramba" "Pangee Creek,Flinders" "Pangunya,Yanda" "Panton,Dudley" "Papekura,Franklin" "Papotoitoi,Mossgiel" "Papperton,Narran" "Pappinbarra,Macquarie" "Para,Wentworth" "Paradise,Evelyn" "Paradise,Gough" "Paradise,Waradgery" "Paradise,Werunda"
"Paradise,Young" "Paradise East,Waradgery" "Paradise North,Gough" "Parailla,Cowper" "Paramellowa,Courallie" "Paringi,Menindee" "Paringi,Wentworth" "Park,Brisbane" "Park,Taila" "Parker,Caira" "Parker,Nicholson" "Parkes,Ashburnham" "Parkes,Gough" "Parkes,Hawes" "Parkes,Killara" "Parkes,White" "Parkes,Young" "Parkhurst,Burnett" "Parkin,Fitzgerald" "Parkungi,Yungnulgra"
"Parmiduan,Leichhardt" "Parnell,Buckland" "Parnell,Hunter" "Paroo,Barrona" "Paroo,Irrara" "Paroo,Killara" "Paroo Plains,Irrara" "Parooingee,Ularara" "Parquin,Wakool" "Parr,Hunter" "Parrabel,Dudley" "Parry,Hunter" "Parsons,Baradine" "Parsons Hill,Buckland" "Patonga,Northumberland" "Patterson,Cooper" "Patterson,Evelyn" "Patterson,Farnell" "Patterson,Poole" "Patterson,Tandora"
"Patterson,Waradgery" "Patutyah,Booroondarra" "Payera,Culgoa" "Peacock,Buller" "Peacumboul,Courallie" "Pearse,Benarba" "Pearse,Denham" "Pearson,Mitchell" "Pearson,Windeyer" "Pechilba,Tara" "Pee Dee,Dudley" "Peel,Roxburgh" "Peel River Estate,Parry" "Peelborough,Finch" "Pejar,Argyle" "Peka,Ularara" "Pelican Ponds,Irrara" "Pelora,Landsborough" "Pelwalka,Tara" "Pembelgong,Waradgery"
"Penarie,Caira" "Penilui,Yanda" "Penonigia,Irrara" "Pentagon,Gregory" "Pentole,Manara" "Pepperbox,Burnett" "Peppercorn,Buccleuch" "Peppin,Townsend" "Peppora,Mootwingee" "Peppora,Perry" "Pera,Gunderbooka" "Perayambone,Cowper" "Percy,St Vincent" "Perekerten,Wakool" "Pericoe,Auckland" "Pernolingay,Wentworth" "Perricoota,Cadell" "Perry,Inglis" "Perry,Menindee" "Perry,Perry"
"Perth,Clive" "Pessima,Yantara" "Peter,Boyd" "Peters,Wellesley" "Peters,Wellington" "Petersham,Cumberland" "Petita,Fitzgerald" "Pevensey,Wakool" "Pevensey,Waradgery" "Peveril,Young" "Phillip,Hunter" "Phillip,Tara" "Piallamore,Parry" "Piallaway,Buckland" "Pialligo,Murray" "Pially,Benarba" "Piambong,Wellington" "Piambra,Napier" "Pian,Denham" "Pian,Jamison"
"Piangula,Gowen" "Pibbon,Gowen" "Picarbin,Drake" "Pickering,Wellesley" "Picton,Camden" "Picton,Yancowinna" "Pidgerie,Evelyn" "Piedmont,Murchison" "Pier Pier,Leichhardt" "Pikapene,Drake" "Pilliga,Baradine" "Pimlico,Rous" "Pimpampa,Waradgery" "Pimpara,Waljeers" "Pinaroo,Poole" "Pinbeyan,Buccleuch" "Pindari,Arrawatta" "Pine,Finch" "Pinegobla,Finch" "Pines,Perry"
"Piney Range,Hume" "Piney Ridge,Urana" "Pingally,Evelyn" "Pingbilly,Evelyn" "Pingunnia,Mossgiel" "Pink Hills,Cowper" "Pinnelco,Menindee" "Pinpira,Evelyn" "Pinpira,Farnell" "Pinpira,Mootwingee" "Piper,Roxburgh" "Piribil,Hunter" "Pirillie,Gunderbooka" "Pirillie,Irrara" "Pitarpunga,Caira" "Pitt Town,Cumberland" "Pittenweem,Mossgiel" "Plevna,Cunningham" "Plevna,Drake" "Plevna,Mossgiel"
"Plumbolah,Finch" "Pocupar,Buller" "Poganbilla,Clarke" "Poimba,Wentworth" "Pokataroo,Denham" "Pokolbin,Northumberland" "Poli,Franklin" "Polia,Windeyer" "Pollen,Caira" "Polo,Gunderbooka" "Pomany,Phillip" "Pombra,Perry" "Pomeroy,Argyle" "Pondery,Wentworth" "Ponsonby,Bathurst" "Ponto,Gordon" "Poon Boon,Wakool" "Pooncaira,Perry" "Poopelloe,Werunda" "Popica,Tara"
"Popica South,Tara" "Popilta,Windeyer" "Popio,Windeyer" "Popong,Wallace" "Poppong,Hunter" "Popran,Northumberland" "Porcupine,Perry" "Porialla,Irrara" "Porirua,Ularara" "Porthole,Cadell" "Power,Culgoa" "Power,Windeyer" "Powerpa,Richmond" "Powheep,Townsend" "Premer,Pottinger" "Preston,King" "Price,Phillip" "Pringle,Courallie" "Pringle,Inglis" "Pringle,Murchison"
"Pringle,Pottinger" "Priory,Mouramba" "Priory,Robinson" "Priory Plains,Mouramba" "Prospect,Cumberland" "Prospect,Macquarie" "Prospero,Durham" "Prunella,Perry" "Prungle,Taila" "Puah,Wakool" "Pucka,Drake" "Puckawidgee,Townsend" "Puckinevvy,Boyd" "Puen Buen,Auckland" "Puggoon,Bligh" "Puhoi,Drake" "Pulacarra,Killara" "Pulchra,Yungnulgra" "Pulganbar,Drake" "Pullabooka,Gipps"
"Pullega,Urana" "Pulletop,Cooper" "Pulletop,Goulburn" "Pulletop,Mitchell" "Pulligal,Gipps" "Pullingarwarina,Gregory" "Pulpa,Wentworth" "Pulpulla,Yanda" "Pulputah,Booroondarra" "Pungmallee,Caira" "Pungulgui,Townsend" "Punnyakunya,Evelyn" "Purdanima,Townsend" "Purfleet,Bathurst" "Purlewaugh,Napier" "Purnamoota,Yancowinna" "Purranga,Fitzgerald" "Purrorumba,Murray" "Puthawarrie,Cowper" "Putta,Menindee"
"Putty,Hunter" "Pybolee,Caira" "Pysant,Livingstone" "Quabothoo,Clyde" "Quabothoo,Gregory" "Quambatook,Sturt" "Quambone,Gregory" "Quamby,Yungnulgra" "Quanda,Flinders" "Quanda Quanda,Leichhardt" "Quandary,Bourke" "Quandong,Canbelego" "Quandong,Gowen" "Quandong,Townsend" "Quandong,Waradgery" "Quantambone,Narran" "Quat Quatta,Hume" "Queanbeyan,Murray" "Queebun,Rous" "Queega,Finch"
"Queens Lake,Macquarie" "Queensborough,Napier" "Queerbri,Jamison" "Quegobla,Baradine" "Questa,Fitzgerald" "Quialigo,Argyle" "Quiamong,Townsend" "Quianderry,Caira" "Quidong,Wellesley" "Quiera,St Vincent" "Quilbone,Gregory" "Quin,Fitzgerald" "Quinn,White" "Quinyambi,Evelyn" "Quirindi,Buckland" "Quondong,Flinders" "Quondong,Gregory" "Quondong,Gunderbooka" "Quondong,Tandora" "Quonmoona,Leichhardt"
"Quorrobolong,Northumberland" "Qwyarigo,Clarence" "Rabnor,King" "Rainding,Taila" "Raleigh,Raleigh" "Ralfe,Macquarie" "Ramleh,Windeyer" "Rampsbeck,Clarke" "Ramsay,Bourke" "Ramsay,Yanda" "Rand,Hume" "Randall,Cowper" "Rangers Valley,Gough" "Rangira,Nandewar" "Rangiri,Darling" "Ranken,Fitzgerald" "Rankin,Booroondarra" "Rankin,Rankin" "Rankin,Waradgery" "Rankin,Yanda"
"Rantyga,Menindee" "Raubelle,Wakool" "Ravensworth,Durham" "Red Gilgais,Flinders" "Red Rock,Clarence" "Redan,Yancowinna" "Redbank,Arrawatta" "Redbank,Cowper" "Redbank,Gordon" "Redbank,Macquarie" "Redbank,Nicholson" "Redcliffe,Kennedy" "Reddin,Killara" "Regan,Flinders" "Regent,Dowling" "Reid,Buller" "Repton,Livingstone" "Restdown,Mouramba" "Retreat,Georgiana" "Retreat,Inglis"
"Reynolds,Denham" "Rhyana,Argyle" "Richardson,Clyde" "Richardson,Cowper" "Richardson,Lincoln" "Richmond,Clarence" "Richmond,Drake" "Richmond,Hume" "Richmond,Richmond" "Ricketson,Townsend" "Rider,Murchison" "Ridge,Clyde" "Rigney,Clarke" "Riley,Richmond" "Ringrose,Werunda" "Rivers,Beresford" "Robe,Yancowinna" "Roberts,Denham" "Roberts,Finch" "Robertson,Bourke"
"Robertson,Buller" "Robertson,Cowper" "Robertson,Gough" "Robertson,White" "Robinson,Mouramba" "Robinson,Tara" "Robinson,Young" "Roche,Gordon" "Rochford,Robinson" "Rock Hill,Cook" "Rock Vale,Clive" "Rockley,Georgiana" "Rockvale,Clarke" "Rocky Glen,Evelyn" "Rocky Hole,Burnett" "Rocky Ponds,Gordon" "Rodd,Pottinger" "Rodgers,Drake" "Rodham,Drake" "Rodney,Wellesley"
"Roeta,Franklin" "Roma,Wentworth" "Romner,King" "Romney,Clive" "Ronald,Caira" "Ronald,Townsend" "Rookery,Caira" "Rooty Hill,Cumberland" "Rosamond,Durham" "Rose,Arrawatta" "Rose,Finch" "Rose Valley,Beresford" "Roseberg,Bathurst" "Roseberry,Rous" "Roset,Mouramba" "Ross,Cowper" "Ross,Fitzroy" "Ross,Gough" "Ross,Urana" "Rossi,Monteagle"
"Rosstrevor,Yungnulgra" "Rothbury,Northumberland" "Rotherwood,Bligh" "Roto,Blaxland" "Rouchel,Durham" "Roumalla,Hardinge" "Round Hill,Barrona" "Round Hill,Hume" "Round Hill,Selwyn" "Rouse,Bligh" "Rouse,Wellington" "Rowan,Durham" "Rowan,Wynyard" "Rowena,Mootwingee" "Rowland,Beresford" "Rowley,Hawes" "Rowley,Macquarie" "Royinn,Parry" "Ruby,Buller" "Ruby,Oxley"
"Rugby,King" "Rugby,Northumberland" "Rumker,Phillip" "Rundle,Baradine" "Runker,Yanda" "Runnymede,Cowper" "Runnymede,Rous" "Rusden,Gough" "Rusden,Murchison" "Rusden,Nandewar" "Rushbrook,Hawes" "Rushforth,Clarence" "Russell,Arrawatta" "Russell,Burnett" "Russell,Caira" "Russell,Cowper" "Russell,Durham" "Russell,Hardinge" "Russell,Kennedy" "Russell,Nicholson"
"Russell,Waradgery" "Rutherford,Waradgery" "Rutherford,Yungnulgra" "Rutland,Dowling" "Rutledge,Oxley" "Ryan,Hume" "Ryanda,Clarke" "Rylstone,Roxburgh" "Saburra,Franklin" "Sadlier,Livingstone" "Sahara,Kilfera" "Sahara East,Kilfera" "Saladin,Mootwingee" "Salamagundia,Blaxland" "Salisbury,Fitzgerald" "Salisbury,Kennedy" "Salisbury,Rankin" "Salisbury,Sandon" "Salisbury,Wakool" "Salisbury,Yanda"
"Salt Lake,Wentworth" "Salt Lake,Yantara" "Saltash,Sandon" "Saltwater,Pottinger" "Salway,Vernon" "Samuel,Arrawatta" "Sandilands,Drake" "Sandon,Sandon" "Sandridge,Gregory" "Sandy,Woore" "Sandy Creek,Cooper" "Sandy Creek,Hardinge" "Sandy Creek,Mitchell" "Sandy Ridges,Hume" "Sanpah,Evelyn" "Sara,Gresham" "Sargood,Denison" "Sarsfield,Kennedy" "Sassafras,St Vincent" "Satiara,Cowper"
"Saumarez,Sandon" "Savernake,Denison" "Savoy,Durham" "Sawers,Narran" "Schofield,Hawes" "Scholefield,Mossgiel" "Scone,Brisbane" "Scone,Gough" "Scope,Clarence" "Scotia,Tara" "Scott,Evelyn" "Scott,Finch" "Scott,Gough" "Scott,Inglis" "Scott,Irrara" "Scott,Mouramba" "Scott,Parry" "Scott,Selwyn" "Scott,Wentworth" "Scott,Yantara"
"Seaham,Durham" "Sebastopol,Clarendon" "Sebastopol,Cunningham" "Sebastopol,Waljeers" "Sebastopol,Yancowinna" "Sedgefield,Durham" "Seeley,Clarke" "Selwyn,Selwyn" "Selwyn,Wynyard" "Sentinel,Yancowinna" "Serpentine,Clarke" "Service,Killara" "Severn,Arrawatta" "Severn,Gough" "Seymour,St Vincent" "Seymour,Wallace" "Shadforth,Bathurst" "Shannon,Fitzroy" "Shannon,Richmond" "Shasta,Sandon"
"Shaw,Bathurst" "Shea,Fitzroy" "Shelving,Vernon" "Shenandoah,Mouramba" "Shenstone,Durham" "Sherlock,Beresford" "Sherwood,Fitzroy" "Sherwood,Georgiana" "Sherwood,Rous" "Sherwyn,Hume" "Shoalhaven,Dampier" "Silent Grove,Clive" "Silistria,Tandora" "Silva,Tongowoko" "Simpson,Phillip" "Sims Gap,Cooper" "Simson,Waljeers" "Simson,Waradgery" "Sinclair,Cowper" "Sinclair,Waradgery"
"Singapoora,Burnett" "Single,Benarba" "Single,Hardinge" "Singoramba,Landsborough" "Singorambah,Boyd" "Sistova,Drake" "Six Brothers,Hunter" "Skinner,Hardinge" "Smart,Courallie" "Snowy,Clarke" "Sobraon,Sandon" "Sofala,Roxburgh" "Solferino,Kilfera" "Somers,Bathurst" "Somerset,Kennedy" "Somerton,Parry" "Somerville,Finch" "Soudan,Yancowinna" "South Ballina,Richmond" "South Bellingen,Raleigh"
"South Borambil,Gipps" "South Burke,Inglis" "South Casino,Richmond" "South Codrington,Richmond" "South Colah,Cumberland" "South Condobolin,Gipps" "South Deniliquin,Townsend" "South Gulgo,Gipps" "South Gundagai,Wynyard" "South Gundurimba,Rous" "South Junee,Clarendon" "South Lismore,Rous" "South Marowie,Nicholson" "South Micabil,Gipps" "South Peak,Blaxland" "South Thule,Blaxland" "South Wagga Wagga,Wynyard" "South Yackerboon,Blaxland" "South Zara,Townsend" "Southampton,Clarence"
"Southend,Cumberland" "Southgate,Clarence" "Speedwell,Westmoreland" "Speewa,Wakool" "Spencer,Manara" "Spencer,Northumberland" "Spencer,Taila" "Spinifex,Windeyer" "Spring Creek,Lincoln" "Springbrook,Gresham" "Springfield,Booroondarra" "Springfield,Pottinger" "Springmount,Sandon" "St Albans,Northumberland" "St Andrew,Cumberland" "St Andrew,Waljeers" "St Andrews,Arrawatta" "St Aubins,Durham" "St Clair,Vernon" "St Columba,Westmoreland"
"St David,Bathurst" "St George,Cumberland" "St George,Hardinge" "St George,St Vincent" "St James,Cumberland" "St John,Cumberland" "St Julian,Durham" "St Lawrence,Cumberland" "St Leonard,Vernon" "St Luke,Cumberland" "St Matthew,Cumberland" "St Monans,Mossgiel" "St Pauls,Caira" "St Peter,Cumberland" "St Philip,Cumberland" "Stack,Burnett" "Stackpoole,Nicholson" "Stag,Murchison" "Stanaforth,Townsend" "Stanbridge,Cooper"
"Stanford,Northumberland" "Stanhope,Cowper" "Stanhope,Durham" "Stanhope,Gregory" "Stanley,Burnett" "Stanley,Cooper" "Stanley,Farnell" "Stanley,Gresham" "Stanley,Kennedy" "Stanley,Rankin" "Stanley,Urana" "Stannard,Beresford" "Stanton,Clarke" "Stapylton,Stapylton" "Stawell,Cowper" "Steel,Livingstone" "Stephen,Tara" "Stephen,Yancowinna" "Stephenson,Burnett" "Stewart,Fitzroy"
"Stewart,Killara" "Stewart,Macquarie" "Stewart,Poole" "Stewart,Roxburgh" "Stitt,Hume" "Stockinbingal,Bland" "Stockrington,Northumberland" "Stockton,Gloucester" "Stoke,Georgiana" "Stonehenge,Clyde" "Stonehenge,Gough" "Stony Ridge,Thoulcanna" "Stonybatter,Hardinge" "Stowe,Northumberland" "Stowell,Gloucester" "Strachan,Gough" "Strahorn,Kennedy" "Stratford,Yancowinna" "Strathaird,Argyle" "Strathbogie,Gough"
"Strathbogie North,Gough" "Strathdon,Cook" "Strathearn,Brisbane" "Strathearn,Clive" "Stratheden,Rous" "Strathmore,Burnett" "Strathorn,Gordon" "Strathspey,Buller" "Stroud,Gloucester" "Stuart,Burnett" "Stuart,Clarence" "Stuart,Cowper" "Stuart,Dudley" "Stubbo,Bligh" "Sturt,Auckland" "Sturt,Canbelego" "Sturt,Farnell" "Sturt,Gresham" "Sturt,Hunter" "Sturt,Poole"
"Sturt,Tandora" "Sturt,Wentworth" "Sturts Meadows,Mootwingee" "Styx,Clarke" "Styx,Vernon" "Sumner,Urana" "Surbiton,Livingstone" "Sussex,Leichhardt" "Sutherland,Cumberland" "Sutherland,Gunderbooka" "Sutherland,Young" "Sutton,Gloucester" "Sutton Forest,Camden" "Suttor,Wellington" "Swamp Oak,Arrawatta" "Swanbrook,Gough" "Swanvale,Gough" "Swatchfield,Westmoreland" "Swinton,Hardinge" "Synnot,Nicholson"
"Tabbimoble,Richmond" "Tabbita,Cooper" "Tabbita,Sturt" "Tabbita North,Cooper" "Table Top,Farnell" "Table Top,Selwyn" "Tabrabucca,Roxburgh" "Tabratong,Kennedy" "Tabratong,Oxley" "Tabulam,Drake" "Tackinbri,Burnett" "Tacklebang,Ewenmar" "Taemas,Cowley" "Tahrone,Leichhardt" "Taila,Taila" "Tailby,Gregory" "Takeiwa,Yantara" "Tala,Benarba" "Tala,Caira" "Talaa,Gunderbooka"
"Talagandra,Murray" "Talawa,Finch" "Talawahl,Gloucester" "Talawanta,Narran" "Talbingo,Buccleuch" "Talbragar,Bligh" "Talgong,Flinders" "Talingaboolba,Kennedy" "Tallabung,Forbes" "Tallaganda,St Vincent" "Tallama,Baradine" "Tallandra,Killara" "Tallarara,Killara" "Tallawang,Bligh" "Tallawudjah,Fitzroy" "Tallebung,Blaxland" "Tallegar,Leichhardt" "Tallowal,St Vincent" "Talluba,Baradine" "Talmalmo,Goulburn"
"Talmo,Harden" "Talmoi,Courallie" "Taloumbi,Clarence" "Talowla,Landsborough" "Talpee,Caira" "Taltaweira,Ularara" "Talyawalka,Livingstone" "Talyawalka,Werunda" "Talyeale,Thoulcanna" "Talyealye,Irrara" "Tamar,Cadell" "Tamarang,Parry" "Tamarang,Pottinger" "Tambalana,Nicholson" "Tambar,Pottinger" "Tambaroora,Wellington" "Tambua,Robinson" "Tameribundy,Gregory" "Tamworth,Inglis" "Tanban,Dudley"
"Tandore,Tandora" "Tandou,Menindee" "Tangaratta,Parry" "Tangaroo,Wellesley" "Tange,Murchison" "Tangory,Durham" "Tanilogo,Kennedy" "Tanja,Dampier" "Tankarook,Rankin" "Tankie,Kilfera" "Tannabar,Gowen" "Tannabutta,Wellington" "Tannawanda,White" "Tantangara,Wallace" "Tantangera,Murray" "Tantarana,Stapylton" "Tantawanga,Barrona" "Tantawangalo,Auckland" "Tantivy,Fitzgerald" "Tantonan,Cadell"
"Tanyarto,Farnell" "Tapio,Wentworth" "Tara,Blaxland" "Tara,Bourke" "Tara,Inglis" "Tara,Yancowinna" "Tara South,Blaxland" "Tarago,Argyle" "Tarambijal,Gowen" "Taranga,Tara" "Tarangara,Wentworth" "Tararie,Caira" "Taratta,Cunningham" "Tarban,Clive" "Tarcombe,Blaxland" "Tarcoola,Perry" "Tarcoon,Cowper" "Tarcutta,Wynyard" "Tarean,Gloucester" "Taree,Macquarie"
"Tareela,Denham" "Tarlee,Jamison" "Tarlo,Argyle" "Tarmoola,Perry" "Tarpoly,Darling" "Tarrabandra,Ularara" "Tarrabandra,Wellesley" "Tarrabandra,Wynyard" "Tarran,Blaxland" "Tarrawonda,Yantara" "Tarrawong,Waljeers" "Tartarus,Westmoreland" "Tartna,Perry" "Tartoo,Waljeers" "Tataila,Cadell" "Tatala,Culgoa" "Tatham,Richmond" "Tatiara,Yanda" "Tatuali,Wellington" "Taunton,King"
"Tawaggan,Culgoa" "Tawarra,Townsend" "Tayar,Roxburgh" "Taylor,Lincoln" "Taylor,Manara" "Tchelery,Wakool" "Teegarraara,Mootwingee" "Teilta,Farnell" "Tekaara,Irrara" "Teleraree,Gloucester" "Telford,Buckland" "Telford,Caira" "Telinebone,Finch" "Tellaraga,Benarba" "Teltawongee,Mootwingee" "Temi,Brisbane" "Temi,Buckland" "Temoin,Narromine" "Temora,Bland" "Temounga,Woore"
"Tenandra,Bathurst" "Tenandra,Clarendon" "Tenandra,Ewenmar" "Tenandra,Lincoln" "Teni,Baradine" "Tenningerie,Cooper" "Tent Hill,Gough" "Tenterden,Hardinge" "Tenterfield,Clive" "Teperago,Yantara" "Teralba,Northumberland" "Teran,Mouramba" "Terangan,Oxley" "Terania,Rous" "Terarra,Ashburnham" "Terell,Brisbane" "Terembone,Baradine" "Terembone,Leichhardt" "Terewah,Narran" "Teriabola,Narran"
"Teridgerie,Baradine" "Teridgerie,Leichhardt" "Termeil,St Vincent" "Terni,Westmoreland" "Terooble,Oxley" "Terra Walka,Narran" "Terraban,Bligh" "Terrabella,Gordon" "Terrabile,Gowen" "Terragong,Camden" "Terramungamine,Lincoln" "Terranna,Argyle" "Terranora,Rous" "Terrapee,Sturt" "Terrawinda,Napier" "Terrawinda,Yantara" "Terreel,Gloucester" "Terrergee,Courallie" "Terribie,Denham" "Terrigal,Gregory"
"Terry,Franklin" "Terry Hie Hie,Courallie" "Teryawinya,Livingstone" "Teven,Rous" "Texas,Arrawatta" "Texas,Buckland" "Thackaringa,Yancowinna" "Thalaba,Denham" "Thalaba,Georgiana" "Thalaba,Gloucester" "Thalaba,Jamison" "Thalaka,Wakool" "Thanowring,Bland" "Thara,Leichhardt" "The Bluff,Cooper" "The Bluff,Flinders" "The Brothers,Beresford" "The Brothers,Canbelego" "The Brothers,Gough" "The Gap,Gordon"
"The Mole,Gregory" "The Oaks,Caira" "The Oaks,Narromine" "The Overflow,Flinders" "The Peak,Cooper" "The Peak,Wallace" "The Peaks,Buccleuch" "The Peaks,Westmoreland" "The Pines,Canbelego" "The Plains,Oxley" "The Rookery,Mouramba" "The Springs,Gordon" "The Willows,Caira" "Thellangering,Waradgery" "Thellangering West,Waradgery" "Therarbung,Bland" "Therribri,Nandewar" "Thirrang,Wentworth" "Thitto,Wentworth" "Thoko,Wellesley"
"Tholloolaboy,Mossgiel" "Tholobin,Townsend" "Tholoo,Denham" "Thompson,Georgiana" "Thononga,Franklin" "Thoolabool,Killara" "Thoolamagoogi,Mossgiel" "Thoomby,Wentworth" "Thornshope,Roxburgh" "Thornshope,Westmoreland" "Thornton,Gloucester" "Thoulcanna,Delalah" "Thourumble,Rankin" "Thredbo,Wallace" "Three Brothers,Bathurst" "Three Rivers,Wellington" "Throsby,Beresford" "Thuara,Clyde" "Thuddungara,Monteagle" "Thudie,Clyde"
"Thugga,Hume" "Thulabin,Townsend" "Thulama,Narran" "Thule,Blaxland" "Thule,Cadell" "Thulloo,Gipps" "Thumulah,Manara" "Thurat,Westmoreland" "Thurgoon,Townsend" "Thurgoona,Goulburn" "Thurlagoona,Culgoa" "Thurlow,Delalah" "Thurmylae,Culgoa" "Thurnapatcha,Irrara" "Thurralilly,Murray" "Thurrowa,Urana" "Thurungle,Forbes" "Thurungly,Bland" "Thyra,Cadell" "Tia,Vernon"
"Tiabundie,Darling" "Tianjara,St Vincent" "Tiara,Clarke" "Tiara,Vernon" "Tiarri,Mossgiel" "Tibara,Mossgiel" "Tibeaudo,Dowling" "Ticehurst,Mossgiel" "Tichawanta,Clyde" "Tiela,Benarba" "Tienga,Hardinge" "Tigeralba,Yanda" "Til Til,Wentworth" "Tilbuster,Sandon" "Till Till,Manara" "Tillaloo,Benarba" "Tillegra,Durham" "Tillegra,Gloucester" "Tilpa,Cowper" "Tilpa,Killara"
"Tiltabrinna,Yantara" "Tiltagara,Woore" "Tiltao,Wentworth" "Tiltargara,Booroondarra" "Timbarra,Clive" "Timbarra,Drake" "Timboon,Raleigh" "Timbrebongie,Narromine" "Timbumburi,Parry" "Timor,Brisbane" "Timor,Gowen" "Timpunga,Perry" "Tinagroo,Brisbane" "Tinda,Cunningham" "Tindale,Waradgery" "Tindara,Poole" "Tindayrey,Robinson" "Tindeanda,Landsborough" "Tinderra,Yanda" "Tinderry,Beresford"
"Tinebank,Macquarie" "Tingaringi,Wellesley" "Tinkoh,Mossgiel" "Tinkrameanah,Pottinger" "Tinna,Waljeers" "Tinonee,Gloucester" "Tintern,Bathurst" "Tintin,Caira" "Tintinalogy,Livingstone" "Tippereena,Nandewar" "Tiri,Gloucester" "Tirlta,Mootwingee" "Tirranna,Gipps" "Titabaira,Tandora" "Tittara,Taila" "Tittil,Wakool" "Tiverton,Sandon" "Tivy,Wellesley" "Tobin,Cowper" "Tobin,Gunderbooka"
"Tobin,Hawes" "Tobin,Leichhardt" "Toburra,Yanda" "Tocumwal,Denison" "Togalo,Hawes" "Toganmain,Boyd" "Tolarno,Livingstone" "Tolarno,Perry" "Tollagong,Hunter" "Tollingo,Cunningham" "Toloora,Leichhardt" "Tomaga,St Vincent" "Tomalla,Hawes" "Tomalpin,Hunter" "Tomara,Cadell" "Tomaree,Gloucester" "Tombong,Wellesley" "Tomboye,St Vincent" "Tomerong,St Vincent" "Tomimbil,Bligh"
"Tomingley,Narromine" "Tomki,Rous" "Tomorrago,Finch" "Toms Lake,Waljeers" "Toms Point,Sturt" "Tonderburine,Gowen" "Tonga,Hunter" "Tongaboo,Denison" "Tongamba,Gregory" "Tongaroo,Wallace" "Tongbong,Phillip" "Tongo,Brisbane" "Tongowoko,Delalah" "Tongowoko,Tongowoko" "Tongul,Waradgery" "Toogimbie,Waradgery" "Toogong,Ashburnham" "Toolamanang,Wellington" "Tooleybuc,Wakool" "Toolmah,Wakool"
"Toolon,Wakool" "Toolond,Rous" "Tooloom,Buller" "Tooloon,Leichhardt" "Tooloor,Franklin" "Tooma,Delalah" "Tooma,Selwyn" "Toonburra,Fitzgerald" "Tooncurrie,Tongowoko" "Toongcooma,Stapylton" "Toontora,Wentworth" "Toonumbar,Rous" "Toopruck,Waljeers" "Toopuntul,Waradgery" "Toora,Leichhardt" "Toorak,Mossgiel" "Tooralboung,Waljeers" "Toorale,Gunderbooka" "Tooram,Canbelego" "Toorangabby,Cadell"
"Tooranie,Woore" "Toorawandi,Napier" "Tooraweenah,Gowen" "Toorincaca,Livingstone" "Toorong,Caira" "Tooronga,Dowling" "Tootalally,Canbelego" "Toothill,Fitzroy" "Tootool,Mitchell" "Tooyal,Bourke" "Topar,Tandora" "Topi Topi,Gloucester" "Torcobil,Blaxland" "Torowoto,Yantara" "Torrens,Bathurst" "Torrens,Macquarie" "Torrens,Tongowoko" "Torrowangee,Farnell" "Torryburn,Hardinge" "Toryweewha,Denham"
"Toual,Murray" "Touga,St Vincent" "Tougaroo,Selwyn" "Tout,Kennedy" "Towac,Wellington" "Towagal,Clarke" "Towallum,Fitzroy" "Towamba,Auckland" "Towarri,Buckland" "Townday,Finch" "Townsend,Dowling" "Townsend,Nicholson" "Townsend,Wallace" "Towool,Townsend" "Towrang,Argyle" "Towri,Killara" "Towtowra,Narran" "Towweruk,Wakool" "Towyal,Gipps" "Toy,Robinson"
"Trafalgar,Cowper" "Trajere,Ashburnham" "Trangie,Narromine" "Traralgon,Cowper" "Trawalla,Cowper" "Trawalla,Waljeers" "Tresillian,Gunderbooka" "Trethella,Yanda" "Trevethin,Clarendon" "Trevor,Gloucester" "Trewalla,Mossgiel" "Triamble,Wellington" "Trickett,Bourke" "Trida,Mossgiel" "Trielmon,Leichhardt" "Trigalana,Gipps" "Trigalong,Bland" "Trigalong,Dowling" "Trigamon,Arrawatta" "Trinidad,Vernon"
"Trinkey,Pottinger" "Trinkey,Stapylton" "Tritton,Canbelego" "Troubalgie,Ashburnham" "Trowan,Oxley" "Trudgett,Wellington" "Truganini,Mootwingee" "Trundle,Cunningham" "Tubba,Cowper" "Tubbamurra,Clarke" "Tubble Gah,Stapylton" "Tubbo,Boyd" "Tubbul,Bland" "Tucinyah,Mootwingee" "Tucka Tucka,Stapylton" "Tuckerbil,Cooper" "Tuckinya,Perry" "Tuckland,Lincoln" "Tuckombil,Rous" "Tuckurimba,Rous"
"Tudor,Durham" "Tuena,Georgiana" "Tuggerabach,Dowling" "Tuggerah,Northumberland" "Tuggeranong,Murray" "Tugima,Wentworth" "Tulcumba,Nandewar" "Tulla Mullen,Pottinger" "Tulladunna,Jamison" "Tullin Tulla,Burnett" "Tulloch,Clyde" "Tulloona,Stapylton" "Tully,Gunderbooka" "Tully,Waradgery" "Tully,Yungnulgra" "Tulrigo,Wentworth" "Tumbarumba,Selwyn" "Tumbleton,Bland" "Tumorrama,Buccleuch" "Tumudgery,Townsend"
"Tumut,Wynyard" "Tun Cooey,Stapylton" "Tuncurry,Gloucester" "Tungara,Fitzgerald" "Tungo,Fitzgerald" "Tunis,Baradine" "Tunnabidgee,Wellington" "Tunstall,Rous" "Tupa,Hunter" "Tuppulmummi,Cowper" "Turee,Bligh" "Turee,Gunderbooka" "Turi,Parry" "Turill,Bligh" "Turner,Booroondarra" "Turner,Rankin" "Turon,Roxburgh" "Turora,Wakool" "Turrallo,Argyle" "Turramia,Denison"
"Turrawah,Benarba" "Turrawan,White" "Turrawarra,Murchison" "Turribung,Narromine" "Turville,Fitzroy" "Tutawa,Finch" "Tutty,Killara" "Tuyerunby,Caira" "Twynam,Selwyn" "Twynam,Waradgery" "Tyagong,Monteagle" "Tyalgum,Rous" "Tycannah,Courallie" "Tycawina,Benarba" "Tygalgah,Rous" "Tyndale,Clarence" "Tyngin,Yanda" "Tyngnynia,Irrara" "Tyraman,Durham" "Tyrie,Narromine"
"Tyringham,Fitzroy" "Tyrl Tyrl,Georgiana" "Tyrone,Brisbane" "Tyrrell,Benarba" "Tyson,Caira" "Tyson,Waljeers" "Tywong,Wynyard" "Uabba,Dowling" "Uarbry,Bligh" "Uardry,Sturt" "Uargon,Gowen" "Ucombe,Fitzroy" "Udah,Gipps" "Uffington,Durham" "Ugalong,Gipps" "Ugobit,Boyd" "Ukerbarley,Baradine" "Uki,Clyde" "Uki,Wentworth" "Ulah,Finch"
"Ulalu,Blaxland" "Ulamambri,Gowen" "Ulambie,Baradine" "Ulambong,Blaxland" "Ulambong,Dowling" "Ulan,Bligh" "Ulandra,Clarendon" "Ularbie,Leichhardt" "Uliara,Landsborough" "Ulinda,Napier" "Ulladulla,St Vincent" "Ullollie,Yungnulgra" "Ulmarra,Clarence" "Ulmarrah,Wellington" "Ulong,Wentworth" "Ulonga,Waradgery" "Ulourie,Clyde" "Ultimo,Young" "Ulumba,Blaxland" "Ulundry,Leichhardt"
"Ulungra,Gowen" "Ulupna,Denison" "Umalee,Manara" "Umang,Flinders" "Umangla,Ewenmar" "Umbango,Wynyard" "Umberumberka,Yancowinna" "Umbiella,Roxburgh" "Umbri,Benarba" "Umburra,Cowley" "Umphelby,Mossgiel" "Umutbee,Wynyard" "Uncana,Yantara" "Undeathi,Livingstone" "Undelcarra,Killara" "Underbank,Durham" "Underbank,Gloucester" "Undercliffe,Buller" "Undoo,Beresford" "Ungarie,Gipps"
"Unkya,Raleigh" "Unumgar,Rous" "Upper Tarlo,Argyle" "Urabrible,Gowen" "Uralgurra,Dudley" "Uralla,Sandon" "Urambie,Blaxland" "Urambie East,Blaxland" "Urana,Urana" "Uranaway,Blaxland" "Uranbah,Benarba" "Uranbene,Dampier" "Urandool,Finch" "Urangeline,Urana" "Urangera,Pottinger" "Urania,Gresham" "Uranquinty,Mitchell" "Urawilkie,Baradine" "Urawilkie,Leichhardt" "Urayarra,Cowley"
"Urella,Delalah" "Uri,Boyd" "Urialla,Murray" "Uriamukki,Hawes" "Urilla,Ularara" "Uringalla,Argyle" "Urisino,Ularara" "Urntah,Windeyer" "Urobula,Ewenmar" "Urolie,Mouramba" "Uroly,Boyd" "Urotah,Sandon" "Urugalah,Franklin" "Utah,Evelyn" "Utah,Tara" "Uteeara,Barrona" "Valencia,Dowling" "Valley Valley,Raleigh" "Vane,Durham" "Vant,Hawes"
"Vautier,Goulburn" "Vautin,Raleigh" "Vaux,Durham" "Veech,Gordon" "Vega,Canbelego" "Veness,Darling" "Venterman,Cowley" "Vere,Northumberland" "Vernon,Dudley" "Vernon,Macquarie" "Vernon,Parry" "Verulam,Gloucester" "Vicars,Burnett" "Vickery,Jamison" "Vickery,Nandewar" "Victor,Blaxland" "Victoria,Auckland" "Victoria,Livingstone" "Victoria,Selwyn" "Victoria,Tara"
"Victoria,Yancowinna" "Vieta,Franklin" "Vincent,Mitchell" "Viney Creek,Gloucester" "Vittoria,Bathurst" "Vivier,Arrawatta" "Vulcan,Westmoreland" "Waalimma,Auckland" "Waarbilla,Bland" "Waayourigong,Forbes" "Wadbilliga,Dampier" "Wadbilliga West,Dampier" "Waddaduri,Boyd" "Wadden,Benarba" "Waddi,Boyd" "Waddiwong,Leichhardt" "Wadell,Cowper" "Wagara,Buccleuch" "Wagga,Blaxland" "Wagonga,Dampier"
"Wagra,Cowper" "Wagra,Goulburn" "Wagstaff,Gordon" "Wahgunyah,Denison" "Wahwoon,Waradgery" "Waihou,Fitzroy" "Waiko,Mossgiel" "Waka,Poole" "Wakool,Wakool" "Walberton,Roxburgh" "Walbrook,Georgiana" "Walbundrie,Hume" "Walcha,Leichhardt" "Walcha,Parry" "Walcha,Vernon" "Waldaira,Caira" "Waldegrave,Bathurst" "Walgett,Baradine" "Walgett,Denham" "Walibree,Macquarie"
"Waljeers,Waljeers" "Walker,Cunningham" "Walker,Killara" "Walker,Mouramba" "Walker,Yungnulgra" "Walkers Hill,Flinders" "Walkminga,Tara" "Walla,Townsend" "Walla,Yungnulgra" "Walla Walla,Hume" "Walla Walla,Leichhardt" "Walla Walla,Pottinger" "Walla Walla West,Pottinger" "Walla Wollong,Blaxland" "Wallabadah,Buckland" "Wallaby,Waradgery" "Wallace,Clarendon" "Wallace,Mouramba" "Wallace,Selwyn" "Wallace,Wynyard"
"Walladilly,Bland" "Wallagaraugh,Auckland" "Wallagoot,Auckland" "Wallah,Finch" "Wallah,King" "Wallah,Nandewar" "Wallah Wallah,Forbes" "Wallala,Buckland" "Wallambine,Northumberland" "Wallandoola,Camden" "Wallandoon,Urana" "Wallandra,Blaxland" "Wallandra,Rankin" "Wallandry,Cooper" "Wallandry North,Cooper" "Wallangery,Mossgiel" "Wallangra,Arrawatta" "Wallangulla,Finch" "Wallanoll,Courallie" "Wallanthery,Nicholson"
"Wallara,Windeyer" "Wallarah,Northumberland" "Wallarobba,Durham" "Wallaroi,Gipps" "Wallaroo,Lincoln" "Wallaroo,Murray" "Wallaya,Camden" "Wallendoon,Harden" "Walleroobie,Bourke" "Wallgrove,Wallace" "Walli,Bathurst" "Wallingat,Gloucester" "Wallon,Stapylton" "Wallumburrawang,Gowen" "Wallundry,Bland" "Walmar,Denham" "Waloona,Urana" "Walshe,Robinson" "Walters,Wellington" "Waltham,Roxburgh"
"Walton,Flinders" "Waltragalda,Young" "Waltragile,Tara" "Walwa,Flinders" "Wambadule,Baradine" "Wambah,Livingstone" "Wamban,Dampier" "Wambanumba,Monteagle" "Wambat,Harden" "Wambelong,Leichhardt" "Wambera,Wentworth" "Wambianna,Ewenmar" "Wambo,Hunter" "Wamboin,Murray" "Wamboyne,Gipps" "Wambrook,Wallace" "Wammell,Finch" "Wammera,Cooper" "Wammerawa,Clyde" "Wammerra,Farnell"
"Wampunnia,Booroondarra" "Wanaaring,Ularara" "Wanalla,Livingstone" "Wanalta,Cowper" "Wandaradget,Wakool" "Wandawandong,Gordon" "Wandella,Dampier" "Wandera,Arrawatta" "Wandewoi,Brisbane" "Wandigong,Waradgery" "Wandook,Townsend" "Wandoona,Benarba" "Wandrawandian,St Vincent" "Waneba,Menindee" "Wanera,Ashburnham" "Wang Wauk,Gloucester" "Wanga,Barrona" "Wanga,Menindee" "Wanga,Mossgiel" "Wangabawgul,Boyd"
"Wangalo,Georgiana" "Wangamong,Denison" "Wangan,Baradine" "Wanganderry,Camden" "Wanganella,Townsend" "Wangaroa,Mossgiel" "Wangat,Gloucester" "Wangellic,Wellesley" "Wangoom,Cowper" "Wangrah,Beresford" "Wangumma,Tara" "Wannawanna,Tara" "Wanneba,Windeyer" "Wannella,Windeyer" "Wanpah,Tongowoko" "Wantabadgery,Clarendon" "Wanteboolka,Perry" "Wantiool,Clarendon" "Waoona,Ularara" "Wapengo,Dampier"
"Wapweelah,Irrara" "Waradgery,Waradgery" "Warangla,Gipps" "Warbreccan,Blaxland" "Warbreccan,Townsend" "Warbro,Dudley" "Warburn,Sturt" "Ward,Clarke" "Ward,Hawes" "Wardry,Dowling" "Wardry,Gipps" "Ware,King" "Wareng,Hunter" "Wargam,Townsend" "Wargin,Bland" "Wargundy,Bligh" "Warialda,Burnett" "Warien,Oxley" "Warkworth,Northumberland" "Warmatta,Denison"
"Warne,Dudley" "Warne,Wellington" "Warner,Clarke" "Waroma,Narran" "Warong,Canbelego" "Warook,Killara" "Warpa,Tara" "Warra Warrama,Stapylton" "Warra Wigra,Woore" "Warraba East,Leichhardt" "Warrabah,Darling" "Warrabah,Leichhardt" "Warrabalong,Nicholson" "Warraberry,Gordon" "Warrabillong,Blaxland" "Warraderry,Forbes" "Warragamba,Camden" "Warragamba,Cook" "Warragan,Leichhardt" "Warragoodinia,Franklin"
"Warragubogra,Denison" "Warrah,Buckland" "Warral,Parry" "Warralonga,Bland" "Warrambool,Finch" "Warrambool,Jamison" "Warrambool,Narran" "Warramutty,Fitzgerald" "Warranary,Mossgiel" "Warranbilla,Canbelego" "Warrangong,Forbes" "Warrangunia,Roxburgh" "Warratra,Wellington" "Warratta,Tongowoko" "Warraweena,Gunderbooka" "Warrawenia,Tara" "Warrawool,Townsend" "Warrazambil,Rous" "Warre Warral,Clarendon" "Warregal,Ashburnham"
"Warrego,Canbelego" "Warrego,Gunderbooka" "Warrego,Yanda" "Warrell,Raleigh" "Warren,Benarba" "Warren,Bourke" "Warren,Oxley" "Warren Downs,Leichhardt" "Warrena,Leichhardt" "Warrenitchie,Mossgiel" "Warri,Bourke" "Warri,Murray" "Warri,Tongowoko" "Warrie,Ewenmar" "Warrie,Lincoln" "Warrigal,Gregory" "Warrigal,Waradgery" "Warriston,Townsend" "Warroo,Gipps" "Warroo,Irrara"
"Warroo,Murray" "Warruera,Ularara" "Warrumba,Forbes" "Warung,Bligh" "Warungo,Canbelego" "Warwick,Werunda" "Warwillah,Townsend" "Waterbeach,Roxburgh" "Waterloo,Cowper" "Waterloo,Gough" "Waterloo,Jamison" "Waterloo,Narromine" "Waterloo,Vernon" "Wathagar,Courallie" "Watt,Brisbane" "Watt,Urana" "Wattamolla,Cumberland" "Wattamondara,Forbes" "Watti,Cooper" "Watton,Roxburgh"
"Wauberrima,Mitchell" "Waugan,Ashburnham" "Waugan,Jamison" "Waugh,Cooper" "Waugh,Finch" "Waugh,Manara" "Waugh,Urana" "Waughandry,Gregory" "Waugoola,Bathurst" "Waugorah,Caira" "Waukeroo,Yancowinna" "Waurdong,Wellington" "Waveney,Canbelego" "Waveney,Clyde" "Waverley,Mootwingee" "Waverley,Raleigh" "Waverley,Thoulcanna" "Waverley,Waljeers" "Waverly,Brisbane" "Wawgan,Gloucester"
"Waymea,Waradgery" "Wayo,Argyle" "Weah Waa,Courallie" "Wean,Nandewar" "Wear,Wellington" "Weatherley,Werunda" "Weatherly,Livingstone" "Webimble,Brisbane" "Wedderburn,Cumberland" "Weddin,Monteagle" "Wee Bulla Bulla,Courallie" "Wee Elwah,Mossgiel" "Wee Waa,White" "Wee Warra,Culgoa" "Wee Warra,Finch" "Weean,Arrawatta" "Weedallion,Bland" "Weejallah,Culgoa" "Weejasper,Buccleuch" "Weejugalah,Mossgiel"
"Weelah,Gipps" "Weeli,Clyde" "Weelong,Rankin" "Weelongbar,Rankin" "Weemabah,Narromine" "Weenculling,Gregory" "Weeney,Hunter" "Weenigoota,Mossgiel" "Weenya,Nicholson" "Weepool,Nicholson" "Weeribinyah,Mossgiel" "Weerie,Nicholson" "Weeta Waa,Jamison" "Weetaliba,Leichhardt" "Weetaliba,Nandewar" "Weetangera,Murray" "Weeyoola,Werunda" "Weilmoringle,Culgoa" "Weimbutta,Yantara" "Weimby,Caira"
"Weinteriga,Tandora" "Welaregang,Selwyn" "Welbon,Stapylton" "Wellesley,Manara" "Wellingrove,Gough" "Wellington,Gough" "Wellington,Gresham" "Wellington,Wellesley" "Wellington,Wellington" "Wellington North,Gough" "Wellington Vale,Gough" "Wells,Roxburgh" "Wellsmore,Wellesley" "Wellwood,Kennedy" "Welman,Clyde" "Welsh,Darling" "Welsh,Perry" "Weltie,Robinson" "Welumba,Selwyn" "Wemabung,Ewenmar"
"Wendi,Menindee" "Wentworth,Barrona" "Wentworth,Brisbane" "Wentworth,Landsborough" "Wentworth,Narromine" "Wentworth,Perry" "Wentworth,Sandon" "Wentworth,Wentworth" "Wera,Oxley" "Werai,Townsend" "Wereboldera,Wynyard" "Wererina,Cowper" "Weribiddee,Clyde" "Weridgery,Kennedy" "Werimble,Taila" "Werkenbergal,Townsend" "Werlong,Mouramba" "Weromba,Camden" "Werong,Georgiana" "Werong,Northumberland"
"Werouera,Wellington" "Werri Berri,Auckland" "Werriberri,Camden" "Werribilla,Finch" "Werrie,Buckland" "Werrikimbe,Hawes" "Werrina,Benarba" "Werriwa,Murray" "Wertago,Yungnulgra" "Werunda,Werunda" "West Bogan,Cowper" "West Coraki,Richmond" "West Fairfield,Drake" "West Goodradigbee,Buccleuch" "West Mitta,Menindee" "West Nelligen,St Vincent" "West Plains,Gipps" "West Uabba,Blaxland" "West Waradgery,Waradgery" "West Wendi,Menindee"
"Westby,Mitchell" "Weston,Pottinger" "Wetuppa,Wakool" "Whakoo,Cowper" "Whalan,Benarba" "Whalan,Stapylton" "Wharfdale,Flinders" "Wharfdale North,Flinders" "Wharparoo,Mossgiel" "Whealbah,Franklin" "Whealbah South,Nicholson" "Wheeland,Evelyn" "Wheeny,Cook" "Wheeo,King" "Wheoga,Forbes" "Wheoga,Gipps" "Wheoh,Baradine" "Whian Whian,Rous" "Whiporie,Richmond" "Whitbarrow,Flinders"
"White,Baradine" "White,Clarke" "White,Hawes" "White,Hunter" "White,White" "Whiteman,Clarence" "Whitminbah,Manara" "Whittabranah,Tongowoko" "Whittaker,Courallie" "Whittingham,Mossgiel" "Whittingham,Northumberland" "Whitty,Evelyn" "Whoey,Blaxland" "Whoyeo,Dowling" "Whurlie,Windeyer" "Whyaddra,Dowling" "Whybrow,Hunter" "Whyjonta,Yantara" "Whylandra,Gordon" "Whymoul,Wakool"
"Wiadere,Wellington" "Wiagdon,Roxburgh" "Wialdra,Phillip" "Wiangaree,Rous" "Wiarborough,Georgiana" "Wickham,Brisbane" "Wickham,Waljeers" "Wicklow,Cunningham" "Wicklow,Flinders" "Widden,Phillip" "Widgee,Woore" "Widgeland,Flinders" "Widgera,Livingstone" "Widgiewa,Urana" "Wigilla,Rankin" "Wilber,Gowen" "Wilberforce,Cook" "Wilbertree,Phillip" "Wilbertroy,Gipps" "Wilby,Narran"
"Wilby Wilby,Finch" "Wilcannia,Young" "Wilcannia South,Werunda" "Wilga,Blaxland" "Wilga,Clyde" "Wilga,Cowper" "Wilga,Finch" "Wilga,Gipps" "Wilga,Narran" "Wilga South,Gipps" "Wilgabone,Canbelego" "Wilgah,Waradgery" "Wilkie,Finch" "Wilkie,Harden" "Willa Murra,Clyde" "Willa Murra,Cowper" "Willabah,Gloucester" "Willaga,Leichhardt" "Willakool,Wakool" "Willala,Pottinger"
"Willalee,Benarba" "Willama,Cunningham" "Willanbalang,Kennedy" "Willandra,Bourke" "Willandra,Manara" "Willandra,Waljeers" "Willara,Ularara" "Willary,Clyde" "Willawarrin,Dudley" "Willawillinbah,Narran" "Willawong,Monteagle" "Willbriggie,Cooper" "Willdrilli,Yungnulgra" "Willenbone,Clyde" "Willera,Thoulcanna" "Willeroo,Argyle" "Willeroo,Townsend" "Willeroon,Canbelego" "Willewa,Clyde" "Willi Culling,Clyde"
"Willi Willi,Dudley" "Williams,Hardinge" "Williams,Yungnulgra" "Williamson,Caira" "Willie,Gregory" "Willie Ploma,Wynyard" "Willilbah,Caira" "Willilbah,Kilfera" "Willilbah East,Kilfera" "Willimbong,Cooper" "Willimill,Stapylton" "Willingerie,Mossgiel" "Willis,Brisbane" "Willis,Waradgery" "Willis,Young" "Willoi,Clyde" "Willotia,Windeyer" "Willoughby,Cumberland" "Willow Tree,Buckland" "Wills,Mouramba"
"Wills,Perry" "Wills,Tandora" "Willurah,Townsend" "Willuri,Nandewar" "Willy,Gresham" "Willydah,Narromine" "Willyeroo,Irrara" "Wilmatha,Flinders" "Wilmatha,Kennedy" "Wilmot,Gloucester" "Wilpatera,Tara" "Wilpee,Caira" "Wilpen,Hunter" "Wilpinjong,Phillip" "Wilson,Darling" "Wilson,Hume" "Wilson,Landsborough" "Wilson,Narran" "Wilson,Pottinger" "Wilson,Urana"
"Wilson,Wallace" "Wilton,Camden" "Wilton,Monteagle" "Wilton,Tara" "Winbar,Robinson" "Winbar,Yanda" "Winbinyah,Fitzgerald" "Winburn,Roxburgh" "Winda,Tara" "Winda South,Tara" "Windaunka,Mootwingee" "Winderima,Mossgiel" "Winderra,Yanda" "Windeyer,Bourke" "Windeyer,Wellington" "Windoley,Landsborough" "Windomal,Caira" "Windoondilla,Courallie" "Windouran,Wakool" "Windsor,Hunter"
"Winduella,King" "Windurong,Gowen" "Windy,Buckland" "Winfell,Flinders" "Wingabutta,Gowen" "Wingadee,Leichhardt" "Wingebar,Gregory" "Wingecarribee,Westmoreland" "Wingello,Camden" "Wingen,Brisbane" "Wingen,Waradgery" "Wingham,Macquarie" "Winifred,Beresford" "Winnaba,Leichhardt" "Winnalabrinna,Barrona" "Winnebaga,Tara" "Winnegow,Wentworth" "Winnini,Booroondarra" "Winslow,Benarba" "Winta,Booroondarra"
"Winter,Townsend" "Winter,Wakool" "Winterbourne,Vernon" "Winton,Inglis" "Winton,Parry" "Wiriri,Fitzroy" "Wirkenberjal,Waradgery" "Wirra North,Benarba" "Wirra Wirra,Yungnulgra" "Wirraba,Hunter" "Wirratcha,Evelyn" "Wirrawarra,Narran" "Wirrigai,Ewenmar" "Wirrigurldonga,Courallie" "Wirringa,Franklin" "Wirringan,Cadell" "Wirrir South,Benarba" "Wirrit,Benarba" "Wise,Ashburnham" "Wise,Beresford"
"Wittagoona,Yanda" "Wittenbra,Baradine" "Wittitrin,Dudley" "Wiveon,Sturt" "Wobaduck,Evelyn" "Wog Wog,St Vincent" "Wogonga,Franklin" "Woko,Hawes" "Wolabler,Ashburnham" "Wolfingham,Durham" "Wolgan,Cook" "Wolgan,Hunter" "Wollamai,Townsend" "Wollangambe,Cook" "Wollangambe North,Cook" "Wollar,Phillip" "Wollara,Brisbane" "Wollemi,Cook" "Wollemi,Hunter" "Wollom,Gloucester"
"Wollombi,Northumberland" "Wollondibby,Wellesley" "Wollongong,Camden" "Wollongough,Gipps" "Wollumbin,Rous" "Wollumboola,St Vincent" "Wologorong,Argyle" "Wolongimba,Benarba" "Wolongong,Cunningham" "Wolseley,Boyd" "Wolseley,Dudley" "Wolseley,Killara" "Wolumla,Auckland" "Wombah,Caira" "Wombin,Kennedy" "Womboin,Clyde" "Womboin,Gloucester" "Womboota,Cadell" "Womboyn,Dowling" "Wombramurra,Parry"
"Womerah,Hunter" "Wommera,Clyde" "Wommera,Gunderbooka" "Wommo,Clyde" "Wonbobbie,Ewenmar" "Wonboyn,Auckland" "Wondaby,Bligh" "Wondalga,Wynyard" "Wondoba,Pottinger" "Wonga,Hunter" "Wonga,Stapylton" "Wongajong,Forbes" "Wongal,Cadell" "Wongal,Narran" "Wongawanga,Fitzroy" "Wongawilli,Camden" "Wongolarroo,Werunda" "Wonko,Fitzgerald" "Wonna,Farnell" "Wonnue,Townsend"
"Wonominta,Evelyn" "Wonominta,Mootwingee" "Wononga,Townsend" "Wooburrabebe,Finch" "Wood,Mitchell" "Wood,Urana" "Wood,Wakool" "Wood,Wynyard" "Wood,Young" "Woodburn,St Vincent" "Woodenbong,Buller" "Woodford,Clarence" "Woodford,Cook" "Woodhouse,Yanda" "Woodonga,Monteagle" "Woodside,Clive" "Woodsreef,Darling" "Woodstock,Mootwingee" "Woolabrar,Jamison" "Woolagoola,Gregory"
"Woolartha,Oxley" "Woolcunda,Tara" "Woolgarlo,Harden" "Woolgoolga,Fitzroy" "Wooli Wooli,Clarence" "Woolingar,Leichhardt" "Woolla,Yanda" "Woolnorth,Narran" "Woolomin,Parry" "Woolomol,Inglis" "Woolomombi,Sandon" "Wooloombye,Waradgery" "Wooloondool,Waradgery" "Woolpagerie,Kilfera" "Woolpagerie North,Manara" "Woolumla,Beresford" "Woomahrigong,Wynyard" "Woomargama,Goulburn" "Woombah,Clarence" "Woombup,Yantara"
"Woonona,Camden" "Woonox,Townsend" "Woonunga,Mootwingee" "Woore,Mossgiel" "Woore,Rankin" "Woore,Werunda" "Woore,Young" "Woorooboomi,Lincoln" "Wooroola,Mossgiel" "Woorooma,Wakool" "Wooroowoolgan,Richmond" "Woorungil,Young" "Woorut,Gowen" "Woperana,Denison" "Woram,Richmond" "Woraro,Yungnulgra" "Worcester,Bathurst" "Worendo,Rous" "Worigal,Baradine" "Worinjerong,Leichhardt"
"Worobil,Bligh" "Worobyan,Wakool" "Worondi,Brisbane" "Worra,Gresham" "Worungil,Tandora" "Wowagin,Georgiana" "Wowong,Sturt" "Woytchugga,Werunda" "Woytchugga,Young" "Wreford,Perry" "Wullamgambone,Gregory" "Wullwye,Wallace" "Wunawunty,Yantara" "Wundabungay,Gregory" "Wunglebong,Clive" "Wunnamurra,Urana" "Wureep,Narran" "Wureep,Townsend" "Wuuluman,Bligh" "Wyabery,Leichhardt"
"Wyabray,Clyde" "Wyadra,Franklin" "Wyalong,Gipps" "Wyalong South,Bland" "Wyanbene,Dampier" "Wyandah,Richmond" "Wyangala,King" "Wyangan,Cooper" "Wyangle,Buccleuch" "Wyarra,Ularara" "Wybong,Brisbane" "Wycheproof,Sturt" "Wydjah,Evelyn" "Wygah,Evelyn" "Wylie,Buller" "Wyndham,Arrawatta" "Wyndham,Auckland" "Wyndham,Georgiana" "Wyndham,Goulburn" "Wyndham,Murchison"
"Wyndham,Rous" "Wynduc,Booroondarra" "Wynn,Durham" "Wyoming,Macquarie" "Wyoming,Waradgery" "Wyon,Richmond" "Wyong,Northumberland" "Wyrra,Bland" "Wyuna,Franklin" "Wyunga,Waljeers" "Yabtree,Wynyard" "Yackerboon,Blaxland" "Yadabal,Wakool" "Yadboro,St Vincent" "Yadchow,Wakool" "Yagobe,Burnett" "Yailah,Ularara" "Yalama,Townsend" "Yalbraith,Georgiana" "Yalcogrin,Gowen"
"Yalgadoori,Townsend" "Yalgogoring,Cooper" "Yallakool,Townsend" "Yallaroi,Burnett" "Yallock,Mossgiel" "Yaloke,Townsend" "Yaloo,Waljeers" "Yalpunga,Tongowoko" "Yaltolka,Windeyer" "Yalwal,St Vincent" "Yamaranie,Killara" "Yamba,Clarence" "Yambacuna,Clyde" "Yambira,Monteagle" "Yambla,Goulburn" "Yamboor,Narran" "Yambulla,Auckland" "Yambunya,Ularara" "Yamby,Culgoa" "Yamby,Narran"
"Yamby West,Culgoa" "Yaminba,White" "Yamma,Flinders" "Yamma,Mouramba" "Yamma,Urana" "Yancannia,Yungnulgra" "Yancarraman,Evelyn" "Yancowinna,Yancowinna" "Yancowinna East,Yancowinna" "Yancowinna North,Yancowinna" "Yanda,Clyde" "Yanda,Robinson" "Yanda,Yanda" "Yandagulla,Yanda" "Yandama,Evelyn" "Yandaminta,Evelyn" "Yandaroo,Barrona" "Yandembah,Franklin" "Yandenberry,Mootwingee" "Yandenberry,Yantara"
"Yandera,Tongowoko" "Yandumblin,Nicholson" "Yang Yang,Waradgery" "Yanga,Caira" "Yanga,Wakool" "Yangalla,Yancowinna" "Yangimulla,Mootwingee" "Yango,Northumberland" "Yanko,Mouramba" "Yanko,Urana" "Yanko South,Urana" "Yannaway,Sturt" "Yantara,Yantara" "Yantaralla,Tara" "Yanununbeyan,Murray" "Yaouk,Cowley" "Yapunya,Fitzgerald" "Yara,Blaxland" "Yara East,Blaxland" "Yarabee,Mitchell"
"Yaradah,Mossgiel" "Yaraman,White" "Yarangery,Cooper" "Yarara,Cowley" "Yarara,Goulburn" "Yarea,Clyde" "Yaree,Franklin" "Yargunyah,Cowper" "Yarindury,Lincoln" "Yarkieta,Narran" "Yarlalla,Windeyer" "Yarllalla,Tara" "Yarllalla South,Tara" "Yarnel,Gipps" "Yarouah,Benarba" "Yarra Yarra,Goulburn" "Yarraba,Poole" "Yarrabandai,Cunningham" "Yarrabandini,Dudley" "Yarrabundry,Dowling"
"Yarradigerie,Narromine" "Yarragal,Bligh" "Yarragong,Ashburnham" "Yarragoora,Leichhardt" "Yarragrin,Gowen" "Yarragundry,Mitchell" "Yarrahapinni,Dudley" "Yarralaw,Argyle" "Yarraldool,Denham" "Yarraman,Baradine" "Yarraman,Brisbane" "Yarraman,Cadell" "Yarraman,Courallie" "Yarraman,Cowper" "Yarraman,Finch" "Yarraman,Georgiana" "Yarraman,Gunderbooka" "Yarraman,Pottinger" "Yarramarra,Landsborough" "Yarramurtie,Evelyn"
"Yarran,Bland" "Yarran,Canbelego" "Yarran,Culgoa" "Yarran,Dowling" "Yarranbar,Jamison" "Yarranbella,Raleigh" "Yarrangobilly,Buccleuch" "Yarranjerry,Bourke" "Yarrari,Nandewar" "Yarratt,Macquarie" "Yarravel,Dudley" "Yarrawa,Camden" "Yarrawell,Gregory" "Yarrawin,Clyde" "Yarrawin,Gowen" "Yarrayin,Leichhardt" "Yarrcalkiarra,Drake" "Yarrein,Wakool" "Yarren,Baradine" "Yarrigan,Baradine"
"Yarrimanbah,Buckland" "Yarrington,Caira" "Yarrobil,Bligh" "Yarrol,Benarba" "Yarrow,Flinders" "Yarrow,Gough" "Yarrow,Lincoln" "Yarrow,Murray" "Yarrowal,Caira" "Yarrowford,Gough" "Yarrowick,Hardinge" "Yarrowick,Sandon" "Yarrowitch,Vernon" "Yarrunga,Camden" "Yartla,Windeyer" "Yarto,Waljeers" "Yass,King" "Yass,Murray" "Yathong,Blaxland" "Yathong,Mossgiel"
"Yathong,Urana" "Yathong South,Urana" "Yatta,Courallie" "Yaven,Wynyard" "Yearanan,Baradine" "Yeerawun,Hawes" "Yeerowin,Parry" "Yeiltara,Yungnulgra" "Yelkeer North,Kilfera" "Yelkin,Dowling" "Yellowin,Selwyn" "Yellymong,Wakool" "Yelty,Manara" "Yenda,Cooper" "Yenda,Livingstone" "Yenda,Perry" "Yengo,Hunter" "Yentabange,Fitzgerald" "Yeo Yeo,Bland" "Yerai,Bland"
"Yeranbah,Finch" "Yerangle,Finch" "Yernca,Irrara" "Yerndambool,Yungnulgra" "Yerong,Mitchell" "Yerriyong,St Vincent" "Yerta,Wentworth" "Yetholme,Roxburgh" "Yetman,Arrawatta" "Yewrangara,Georgiana" "Yhababong,Gregory" "Yhoul,Kilfera" "Yhoul,Manara" "Yiddah,Bland" "Yimbaring,Waradgery" "Yipunyah,Ularara" "Yithan,Bourke" "Yoee,Leichhardt" "Yooloobil,Stapylton" "Yooltoo,Fitzgerald"
"Yoongee,Flinders" "Yoree,Werunda" "York,Beresford" "Youendah,Leichhardt" "Yough,Caira" "Youlbung,Gowen" "Young,Benarba" "Young,Monteagle" "Young,Tara" "Young,Young" "Younga Plain,Gipps" "Younga South,Manara" "Youngal,Selwyn" "Youngareen,Gipps" "Youngarignia,Irrara" "Youngera,Taila" "Yourblah,Finch" "Youyang,Mossgiel" "Youyang,Mouramba" "Yowahro,Farnell"
"Yowahroo,Yungnulgra" "Yowaka,Auckland" "Yowrie,Dampier" "Yralla,Kennedy" "Yugaruree,Mossgiel" "Yuggel,Napier" "Yuglamah,Auckland" "Yulgilbar,Drake" "Yuline,Bland" "Yuma,Leichhardt" "Yundoo,Monteagle" "Yungnulgra,Young" "Yurammie,Auckland" "Yurdyilla,Nicholson" "Yurongan,Gunderbooka" "Zanci,Taila" "Zara,Narran" "Zouch,Cowper"

))


(defun linebuilder (/)

 ;----------------------------------------start line builder

  
  ;get line 1

  

 

(if (= (substr sobs 1 3) "arc")(progn

				 ;seperate obs and points
       (setq !pos1 (vl-string-position 33 sobs 0))
  (setq ~pos1 (vl-string-position 126 sobs 0))
       (setq ,pos1 (vl-string-position 44 sobs 0))
            
   (setq bearing  (substr sobs 4 (- ~pos1 3)))
   (setq arclength (substr sobs (+ ~pos1 2) (- (- ,pos1 ~pos1) 1)))
       (setq radius (substr sobs (+ ,pos1 2) (- (- !pos1 ,pos1) 1)))
   (setq target (substr sobs  (+ !pos1 2) 200))
				  
  ;calc chord distance, note using string values not digital values
	    (setq stringO (/ (atof arclength) (atof radius)));arc internal angle based on string values
	    (setq dist (rtos (* 2 (atof radius) (sin (/ stringO 2))) 2 3))
  )

 
  
(progn ; is a line
  ;seperate obs and points
       (setq !pos1 (vl-string-position 33 sobs 0))
  (setq ~pos1 (vl-string-position 126 sobs 0))
   (setq bearing  (substr sobs 1 ~pos1))
   (setq dist (substr sobs (+ ~pos1 2) (+ !pos1 2)))
   (setq target (substr sobs  (+ !pos1 2) 200))
));p& ifline/arc

  ;APPLY ALL CORRECTIONS AND EXTRACT INFORMATION FROM USER INPUT
(if (/= (vl-string-position 46 bearing 0) nil ) (PROGN
  (setq dotpt1 (vl-string-position 46 bearing 0))
  (setq deg  (substr bearing 1  dotpt1 ))
  (SETQ mins  (substr bearing (+ dotpt1 2) 2))
  (setq sec  (substr bearing (+ dotpt1 4) 10))

  ;truncated mins and secs
  (if (= (strlen sec) 1)  (setq sec (strcat sec "0" )))
  (if (= (strlen mins) 1)  (setq mins (strcat mins "0" )))
  (setq mins (strcat mins (chr 39)))
  
  (if (> (strlen sec) 2) (setq sec (strcat (substr sec 1 2) "." (substr sec 3 10))))

  (if (= (strlen sec) 0) (setq sec "") (setq sec (strcat sec (chr 34))))
  );P
	(progn
	  (setq deg bearing)
	  (setq mins "")
	  (setq sec "")
	  );p else
  
  );IF

  ;look for R
  (if (or (= (substr bearing 1 1 ) "r") (= (substr bearing 1 1 ) "R" ))
    (progn
      (setq deg (substr deg 2 10))
      (setq rswitch "T")
      )
    (setq rswitch "F")
    )
  
        
	      

    ;DRAW LINE 1
      (setq lbearing bearing)
  ;(IF ( = rswitch "T")(setq obearing (substr lbearing 2 200))(setq obearing lbearing))
  (setq dist (rtos (atof dist)2 3));remove trailing zeros
  
  (setq ldist dist)
  (setq bearing (strcat  deg "d" mins sec))

  (setq linetext (strcat "@" dist "<" bearing))
    (command "line" startpoint linetext "")

  (setq sent (entlast))
   (SETQ SENTLIST (ENTGET SENT))

    (setq p2 (CDR(ASSOC 11 sentlist)))
    
  
;Move line if reverse activated
(if (= rswitch "T")
  (progn
    (setq p1 (CDR(ASSOC 10 sentlist)))
    (setq p2 (CDR(ASSOC 11 sentlist)))
    (command "move" sent "" p2 p1)
     (setq sent (entlast))
   (SETQ SENTLIST (ENTGET SENT))
    (setq p2 (CDR(ASSOC 10 sentlist)))
    
 
    )
  )

  ;(command "erase" sent "")
  (setq dellines (ssadd sent dellines))
    
 ; (alert (strcat "\n" sp " to " target " oc" (rtos obscount 2 0) "-" (rtos (length orderlist) 2 0) "-" (rtos (length cgpointnum) 2 0)))

  (if (= (setq remlist (member target cgpointnum)) nil)
    (progn
      (setq cgpointnum (append cgpointnum (list target)))
      (setq cgpointco (append cgpointco (list p2)))
(setq orderlist (append orderlist (list order)))
      
      (setq remlist (member target cgpointnum))
       (setq existco (nth (- (length cgpointnum)(length remlist)) cgpointco))
      )
    (progn
      (setq existco (nth (- (length cgpointnum)(length remlist)) cgpointco))
      (if (> (atof (rtos (distance existco p2) 2 3)) 0)
	(progn

	  
	  (command "layer" "m" "Miscloses" "c" "Yellow" "Miscloses" "" )
      (command "line" existco p2 "")
	  (setq sent (entlast))
      (command "scale" sent "" p2 "100")
	  (setq mdist (rtos (* (distance existco p2 ) 1000) 2 0))
	  (setq mang (angtos (angle p2 existco) 0 0))
	  (COMMAND "TEXT" "J" "BL" existco TH (angtos (angle p2 existco) 0 5) (strcat mang "�-" mdist ))

	  (setq curorder (nth (- (length cgpointnum)(length remlist)) orderlist))
	 

	  (if (< order curorder);if new point is higher in the heirachy
	    (progn
	      
	      (setq cgpointnum (remove_nth cgpointnum   (- (length cgpointnum)(length remlist))))
	      (setq cgpointco (remove_nth cgpointco   (- (length cgpointco)(length remlist))))
	      (setq orderlist (remove_nth orderlist   (- (length orderlist)(length remlist))))
	      (setq cgpointnum (append cgpointnum (list target)))
              (setq cgpointco (append cgpointco (list p2)))
              (setq orderlist (append orderlist (list order)))
	      ;  (alert (strcat "\n" sp " to " target " oc" (rtos obscount 2 0) "-" (rtos (length orderlist) 2 0) "-" (rtos (length cgpointnum) 2 0)))

	      )
	    )
	  
      ));dist > 0
      )
    )

  
)
  

(defun obsimporter (/)
   (setq prevlayer (getvar "CLAYER"))
  (SETVAR "CLAYER"  "Lot Definitions" )
 
  (setq roadpoints nil)
  (setq roadobs nil)
  (setq bdypoints nil)
  (setq bdyobs nil)
  (setq conpoints nil)
  (setq conobs nil)
  (setq cgpointnum (list));list of coordinate geometery names
  (setq cgpointco (list)) ;listof coordunate geometery coorindates
  (setq rorder (list));lists for order of insertion of lines
  (setq border (list))
  (setq corder (list))
  (setq orderlist (list))
  (setq origcgpointlist (list));original coordintes for establishing shifts
  (setq newcgpointlist (list));new coorinates of the same points
  (setq dellines (ssadd))
  (setq NCGlist (list));list instruments stations not connected by geomtery (eg BM's only connected by height diffs)

  (setq cgpointlist (list));list of names coordinates and types for importer
  
  ;(setq xmlfilen (getfiled "Select XML file" "" "xml" 2))



  
  (setq startpoint (getpoint "Select a starting point:"))

  ;linefeed to observations
(setq linetext "")
  (setq obscount 0)
   (while (= (vl-string-search "<ObservationGroup" linetext) nil) ( progn
  (linereader)
))


  

  (linereader)
  
(while (= (vl-string-search "</ObservationGroup>" linetext ) nil)( progn

								   (setq rmline 0);reset trigger for rmline with monument at other end.

		;line observation--------------------------------------------------------------------------------------------------
		(if (/= (vl-string-search "<ReducedObservation" linetext ) nil)
	    (progn
	      
	      
	    (setq stringpos (vl-string-search "desc" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 6)))
            (setq rolayer (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5))))

	    (setq stringpos (vl-string-search "setupID" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 9)))
            (setq setupid  (substr linetext (+ stringpos 10) (-(- wwpos 1)(+ stringpos 8))))
	    
	    (setq stringpos (vl-string-search "targetSetupID" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 15)))
            (setq targetid  (substr linetext (+ stringpos 16) (-(- wwpos 1)(+ stringpos 14))))
	    
	    (if (setq stringpos (vl-string-search "azimuth" linetext ))(progn
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 9)))
            (setq bearing (substr linetext (+ stringpos 10) (-(- wwpos 1)(+ stringpos 8))))
	    (setq xbearing bearing))(setq xbearing ""
					  bearing ""))

	    (if (setq stringpos (vl-string-search "horizDistance" linetext ))(progn
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 15)))
            (setq dist (substr linetext (+ stringpos 16) (-(- wwpos 1)(+ stringpos 14)))))(setq dist ""))

	    (if (/= (setq stringpos (vl-string-search "distanceType=" linetext ))nil)(progn
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 14)))
            (setq distancetype (strcat " distanceType=\"" (substr linetext (+ stringpos 15) (-(- wwpos 1)(+ stringpos 13))) "\" ")))(setq distancetype ""))

	    (if (/= (setq stringpos (vl-string-search "distanceAdoptionFactor" linetext )) nil)(progn
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 24)))
            (setq daf (substr linetext (+ stringpos 25) (-(- wwpos 1)(+ stringpos 23)))))(setq daf ""))

	    

	    	      (if (/= (setq stringpos (vl-string-search "<FieldNote>" linetext )) nil)(progn
											   
(if (setq wwpos (vl-string-position 34 linetext (+ stringpos 12)))
  (progn;if field not contains ""s
    (setq comment (substr linetext (+ stringpos 13) (-(- wwpos 1)(+ stringpos 11))))
    )
  (progn; else use the < to get other end of field note
    (setq <pos (vl-string-position 60 linetext (+ stringpos 11)))
    (setq comment (substr linetext (+ stringpos 12) (-(- <pos 1)(+ stringpos 10))))
    )
  )
)
  (setq comment ""))
(setq &pos 0)
	      (while (/=  (setq &pos (vl-string-search "&amp;" comment &pos )) nil) (setq comment (vl-string-subst "&" "&amp;"  comment &pos)
										      &pos (+ &pos 1)))
	    

	    (if (or (= rolayer "Road")(= rolayer "Road Extent"))(progn
				    (if (= (member (strcat bearing "~" dist "!" targetid) roadobs) nil)(progn
				    
	      (setq roadpoints (append roadpoints (list setupid)))
	      (setq roadobs (append roadobs (list (strcat bearing "~" dist "!" targetid))))
	      (setq roadpoints (append roadpoints (list targetid)))
	      (setq roadobs (append roadobs (list (strcat "r" bearing "~" dist "!" setupid))))
	      ));p&if not already in list
				    ));p&if road layer

	    (if (= rolayer "Boundary")(progn
				    (if (= (member (strcat bearing "~" dist "!" targetid) bdyobs) nil)(progn
				    
	      (setq bdypoints (append bdypoints (list setupid)))
	      (setq bdyobs (append bdyobs (list (strcat bearing "~" dist "!" targetid))))
	      (setq bdypoints (append bdypoints (list targetid)))
	      (setq bdyobs (append bdyobs (list (strcat "r" bearing "~" dist "!" setupid))))
	      ));p&if not already in list
				    ));p&if boundary layer

	    (if (or (= rolayer "Connection")(= rolayer "Reference"))(progn
				    (if (= (member (strcat bearing "~" dist "!" targetid) conobs) nil)(progn
				    
	      (setq conpoints (append conpoints (list setupid)))
	      (setq conobs (append conobs (list (strcat bearing "~" dist "!" targetid))))
	      (setq conpoints (append conpoints (list targetid)))
	      (setq conobs (append conobs (list (strcat "r" bearing "~" dist "!" setupid))))
	      ));p&if not already in list
				    ));p&if connection layer
	    
	    
	    
	    (setq obscount (+ obscount 1))


	    	    ));pif line


;------------arc observation-------------------------------------------------------------------------------------------------


		(if (/= (vl-string-search "<ReducedArcObservation" linetext ) nil)
	    (progn
	      
	      
	    (setq stringpos (vl-string-search "desc" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 6)))
            (setq rolayer (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5))))

	    (setq stringpos (vl-string-search "setupID" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 9)))
            (setq setupid  (substr linetext (+ stringpos 10) (-(- wwpos 1)(+ stringpos 8))))
	    
	    (setq stringpos (vl-string-search "targetSetupID" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 15)))
            (setq targetid (substr linetext (+ stringpos 16) (-(- wwpos 1)(+ stringpos 14))))
	    
	    (setq stringpos (vl-string-search "chordAzimuth" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 14)))
            (setq bearing (substr linetext (+ stringpos 15) (-(- wwpos 1)(+ stringpos 13))))
	    (setq xbearing bearing)

	    (setq stringpos (vl-string-search "length" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 8)))
            (setq arclength (substr linetext (+ stringpos 9) (-(- wwpos 1)(+ stringpos 7))))
	    (setq arclength (rtos (atof arclength)2 3));remove trailing zeros

	    (setq stringpos (vl-string-search "radius" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 8)))
            (setq radius (substr linetext (+ stringpos 9) (-(- wwpos 1)(+ stringpos 7))))
	    

	    (setq stringpos (vl-string-search "rot" linetext ))
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 5)))
            (setq curverot (substr linetext (+ stringpos 6) (-(- wwpos 1)(+ stringpos 4))))

	    (if (/= (setq stringpos (vl-string-search "arcType" linetext )) nil)(progn
	    (setq wwpos (vl-string-position 34 linetext (+ stringpos 9)))
            (setq arcType (strcat " arcType=\"" (substr linetext (+ stringpos 10) (-(- wwpos 1)(+ stringpos 8))) "\"")))(setq arcType ""))

	   	      (if (/= (setq stringpos (vl-string-search "<FieldNote>" linetext )) nil)(progn
											   
(if (setq wwpos (vl-string-position 34 linetext (+ stringpos 12)))
  (progn;if field not contains ""s
    (setq comment (substr linetext (+ stringpos 13) (-(- wwpos 1)(+ stringpos 11))))
    )
  (progn; else use the < to get other end of field note
    (setq <pos (vl-string-position 60 linetext (+ stringpos 11)))
    (setq comment (substr linetext (+ stringpos 12) (-(- <pos 1)(+ stringpos 10))))
    )
  )
)
  (setq comment ""))
	    
	    (setq &pos 0)
	      (while (/=  (setq &pos (vl-string-search "&amp;" comment &pos )) nil) (setq comment (vl-string-subst "&" "&amp;"  comment &pos)
										      &pos (+ &pos 1)))




	    (if (or (= rolayer "Road")(= rolayer "Road Extent"))(progn
				    (if (= (member (strcat "arc" bearing "~" arclength "," radius "!" targetid) roadobs) nil)(progn
				    
	      (setq roadpoints (append roadpoints (list setupid)))
	      (setq roadobs (append roadobs (list (strcat "arc" bearing "~" arclength "," radius "!" targetid))))
	      (setq roadpoints (append roadpoints (list targetid)))
	      (setq roadobs (append roadobs (list (strcat "arc" "r" bearing "~" arclength "," radius "!" setupid))))
	      ));p&if not already in list
				    ));p&if road layer

	    (if (= rolayer "Boundary")(progn
				    (if (= (member (strcat "arc" bearing "~" arclength "," radius "!" targetid) bdyobs) nil)(progn
				    
	      (setq bdypoints (append bdypoints (list setupid)))
	      (setq bdyobs (append bdyobs (list  (strcat "arc" bearing "~" arclength "," radius "!" targetid))))
	      (setq bdypoints (append bdypoints (list targetid)))
	      (setq bdyobs (append bdyobs (list (strcat "arc" "r" bearing "~" arclength "," radius "!" setupid))))
	      ));p&if not already in list
				    ));p&if boundary layer

	    (if (or (= rolayer "Connection")(= rolayer "Reference"))(progn
				    (if (= (member (strcat "arc" bearing "~" arclength "," radius "!" targetid) conobs) nil)(progn
				    
	      (setq conpoints (append conpoints (list setupid)))
	      (setq conobs (append conobs (list  (strcat "arc" bearing "~" arclength "," radius "!" targetid))))
	      (setq conpoints (append conpoints (list targetid)))
	      (setq conobs (append conobs (list (strcat "arc" "r" bearing "~" arclength "," radius "!" setupid))))
	      ));p&if not already in list
				    ));p&if connection layer
	    
	 (setq obscount (+ obscount 1))
	    	    ));pif arc

		

	    

		(linereader)
				));p and while not end of observation				 

;start building lines

  (princ "\nObservations imported - drawing lines")

(if (> (length roadobs) 0)(progn
  (setq sp (nth 0 roadpoints))
  (setq sobs (nth 0 roadobs))
  (setq roadobs (remove_nth roadobs 0))
  (setq roadobs (remove_nth roadobs 0))
  (setq roadpoints (remove_nth roadpoints 0))
  (setq roadpoints (remove_nth roadpoints 0))
  (SETVAR "CLAYER"  "Road" )
  );if road
  (progn;if no road try boundary
  (if (> (length bdyobs) 0)(progn
  (setq sp (nth 0 bdypoints))
  (setq sobs (nth 0 bdyobs))
  (setq bdyobs (remove_nth bdyobs 0))
  (setq bdyobs (remove_nth bdyobs 0))
  (setq bdypoints (remove_nth bdypoints 0))
  (setq bdypoints (remove_nth bdypoints 0))
  (SETVAR "CLAYER"  "Boundary" )
  );if boundary
    (progn ;if no bdy or road try cons
      (if (> (length conobs) 0)(progn
  (setq sp (nth 0 conpoints))
  (setq sobs (nth 0 conobs))
  (setq conobs (remove_nth conobs 0))
  (setq conobs (remove_nth conobs 0))
  (setq conpoints (remove_nth conpoints 0))
  (setq conpoints (remove_nth conpoints 0))
  (SETVAR "CLAYER"  "Connection" )
  )(exit);if connections
));if no boundary
  ));if no road
  );if road


  

   (setq cgpointnum (append cgpointnum (list sp)))
  (setq cgpointco (append cgpointco (list startpoint)))
  (setq orderlist (append orderlist (list 1)))
  
(setq obspos 0)
  
  (setq order 1)
 (linebuilder)

 
;(setq obscount (- obscount 1))
  (setq rorder (append rorder (list target)))
  
(while (/= obscount 0)
  
 (progn

    (setq obsdone "N")

 

      ;if roadpoint found
(if (setq spremlist (member sp roadpoints))
  (progn
    (setq obspos (- (length roadpoints) (length spremlist)))
    (setq sobs (nth obspos roadobs))
    (SETVAR "CLAYER"  "Road" )
    (setq order 1)
    (linebuilder)

    (if (= rswitch "T")
      (progn
  (setq roadobs (remove_nth roadobs (- obspos 1)))
  (setq roadobs (remove_nth roadobs (- obspos 1)))
  (setq roadpoints (remove_nth roadpoints  (- obspos 1)))
  (setq roadpoints (remove_nth roadpoints  (- obspos 1)))
  
    )
      (progn
  (setq roadobs (remove_nth roadobs  obspos ))
  (setq roadobs (remove_nth roadobs  obspos ))
  (setq roadpoints (remove_nth roadpoints  obspos ))
  (setq roadpoints (remove_nth roadpoints  obspos ))
	)
      )
    
    (setq obsdone "Y")
    ;(setq obscount (- obscount 1))

       (if (= (member target rorder) nil)(setq rorder (append rorder (list target))))
	
    );p
  );if roadpoints

;if no road check for boundary line from point
(if (and (/= obsdone "Y") (setq spremlist (member sp bdypoints)))
  (progn
    (setq obspos (- (length bdypoints) (length spremlist)))
    (setq sobs (nth obspos bdyobs))
    (SETVAR "CLAYER"  "Boundary" )
    (setq order 2)
    (linebuilder)

    (if (= rswitch "T")
      (progn
  (setq bdyobs (remove_nth bdyobs (- obspos 1)))
  (setq bdyobs (remove_nth bdyobs (- obspos 1)))
  (setq bdypoints (remove_nth bdypoints  (- obspos 1 )))
  (setq bdypoints (remove_nth bdypoints  (- obspos 1 )))
  
    )
      (progn
  (setq bdyobs (remove_nth bdyobs   obspos ))
  (setq bdyobs (remove_nth bdyobs   obspos ))
  (setq bdypoints (remove_nth bdypoints  obspos ))
  (setq bdypoints (remove_nth bdypoints  obspos ))
	)
      )
    (setq obsdone "Y")
    ;(setq obscount (- obscount 1))
    
    (if (= (member target border) nil)
      (progn
	(setq border (append border (list target)))
     ; (alert (strcat target " added to border"))
      ))
    )
  );if bdypoints


;if no road or boundary check for connection line from point
(if (and (/= obsdone "Y") (setq spremlist (member sp conpoints)))
  (progn
    (setq obspos (- (length conpoints) (length spremlist)))
    (setq sobs (nth obspos conobs))
    (SETVAR "CLAYER"  "Connection" )
    (setq order 3)
    (linebuilder)

    (if (= rswitch "T")
      (progn
  (setq conobs (remove_nth conobs (- obspos 1)))
  (setq conobs (remove_nth conobs (- obspos 1)))
  (setq conpoints (remove_nth conpoints (- obspos 1 )))
  (setq conpoints (remove_nth conpoints (- obspos 1 )))
  
    )
      (progn
  (setq conobs (remove_nth conobs   obspos ))
  (setq conobs (remove_nth conobs   obspos  ))
  (setq conpoints (remove_nth conpoints  obspos ))
  (setq conpoints (remove_nth conpoints  obspos ))
	)
      )
    (setq obsdone "Y")
    ;(setq obscount (- obscount 1))
    (if (= (member target corder) nil)(setq corder (append corder (list target))))
    )
  );if bdypoints

;no more obs found from point, go to next point in heirachy
(if (/= obsdone "Y")
  (progn
    (SETVAR "CLAYER"  "Road" )
    (setq pointfound "N")


    (if (and  (= (length rorder) 0) (= (length border) 0) (= (length corder) 0));check for isolated points
  (progn
   (setq isopoints "")
   (setq count 0)
  (repeat (length roadpoints)
    (setq isopoints (strcat isopoints (nth count roadpoints) " "))
    (setq count (+ count 1))
    )
   (setq count 0)
  (repeat (length bdypoints)
    (setq isopoints (strcat isopoints (nth count bdypoints) " "))
    (setq count (+ count 1))
    )
   (setq count 0)
  (repeat (length conpoints)
    (setq isopoints (strcat isopoints (nth count conpoints) " "))
    (setq count (+ count 1))
    )
   (if (/= isopoints "")  (princ (strcat "\n Error - Isolated Points Detected:" isopoints)))
   ); print isolated poitns
 );if


    
    (if (> (length rorder) 0)(setq sp (car rorder)
				   rorder (remove_nth rorder 0)
				   pointfound "Y"))
    (if (and (= (length rorder) 0)(> (length border) 0)(/= pointfound "Y"))(setq sp (car border)
							                         border (remove_nth border 0)
										 pointfound "Y")
										 )
    (if (and (= (length rorder) 0)(= (length border) 0)(> (length corder) 0)(/= pointfound "Y"))(setq sp (car corder)
										                      corder (remove_nth corder 0)
												      pointfound "Y"))
    (if (and (= (length rorder) 0)(= (length border) 0)(= (length corder) 0)(/= pointfound "Y"))(setq obscount 0))
    
    (setq remlist (member sp cgpointnum))
    (setq startpoint (nth (- (length cgpointnum)(length remlist)) cgpointco))
    
    
    ;(alert (strcat "\nPoint Switched to " sp  "-" (rtos obscount 2 0)))
    )
  )


));p and if while obscount

  
   (PRINC "\nObservation Import Drawing Complete-calculating new point coordinates")


 ;Create GG point list

(close xmlfile)
  (setq xmlfile (open xmlfilen "r"))
  
 
  ;CGPOINTS bdy and control-------------------------------------
  ;linefeed to cgpoints
  (while (= (vl-string-search "<CgPoints" linetext) nil) ( progn
  (linereader)
))


  ;get zone if present
  (if (/= (setq stringpos (vl-string-search "zoneNumber" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 12)))(setq zone (substr linetext (+ stringpos 13) (-(- wwpos 1)(+ stringpos 11)))))(setq zone ""))
  
  (linereader)
  ;do until end of cgpoints
      (while (= (vl-string-search "</CgPoints" linetext) nil) ( progn
   (if (/= (vl-string-search "<CgPoint" linetext )nil)
     (progn
       ;store line information
       (if (/= (setq stringpos (vl-string-search "state" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 7)))(setq cgpstate (substr linetext (+ stringpos 8) (-(- wwpos 1)(+ stringpos 6)))))(setq cgpstate nil))
              (if (/= (setq stringpos (vl-string-search "pntSurv" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 9)))(setq cgpntsurv (substr linetext (+ stringpos 10) (-(- wwpos 1)(+ stringpos 8)))))(setq cgpntsurv nil))
              (if (/= (setq stringpos (vl-string-search "name" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 6)))(setq cgpname (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5)))))(setq cgpname nil))
                     (if (/= (setq stringpos (vl-string-search "oID" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 5)))(setq cgpoID (substr linetext (+ stringpos 6) (-(- wwpos 1)(+ stringpos 4)))))(setq cgpoID nil))
                            (if (/= (setq stringpos (vl-string-search "desc" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 6)))(setq cgdesc (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5)))))(setq cgdesc nil))

       ;check if point is a pm and store in drawpmlist
       (if (/= cgpoID nil)(progn
			    (setq remlist (member cgpname pmlist))
			    (setq pmline (cadr remlist))
			    (if (/= (setq stringpos (vl-string-search "type" pmline)) nil)(progn
			    (setq wwpos (vl-string-position 34 pmline (+ stringpos 6)))(setq pmstart (substr pmline (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5)))))
			      (setq pmstart nil))
			    (if (/= (setq stringpos (vl-string-search "state" pmline)) nil)(progn
			    (setq wwpos (vl-string-position 34 pmline (+ stringpos 7)))(setq pmstate (substr pmline (+ stringpos 8) (-(- wwpos 1)(+ stringpos 6)))))
			      (setq pmstate ""))
			    (setq drawpmlist (APPEND drawpmlist (list cgpname)(list (strcat pmstart cgpoID ))(list pmstate )))
			    )
	 )
              	  
			    
       ;get cgpoint coodintes

       ;IS to cgpname list
(if (setq remlist (member cgpname islist))
       (progn
       (setq cgppos (- (length islist) (length remlist)))
       (setq isname (substr (nth (- cgppos 1)  islist) 4 200))
        
    (if (setq remlist (member isname cgpointnum))
      (progn
      

	     (if (/= (setq stringpos (vl-string-search ">" linetext )) nil)(progn
(setq <pos (vl-string-position 60 linetext (+ stringpos 2)))
(if (= <pos nil)(setq <pos 2000))
(setq spcpos (vl-string-position 32 linetext stringpos))
(setq north  (atof (substr linetext (+ stringpos 2) (- spcpos (+ stringpos 1) ))))
(setq east  (atof (substr linetext (+ spcpos 2) (- (- <pos 1) spcpos ))))
(setq origco (list  east north))
));get original coords for sideshot compare

	   
       (setq cgco (nth (- (length cgpointnum)(length remlist)) cgpointco))
(setq cgcos (strcat (rtos (car cgco)2 6) "," (rtos (cadr cgco) 2 6)))
       (setq cgpointlist (append cgpointlist (list cgpname) (list cgcos)(list (substr cgpntsurv 1 1))))
	   (setq origcgpointlist (append origcgpointlist  (list origco)))
	   (setq newcgpointlist (append newcgpointlist (list cgco)))
           (setq east (car cgco))
	   (setq north (cadr cgco)) 
      	   (if (> east maxeast) (setq maxeast east))
           (if (< north minnorth)(setq minnorth north))
	   

	


        ;DRAW CG POINTS
       (if (= simplestop "0")(progn
			       
       (SETVAR "CLAYER"  "CG Points" )
       (setq p1 (list  east north))
       
       (command "point" p1)
       (COMMAND "TEXT" "J" "BL"  P1 (* TH 0.25) "90" (strcat cgpname (substr cgpntsurv 1 1)(substr cgpstate 1 1)))
       ))
       )
      (progn ;if its a IS but not connected
      (princ (strcat "\n" isname " is not connected to geometry"))
      (setq NCGlist (append NCGlist (list cgpname)))
)
      );if IS is in imported geometry
   ));if not sideshot

       ;if datum point draw datum point and label
       
(if (and (/= cgdesc nil)(= simplestop "0"))(progn
		   	 (SETVAR "CLAYER"  "Datum Points" )
		      (COMMAND "POINT" cgco)
		 (SETQ SENT (ENTLAST))
  (SETQ SENTLIST (ENTGET SENT))
(SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 cgdesc)))))
		     (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)
       (SETQ TEXTPOS (LIST (-  (car cgco) TH) (+  (cadr cgco) (* 0.5 TH))))
		 (SETVAR "CLAYER"  "Drafting" )
  		 (COMMAND "TEXT" "J" "BR"  TEXTPOS (* TH 2) "90" cgdesc)
  ));p&if datum
       


       
       ))
(linereader)

   ));p&while not cgpoint end

  

  ;start again to establish shifts for sideshots
       (close xmlfile)
  (setq xmlfile (open xmlfilen "r"))
      
 
  ;CGPOINTS sideshots-------------------------------------
  ;linefeed to cgpoints

   (while (= (vl-string-search "<CgPoints" linetext) nil) ( progn
 (linereader)
))


 (linereader)
  ;do until end of cgpoints
      (while (= (vl-string-search "</CgPoints" linetext) nil) ( progn
   (if (/= (vl-string-search "<CgPoint" linetext )nil)
     (progn
       ;store line information
       (if (/= (setq stringpos (vl-string-search "state" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 7)))(setq cgpstate (substr linetext (+ stringpos 8) (-(- wwpos 1)(+ stringpos 6)))))(setq cgpstate nil))
              (if (/= (setq stringpos (vl-string-search "pntSurv" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 9)))(setq cgpntsurv (substr linetext (+ stringpos 10) (-(- wwpos 1)(+ stringpos 8)))))(setq cgpntsurv nil))
              (if (/= (setq stringpos (vl-string-search "name" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 6)))(setq cgpname (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5)))))(setq cgpname nil))
                     (if (/= (setq stringpos (vl-string-search "oID" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 5)))(setq cgpoID (substr linetext (+ stringpos 6) (-(- wwpos 1)(+ stringpos 4)))))(setq cgpoID nil))
                            (if (/= (setq stringpos (vl-string-search "desc" linetext )) nil)(progn
(setq wwpos (vl-string-position 34 linetext (+ stringpos 6)))(setq cgdesc (substr linetext (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5)))))(setq cgdesc nil))

              	  
			    
       ;get cgpoint coodintes

       ;possibly need an IS to cgpname list here later on
       
       (if (or (member cgpname NCGlist)(= (member cgpname islist) nil))
	 (progn

                          (if (/= (setq stringpos (vl-string-search ">" linetext )) nil)(progn
(setq <pos (vl-string-position 60 linetext (+ stringpos 2)))
(if (= <pos nil)(setq <pos 2000))
(setq spcpos (vl-string-position 32 linetext stringpos))
(setq north (atof (substr linetext (+ stringpos 2) (- spcpos (+ stringpos 1) ))))
(setq east (atof (substr linetext (+ spcpos 2) (- (- <pos 1) spcpos ))))
(setq cgss (list east north))
))

	   ;find closest new position to establish shift for sideshot
(setq mindist 10000000000000000000000000000000000000000000000000000000000000000000)
(setq sscount 0)
(repeat (length origcgpointlist)
  (setq origco (nth sscount origcgpointlist))
  (setq newco (nth sscount newcgpointlist))
  (if (< (distance cgss origco) mindist)(setq shift (list (- (car newco)(car origco))(- (cadr newco)(cadr origco)))
							       mindist (distance cgss origco)))
  (setq sscount (+ sscount 1))
    )

(setq cgcos (strcat (rtos(+ (car shift) east) 2 6) "," (rtos(+ (cadr shift) north)2 6)))

 (setq cgpointlist (append cgpointlist (list cgpname) (list cgcos)(list (substr cgpntsurv 1 1))))

	   ;check for max east min north
	   
	   (if (> (+ (car shift) east) maxeast) (setq maxeast (+ (car shift) east)))
           (if (< (+ (cadr shift) north) minnorth)(setq minnorth (+ (cadr shift) north)))

	   ;DRAW CG POINTS   
       (if (= simplestop "0")(progn
       (SETVAR "CLAYER"  "CG Points" )
       (setq p1 (list  (+ (car shift) east)  (+ (cadr shift) north)))
       (command "point" p1)
       (COMMAND "TEXT" "J" "BL"  P1 (* TH 0.25) "90" (strcat cgpname (substr cgpntsurv 1 1)(substr cgpstate 1 1)))
	   ))
));p&if sideshot

    

       ))
  (linereader)
   ));p&while not cgpoint end

  (if (= simplestop "0")(command "erase" dellines ""))

  )     


 

  

(defun c:xsw (/) ; SWAP TEXT POSITIONS


  (SETQ LINES (SSGET  '((0 . "TEXT"))))

  (SETQ COUNT 0)

(SETQ P1 (CDR(ASSOC 11 (ENTGET (SSNAME LINES COUNT)))))
(SETQ P2 (CDR(ASSOC 11 (ENTGET (SSNAME LINES (+ COUNT 1))))))
  (SETQ EN1 (CDR(ASSOC -1 (ENTGET (SSNAME LINES COUNT)))))
  (SETQ EN2 (CDR(ASSOC -1 (ENTGET (SSNAME LINES (+ COUNT 1))))))

  (SETQ EN1G (ENTGET EN1))
  (SETQ EN2G (ENTGET EN2))
  
  (SETQ	EN1G (subst (cons 11  P2)(assoc 11 EN1G) EN1G ) )
 
  (ENTMOD EN1G)

  (SETQ	EN2G (subst (cons 11  P1)(assoc 11 EN2G) EN2G ) )
  (ENTMOD EN2G)

  )

(defun c:xsp (/) ;SPIN TEXT 180


  (SETQ LINES (SSGET  '((0 . "TEXT"))))

  (SETQ COUNT 0)

  (repeat (sslength lines)
(SETQ P1 (CDR(ASSOC 11 (ENTGET (SSNAME LINES COUNT)))))
(SETQ ROT (CDR(ASSOC 50 (ENTGET (SSNAME LINES COUNT)))))
  (SETQ EN1 (CDR(ASSOC -1 (ENTGET (SSNAME LINES COUNT)))))

    (SETQ ROT (+ ROT PI))
    (IF (> ROT (* 2 PI))(SETQ ROT (- ROT (* 2 PI))))

  (SETQ EN1G (ENTGET EN1))
    
  (SETQ	EN1G (subst (cons 50  ROT)(assoc 50 EN1G) EN1G ) )
 
  (ENTMOD EN1G)

    (SETQ COUNT (+ COUNT 1))
    )

  )

(defun C:XSB (/)

  (PRINC "\nSelect bearings to spread:")
  (SETQ LINES (SSGET  '((0 . "TEXT"))))

  (SETQ COUNT 0)
  (SETQ P1 (CDR(ASSOC 11 (ENTGET (SSNAME LINES COUNT)))))
(SETQ ROT (CDR(ASSOC 50 (ENTGET (SSNAME LINES COUNT)))))
  (SETQ EN1 (CDR(ASSOC -1 (ENTGET (SSNAME LINES COUNT)))))
  (SETQ TEXTHEIGHT (CDR(ASSOC 40 (ENTGET (SSNAME LINES COUNT)))))
  (SETQ ZA (CDR(ASSOC 210 (ENTGET (SSNAME LINES COUNT)))))
(SETQ TEXT (CDR(ASSOC 1 (ENTGET (SSNAME LINES COUNT)))))
(SETQ TEXTCHK TEXT)
  (SETQ P1 (TRANS P1 ZA 0))
  (SETQ P1 (TRANS P1 0 1))
  
  (SETQ MINX (CAR P1))
  (SETQ MAXX (CAR P1))
  (SETQ MINY (CADR P1))
  (SETQ MAXY (CADR P1))

  (SETQ SP P1)
  (SETQ EP P1)
  
  (SETQ COUNT 1)
  (REPEAT (-(SSLENGTH LINES) 1)

    (SETQ P1 (CDR(ASSOC 11 (ENTGET (SSNAME LINES COUNT)))))
(SETQ ANG (CDR(ASSOC 50 (ENTGET (SSNAME LINES COUNT)))))
  (SETQ EN1 (CDR(ASSOC -1 (ENTGET (SSNAME LINES COUNT)))))
(SETQ TEXT (CDR(ASSOC 1 (ENTGET (SSNAME LINES COUNT)))))
    (SETQ P1 (TRANS P1 ZA 0))
    (SETQ P1 (TRANS P1 0 1))

    

    (IF (/= TEXT TEXTCHK)(PROGN
			   (PRINC "\nAll bearings not the same")
			   (QUIT)
			   ))
(IF (/= (RTOS MAXX 2 4) (RTOS (CAR P1) 2 4))(PROGN ;CASE IF NOT EXACTLY NORTH SOUTH
    
    (IF (> (CAR P1) MAXX)(SETQ EP P1
			       MAXX (CAR P1)))
    
    (IF (< (CAR P1) MINX)(SETQ SP P1
			       MINX (CAR P1)))
    )
  (PROGN;CASE IF EXACTLY NORTH SOUTH
     (IF (> (CADR P1) MAXY)(SETQ EP P1
			       MAXY (CADR P1)))
    
    (IF (< (CADR P1) MINY)(SETQ SP P1
			       MINY (CAR P1)))
    )
  )
  
    
    
(SETQ COUNT (+ COUNT 1))
    )

  

  (if (/= (setq wwpos (vl-string-position 34 text 0)) nil)(progn ;seconds exist so 3 spread
						  (setq degpos (vl-string-position 176 text 0))
						  (setq wpos (vl-string-position 39 text 0))
						  (setq deg (substr text 1 (+ degpos 1)))
						  (setq mins (substr text (+ degpos 2)(- wpos degpos)))
						  (setq sec (substr text (+ wpos 2) 50))
						  (setq mp (list (/ (+ (CAR SP)(CAR EP)) 2)(/ (+ (CADR SP)(CADR EP)) 2)))

						  (SETQ SP (TRANS SP 1 0))
						  (SETQ MP (TRANS MP 1 0))
						  (SETQ EP (TRANS EP 1 0))
						   (SETQ ANG (ANGLE SP EP))
						  (SETVAR "CLAYER" "DRAFTING")
						  (COMMAND "UCS" "W")
						  (COMMAND "TEXT" "J" "MC"     sp    TEXTHEIGHT (ANGTOS ANG 1 4) DEG)
						  (COMMAND "TEXT" "J" "MC"     mp   TEXTHEIGHT (ANGTOS ANG 1 4) MINS)
						  (COMMAND "TEXT" "J" "MC"     ep   TEXTHEIGHT (ANGTOS ANG 1 4) SEC)
						  (command "erase" lines "")
						  (COMMAND "UCS" "p")
						  

						  )
    (progn ;else deg and mins
      (setq degpos (vl-string-position 176 text 0))
      (setq deg (substr text 1 (+ degpos 1)))
      (setq mins (substr text (+ degpos 1) 50))

      
     (SETQ SP (TRANS SP 1 0))
      (SETQ EP (TRANS EP 1 0))
      (SETQ ANG (ANGLE SP EP))
      (COMMAND "UCS" "W")
       (COMMAND "TEXT" "J" "MC"     sp   TEXTHEIGHT (ANGTOS ANG 1 4) DEG)
       (COMMAND "TEXT" "J" "MC"     ep    TEXTHEIGHT (ANGTOS ANG 1 4) MINS)
      (command "erase" lines "")
      (COMMAND "UCS" "P")
      
      )
    )
  )


;------------------------------------------------create brackets around text ------------------------------
(DEFUN C:XCB (/)
						  
      (setvar "clayer" prevlayer)
  
  (SETQ LINES (SSGET  '((0 . "TEXT"))))

  (SETQ COUNT 0)

  (repeat (sslength lines)
(SETQ P1 (CDR(ASSOC 11 (ENTGET (SSNAME LINES COUNT)))))
(SETQ TEXT (CDR(ASSOC 1 (ENTGET (SSNAME LINES COUNT)))))
  (SETQ EN1 (CDR(ASSOC -1 (ENTGET (SSNAME LINES COUNT)))))

    (SETQ TEXT (STRCAT "(" TEXT ")"))

  (SETQ EN1G (ENTGET EN1))
    
  (SETQ	EN1G (subst (cons 1 TEXT)(assoc 1 EN1G) EN1G ) )
 
  (ENTMOD EN1G)

    (SETQ COUNT (+ COUNT 1))
    )

  )
						  

   
; real-time LandXML4AC XData viewer  - Thanks to Roumen Mollov for the code.

(defun c:XHV () (dxdata "landxml") (princ))


; used subs 
; display app xdata *****************

(defun dxdata ( app / *error* val var gr ent text ent str norm pt lst)
  (vl-load-com)
  (defun *error* (msg)
    (and msg (not (wcmatch (strcase msg t ) "*break,*cancel*,*exit*" )) (princ (strcat "*** Err: " msg)))
    (and text (entdel text))
    (and ent (redraw ent 4))
    (princ)
  )
  (setq val (mapcar 'getvar (setq var '("cmdecho" "blipmode" "osmode" "clayer" "textstyle"))))
  (mapcar 'setvar '("cmdecho" "blipmode" "osmode" ) '(0 0 1 ))
  ;(vl-cmdf "-style" "ANI" "ARIAL NARROW ITALIC" "0.0" "1" "0" "NO" "NO")

  
  (sssetfirst nil nil)
  (while (= (car (setq gr (grread t 14 2))) 5)
    (and text (entdel text) (setq text nil))
    (and ent (redraw ent 4))
    (setq pt (cadr gr))
    (if (and (setq ent (ssget pt (list (list -3 (list app)))))
             (setq ent (ssname ent 0))
             (setq lst (cdadr (assoc -3 (entget ent (list app)))))
        )
      (progn (redraw ent 3)
             (setq size (/ (getvar "VIEWSIZE") 50.0) ; hauteur de texte
                   norm (trans '(0 0 1) 2 0 t)
                   text (entmakex (append (list '(0 . "MTEXT")
                                                '(100 . "AcDbEntity")
                                                '(100 . "AcDbMText")
                                                (cons 10 (trans (polar (trans pt 1 2) (* pi 1.75) size) 2 0))
                                                (cons 40 size)
                                                '(41 . 0.)
                                                (cons 1 "")
                                                (cons 7 (getvar 'textstyle))
                                                (cons 210 norm)
						(cons 71 2)
                                                (cons 11 (trans '(1 0 0) 2 0 t))
                                          )
                                          (if (assoc 1070 lst)
                                            (list (cons 90 (cdr (assoc 1070 lst)))
                                                  (cons 63 (cdr (assoc 1071 lst)))
                                                  (cons 45 (cdr (assoc 1040 lst)))
                                            )
                                          )
                                  )
                        )
             )
             (vla-put-textstring (vlax-ename->vla-object text) (cdr (assoc 1000 lst)))
      )
    )
  )
  (mapcar 'setvar var val)
  (*error* nil)
); defun

;----------------------------------------------------COORDINATE TIDY--------------------------------------------


(defun C:XCT (/)

  (setq coords7 nil);list of coords to 7 decimal places
  (setq coords4 nil);list of coords to 4 decimal places

  ;get coordinates of all boundary,road and easement lines and make 2 lists

 ;get  lines
    (princ "\nProcessing Boundary Lines ")
 
(IF (/= (setq bdyline (ssget "_X" '((0 . "LINE") (8 . "Boundary,Road,Easement")))) nil)(progn 
  (setq count 0)
  (repeat (sslength bdyline)
  (SETQ P1 (CDR(ASSOC 10 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ P2 (CDR(ASSOC 11 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME bdyline COUNT)))))
	  

    (setq p1s7 (strcat (rtos (car p1) 2 7) "," (rtos (cadr p1) 2 7)))
    (setq p2s7 (strcat (rtos (car p2) 2 7) "," (rtos (cadr p2) 2 7)))
    (setq p1s4 (strcat (rtos (car p1) 2 4) "," (rtos (cadr p1) 2 4)))
    (setq p2s4 (strcat (rtos (car p2) 2 4) "," (rtos (cadr p2) 2 4)))

    (setq coords7 (append coords7 (list p1s7)(list p2s7)))
    (setq coords4 (append coords4 (list p1s4)(list p2s4)))
    

   
    (setq count (+ count 1))
    );r
  );p
 
  );if

;get arcs
  (princ "\nProcessing Boundary Arcs ")
(IF (/= (setq bdyline (ssget "_X" '((0 . "ARC") (8 . "Boundary,Road,Easement")))) nil)(progn 
 

    (setq count 0)
  (repeat (sslength bdyline)


(SETQ CP (CDR(ASSOC 10 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ RADIUS (CDR(ASSOC 40 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ ANG1 (CDR(ASSOC 50 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ ANG2 (CDR(ASSOC 51 (ENTGET (SSNAME bdyline COUNT)))))

  (SETQ P1 (POLAR CP ANG1 RADIUS))
  (SETQ P2 (POLAR CP ANG2 RADIUS))
;CONVERT TO WCS
    (SETQ ZA (CDR(ASSOC 210 (ENTGET (SSNAME bdyline COUNT)))))
    (SETQ CP (TRANS CP ZA 0))
    (SETQ P1 (TRANS P1 ZA 0))
    (SETQ P2 (TRANS P2 ZA 0))
    (if (< (caddr za) 0)(setq TEMP1 P1
			      P1 P2
			      P2 TEMP1))
    

    (setq p1s7 (strcat (rtos (car p1) 2 7) "," (rtos (cadr p1) 2 7)))
    (setq p2s7 (strcat (rtos (car p2) 2 7) "," (rtos (cadr p2) 2 7)))
    (setq p1s4 (strcat (rtos (car p1) 2 4) "," (rtos (cadr p1) 2 4)))
    (setq p2s4 (strcat (rtos (car p2) 2 4) "," (rtos (cadr p2) 2 4)))

    (setq coords7 (append coords7 (list p1s7)(list p2s7)))
    (setq coords4 (append coords4 (list p1s4)(list p2s4)))
    ;(setq cps (strcat (rtos (cadr cp) 2 6) " " (rtos (car cp) 2 6)))

 (setq count (+ count 1))
    );r
  );p
 
  );if

;get lot definitons

(IF (/= (setq lots (ssget "_X" '((0 . "LWPOLYLINE") (8 . "Lot Definitions")))) nil)
  (progn
(setq count 0)
    (repeat (sslength lots);do for number of polylines
      (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME LOTS COUNT)))))

      (setq ed (entget en))
(setq i 0)
      (repeat (length ed)

	(if (= (car (nth i ed)) 10) ;if item is a vertex 
	  (progn
	    (setq vt (cdr (nth i ed))) ; get vertex values

	    (setq testpoint4 (strcat (rtos (car vt) 2 4) "," (rtos (cadr vt) 2 4)))
	    (setq testpoint7 (strcat (rtos (car vt) 2 7) "," (rtos (cadr vt) 2 7)))

	    (if (setq remlist (member testpoint4 coords4))(progn
							    
	      (setq finecoord (nth (- (length coords4) (length remlist)) coords7));check in low precision list and return high precision value

	    (if (/= testpoint7 finecoord)(progn
					     
					     (setq ,pos1 (vl-string-position 44 finecoord 0))
					     (setq east  (substr finecoord 1 ,pos1))
					     (setq north  (substr finecoord (+ ,pos1 2) 50))
					     (setq newpt (list (atof east)(atof north)))
					     (setq ed (subst (cons 10 newpt) (nth i ed) ed))
					     (entmod ed) ; update the drawing
					   (princ (strcat "\nLot Vertex at " (strcat (rtos (car vt) 2 3) "," (rtos (cadr vt) 2 3)) " moved by " (rtos (distance vt newpt) 2 9)))
					     ));p&if not same to 7 dec plcs
	      ));p&if memebr of coords4
	      ));p&if vertex
	(setq i (+ i 1))
	);r polyline
      (setq count (+ count 1))
      );r number of polylines
));p&if lot polylines in drawing

  )
					     
					     
(defun symbolreplace (/)


  ;search for symbols and replace with xml symbols for description and fieldnote


  ;FIELDNOTE
	         (if (/= (setq stringpos (vl-string-search "<FieldNote>" xdatai )) nil)(progn
(setq endstringpos (vl-string-search "</FieldNote>" xdatai (+ stringpos 12)))
  
  
  (setq sybpos (+ stringpos 12))

	      (while (and (/=  (setq sybpos (vl-string-search "&" xdatai sybpos )) nil)(< sybpos (- endstringpos 1)))
		(setq xdatai (vl-string-subst "&amp;" "&"  xdatai sybpos)
		      sybpos (+ sybpos 4)))

(setq sybpos (+ stringpos 12))
	      (while (and (/=  (setq sybpos (vl-string-search "'" xdatai sybpos )) nil)(< sybpos (- endstringpos 1)))
		(setq xdatai (vl-string-subst "&apos;" "'"  xdatai sybpos)
		      sybpos (+ sybpos 4)))
      
       (setq sybpos (+ stringpos 12))
	      (while (and (/=  (setq sybpos (vl-string-search (chr 34) xdatai sybpos )) nil)(< sybpos (- endstringpos 1)))
		(setq xdatai (vl-string-subst "&quot;" (chr 34)  xdatai sybpos)
		      sybpos (+ sybpos 4)))

	            (setq sybpos (+ stringpos 12))
	      (while (and (/=  (setq sybpos (vl-string-search "�" xdatai sybpos )) nil)(< sybpos (- endstringpos 1)))
		(setq xdatai (vl-string-subst "&#176;" "�"  xdatai sybpos)
		      sybpos (+ sybpos 5)))

));p&if fieldnote found

   ;MONUMENTTYPE
	         (if (/= (setq stringpos (vl-string-search "type" xdatai )) nil)(progn
(setq endstringpos (vl-string-position 34 xdatai (+ stringpos 6)))

 
  
  (setq sybpos (+ stringpos 6))
	      (while (and (/=  (setq sybpos (vl-string-search "&" xdatai sybpos )) nil)(< sybpos (- endstringpos 1)))
		(setq xdatai (vl-string-subst "&amp;" "&"  xdatai sybpos)
		      sybpos (+ sybpos 4)))
		

(setq sybpos (+ stringpos 6))
	      (while (and (/=  (setq sybpos (vl-string-search "'" xdatai sybpos )) nil)(< sybpos (- endstringpos 1)))
		(setq xdatai (vl-string-subst "&apos;" "'"  xdatai sybpos)
		      sybpos (+ sybpos 4)))
       
       (setq sybpos (+ stringpos 6))
	      (while (and (/=  (setq sybpos (vl-string-search (chr 34) xdatai sybpos )) nil)(< sybpos (- endstringpos 1)))
		(setq xdatai (vl-string-subst "&quot;" (chr 34)  xdatai sybpos)
		      sybpos (+ sybpos 4)))

	            (setq sybpos (+ stringpos 6))
	      (while (and (/=  (setq sybpos (vl-string-search "�" xdatai sybpos )) nil)(< sybpos (- endstringpos 1)))
		(setq xdatai (vl-string-subst "&#176;" "�"  xdatai sybpos)
		      sybpos (+ sybpos 5)))

));p&if type


    ;description
  
	         (if (/= (setq stringpos (vl-string-search "desc" xdatai )) nil)(progn
(setq endstringpos (vl-string-position 34 xdatai (+ stringpos 6)))

  
  
  (setq sybpos (+ stringpos 6))
	      (while (and (/=  (setq sybpos (vl-string-search "&" xdatai sybpos )) nil)(< sybpos (- endstringpos 1)))
		(setq xdatai (vl-string-subst "&amp;" "&"  xdatai sybpos)
		      sybpos (+ sybpos 4)))
		

(setq sybpos (+ stringpos 6))
	      (while (and (/=  (setq sybpos (vl-string-search "'" xdatai sybpos )) nil)(< sybpos (- endstringpos 1)))
		(setq xdatai (vl-string-subst "&apos;" "'"  xdatai sybpos)
		      sybpos (+ sybpos 4)))
       
       (setq sybpos (+ stringpos 6))
	      (while (and (/=  (setq sybpos (vl-string-search (chr 34) xdatai sybpos )) nil)(< sybpos (- endstringpos 1)))
		(setq xdatai (vl-string-subst "&quot;" (chr 34)  xdatai sybpos)
		      sybpos (+ sybpos 4)))

	            (setq sybpos (+ stringpos 6))
	      (while (and (/=  (setq sybpos (vl-string-search "�" xdatai sybpos )) nil)(< sybpos (- endstringpos 1)))
		(setq xdatai (vl-string-subst "&#176;" "�"  xdatai sybpos)
		      sybpos (+ sybpos 5)))

));p&if description found
  );defun
  

	      
       


;-------------------------------------------------------------AUDIT XML-----------------------------------


(DEFUN C:XAUD (/)

  (setq prevlayer (getvar "CLAYER"))

 (SETQ LINES (SSGET  '((0 . "LINE,ARC") (8 . "Road,Road Extent,Boundary,Easement,Connection,RM Connecion,PM Connection"))))

  (SETQ COUNT 0)
(REPEAT (SSLENGTH LINES)

   (SETQ OBJTYPE (CDR(ASSOC 0 (ENTGET (SSNAME LINES COUNT)))))
  (IF (= OBJTYPE "LINE")
    (PROGN
  

  
(SETQ P1 (CDR(ASSOC 10 (ENTGET (SSNAME LINES COUNT)))))
  (SETQ P1 (LIST (CAR P1) (CADR P1)));2DISE P1 TO GIVE 2D DISTANCE
  (SETQ P2 (CDR(ASSOC 11 (ENTGET (SSNAME LINES COUNT)))))
  (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME LINES COUNT)))))
  (SETQ LAYER (CDR(ASSOC 8 (ENTGET (SSNAME LINES COUNT)))))

  (SETQ MPE (/ (+ (CAR P1 ) (CAR P2)) 2))
    (SETQ MPN (/ (+ (CADR P1 ) (CADR P2)) 2))
    (SETQ MP (LIST MPE MPN))


;GET XDATA BEARING AND DISTANCE
  
    	    (SETQ XDATAI (ENTGET EN '("LANDXML")))
	   (IF (= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL) (progn
	      	     (COMMAND "CHANGE" en "" "P" "C" "6" "")
	      (princ (strcat "\nBoundary Line with no XML data at " (rtos (car p1) 2 3) "," (rtos (cadr p1)2 3)))
	     ))
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))


   
    	    (setq stringpos (vl-string-search "azimuth" xdatai ))
	    (setq wwpos (vl-string-position 34 xdatai (+ stringpos 9)))
            (setq xbearing (substr xdatai (+ stringpos 10) (-(- wwpos 1)(+ stringpos 8))))
            (setq stringpos (vl-string-search "horizDistance" xdatai ))
	    (setq wwpos (vl-string-position 34 xdatai (+ stringpos 15)))
            (setq xdist (atof (substr xdatai (+ stringpos 16) (-(- wwpos 1)(+ stringpos 14)))))


       ;APPLY ALL CORRECTIONS AND EXTRACT INFORMATION FROM USER INPUT
(if (/= (vl-string-position 46 Xbearing 0) nil ) (PROGN
  (setq dotpt1 (vl-string-position 46 Xbearing 0))
  (setq deg  (substr Xbearing 1  dotpt1 ))
  (SETQ mins   (substr Xbearing (+ dotpt1 2) 2) )
  (if (= (strlen mins) 1)(setq mins (strcat  mins "0")));fix problem with truncating zeros on minutes and seconds
  (setq mins (strcat mins "'"))
  (setq sec  (substr Xbearing (+ dotpt1 4) 10))
  (if (= (strlen sec) 1) (setq sec (strcat sec "0")))
  (if (> (strlen sec) 2) (setq sec (strcat (substr sec 1 2) "." (substr sec 3 10))))
  (if (= (strlen sec) 0) (setq sec "00") (setq sec (strcat sec (chr 34))))

  )
  (progn
    (setq deg xbearing)
  (setq mins "00")
  (setq sec "00")
  )
  )

;check for non rounded seconds

;(if (> (- (/ (atof sec) 5)(fix (/ (atof sec) 5))) 0)
;  (progn
;     (COMMAND "CHANGE" en "" "P" "C" "191" "")
;      (command "layer" "m" "Miscloses" "c" "Red" "Miscloses" "" )
;      (command "text" "j" "r" MP "0.5" "90" "Non rounded bearing")
;    )
;  );if non round seconds

  (setq deg (atof deg))
  (setq mins (/ (atof mins) 60) )
  (setq sec (/ (atof sec) 3600))
  (setq xdd (+ deg mins sec))
  

  
  


;GET REAL BEARING 

  (SETQ ANG (ANGLE  P1  P2 ))

  (SETQ LBEARING (ANGTOS ANG 1 4));REQUIRED FOR ELSE ROUND
  (setq bearing (vl-string-subst "d" (chr 176) lbearing));added for BricsCAD changes degrees to "d"
  (SETQ LDIST (DISTANCE (LIST (CAR P1)(CADR P1)) P2));REQUIRED FOR ELSE ROUND


   (SETQ SANG (ANGTOS ANG 1 4))
    (setq sang (vl-string-subst "d" (chr 176) sang));added for BricsCAD changes degrees to "d"
    (setq CHRDPOS (vl-string-position 100 SANG 0))
    (setq MINPOS (vl-string-position 39 SANG 0))
    (setq SECPOS (vl-string-position 34 SANG 0))

 ;PARSE ANGLE
    (setq DEG  (substr SANG 1  CHRDPOS ))
    (setq MINS   (substr SANG (+ CHRDPOS 2)  (-(- MINPOS CHRDPOS)1)))
    (setq SEC  (substr SANG (+ MINPOS 2)  (-(- SECPOS MINPOS )1)))
  

   (setq deg (atof deg))
  (setq mins (/ (atof mins) 60) )
  (setq sec (/ (atof sec) 3600))
  (setq ldd (+ deg mins sec))
  
  (if (or (> (abs (- xdd ldd)) 1) (> (ABS (- XDIST LDIST)) 0.1))
    (PROGN
      
      (COMMAND "CHANGE" en "" "P" "C" "6" "")
      (command "layer" "m" "Miscloses" "c" "Red" "Miscloses" "" )
      (command "text" MP "0.5" "90" (STRCAT "BRG:" (RTOS (- xdd ldd) 2 1) " DST:" (RTOS (- XDIST LDIST) 2 3)))
));if out of tolerance

 
));P IF LINE


										     




;-----------------------------------------------------ARCS------------------------------------------------------------------


  
  (IF (= OBJTYPE "ARC")
    (PROGN
    
 



(SETQ CP (CDR(ASSOC 10 (ENTGET (SSNAME LINES COUNT)))))
  
  (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME LINES COUNT)))))
  (SETQ LAYER (CDR(ASSOC 8 (ENTGET (SSNAME LINES COUNT)))))

  

;GET XDATA BEARING AND DISTANCE
  
    	    (SETQ XDATAI (ENTGET EN '("LANDXML")))
	   (IF (= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL) (progn
	      	     (COMMAND "CHANGE" en "" "P" "C" "6" "")
	      (princ (strcat "\nBoundary Line with no XML data at " (rtos (car p1) 2 3) "," (rtos (cadr p1)2 3)))
	     ))
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))


   
    	     (setq stringpos (vl-string-search "chordAzimuth" XDATAI ))
	    (setq wwpos (vl-string-position 34 XDATAI (+ stringpos 14)))
            (setq bearing (substr XDATAI (+ stringpos 15) (-(- wwpos 1)(+ stringpos 13))))
	    (setq xbearing bearing)

	    (setq stringpos (vl-string-search "length" XDATAI ))
	    (setq wwpos (vl-string-position 34 XDATAI (+ stringpos 8)))
            (setq arclength (substr XDATAI (+ stringpos 9) (-(- wwpos 1)(+ stringpos 7))))
	    (setq arclength (rtos (atof arclength)2 3));remove trailing zeros

	    (setq stringpos (vl-string-search "radius" XDATAI ))
	    (setq wwpos (vl-string-position 34 XDATAI (+ stringpos 8)))
            (setq Xradius (substr XDATAI (+ stringpos 9) (-(- wwpos 1)(+ stringpos 7))))
	    

	    (setq stringpos (vl-string-search "rot" XDATAI ))
	    (setq wwpos (vl-string-position 34 XDATAI (+ stringpos 5)))
            (setq curverot (substr XDATAI (+ stringpos 6) (-(- wwpos 1)(+ stringpos 4))))


  ;calc arc internal angle
(SETQ Chorddist (* 2 (* (atof xradius) (sin(/ (atof arclength) (* 2 (atof xradius)))))))
	      (SETQ MAST (SQRT (- (* (atof XRADIUS) (atof XRADIUS)) (* (/ chorddist 2)(/ chorddist 2 )))))
  (SETQ O (* 2 (ATAN (/ (/ chorddist 2) MAST))))
	    (setq remhalfO  (- (* 0.5 pi) (/ O 2)))
	    ;calc bearing from p1 to arc centre (watching for bulbous arcs)
	  

	    
	  	    
  					   
;calc chord distance, note using string values not digital values
	    (setq stringO (/ (atof arclength) (atof Xradius)));arc internal angle based on string values
	    (setq Xdist (* 2  (ATOF Xradius) (sin (/ stringO 2))))

  


       ;APPLY ALL CORRECTIONS AND EXTRACT INFORMATION FROM USER INPUT
(if (/= (vl-string-position 46 Xbearing 0) nil ) (PROGN
  (setq dotpt1 (vl-string-position 46 Xbearing 0))
  (setq deg  (substr Xbearing 1  dotpt1 ))
  (SETQ mins   (substr Xbearing (+ dotpt1 2) 2) )
  (if (= (strlen mins) 1)(setq mins (strcat  mins "0")));fix problem with truncating zeros on minutes and seconds
  (setq mins (strcat mins "'"))
  (setq sec  (substr Xbearing (+ dotpt1 4) 10))
  (if (= (strlen sec) 1) (setq sec (strcat sec "0")))
  (if (> (strlen sec) 2) (setq sec (strcat (substr sec 1 2) "." (substr sec 3 10))))
  (if (= (strlen sec) 0) (setq sec "") (setq sec (strcat sec (chr 34))))

  )
  (progn
    (setq deg xbearing)
  (setq mins "00")
  (setq sec "00")
  )
  )

  (setq deg (atof deg))
  (setq mins (/ (atof mins) 60) )
  (setq sec (/ (atof sec) 3600))
  (setq xdd (+ deg mins sec))





(SETQ CP (CDR(ASSOC 10 (ENTGET (SSNAME LINES COUNT)))))
(SETQ RADIUS (CDR(ASSOC 40 (ENTGET (SSNAME LINES COUNT)))))
  (SETQ ANG1 (CDR(ASSOC 50 (ENTGET (SSNAME LINES COUNT)))))
  (SETQ ANG2 (CDR(ASSOC 51 (ENTGET (SSNAME LINES COUNT)))))

  (SETQ P1 (POLAR CP ANG1 RADIUS))
  (SETQ P2 (POLAR CP ANG2 RADIUS))
(IF (= curverot "ccw")  (SETQ ANG (ANGLE P1 P2)))
(if (= curverot "cw") (setq ang (angle P2 P1)))

  

  ;calc curve midpoint

  

  (SETQ LBEARING (ANGTOS ANG 1 4))
  (setq bearing (vl-string-subst "d" (chr 176) Lbearing));added for BricsCAD changes degrees to "d"
  (SETQ LDIST  (DISTANCE (LIST (CAR P1)(CADR P1))P2))


  
   (SETQ SANG (ANGTOS ANG 1 4))
    (setq sang (vl-string-subst "d" (chr 176) sang));added for BricsCAD changes degrees to "d"
    (setq CHRDPOS (vl-string-position 100 SANG 0))
    (setq MINPOS (vl-string-position 39 SANG 0))
    (setq SECPOS (vl-string-position 34 SANG 0))

 ;PARSE ANGLE
    (setq DEG  (substr SANG 1  CHRDPOS ))
    (setq MINS   (substr SANG (+ CHRDPOS 2)  (-(- MINPOS CHRDPOS)1)))
    (setq SEC  (substr SANG (+ MINPOS 2)  (-(- SECPOS MINPOS )1)))
  

   (setq deg (atof deg))
  (setq mins (/ (atof mins) 60) )
  (setq sec (/ (atof sec) 3600))
  (setq ldd (+ deg mins sec))



  (SETQ MPE (/ (+ (CAR P1 ) (CAR P2)) 2))
    (SETQ MPN (/ (+ (CADR P1 ) (CADR P2)) 2))
    (SETQ MP (LIST MPE MPN))
  
  
  (if (or (> (abs (- xdd ldd)) 1) (> (ABS (- XDIST LDIST)) 0.1))
    (PROGN
      
      (COMMAND "CHANGE" en "" "P" "C" "6" "")
      (command "layer" "m" "Miscloses" "c" "Red" "Miscloses" "" )
      (command "text" MP "0.5" "90" (STRCAT "BRG:" (RTOS (- xdd ldd) 2 1) " DST:" (RTOS (- XDIST LDIST) 2 3)))
));if out of tolerance

 ));P & IF ARC

  (SETQ COUNT (+ COUNT 1))

  );R


  

      (SETVAR "CLAYER" prevlayer)





  
  );DEFUN






;----------------------------------------------------relabel text from xdata----------------------------------------------------
(DEFUN C:XRT (/)
 (setq prevlayer (getvar "CLAYER"))
  (SETQ LINES (SSGET  '((0 . "LINE"))))

  (SETQ COUNT 0)
(REPEAT (SSLENGTH LINES)
(SETQ P1 (CDR(ASSOC 10 (ENTGET (SSNAME LINES COUNT)))))
  (SETQ P1 (LIST (CAR P1) (CADR P1)));2DISE P1 TO GIVE 2D DISTANCE
  (SETQ P2 (CDR(ASSOC 11 (ENTGET (SSNAME LINES COUNT)))))
  (SETQ LAYER (CDR(ASSOC 8 (ENTGET (SSNAME LINES COUNT)))))
(SETVAR "CLAYER" LAYER)
  (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME LINES COUNT)))))

		     (SETQ XDATAI (ENTGET EN '("LANDXML")))
	    (IF (= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL) (progn
	      	     (COMMAND "CHANGE" en "" "P" "C" "6" "")
	      (princ (strcat "\nERROR Selected Line has no XML data at " (rtos (car p1) 2 3) "," (rtos (cadr p1)2 3)))
	     ))
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))

   (setq stringpos (vl-string-search "azimuth" xdatai ))
	    (setq wwpos (vl-string-position 34 xdatai (+ stringpos 9)))
            (setq bearing (substr xdatai (+ stringpos 10) (-(- wwpos 1)(+ stringpos 8))))
	    (setq xbearing bearing)

	    (setq stringpos (vl-string-search "horizDistance" xdatai ))
	    (setq wwpos (vl-string-position 34 xdatai (+ stringpos 15)))
            (setq dist (substr xdatai (+ stringpos 16) (-(- wwpos 1)(+ stringpos 14))))

	  	    

	    (if (/= (setq stringpos (vl-string-search "<FieldNote>" xdatai )) nil)(progn
											   
(if (setq wwpos (vl-string-position 34 xdatai (+ stringpos 12)))
  (progn;if field not contains ""s
    (setq comment (substr xdatai (+ stringpos 13) (-(- wwpos 1)(+ stringpos 11))))
    )
  (progn; else use the < to get other end of field note
    (setq <pos (vl-string-position 60 xdatai (+ stringpos 11)))
    (setq comment (substr xdatai (+ stringpos 12) (-(- <pos 1)(+ stringpos 10))))
    )
  )
)
  (setq comment ""))

  (if (/= (vl-string-position 46 bearing 0) nil ) (PROGN
  (setq dotpt1 (vl-string-position 46 bearing 0))
  (setq deg  (substr bearing 1  dotpt1 ))
  (SETQ mins   (substr bearing (+ dotpt1 2) 2) )
  (if (= (strlen mins) 1)(setq mins (strcat  mins "0")));fix problem with truncating zeros on minutes and seconds
  (setq mins (strcat mins "'"))
  (setq sec  (substr bearing (+ dotpt1 4) 10))
  (if (= (strlen sec) 1) (setq sec (strcat sec "0")))

  
  (if (> (strlen sec) 2) (setq sec (strcat (substr sec 1 2) "." (substr sec 3 10))))
  (if (= (strlen sec) 0) (setq sec "") (setq sec (strcat sec (chr 34))))
  
  );P
	(progn
	  (setq deg bearing)
	  (setq mins "")
	  (setq sec "")
	  );p else
  
  );IF

      
(setq bearing (strcat  deg "d" mins sec))
    ;(setq lbearing bearing)
	    (setq dist (rtos (atof dist)2 3));remove trailing zeros
	    
  (setq ldist (strcat dist ))

  (command "line" (trans p1 0 1) (trans p2 0 1) "")
  (setq delent (entlast))

  (lba)

  

  (command "erase" delent "")
  
(setq count (+ count 1))
  );r
  (SETVAR "CLAYER"  prevlayer )
  );defun



;----------------------------------------------------export mountuments to csv file------------------------------
  (Defun c:xmo (/)
   (setq prevlayer (getvar "CLAYER"))
  (SETVAR "CLAYER"  "CG Points" )
      
   (setq fn (getfiled "Output File" "" "TXT" 1)) 
 
  
  (SETQ outfile (OPEN fn "w"))

(WRITE-LINE (strcat "POINT,EAST,NORTH,HEIGHT,TYPE-STATE-CONDITION-ORIGIN-DESCRIPTION-PLAN" ) outfile)

      (IF (/= (setq bdyline (ssget '((0 . "POINT") (8 . "Monument,PM")))) nil)(progn

									      (setq ptnum (getreal "Start at:"))
  (setq count 0)
  (repeat (sslength bdyline)


(SETQ P1 (CDR(ASSOC 10 (ENTGET (SSNAME bdyline COUNT)))))
(SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME bdyline COUNT)))))
    (SETQ layer (CDR(ASSOC 8 (ENTGET (SSNAME bdyline COUNT)))))
    (SETQ ZA (CDR (ASSOC 210 (ENTGET (SSNAME bdyline COUNT)))))
    (SETQ P1 (TRANS P1 ZA 0))

    	    (SETQ XDATAI (ENTGET EN '("LANDXML")))
	    (IF (= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL) (progn
	      	     (COMMAND "CHANGE" en "" "P" "C" "6" "")
	      (princ (strcat "\nERROR RM point with no XML data at " (rtos (car p1) 2 3) "," (rtos (cadr p1)2 3)))
	     ))
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))
       (setq &pos 0)
	      (while (/=  (setq &pos (vl-string-search "&amp;" xdatai &pos )) nil) (setq xdatai (vl-string-subst "&" "&amp;"   xdatai &pos)
										      &pos (+ &pos 4)))

    (if (= layer "Monument")
      (progn
    (if (/= (setq stringpos (vl-string-search "type" XDATAI )) nil)(progn
(setq wwpos (vl-string-position 34 XDATAI (+ stringpos 6)))(setq montype (substr XDATAI (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5)))))(setq montype ""))
       (if (/= (setq stringpos (vl-string-search "desc" XDATAI )) nil)(progn
(setq wwpos (vl-string-position 34 XDATAI (+ stringpos 6)))(setq mondesc (substr XDATAI (+ stringpos 7) (-(- wwpos 1)(+ stringpos 5)))))(setq mondesc ""))
       (if (/= (setq stringpos (vl-string-search "state" XDATAI )) nil)(progn
(setq wwpos (vl-string-position 34 XDATAI (+ stringpos 7)))(setq monstate (substr XDATAI (+ stringpos 8) (-(- wwpos 1)(+ stringpos 6)))))(setq monstate ""))
       (if (/= (setq stringpos (vl-string-search "originSurvey" XDATAI )) nil)(progn
(setq wwpos (vl-string-position 34 XDATAI (+ stringpos 14)))(setq monrefdp (substr XDATAI (+ stringpos 15) (-(- wwpos 1)(+ stringpos 13)))))(setq monrefdp ""))
       (if (/= (setq stringpos (vl-string-search "condition" XDATAI )) nil)(progn
(setq wwpos (vl-string-position 34 XDATAI (+ stringpos 11)))(setq moncond (substr XDATAI (+ stringpos 12) (-(- wwpos 1)(+ stringpos 10)))))(setq moncond ""))
           (if (/= (setq stringpos (vl-string-search "refplan" XDATAI )) nil)(progn
(setq wwpos (vl-string-position 34 XDATAI (+ stringpos 9)))(setq refplan (substr XDATAI (+ stringpos 10) (-(- wwpos 1)(+ stringpos 8)))))(setq refplan ""))

    (WRITE-LINE (strcat (rtos  ptnum  2 0) "," (rtos (car p1) 2 3) "," (rtos (cadr p1) 2 3) "," (rtos (caddr p1) 2 3) "," montype "-" monstate "-" moncond "-" monrefdp "-" mondesc "-" refplan ) outfile)

    (command "text" p1 "0.5" "90" (rtos PTNUM 2 0))

    (setq pmnum (+ ptnum 1))
    ))

    (if (= layer "PM")
      (progn
	 ;cut pm number from xdata
      (setq ,pos1 (vl-string-position 44 xdatai 0))
    (setq pmnum  (substr xdatai 1 ,pos1 ))
    (setq xdatai  (substr xdatai (+ ,pos1 2) 500))
    ;cut state from xdata

       (if (/= (setq !pos1 (vl-string-position 33 xdatai 0)) nil)(progn
                      (setq pmstate (substr xdatai (+ !pos1 2) 200))
                      (setq xdatai  (substr xdatai 1 !pos1))
		      )
      (setq pmstate "Found")
      )


      (setq ormtype "")
        (if (= (substr pmnum 1 2) "PM")(setq ormtype ( strcat "PM")))
  (if (= (substr pmnum 1 2) "TS")(setq ormtype ( strcat "TS")))
  (if (= (substr pmnum 1 2) "MM")(setq ormtype ( strcat "MM")))
  (if (= (substr pmnum 1 2) "GB")(setq ormtype ( strcat "GB")))
  (if (= (substr pmnum 1 2) "CP")(setq ormtype ( strcat "CP")))
  (if (= (substr pmnum 1 2) "CR")(setq ormtype ( strcat "CR")))
  (if (= (substr pmnum 1 3) "SSM")(setq ormtype ( strcat "SSM")))

      

     (WRITE-LINE (strcat  pmnum  "," (rtos (car p1) 2 3) "," (rtos (cadr p1) 2 3) "," (rtos (caddr p1) 2 3) "," ormtype "-" pmstate "-"  "-"  "-" "-" refplan ) outfile)

))
      
       
  
    (setq count (+ count 1))
    

    );r
  ));p&if monuments

     (SETVAR "CLAYER"  prevlayer )
(CLOSE outfile)
)



;-------------------------------------------------------------------Add REFPLAN to Line-------------

(DEFUN C:XARP (/)

      

(PRINC "\n Select Lines to add Refplan to:")

  (setq bdyline (ssget  '((0 . "LINE,ARC,POINT")(8 . "Boundary,Road,Road Extent,Connection,RM Connection,PM Connection,Easement,Irregular Right Lines,Monument,PM" ))))

    (setq csf (getstring "\nRef Plan(or enter to select admin sheet):"))

  (if (= csf "")
    (progn
    (setq adminsheet (ssget  '((0 . "INSERT") (2 . "PLANFORM6,PLANFORM3"))))
    

		        (princ "\nProcessing Admin Sheet")

		(SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME ADMINSHEET 0)))))
		(SETQ BLOCKNAME (CDR(ASSOC 2 (ENTGET (SSNAME ADMINSHEET 0))))) 

							       
		(setq count 1)
  (SETQ ATTLIST (LIST))
	    
(setq Obj (vlax-ename->vla-object En))
	(foreach x (vlax-invoke Obj 'GetAttributes)
	  (SETQ ATT (vla-get-textstring X))
	  (if (= att "none") (setq att ""))

	  (setq &pos 0)
	   (while (/=  (setq &pos (vl-string-search "&" att &pos )) nil) (setq att (vl-string-subst "&amp;" "&"  att &pos)
										      &pos (+ &pos 4)))
	  
	  (setq crlfpos 0)
	   (while (/=  (setq crlfpos (vl-string-search "\\P" att crlfpos )) nil) (setq att (vl-string-subst "&#xA;" "\\P"  att crlfpos)
										      crlfpos (+ crlfpos 5)))
	             (setq crlfpos 0)
	   (while (/=  (setq crlfpos (vl-string-search "\n" att crlfpos )) nil) (setq att (vl-string-subst "&#xA;" "\n"  att crlfpos)
										      crlfpos (+ crlfpos 5)))


	  (setq attlist (append attlist (list att)))

	  )

		(setq csf (nth 0 attlist))
		))
   
      
      
  (setq count 0)
  (repeat (sslength bdyline)
  (SETQ P1 (CDR(ASSOC 10 (ENTGET (SSNAME bdyline COUNT)))))
  (SETQ EN (CDR(ASSOC -1 (ENTGET (SSNAME bdyline COUNT)))))

    	    (SETQ XDATAI (ENTGET EN '("LANDXML")))
	    (IF (= (SETQ XDATAI (ASSOC -3 XDATAI)) NIL) (progn
	      	     (COMMAND "CHANGE" en "" "P" "C" "6" "")
	      (princ (strcat "\nObject has not xdata " (rtos (car p1) 2 3) "," (rtos (cadr p1)2 3)))
	     ))
	    (SETQ XDATAI (NTH 1 XDATAI))
	    (SETQ XDATAI (CDR (NTH 1 XDATAI)))



    (if (/= (setq stringpos (vl-string-search "refplan" xdatai )) nil)(progn
(setq wwpos (vl-string-position 34 xdatai (+ stringpos 9)))
(setq stringpos1 (- stringpos 1)
       stringpos2 (+ wwpos 2) )
);p
      
(progn

 ;else
    (setq stringpos (vl-string-search ">" xdatai ))
  (setq stringpos/ (vl-string-search "/" xdatai))
  (if (= (- stringpos stringpos/) 1)(setq stringpos1 (- stringpos 1)
					  stringpos2 (- stringpos 1))
    (setq stringpos1  stringpos 
	 stringpos2  stringpos ))
  
	
  )
      )
  
    
(setq xdatafront (substr xdatai 1  stringpos1 ))
    (setq xdataback (substr xdatai (+ stringpos2 1)))
    (setq xdatai (strcat xdatafront " refplan=\"" csf "\" " xdataback))

    (SETQ SENTLIST (ENTGET EN))
  (SETQ XDATA (LIST (LIST -3 (LIST "LANDXML" (CONS 1000 xdatai)))))
   (setq NEWSENTLIST (APPEND SENTLIST XDATA))
  (ENTMOD NEWSENTLIST)
    
    (setq count (+ count 1))
    )
  );defun

