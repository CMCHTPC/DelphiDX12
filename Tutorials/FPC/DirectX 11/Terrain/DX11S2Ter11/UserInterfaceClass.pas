unit UserInterfaceClass;

interface

uses
    Classes, SysUtils, Windows,
    DX12.D3D11,
    DX12.DXGI,
    DX12.D3DCommon,
    DirectX.Math,
    D3DClass,
    ShaderManagerClass,
    FontClass,
    TextClass;

type

    { TUserInterfaceClass }

    TUserInterfaceClass = class(TObject)

    public
        constructor Create;
        destructor Destroy; override;

        function Initialize(Direct3D: TD3DClass; screenHeight, screenWidth: integer): HResult;
        procedure Shutdown();

        function Frame(deviceContext: ID3D11DeviceContext; fps: integer; posX, posY, posZ, rotX, rotY, rotZ: single): HResult;
        function Render(Direct3D: TD3DClass; ShaderManager: TShaderManagerClass;
            worldMatrix, viewMatrix, orthoMatrix: TXMMATRIX): HResult;

        function UpdateRenderCounts(deviceContext: ID3D11DeviceContext; renderCount, nodesDrawn, nodesCulled: integer): HResult;
    private
        function UpdateFpsString(deviceContext: ID3D11DeviceContext; fps: integer): Hresult;
        function UpdatePositionStrings(deviceContext: ID3D11DeviceContext; posX, posY, posZ, rotX, rotY, rotZ: single): HResult;

    private
        m_Font1: TFontClass;
        m_VideoStrings: array of TTextClass;
        m_FpsString: TTextClass;
        m_PositionStrings: array of TTextClass;
        m_previousFps: integer;
        m_previousPosition: array [0..5] of integer;
        m_RenderCountStrings: array of TTextClass;
    end;

implementation




constructor TUserInterfaceClass.Create;
begin

end;



destructor TUserInterfaceClass.Destroy;
begin
    inherited Destroy;
end;



function TUserInterfaceClass.Initialize(Direct3D: TD3DClass; screenHeight, screenWidth: integer): HResult;
var
(*    char videoCard[128];
    int videoMemory;
    char videoString[144];
    char memoryString[32];
    char tempString[16]; *)
    i: integer;
begin

    // Create the first font object.
    m_Font1 := TFontClass.Create;

    // Initialize the first font object.
    Result := m_Font1.Initialize(Direct3D.GetDevice(), Direct3D.GetDeviceContext(), '.\data\font\font01.txt',
        '.\data\font\font01.tga', 32.0, 3);
    if (Result <> S_OK) then Exit;


    // Create the text object for the fps string.
    m_FpsString := TTextClass.Create;

    // Initialize the fps text string.
    Result := m_FpsString.Initialize(Direct3D.GetDevice(), Direct3D.GetDeviceContext(), screenWidth, screenHeight,
        16, False, m_Font1, 'Fps: 0', 10, 50, 0.0, 1.0, 0.0);
    if (Result <> S_OK) then Exit;

    // Initial the previous frame fps.
    m_previousFps := -1;

    // Setup the video card strings.
