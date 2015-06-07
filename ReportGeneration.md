**_Note: This feature is part of xbrlware Enterprise Edition_**

This guide provides information on:




## Reports ##

xbrlware has support for creating nice xls and HTML reports for presentations/calculations from linkbase documents.

  * [Sample reports](http://wiki.xbrlware.googlecode.com/hg/sample_reports/edgar_report_index.html)

### Reports for single entity ###

In this example we download XBRL files for a company who's central-index key is 843006 and filling number is 000135448809002030 from SEC's online edgar system and generate reports.

```
require 'rubygems' # you need this when xbrlware is installed as gem
require 'edgar'
require 'xbrlware/reports/sec'

dl=Edgar::HTMLFeedDownloader.new()   # Init HTMLFeedDownloader

url="http://www.sec.gov/Archives/edgar/data/843006/000135448809002030/0001354488-09-002030-index.htm"
download_dir=url.split("/")[-2] # download dir is : 000135448809002030
dl.download(url, download_dir) # Download XBRL filling files from the url

report=Xbrlware::Report.new() # Create report instance
report.gen(download_dir) # Generates HTML presentation reports
                         # stores report index file (edgar_report_index.html) under download_dir

report.gen(download_dir, "pre", "html") # Generates HTML presentation reports and
                              # stores report index file (edgar_report_index.html) under download_dir

report.gen(download_dir, "pre", "html|xls") # Generates HTML and xls reports for presentation
                              # stores report index file (edgar_report_index.html) under download_dir

report.gen(download_dir, "cal", "html|xls") # Generates HTML and xls reports for calculation
                              # stores report index file (edgar_report_index.html) under download_dir


report.gen(download_dir, "pre|cal", "html|xls") # Generates HTML and Xls reports for calculation and presentation
                              # stores report index file (edgar_report_index.html) under download_dir
```

### Reports for multiple entities in one-go ###

In this example we download top 5 entries from SEC EDGAR [RSS feed](http://www.sec.gov/Archives/edgar/usgaap.rss.xml) and generate reports.


```
require 'rubygems' # you need this when xbrlware is installed as gem
require 'edgar'
require 'xbrlware/reports/sec'

dl=Edgar::RSSFeedDownloader.new() # Init - uses default SEC EDGAR RSS Filing URL
download_dir="edgar_data"
dl.download(5, download_dir) # download XBRL fillings for top 5 entries to edgar_data folder of current dir. 
                             # Data for each entities will be stored under different sub-folders.

report=Xbrlware::Report.new() # Create report instance
report.gen(download_dir, "pre|cal", "html|xls|xml") # xbrlware understands there are multiple entities under edgar_data 
                                                    # generates reports for all entities.
                                                    # stores report index file (edgar_report_index.html) under edgar_data folder
```

### Reports for single entity, specifying instance, taxonomy and linkbase file paths explicitly ###
**_Note: This feature is part of xbrlware Enterprise Edition_**

There may be a situation
  * instnace, taxonomy and linkbase files are scattered around many places
> > or
  * file names are not in the following convention.
    * calculation linkbase document must end with _cal.xml
    * definition linkbase document must end with_def.xml
    * presentation linkbase document must end with _pre.xml
    * label linkbase document must end with_lab.xml
    * taxonomy file must end with .xsd
    * instance document must end with .xml


In these situations, gen\_for method of Report can be used to generate reportsrequire 'rubygems' # you need this when xbrlware is installed as gem
require 'xbrlware/reports/sec'

files={}
files["ins"] = "<instnace_file_path>"
files["tax"] = "<taxonomy_file_path>"
files["cal"] = "<calculation_linkbase_file_path>"
files["pre"] = "<presentation_linkbase_file_path>"
files["lab"] = "<label_linkbase_file_path>"
files["def"] = "<definition_linkbase_file_path>"

report=Xbrlware::Report.new() # Create report instance
report.gen_for(files, "pre|cal", "html|xls|xml|") # Generates HTML and xls reports for calculation and presentation
                              # stores report index file (edgar_report_index.html) under parent of instance_file.```