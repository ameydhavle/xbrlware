## Introduction ##

**xbrlware enables financial firms & analysts to create smarter automated financial analysis, analytics & business intelligence solutions from XBRL financial facts. See [case study](http://code.google.com/p/xbrlware/wiki/CaseStudy) page for practical examples using xbrlware.**

xbrlware is a fast, lightweight framework to parse, extract, search & analyze  financial and business facts from XBRL documents. xbrlware understands structure and relationship among elements of XBRL documents and defines a set of powerful object-oriented layer for accessing financial & business facts, meta & other related information defined in XBRL documents. **With xbrlware, users gain instant access to accurate financial and business facts from XBRL documents**. xbrlware lets developers deal with XBRL documents (Instance, taxonomy and Linkbase documents) following object-oriented idiom. xbrlware also has plugins to [generate financial reports](http://code.google.com/p/xbrlware/wiki/ReportGeneration), [export financial facts in RDF](http://code.google.com/p/xbrlware/wiki/RDFSupport) & fetch financial calculations from the xbrl documents.

xbrlware is written in Ruby. xbrlware can be easily integrated with other languages (C++, Java, C#, Python, Perl, Erlang and others). See [language integration](LanguageIntegration.md) page for example and more details.

xbrlware APIs are designed for productivity, speed and easy of use. With just few lines of code, get instant access to accurate financial facts.
```
require 'rubygems'
require 'xbrlware'

ins=Xbrlware.ins(<xbrl_instance_file_path>) # Initialize XBRL instance
items=ins.item("ProfitLoss") # Fetch all "ProfitLoss" financial fact
items.each do |item|
 puts item.value # Print value of each "ProfitLoss" item
end
```

xbrlware is developed and distributed by [jc-analytics](http://www.jc-analytics.com),                                               a financial products company that develops innovative process automation & collaboration
tools for financial institutions by leveraging latest advancements in computation and communication technologies.

To shape the direction of xbrlware, join us : [![](http://xbrlware.s3.amazonaws.com/static/icons/facebook-icon.gif)](http://www.facebook.com/pages/xbrlware/277013293101)  & [![](http://xbrlware.s3.amazonaws.com/static/icons/twitter-icon.gif)](http://twitter.com/xbrlware)

## Features ##
  * Supports
    * XBRL specification 2.1
    * US GAAP Taxonomy, Release 2009
    * Support for taxonomies other than US GAAP (Ex, FDIC call report taxonomy.)
    * Support for taxonomies of other countries (Canada, UK, Australia, Germany, etc)
    * XBRL Dimensions 1.0 (Explicit Dimensions)
  * Support for reports generation from presentation and calculation linkbases
    * business reports, see [screen shot](http://wiki.xbrlware.googlecode.com/hg/static/screen_shots/business_report.png)
    * developer reports, see [screen shot](http://wiki.xbrlware.googlecode.com/hg/static/screen_shots/developer_report.png)
  * [RDF/Semantic support](http://code.google.com/p/xbrlware/wiki/RDFSupport)
  * [Easy financial ratios calculation](http://code.google.com/p/xbrlware/wiki/CaseStudy#Financial_Ratios)
  * Support for **inline viewing** of footnotes such as operating leases, debt levels, options and tax rates etc, see [screen shot](http://wiki.xbrlware.googlecode.com/hg/static/screen_shots/inline_footnotes.png)
  * Programmatic access to business facts via **xbrlware APIs**
  * Business facts can be exported in **JSON, xml** formats, see [sample reports](http://wiki.xbrlware.googlecode.com/hg/static/sample_reports/master_report_index.html)
  * **No code/stub generation** from XBRL files is required. With just few lines of code, get instant access to accurate financial facts
  * Support for exporting presentations and calculations to **HTML/xls**, see [sample reports](http://wiki.xbrlware.googlecode.com/hg/static/sample_reports/master_report_index.html)
  * Thread-safe
  * [Documentation](GetStarted.md) and unit tests
  * Fast, see [benchmark](Benchmark.md)

## Editions ##
xbrlware is provided in two editions:
  * Enterprise Edition - License for commercial use, Free for opensource projects.
  * Community Edition - Free & Apache License 2.0

See [Editions & Pricing](XbrlwareEditionsAndPricing.md) page for more details

## Installation ##

### Prerequisite for installation ###

Make sure your environment has
  * Ruby 1.8.7 and Ruby gems

### Installing via gem command ###
xbrlware is available as a Gem and the easiest way to install it is to:

> sudo gem install xbrlware-ce --no-ri --no-rdoc

In the [documentation](GetStarted.md) page, you will learn about how to use xbrlware. It covers practical aspects of using xbrlware such as pulling XBRL filings, analyzing instance &  linkbase files, getting data out of instance file, report generation and much more.