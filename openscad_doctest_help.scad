// OpenSCAD_DocTest: OpenSCAD documentation and unit testing library
// Copyright (C) 2014 Runsun Pan (run+sun (at) gmail.com) 
// Source: https://github.com/runsun/openscad_doctest
//
// This library is licensed under the AGPL 3.0 described in
// http://www.gnu.org/licenses/agpl.txt
//
// This file, openscad_doctest_help.scad, is part of OpenSCAD_DocTest library
//
// The OpenSCAD_DocTest library is free software: you can redistribute it and/or 
// modify it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//-------------------------------------------------------------------------


// openscad_doctest_help.scad
//
// Try one or both modules below. It will show a list of indices or modes, 
// so no need to worry about what to enter. Just run it and then choose from. 
//
// 	doctest_help(index)  // index=undef echos all help sections.
//
// 	doctest_tool_test(mode=2) 
//

include <openscad_doctest.scad>

//doctest_help(index=0); // index=undef echos all help sections

//doctest_tool_test(mode=0);
//doctest_tool_test(mode=1);
//doctest_tool_test(mode=2);
//doctest_tool_test(mode=3);
//doctest_tool_test(mode=10);
//doctest_tool_test(mode=11);
//doctest_tool_test(mode=12);
//doctest_tool_test(mode=13);

//doctest(doctest);


