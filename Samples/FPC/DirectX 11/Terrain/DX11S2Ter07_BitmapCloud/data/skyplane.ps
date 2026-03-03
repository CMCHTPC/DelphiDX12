////////////////////////////////////////////////////////////////////////////////
// Filename: skyplane.ps
////////////////////////////////////////////////////////////////////////////////


/////////////
// GLOBALS //
/////////////
Texture2D cloudTexture1 : register(t0);
Texture2D cloudTexture2 : register(t1);
SamplerState SampleType;

cbuffer SkyBuffer
{
	float firstTranslationX;
	float firstTranslationZ;
	float secondTranslationX;
	float secondTranslationZ;
	float brightness;
	float3 padding;
};


//////////////
// TYPEDEFS //
//////////////
struct PixelInputType
{
    float4 position : SV_POSITION;
    float2 tex : TEXCOORD0;
};


////////////////////////////////////////////////////////////////////////////////
// Pixel Shader
////////////////////////////////////////////////////////////////////////////////
float4 SkyPlanePixelShader(PixelInputType input) : SV_TARGET
{
	float2 sampleLocation;
	float4 textureColor1;
	float4 textureColor2;
	float4 finalColor;


	// Translate the position where we sample the pixel from using the first texture translation values.
    sampleLocation.x = input.tex.x + firstTranslationX;
    sampleLocation.y = input.tex.y + firstTranslationZ;

	// Sample the pixel color from the first cloud texture using the sampler at this texture coordinate location.
    textureColor1 = cloudTexture1.Sample(SampleType, sampleLocation);

	// Translate the position where we sample the pixel from using the second texture translation values.
    sampleLocation.x = input.tex.x + secondTranslationX;
    sampleLocation.y = input.tex.y + secondTranslationZ;

	// Sample the pixel color from the second cloud texture using the sampler at this texture coordinate location.
    textureColor2 = cloudTexture2.Sample(SampleType, sampleLocation);

	// Combine the two cloud textures evenly.
	finalColor = lerp(textureColor1, textureColor2, 0.5f);

	// Reduce brightness of the combined cloud textures by the input brightness value.
	finalColor = finalColor * brightness;

    return finalColor;
}