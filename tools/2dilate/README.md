### 2dilate

#### Description:
2dilate is a new (and slightly different) 2da merger.  It adds a new
file type: 2dx (specification below).  To simplify and easy the 2da
merging process.

#### Goals:
* A merger that did not require using directories to separate multiple
  merge files.
* A file format that is simple, compact, and familiar.  Something that
  could ideally be distributed with custom content to ease merging or
  shared by community members.  And also trivially implementable in
  any programming language/environment.
* A simple straight forward interface, that does not require a PhD to learn.

#### Dependencies:
* [Python 3](https://www.python.org/)
* [PyNWN](https://github.com/jd28/pynwn)

#### Windows Executable version:
* http://neverwintervault.org/project/nwn1/other/tool/2dilate

#### 2dx file format.
* Header: **2DX V2.0**
* Specifications: The following lines are optional, their ordering
  does not matter.  Their contents are limited to a single line.  If
  none are used there must be one blank line between the Header and
  the Column Labels.
  * **TLK: \<offset\> (\<Column Label\>, ...)** - Any number of Column
    Labels can be used, they must be lines referencing tlk entries.
  * **DESCRIPTION: \<Some text\>** - This will be used in future
    versions to prompt users as to whether or not they'd like to merge
    a particular 2dx file.
* Column Labels: As 2da, note however that a 2dx file needn't have all
  the columns of it's parent 2da.  Only the columns that are being
  merged need to be included.  Also, new columns can be added.
* Rows: As 2da with a couple exceptions:
  * Row numbers are significant, this is how 2dilate decides where to
    merge the 2dx file.
  * Row numbers are not expected to start from 0, they should be start
    wherever you want to merge.  They need not be contiguous or even
    ordered.
  * **####** is a new entry type that tells 2dilate to ignore the row
    entry as far as merging goes.  This is very handy when you want to
    merge changes from a few different columns but only change some
    values on certain rows.

#### Command Line Usage:
```
usage: 2dilate.exe [-h] [-v] [-o OUTPUT] [-x TWODX] [--non-default]
                   files [files ...]

positional arguments:
  files                 2da file(s).

optional arguments:
  -h, --help            show this help message and exit
  -v, --version         show program's version number and exit
  -o OUTPUT, --output OUTPUT
                        Output directory.
  -x TWODX, --twodx TWODX
                        2dx directory.
  --non-default         Ignore non-default 2da row entries.
```
