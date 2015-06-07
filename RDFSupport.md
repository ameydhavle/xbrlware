**_Note: This feature is part of xbrlware Enterprise Edition._**

This guide provides information on:



## Introduction ##

xbrlware supports exporting XBRL financial facts as RDF statements. xbrlware defines a set of well meaningful, semantic financial vocabularies which are used in creating RDF statements in the form of subject-predicate-object expressions. xbrlware includes built-in support for [N-Triples](http://en.wikipedia.org/wiki/N-Triples) RDF serialization. This page also details about converting RDF data between most of the various popular RDF serialization formats. Here we discuss about RDF support in xbrlware for US SEC XBRL filings.

## Features ##
  * Contains meaningful semantic vocabularies.
  * Understands data-types and exported RDF statements includes data-type attribute.
  * All data exported are completely pre-processed as per XBRL 2.1 specification, thus ready for consumption/analysis.
  * RDF xbrlware plug-in is a library & exposes functionalities as API (This allows developer to create their own solutions.)
  * Has inbuilt support for N-Triples serialization & well documented approach for converting to other serialization formats.

## xbrlware Semantic Vocabularies ##
xbrlware defines set of vocabularies to link information related to financial facts. In XBRL document, an item represents a single financial fact. A context holds additional relevant information about the item. Item with same name may appear more than once in the document but each referencing a different context.

xbrlware defines following vocabularies based on **period of an item context** ,
### vocabularies for duration period ###
| **Predicate** | **Description** |
|:--------------|:----------------|
| MRFY\_TO\_DATE | Most recent financial year-to-date |
| CY\_TO\_DATE\_PFY | Corresponding year to-date preceding fiscal year |
| CY\_TO\_DATE\_PFY2 | Corresponding year to-date preceding fiscal year 2 |
| CY\_TO\_DATE\_PFY3 | Corresponding year to-date preceding fiscal year 3 |
| MRQ\_TO\_DATE | Most recent quarter end-to-date |
| CQ\_TO\_DATE\_PY | Corresponding quarter end-to-date preceding year |
| CQ\_TO\_DATE\_PY2 | Corresponding quarter end-to-date preceding year 2 |
| CQ\_TO\_DATE\_PY3 | Corresponding quarter end-to-date preceding year 3 |
| UNKNOWN       | Semantic not known |


---


### vocabularies for instant period ###
| **Predicate** | **Description** |
|:--------------|:----------------|
| FSD           | Filing start date |
| CFSD\_PY      | Corresponding filing start date preceding year |
| CFSD\_PY2     | Corresponding filing start date preceding year 2 |
| CFSD\_PY3     | Corresponding filing start date preceding year 3 |
| FED           | Filing end date |
| CFED\_PY      | Corresponding filing end date preceding year |
| CFED\_PY2     | Corresponding filing end date preceding year 2 |
| CFED\_PY3     | Corresponding filing end date preceding year 3 |
| QSD           | Quarter start date |
| CQSD\_PY      | Corresponding quarter start date preceding year |
| CQSD\_PY2     | Corresponding quarter start date preceding year 2 |
| CQSD\_PY3     | Corresponding quarter start date preceding year 3 |
| UNKNOWN       | Semantic not known |

xbrlware also defines following vocabularies to link related information,
### item value & related vocabularies ###
| **Predicate** | **Description** |
|:--------------|:----------------|
| VALUE         | Item value      |
| HAS\_FOOTNOTES | Does an item has foot notes? |
| FOOTNOTES     | Associated footnotes |
| NOTES\_LANGUAGE | Footnotes language |
| NOTES\_TEXT   | Footnotes text  |
| HAS\_DIMENSIONS | Does an item has dimensions? |
| DIMENSION     | Item Dimension  |
| DOMAIN        | Item domain     |
| DIM\_DOM      | Dimension & domain grouping |
| SDATE         | Start date of an item context, if it is instant it will be equal to EDATE|
| EDATE         | End date of an item context, if it is instant it will be equal to SDATE|
| UNIT          | Unit of an item |
| MEASURE       | represent unit element when unit is simple, ie unit is not divide |
| UNIT\_NUMERATOR | Represent unit numerator when unit is divide |
| UNIT\_DENOMINATOR | Represent unit denominator when unit is divide |
| IS\_UNIT\_DIVIDE | Is unit is divide or simple |

_Note : **All predicates appear beneath http://rdf.xbrlware.com/sec#**_

## Exporting RDF statement of a XBRL financial fact in N-Triple format ##
```
require 'xbrlware'
require 'xbrlware/rdf/sec'

ins=Xbrlware.ins(<path_to_instance_file>)

items=ins.item(<item_name>)

# Sample, fetch all AccountsPayableCurrent from XBRL 
# items=ins.item("AccountsPayableCurrent") filing

items.each do |item|
 rdf_stmts = i.ntriples
 # do something with rdf_stmts
end
```

## Exporting RDF statement of all XBRL financial facts in N-Triple format ##
```
require 'xbrlware'
require 'xbrlware/rdf/sec'

ins=Xbrlware.ins(<path_to_instance_file>)
rdf_stmts = ins.ntriples
```

## Serializing RDF statements into a file ##
```
require 'xbrlware'
require 'xbrlware/rdf/sec'
ins=Xbrlware.ins(<path_to_instance_file>)
rdf_stmts = ins.ntriples

RDF::Writer.for(:ntriples).open("output.nt") do |writer|
  rdf_stmts.each do |stmt|
    writer << stmt
  end
end
```

## Converting between various RDF serialization formats ##
In this ection, we discuss about using open-source [Raptor RDF Parser Library](http://librdf.org/raptor/) to convert RDF from one serialization format to another.

  * Install raptor library
```
   sudo apt-get install raptor-utils  # ubuntu
```

  * We will use "rapper" command-line util that comes with "raptor" toolkit to convert from one RDF serialization format to another.

  * Example to convert from ntriples to rdfxml
```
  rapper -i ntriples -o rdfxml output.nt > output.rdf
```
  * To see the full list of supported RDF serialization formats run
```
   rapper --help
```

## Simple linked financial item - in picture ##
![http://wiki.xbrlware.googlecode.com/hg/static/rdf/sample_linked_financial_data.png](http://wiki.xbrlware.googlecode.com/hg/static/rdf/sample_linked_financial_data.png)

## Exporting RDF data to storage systems ##
xbrlware RDF support is built with [RDF.rb](http://rdf.rubyforge.org/). Any plugin for RDF.rb will just work fine with xbrlware.
  * Exporting to Sesame RDF store => See, [Sesame plugin](http://rdf.rubyforge.org/sesame/)
  * Exporting to RDBMS => See, [Data objects plugin](http://rdf.rubyforge.org/do/)