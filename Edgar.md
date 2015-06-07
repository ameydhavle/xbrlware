This guide provides information on:




## Download XBRL files and search for GAAP item ##

In this example we download XBRL files for a company who's central-index key is 843006 and filling number is 000135448809002030 from SEC's online edgar system and search for the GAAP item "OtherAssetsCurrent" in the XBRL instance file.

```
require 'rubygems' # you need this when xbrlware is installed as gem
require 'edgar'
require 'xbrlware'

dl=Edgar::HTMLFeedDownloader.new()

url="http://www.sec.gov/Archives/edgar/data/843006/000135448809002030/0001354488-09-002030-index.htm"
download_dir=url.split("/")[-2] # download dir is : 000135448809002030
dl.download(url, download_dir)

# Name of xbrl documents downloaded from EDGAR system is in the following convention
#    calculation linkbase document ends with _cal.xml
#    definition linkbase document ends with _def.xml
#    presentation linkbase ends with _pre.xml
#    label linkbase document ends with _lab.xml
#    taxonomy document ends with .xsd
#    instance document ends with .xml
# Xbrlware.file_grep understands above convention.  
instance_file=Xbrlware.file_grep(download_dir)["ins"] # use file_grep to filter xbrl files and get instance file

instance=Xbrlware.ins(instance_file)

items=instance.item("OtherAssetsCurrent")
puts "Other-Assets \t Context"
items.each do |item|
  puts item.value+" \t "+item.context.id
end
```

## Download XBRL files and generate reports ##

xbrlware has support for generating reports in HTML, xls, xml formats. See [report generation](ReportGeneration.md) page for more details.