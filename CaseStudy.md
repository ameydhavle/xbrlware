This guide provides information on:



## Extracting fair value disclosure of a company ##

### Description ###
A financial analyst wants to extract fixed maturity securities with carrying value and estimated fair value from a company filing for his analysis.This example shows, how to do that with xbrlware.

Steps involved in this example,
  1. Download annual XBRL filling of a company.
  1. Fetch all "Fixed maturity securities" from the XBRL filing.
  1. Filter for "carrying value" & "estimated fair value"


### Solution ###

In XBRL filings "Fixed maturity securities" is represented as "AvailableForSaleSecuritiesDebtSecurities"

```
require 'rubygems' # you need this when xbrlware is installed as gem
require 'edgar'
require 'xbrlware'

dl=Edgar::HTMLFeedDownloader.new()

# Metlige Q2 10-Q filings
url="http://www.sec.gov/Archives/edgar/data/1099219/000095012310070688/0000950123-10-070688-index.htm"
download_dir=url.split("/")[-2] # download dir is : 000095012310070688
dl.download(url, download_dir)

instance_file=Xbrlware.file_grep(download_dir)["ins"] # use file_grep to filter xbrl files and get instance file

instance=Xbrlware.ins(instance_file)

# Fetch all "Fixed maturity securities"
items=instance.item("AvailableForSaleSecuritiesDebtSecurities")

# Filter for "carrying value"
carrying_items = items.select { |item| item.context.domains==["us-gaap:CarryingReportedAmountFairValueDisclosureMember"] }

# Filing contains data for filing quarter period and corresponding quarter period previous year
# To fetch value of filing quarter, sort in ascending order (of filtered carrying items from above step) & take the the farthest element
carrying_items.sort! {|item_a, item_b| item_a.context.period.value <=> item_b.context.period.value}

# Print value for the filing quarter that is represented by farthest element in the array, index -1
puts "Fixed maturity securities, carrying value is #{carrying_items[-1].value} for period #{carrying_items[-1].context.period.value}" if carrying_items.size > 0

# Filter for "estabilished fair value"
est_items = items.select { |item| item.context.domains==["us-gaap:EstimateOfFairValueFairValueDisclosureMember"] }

# Filing contains data for filing quarter period and corresponding quarter period previous year
# To fetch value of filing quarter,  sort in ascending order (of filtered est items from above step) & take the the farthest element
est_items.sort! {|item_a, item_b| item_a.context.period.value <=> item_b.context.period.value}

# Print value for the filing quarter that is represented by farthest element in the array, index -1
puts "Fixed maturity securities, estimated fair value is #{est_items[-1].value} for period #{est_items[-1].context.period.value}" if est_items.size > 0

```

## Calculating Financial Ratios ##

### Description ###
This example shows computing [current ratio ](http://en.wikipedia.org/wiki/Current_ratio)(current ratio is an indication of a company's ability to meet short-term debt obligations; A high ratio indicates a good probability the company can meet current debts.) from annual filling of a company for current filing period and previous filing period.

Steps for calculating current ratio

  1. Download annual XBRL filling of a company.
  1. Fetch current assets (GAAP term is "AssetsCurrent") from the XBRL instance document.
  1. Fetch current liabilities (GAAP term is "LiabilitiesCurrent") from the XBRL instance document.
  1. Compute current ratio.

```
current ratio = current assets / current liabilities
```

**_Note_:** You need [xbrlware enterprise edition](http://code.google.com/p/xbrlware/wiki/XbrlwareEditionsAndPricing#Pricing_for_Enterprise_Edition) for this example

### Solution ###
```
require 'rubygems' # you need this when xbrlware is installed as gem
require 'edgar'
require 'xbrlware'
require 'xbrlware/rdf/sec'

dl=Edgar::HTMLFeedDownloader.new()

url="http://www.sec.gov/Archives/edgar/data/1136869/000095012310017177/0000950123-10-017177-index.htm"
download_dir=url.split("/")[-2] # download dir is : 000095012310017177
dl.download(url, download_dir)

instance_file=Xbrlware.file_grep(download_dir)["ins"]
ins=Xbrlware.ins(instance_file)

# Fetch current assets for current filing period
curr_assets = ins.item_by_vocab("AssetsCurrent", Xbrlware::RDF::SEC.FED)[0].value.to_f

# Fetch current liabilities for current filing period
curr_liabs = ins.item_by_vocab("LiabilitiesCurrent", Xbrlware::RDF::SEC.FED)[0].value.to_f

# Compute current ratio
current_ratio= curr_assets / curr_liabs # compute current ratio

puts " Current ratio is #{current_ratio}"


# Fetch current assets for previous filing period
curr_assets = ins.item_by_vocab("AssetsCurrent", Xbrlware::RDF::SEC.CFED_PY)[0].value.to_f

# Fetch current liabilities for previous filing period 
curr_liabs = ins.item_by_vocab("LiabilitiesCurrent", Xbrlware::RDF::SEC.CFED_PY)[0].value.to_f

# Compute current ratio
current_ratio= curr_assets / curr_liabs # compute current ratio

puts " Current ratio for previous year is #{current_ratio}"

```

## Exporting financial facts ##
### Description ###
Many times we have to export financial facts from XBRL filings to other software systems (like RDBMS, NOSQL DB, full text search engine, semantic database, datawarehouse, business intelligence software or your own proprietary systems) for reuse, analytical and analysis purpose. Here we discuss about exporting financial facts to RDBMS, by glancing through the code discussed here, you will get an idea on how to do it for other systems.

### Solution ###
To keep things simple, we

a) Ignore non numeric financial facts & facts with domain and dimensions in their contet.
b) Assume all financial facts are of same unit.

