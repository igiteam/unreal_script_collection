/**
 * Copyright 2013 Red Barrels Inc. All Rights Reserved.
 */
class OLUberPostProcessEffect extends UberPostProcessEffect
	native
	dependson(PostProcessVolume);

var(Vignette) float VignetteBlack<DisplayName=Black>;
var(Vignette) float VignetteWhite<DisplayName=White>;

var(Noise) float GrainBrightness<DisplayName=Brightness>;
var(Noise) float GrainOpacity<DisplayName=Opacity>;
var(Noise) float GrainScale<DisplayName=Scale>;
var Texture2D GrainTexture;

var(Hurt) LinearColor HurtColor<DisplayName=Color>;
var(Hurt) float HurtRadiusMin<DisplayName=RadiusMin>;
var(Hurt) float HurtRadiusMax<DisplayName=RadiusMax>;
var(Hurt) float HurtHardnessMin<DisplayName=HardnessMin>;
var(Hurt) float HurtHardnessMax<DisplayName=HardnessMax>;
var(Hurt) float HurtAmount<DisplayName=Amount>;
var(Hurt) float HurtExp<DisplayName=Exp>;
var(Hurt) float HurtTimeScale<DisplayName=TimeScale>;
var(Hurt) float HurtScale<DisplayName=Scale>;

enum ECameraMode
{
	CM_Off,
	CM_On,
	CM_OnNightVision
};

var(Camera) ECameraMode CameraMode<DisplayName=Mode>;
var(Camera) bool        bCameraGlassShattered<DisplayName=GlassShattered>;
var(Camera) float       CameraColorEffect<DisplayName=ColorStrength>;
var(Camera) float       CameraScale<DisplayName=Scale>;
var(Camera) LinearColor CameraColor<DisplayName=Color>;

var(Camera) float       CameraGlassLightIntensity<DisplayName=GlassLightIntensity>;
var(Camera) LinearColor CameraGlassLightColor<DisplayName=GlassLightColor>;
var Texture2D   CameraGlassDiffuse;
var Texture2D   CameraGlassNormal;
var TextureCube CameraGlassCubeMap;

var(MovieEffect) float       MovieIntensity<DisplayName=Intensity>;
var(MovieEffect) LinearColor MovieColorHi<DisplayName=ColorHi>;
var(MovieEffect) LinearColor MovieColorLo<DisplayName=ColorLo>;
var(MovieEffect) LinearColor MovieColor<DisplayName=MovieColor>;
var TextureMovie	MovieTexture;
var Texture2D		MovieGradTexture;
var Texture2D		MovieLightMaskTexture;

cpptext
{
	// UPostProcessEffect interface

	/**
	 * Creates a proxy to represent the render info for a post process effect
	 * @param WorldSettings - The world's post process settings for the view.
	 * @return The proxy object.
	 */
	virtual class FPostProcessSceneProxy* CreateSceneProxy(const FPostProcessSettings* WorldSettings);
}

defaultproperties
{
	VignetteBlack=0.4;
	VignetteWhite=1.75;
	
	GrainBrightness=0.8;
	GrainOpacity=1.0;
	GrainScale=3.0;
	GrainTexture=Texture2D'Asylum_post_process.FilmGrain.T_FilmGrain';

	HurtColor=(R=0.795551,G=0.023503,B=0.0,A=1.0);
	HurtRadiusMin=2.3;
	HurtRadiusMax=0.75;
	HurtHardnessMin=0.3;
	HurtHardnessMax=0.2;
	HurtAmount=0.0;
	HurtExp=0.5;
	HurtTimeScale=0.01;
	HurtScale=0.2;

	CameraMode=CM_Off;
	bCameraGlassShattered=false;
	CameraColorEffect=1.0;
	CameraScale=0.2;
	CameraColor=(R=0.824772,G=1.000000,B=0.785341,A=1.05);

	CameraGlassLightIntensity=0.009837;
	CameraGlassLightColor=(R=0.006571,G=0.008318,B=0.009003,A=1.0);
	CameraGlassDiffuse=Texture2D'Asylum_post_process.ShatterredGlass.BrokenCamera_D';
	CameraGlassNormal=Texture2D'Asylum_post_process.ShatterredGlass.BrokenCamera_N';
	CameraGlassCubeMap=TextureCube'Basic_Mat_Cubemaps.room.LabCM02_Tex';

	MovieIntensity=0.0;
	MovieTexture=TextureMovie'02_NanoCloud.Movie.SwamMind';
	MovieGradTexture=Texture2D'Asylum_post_process.WeirdEffect.boom_grad';
	MovieLightMaskTexture=Texture2D'hugo_test.lighting_mask';
	MovieColorHi=(R=0.712397,G=0.904166,B=1.000000,A=2.000000);
	MovieColorLo=(R=1.000000,G=0.576137,B=0.203667,A=2.000000);
	MovieColor  =(R=0.853440,G=1.000000,B=0.840112,A=4.000000);
}
