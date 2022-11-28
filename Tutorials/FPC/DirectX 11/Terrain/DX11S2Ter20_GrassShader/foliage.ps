////////////////////////////////////////////////////////////////////////////////
// Filename: foliage.ps
////////////////////////////////////////////////////////////////////////////////


/////////////
// GLOBALS //
/////////////
Texture2D shaderTexture;
SamplerState SampleType;


//////////////
// TYPEDEFS //
//////////////
struct PixelInputType
{
    float4 position : SV_POSITION;
    float2 tex : TEXCOORD0;
	float3 foliageColor : TEXCOORD1;
};


////////////////////////////////////////////////////////////////////////////////
// Pixel Shader
////////////////////////////////////////////////////////////////////////////////
float4 FoliagePixelShader(PixelInputType input) : SV_TARGET
{
	float4 textureColor;
	float4 color;


	// Sample the pixel color from the texture using the sampler at this texture coordinate location.
	textureColor = shaderTexture.Sample(SampleType, input.tex);

	// Combine the texture and the foliage color.
	color = textureColor * float4(input.foliageColor, 1.0f);

	// Saturate the final color result.
	color = saturate(color);

    return color;
}