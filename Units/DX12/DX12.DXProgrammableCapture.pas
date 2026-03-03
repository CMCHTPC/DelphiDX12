{ **************************************************************************
    FreePascal/Delphi DirectX 12 Header Files

    Copyright (C) 2013-2025 Norbert Sonnleitner

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

   Copyright (C) Microsoft Corporation.
   Licensed under the MIT license

   This unit consists of the following header files
   File name:  DXProgrammableCapture.h
   Header version: 10.0.26100.6584

  ************************************************************************** }
unit DX12.DXProgrammableCapture;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils;

    {$Z4}

const
    IID_IDXGraphicsAnalysis: TGUID = '{9f251514-9d4d-4902-9d60-18988ab7d4b5}';

type

    // Applications use this interface to denote the beginning and ending of a
    // "frame" of captured DXGI/D3D10+ commands for examination within a debugging
    // tool such as Visual Studio 2013. Absent such calls, a frame is defined by
    // Visual Studio as beginning and ending with the IDXGISwapChain*::Present* calls.

    //  To retrieve a pointer to this interface, call

    //     ComPtr<IDXGraphicsAnalysis> graphicsAnalysis;
    //     DXGIGetDebugInterface1(0, IID_PPV_ARGS(&graphicsAnalysis));

    // The function will only succeed when the application is being run under
    // "graphics analysis" in Visual Studio (or other similar tools), so applications
    // must be sure to handle failure from DXGIGetDebugInterface1 gracefully.

    // Further note that DXGIGetDebugInterface1 is tagged as a development-only capability,
    // which implies that linking to this function will cause the application to fail
    // Windows store certification. Consequently, it is recommended that usage of that
    // function be compiled only for pre-release code.

    IDXGraphicsAnalysis = interface(IUnknown)
        ['{9f251514-9d4d-4902-9d60-18988ab7d4b5}']
        procedure BeginCapture(); stdcall;
        procedure EndCapture(); stdcall;
    end;


implementation

end.