Steps for exporting financial facts,

  1. Design & create a database table to store financial facts.
  1. Download a XBRL filling.
  1. Get all financial facts from the filing.
  1. Export financial facts to the table.

We use xbrlware enterprise edition(http://www.bitstat.com/xbrlware) to implement above mentioned steps.

_**Table design:**_

Each XBRL filing contains entries for many financial facts (Assets, NetIncome, Liabilities etc) under different contexts (Current quarter, Previous quarter etc). Number of financial facts represented in XBRL filing will differ from company to company, because
  1. Not all the financial facts are of same importance for all industries.(Ex: Inventory is very important fact for oil & automibile industries and of less important for software service industries).
  1. Some companies provide verbose financial facts where as some provide concise financial facts in their XBRL filing.

To store financial facts from XBRL filings, we will design a database table as shown below,

```
# See below ruby code for full table design
CREATE TABLE XW_FACTS (
NAME VARCHAR, # Name for the fact
VALUE NUMBER, # Value of the fact.
VOCAB VARCHAR, # xbrlware defined vocabulary based on context of the fact.
.....
.....
# See attached file for full table design
);
```

**_Exporting financial facts:_**

```
require 'rubygems'
require 'sequel'

#DB = Sequel.connect "mysql://user_name:password@machine/database"
DB = Sequel.connect "mysql://xbrlware:xbrlware@localhost/xbrlware"

# create financial facts table, if not exist
DB.create_table? :XW_FACTS do
  String :name # Fact name
  Float :value # Fact value
  String :vocab # Context vocab as defined by xbrlware (See http://code.google.com/p/xbrlware/wiki/RDFSupport)
  Date  :start_dt # Context start date
  Date  :end_dt # Context end date
  String :entity # Entity name
  String :ci_key # Central index key of the entity
  String :doc_type # Document type, 10-Q, 10-K etc
end

require 'edgar'
require 'xbrlware'
require 'xbrlware/rdf/sec'

dl=Edgar::HTMLFeedDownloader.new()

# Download a XBRL filing
url="http://www.sec.gov/Archives/edgar/data/1136869/000095012310017177/0000950123-10-017177-index.htm"
download_dir=url.split("/")[-2] # download dir is : 000095012310017177
dl.download(url, download_dir)

instance_file=Xbrlware.file_grep(download_dir)["ins"]
ins=Xbrlware.ins(instance_file)

# All financial facts as array
facts=ins.item_all

# Remove financial facts that are not numeric or has dimensions
facts.reject! {|fact| fact.value.nil? || fact.value.is_nan? || fact.context.has_dimensions?}

# Entity name, central index key of the entity & document type 
entity, ci_key, doc_type = ins.entity_details["name"], ins.entity_details["ci_key"], ins.entity_details["doc_type"]

facts.each do |fact|
  period = fact.context.period

  # If context period is instant, set start_dt to nil & populate end_dt
  start_dt, end_dt = nil, period.value if period.is_instant?

  # If context period is duration, populate start_dt and end_dt  
  start_dt, end_dt = period.value["start_date"], period.value["end_date"] if period.is_duration?

  # Insert into table "XW_FACTS"
  DB[:XW_FACTS] << {
          :name => fact.name, :value => fact.value, :vocab => fact.vocab.to_s, :start_dt => start_dt, :end_dt => end_dt,
          :entity => entity, :ci_key => ci_key, :doc_type =>  doc_type
  }
end

puts "Done.."
```

## Retrieving financial facts from presentation linkbases ##
### Description ###
we discuss about extrating financial facts associated with presentation linkbases.  Steps involved in this example,

  1. Download annual XBRL filling of a company.
  1. Fetch all presentations from linkbases.
  1. Iterate through each presentations from step 2 and retrieve presentation line items.
  1. Print financial facts associated with presentation each presentation line item from step 3.

we use xbrlware enterprise edition (http://www.bitstat.com/xbrlware) to implement above mentioned steps,

### Solution ###
```
require 'rubygems' # you need this when xbrlware is installed as gem
require 'edgar'
require 'xbrlware'

def is_nan?(value)
  not (value.to_i.to_s == value || value.to_f.to_s == value)
end

def walk_tree(elements, indent_count=0)
  elements.each_with_index do |element, index|
    indent=" " * indent_count

    # Filter only numeric values
    matched_items=element.items.select {|item| (not item.value.nil?) && (not is_nan?(item.value))}

    matched_items.each do |item|

      # Dimension and Domain values
      dim_doms=StringIO.new
      item.context.dimensions_domains.each do |dimension, domain|
        dim_doms << "#{dimension} => #{domain} | "
      end
      dim_doms_str = dim_doms.string

      period=item.context.period
      period_str = period.is_duration? ? "#{period.value["start_date"]} to #{period.value["end_date"]}" : "#{period.value}"
      puts "#{indent} #{element.label} (#{period_str} #{dim_doms_str if dim_doms_str.length > 0}) = #{item.value}" unless item.nil?
    end

    # If it has more elements, walk tree, recursively.
    walk_tree(element.children, index+1) if element.has_children?
  end
end

# Download annual XBRL filing of a company
dl=Edgar::HTMLFeedDownloader.new()

url="http://www.sec.gov/Archives/edgar/data/1136869/000095012310017177/0000950123-10-017177-index.htm"
download_dir=url.split("/")[-2] # download dir is : 000095012310017177
dl.download(url, download_dir)

instance_file=Xbrlware.file_grep(download_dir)["ins"]

# Initialize xbrlware
ins=Xbrlware.ins(instance_file)

# Fetch all presentations
presentations=ins.taxonomy.prelb.presentation

# Walk presentation tree and print all values.
presentations.each do |pre|
  # print presentation title
  puts "#{pre.title}"

  # Walk presentation line items (arcs) recursively
  walk_tree(pre.arcs)
  puts "\n"
end
```

## Analyzing financial facts of FDIC insured institutions ##
### Description ###
FFIEC (http://www.ffiec.gov/) publishes financial information of FDIC-insured institutions. These information is available as "Reports of Condition" and "Income (Call Report)" in the form of XBRL. FFIEC also publishes Uniform Bank Performance Reports(UBPR) that are based on call report data in the form of XBRL. Access to these XBRL files is free with FFIEC webservice account. In this blog, we discuss about retrieving XBRL Call Report of a company from FFIEC and analyzing it.

  1. Get FFIEC webservice account Go to https://cdr.ffiec.gov/public/Default.aspx and click on "Manage my web service account"
  1. Description about FFIEC data retrieval web service could be located at https://cdr.ffiec.gov/Public/PWS/Webservices/RetrievalService.asmx
  1. Use Xbrlware Enterprise Edition to download call report XBRL document from FFIEC webservice.
  1. Use Xbrlware Enterprise Edition to analyze downloaded XBRL document.
### Solution ###
```
require 'rubygems'
require 'xbrlware'
require 'xbrlware/ffiec'

client = Xbrlware::FFIEC::WSClient.new

# Print all soap actions in console
puts client.wsdl.soap_actions

# Retrieve Call report XBRL for FDIC Certificate Number 3510 (FDIC cert number 3510 represents - Bank of America, NA)
reponse = client.retrieve_facsimile do |soap, wsse|
  wsse.username = "ffiec_auth_username" # Replace with your's
  wsse.password = "ffiec_auth_password" # Replace with your's
  soap.body = {
          "wsdl:dataSeries" => 'Call', "wsdl:reportingPeriodEndDate" => "9/30/2009", 
          "wsdl:fiIDType" => 'FDICCertNumber', "wsdl:fiID" => 3510, "wsdl:facsimileFormat" => 'XBRL'
  }
end

# Retrieve encoded XBRL content from response and decode it.
xbrl_content=Base64.decode64(reponse.to_hash[:retrieve_facsimile_response][:retrieve_facsimile_result])

# Write decoded XBRL content to a file
File.open("xbrl.xml", 'w') {|f| f.write(xbrl_content) }

# Instruct xbrlware to use call report taxonomy
ENV["TAXO_NAME"]="FFIEC-CALLREPORT"
ENV["TAXO_VER"]="20100930"

# Create xbrlware instance of XBRL document
ins=Xbrlware::Instance.new "xbrl.xml"

# Retrieve and print total interest on loans
item=ins.item('RIAD4010')[0]
puts "Total interest and fee income on loans => #{item.value} | #{item.balance}" 

# Retrieve and print net interest income
item=ins.item('RIAD4074')[0]
puts "Net interest income => #{item.value} | #{item.balance}"

```
You would see following output in the console,

Total interest and fee income on loans => 23755060000.0 | credit

Net interest income => 24580146000.0 | credit

## Case study 1 ##

### Description ###
Mr.T is a quantitative trader dealing in the equity market. His portfolio contains stocks of company C.

T has many strategies on how to trade C's stocks. One of the strategies is to offload C's stocks from his portfolio when its net income decreases by more than 5% compared to last year.

T wants to apply the strategy at the earliest after the XBRL filing by C.

### Solution ###
Extract and compare the net income values from the annual XBRL filing of C.

C's XBRL instance document is c-20091230.xml and T's strategy file c\_sell\_strategy.rb

contents of c-20091230.xml
```
<?xml version="1.0" encoding="US-ASCII"?>
<xbrli:xbrl xmlns:xbrli="http://www.xbrl.org/2003/instance" xmlns:iso4217="http://www.xbrl.org/2003/iso4217"
            xmlns:link="http://www.xbrl.org/2003/linkbase" xmlns:us-gaap="http://xbrl.us/us-gaap/2009-01-31" 
            xmlns:xbrldi="http://xbrl.org/2006/xbrldi" xmlns:xlink="http://www.w3.org/1999/xlink">
    <link:schemaRef xlink:href="" xlink:type="simple"/>
    <xbrli:context id="Y2009">
        <xbrli:entity>
            <xbrli:identifier scheme="http://www.sec.gov/CIK">9999999999</xbrli:identifier>
        </xbrli:entity>
        <xbrli:period>
            <xbrli:startDate>2009-01-02</xbrli:startDate>
            <xbrli:endDate>2009-12-30</xbrli:endDate>
        </xbrli:period>
    </xbrli:context>
    <xbrli:context id="Y2008">
        <xbrli:entity>
            <xbrli:identifier scheme="http://www.sec.gov/CIK">9999999999</xbrli:identifier>
        </xbrli:entity>
        <xbrli:period>
            <xbrli:startDate>2008-01-02</xbrli:startDate>
            <xbrli:endDate>2008-12-30</xbrli:endDate>
        </xbrli:period>
    </xbrli:context>  
    <xbrli:unit id="USD">
        <xbrli:measure>iso4217:USD</xbrli:measure>
    </xbrli:unit>
    <us-gaap:NetIncomeLoss contextRef="Y2009" unitRef="USD" decimals="-6">730000000</us-gaap:NetIncomeLoss>
    <us-gaap:NetIncomeLoss contextRef="Y2008" unitRef="USD" decimals="-6">902000000</us-gaap:NetIncomeLoss>
</xbrli:xbrl>
```

contents of c\_sell\_strategy.rb
```
require 'rubygems' # you need this when xbrlware is installed as gem
require 'xbrlware'

instance_file="c-20091230.xml"
instance = Xbrlware.ins(instance_file) # Create parser instance

item_name="NetIncomeLoss" # This is the item we are interested in.
net_incomes = instance.item(item_name) # Extracts "NetIncomeLoss"

if net_incomes.size < 2
  puts item_name + " Not found.."
  return
end

curr_netincome, prev_netincome=0, 0

if net_incomes[0].context.period.value["end_date"] > net_incomes[1].context.period.value["end_date"]
  curr_netincome=net_incomes[0].value.to_f
  prev_netincome=net_incomes[1].value.to_f
else
  curr_netincome=net_incomes[1].value.to_f
  prev_netincome=net_incomes[0].value.to_f  
end

expected_netincome=prev_netincome-(prev_netincome * 0.05)

if curr_netincome < expected_netincome
  puts "Sell..." # Sell C's stocks
end
```

## Case study 2 ##

### Description ###
This case study is similar to Case study 1 except that instead of analyzing sample instance file, this case study downloads xbrl filling documents from SEC EDGAR system and extracts necessary item for comparison.

### Solution ###
```
require 'rubygems' # you need this when xbrlware is installed as gem
require 'edgar'
require 'xbrlware'

dl=Edgar::HTMLFeedDownloader.new()

url="http://www.sec.gov/Archives/edgar/data/843006/000135448809002030/0001354488-09-002030-index.htm"
download_dir=url.split("/")[-2] # download dir is : 000135448809002030
dl.download(url, download_dir)

instance_file=Xbrlware.file_grep(download_dir)["ins"]
instance=Xbrlware.ins(instance_file)

item_name="Assets"
assets = instance.item(item_name) # Extracts "Assets"

if assets.size < 2
  puts item_name + " Not found.."
  return
end

curr_asset, prev_asset=0, 0

if assets[0].context.period.value > assets[1].context.period.value
  curr_asset=assets[0].value.to_f
  prev_asset=assets[1].value.to_f
else
  curr_asset=assets[1].value.to_f
  prev_asset=assets[0].value.to_f
end

if curr_asset > prev_asset
  puts "Buy..."
end
```