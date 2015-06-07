This guide provides information on:




## Prerequisites to build xbrlware ##
  * [Ruby 1.8.7](http://www.ruby-lang.org/en/)
  * [Rake](http://rake.rubyforge.org/), which is a ruby build tool
  * [Mercurial](http://mercurial.selenic.com/), a distributed source control management tool

## Building xbrlware ##
```
hg clone https://xbrlware.googlecode.com/hg/ xbrlware

cd xbrlware

rake # Runs all tests

rake package # creates gem and tar files for distribution
```

## Common xbrlware rake tasks ##
```
rake # Runs  all tests

rake test # Runs  all tests, test is the default task

rake rdoc # Generates RDoc

rake package # Generates gem distribution and source .tgz file
```

## Advanced xbrlware rake tasks ##

When JRuby is the default runtime for your environment,
```
rake # Runs  all tests, also enables Schema validation of instance and taxonomy files
rake SCHEMA_VALIDATION=False # Runs  all tests without schema validation
```


To generate gem and .tgz with specific version number
```
rake package REL 1.0.2 # Generates gem and .tgz release with version number 1.0.2
```

## Contributing to xbrlware ##
  * Join our [developer discussion groups](http://groups.google.com/group/xbrlware)  to learn about xbrlware and contribute to its future
  * Make xbrlware better by finding bugs and filing bug reports (bugs submitted as unit-tests are much appreciated)
  * Submit patches for known bugs. Mercurial has [great support](http://hgbook.red-bean.com/read/managing-change-with-mercurial-queues.html) for patch management.