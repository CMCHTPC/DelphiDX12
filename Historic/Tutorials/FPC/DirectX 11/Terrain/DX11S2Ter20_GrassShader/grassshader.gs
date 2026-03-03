cbuffer MatrixBuffer
{
	matrix World;
	matrix View;
	matrix Projection;
};

cbuffer LightBuffer
{
    float3 LightPosition;
    float padding;
    float3 CameraPosition;
    float padding2;
    float2 Time;
    float2 WindVector;
};


// Our constants
static const float kHalfPi = 1.5707;
static const float kQuarterPi = 0.7853;
static const float kOscillateDelta = 0.25;
static const float kWindCoeff = 50.0f;

void GS_Shader(point GEO_IN points[1], in uint vertexDifference, inout TriangleStream<GEO_OUT> output)
{
	float4 root = points[0].Position;

	// Generate a random number between 0.0 to 1.0 by using the root position (which is randomized by the CPU)
	float random = sin(kHalfPi * frac(root.x) + kHalfPi * frac(root.z));
	float randomRotation = random;

	float cameraDistance = length(CameraPosition.xz - root.xz);

	// Properties of the grass blade
	float minHeight = 4.5;
	float minWidth = 0.03 + (cameraDistance * 0.0001);
	float sizeX = minWidth + (random / 50);
	float sizeY = minHeight + (random / 5);

	// Animation
	float toTheLeft = sin(Time.x);

	// Rotate in Z-axis
	float3x3 rotationMatrix = {		cos(randomRotation),	0,	sin(randomRotation),
									0,						1,	0,
									-sin(randomRotation),	0,	cos(randomRotation) };

	/////////////////////////////////
	// Generating vertices
	/////////////////////////////////

	const uint vertexCount = 12;
	float3 levelOfDetail = { vertexDifference * 0.0, 1, vertexDifference * 0.0 };
	const float realVertexCount = (vertexCount - vertexDifference);
	GEO_OUT v[vertexCount] = {
		createGEO_OUT(), createGEO_OUT(), createGEO_OUT(), createGEO_OUT(),
		createGEO_OUT(), createGEO_OUT(), createGEO_OUT(), createGEO_OUT(),
		createGEO_OUT(), createGEO_OUT(), createGEO_OUT(), createGEO_OUT()
	};

	float3 positionWS[vertexCount];

	// This is used to calculate the current V position of our TexCoords.
	// We know the U position, because even vertices (0, 2, 4, ...) always have X = 0
	// And uneven vertices (1, 3, 5, ...) always have X = 1
	float currentV = 1;
	float VOffset = 1 / ((realVertexCount / 2) - 1);
	float currentNormalY = 0;
	float currentHeightOffset = sqrt(sizeY);
	float currentVertexHeight = 0;

	// Wind
	float windCoEff = 0;

	// We don't want to interpolate linearly for the normals. The bottom vertex should be 0, top vertex should be 1.
	// If we interpolate linearly and we have 4 vertices, we get 0, 0.33, 0.66, 1. 
	// Using pow, we can adjust the curve so that we get lower values on the bottom and higher values on the top.
	float steepnessFactor = 1.75; 
	
	// Transform into projection space and calculate vectors needed for light calculation
	[unroll]
	for(uint i = 0; i < vertexCount - vertexDifference; i++)
	{
		// Fake creation of the normal. Pointing downwards on the bottom. Pointing upwards on the top. And then interpolating in between.
		v[i].Normal = normalize(float4(0, pow(currentNormalY, steepnessFactor), 0, 1));

		// Creating vertices and calculating Texcoords (UV)
		// Vertices start at the bottom and go up. v(0) and v(1) are left bottom and right bottom.
		if (i % 2 == 0) { // 0, 2, 4
			v[i].Position = float4(root.x - sizeX, root.y + currentVertexHeight, root.z, 1);
			v[i].TexCoord = float2(0, currentV);
		} else { // 1, 3, 5
			v[i].Position = float4(root.x + sizeX, root.y + currentVertexHeight, root.z, 1);
			v[i].TexCoord = float2(1, currentV);
		}

		// First rotate (translate to origin)
		v[i].Position = float4(v[i].Position.x - root.x, v[i].Position.y - root.y, v[i].Position.z - root.z, 1);
		v[i].Position = float4(mul(v[i].Position.xyz, rotationMatrix), 1);
		v[i].Position = float4(v[i].Position.x + root.x, v[i].Position.y + root.y, v[i].Position.z + root.z, 1);

		// Wind
		float2 windVec = WindVector;
		windVec.x += (sin(Time.x + root.x / 25) + sin((Time.x + root.x / 15) + 50)) * 0.5;
		windVec.y += cos(Time.x + root.z / 80);
		windVec *= lerp(0.7, 1.0, 1.0 - random);

		// Oscillate wind
		float sinSkewCoeff = random;
		float oscillationStrength = 2.5f;
		float lerpCoeff = (sin(oscillationStrength * Time.x + sinSkewCoeff) + 1.0) / 2;
		float2 leftWindBound = windVec * (1.0 - kOscillateDelta);
		float2 rightWindBound = windVec * (1.0 + kOscillateDelta);
		windVec = lerp(leftWindBound, rightWindBound, lerpCoeff);

		// Randomize wind by adding a random wind vector
		float randAngle = lerp(-3.14, 3.14, random);
		float randMagnitude = lerp(0, 1.0, random);
		float2 randWindDir = float2(sin(randAngle), cos(randAngle));
		windVec += randWindDir * randMagnitude;

		float windForce = length(windVec);

		// Calculate final vertex position based on wind
		v[i].Position.xz += windVec.xy * windCoEff;
		v[i].Position.y -= windForce * windCoEff * 0.8;
		positionWS[i] = mul(v[i].Position, World).xyz;

		// Calculate output
		v[i].Position = mul(mul(mul(v[i].Position, World), View), Projection);
		v[i].VertexToLight = normalize(LightPosition - positionWS[i].xyz);
		v[i].VertexToCamera = normalize(CameraPosition - positionWS[i].xyz);
		v[i].Random = random;
		v[i].LevelOfDetail = levelOfDetail;

		if (i % 2 != 0) {
			// General
			currentV -= VOffset;
			currentNormalY += VOffset * 2;
			levelOfDetail.r += VOffset;

			// Height
			currentHeightOffset -= VOffset;
			float currentHeight = sizeY - (currentHeightOffset * currentHeightOffset);
			currentVertexHeight = currentHeight;

			// Wind
			windCoEff += VOffset; // TODO: Check these values
		}
	}

	// Connect the vertices
	[unroll]
	for (uint p = 0; p < (vertexCount - vertexDifference - 2); p++) {
		output.Append(v[p]);
		output.Append(v[p+2]);
		output.Append(v[p+1]);
	}
}