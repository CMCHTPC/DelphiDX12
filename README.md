# DelphiDX12
DirectX 12 Headers for (Delphi and) FPC
based on SDK 10.0.26100.7705 February 2026 and DirectX SDK 619 February 2026

The files are available under Apache License, Version 2.0.
You may obtain a copy of the License at
       http://www.apache.org/licenses/LICENSE-2.0

So this license should be okay also for commerical projects.
	   
The present files are a complete retranslation of the DirectX header files. Since the first release over 10 years ago, Free Pascal has gained a large number of additional features. At this point, a BIG THANK YOU to the developers and the community of Free Pascal.

For this reason, I decided to retranslate the headers and take advantage of the new possibilities. Furthermore, the headers are now (more) SAL-oriented. Wherever possible, the calling conventions have been preserved and the original comments have also been retained.

The old files can be found in the “Historic” folder.

For older DirectX 11 or DirectX 10 applications, switching is not necessarily required. The JSB headers are still available on the internet as well. However, anyone who wants to develop with DirectX 12 is strongly advised to use the new header files.

The DirectX 12 ToolKit (also known as DX12TK) has already been largely translated, although not yet completely. Further updates and tools will follow.

A word to Delphi users: the new headers have not been tested under Delphi. I will address this at a later point. My main development environment at the moment is CodeTyphon and therefore the header files are only tested under Free Pascal.

I welcome bug reports and suggestions for extensions and improvements.

Have fun and happy DirectX coding!

P.S.: The DirectX 12 multithreading sample runs about 19% faster on my PC than the original C++ version from Microsoft. 
