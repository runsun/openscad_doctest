// OpenSCAD_DocTest: OpenSCAD documentation and unit testing library
// Copyright (C) 2014 Runsun Pan (run+sun (at) gmail.com) 
// Source: https://github.com/runsun/openscad_doctest
// 
// This library is licensed under the AGPL 3.0 described in
// http://www.gnu.org/licenses/agpl.txt
//
// This file, openscad_doctest.scad, is part of OpenSCAD_DocTest library
//.
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


// openscad_doctest.scad
//
// For a quick look, check out openscad_doctest_demo_1.scad 
// For details, check out openscad_doctest_help.scad 


DT_ZERO=1e-13;  	// used to chk a value that's supposed to be 0: abs(v)<DT_ZERO
DT_MODES=[		// doctest modes
 0, "No doc, no test, show function headers only."
,1, "No doc, no test, show all test cases as usage examples."
,2, "No doc. Do tests, but show only failed cases."
,3, "No doc. Do tests and show all test cases."
,10, "Show doc, no test."
,11, "Show doc, no test, show all test cases as usage examples."
,12, "Show doc, do tests, but show only the error cases."
,13, "Show doc, test and show all test cases."
];

// ========================================================
//
// Utilities functions needed for doctest. All are prefixed with dt_.
// Documentations/tests are in the file openscad_doctest_help.scad
//
// ========================================================
function dt_begwith(o,x)= x==""||x==[]?undef:dt_index(o,x)==0;
function dt_countStr(arr)= dt_countType(arr, "str") ;
function dt_countType(arr, typ, _i_=0)=
(
     _i_<len(arr)?
	 ( 
		typ=="num"?
		((dt_isnum(arr[_i_])?1:0)+dt_countType(arr,"num",_i_+1))
		:((dt_type(arr[_i_])==typ?1:0)+dt_countType(arr, typ, _i_+1)) 
	 )
	 :0
);
module dt_echo_(s, arr=undef)
{
	if(arr==undef){ echo(s); }
	else if (dt_isarr(arr)){
		echo( dt_s(s, arr));
	}else { echo( str(s, arr) ); }
}
function dt_endwith(o,x)= 
( 
	dt_isarr(o)? 
	  o[len(o)-1]==x
	  :dt_index(o,x)+len(x)==len(o)
);
function dt_fmt(x, s=_span("&quot;,&quot;", "color:purple") 
			, n=_span(",", "color:brown") 
			, a=_span(",", "color:navy") 
			, ud=_span(",", "color:brown") 
			//, level=2
			, fixedspace= true
		   )=
(
	x==undef? dt_replace(ud, ",", x) 
	:dt_isarr(x)? dt_replace(a, ",", dt_replace(str(x),"\"","&quot;")) 
	: dt_isstr(x)? dt_replace(s,",",fixedspace?dt_replace(str(x)," ", "&nbsp;"):str(x)) 
		:dt_isnum(x)||x==true||x==false?dt_replace(n,",",str(x))
				:x
);
function dt_get(o,i, iscycle=false)= 
( 
	iscycle? 
	( o[ i%len(o)<0?(len(o)+i%len(o)):i%len(o)] ) 
	: ( dt_inrange(o,i)?( o[i<0?(len(o)+i):i] ):undef )
);
function dt_hash(h,k, notfound=undef, if_v=undef, then_v=undef, else_v=undef, _i_=0)= 
(
	!dt_isarr(h)? notfound      // not a dt_hash
	:_i_>len(h)-1? notfound  // key not found
		: h[_i_]==k?        // key found
			 (_i_==len(h)-1?notfound  // value not found
				: (if_v==undef    
					? h[_i_+1]     // return v if if_v undefined
					: h[_i_+1]==if_v  // else, ask if v==if_v
						? then_v  	  // if yes, return if_v  
						:( else_v==undef    // else, ask if else_v defined
								?h[_i_+1]  // if no, return v
								:else_v)   // if yes, return else_v 
				  )	 
			)
			: dt_hash( h=h, k=k, notfound=notfound, if_v=if_v, then_v=then_v
				  , else_v=else_v, _i_=_i_+2)           
);


