{ **************************************************************************
  FreePascal/Delphi DirectX 12 Header Files
  
  Copyright 2013-2021 Norbert Sonnleitner

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
   SOFTWARE.
  ************************************************************************** }

{ **************************************************************************
  Additional Copyright (C) for this modul:

  Copyright (c) Microsoft Corporation.  All rights reserved.

  This unit consists of the following header files
  File name: DCOMPTypes.h
			 
  Header version: 10.0.19041.0

  ************************************************************************** }
unit DX12.DCompTypes;

interface

uses
    Windows, Classes, SysUtils,
    DX12.DXGI, // for DXGI_RATIONAL
    DX12.DXGI1_5; // for DXGI_ALPHA_MODE, DXGI_HDR_METADATA_TYPE


// Composition object specific access flags

const
    COMPOSITIONOBJECT_READ = $0001;
    COMPOSITIONOBJECT_WRITE = $0002;
    COMPOSITIONOBJECT_ALL_ACCESS = (COMPOSITIONOBJECT_READ or COMPOSITIONOBJECT_WRITE);

type
    // DirectComposition types

    TDCOMPOSITION_BITMAP_INTERPOLATION_MODE = (
        DCOMPOSITION_BITMAP_INTERPOLATION_MODE_NEAREST_NEIGHBOR = 0,
        DCOMPOSITION_BITMAP_INTERPOLATION_MODE_LINEAR = 1,
        DCOMPOSITION_BITMAP_INTERPOLATION_MODE_INHERIT = $ffffffff
        );

    TDCOMPOSITION_BORDER_MODE = (
        DCOMPOSITION_BORDER_MODE_SOFT = 0,
        DCOMPOSITION_BORDER_MODE_HARD = 1,
        DCOMPOSITION_BORDER_MODE_INHERIT = $ffffffff
        );

    TDCOMPOSITION_COMPOSITE_MODE = (
        DCOMPOSITION_COMPOSITE_MODE_SOURCE_OVER = 0,
        DCOMPOSITION_COMPOSITE_MODE_DESTINATION_INVERT = 1,
        DCOMPOSITION_COMPOSITE_MODE_MIN_BLEND = 2,
        DCOMPOSITION_COMPOSITE_MODE_INHERIT = $ffffffff
        );

    
    TDCOMPOSITION_BACKFACE_VISIBILITY = (
        DCOMPOSITION_BACKFACE_VISIBILITY_VISIBLE = 0,
        DCOMPOSITION_BACKFACE_VISIBILITY_HIDDEN = 1,
        DCOMPOSITION_BACKFACE_VISIBILITY_INHERIT = $ffffffff
        );

    TDCOMPOSITION_OPACITY_MODE = (
        DCOMPOSITION_OPACITY_MODE_LAYER = 0,
        DCOMPOSITION_OPACITY_MODE_MULTIPLY = 1,
        DCOMPOSITION_OPACITY_MODE_INHERIT = $ffffffff
        );

    TDCOMPOSITION_DEPTH_MODE = (
        DCOMPOSITION_DEPTH_MODE_TREE = 0,
        DCOMPOSITION_DEPTH_MODE_SPATIAL = 1,
        DCOMPOSITION_DEPTH_MODE_SORTED = 3,
        DCOMPOSITION_DEPTH_MODE_INHERIT = $ffffffff
        );
    

    TDCOMPOSITION_FRAME_STATISTICS = record
        lastFrameTime: LARGE_INTEGER;
        currentCompositionRate: TDXGI_RATIONAL;
        currentTime: LARGE_INTEGER;
        timeFrequency: LARGE_INTEGER;
        nextEstimatedFrameTime: LARGE_INTEGER;
    end;
    PDCOMPOSITION_FRAME_STATISTICS = ^TDCOMPOSITION_FRAME_STATISTICS;


implementation

end.
 
