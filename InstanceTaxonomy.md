This guide provides information on:




## Introduction to XBRL items ##

An item represents a single fact or business measurement. A context holds additional relevant information about the item. The item definitions are defined in the taxonomy document. The item values are contained in the instance document. Item with same name may appear more than once in the instance document but each referencing a different context.

## Creating parser instance ##
```
require 'rubygems' # you need this when xbrlware is installed as gem
require 'xbrlware'

instance=Xbrlware.ins(<instance_file_path>)


# When no taxonomy path is given, taxonomy document mentioned in the instance file will be used.
# When taxonomy path is given explicitly, taxonomy document mentioned in the instance file will be ignored.
instance=Xbrlware.ins(<instance_file_path>, <taxonomy_file_path>)
```

## Working with items ##

### item by name ###
```
items=instance.item(<item_name>) # get item by name, ex: to fetch, <us-gaap:ProfitLoss> item, call instance.item("ProfitLoss")
puts items.size # prints number of occurrences of the item 
```

```
items=instance.item(<item_name>, <context_ref>) # get item by name and context reference
puts items.size # It print 0 if no match, 1 if there is a match. It can't be more than 1 as instance document can't have item with same name and context more than once
```

### all items ###
```
item_all=instance.item_all_map # Fetch all facts as map, key is fact name and value is array of facts
item_all.each do |name, items| # iterate
 puts " Items for #{name} ..." # Print item name
 items.each do |item|
   puts item.value # Print value of each item
 end
end
```
### context of items ###
```
items.each do |item|
  ctx=item.context # get context associated with item
  puts ctx.id # context id

  puts "Context period  is a duration" if ctx.period.is_duration? # ctx.period.value is a Hash  with keys "start_date", "end_date" and values are Date object representing a date.
  puts "Context period  is an instant" if ctx.period.is_instant? # ctx.period.value is a Date object representing a date
  puts "Context period  is forever" if ctx.period.is_forever? # ctx.period.value is -1


  dims = ctx.dimensions # get all dimensions as array
  #...code that use dims in some way

  doms = ctx.domains # get all domains as array
  #...code that use doms in some way

  doms = ctx.domains(["dimension_x", "dimension_y"]) # get domains for dimensions dimension_x, dimension_y 
  #...code that use doms in some way

  dim_dom=ctx.dimensions_domains # Gets dimensions and corresponding domains in a Hash
  dim_dom.each |dim, dom| do
    puts "  Dimension ["+dim+"] Domains ["+dom+"]" # dom is a array containing domains
  end

end
```

### unit of items ###
```
items.each do |item|
  unit=item.unit # get unit associated with item
  puts unit.id # unit id
  if unit.measure.is_a?(Xbrl::Unit::Divide) # check measure is "Divide"
    numerator=unit.measure.numerator # array containing numerator measure values
    denominator=unit.measure.denominator # array containing denominator measure values
    
    # do something with numerator / denominator
  else
    # array containing measure values
    unit.measure.each do |value| 
      # do some thing with value
    end
  end
```

### filter items with context filter block ###
```
items=instance.item_ctx_filter(<item_name>) {|ctx| ctx.has_dimensions?}
puts items.size # prints number of occurrences of the item who's context has dimension
```

### taxonomy definition of items ###
```
items=instance.item(<item_name>)
items.each do |item|
  _def=item.def # taxonomy definition of the item, in Hash
  puts _def["xbrli:balance"] if _def.has_key?("xbrli:balance") # print item balance "credit" / "debit" from taxonomy definition
end
```

### footnotes of items ###
```
items=instance.item(<item_name>)
items.each do |item|
  fnotes=item.footnotes # all footnotes as Hash (language as key, array of notes as value)
  fnotes.each do |lang, notes|
    puts notes.size.to_s + " notes exist in language " + lang + " for " + item.name
  end
end
```

## Working with contexts ##

### contexts for item ###
```
ctxs=instance.context_for_item(<item_name>) # array of all contexts for item
```

### all contexts ###
```
ctxs=instance.context # array of all contexts in the instance document
```

### context by id ###
```
ctx=instance.context(<ctx_id>) # Context instance if exist or Nil if doesn't exist
```

### contexts by dimension ###
```
ctxs=instance.context(nil, [<dimension_one>, <dimension_two>,...]) # get array of all contexts, by passing nil for context id and array of dimensions
```

### contexts group by dimensions ###
```
ctx_group=instance.ctx_groupby_dim # returns map, key is dimension and array of context as value for the key
```

### contexts group by domain ###
```
ctx_group=instance.ctx_groupby_domain # returns map, key is domain and array of context as value for the key
```

### contexts group by domain for dimensions ###
```
ctx_group=instance.ctx_groupby_dom([<dimension_one>,...]) # returns map, key is domain and array of context as value for the key
```


## Working with units ##

### all units ###
```
units=instance.unit # array of all units in the instance document
```

### unit by id ###
```
unit=instance.unit(<unit_id>) # Unit instance if exist or nil if doesn't exist
```