function dt_haskey(h,k,_i_=0)=
(
	dt_index(dt_keys(h),k)>=0
);

function dt_index(o,x, wrap=undef, _i_=0)= 
(
	x==""?-1: 
	(
		dt_type(o)=="arr"?			// array
		(	x==o[_i_]?
			_i_:( _i_<len(o)?
            dt_index(o,x,undef, _i_+1):-1 
		  	)
		):(						// string
			wrap==undef?
			(						
			_i_+len(x)>len(o)?
			-1: dt_slice( o, _i_, _i_+len(x))==x? 
				_i_: dt_index( o,x, undef, _i_+1)

			):( // has wrap like "{,}". Basically it just
				// replaces x with replace(wrap,",",x)
				// NOTE_20140514:
				//   mmmhhh ... why am I doing this? 
				//     dt_index("a{_b_}{_c_}","{_,_}","c") 
				//   could have been achieved with:
				//     dt_index("a{_b_}{_c_}", dt_replace("{,}",",","c") )
				//   but it does look longer

			_i_+len(x)>len(o)?
			-1: dt_slice( o, _i_, _i_+len(dt_replace(wrap,",",x)))
                      ==(dt_replace(wrap,",",x))? 
				_i_: dt_index( o,x, wrap, _i_+1)
			)
		)
	)
);

function dt_inrange(o,i)=
(
	/*
	len: 1 2 3 4 5
		 0 1 2 3 4   i>=0
   		-5-4-3-2-1   i <0    
	*/
	
	len(o)==0? false
	: !dt_isint(i)?false
		:i>=0? i < len(o)
	  		: abs(i) <= len(o)
);


function dt_isarr(x)=   dt_type(x)=="arr";
function dt_isequal(a,b)= abs(a-b)< DT_ZERO;
function dt_isint(x)=   dt_type(x)=="int";
function dt_isnum(x)=   dt_type(x)=="int" || dt_type(x)=="float";
function dt_isstr(x)=   dt_type(x)=="str";
function dt_join(arr, sp=",", _i_=0)= 
(
	_i_<len(arr)?
	str(
		arr[ _i_ ]
		, _i_<len(arr)-1?sp:""
		,dt_join(arr, sp, _i_+1)
	):""
); 

function dt_keys(h, _i_=0)=
(
	 _i_>=len(h)? []
	 :( concat( [h[_i_]]
	         , dt_keys( h, _i_+2) 
			 )
	 )
);

function dt_multi(x,n=2)=
(
	dt_isarr(x)?
	concat(x, n>1?dt_multi(x,n-1):[])
	:str(x, n>1?dt_multi(x,n-1):"")
);

function dt_replace(o,x,new="")=
( 
  dt_isarr(o)
  ? (dt_inrange(o,x)
	? concat( dt_slice(o, 0, x), [new], x==len(o)-1?[]:dt_slice(o,x+1)): o 
	)
  : (dt_index(o,x)<0? 
	  o :str( dt_slice(o,0, dt_index(o,x))
			, new 
			, (dt_index(o,x)==len(o)-len(x)?""
				:dt_replace( dt_slice(o, dt_index(o,x)+len(x)), x, new) )
		   )
    )
);

function dt_s(s,arr, sp="{_}", _i_=0)= 
( 
	dt_index(s,sp)>=0 && len(arr)>_i_ ?
		str( dt_slice(s,0, dt_index( s,sp))
			, arr[_i_] 
			,  dt_index(s,sp)+len(sp)==len(s)?
				"":(dt_s( dt_slice( s, dt_index(s,sp)+len(sp)), arr, sp, _i_+1))
		   ): s
);

