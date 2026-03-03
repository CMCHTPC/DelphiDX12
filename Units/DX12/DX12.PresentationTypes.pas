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

   This unit consists of the following header files
   File name: PresentationTypes.h
   Header version: 10.0.26100.6584

  ************************************************************************** }

unit DX12.PresentationTypes;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils;

    {$Z4}

type

    TSystemInterruptTime = record
        Value: uint64;
    end;
    PSystemInterruptTime = ^TSystemInterruptTime;


    TPresentationTransform = record
        M11: single;
        M12: single;
        M21: single;
        M22: single;
        M31: single;
        M32: single;
    end;
    PPresentationTransform = ^TPresentationTransform;


    TCompositionFrameId = uint64;
    PCompositionFrameId = ^TCompositionFrameId;

    TPresentStatisticsKind = (
        PresentStatisticsKind_PresentStatus = 1,
        PresentStatisticsKind_CompositionFrame = 2,
        PresentStatisticsKind_IndependentFlipFrame = 3);

    PPresentStatisticsKind = ^TPresentStatisticsKind;


implementation

end.
