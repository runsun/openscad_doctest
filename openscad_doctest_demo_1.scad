// OpenSCAD_DocTest: OpenSCAD documentation and unit testing library
// Copyright (C) 2014 Runsun Pan (run+sun (at) gmail.com) 
//
// This library is licensed under the AGPL 3.0 described in
// http://www.gnu.org/licenses/agpl.txt
//
// This file, openscad_doctest_demo_1.scad, is part of OpenSCAD_DocTest library
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


// openscad_doctest_demo_1.scad
//
// Demo the basics of doctest with a function addz(). Run addz_test(mode)
// where mode is one of [0,1,2,3,10,11,12,13]. Or, Run addz_test_all_modes()
//
// More advanced settings and detailed documentaion can be found in 
// openscad_doectest_help.scad


include <openscad_doctest.scad>

//=============================================
// 1. Write the function

function addz(p,z)= [p.x, p.y, (len(p)==2?0:p.z)+z];



//=============================================
// 2. Write the doc
// 
//   [ func_name
//   , arg_name(s)
//   , return_type
//   , categories
//   , doc_content
//   ] 
//
// Use ;; for line break

addz=[ "addz", "p,z", "array",  "Array",
" Given a point (p) and a number (z), add z to p.z if p is
;; 3d, or append z to p if p is 2d.
"];



//=============================================
// 3. Write the tests
//
// doctest( doc,tests=[], ops=[], scope=[] )
//
// a test:  [ arg_string, result, expected, test_option ]

module addz_test( mode=13 )
{
   pt3=[3,4,5];   // define scope (optional)
	
   addz_tests=
   [
     [ "[3,4],2", addz([3,4],2), [3,4,2] ]  // test w/o scope       
   , [ "pt3,2", addz(pt3,2), [3,4,7] ]     // test using scope   
   , [ "pt3,2", addz(pt3,2), [3,4,5] ]     // WRONG ANSWER   
   ]; 
   doctest( addz            // doc 
		 , addz_tests      // tests
		 , ["mode",mode] // op mode
		 , ["pt3",pt3]   // add scope 
		 );  
}    


//=============================================
// 4. Call

addz_test(13);

module addz_test_all_modes()
{
	for(mode=[0,1,2,3,10,11,12,13]) 
	{ echo_(_green("NEXT: <b>addz_test</b>( mode= {_} )"),[mode] );
	  addz_test(mode);
	}
}

addz_test_all_modes();






