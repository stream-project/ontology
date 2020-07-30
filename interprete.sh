#!/bin/bash

# First read OOPS results
cat ./oops_result.xml
sh -c " cat ./oops_result.xml | xq -c '.[\"rdf:RDF\"] | .[\"rdf:Description\"] |  map( select( [ .[\"oops:hasImportanceLevel\"] | .[\"#text\"] == \"Critical\" ] | any )? )' | jq -c '.[] | (.[\"oops:hasNumberAffectedElements\"] | .[\"#text\"]), (.[\"oops:hasDescription\"] | .[\"#text\"])'" > critical.txt
sh -c " cat ./oops_result.xml | xq -c '.[\"rdf:RDF\"] | .[\"rdf:Description\"] |  map( select( [ .[\"oops:hasImportanceLevel\"] | .[\"#text\"] == \"Important\" ] | any )? )' | jq -c '.[] | (.[\"oops:hasNumberAffectedElements\"] | .[\"#text\"]), (.[\"oops:hasDescription\"] | .[\"#text\"])'" > important.txt
sh -c " cat ./oops_result.xml | xq -c '.[\"rdf:RDF\"] | .[\"rdf:Description\"] |  map( select( [ .[\"oops:hasImportanceLevel\"] | .[\"#text\"] == \"Minor\" ] | any )? )' | jq -c '.[] | (.[\"oops:hasNumberAffectedElements\"] | .[\"#text\"]), (.[\"oops:hasDescription\"] | .[\"#text\"])'" > minor.txt

# Now read RDFUnit report
lines=$(awk 'END{print NR}' RDFUnit_errors.txt)

    if [ $lines -gt 12 ]; then
	cat RDFUnit_errors.txt
	exit 1
    fi
