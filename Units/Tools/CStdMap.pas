unit CStdMap;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$ENDIF}

interface

uses
    Classes, SysUtils;

type

    { TCStdMap }

   { TIterator }

   TIterator<T1, T2> = record
        First: T1;
        second: T2;
        class operator Equal(l: TIterator<T1,T2>; r: TIterator<T1,T2>): boolean;
    end;

    TCStdMap<T1, T2> = record
    type
        TMapIterator = TIterator<T1, T2>;
        function Find(Item: T1): TMapIterator;
        function _End : TMapIterator;
    end;

implementation

{ TIterator }

class operator TIterator<T1, T2>.Equal(l: TIterator<T1, T2>; r: TIterator<T1, T2
  >): boolean;
begin
      // sresult:= (l.First = r.First) and (r.Second = r.Second);
end;

{ TCStdMap }

function TCStdMap<T1, T2>.Find(Item: T1): TMapIterator;
begin

end;

function TCStdMap<T1, T2>._End: TMapIterator;
begin

end;

end.
