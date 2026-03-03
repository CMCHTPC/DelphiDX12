{ **************************************************************************
    FreePascal/Delphi std::vector implementation

    Copyright (C) 2026 Norbert Sonnleitner

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
   This unit implements the behaviour of the C/C++ std::vector

   Only use with basic data types or records that manage their own resources
   (managment operators).
   For pointer types, memory leaks may occur because the pointed-to objects
   are not destroyed automatically.

  ************************************************************************** }
unit CStdVector;

{$IFDEF FPC}
{$mode ObjFPC}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$ENDIF}

interface

uses
    Classes, SysUtils;

type


    { TCStdVector }
    generic TCStdVector<T> = record
    type
        PT = ^T;
        TValueType = T;
    private
        FArray: array of T;
        FElementCount: size_t;
        FCapacity: size_t;
        function GetBack: T;
        function GetFront: T;
        function GetItem(idx: size_t): T;
        function GetPtrItem(idx: size_t): PT;
        procedure SetItem(idx: size_t; AValue: T);
        procedure SetPtrItem(idx: size_t; AValue: PT);

        class operator Initialize(var aRec: TCStdVector);
        class operator Finalize(var aRec: TCStdVector);
    public
        // access specified element
        property Item[idx: size_t]: T read GetItem write SetItem;
        property PtrItem[idx: size_t]: PT read GetPtrItem write SetPtrItem;

        // access the first element
        property Front: T read GetFront;
        // access the last element
        property back: T read GetBack;

    public
        // adds an element to the end
        procedure push_back(Value: T);
        // removes the last element
        procedure pop_back(out Value: T);
        // changes the number of elements stored
        procedure resize(Count: size_t); overload;
        procedure resize(Count: size_t; Value: T); overload;
        // clears the contents
        procedure Clear;
        //  access specified element with bounds checking
        function At(pos: size_t): T;
        // checks whether the container is empty
        function Empty: boolean;
        // returns the number of elements
        function Size: size_T;
        // returns the maximum possible number of elements
        function max_size: size_T;
        // reserves storage
        procedure reserve(new_cap: size_T);
        // returns the number of elements that can be held in currently allocated storage
        function capacity: size_T;
        // direct access to the underlying contiguous storage
        function Data(): PT;
        // erases elements
        procedure Erase(pos: size_T);
        procedure Erase(First, last: size_T);
        procedure Insert(pos: size_t; value:T);
    end;


implementation


{ TCStdVector }

function TCStdVector.GetItem(idx: size_t): T;
begin
    Result := FArray[idx];
end;



function TCStdVector.Data: PT;
begin
    Result := @FArray[0];
end;



procedure TCStdVector.Erase(pos: size_T);
var
    i: size_T;
begin
    for i := pos to FElementCount - 2 do
    begin
        FArray[i] := FArray[i + 1];
    end;
    Dec(FElementCount);
end;



procedure TCStdVector.Erase(First, last: size_T);
var
    i: size_T;
    n: size_T;
begin
    n := (last - First);
    for i := First to FElementCount - n - 2 do
    begin
        FArray[i] := FArray[i + 1 + n];
    end;
    Dec(FElementCount, n + 1);
end;

procedure TCStdVector.Insert(pos: size_t; value: T);
begin
     System.Insert(value,FArray,pos);
end;



function TCStdVector.GetBack: T;
begin
    if FElementCount = 0 then
        Result := T(nil^)
    else
        Result := FArray[FElementCount - 1];
end;



function TCStdVector.GetFront: T;
begin
    if FElementCount = 0 then
        Result := T(nil^)
    else
        Result := FArray[0];
end;



function TCStdVector.GetPtrItem(idx: size_t): PT;
begin
    Result := @FArray[idx];
end;



procedure TCStdVector.SetItem(idx: size_t; AValue: T);
begin
    FArray[idx] := AValue;
end;



procedure TCStdVector.SetPtrItem(idx: size_t; AValue: PT);
begin
    FArray[idx] := AValue^;
end;



class operator TCStdVector.Initialize(var aRec: TCStdVector);
begin
    aRec.FElementCount := 0;
    aRec.FCapacity := 1;
    SetLength(aRec.FArray, aRec.FCapacity);
end;



class operator TCStdVector.Finalize(var aRec: TCStdVector);
begin
    SetLength(aRec.FArray, 0);
end;



procedure TCStdVector.push_back(Value: T);
var
    i: integer;
begin
    if ((FElementCount + 1) > FCapacity) then
    begin
        FCapacity := FCapacity * 2;
        SetLength(FArray, FCapacity);
    end;
    FArray[FElementCount] := Value;
    Inc(FElementCount);
end;



procedure TCStdVector.pop_back(out Value: T);
begin
    if FElementCount = 0 then
    begin
        Value := T(nil^);
        Exit;
    end;
    Dec(FElementCount);
    Value := FArray[FElementCount];
end;



procedure TCStdVector.resize(Count: size_t);
var
    n: integer;
    i: integer;
begin
    while Count > FCapacity do
    begin
        FCapacity := FCapacity * 2;
        SetLength(FArray, FCapacity);
    end;
    FElementCount := Count;
end;



procedure TCStdVector.resize(Count: size_t; Value: T);
var
    lOldCount: size_t;
    i: size_t;
begin
    lOldCount := FElementCount;
    while Count > FCapacity do
    begin
        FCapacity := FCapacity * 2;
        SetLength(FArray, FCapacity);
    end;
    FElementCount := Count;
    for i := lOldCount to FElementCount - 1 do
    begin
        FArray[i] := Value;
    end;
end;



procedure TCStdVector.Clear;
begin
    FillByte(FArray[0], FElementCount * SizeOf(T), 0);
    FElementCount := 0;
end;



function TCStdVector.At(pos: size_t): T;
begin
    if (pos < 0) or (pos >= FElementCount) then
        raise Exception.Create('std::out_of_range');
    Result := FArray[pos];
end;



function TCStdVector.Empty: boolean;
begin
    Result := (FElementCount = 0);
end;



function TCStdVector.Size: size_T;
begin
    Result := FElementCount;
end;



function TCStdVector.max_size: size_T;
begin
    Result := size_T(-1);
end;



procedure TCStdVector.reserve(new_cap: size_T);
begin
    if new_cap <= FCapacity then
        Exit;
    FCapacity := new_cap;
    SetLength(FArray, FCapacity);
end;



function TCStdVector.capacity: size_T;
begin
    Result := FCapacity;
end;


end.
