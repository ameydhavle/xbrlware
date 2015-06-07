This guide provides information on:



## Benchmark ##

xbrlware's speed directly influenced by following parameters
  * Size of instance and link base documents.
  * Complexity of relationship and association among various items of instance and linkbase documents.
  * Hardware configuration of the system that runs xbrlware

### Configuration ###

Configuration details of benchmark run

#### Hardware ####
```
RAM       : 1 GB 
Processor : Intel Centrino (single core)
```

#### Software ####
```
OS                      : Ubuntu 9.0.4 Server edition
Ruby                    : 1.8.7
No. of Parallel Threads : 1
No. of Ruby Processes   : 1
```


### Benchmark results ###

We ran our benchmark tests intentionally against low hardware/software configuration listed above to test xbrlwares performance.

#### Parser benchmark ####

| **Instance + Taxonomy file size (KB)** | **Time (Seconds)** |
|:---------------------------------------|:-------------------|
| 1694.4961                              | 1.5200             |
| 1118.5566                              | 1.6500             |
| 564.2227                               | 0.8100             |
| 1738.5664                              | 1.0300             |
| 965.7588                               | 0.9600             |

#### Report generation benchmark ####

| **Instance + Taxonomy + All Linkbases file size (KB)** | **No. of reports generated** | **Time (Seconds)** |
|:-------------------------------------------------------|:-----------------------------|:-------------------|
| 2056.2656                                              | 31                           |2.9800              |
| 1704.6846                                              | 33                           |5.2200              |
| 829.1006                                               | 23                           |1.8800              |
| 2150.8945                                              | 23                           |2.2900              |
| 1353.5186                                              | 27                           |2.8400              |