# DelphiDX12
DirectX 12 Headers for Delphi and FPC
based on SDK 10.0.17763.0 SDK Oct 2018

The files are available under Apache License, Version 2.0.
You may obtain a copy of the License at
       http://www.apache.org/licenses/LICENSE-2.0

So this license should be okay also for commerical projects.
	   
This header translation is  NOT based on the JSB headers

  The HelperFiles are translated to be used with Delphi/FPC. Therefore there are
  more functions then in the original header file since Pascal syntax doesn't
  support default values of a function as a result of another function.

  But the use should be straight forward. Looks to the examples if any
  questions.

  WHEN you should use this headers: if you plan a new software release and
     you are not based on much older source code.
  WHEN you should NOT use this heades: when you have existing source code
    based on the JSB headers and don't want to change a LOT.

  You MUST use this if you work with FPC. The JSB Headers are buggy for FPC
  cause interfaces not based on IUnknown are solved with abstract classes
  in Delphi, which will not work on FPC. FPC has the CORBA Interface
  compiler switch.
  Also FPC supports BITPACKED RECORDS.

  The inline functions of the interfaces are
  translated to FPC in some headers (still some work todo).
  FPC supports now helper classes for interface.
  In Delphi you miss this feature. Maybe someday...
