unit CStdList;


{$IFDEF FPC}
{$mode ObjFPC}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$ENDIF}


interface

uses
    Classes, SysUtils;

type

    { TCStdList }

    generic TCStdList<T> = record
    type
        PT = ^T;
        PListNode = ^TListNode;

        TListNode = record
            Prev: PListNode;
            Next: PListNode;
            Value: T; // templated value
        end;
    private
        FHead: PListNode;
        FTail: PListNode;
        FCount: SizeInt;
    private
        class operator Initialize(var aRec: TCStdList);
        class operator Finalize(var aRec: TCStdList);
    public
          // clears the contents
          procedure clear();
          // adds an element to the end
          procedure push_back(value: T);
          // removes the last element
          procedure pop_back();
          // inserts an element to the beginning
          procedure push_front(value: T);
          // removes the first element
          procedure pop_front();
          // access the first element
          function front():PT;
          // access the last element
          function back():PT;
    end;

implementation

{ TCStdList }

class operator TCStdList.Initialize(var aRec: TCStdList);
begin
    aRec.FHead := nil;
    aRec.FTail := nil;
    aRec.FCount := 0;
end;



class operator TCStdList.Finalize(var aRec: TCStdList);
begin

end;

procedure TCStdList.clear();
begin

end;

procedure TCStdList.push_back(value: T);
begin

end;

procedure TCStdList.pop_back();
begin

end;

procedure TCStdList.push_front(value: T);
begin

end;

procedure TCStdList.pop_front();
begin

end;

function TCStdList.front(): PT;
begin

end;

function TCStdList.back(): PT;
begin

end;

end.
