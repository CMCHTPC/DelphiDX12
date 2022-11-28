struct VertexInputType
{
	float4 Position : POSITION;
	float4 Normal	: NORMAL0;
	float2 TexCoord	: TEXCOORD0;
};

struct GeoInputType
{
	float4 Position			: SV_POSITION;
	float4 Normal			: NORMAL0;
};

GeoInputType GrassVertexShader(VertexInputType input)
{
    GeoInputType output;

	output.Position = input.Position;
	output.Normal = input.Normal;

    return output;
}