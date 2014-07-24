OpenSCAD_DocTest
================

OpenSCAD_DocTest version: 20140720_1<br/>
Copyright (C) 2014 Runsun Pan (run+sun (at) gmail.com)
```
1. Introduction
2. Files included
3. Quick Look
4. Console Output
5. Where to Start
6. Doctest Modes
7. Special Characters
8. Scope for Test
9. Commenting tests
10. Test as string
11. Utility functions
12. Future Plan
13. Release Note
```
####1. Introduction

**OpenSCAD_DocTest** is a library for *doc* and *unit testing* of functions in [**OpenSCAD**](http://www.openscad.org). 
Both doc and tests are written in arrays and processed by **doctest()** and output to the 
console. It has different modes like doc only, test only, show tests as examples (i.e., 
no testing), etc, and capable of commenting on test cases easily, making it a good tool 
for demostrating *function usages*. 

Whichever mode it operates on, the output (in the console) can be copied and pasted
to a doc editor (like LibreOffice Writer), and an api doc can be generated with very 
minor editting. The file openscad_doctest_api.html servers as a good demo for this feature.

The *unit test* feature helps to ensure quality, reduces maintainence burden, facilitate 
re-factoring, and, my favorite, allows for **test-first** or **test-driven programming** (see <a href="http://en.wikipedia.org/wiki/Test-driven_development">test-driven development</a>), i.e., 
write the expected outcome of a function first, then starts writing the code to see if it 
behaves as expected. 

####2. Files included

* openscad_doctest.scad        --- doctest() and utilities (see below)
* openscad_doctest_help.scad   --- help and doc and tests
* openscad_doctest_demo_1.scad --- demo of basics
* openscad_doctest_api.html    --- api doc
* README.md

####3. Quick Look

Example function: 
```
function addz(p,z)= [p.x, p.y, p.z+z];
```
a. Write doc:

```javascript
addz=[ "addz"   // function name
     , "p,z"    // arg names
     , "array"  // return type
     , "Array"  // category
     , "Add z to the z of p."  // doc content
]; 
```

b. Write test:  [ arg_string, result, expected] 
  
```
module addz_test( mode=13 )
{
   addz_tests=
   [
      ["[3,4,5],2", addz([3,4,5],2), [3,4,7] ]
   ]; 
   doctest( addz           // doc
          , addz_tests     // tests
          , ["mode",mode]  // options
          ); 
}    
```
   Or use local scope for variables:

```
module addz_test( mode=13 )
{
   pt=[3,4,5];   // define test variables
   addz_tests=
   [
      [ "pt,2", addz(pt,2), [3,4,7] ]        
   ]; 
   doctest( addz           // doc
          , addz_tests     // tests
          , ["mode",mode]  // options
          , ["pt",pt] );  // add scope
          ); 
}    
```

c. Include this:

```
include <openscad_doctest.scad> 
addz_test( 13 );
```

####4. Console Output

The output of **doctest()** depends on the value of option **mode**. For example,
`mode=13`, which is the full display of everything (See section **Doctest Modes** for details), gives this:

```
-------------------------------------------------------
addz ( p,z )=array ( tested:3/failed:1 )
| Given a point (p) and a number (z), add z to p.z if p is
| 3d, or append z to p if p is 2d.
|
| Tags: Array
|
|Tests:
|
|> pt3= [3, 4, 5]; 
|> addz( [3,4],2 )= [3, 4, 2]
|> addz( pt3,2 )= [3, 4, 7]
|> addz( pt3,2 )= [3, 4, 5] got: [3, 4, 7] #FAIL#
```

####5. Where to Start

 * Run *openscad_doctest_demo_1.scad* for a quick taste of basics.
 * Run **doctest_help(index)** in *openscad_doctest_help.scad* to display help
 * Run **doctest_tool_test(mode)** in *openscad_doctest_help.scad* for a
   complete demo of testing all the unility functions that **doctest** uses.

 Pick an `index` or `mode` according to the instructions displayed. 

####6. Doctest Modes

Two main features of **doctest()**, *doc* and *testing*,  can be used together or
separately by setting doctest's `mode` option to one of 8 possibilities. 
Lets start with the *test-only* modes:

| mode | doc? | test? | display_tests? |                                             |
|------|------|-------| ---------------|---------------------------------------------|
|   0  |   -  |   -   |       -        | doesn't do or display tests                 |
|   1  |   -  |   -   |      YES       | no test, but display test cases             | 
|   2  |   -  |  YES  |    ON_ERROR    | do tests, but display tests only on failed  |
|   3  |   -  |  YES  |     YES        | do and display all tests                    |

So, `doctest(... ops=["mode",0])` lists the function signatures, good for function directory.
`doctest(... ops=["mode",1])` displays tests without testing, good for usage demonstration.
`doctest(... ops=["mode",2])` is good for maintainance to see if anything breaks. 

To add doc, simply add 10 to each:

| mode | doc? | test? | display_tests? |                                             |
|------|------|-------| ---------------|---------------------------------------------|
|  10  | YES  |   -   |       -        | doesn't do or display tests                 |
|  11  | YES  |   -   |      YES       | no test, but display test cases             | 
|  12  | YES  |  YES  |    ON_ERROR    | do tests, but display tests only on failed  |
|  13  | YES  |  YES  |     YES        | do and display all tests                    |

`doctest(... ops=["mode",13])` fires and displays everything, good for development of new code.



####7. Special Characters

Special attention is needed when writing doc and tests. 

a. Use double apostrophes ('') in place of a quote symbol(")to represent a string:

```
[ "''abcdef'', ''def''", dt_begwith("abcdef", "def"), false ]
```

b. In the doc, use double semicolon (;;) as a linebreak:
   
```
dt_get=[ ... ,
" Given a str or arr (o), an index (i), get the i-th item.
;; i could be negative.
;;
;; *iscycle*: cycling from the other end if out of range. Useful
;; when looping through the boundary points of a shape.
"]; 
```

c. If a semicolon is to be placed in the end of line, like showing a code line,
   put an extra space after it to prevent it from mixing with the next linebreak.

####8. Scope for Test

Being able to set variable scope for testing makes coding the tests a lot easier 
also make the tests much easier to read, especially when the value length is long 
and repeated use of a variable is needed. 

```javascript
module addz_test( mode=13 ){

      pt=[3,4,5];   // define test variables

      addz_tests=
      [
        [ "pt,2", addz(pt,2), [3,4,7] ]  // pt is applied here       
        [ "pt,3", addz(pt,3), [3,4,8] ]  // Don't have to re-type long value 
        [ "pt,-1", addz(pt,-1), [3,4,4] ]  
      ]; 
      doctest( addz
             , addz_tests
             , ["mode",mode]
             , ["pt",pt]      // add scope as the last arg for doctest 
             );  
   } 
```

The scope will be displayed in the output:

```
|Tests:
|
|> pt= [3, 4, 5];             // scope displayed in the output 
|> addz( pt,2 )= [3, 4, 2]
|> addz( pt,3 )= [3, 4, 8]
|> addz( pt,-1 )= [3, 4, 4]
```

####9. Commenting tests

There are two ways to add comments to the tests. One is making comments
in place of test cases, the other is an inline comment written as an
option to a test case. Consider the example used in *Quick Start*. We 
add 3 comments to the code:

```
module addz_test( mode=13 ){
  pt=[3,4,5];   
  doctest
  ( 
     addz, 
  ,  [
       "A string will be treated as it is"   // 1
     , [ "pt,2", addz(pt,2), [3,4,7] ]        
     , "// String starting with // will be in green" // 2
     , [ "pt,3", addz(pt,3), [3,4,8]
         , ["rem","In-line comments following output" ] // 3
       ]         
     ]
  ,  ["mode",mode], ["pt",pt]
  );
} 
```

####10. Test as string

In some cases, it's hard to compare variables and it's a good idea to 
convert them into string before comparison. There's an option *asstr* that
can be used:
```
module addz_test( mode=13 ){
  pt=[3,4,5];  
  doctest
  ( 
     addz, 
  ,  [
      ["pt,2",addz(pt,2),[3,4,7]]        
     ,["pt,3",addz(pt,3),[3,4,8],["asstr",true]] // for this test         
     ]
  ,  ["mode",mode, "asstr", true] // applied to all tests
  ,  ["pt",pt]
  );
} 
```

####11. Utility functions

Functions used by **doctest()** could serve as a stand-alone lib w/o the use of doctest. See 
below or *doctest_tool_test()* where they are tested by **doctest()**. 

```
dt_begwith ( o,x )=true|false
dt_countStr ( arr )=int
dt_countType ( arr,typ )=int
dt_echo_ ( s,arr=undef )
dt_endwith ( o,x )=T/F
dt_fmt ( x,[s,n,a,ud,fixedspace] )=string
dt_get ( o,i,iscycle=false )=item
dt_hash ( h,k, notfound=undef, if_v=undef, then_v=undef, else_v=undef )=Any
dt_haskey ( h,k )=T|F
dt_index ( o,x )=int
dt_inrange ( o,i )=T|F
dt_isarr ( x )=T|F
dt_isequal ( a,b )=T|F
dt_isint ( x )=T|F
dt_isnum ( x )=T|F
dt_isstr ( x )=T|F
dt_join ( arr, sp="," )=string
dt_keys ( h )=array
dt_multi ( x,n=2 )=str|arr
dt_replace ( o,x,new="" )=str|arr
dt_s ( s,arr,sp="{_}" )=str
dt_slice ( s,i,j="" )=str|arr
dt_split ( s, sp="," )=arr
dt_type ( x )=str
```

####12. Future Plan

* Output in different formats (html, markdown, wikibook, etc)
* Rewrite with new feature of OpenSCAD (list comprehension,etc)

####13. Release Note

1. **OpenSCAD_DocTest** is built on OpenSCAD 2014.03.11, in which some nice
newer features like list comprehension, var assignment in function, etc,
are not available. Therefore, many functions are made available through
extensive recursive and/or repetive calls of itself or some other 
functions. That could be a factor for its slowness.

2. Newer version of **OpenSCAD_DocTest** will take advantages of those new
features of OpenSCAD, which probably won't be available until the end of 
2014. At this moment, this version will most likely not add new features or 
improvements but bugfix. Still, comments or suggestions are always welcome.

3. The author would like to express appreciation for the help from OpenSCAD 
community in http://forum.openscad.org/ to make this release come true. 
"