function dt_slice(s,i,j=undef)= 
(
  !dt_inrange(s,i) || (j>0 && i>j) || (i<0 && j<i)? 
  undef
  :(
	dt_isstr(s)?(
	s==""?
	 "":	(i==j?
		 "": str(
				  dt_get(s,i)
				, ( (  i<0? 
				      (len(s)+i):i
                     )<(
				      j==undef ?
      			      len(s)
      			      : (j<0?len(s)+j:j)
                       )-1
			       )?
			       dt_slice(s,i+1, j)
			       :""
		   		)//str
		)//i==j
	):                       
	(s==[]?				// array
	 []:	( i==j?
		  []: concat(
				  	[dt_get(s,i)]
				  , ( ( i<0?(len(s)+i):i
                       )<
					  ( j==undef ?
      			           len(s)
      			           : (j<0?len(s)+j:j)
                       )-1
			         )?
			         dt_slice(s,i+1, j) : []
		   		   ) //concat
		 )//i==j
	)//s==[]
  ) // dt_inrange
  //:undef
);

function dt_split(s,sp=" ")=
(
	dt_index(s,sp)<0?
	[s]: concat(
		 [ dt_slice(s, 0, dt_index(s,sp))]
		   , dt_endwith(s,sp)?
			 "":dt_split( dt_slice(s, dt_index(s,sp)+len(sp)), sp ) 
		)
);

function dt_type(x)= 
(
	x==undef?undef:
	( abs(x)+1>abs(x)?
	  floor(x)==x?"int":"float"
	  : str(x)==x?
		"str"
		: str(x)=="false"||str(x)=="true"?"bool"
			:([0]==[0])? "arr":"unknown"
	)
);


//===========================================
//
// Console html tools 
//
//===========================================

_SP  = "&nbsp;";
_SP2 = "　";  // a 2-byte space 
_BR  = "<br/>"; 

function _tag(tagname, t="", s="", a="")=
(
	str( "<", tagname, a?" ":"", a
		, s==""?"":str(" style='", s, "'")
		, ">", t, "</", tagname, ">")
);

function _div (t, s="", a="")=_tag("div", t, s, a);
function _span(t, s="", a="")=_tag("span", t, s, a);
function _table(t, s="", a="")=_tag("table", t, s, a);
function _pre(t, s="font-family:ubuntu mono;margin-top:5px;margin-bottom:0px", a="")=_tag("pre", t, s, a);
function _code (t, s="", a="")=_tag("code", t, s, a);
function _tr   (t, s="", a="")=_tag("tr", t, s, a);
function _td   (t, s="", a="")=_tag("td", t, s, a);
function _b   (t, s="", a="")=_tag("b", t, s, a);
function _i   (t, s="", a="")=_tag("i", t, s, a);
function _u   (t, s="", a="")=_tag("u", t, s, a);
function _h1  (t, s="margin-top:0px;margin-bottom:0px", a="")= _tag("h1", t, s, a); 
function _h2  (t, s="margin-top:0px;margin-bottom:0px", a="")= _tag("h2", t, s, a); 
function _h3  (t, s="margin-top:0px;margin-bottom:0px", a="")= _tag("h3", t, s, a); 
function _h4  (t, s="margin-top:0px;margin-bottom:0px", a="")= _tag("h4", t, s, a); 

function _color(t,c) = _span(t, s=str("color:",c));
function _red  (t) = _span(t, s="color:red");
function _green(t) = _span(t, s="color:green");
function _blue (t) = _span(t, s="color:blue");
function _gray (t) = _span(t, s="color:gray");

function _tab(t,spaces=4)= dt_replace(t, dt_multi("&nbsp;",spaces)); // replace tab with spaces
function _cmt(s)= _span(s, "color:darkcyan");   // for comment

// Format the function/module argument
function _arg(s)= _span( s?str("<i>"
					,dt_replace(dt_replace(s,"''","&quot;"),"\"","&quot;")//"“"),"\"","“")
					,"</i>"):""
					, "color:#444444;font-family:ubuntu mono");


//========================================================
//========================================================
//========================================================


module doctest(doc,recs=[], ops=[], scope=[])
{
	//echo("doctest");


	//-----------------------------------
	//   setting
	//-----------------------------------