(*    Direct3D.GetVideoCardInfo(videoCard, videoMemory);
    strcpy_s(videoString, "Video Card: ");
    strcat_s(videoString, videoCard);

    _itoa_s(videoMemory, tempString, 10);

    strcpy_s(memoryString, "Video Memory: ");
    strcat_s(memoryString, tempString);
    strcat_s(memoryString, " MB");  *)

    // Create the text objects for the video strings.
    SetLength(m_VideoStrings, 2);
    m_VideoStrings[0] := TTextClass.Create;
    m_VideoStrings[1] := TTextClass.Create;


    // Initialize the video text strings.
    Result := m_VideoStrings[0].Initialize(Direct3D.GetDevice(), Direct3D.GetDeviceContext(), screenWidth, screenHeight,
        256, False, m_Font1, 'Video Memory: ', 10, 10, 1.0, 1.0, 1.0);
    if (Result <> S_OK) then Exit;

    Result := m_VideoStrings[1].Initialize(Direct3D.GetDevice(), Direct3D.GetDeviceContext(), screenWidth, screenHeight,
        32, False, m_Font1, 'MB: ', 10, 30, 1.0, 1.0, 1.0);
    if (Result <> S_OK) then Exit;

    // Create the text objects for the position strings.
    SetLength(m_PositionStrings, 6);
    for i := 0 to 5 do
        m_PositionStrings[i] := TTextClass.Create;


    // Initialize the position text strings.
    Result := m_PositionStrings[0].Initialize(Direct3D.GetDevice(), Direct3D.GetDeviceContext(), screenWidth,
        screenHeight, 16, False, m_Font1, 'X: 0', 10, 310, 1.0, 1.0, 1.0);
    if (Result <> S_OK) then Exit;

    Result := m_PositionStrings[1].Initialize(Direct3D.GetDevice(), Direct3D.GetDeviceContext(), screenWidth,
        screenHeight, 16, False, m_Font1, 'Y: 0', 10, 330, 1.0, 1.0, 1.0);
    if (Result <> S_OK) then Exit;

    Result := m_PositionStrings[2].Initialize(Direct3D.GetDevice(), Direct3D.GetDeviceContext(), screenWidth,
        screenHeight, 16, False, m_Font1, 'Z: 0', 10, 350, 1.0, 1.0, 1.0);
    if (Result <> S_OK) then Exit;

    Result := m_PositionStrings[3].Initialize(Direct3D.GetDevice(), Direct3D.GetDeviceContext(), screenWidth,
        screenHeight, 16, False, m_Font1, 'rX: 0', 10, 370, 1.0, 1.0, 1.0);
    if (Result <> S_OK) then Exit;

    Result := m_PositionStrings[4].Initialize(Direct3D.GetDevice(), Direct3D.GetDeviceContext(), screenWidth,
        screenHeight, 16, False, m_Font1, 'rY: 0', 10, 390, 1.0, 1.0, 1.0);
    if (Result <> S_OK) then Exit;

    Result := m_PositionStrings[5].Initialize(Direct3D.GetDevice(), Direct3D.GetDeviceContext(), screenWidth,
        screenHeight, 16, False, m_Font1, 'rZ: 0', 10, 410, 1.0, 1.0, 1.0);
    if (Result <> S_OK) then Exit;

    // Initialize the previous frame position.
    for i := 0 to 5 do
    begin
        m_previousPosition[i] := -1;
    end;

    // Create the text objects for the render count strings.
    SetLength(m_RenderCountStrings, 3);

    // Initialize the render count strings.
    m_RenderCountStrings[0]:= TTextClass.Create;
    Result := m_RenderCountStrings[0].Initialize(Direct3D.GetDevice(), Direct3D.GetDeviceContext(), screenWidth,
        screenHeight, 32, False, m_Font1, 'Polys Drawn: 0', 10, 260, 1.0, 1.0, 1.0);
    if (Result <> S_OK) then Exit;

     m_RenderCountStrings[1]:= TTextClass.Create;
    Result := m_RenderCountStrings[1].Initialize(Direct3D.GetDevice(), Direct3D.GetDeviceContext(), screenWidth,
        screenHeight, 32, False, m_Font1, 'Cells Drawn: 0', 10, 280, 1.0, 1.0, 1.0);
    if (Result <> S_OK) then Exit;

     m_RenderCountStrings[2]:= TTextClass.Create;
    Result := m_RenderCountStrings[2].Initialize(Direct3D.GetDevice(), Direct3D.GetDeviceContext(), screenWidth,
        screenHeight, 32, False, m_Font1, 'Cells Culled: 0', 10, 300, 1.0, 1.0, 1.0);

end;



procedure TUserInterfaceClass.Shutdown();
var
    i: integer;
