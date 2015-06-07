This guide provides information on:



## Configuring xbrlware to use different taxonomy ##
**_Note: This feature is part of xbrlware Enterprise Edition_**

By default, xbrlware is configured to use US GAAP Taxonomy, Release 2009. You can easily configure xbrlware to use other taxonomy. In this example, we will see how to use xbrlware with Canada GAAP taxonomy.
```
require 'rubygems'
require 'xbrlware'

# take backup of default taxonomy constants
us_tax_name=ENV["TAXO_NAME"]
us_tax_version=ENV["TAXO_VERSION"]

# Override constant values for canada-gaap taxonomy
ENV["TAXO_NAME"]="CA-GAAP"
ENV["TAXO_VERSION"]="20070119"

ins_ca=Xbrlware.ins(<instance_file_path>) # initialize instance
                                       # This instance will use canada-gaap taxonomy

# Override constant values for us-gaap taxonomy from backed-up values
ENV["TAXO_NAME"]=us_tax_name
ENV["TAXO_VERSION"]=us_tax_version

ins_us=Xbrlware.ins(<instance_file_path>) # initialize instance
                                       # This instance will use us-gaap taxonomy
```