	ops= concat( ["scope", scope], ops==undef?[]:ops, 
	[
	  "mode", 13  
	, "asstr", false  // test them as string
	, "prefix", "|"   // prefix for each rec line
	, "linebr", ";;"  // the line break in doc
	]);
	function ops(k)=dt_hash(ops,k);

	fname = doc[0];  // function name  like "sum"
	args  = doc[1];  // argument string like "x,y"
	retn  = doc[2];  // return dt_type ("array", "string"...), "n/a" if module
	tags  = doc[3];  // like, "Array,Inspect"
	docdata= doc[4]; // New 7/7/14
	
	//echo("ops = ", ops);

	mode = ops("mode"); 
	
	prefix = ops("prefix");	
	docmode = floor(mode/10);  // 0: no doc
							// 1: show dow
							
	testmode= tags=="n/a"?0:(mode-floor(mode/10)*10);
			// 0 : no test, no show 
			// 1 : no test, show all test records as usage examples 
			// 2 : test, show only when error
			// 3 : test and show all test records

	is_show_doc= docmode>0;
	is_do_test = testmode > 1;
	is_show_header= true;      // always show header for now;
	is_module = retn=="n/a";


	//-----------------------------------
	//   header functions
	//-----------------------------------


	//echo( dt_replace(dt_replace(_b("bold"),"<","&lt;"),">","&gt;")); 

	function _dt_getHeader_fname(fails)=
	(	
		// Return the formatted function name. If fails>0,
		// format it with red. Note the underscore is replaced
		// w/ its 2-byte version so it is not too low to be 
		// seen when the header is underlined.

		_b( fails==0 ?  dt_replace(fname,"_","＿")
				:_red( dt_replace(fname,"_","＿")) 
		  )
	);


	function _dt_getHeader_args()=
	(	
		// get formatted args for the header.

 		_green( str( " ( ", _arg(args) , " )") )
	);


	function _dt_getHeader_testcount( testcount, fails)=
	(
		// get testcount/failed count (be called only when functions)
		 
		str( _blue("=")
		   , retn
		   ,	testcount==0 ? ""
			: dt_s( " ( tested:{_}{_} )"
				, [ testcount
				  , fails==0?"": _red(str( "/failed:",fails) )
 				  ]
			    )
		   )
	);	


	function _dt_getDocHeader(doc, testcount=0, fails=0)=
	(  	
		// Given doc = [ docname, argstring, return, tags, doclines ],
		// (where return="n/a" if doc is for a module), return doc header.

		// Note that when mode = 0 or 2, only header is shown,
		// so it'd be a one-liner. We 1) skip br; 2) do NOT underscore. 

		_u(str((mode==0||mode==2)?"</u>":"<br/>" // header is a one-liner
			  , _dt_getHeader_fname(fails)
			  , _dt_getHeader_args() 
		    , retn=="n/a"?"":_dt_getHeader_testcount( testcount, fails)
				  
	     ))
	); 



	//-----------------------------------
	//   doc functions
	//-----------------------------------


	function _doc_dt_getDocLinesString( lines , tags, _i_=0 )=
	(
		_i_>len(lines)-1?""
		:str(
			 _i_==0? prefix :""
			, dt_replace(lines[_i_], "''", "&quot;" )  // #2
				, "<br/>"
				, prefix 
			,  _doc_dt_getDocLinesString( lines, tags, _i_=_i_+1 )
			, _i_==len(lines)-1? str("<br/>", prefix, " <u>Tags:</u> ",tags):""
		)	
	
	); 

	docstring = is_show_doc?
				_doc_dt_getDocLinesString( dt_split(docdata,ops("linebr") ), tags )
				:"";

	
	//-----------------------------------
	//   test settings
	//-----------------------------------


	scope  = ops("scope");
	asstr  = ops("asstr");
	error_prefix= " got: ";
	error_suffix= _red(" #FAIL#");
	
	testcount= len(recs)-dt_countStr(recs); // Exclude comments