help_text=[

"Introduction", 

";;**OpenSCAD_DocTest** is a library for *doc* and *unit testing* of functions in OpenSCAD. 
;;Both doc and tests are written in arrays and processed by **doctest()** and output to the 
;;console. It has different modes like doc only, test only, show tests as examples (i.e., 
;;no testing), etc, and capable of commenting on test cases easily, making it a good tool 
;;for demostrating *function usages*. 
;;
;;Whichever mode it operates on, the output (in the console) can be copied and pasted
;;to a doc editor (like LibreOffice Writer), and an api doc can be generated with very 
;;minor editting. The *openscad_doctest_api.html* servers as a good demo for this feature.
;;
;;The *unit test* feature helps to ensure quality, reduces maintainence burden, facilitate 
;;re-factoring, and, my favorite, allows for test-first (or, test-driven) programming, i.e., 
;;write the expected outcome of a function first, then starts writing the code to see if it 
;;behaves as expected. 
"

//-----------------------------------------
,"Files included",

"
;;openscad_doctest.scad        --- doctest() and utilities (see below)
;;openscad_doctest_help.scad   --- help and doc and tests
;;openscad_doctest_demo_1.scad --- demo of basics
;;openscad_doctest_api.html    --- api doc
;;openscad_doctest_modes.md    --- screenshots of different modes
;;README.md
"

//-----------------------------------------
,"Quick Look",


";;Example function: addz(p,z)= [p.x, p.y, p.z+z]
;;
;;a. Write doc:
;;
;;   addz=[ &quot;addz&quot;   // function name
;;        , &quot;p,z&quot;    // arg names
;;        , &quot;array&quot;  // return type
;;        , &quot;Array&quot;  // category
;;        , &quot;Add z to the z of p.&quot;  // doc content
;;   ]; 
;;
;;b. Write test:  [ arg_string, result, expected] 
;;  
;;   module addz_test( mode=13 ){
;;      addz_tests=[
;;        [&quot;[3,4,5],2&quot;, addz([3,4,5],2), [3,4,7] ]
;;      ]; 
;;      doctest( addz, addz_tests, [&quot;mode&quot;,mode]); 
;;   }    
;;
;;   Or use local scope for variables:
;;
;;   module addz_test( mode=13 ){
;;      pt=[3,4,5];   // define test variables
;;      addz_tests=[
;;        [ &quot;pt,2&quot;, addz(pt,2), [3,4,7] ]        
;;      ]; 
;;      doctest( addz, addz_tests, [&quot;mode&quot;,mode], [&quot;pt&quot;,pt] );  // add scope
;;   }    
;;
;;c. Include this:
;;
;;   include &lt;openscad_doctest.scad&gt; 
;;   addz_test( 13 );
"

//-----------------------------------------
,"Console Output",

";;The output of **doctest()** depends on the value of option *mode*. For example,
;;mode=13, which is the full display of everything, gives this:
;;
;;-------------------------------------------------------
;;<u>addz ( p,z )=array ( tested:3/failed:1 )</u>
;;| Given a point (p) and a number (z), add z to p.z if p is
;;| 3d, or append z to p if p is 2d.
;;|
;;| Tags: Array
;;|
;;|Tests:
;;|
;;|> pt3= [3, 4, 5]; 
;;|> addz( [3,4],2 )= [3, 4, 2]
;;|> addz( pt3,2 )= [3, 4, 7]
;;|> addz( pt3,2 )= [3, 4, 5] got: [3, 4, 7] #FAIL#
"

//-----------------------------------------
,"Where to Start",

"
;; * Run *openscad_doctest_demo_1.scad* for a quick taste of basics.
;; * Run **doctest_help(index)** in *openscad_doctest_help.scad* to display help
;; * Run **doctest_tool_test(mode)** in *openscad_doctest_help.scad* for a
;;   complete demo of testing all the unility functions that **doctest** uses.
;;
;; Pick an *index* or *mode* according to the instructions displayed. 
"
 
//-----------------------------------------
,"Doctest Modes",

";;Features *doc* and *testing* in **doctest()** can be used together or
;;separately by setting doctest's *mode* option to one of 8 possibilities. 
;;Lets start with the *test*-only modes:
;;
;; mode test? display_tests?
;; ---- ----- -------------- 
;;  0   NO       NO         => doesn't do or display tests  
;;  1   NO       YES        => no test, but display test cases  
;;  2   YES      ON_ERROR   => do tests, but display tests only on failed
;;  3   YES      YES        => do and display all tests
;;
;;To add doc, simply add 10 to them. Below is the details:
;;
;;  0, ''No doc, no test, show function headers only.''
;;  1, ''No doc, no test, show all test cases as usage examples.''
;;  2, ''No doc. Do tests, but show only failed cases.''
;;  3, ''No doc. Do tests and show all test cases.''
;; 10, ''Show doc, no test.''
;; 11, ''Show doc, no test, show all test cases as usage examples.''
;; 12, ''Show doc, do tests, but show only the error cases.''
;; 13, ''Show doc, test and show all test cases.''
"

//-----------------------------------------
,"Special Characters",

";;Special attention is needed when writing doc and tests. 
;;
;;a. Use double apostrophes (<span>'</span>') in place of a quote symbol(&quot;)to represent a string:
;;
;;   [ &quot;''abcdef'', ''def''&quot;, dt_begwith(&quot;abcdef&quot;, &quot;def&quot;), false ]
;;
;;b. In the doc, use double semicolon (<span>;</span>;) as a linebreak:
;;   
;;   dt_get=[ ... ,
;;    &quot; Given a str or arr (o), an index (i), get the i-th item.
;;   ;<span>;</span> i could be negative.
;;   ;<span>;</span>
;;   ;<span>;</span> *iscycle*: cycling from the other end if out of range. Useful
;;   ;<span>;</span> when looping through the boundary points of a shape.
;;   ;<span>;</span>&quot;]; 
;;
;;c. If a semicolon is to be placed in the end of line, like showing a code line,
;;   put an extra space after it to prevent it from mixing with the next linebreak.
"


//-----------------------------------------
,"Scope for Test",

";;Being able to set variable scope for testing makes coding the tests a lot easier 
;;also make the tests much easier to read, especially when the value length is long 
;;and repeated use of a variable is needed. 
;;
;;   module addz_test( mode=13 ){
;;
;;      pt=[3,4,5];   // define test variables
;;
;;      addz_tests=
;;      [
;;        [ &quot;pt,2&quot;, addz(pt,2), [3,4,7] ]  // pt is applied here       
;;        [ &quot;pt,3&quot;, addz(pt,3), [3,4,8] ]  // Don't have to re-type long value 
;;        [ &quot;pt,-1&quot;, addz(pt,-1), [3,4,4] ]  
;;      ]; 
;;      doctest( addz
;;             , addz_tests
;;             , [&quot;mode&quot;,mode]
;;             , [&quot;pt&quot;,pt]      // add scope as the last arg for doctest 
;;             );  
;;   } 
;;
;;The scope will be displayed in the output:
;;
;; |Tests:
;; |
;; |> pt= [3, 4, 5];             // scope displayed in the output 
;; |> addz( pt,2 )= [3, 4, 2]
;; |> addz( pt,3 )= [3, 4, 8]
;; |> addz( pt,-1 )= [3, 4, 4]
"


//-----------------------------------------
,"Commenting tests",

";;There are two ways to add comments to the tests. One is making comments
;;in place of test cases, the other is an inline comment written as an
;;option to a test case. Consider the example used in *Quick Start*. We 
;;add 3 comments to the code:
;;
;;   module addz_test( mode=13 ){
;;      pt=[3,4,5];   
;;      doctest
;;      ( 
;;         addz, 
;;      ,  [
;;           &quot;A string will be treated as it is&quot;   // 1
;;         , [ &quot;pt,2&quot;, addz(pt,2), [3,4,7] ]        
;;         , &quot;// String starting with // will be in green&quot; // 2
;;         , [ &quot;pt,3&quot;, addz(pt,3), [3,4,8]
;;             , [&quot;rem&quot;,&quot;In-line comments following output&quot; ] // 3
;;           ]         
;;         ]
;;      ,  [&quot;mode&quot;,mode], [&quot;pt&quot;,pt]
;;      );
;;   } 
"

//-----------------------------------------
,"Test as string",

";;In some cases, it's hard to compare variables and it's a good idea to 
;;convert them into string before comparison. There's an option *asstr* that
;;can be used:
;;
;;   module addz_test( mode=13 ){
;;      pt=[3,4,5];  
;;      doctest
;;      ( 
;;         addz, 
;;      ,  [
;;          [&quot;pt,2&quot;,addz(pt,2),[3,4,7]]        
;;         ,[&quot;pt,3&quot;,addz(pt,3),[3,4,8],[&quot;asstr&quot;,true]] // for this test         
;;         ]
;;      ,  [&quot;mode&quot;,mode, &quot;asstr&quot;, true] // applied to all tests
;;      ,  [&quot;pt&quot;,pt]
;;      );
;;   } 
"

//-----------------------------------------
,"Utility functions",

"
;;Functions used by doctest() could serve as a stand-alone lib w/o the use of doctest. See 
;;below or doctest_tool_test() where they are tested by doctest(). 
;;
;;  dt_begwith ( o,x )=true|false
;;  dt_countStr ( arr )=int
;;  dt_countType ( arr,typ )=int
;;  dt_echo_ ( s,arr=undef )
;;  dt_endwith ( o,x )=T/F
;;  dt_fmt ( x,[s,n,a,ud,fixedspace] )=string
;;  dt_get ( o,i,iscycle=false )=item
;;  dt_hash ( h,k, notfound=undef, if_v=undef, then_v=undef, else_v=undef )=Any
;;  dt_haskey ( h,k )=T|F
;;  dt_index ( o,x )=int
;;  dt_inrange ( o,i )=T|F
;;  dt_isarr ( x )=T|F
;;  dt_isequal ( a,b )=T|F
;;  dt_isint ( x )=T|F
;;  dt_isnum ( x )=T|F
;;  dt_isstr ( x )=T|F
;;  dt_join ( arr, sp=&quot;,&quot; )=string
;;  dt_keys ( h )=array
;;  dt_multi ( x,n=2 )=str|arr
;;  dt_replace ( o,x,new=&quot;&quot; )=str|arr
;;  dt_s ( s,arr,sp=&quot;{_}&quot; )=str
;;  dt_slice ( s,i,j=&quot;&quot; )=str|arr
;;  dt_split ( s, sp=&quot;,&quot; )=arr
;;  dt_type ( x )=str
"
////-----------------------------------------
//,"Advanced Usage",
//
//";;
//
//"


//-----------------------------------------
,"Future Plan",

";;* Output in different formats (html, markdown, wikibook, etc)
;;* Rewrite with new feature of OpenSCAD (list comprehension,etc)
"


//-----------------------------------------
,"Release Note",

";;1. **OpenSCAD_DocTest** is built on OpenSCAD 2014.03.11, in which some nice
;;newer features like list comprehension, var assignment in function, etc,
;;are not available. Therefore, many functions are made available through
;;extensive recursive and/or repetive calls of itself or some other 
;;functions. That could be a factor for its slowness.
;;
;;2. Newer version of **OpenSCAD_DocTest** will take advantages of those new
;;features of OpenSCAD, which probably won't be available until the end of 
;;2014. At this moment, this version will most likely not add new features or 
;;improvements but bugfix. Still, comments or suggestions are always welcome.
;;
;;3. The author would like to express appreciation for the help from OpenSCAD 
;;community in http://forum.openscad.org/ to make this release come true. 
"
];


