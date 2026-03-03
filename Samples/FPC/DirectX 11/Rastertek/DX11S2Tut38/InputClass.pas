unit InputClass;

{$mode delphiunicode}{$H+}

interface

uses
    Classes, SysUtils, Windows;

type

    { TInputClass }

    TInputClass = class(TObject)
    private
        m_keys: array[0..255] of boolean;
    public
        constructor Create;
        destructor Destroy; override;
        procedure Initialize();
        procedure KeyDown(input: UINT);
        procedure KeyUp(input: UINT);
        function IsKeyDown(key: UINT): boolean;
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
var
    i: integer;
begin
    // Initialize all the keys to being released and not pressed.
    for i := 0 to 255 do
        m_keys[i] := False;
end;



procedure TInputClass.KeyDown(input: UINT);
begin
    // If a key is pressed then save that state in the key array.
    m_keys[input] := True;
end;



procedure TInputClass.KeyUp(input: UINT);
begin
    // If a key is released then clear that state in the key array.
    m_keys[input] := False;
end;



function TInputClass.IsKeyDown(key: UINT): boolean;
begin
    // Return what state the key is in (pressed/not pressed).
    Result := m_keys[key];
end;

end.
