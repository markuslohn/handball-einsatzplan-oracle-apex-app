# Einsatzplan with Oracle Apex

The application installs a calendar and provides a REST API to automatically import the match schedule from the Bavarian Handball Association. The individual matches can be viewed in a calendar view. Furthermore, the necessary helpers can be entered for each match.

## REST API to import games

Database REST-Service: https://servername:port/ords/handball/einsatzplan/spielplan/${header.begegnungNr}?httpMethod=PUT

## Installation Steps

1. Install the necessary database objects using einsatzplan.sql script.
2. Download the einsatzplan.zip file in this directory
3. Navigate to App Builder -> Import
4. Drag and drop the application .zip file and click Next
5. Leave the defaults as they are, then continue through the remaining steps in the wizard to finish installing the application

