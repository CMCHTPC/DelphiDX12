unit FontClass;

interface

uses
    Classes, SysUtils, Windows,
    textureclass,
    DX12.D3D11,
    DX12.D3DX10;

type
    TFontType = record
        left, right: single;
        size: integer;
    end;

    TVertexType = record
        position: TD3DXVECTOR3;
        texture: TD3DXVECTOR2;
    end;

    TFontClass = class(TObject)
    private


    private
        m_Font: array of TFontType;
        m_Texture: TTextureClass;
    public
        constructor Create;
        destructor Destroy; override;

        function Initialize(device: ID3D11Device; fontFilename, textureFilename: WideString): HResult;
        procedure Shutdown();

        function GetTexture(): ID3D11ShaderResourceView;

        procedure BuildVertexArray(vertices: pointer; sentence: ansistring; drawX, drawY: single);

    private
        function LoadFontData(filename: WideString): HResult;
        procedure ReleaseFontData();
        function LoadTexture(device: ID3D11Device; filename: WideString): HResult;
        procedure ReleaseTexture();

    end;


implementation



constructor TFontClass.Create;
begin
    m_Font := nil;
    m_Texture := nil;
end;




destructor TFontClass.Destroy;
begin
    inherited;
end;



function TFontClass.Initialize(device: ID3D11Device; fontFilename, textureFilename: WideString): HResult;
begin
    // Load in the text file containing the font data.
    Result := LoadFontData(fontFilename);
    if (Result <> S_OK) then Exit;

    // Load the texture that has the font characters on it.
    Result := LoadTexture(device, textureFilename);
end;



procedure TFontClass.Shutdown();
begin
    // Release the font texture.
    ReleaseTexture();

    // Release the font data.
    ReleaseFontData();
end;



function TFontClass.LoadFontData(filename: WideString): HResult;
var
    f: Textfile;
    i, j: integer;
    s, s1: ansistring;
    k: integer;
    code: integer;
begin
    // Create the font spacing buffer.
    SetLength(m_Font, 95);
    FormatSettings.DecimalSeparator := '.';

    // Read in the font size and spacing between chars.
    AssignFile(f, filename);
    Reset(f);

    // Read in the 95 used ascii characters for text.
    for  i := 0 to 94 do
    begin
        k := 1;
        readln(f, s);
        j := 1;
        while s[j] <> ' ' do
            Inc(j);
        Inc(j);
        while s[j] <> ' ' do
            Inc(j);
        Inc(j);
        k := j;
        while s[j] <> ' ' do
            Inc(j);
        s1 := copy(s, k, j - k);
        Val(s1, m_Font[i].left, code);
        while (s[j] = ' ') do
            Inc(j);

        k := j;
        while (s[j] <> ' ') do
            Inc(j);
        s1 := copy(s, k, j - k);
        Val(s1, m_Font[i].right, code);
        while (s[j] = ' ') do
            Inc(j);
        s1 := copy(s, j, length(s) - j + 1);
        Val(s1, m_Font[i].size, code);

    end;

    // Close the file.
    CloseFile(f);

    Result := S_OK;
end;



procedure TFontClass.ReleaseFontData();
begin
    // Release the font data array.
    SetLength(m_Font, 0);
end;



function TFontClass.LoadTexture(device: ID3D11Device; filename: WideString): HResult;
begin
    // Create the texture object.
    m_Texture := TTextureClass.Create;

    // Initialize the texture object.
    Result := m_Texture.Initialize(device, filename);
end;



procedure TFontClass.ReleaseTexture();
begin
    // Release the texture object.
    if (m_Texture <> nil) then
    begin
        m_Texture.Shutdown();
        m_Texture.Free;
        m_Texture := nil;
    end;

end;



function TFontClass.GetTexture(): ID3D11ShaderResourceView;
begin
    Result := m_Texture.GetTexture();
end;



procedure TFontClass.BuildVertexArray(vertices: pointer; sentence: ansistring; drawX, drawY: single);
var
    vertexPtr: array of TVertexType absolute vertices;
    numLetters, index, i, letter: integer;
begin
    // Coerce the input vertices into a VertexType structure.

    // Get the number of letters in the sentence.
    numLetters := length(sentence);

    // Initialize the index to the vertex array.
    index := 0;

    // Draw each letter onto a quad.
    for i := 0 to numLetters - 1 do
    begin
        letter := Ord(sentence[i + 1]) - 32;

        // If the letter is a space then just move over three pixels.
        if (letter = 0) then
        begin
            drawX := drawX + 3.0;
        end
        else
        begin
            // First triangle in quad.
            vertexPtr[index].position := TD3DXVECTOR3.Create(drawX, drawY, 0.0);  // Top left.
            vertexPtr[index].texture := TD3DXVECTOR2.Create(m_Font[letter].left, 0.0);
            Inc(index);

            vertexPtr[index].position := TD3DXVECTOR3.Create((drawX + m_Font[letter].size), (drawY - 16), 0.0);  // Bottom right.
            vertexPtr[index].texture := TD3DXVECTOR2.Create(m_Font[letter].right, 1.0);
            Inc(index);

            vertexPtr[index].position := TD3DXVECTOR3.Create(drawX, (drawY - 16), 0.0);  // Bottom left.
            vertexPtr[index].texture := TD3DXVECTOR2.Create(m_Font[letter].left, 1.0);
            Inc(index);

            // Second triangle in quad.
            vertexPtr[index].position := TD3DXVECTOR3.Create(drawX, drawY, 0.0);  // Top left.
            vertexPtr[index].texture := TD3DXVECTOR2.Create(m_Font[letter].left, 0.0);
            Inc(index);

            vertexPtr[index].position := TD3DXVECTOR3.Create(drawX + m_Font[letter].size, drawY, 0.0);  // Top right.
            vertexPtr[index].texture := TD3DXVECTOR2.Create(m_Font[letter].right, 0.0);
            Inc(index);

            vertexPtr[index].position := TD3DXVECTOR3.Create((drawX + m_Font[letter].size), (drawY - 16), 0.0);  // Bottom right.
            vertexPtr[index].texture := TD3DXVECTOR2.Create(m_Font[letter].right, 1.0);
            Inc(index);

            // Update the x location for drawing by the size of the letter and one pixel.
            drawX := drawX + m_Font[letter].size + 1.0;
        end;
    end;
end;

end.