	//-----------------------------------
	//   test functions
	//-----------------------------------


	function _test_dt_getScopeLines( scope=scope, _i_=0 )=
	(
		// Return an array containing scope item pairs as strings
	 	// with formatting. For example,
		// 
		// You write this:
	 	//     ["s", "a_text" ,"t", [2,3,5]]
		//   
		// and this function give you this:
	 	// 	  [ "> s= \”a_text\""
		//     , "> t= [2, 3, 5]"   ] 
	 	_i_>=len(scope)-1?[]
	 	:concat(
	 			[ str( prefix, "> ", scope[_i_], "= ", dt_fmt(scope[_i_+1]), "; ")]
			   , _test_dt_getScopeLines( _i_=_i_+2 ) 
		)		
	);

	//-------------------------------------------------------
	function _test_dt_getInlineRem(rec)=   //==> ""|rem 
	(	
		// Given a test rec, like:
		// [["-3.8"],int("-3.8"),-3, [["rem","_Note this_"]]]
		// return the formatted rem (in this case, " // _Note this_" )
		dt_haskey(rec[3],"rem")? 
		_green(str( " // ", dt_hash(rec[3],"rem") ) ):""
	);


	//-------------------------------------------------------
	function _test_do_a_test(rec)=  //==> 0|failtext 
								// where failtext is something like "got: 1 #FAIL#"
	(
	     dt_isstr(rec)||
		(
			(dt_hash(ops,"asstr")            // test-level asstr
		     || dt_hash(rec[3],"asstr", false)// rec-level asstr
		  	) 
			? str(rec[1])==str(rec[2])
			: ( dt_isnum(rec[2] )
			    ? dt_isequal(rec[1],rec[2])  // when want is a number, we use dt_isequal()
			    : rec[1]==rec[2]
                )
		)?0
		:str( " got: "
		    , dt_fmt(rec[1])
		    , _red(" #FAIL#")
		    )
	
	);


	//-------------------------------------------------------
	function _test_do_tests(recs=recs, _i_=0)=  //==> [ 0,0,failtext, 0,0 ...]
	(	
		// Given recs, do the testing on all recs and return array containing
		// 0 (pass) or failtext for each rec ( like, [0,0,"...",0,"..."] )
		// Each rec: [ arg_arr, got, want, ops]
		//  where ops could have : "asstr" "rem"
		
		_i_>len(recs)-1?[]
		:concat
		  (	
			[ _test_do_a_test( rec= recs[_i_] )	],
			  _test_do_tests( recs=recs, _i_=_i_+1)			
		  )//concat		
	);



	//-------------------------------------------------------
	function _test_isshowtest(i)=
	(
		// testmode:
		// 0 : no test, no show 
		// 1 : no test, show all test records as usage examples 
		// 2 : test, show only when error
		// 3 : test and show all test records
		testmode==3 || testmode==1 || (is_do_test && results[i])
	);


	//-------------------------------------------------------
	function _test_dt_getRecLine( rec, i )=
	( 
		dt_isstr(rec)? str(prefix,dt_begwith(rec,"//")?_cmt(rec):rec)
		:str( prefix
			, "> " 
			, dt_replace(dt_hash( rec[3]  // New ops *funcwrap* added 6/6/2014
						, "funcwrap"     // ops ["funcwrap", "[{_}]"] converts "sum(2,3)" to "[sum(2,3)]"
						, notfound="{_}") // Chk the tests in angleBisectPt_test for this powerful tool 
					, "{_}"
			   , str(_color(fname,"darkblue"),_b("( "), _arg(rec[0]), _b(" )"))
                ) 
			, _color("= ","gray")
			, dt_fmt(rec[2])   //want
			, is_do_test&&asstr?" * ":""
			, _test_dt_getInlineRem(rec) //rem
			, results[i]?results[i]:"" //failtxt?failtxt:""
		) // str
	);