begin
    // Release the render count strings.
    for i := 0 to 2 do
    begin
        if m_RenderCountStrings[i] <> nil then
        begin
            m_RenderCountStrings[i].Shutdown();
            m_RenderCountStrings[i].Free;
            m_RenderCountStrings[i] := nil;
        end;
    end;
    SetLength(m_RenderCountStrings, 0);

    // Release the position text strings.
    for i := 0 to 5 do
    begin
        if m_PositionStrings[i] <> nil then
        begin
            m_PositionStrings[i].Shutdown();
            m_PositionStrings[i].Free;
            m_PositionStrings[i] := nil;
        end;
    end;
    SetLength(m_PositionStrings, 0);



    // Release the video card string.
    m_VideoStrings[0].Shutdown();
    m_VideoStrings[0].Free;
    m_VideoStrings[1].Shutdown();
    m_VideoStrings[1].Free;
    SetLength(m_VideoStrings, 0);



    // Release the fps text string.
    if (m_FpsString <> nil) then
    begin
        m_FpsString.Shutdown();
        m_FpsString.Free;
        m_FpsString := nil;
    end;

    // Release the font object.
    if (m_Font1 <> nil) then
    begin
        m_Font1.Shutdown();
        m_Font1.Free;
        m_Font1 := nil;
    end;

end;



function TUserInterfaceClass.Frame(deviceContext: ID3D11DeviceContext; fps: integer; posX, posY, posZ, rotX, rotY, rotZ: single): HResult;
begin

    // Update the fps string.
    Result := UpdateFpsString(deviceContext, fps);
    if (Result <> S_OK) then Exit;


    // Update the position strings.
    Result := UpdatePositionStrings(deviceContext, posX, posY, posZ, rotX, rotY, rotZ);

end;



function TUserInterfaceClass.Render(Direct3D: TD3DClass; ShaderManager: TShaderManagerClass;
    worldMatrix, viewMatrix, orthoMatrix: TXMMATRIX): HResult;
var
    i: integer;
begin

    // Turn off the Z buffer and enable alpha blending to begin 2D rendering.
    Direct3D.TurnZBufferOff();
    Direct3D.EnableAlphaBlending();

    // Render the fps string.
    m_FpsString.Render(Direct3D.GetDeviceContext(), ShaderManager, worldMatrix, viewMatrix, orthoMatrix, m_Font1.GetTexture());

    // Render the video card strings.
    m_VideoStrings[0].Render(Direct3D.GetDeviceContext(), ShaderManager, worldMatrix, viewMatrix, orthoMatrix, m_Font1.GetTexture());
    m_VideoStrings[1].Render(Direct3D.GetDeviceContext(), ShaderManager, worldMatrix, viewMatrix, orthoMatrix, m_Font1.GetTexture());

    // Render the position and rotation strings.
    for i := 0 to 5 do
    begin
        m_PositionStrings[i].Render(Direct3D.GetDeviceContext(), ShaderManager, worldMatrix, viewMatrix, orthoMatrix, m_Font1.GetTexture());
    end;

    // Render the render count strings.
    for i := 0 to 2 do
        m_RenderCountStrings[i].Render(Direct3D.GetDeviceContext(), ShaderManager, worldMatrix, viewMatrix, orthoMatrix, m_Font1.GetTexture());


    // Turn off alpha blending now that the text has been rendered.
    Direct3D.DisableAlphaBlending();

    // Turn the Z buffer back on now that the 2D rendering has completed.
    Direct3D.TurnZBufferOn();

    Result := S_OK;
end;



function TUserInterfaceClass.UpdateRenderCounts(deviceContext: ID3D11DeviceContext; renderCount, nodesDrawn, nodesCulled: integer): HResult;
begin
    // Update the sentence vertex buffer with the new string information.
    Result := m_RenderCountStrings[0].UpdateSentence(deviceContext, m_Font1, 'Polys Drawn: ' + IntToStr(renderCount), 10, 260, 1.0, 1.0, 1.0);
    if (Result <> S_OK) then Exit;

    // Update the sentence vertex buffer with the new string information.
    Result := m_RenderCountStrings[1].UpdateSentence(deviceContext, m_Font1, 'Cells Drawn: ' + IntToStr(nodesDrawn), 10, 280, 1.0, 1.0, 1.0);
    if (Result <> S_OK) then Exit;

    // Update the sentence vertex buffer with the new string information.
    Result := m_RenderCountStrings[2].UpdateSentence(deviceContext, m_Font1, 'Cells Culled: ' + IntToStr(nodesCulled), 10, 300, 1.0, 1.0, 1.0);
    if (Result <> S_OK) then Exit;
end;



function TUserInterfaceClass.UpdateFpsString(deviceContext: ID3D11DeviceContext; fps: integer): Hresult;
var
    (*char tempString[16];
    char finalString[16]; *)
    red, green, blue: single;
    finalstring: ansistring;
