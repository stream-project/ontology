## MSLE Competency Questions
1. List of Single Beam Electron Microscopes.
2. What is the maximum high tension of the electron beam for Zeiss Auriga 60 ?
3. What is a Dual Beam Microscope?
4. What types of detectors are available?
5. What is the range of SEM and FIB magnification for Zeiss Auriga 60?
6. What types of the dual-beam microscope are available?
7. In which dual beam system is the maximum high tension of the ion beam 30 kV?
8. Which instrument is equipped with a STEM detector?
9. List of Detectors(Samplers in SSN ontology).
10. Which Equipment(Observer in MatVoc ontology) has gas injection system?
11. What are the types of FEI ‎Strata 400S gas injection ‎system (GIS)?‎



## Answer to CQs via SPARQL

CQ1. List of Single Beam Electron Microscopes.
```
PREFIX MSLE: <http://www.semanticweb.org/hr7456/ontologies/2021/8/MSLEWL#>
PREFIX MSLEE: <http://www.semanticweb.org/hr7456/ontologies/2021/8/MSLE#>
SELECT ?SingleBeam
WHERE {?SingleBeam rdfs:subClassOf MSLE:Single_Beam }
```
CQ2. What is the maximum high tension of the electron beam for Zeiss Auriga 60 ?
```
PREFIX MSLE: <http://www.semanticweb.org/hr7456/ontologies/2021/8/MSLEWL#>
PREFIX MSLEE: <http://www.semanticweb.org/hr7456/ontologies/2021/8/MSLE#>
SELECT ?High_Tension
	WHERE { MSLE:Zeiss_Auriga_60   MSLE:hasHighTension  ?High_Tension}
```
CQ3. What is a Dual Beam Microscope?
```
SELECT ?X
	WHERE { MSLE:Dual_Beam ‎owl:equivalentClass ?X}‎

```
CQ4. What types of detectors are available?
```
SELECT ?Detectors
	WHERE { ?Detectors rdfs:subClassOf  MSLE:Detectors}

```

CQ5. What is the range of SEM and FIB magnification for Zeiss Auriga 60?
```
SELECT ?SEM_Magnification  ? FIB_Magnification
	WHERE { MSLEE:Zeiss_Auriga_60   MSLE:hasSEMmagnification  ?SEM_Magnification ;
                MSLE:hasFIBmagnification  ?FIB_Magnification }

```
CQ6. What types of the dual-beam microscope are available?
```
PREFIX MSLE: <http://www.semanticweb.org/hr7456/ontologies/2021/8/MSLEWL#>
PREFIX MSLEE: <http://www.semanticweb.org/hr7456/ontologies/2021/8/MSLE#>
PREFIX SSN: <http://www.w3.org/ns/sosa/>
SELECT ?X
WHERE {?X a MSLEE:Dual_Beam.
   }
```
CQ7. In which dual beam system is the maximum high tension of the ion beam 30 kV?
```
SELECT ?x
	WHERE { ?x rdf:type MSLE:Dual_Beam  ; ‎
‎                                            MSLE:hasHighTension ‎‎35 }‎

```
CQ8. Which instrument is equipped with a STEM detector??
```
Select ?device
WHERE { ?Device  rdf:type ?x .‎
‎                   ?x rdf:type  owl:Restriction .‎
‎                   ?x  owl:onProperty MSLE:hasDetector .                    ‎
‎                   ?x  owl:someValuesFrom ‎MSLE:STEM_Detector  }‎

```


CQ9. List of Detectors(Samplers in SSN ontology)
```
PREFIX MSLE: <http://www.semanticweb.org/hr7456/ontologies/2021/8/MSLEWL#>
PREFIX MSLEE: <http://www.semanticweb.org/hr7456/ontologies/2021/8/MSLE#>
PREFIX SSN: <http://www.w3.org/ns/sosa/>
SELECT ?Detectors
WHERE {?Detectors rdfs:subClassOf SSN:Sampler }

```
CQ10. Which Equipment(Observer in MatVoc ontology) has gas injection system?
```
PREFIX MSLE: <http://www.semanticweb.org/hr7456/ontologies/2021/8/MSLEWL#>
PREFIX MSLEE: <http://www.semanticweb.org/hr7456/ontologies/2021/8/MSLE#>
PREFIX SSN: <http://www.w3.org/ns/sosa/>
SELECT ?Equipment
WHERE {?Equipment MSLEE:hasInjection ?X.
?X rdf:type MSLEE:Gas_Injection_System .
    }
```
CQ11. What are the types of FEI ‎Strata 400S gas injection ‎system (GIS)?‎
```
PREFIX MSLE: <http://www.semanticweb.org/hr7456/ontologies/2021/8/MSLEWL#>
PREFIX MSLEE: <http://www.semanticweb.org/hr7456/ontologies/2021/8/MSLE#>
PREFIX SSN: <http://www.w3.org/ns/sosa/>
SELECT ?X
WHERE {MSLEE:FEI_Strata_400s MSLEE:hasInjection ?X.
   }

```