	//-------------------------------------------------------
	function _test_dt_getRecLines( recs=recs,  _i_=0 )=
	( 
		
		_i_>len(recs)-1?[]
		: concat(
				_test_isshowtest(_i_) 
				? [_test_dt_getRecLine( recs[_i_], _i_ ) ]
				: []
				
				, _test_dt_getRecLines(recs, _i_=_i_+1)
			    )
	);
	
	//-------------------------------------------------------
	//-------------------------------------------------------
	//-------------------------------------------------------
	
	results= is_do_test?_test_do_tests():[];

	_recs = mode==0? []
		: mode==1? concat( _test_dt_getScopeLines( ), _test_dt_getRecLines() )
		: mode==2? concat( _test_dt_getScopeLines( ), _test_dt_getRecLines() )
		: mode==3? concat( _test_dt_getScopeLines( ), _test_dt_getRecLines() )
		: mode==10? [] 
		: mode==11? concat( _test_dt_getScopeLines( ), _test_dt_getRecLines() )
		: mode==12? concat( _test_dt_getScopeLines( ), _test_dt_getRecLines() )
		          : concat( _test_dt_getScopeLines( ), _test_dt_getRecLines() );

	fails = dt_countStr(results);

	//-------------------------------------------------------


	h = _dt_getDocHeader(doc, testcount=is_do_test?testcount:0, fails=fails);

	//echo("recs = ", recs );

	testlines= _recs; 

	//echo("testlines: ", testlines);

	content = str(  
		!(mode==0||mode==2)?str(_BR,_code(dt_multi("-", 65))):""
		,is_show_header? h:""

		, mode==0? "" //_pre( dt_join( testlines, "<br/>") )
		: mode==1? _pre( dt_join( concat( str(prefix,"<u>Usage:</u>"),testlines), "<br/>") )
		: mode==2? (fails==0?""
                    :_pre(dt_join(concat( str(prefix, _red("<u>Failed Test(s):</u>")),
                                    //  _test_dt_getScopeLines()
                                     , testlines)
						  ,"<br/>"))
                    )  
		: mode==3? _pre( dt_join( concat( testcount==0?
									str(prefix,"<u>Usage:</u>")
								  	:str(prefix,"<u>Tests:</u>")
								  , testlines
								  ), "<br/>") )
		: mode==10? (docstring? _pre( docstring):"")
		: mode==11? _pre( dt_join( concat(docstring, prefix, str(prefix, "<u>Usage:</u>"), prefix,  testlines),"<br/>") )
		: mode==12? ( fails==0? _pre(  docstring )
				   :	_pre( dt_join( concat(docstring, prefix, str(prefix, _red("<u>Failed Test(s):</u>"), str("<br/>", prefix))
							, testlines),"<br/>")) 
				   )	
		// mode=13: 	
		: _pre( dt_join( concat(docstring
							, is_module?[]
							  : [prefix, testcount==0?
										str(prefix, "<u>Usage:</u>")
										:str(prefix, "<u>Tests:</u>")
							   , prefix], testlines),"<br/>")) 

				);
 	//echo("dt_type doc: ", dt_type(_doc));

	out = content;
	echo(out); //dt_join(out,"<br/>"));

} //doctest



doctest_ver=[
["20140720_1", "Remove all doc and tests of utility functions and help text to openscad_doctest_help.scad " ]
,["20140719_1", "doctest_help() and help_test done." ]
,["20140718_2", "help_text() almost finished." ]
,["20140718_1", "All tests go well." ]
,["20140717_2", "Rename to openscad_doctest.scad." ]
,["20140717_1", "Rename from scadex_doctest to scad_doctest, in order to migrate to a stand-alone doctest lib (no need for scadex.scad)." ]
,["20140708_2", "in scadex_dev.scad: rename doctest to doctest_old, doctest2 to doctest; MOVE this new doctest to a new file scadex_doctest.scad (this file)." ]
];


DOCTEST_VERSION = doctest_ver[0][0];

echo( _color(str("<code>||.........  <b>OpenSCAD_DocTest version: "
	, DOCTEST_VERSION
	, "</b>  .........||</code>"
	),"brown"));