module doctest_help(index=0)
{

	titles= concat([""], dt_keys( help_text ));
	//topics = dt_keys(help_text);

	function hashkvs(h, _i_=0)=
	(
		!dt_isarr(h)? undef     // not a hash
		:_i_>len(h)-1? []       // end of search
			: concat( 
					 [[h[_i_],h[_i_+1]]]
				    , hashkvs(h, _i_=_i_+2)
					)
	);

	_menulist = "{_} {_} {_}: {_}{_}";
	function _getmenu(_I_=1)=
	(
		_I_<len(titles)
		? concat( 
			[ index==_I_
			  ? dt_s( _menulist, ["<b>", "@", _I_, titles[_I_], "</b>"])
			  : dt_s( _gray(_menulist), ["", " ", _I_, titles[_I_], ""])
			]
			, _getmenu(_I_+1)
		):[]
	);

	function _gettitle()=
	(	
		_color(str(
		dt_multi("#",78)
		,_h2("OpenSCAD_DocTest")
		,"OpenSCAD_DocTest version: ", DOCTEST_VERSION
		,"<br/>Copyright (C) 2014 Runsun Pan (run+sun (at) gmail.com)"
		,_BR
		),"darkgreen")
	);

	//
	// Header of doctest_help (including menu list)
	//
	module echo_header(gettitle=false)
	{
	echo(
		_pre(
			str( _BR
			   ,  _color(dt_multi("#",78),"darkgreen")
			   ,  _h3(dt_s("doctest_help( index={_} ) starts",[ index ])
					, "color:darkgreen;margin-top:0px;margin-bottom:0px")
			   , gettitle? _gettitle():""
			   , dt_multi("-",78)
			   , _BR
			   , dt_join( _getmenu(), "<br/>")
			   , _BR
			   , _color(dt_multi("-",78),"darkgreen")
			   )
			)
		);
  	}

	module echo_footer()
	{
	//
	// Footer of doctest_help
	//
	echo(_pre(str(
		 _color(dt_multi("-",78),"darkgreen")
		,_h3(dt_s("doctest_help( index={_} ) ends",[index])
				, "color:darkgreen;margin-top:0px;margin-bottom:0px")
		,  _color(dt_multi("#",78),"darkgreen")
		)));
	}


	module echo_text( txt, i )
	{ 
	 
       echo( str( 							// text title
				_b(_u( 
					   str( //"&nbsp;&nbsp;"b
					   i,". "
					  , titles[i]
					  //, "&nbsp;&nbsp;"
					  )
				  ), "font-size:18px")
										// text content
			    ,_code(
			 		  _pre(dt_replace(txt, ";;","<br/>"))
					 )
	  ));
	}
	
	if( !index ){
		echo_header(gettitle=true);	
		for( i=[1:len(titles)-1] ) {
			echo_text( dt_hash( help_text, titles[i]), i );
		}
	} else {
		echo_header();	
 		 echo_text( dt_hash( help_text, titles[index]), index );
	}
	echo_footer();
	
}


