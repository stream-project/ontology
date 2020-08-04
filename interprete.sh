#!/bin/bash

# First read OOPS results
sh -c " cat ./oops_result.xml | xq -c '.[\"rdf:RDF\"] | .[\"rdf:Description\"] |  map( select( [ .[\"oops:hasImportanceLevel\"] | .[\"#text\"] == \"Critical\" ] | any )? )' | jq -c '.[] | (.[\"oops:hasNumberAffectedElements\"] | .[\"#text\"]), (.[\"oops:hasDescription\"] | .[\"#text\"])'" > critical.txt
sh -c " cat ./oops_result.xml | xq -c '.[\"rdf:RDF\"] | .[\"rdf:Description\"] |  map( select( [ .[\"oops:hasImportanceLevel\"] | .[\"#text\"] == \"Important\" ] | any )? )' | jq -c '.[] | (.[\"oops:hasNumberAffectedElements\"] | .[\"#text\"]), (.[\"oops:hasDescription\"] | .[\"#text\"])'" > important.txt
sh -c " cat ./oops_result.xml | xq -c '.[\"rdf:RDF\"] | .[\"rdf:Description\"] |  map( select( [ .[\"oops:hasImportanceLevel\"] | .[\"#text\"] == \"Minor\" ] | any )? )' | jq -c '.[] | (.[\"oops:hasNumberAffectedElements\"] | .[\"#text\"]), (.[\"oops:hasDescription\"] | .[\"#text\"])'" > minor.txt

# Put everything into one file
echo "OOPS Summary: (always the occurrences amount and then the description) \n Critical: \n " `cat critical.txt` " \n  \n Important: \n " `cat important.txt` " \n  \n Minor: \n " `cat minor.txt` " \n  \n " > reports.txt
echo "RDFUnit Summary: \n " `cat RDFUnit_errors_.txt` >> RDFUnit_errors.txt
cp reports.txt all_reports.txt
ls -hal

# Now read RDFUnit report
lines=$(awk 'END{print NR}' RDFUnit_errors_.txt)

if [ $lines -gt 12 ]; then
	cat RDFUnit_errors_.txt
	exit 1
fi