begin
    Result := S_OK;
    // Check if the fps from the previous frame was the same, if so don't need to update the text string.
    if (m_previousFps = fps) then Exit;


    // Store the fps for checking next frame.
    m_previousFps := fps;

    // Truncate the fps to below 100,000.
    if (fps > 99999) then
    begin
        fps := 99999;
    end;

    // Convert the fps integer to string format.
(*    _itoa_s(fps, tempString, 10);

    // Setup the fps string.
    strcpy_s(finalString, "Fps: ");
    strcat_s(finalString, tempString);     *)

    // If fps is 60 or above set the fps color to green.
    if (fps >= 60) then
    begin
        red := 0.0;
        green := 1.0;
        blue := 0.0;
    end;

    // If fps is below 60 set the fps color to yellow.
    if (fps < 60) then
    begin
        red := 1.0;
        green := 1.0;
        blue := 0.0;
    end;

    // If fps is below 30 set the fps color to red.
    if (fps < 30) then
    begin
        red := 1.0;
        green := 0.0;
        blue := 0.0;
    end;

    // Update the sentence vertex buffer with the new string information.
    Result := m_FpsString.UpdateSentence(deviceContext, m_Font1, finalString, 10, 50, red, green, blue);
end;



function TUserInterfaceClass.UpdatePositionStrings(deviceContext: ID3D11DeviceContext; posX, posY, posZ, rotX, rotY, rotZ: single): HResult;

var

    positionX, positionY, positionZ, rotationX, rotationY, rotationZ: integer;
    finalString: ansistring;
begin

    // Convert the float values to integers.
    positionX := trunc(posX);
    positionY := trunc(posY);
    positionZ := trunc(posZ);
    rotationX := trunc(rotX);
    rotationY := trunc(rotY);
    rotationZ := trunc(rotZ);

    // Update the position strings if the value has changed since the last frame.
    if (positionX <> m_previousPosition[0]) then
    begin
        m_previousPosition[0] := positionX;
        finalString := 'X: ' + IntToStr(positionX);
        Result := m_PositionStrings[0].UpdateSentence(deviceContext, m_Font1, finalString, 10, 100, 1.0, 1.0, 1.0);
        if (Result <> S_OK) then Exit;
    end;

    if (positionY <> m_previousPosition[1]) then
    begin
        m_previousPosition[1] := positionY;
        finalString := 'Y: ' + IntToStr(positionY);
        Result := m_PositionStrings[1].UpdateSentence(deviceContext, m_Font1, finalString, 10, 120, 1.0, 1.0, 1.0);
        if (Result <> S_OK) then Exit;
    end;

    if (positionZ <> m_previousPosition[2]) then
    begin
        m_previousPosition[2] := positionZ;
        finalString := 'Z: ' + IntToStr(positionZ);
        Result := m_PositionStrings[2].UpdateSentence(deviceContext, m_Font1, finalString, 10, 140, 1.0, 1.0, 1.0);
        if (Result <> S_OK) then Exit;
    end;

    if (rotationX <> m_previousPosition[3]) then
    begin
        m_previousPosition[3] := rotationX;
        finalString := 'rX: ' + IntToStr(rotationX);
        Result := m_PositionStrings[3].UpdateSentence(deviceContext, m_Font1, finalString, 10, 180, 1.0, 1.0, 1.0);
        if (Result <> S_OK) then Exit;
    end;

    if (rotationY <> m_previousPosition[4]) then
    begin
        m_previousPosition[4] := rotationY;
        finalString := 'rY: ' + IntToStr(rotationY);
        Result := m_PositionStrings[4].UpdateSentence(deviceContext, m_Font1, finalString, 10, 200, 1.0, 1.0, 1.0);
        if (Result <> S_OK) then Exit;
    end;

    if (rotationZ <> m_previousPosition[5]) then
    begin
        m_previousPosition[5] := rotationZ;
        finalString := 'Z: ' + IntToStr(rotationZ);
        Result := m_PositionStrings[5].UpdateSentence(deviceContext, m_Font1, finalString, 10, 220, 1.0, 1.0, 1.0);
        if (Result <> S_OK) then Exit;
    end;
    Result := S_OK;
end;


end.