// ========================================================
//
// Tool functions for doctest. All are prefixed with dt_.
//
// ========================================================
dt_begwith=[ "dt_begwith", "o,x", "true|false",  "String, Array, Inspect" ,
" Given a str|arr (o) and x, return true if o starts with x.
"];
module dt_begwith_test(ops)
{

	dt_begwith_tests=
	[ 
  	  [ "''abcdef'', ''def''", dt_begwith("abcdef", "def"), false ]
	, [ "''abcdef'', ''abc''",  dt_begwith("abcdef", "abc"),true ]
	, [ "''abcdef'', ''''",  dt_begwith("abcdef", ""),undef ]
	, [ "[''ab'',''cd'',''ef'', ''ab''", dt_begwith(["ab","cd","ef"], "ab"),true]
	, [ "[], ''ab''", dt_begwith([], "ab"),false]
	, [ "'''', ''ab''", dt_begwith("", "ab"),false]
	//, "// The following are intentionally given wrong anwsers "
//	, "// to test the error reporting capability."
//	,[ "''abcdef'', ''def''", dt_hash("abcdef", "def"), 1, ["rem","error demonstration"] ]
	];
	
	doctest( dt_begwith, dt_begwith_tests, ops );
}


//========================================================
dt_countStr= ["dt_countStr", "arr", "int", "Array, Inspect",
" Given array (arr), count the number of strings in arr. 
"];
module dt_countStr_test( ops )
{
	doctest
	( 
	  dt_countStr
	, [
		[ "[''x'',2,''3'',5]", dt_countStr(["x",2,"3",5]), 2 ]
	  ,	[ "[''x'',2, 5]", dt_countStr(["x",2,5]), 1 ]
	  ]
	, ops
	);

}
//========================================================
dt_countType= ["dt_countType", "arr,typ", "int", "Array, Inspect",
" Given array (arr) and dt_type name (typ), count the items of type
;; *typ* in arr.
"];
module dt_countType_test( ops )
{

	dt_countType_tests=  
	[
		[ "[''x'',2,[1,2],5.1], ''str''"
			, dt_countType(["x",2,[1,2],5.1], "str"), 1 ]
	  ,	[ "[''x'',2,[1,2],5.1,3], ''int''"
			, dt_countType(["x",2,[1,2],5.1,3],"int"), 2 ]
	  ,	[ "[''x'',2,[1,2],5.1,3], ''float''"
			, dt_countType(["x",2,[1,2],5.1,3],"float"), 1 ]
	];

	doctest(dt_countType, dt_countType_tests,ops);

} 

//========================================================
dt_echo_=["dt_echo_", "s,arr=undef", "n/a", "Console",
" Given a string containing one or more ''{_}'' as blanks to fill,
;; and an array (arr) as the data to fill, echo a new string with all 
;; blanks replaced by arr items one by one. If the arr is given as 
;; a string, it is the same as echo( str(s,arr) ).
;;
;; Example usage: 
;;
;; dt_echo_( ''{_}.scad, version={_}'', [''openscad_doctest'', ''20140729-1''] );
"];
module echo__test( ops ){ doctest( dt_echo_, ops=ops); }


//========================================================
dt_endwith=[ "dt_endwith", "o,x", "T/F",  "String, Array, Inspect",
" Given a str|arr (o) and x, return true if o ends with x.
"];
module dt_endwith_test( ops )
{
	doctest
	(
	 dt_endwith
	,[ 
	    [ "''abcdef'', ''def''", dt_endwith("abcdef", "def"), true ]
	  , [ "''abcdef'', ''def''", dt_endwith("abcdef", "abc"), false ]
	  , [ "[''ab'',''cd'',''ef''], ''ef''",  dt_endwith(["ab","cd","ef"], "ef"),true ]
	  , [ "[''ab'',''cd'',''ef''], ''ab''",  dt_endwith(["ab","cd","ef"], "ab"),false ]
	  ], ops
	);
}

//========================================================
dt_fmt=["dt_fmt", "x,[s,n,a,ud,fixedspace]", "string", "String" ,
" Given an variable (x), and formattings for string (s), number (n),
;; array (a) or undef (ud), return a formatted string of x. If
;; fixedspace is set to true, replace spaces with html space. The
;; formatting is entered in ''(prefix),(suffix)'' pattern. For
;; example, if x is a number, setting n=''{,}'' converts x to ''{x}''.
"
];
module dt_fmt_test( ops )
{

	doctest(
	 dt_fmt
	,[
	   str("dt_fmt(3.45): ", dt_fmt(3.45))
     ,  str("dt_fmt([''a'',[3,''b''], 4]): ", dt_fmt(["a",[3,"b"], 4] ))
     ,  str("dt_fmt(''a string with     5 spaces''): ", dt_fmt("a string with     5 spaces"))			, str("dt_fmt(false): ", dt_fmt(false))

	],  ops
	);
}

//========================================================
dt_get=["dt_get", "o,i,iscycle=false", "item", "dt_index, Inspect, Array, String",
" Given a str or arr (o), an index (i), get the i-th item.
;; i could be negative.
;;
;; *iscycle*: cycling from the other end if out of range. Useful
;; when looping through the boundary points of a shape.
"];

module dt_get_test( ops=["mode",13] )
{
	arr = [20,30,40,50];

	doctest
	( dt_get
		,[ 
		  "## array ##"
		 , [ "arr, 1", dt_get( arr, 1 ), 30 ]
    		 , [ "arr, -1", dt_get(arr, -1), 50 ]
    		 , [ "arr, -2", dt_get(arr, -2), 40 ]
    		 , [ "arr, true", dt_get(arr, true), undef ]
    		 , [ "[], 1", dt_get([], 1), undef ]
		 , [ "[[2,3],[4,5],[6,7]], -2", dt_get([[2,3],[4,5],[6,7]], -2), [4,5] ]
    		 , "## string ##"
    		 , [ "''abcdef'', -2", dt_get("abcdef", -2), "e" ]
    		 , [ "''aabcdef'', false", dt_get("abcdef", false), undef ]
    		 , [ "'''', 1", dt_get("", 1), undef ]
		 , "//New 2014.6.27: iscycle"
		 , [ "arr, 4", dt_get(arr,4), undef]
		 , [ "arr, 4, iscycle=true", dt_get(arr,4,iscycle=true), 20]
		 , [ "arr, 10, iscycle=true", dt_get(arr,10,iscycle=true), 40]
		 , [ "arr, -5", dt_get(arr,-5), undef]
		 , [ "arr, -5, iscycle=true", dt_get(arr,-5,iscycle=true), 50]

    		 ],ops,  ["arr", arr]
	);
}

//========================================================
dt_hash=[ "dt_hash", "h,k, notfound=undef, if_v=undef, then_v=undef, else_v=undef", "Any","dt_hash",
" Given an array (h, arranged like h=[k,v,k2,v2 ...] to serve
;; as a hash) and a key (k), return a v from h: dt_hash(h,k)=v.
;; If key not found, or value not found (means k is the last item
;; in h), return notfound. When if_v is defined, check if v=if_v.
;; If yes, return then_v. If not, return else_v if defined, or v
;; if not.
"];

module dt_hash_test( ops )
{
	scope=[
	"h", 	[ -50, 20 
			, "xy", [0,1] 
			, 2.3, 5 
			,[0,1],10
			, true, 1 
			, 1, false
			,-5
			]
	];
	h = dt_hash( scope, "h");	
	h2 = dt_hash( scope, "h2");	

	doctest
	(
		dt_hash  
		,[ [ "h, -50", dt_hash(h, -50), 20 ]
    		 , [ "h, ''xy''", dt_hash(h, "xy"), [0,1] ]
		 , [ "h, 2.3", dt_hash(h, 2.3), 5 ]
    		 , [ "h, [0,1]", dt_hash(h, [0,1]), 10 ]
		 , [ "h, true", dt_hash(h, true), 1 ]
    		 , [ "h, 1", dt_hash(h, 1), false ]
    		 , [ "h, ''xx''", dt_hash(h, "xx"), undef ]
		 , "## key found but it's in the last item without value:"
    		 , [ "h, -5", dt_hash(h, -5), undef ]
		 , "## notfound is given: "
    		 , [ "h, -5,''df''", dt_hash(h, -5,"df"), "df" , ["rem", "value not found"] ]
	 	 , [ "h, -50, ''df''", dt_hash(h, -50,"df"), 20 ]
    		 , [ "h, -100, ''df''", dt_hash(h, -100,"df"), "df" ]
		 , "## Other cases:"
	 	 , [ "[], -100", dt_hash([], -100), undef ]
	 	 , [ "true, -100", dt_hash(true, -100), undef ]
    		 , [ "[[undef,10]], undef", dt_hash([ [undef,10]], undef), undef ]
 		 , "  "
	 	 , "## Note below: you can ask for a default upon a non-hash !!"
		 , [ "true, -100, ''df''", dt_hash(true, -100, "df"), "df"]
	 	 , [ "true, -100 ", dt_hash(true, -100), undef]
	 	 , [ "3, -100, ''df''", dt_hash(3, -100, "df"), "df"]
	 	 , [ "''test'', -100, ''df''", dt_hash("test", -100, "df"), "df"]
		 , [ "false, 5, ''df''", dt_hash(false, 5, "df"), "df"]
		 , [ "0, 5, ''df''", dt_hash(0, 5, "df"), "df" ]
		 , [ "undef, 5, ''df''", dt_hash(undef, 5, "df"), "df" ]
		 , "  "
		 , "## New 20140528: if_v, then_v, else_v "
		 , [ "h, 2.3, if_v=5, then_v=''got_5''", dt_hash(h, 2.3, if_v=5, then_v="got_5"), "got_5" ]
		 , [ "h, 2.3, if_v=6, then_v=''got_5''", dt_hash(h, 2.3, if_v=6, then_v="got_5"), 5 ]
		 , [ "h, 2.3, if_v=6, then_v=''got_5'', else_v=''not_5''"
					, dt_hash(h, 2.3, if_v=6, then_v="got_5", else_v="no_5"), "no_5" ]

		], ops,scope
	);
}


//========================================================
dt_haskey=["dt_haskey", "h,k", "T|F", "Hash, Inspect",
" Check if the hash (h) has a key (k)
"];

module dt_haskey_test( ops )
{
	table = 	[ -50, 20 
			, "80", 25 
			, 2.3, "yes" 
			,[0,1],5
			, true, "YES" 
			];

	doctest
	(dt_haskey, 
		 [ [ "table, -50", dt_haskey(table, -50), true ]
    		 , [ "table, ''80''", dt_haskey(table, "80"), true ]
		 , [ "table, ''xy''", dt_haskey(table, "xy"), false ]
		 , [ "table, 2.3", dt_haskey(table, 2.3), true ]
    		 , [ "table, [0,1]", dt_haskey(table, [0,1]), true ]
		 , [ "table, true", dt_haskey(table, true), true ]
    		 , [ "table, -100", dt_haskey(table, -100), false ]
    		 , [ "[], -100", dt_haskey([], -100), false ]
    		 , [ "[[undef,1], undef", dt_haskey([ [undef,1]], undef), true
			, [["rem","###### NOTE THIS!"]] ]
    		 ],ops, ["table", table]
	);

}

//========================================================
dt_index=["dt_index", "o,x", "int", "dt_index,Array,String,Inspect",
" Return the index of x in o (a str|arr), or -1 if not found.
"];	 

module dt_index_test( ops )
{

     arr = ["xy","xz","yz"];
	arr2= ["I_am_the_findw"];

	doctest
	(dt_index,  
	 [ 
	 "## Array dt_indexing ##"
	 , [ "arr, ''xz''", dt_index(["xy","xz","yz"],"xz"),  1 ]
    	 , [ "arr, ''yz''", dt_index(["xy","xz","yz"],"yz"),  2 ]
    	 , [ "arr, ''xx''", dt_index(["xy","xz","yz"],"xx"),  -1 ]
    	 , [ "[], ''xx''", dt_index([],"xx"),  -1 ]
    	 ,"## String indexing ##"
	 , [ "arr2, ''a''", dt_index( "I_am_the_findw","a"),  2 ]
    	 , [ "arr2, ''am''", dt_index( "I_am_the_findw","am"),  2 ]
    	 , [ "''abcdef'',''f''", dt_index(  "abcdef","f"),  5 ]
    	 , [ "''findw'',''n''", dt_index( "findw","n"),  2 ]
    	 , [ "arr2, ''find''", dt_index( "I_am_the_findw","find"),  9 ]
    	 , [ "arr2, ''the''", dt_index( "I_am_the_findw","the"),  5 ]
    	 , [ "arr2, ''findw''", dt_index("I_am_the_ffindw","findw"),  10 ]
    	 , [ "''findw'', ''findw''", dt_index("findw", "findw"),  0 ]
    	 , [ "''findw'', ''dwi''", dt_index( "findw","dwi"),  -1 ]
    	 , [ "arr2, ''The''", dt_index("I_am_the_findw","The"),  -1 ]
	 , [ "arr2, ''tex''",dt_index( "replace__text","tex"),  9 ]
    	 , [ "''replace__ttext'', ''tex''", dt_index("replace__ttext","tex"), 10 ]
    	 , [ "''replace_t_text'',''tex''", dt_index( "replace_t_text","text"),  10]
	 , [ "''abc'', ''abcdef''",dt_index("abc", "abcdef"),  -1 ]
	 , [ "'''', ''abcdef''",dt_index( "","abcdef"),  -1 ]
	 , [ "'''', ''abc''",dt_index( "abc",""),  -1 ]
	 ,"## String indexing with wrap ##"
	 , [ "''{a}bc'',''a'', ''{,}''", dt_index("{a}bc","a",wrap="{,}"), 0] 
	 , [ "''a}bc'',''a'', '',}''", dt_index("a}bc","a",wrap=",}"), 0] 
	 , [ "''a{b}c'',''b'', ''{,}''", dt_index("a{b}c","b",wrap="{,}"), 1] 
	 , [ "''a//bc'',''b'', ''//,''", dt_index("a//bc","b",wrap="//,"), 1] 
	 , [ "''abc:d'',''c'', '',:''", dt_index("abc:d","c",wrap=",:"), 2] 
	 , [ "''a{_b_}{_c_}'',''c'', ''{_,_}''", dt_index("a{_b_}{_c_}","c",wrap="{_,_}"), 6] 
	 ,"## Others ##"
	 , [ "[2, ,3, undef], undef", dt_index([2,3, undef], undef), 2 ]
    	 ],ops, ["arr",arr, "arr2",arr2]
	);
}

//========================================================
dt_inrange=["dt_inrange", "o,i", "T|F", "dt_index, Array, String, Inspect",
" Check if index i is in range of o (a str|arr). i could be negative.
"];

module dt_inrange_test( ops )
{

	doctest
	( 
	 dt_inrange, [
		"## string ##"
	  , [ "''789'',2", dt_inrange("789",2), true ]
	  ,	[ "''789'',3", dt_inrange("789",3), false ]
	  ,	[ "''789'',-2", dt_inrange("789",-2), true ]
	  ,	[ "''789'',-3", dt_inrange("789",-3), true ]
	  ,	[ "''789'',-4", dt_inrange("789",-4), false ]
	  ,	[ "'',0", dt_inrange("",0), false ]
	  ,	[ "''789'',''a''", dt_inrange("789","a"), false ]
	  ,	[ "''789'',true", dt_inrange("789",true), false ]
	  ,	[ "''789'',[3]", dt_inrange("789",[3]), false ]
	  ,	[ "''789'',undef", dt_inrange("789",undef), false ]
	  , "## array ##"
	  ,	[ "[7,8,9],2", dt_inrange([7,8,9],2), true ]
	  ,	[ "[7,8,9],3", dt_inrange([7,8,9],3), false ]
	  ,	[ "[7,8,9],-2", dt_inrange([7,8,9],-2), true ]
	  ,	[ "[7,8,9],-3", dt_inrange([7,8,9],-3), true ]
	  ,	[ "[7,8,9],-4", dt_inrange([7,8,9],-4), false ]
	  ,	[ "[],0", dt_inrange([],0), false ]
	  ,	[ "[7,8,9],''a''", dt_inrange([7,8,9],"a"), false ]
	  ,	[ "[7,8,9],true", dt_inrange([7,8,9],true), false ]
	  ,	[ "[7,8,9],[3]", dt_inrange([7,8,9],[3]), false ]
	  ,	[ "[7,8,9],undef", dt_inrange([7,8,9],undef), false ]
	  ], ops
	);
}

//========================================================
dt_isarr=[ "dt_isarr","x", "T|F", "dt_type, Inspect, Array",
" Given x, return true if x is an array.
"];

module dt_isarr_test( ops )
{
	doctest
	(
		dt_isarr, [
		[ "[1,2,3]", dt_isarr([1,2,3]), true]
	 ,	[ "''a''", dt_isarr("a"), false]
	 ,	[ "true", dt_isarr(true), false]
	 ,	[ "false", dt_isarr(false), false]
	 ,	[ "undef", dt_isarr(undef), false]
	 ],ops
	);
}

//========================================================
dt_isequal=["dt_isequal", "a,b", "T|F", "Inspect",
dt_s("
 Given 2 numbers a and b, return true if they are determined to
;; be the same value. This is needed because sometimes a calculation
;; that should return 0 ends up with something like 0.0000000000102.
;; So it fails to compare with 0.0000000000104 (another shoulda-been
;; 0) correctly. This function checks if abs(a-b) is smaller than the
;; predifined DT_ZERO constant ({_}) and return true if it is.
", [DT_ZERO])
];

module dt_isequal_test( ops )
{
	doctest
	(
		dt_isequal, [

	 ],ops
	);
}



//========================================================
dt_isint = [ "dt_isint","x", "T|F", "dt_type,Inspect, Number",
" Check if x is an integer.
"];

module dt_isint_test( ops )
{
	doctest(dt_isint, 
	[
		[ "3", dt_isint(3), true]
	 ,	[ "3.2", dt_isint(3.2), false]
	 ,	[ "''a''", dt_isint("a"), false]
	],ops
	);
}


//========================================================
dt_isnum =["dt_isnum","x", "T|F", "Type,Inspect,Number",
" Check if x is a number.
"];

module dt_isnum_test( ops )
{
	doctest(dt_isnum, 
	[
		[ "3", dt_isnum(3), true]
	 ,	[ "3.2", dt_isnum(3.2), true]
	 ,	[ "''a''", dt_isnum("a"), false]
	],ops
	);
}


//========================================================
dt_isstr= ["dt_isstr","x", "T|F", "dt_type,String,Inspect",
" Check if x is a string.
"];

module dt_isstr_test( ops )
{
	doctest(dt_isstr, 
	[
		[ "3", dt_isstr(3), false]
	 ,	[ "3.2", dt_isstr(3.2), false]
	 ,	[ "''a''", dt_isstr("a"), true]
	],ops
	);
}

//========================================================
dt_join=["dt_join", "arr, sp=\",\"" , "string","Array",
" join items of arr into a string, separated by sp.
"];

module dt_join_test( ops=["mode",13] )
{
  doctest( 
	dt_join, 
	[
	  [ "[2,3,4]", dt_join([2,3,4]), "2,3,4", ["rem","default sp=&quot;,&quot;" ]]
	, [ "[2,3,4], ''|''", dt_join([2,3,4], "|"), "2|3|4" ]
	, [ "[2,[5,1],''a''], ''/''", dt_join([2,[5,1],"a"], "/"), "2/[5, 1]/a" ]
	, [ "[], ''|''", dt_join([], "|"), "" ]
	, "// The following are intentionally given wrong anwsers "
	, "// to test the error reporting capability."
	, [ "[2,3,4], ''|''", dt_join([2,3,4], "|"), "2,3,4" ]
	], ops
  );
}


//========================================================
dt_keys=["dt_keys", "h", "array", "Hash",
" Given a hash (h), return keys of h as an array.
"];

module dt_keys_test( ops=["mode",13] )
{
	doctest
	( dt_keys, 
	  [
		[ ["a",1,"b",2], dt_keys(["a",1,"b",2]), ["a","b"] ]
	  ,	[ [1,2,3,4], dt_keys([1,2,3,4]), [1,3] ]
	  ,	[ "[1,2],0,3,4", dt_keys([[1,2],0,3,4]), [[1,2],3] ]
	  ,	[ [], dt_keys([]), [] ]
	  ],ops
	);
}

//========================================================
dt_multi=["dt_multi", "x,n=2", "str|arr", "Array,String" ,
" Given x and n, duplicate x (a str|int|arr) n times.
"];

module dt_multi_test( ops )
{
	doctest( 
	dt_multi, [ 
		[ "''d''", dt_multi("d"), "dd" ]
	 ,	[ "''d'',5''", dt_multi("d",5), "ddddd" ]
	 ,	[ "[2,3]", dt_multi([2,3]), [2,3,2,3] ]
	 ,	[ "[2,3],3", dt_multi([2,3],3), [2,3,2,3,2,3] ]
	 ,  ["3",  dt_multi(3), "33" ]
	 ,  ["3,5",  dt_multi(3,5), "33333", [["rem","return a string"]] ]
	],ops
	);
} 

//========================================================
dt_replace =[ "dt_replace", "o,x,new=\"\"", "str|arr", "String, Array",
" Given a str|arr (o), x and optional new, replace x in o with
;; new when o is a str; replace the item x (an index) with new
;; when o is an array.
" ];

module dt_replace_test( ops )
{
	doctest( dt_replace, 
	[
	  ["''a_text'', ''e''", 			dt_replace("a_text", "e"), "a_txt"]
	 ,["''a_text'', ''''", 			dt_replace("a_text", ""), "a_text"]
	 ,["''a_text'', ''a_t'', ''A_T''", dt_replace("a_text", "a_t", "A_T"), 	"A_Text"]
	 ,["''a_text'', ''ext'', ''EXT''", 	dt_replace("a_text", "ext", "EXT"), "a_tEXT"]
	 ,["''a_text'', ''abc'', ''EXT''", 	dt_replace("a_text", "abc", "EXT"), "a_text"]
	 ,["''a_text'', ''t'',   ''{t}''", 	dt_replace("a_text", "t", 	"{t}"), "a_{t}ex{t}"]
	 ,["''a_text'', ''t'', 4",     dt_replace("a_text", "t", 	4), 		"a_4ex4"]
	 ,["''a_text'', ''a_text'', ''EXT''", dt_replace("a_text", "a_text","EXT"), "EXT"]
    	 ,["'''', ''e''", 			dt_replace("", "e"), ""]
	 ,"# Array # "
	 ,["[2,3,5], 0, 4", dt_replace([2,3,5], 0, 4), [4,3,5] ]
	 ,["[2,3,5], 1, 4", dt_replace([2,3,5], 1, 4), [2,4,5] ]
	 ,["[2,3,5], 2, 4", dt_replace([2,3,5], 2, 4), [2,3,4] ]
	 ,["[2,3,5], 3, 4", dt_replace([2,3,5], 3, 4), [2,3,5] ]
	 ], ops
	);
} 
//========================================================
dt_s= [ "dt_s", "s,arr,sp=''{_}''" , "str", "String",
" Given a string (s) and an array (arr), replace the sp in s with
;; items of arr one by one. This serves as a string template.
"
] ;

module dt_s_test( ops )
{
	doctest( 
	dt_s
	, [
		 ["''2014.{_}.{_}'', [3,6]", dt_s("2014.{_}.{_}", [3,6]), "2014.3.6"]
	 	,["'''', [3,6]", dt_s("", [3,6]), ""]
	 	,["''2014.{_}.{_}'', []", dt_s("2014.{_}.{_}", []), "2014.{_}.{_}"]
	 	,["''2014.{_}.{_}'', [3]", dt_s("2014.{_}.{_}", [3]), "2014.3.{_}"]
	 	,["''2014.3.6'', [4,5]",     dt_s("2014.3.6", [4,5]), "2014.3.6"]
		,["''{_} car {_} seats?'', [''red'',''blue'']"
			,dt_s("{_} car {_} seats?", ["red","blue"]), "red car blue seats?"]	 
		 ], ops
	);
}
//========================================================
dt_slice=["dt_slice", "s,i,j=\"\"", "str|arr", "String,Array",
" Slice s (str|arr) from i to j.
"
];


module dt_slice_test( ops )
{
	doctest( 
	dt_slice
	, [
	  "## dt_slice a string ##" 			 
	  , [ "''I_am_the_dt_slice'', -6", dt_slice("I_am_the_slice", -6), "_slice"]
	  ,[ "''I_am_the_dt_slice'', 0", dt_slice("I_am_the_slice", 0), "I_am_the_slice"]
	  ,[ "''I_am_the_slice'', 0,5", dt_slice("I_am_the_slice", 0,5), "I_am_"]
	  ,[ "''I_am_the_slice'', 2", dt_slice("I_am_the_slice", 2), "am_the_slice"]
	  ,[ "''I_am_the_slice'', 2,5", dt_slice("I_am_the_slice", 2,5), "am_"]
	  ,[ "''I_am_the_slice'', -9,-6", dt_slice("I_am_the_slice", -9,-6), "the"]
	  ,[ "''I_am_the_slice'', -2", dt_slice("I_am_the_slice", -2), "ce"]
	  ,[ "''I_am_the_slice'', 1,1", dt_slice("I_am_the_slice", 1,1), ""]
	  ,[ "'''', -2", dt_slice("", -2), undef]
	  
	  , "## slice an array ##" 			 
	  , [ "[3,4,5,6,7,8,9], 2", dt_slice([3,4,5,6,7,8,9], 2), [5,6,7,8,9]]
    	  , [ "[3,4,5,6,7,8,9], 2,5", dt_slice([3,4,5,6,7,8,9], 2,5), [5,6,7]]
    	  , [ "[3,4,5,6,7,8,9], -3", dt_slice([3,4,5,6,7,8,9], -3), [7,8,9]]
    	  , [ "[[1,2],[3,4],[5,6]], 2"
	  	, dt_slice([[1,2],[3,4],[5,6]], 2), [[5,6]]]
    	  , [ "[[1,2],[3,4],[5,6]], 1,1"
	  	, dt_slice([[1,2],[3,4],[5,6]], 1,1), []]
    	  , [ "[], 1", dt_slice([], 1), undef]
    	  , [ "[9], 1", dt_slice([9], 1), undef]
    	  
	  ,"// --- when j>0 && i>j || i<0 && j<i "
	  ,[ "''I_am_the_slice'', 5,2", dt_slice("I_am_the_slice", 5,2), undef, [["rem","Watch this"]]]
	  ,[ "''I_am_the_slice'', 2,1", dt_slice("I_am_the_slice", 2,1), undef, [["rem","Watch this"]]]
	  
	  ,[ "''I_am_the_slice'', -3,-5", dt_slice("I_am_the_slice", -3,-5), undef, [["rem","Watch this"]]]
	  ], ops
	);
}


//========================================================
dt_split= [ "dt_split", "s, sp=\",\"", "arr", "String",
" Split a string into an array.
"
];

module dt_split_test( ops )
{
	doctest( 
	dt_split
	,[ 
		[ "''this is it''", dt_split("this is it"), ["this","is","it"]]
	 ,	[ "''this is it'',''i''", dt_split("this is it","i"), ["th","s ","s ","t"]]
	 ,	[ "''this is it'',''t''", dt_split("this is it","t"), ["","his is i",""]]
	 ,	[ "''this is it'',''is''", dt_split("this is it","is"), ["th"," "," it"]]
	 ,	[ "''this is it'','',''", dt_split("this is it",","), ["this is it"]]
	 ,	[ "''Scadex'',''Scadex''", dt_split("Scadex","Scadex"), ["",""]]
	], ops
	);
}

//========================================================
dt_type=[ "dt_type", "x", "str", "dt_type, Inspect",
" Given x, return type of x as a string.
"
];

module dt_type_test( ops )
{
	doctest
	(
	dt_type,[  ["[2,3]", dt_type([2,3]), "arr" ]
    	 , [ "[]", dt_type([]), "arr" ]
	 , [ "-4", dt_type(-4), "int"]
	 , [ "0", dt_type( 0 ), "int"]
	 , [ "0.3", dt_type( 0.3 ), "float"]
	 , [ "-0.3", dt_type( -0.3 ), "float"]
	 , [ "''a''",dt_type("a"), "str"]
	 , [ "''10''", dt_type("10"), "str"]
	 , [ "true", dt_type(true), "bool"]
	 , [ "false", dt_type(false), "bool"]
	 , [ "undef", dt_type(undef), undef]
    	 ],ops
	);
}


//========================================================
//========================================================
//========================================================
doctest=["doctest", "doc,recs=[],ops=[],scope=[]","n/a","Doc,Test"
," Doc and test tool for OpenSCAD functions. 
;; 
;; <u>doc</u>: array of 5 strings:
;;
;;   [ func_name, arg_name(s), return_type, tags, doc_content ]
;;
;;   e.g, [''addz'',''p,z'',''array'',''Array'',''doc...'']
;;
;; <u>recs</u>: array of test cases, each is:
;;
;;   [ arg_string, result, wanted, test_option ]
;;
;;   e.g, [ ''[3,4],2'', addz([3,4],2), [3,4,2] ]
;;
;;   where test_option is an optional array:
;;
;;     [ ''rem'', ..., ''asstr'', true|false ]  
;; 
;; <u>ops</u>: options for all test cases in this call:
;;
;;   [ ''mode'', 13      // Chk doctest_help()
;;   , ''asstr'', false  // test all as string
;;   , ''prefix'', ''|'' // prefix for each line
;;   ]
;; 
;; <u>scope</u>: scope used for test cases. Useful especially when
;;    the var value is long and need to be used multiple times.
;;    It is in a hash format, e.g., [''point'',[-1,2,3]]
"];

module doctest_tool_test(mode=13)
{
//	Demo the tests on whole bunch of functions, with added header to show
//	the mode list for easier understanding of differences between modes.
//	The header/footer are not needed in actual tests.


	//======================================
	//
	// Header (not needed for actual tests)
	//
	//======================================

	function hashkvs(h, _i_=0)=
	(
		!dt_isarr(h)? undef        // not a hash
		:_i_>len(h)-1? []       // end of search
			: concat( 
					 [[h[_i_],h[_i_+1]]]
				    , hashkvs(h, _i_=_i_+2)
					)
	);

	function _getModeStrings(mode_kvs, mode, _i_=0)=
	(
		_i_<len(mode_kvs)?
			concat( [mode==mode_kvs[_i_][0]?
						(str(" @ ", mode_kvs[_i_][0]
							,": ", mode_kvs[_i_][1] ))
						:_gray(str("   ", mode_kvs[_i_][0]
							,  ": ", mode_kvs[_i_][1]  ))
					]
				 , _getModeStrings(mode_kvs, mode, _i_=_i_+1) 
                   )
			:[]
	);

	echo(_pre(str(
	_BR,  _color(dt_multi("#",78),"brown")
	,_h3(dt_s("doctest_tool_test( mode={_} ) starts",[ mode ]), "color:brown;margin-top:0px;margin-bottom:0px")
	//,_s("mode={_}: {_}",[ mode, hash(DT_MODES,mode) ])
	,dt_multi("-",78)
	,"<br/>"
	,dt_join( _getModeStrings( hashkvs(DT_MODES), mode=mode), "<br/>")
	,_BR,  _color(dt_multi("-",78),"brown")
	)));

	ops=["mode",mode];

	//======================================
	//
	// tests of multiple functions
	//
	//======================================

	doctest(doctest, ops=ops);

	dt_begwith_test( ops );
	dt_countStr_test( ops );
	dt_countType_test( ops );
	echo__test( ops );
	dt_endwith_test( ops );

	dt_fmt_test( ops );
	dt_get_test( ops );
	dt_hash_test( ops );

	dt_haskey_test( ops );
	dt_index_test( ops );
	dt_inrange_test( ops );

	dt_isarr_test( ops );
	dt_isequal_test( ops );
	dt_isint_test( ops );

	dt_isnum_test( ops );
	dt_isstr_test( ops );
	dt_join_test( ops );

	dt_keys_test( ops );
	dt_multi_test( ops );
	dt_replace_test( ops );

	dt_s_test( ops );
	dt_slice_test( ops );
	dt_split_test( ops );
	dt_type_test( ops );

	//======================================
	//
	// footer (not needed for actual tests)
	//
	//======================================
	echo(_pre(str(
		 _color(dt_multi("-",78),"brown")
		,_h3(dt_s("doctest_tool_test( mode={_} ) ends",[mode])
				, "color:brown;margin-top:0px;margin-bottom:0px")
		,  _color(dt_multi("#",78),"brown")
		)));
}


doctest_ver=[
["20140720_1", "Split from openscad_doctest_20140719_1.scad." ]
,["20140719_1", "doctest_help() and help_test done." ]
,["20140718_2", "help_text() almost finished." ]
,["20140718_1", "All tests go well." ]
,["20140717_2", "Rename to openscad_doctest.scad." ]
,["20140717_1", "Rename from scadex_doctest to scad_doctest, in order to migrate to a stand-alone doctest lib (no need for scadex.scad)." ]
,["20140708_2", "in scadex_dev.scad: rename doctest to doctest_old, doctest2 to doctest; MOVE this new doctest to a new file scadex_doctest.scad (this file)." ]
];


DOCTEST_VERSION = doctest_ver[0][0];

echo( _color(str("<code>||.........  <b>openscad_doctest version: "
	, DOCTEST_VERSION
	, "</b>  .........||</code>"
	),"brown"));

