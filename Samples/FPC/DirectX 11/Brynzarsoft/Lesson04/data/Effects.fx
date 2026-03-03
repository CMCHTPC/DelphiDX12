
float4 VS(float4 inPos : POSITION) : SV_POSITION
{
    return inPos;
}

float4 PS() : SV_TARGET
{
    return float4(0.0f, 0.0f, 1.0f, 1.0f);
}
