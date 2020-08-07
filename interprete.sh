#!/bin/bash

# First read OOPS results
sh -c " cat ./oops_result.xml | xq -c '.[\"rdf:RDF\"] | .[\"rdf:Description\"] |  map( select( [ .[\"oops:hasImportanceLevel\"] | .[\"#text\"] == \"Critical\" ] | any )? )' | jq -c '.[] | (.[\"oops:hasNumberAffectedElements\"] | .[\"#text\"]), (.[\"oops:hasDescription\"] | .[\"#text\"])'" | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/\<br\>/g' > critical.txt
sh -c " cat ./oops_result.xml | xq -c '.[\"rdf:RDF\"] | .[\"rdf:Description\"] |  map( select( [ .[\"oops:hasImportanceLevel\"] | .[\"#text\"] == \"Important\" ] | any )? )' | jq -c '.[] | (.[\"oops:hasNumberAffectedElements\"] | .[\"#text\"]), (.[\"oops:hasDescription\"] | .[\"#text\"])'" | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/\<br\>/g' > important.txt
sh -c " cat ./oops_result.xml | xq -c '.[\"rdf:RDF\"] | .[\"rdf:Description\"] |  map( select( [ .[\"oops:hasImportanceLevel\"] | .[\"#text\"] == \"Minor\" ] | any )? )' | jq -c '.[] | (.[\"oops:hasNumberAffectedElements\"] | .[\"#text\"]), (.[\"oops:hasDescription\"] | .[\"#text\"])'" | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/\<br\>/g' > minor.txt

# Put everything into one file
echo "OOPS Summary: (always the occurrences amount and then the description) <br> Critical: <br> " `cat critical.txt` " <br>  <br> Important: <br> " `cat important.txt` " <br>  <br> Minor: <br> " `cat minor.txt` " <br>  <br> " > reports.txt
echo "RDFUnit Summary: (always the occurrences amount and then the description)<br> " `cat RDFUnit_errors_.txt` | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/\<br\>/g' >> reports.txt
