unit CContainer;

{$mode ObjFPC}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}

interface

uses
    Classes, SysUtils;

type

    { TCPair }


    generic TCPair<T1, T2> = class
    type
        PT1 = ^T1;
        PT2 = ^T2;
        PCPair = ^TCPair;
    protected
    FFirst: PT1;
    FSecond :PT2;


    public
       // property First: T1 read GetFirst;
//        property Second: T2 read GetSecond;
    public
        procedure Swap(A: TCPair);
        constructor Create; overload;
        constructor Create(a: T1; b: T2); overload;
        constructor Create(a: PT1; b: PT2); overload;
        constructor Create(a: TCPair);
        procedure Assign(x: PCPair); overload;
        procedure Assign(x: TCPair); overload;

    end;

    // implementation of std::set red-black tree
    // sorting is done by compare function
    generic TCSet<T, C, A> = class
        key_type: T;
        value_type: T;
        key_compare: C;
        value_compare: C;
        alloator_type: A;


    end;

implementation

{ TCPair }

procedure TCPair.Swap(A: TCPair);
var
    temp1: T1;
    temp2: T2;
begin
    temp1 := self.fFirst;
    self.FFirst := A.FFirst;
    A.FFirst := temp1;
    temp2 := self.FSecond;
    self.FSecond := A.FSecond;
    A.FSecond := temp2;
end;



constructor TCPair.Create;
begin

end;



constructor TCPair.Create(a: T1; b: T2);
begin
    FFirst^ := a;
    FSecond^ := b;
end;



constructor TCPair.Create(a: PT1; b: PT2);
begin
    FFirst := a;
    FSecond := b;
end;



constructor TCPair.Create(a: TCPair);
begin
    self.FFirst^ := a.FFirst^;
    self.FSecond^ := a.FSecond^;
end;

procedure TCPair.Assign(x: PCPair);
begin
//  self.First:=;
end;

procedure TCPair.Assign(x: TCPair);
begin

end;

end.
