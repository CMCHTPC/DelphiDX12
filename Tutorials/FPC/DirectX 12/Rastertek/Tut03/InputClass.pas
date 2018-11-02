unit InputClass;

{$mode delphi}

interface

uses
    Windows, Classes, SysUtils;

type

    { TInputClass }

    TInputClass = class(TObject)
    private
        Fkeys: array[0..255] of boolean;
    public

        constructor Create;
        destructor Destroy; override;

        procedure Initialize();

        procedure KeyDown(input: uint);
        procedure KeyUp(input: uint);

        function IsKeyDown(key: uint): boolean;
    end;

implementation

{ TInputClass }

constructor TInputClass.Create;
begin

end;



destructor TInputClass.Destroy;
begin
    inherited Destroy;
end;



procedure TInputClass.Initialize();
begin
    ZeroMemory(@Fkeys, SizeOf(Fkeys));
end;



procedure TInputClass.KeyDown(input: uint);
begin
    // If a key is pressed then save that state in the key array.
    Fkeys[input] := True;
end;



procedure TInputClass.KeyUp(input: uint);
begin
    // If a key is released then clear that state in the key array.
    Fkeys[input] := False;
end;



function TInputClass.IsKeyDown(key: uint): boolean;
begin
    // Return what state the key is in (pressed/not pressed).
    Result := Fkeys[key];
end;

end.
