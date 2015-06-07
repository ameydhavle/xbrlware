
## Introduction to linkbases ##

Linkbases provide additional information about items by expressing relationships between items (inter-concept relationships) or associating items with documentation about their meaning. xbrlware has complete support for dealing linkbases.

There are 3 linkbases to express inter-concept relationships among items
  1. Calculation
> It defines how children business facts computationally (credit or debit) contribute  to parent business fact. Ex. "NetIncomeBeforeTaxes" and "Taxes" business facts contribute to "NetIncomeAfterTaxes" business fact. "NetIncomeBeforeTaxes" contributes "credit" to NetIncomeAfterTaxes and "Taxes" contributes "debit" to "NetIncomeAfterTaxes", computationally.
  1. Definition
> It defines how one business fact relate to other business fact. Used extensively in XBRL dimensions and us-gaap to define primary-items, hyper-cubes, dimensions, domains.
  1. Presentation
> It arranges business facts into a hierarchy and specific ordering.

There are 2 linkbases to express relationships between itemss and their documentation
  1. Label
> It defines human-readable XBRL documentation for business facts

  1. Reference
> It contains references to authoritative statements in the published business, financial and accounting literature that give meaning to the concepts.

## Initializing linkbases ##
XBRL Taxonomy document contains linkbase definitions.
### Initializing all linkbases in one-go ###
```
instance = Xbrlware.ins(<instance_file>)
taxonomy=instance.taxonomy
taxonomy.init_all_lb #initialize all linkbases
lablb=taxonomy.lablb # Get label linkbase
deflb=taxonomy.deflb # Get definition linkbase
callb=taxonomy.callb # Get calculation linkbase
prelb=taxonomy.prelb # Get presentation linkbase
```
### Initializing individual linkbases ###
In some situations, initializing all linkbases may not be preferable. In those cases, individual linkbases could be initialized.
```
instance = Xbrlware.ins(<instance_file>)
taxonomy=instance.taxonomy
lablb=taxonomy.lablb # Initilaize and get label linkbase
...# same technique for other linkbases
```
### Suppying external linkbase file and forcing xbrlware to ignore linkbase definition from taxonomy document ###
```
instance = Xbrlware.ins(<instance_file>)
taxonomy=instance.taxonomy
lablb=taxonomy.lablb(<label_linkbase_path>) # Initilaize with path supplied and 
                                            # ignores label linkbase definition defined in the taxonomy document
...# same technique for other linkbases
```

## Calculation linkbase ##

### Getting all calculations ###
```
instance = Xbrlware.ins(<instance_file>)
taxonomy=instance.taxonomy
taxonomy.init_all_lb #initialize all linkbases
callb=taxonomy.callb # Get calculation linkbase
calculations=callb.calculation # returns array of calculation links. Empty array if no links
```

### Fetching specific calculation ###
```
instance = Xbrlware.ins(<instance_file>)
taxonomy=instance.taxonomy
taxonomy.init_all_lb #initialize all linkbases
callb=taxonomy.callb # Get calculation linkbase
calculation=callb.calculation(<calculation_link_role>) # returns a calculation link that matches given role. Nil if no match
```

### Inspecting calculations ###
```
instance = Xbrlware.ins(<instance_file>)
taxonomy=instance.taxonomy
taxonomy.init_all_lb #initialize all linkbases
callb=taxonomy.callb # Get calculation linkbase
calculations=callb.calculation
calculations.each do |cal|
 cal.print # Prints all elements with their children and their role in tree structure
 cal.print("v") # Prints detailed information about all elements and their children in tree structure
end
```


### Exporting calculation data ###
_**This feature is part of xbrlware Enterprise Edition**
```
instance = Xbrlware.ins(<instance_file>)
taxonomy=instance.taxonomy
taxonomy.init_all_lb #initialize all linkbases
callb=taxonomy.callb # Get calculation linkbase
calculations=callb.calculation
calculations.each do |cal|
 cal.to_json # Export calculation definition along with label and data in JSON
 cal.to_xml # Export calculation definition along with label and data in xml
 cal.to_hash # Export calculation definition along with label and data in hash
end
```_

## Presentation linkbase ##

### Getting all presentations ###
```
instance = Xbrlware.ins(<instance_file>)
taxonomy=instance.taxonomy
taxonomy.init_all_lb #initialize all linkbases
prelb=taxonomy.prelb # Get presentation linkbase
presentations=prelb.presentation # returns array of presentation links. Empty array if no links
```

### Fetching specific presentation ###
```
instance = Xbrlware.ins(<instance_file>)
taxonomy=instance.taxonomy
taxonomy.init_all_lb #initialize all linkbases
prelb=taxonomy.prelb # Get presentation linkbase
presentation=prelb.presentation(<presentation_link_role>) # returns a presentation link that matches given role. Nil if no match
```

### Inspecting presentations ###
```
instance = Xbrlware.ins(<instance_file>)
taxonomy=instance.taxonomy
taxonomy.init_all_lb #initialize all linkbases
prelb=taxonomy.prelb # Get presentation linkbase
presentations=prelb.presentation
presentations.each do |pre|
 pre.print # Prints all elements with their children and their role in tree structure
 pre.print("v") # Prints detailed information about all elements and their children in tree structure
end
```

### Exporting presentation data ###
