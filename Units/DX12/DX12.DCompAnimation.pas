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

   Copyright (c) Microsoft Corporation.  All rights reserved.
   this ALWAYS GENERATED file contains the definitions for the interfaces

   This unit consists of the following header files
   File name: dcompanimation.h
   Header version: 10.0.26100.6584

  ************************************************************************** }
unit DX12.DCompAnimation;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils;

    {$Z4}

const
    IID_IDCompositionAnimation: TGUID = '{CBFD91D9-51B2-45e4-B3DE-D19CCFB863C5}';

type
    (* Forward Declarations *)
    IDCompositionAnimation = interface;
    PIDCompositionAnimation = ^IDCompositionAnimation;

    IDCompositionAnimation = interface(IUnknown)
        ['{CBFD91D9-51B2-45e4-B3DE-D19CCFB863C5}']
        function Reset(): HRESULT; stdcall;

        function SetAbsoluteBeginTime(beginTime: LARGE_INTEGER): HRESULT; stdcall;

        function AddCubic(beginOffset: double; constantCoefficient: single; linearCoefficient: single; quadraticCoefficient: single; cubicCoefficient: single): HRESULT; stdcall;

        function AddSinusoidal(beginOffset: double; bias: single; amplitude: single; frequency: single; phase: single): HRESULT; stdcall;

        function AddRepeat(beginOffset: double; durationToRepeat: double): HRESULT; stdcall;

        function _End(endOffset: double; endValue: single): HRESULT; stdcall;

    end;


implementation

end.
