You're now ready to write some code. An easy way to get started is this example, ruby file foo.rb searches for the GAAP item "ProfitLoss" in XBRL instance file foo.xml and then outputs the matched items value to the console.

contents of foo.rb,

```
require 'rubygems' # you need this when xbrlware is installed as gem
require 'xbrlware'

instance=Xbrlware.ins("foo.xml")
items=instance.item("ProfitLoss")

puts "Profit-Loss \t Context"
items.each do |item|
  puts item.value+" \t "+item.context.id
end
```

contents of foo.xml :

```
<?xml version="1.0" encoding="US-ASCII"?>
<xbrli:xbrl xmlns:xbrli="http://www.xbrl.org/2003/instance" xmlns:iso4217="http://www.xbrl.org/2003/iso4217" 
xmlns:link="http://www.xbrl.org/2003/linkbase" xmlns:us-gaap="http://xbrl.us/us-gaap/2009-01-31" 
xmlns:xbrldi="http://xbrl.org/2006/xbrldi" xmlns:xlink="http://www.w3.org/1999/xlink">
    <link:schemaRef xlink:href="" xlink:type="simple"/>
    <xbrli:context id="D2009Q2YTD">
        <xbrli:entity>
            <xbrli:identifier scheme="http://www.sec.gov/CIK">9999999999</xbrli:identifier>
        </xbrli:entity>
        <xbrli:period>
            <xbrli:startDate>2009-02-01</xbrli:startDate>
            <xbrli:endDate>2009-08-15</xbrli:endDate>
        </xbrli:period>
    </xbrli:context>
    <xbrli:context id="D2008Q2YTD">
        <xbrli:entity>
            <xbrli:identifier scheme="http://www.sec.gov/CIK">9999999999</xbrli:identifier>
        </xbrli:entity>
        <xbrli:period>
            <xbrli:startDate>2008-02-03</xbrli:startDate>
            <xbrli:endDate>2008-08-16</xbrli:endDate>
        </xbrli:period>
    </xbrli:context>  
    <xbrli:unit id="USD">
        <xbrli:measure>iso4217:USD</xbrli:measure>
    </xbrli:unit>
    <us-gaap:ProfitLoss contextRef="D2008Q2YTD" unitRef="USD" decimals="-6">730000000</us-gaap:ProfitLoss>
    <us-gaap:ProfitLoss contextRef="D2009Q2YTD" unitRef="USD" decimals="-6">902000000</us-gaap:ProfitLoss>
</xbrli:xbrl>
```

When you run foo.rb, it should generate output as shown below

```
Profit-Loss 	 Context
730000000.0 	 D2008Q2YTD
902000000.0 	 D2009Q2YTD
```

Congratulations, you've managed to get started with xbrlware!.