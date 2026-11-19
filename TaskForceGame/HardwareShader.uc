class HardwareShader extends RenderedMaterial
	native;

// DS_SHADER

enum SConstant
{
	EVC_Unused, // This constant isn't used by the shader and does not need to be updated
	EVC_MaterialDefined, // The constant is defined by by the Value member of FVSConstantsInfo
	EVC_ViewProjMatrix, // The constant, and the three constants after it will contain the view projection matrix
	EVC_WorldViewProjMatrix,
	EVC_WorldMatrix,
	EVC_InvViewMatrix, // The constant, and the three constants after it will contain the inverse view matrix
	EVC_ViewMatrix, // The constant, and the three constants after it will contain the view matrix
	EVC_InvWorldMatrix,
	EVC_Time, // Time, cycled over 120 seconds
	EVC_CosTime,
	EVC_SinTime,
	EVC_TanTime,
	EVC_Eye,
	EVC_XYCircle,
	EVC_NearestLightPos1,
	EVC_InvLightRadius1,
	EVC_NearestLightPos2,
	EVC_InvLightRadius2,
	EVC_LightColor1,
	EVC_LightColor2
};

struct native SConstantsInfo
{
	var() SConstant Type;
	var() Plane Value;
};

enum HSBlendOps
{
    HSBLEND_ZERO,
    HSBLEND_ONE,
    HSBLEND_SRCCOLOR,
    HSBLEND_INVSRCCOLOR,
    HSBLEND_SRCALPHA,
    HSBLEND_INVSRCALPHA,
    HSBLEND_DESTALPHA,
    HSBLEND_INVDESTALPHA,
    HSBLEND_DESTCOLOR,
    HSBLEND_INVDESTCOLOR,
    HSBLEND_SRCALPHASAT,
    HSBLEND_BOTHSRCALPHA,
    HSBLEND_BOTHINVSRCALPHA,
}; 
    
struct native HSRenderState
{
	var() bool ZTest; 
	var() bool ZWrite; 
	var() bool AlphaBlending; 
	var() bool AlphaTest; 
	var() byte AlphaRef; 
	var() HSBlendOps SrcBlend;
	var() HSBlendOps DestBlend;
}; 

struct native HardwareShaderPass
{
	var() Material Textures[8];

	var() SConstantsInfo	VSConstants[96];
	var() string			VertexShaderText;

	var() SConstantsInfo	PSConstants[8];
	var() string			PixelShaderText;

	var() HSRenderState		RenderState; 
	
	var() String			VSByteCode;		// Precompiled vertex shader bytecode for the XBOX
	var() String			PSByteCode;		// Precompiled pixel shader bytecode for the XBOX
}; 

var(HardwareShader) HardwareShaderPass RenderPasses[4]; 
var(HardwareShader) array<INT> StreamMapping;

var transient const int VertexShaders[4];
var transient const int PixelShaders[4];
var int  NumPasses;


// Decompiled with UE Explorer.
defaultproperties
{
    NumPasses=1
    MaterialFlag=512
}