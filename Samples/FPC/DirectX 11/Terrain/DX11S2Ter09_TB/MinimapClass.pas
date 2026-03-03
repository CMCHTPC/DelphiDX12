unit MinimapClass;

{$mode Delphi}

interface

uses
    Classes, SysUtils, Windows,
    DX12.D3D11,
    BitmapClass,
    DirectX.Math,
    ShaderManagerClass;

type

    { TMiniMapClass }

    TMiniMapClass = class(TObject)

    public
        constructor Create;
        destructor Destroy; override;

        function Initialize(device: ID3D11Device; deviceContext: ID3D11DeviceContext; screenWidth, screenHeight: integer;
            terrainWidth, terrainHeight: single): HResult;
        procedure Shutdown();
        function Render(deviceContext: ID3D11DeviceContext; ShaderManager: TShaderManagerClass;
            worldMatrix, viewMatrix, orthoMatrix: TXMMATRIX): Hresult;

        procedure PositionUpdate(positionX, positionZ: single);

    private
        m_mapLocationX, m_mapLocationY, m_pointLocationX, m_pointLocationY: integer;
        m_mapSizeX, m_mapSizeY, m_terrainWidth, m_terrainHeight: single;
        m_MiniMapBitmap, m_PointBitmap: TBitmapClass;
    end;

implementation

{ TMiniMapClass }

constructor TMiniMapClass.Create;
begin

end;



destructor TMiniMapClass.Destroy;
begin
    inherited Destroy;
end;



function TMiniMapClass.Initialize(device: ID3D11Device; deviceContext: ID3D11DeviceContext; screenWidth, screenHeight: integer;
    terrainWidth, terrainHeight: single): HResult;
begin
    // Set the size of the mini-map  minus the borders.
    m_mapSizeX := 150.0;
    m_mapSizeY := 150.0;

    // Initialize the location of the mini-map on the screen.
    m_mapLocationX := trunc(screenWidth - m_mapSizeX - 10);
    m_mapLocationY := 10;

    // Store the terrain size.
    m_terrainWidth := terrainWidth;
    m_terrainHeight := terrainHeight;

    // Create the mini-map bitmap object.
    m_MiniMapBitmap := TBitmapClass.Create;


    // Initialize the mini-map bitmap object.
    Result := m_MiniMapBitmap.Initialize(device, deviceContext, screenWidth, screenHeight, '.\data\minimap\minimap.tga', 154, 154);
    if (Result <> S_OK) then Exit;

    // Create the point bitmap object.
    m_PointBitmap := TBitmapClass.Create;

    // Initialize the point bitmap object.
    Result := m_PointBitmap.Initialize(device, deviceContext, screenWidth, screenHeight, '.\data\minimap\point.tga', 3, 3);

end;



procedure TMiniMapClass.Shutdown();
begin
    // Release the point bitmap object.
    if (m_PointBitmap <> nil) then
    begin
        m_PointBitmap.Shutdown();
        m_PointBitmap.Free;
        m_PointBitmap := nil;
    end;

    // Release the mini-map bitmap object.
    if (m_MiniMapBitmap <> nil) then
    begin
        m_MiniMapBitmap.Shutdown();
        m_MiniMapBitmap.Free;
        m_MiniMapBitmap := nil;
    end;

end;



function TMiniMapClass.Render(deviceContext: ID3D11DeviceContext; ShaderManager: TShaderManagerClass;
    worldMatrix, viewMatrix, orthoMatrix: TXMMATRIX): Hresult;
begin
    // Put the mini-map bitmap vertex and index buffers on the graphics pipeline to prepare them for drawing.
    Result := m_MiniMapBitmap.Render(deviceContext, m_mapLocationX, m_mapLocationY);
    if (Result <> S_OK) then Exit;

    // Render the mini-map bitmap using the texture shader.
    Result := ShaderManager.RenderTextureShader(deviceContext, m_MiniMapBitmap.GetIndexCount(), worldMatrix, viewMatrix,
        orthoMatrix, m_MiniMapBitmap.GetTexture());
    if (Result <> S_OK) then Exit;

    // Put the point bitmap vertex and index buffers on the graphics pipeline to prepare them for drawing.
    Result := m_PointBitmap.Render(deviceContext, m_pointLocationX, m_pointLocationY);
    if (Result <> S_OK) then Exit;

    // Render the point bitmap using the texture shader.
    Result := ShaderManager.RenderTextureShader(deviceContext, m_PointBitmap.GetIndexCount(), worldMatrix, viewMatrix,
        orthoMatrix, m_PointBitmap.GetTexture());

end;



procedure TMiniMapClass.PositionUpdate(positionX, positionZ: single);
var
    percentX, percentY: single;
begin
    // Ensure the point does not leave the minimap borders even if the camera goes past the terrain borders.
    if (positionX < 0) then
    begin
        positionX := 0;
    end;

    if (positionZ < 0) then
    begin
        positionZ := 0;
    end;

    if (positionX > m_terrainWidth) then
    begin
        positionX := m_terrainWidth;
    end;

    if (positionZ > m_terrainHeight) then
    begin
        positionZ := m_terrainHeight;
    end;

    // Calculate the position of the camera on the minimap in terms of percentage.
    percentX := positionX / m_terrainWidth;
    percentY := 1.0 - (positionZ / m_terrainHeight);

    // Determine the pixel location of the point on the mini-map.
    m_pointLocationX := trunc((m_mapLocationX + 2) + (percentX * m_mapSizeX));
    m_pointLocationY := trunc((m_mapLocationY + 2) + (percentY * m_mapSizeY));

    // Subtract one from the location to center the point on the mini-map according to the 3x3 point pixel image size.
    m_pointLocationX := m_pointLocationX - 1;
    m_pointLocationY := m_pointLocationY - 1;
end;

end.
