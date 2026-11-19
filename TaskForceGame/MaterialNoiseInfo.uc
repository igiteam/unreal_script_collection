class MaterialNoiseInfo Extends Object
	abstract;

//All vars are const; they can only be set in default props
var const float NoiseValue[EMATERIALTYPE_SIZE];	//The array of noise factors for each material

//
// footstep sounds
//
var const Sound FootstepSounds[EMATERIALTYPE_SIZE];
//
// landing sounds
//
var const Sound LandingSounds[EMATERIALTYPE_SIZE];

//
// Falling sounds
//
var const sound BodyFallSounds[EMATERIALTYPE_SIZE];

var const sound IceSlipSounds[4];

var const sound MeleeImpactSounds[EMATERIALTYPE_SIZE];

static function float GetNoiseFactor( byte MaterialType )
{
	if( MaterialType >= EMATERIALTYPE_SIZE )
		MaterialType = 0;
	
	return default.NoiseValue[MaterialType];
}

static function Sound GetBodyFallSound( byte MaterialType )
{
	if( MaterialType >= EMATERIALTYPE_SIZE )
		MaterialType = 0;
	
	return default.BodyFallSounds[MaterialType];
}

static function Sound GetFootstepSound( byte MaterialType )
{
	if( MaterialType >= EMATERIALTYPE_SIZE )
		MaterialType = 0;
	
	return default.FootstepSounds[MaterialType];
}

static function Sound GetLandingSound( byte MaterialType )
{
	if( MaterialType >= EMATERIALTYPE_SIZE )
		MaterialType = 0;
	
	return default.LandingSounds[MaterialType];
}

static function Sound GetIceSlipSound ( byte Index )
{
	if ( Index < 0 || Index > 4 )
	{
		return None;
	}
	return default.IceSlipSounds[Index];
}


// Decompiled with UE Explorer.
defaultproperties
{
    NoiseValue[0]=0.2000000
    NoiseValue[1]=0.5000000
    NoiseValue[2]=0.2000000
    NoiseValue[3]=0.5000000
    NoiseValue[4]=0.5000000
    NoiseValue[5]=0.5000000
    NoiseValue[6]=0.5000000
    NoiseValue[7]=0.4000000
    NoiseValue[8]=0.3000000
    NoiseValue[9]=0.5000000
    NoiseValue[10]=0.3000000
    NoiseValue[11]=0.5000000
    FootstepSounds[0]=Sound'CBW_DYN_Foley.footsteps.footstep_stone1'
    FootstepSounds[1]=Sound'CBW_DYN_Foley.footsteps.footstep_gravel1'
    FootstepSounds[2]=Sound'CBW_DYN_Foley.footsteps.footstep_sand1'
    FootstepSounds[3]=Sound'CBW_DYN_Foley.footsteps.footstep_metal1'
    FootstepSounds[4]=Sound'CBW_DYN_Foley.footsteps.footstep_stone1'
    FootstepSounds[5]=Sound'CBW_DYN_Foley.footsteps.footstep_water1'
    FootstepSounds[6]=Sound'CBW_DYN_Foley.footsteps.footstep_wood1'
    FootstepSounds[7]=Sound'CBW_DYN_Foley.footsteps.footstep_debris1'
    FootstepSounds[8]=Sound'CBW_DYN_Foley.footsteps.footstep_jungle1'
    FootstepSounds[9]=Sound'CBW_DYN_Foley.footsteps.footstep_swamp1'
    FootstepSounds[10]=Sound'CBW_DYN_Foley.footsteps.footstep_mud1'
    FootstepSounds[11]=Sound'CBW_DYN_Foley.footsteps.footstep_mud1'
    LandingSounds[0]=Sound'CBW_DYN_Foley.landing.footstep_landing_stone1'
    LandingSounds[1]=Sound'CBW_DYN_Foley.landing.footstep_landing_gravel1'
    LandingSounds[2]=Sound'CBW_DYN_Foley.landing.footstep_landing_sand1'
    LandingSounds[3]=Sound'CBW_DYN_Foley.landing.footstep_landing_metal1'
    LandingSounds[4]=Sound'CBW_DYN_Foley.landing.footstep_landing_stone1'
    LandingSounds[5]=Sound'CBW_DYN_Foley.landing.footstep_landing_water1'
    LandingSounds[6]=Sound'CBW_DYN_Foley.landing.footstep_landing_wood1'
    LandingSounds[7]=Sound'CBW_DYN_Foley.landing.footstep_landing_debris1'
    LandingSounds[8]=Sound'CBW_DYN_Foley.landing.footstep_landing_jungle1'
    LandingSounds[9]=Sound'CBW_DYN_Foley.landing.footstep_landing_swamp1'
    LandingSounds[10]=Sound'CBW_DYN_Foley.landing.footstep_landing_mud1'
    LandingSounds[11]=Sound'CBW_DYN_Foley.landing.footstep_landing_mud1'
    BodyFallSounds[0]=Sound'CBW_DYN_Foley.bodyfalls.bodyfall_stone1'
    BodyFallSounds[1]=Sound'CBW_DYN_Foley.bodyfalls.bodyfall_gravel1'
    BodyFallSounds[2]=Sound'CBW_DYN_Foley.bodyfalls.bodyfall_gravel1'
    BodyFallSounds[3]=Sound'CBW_DYN_Foley.bodyfalls.bodyfall_wood1'
    BodyFallSounds[4]=Sound'CBW_DYN_Foley.bodyfalls.bodyfall_stone1'
    BodyFallSounds[5]=Sound'CBW_DYN_Foley.bodyfalls.bodyfall_water1'
    BodyFallSounds[6]=Sound'CBW_DYN_Foley.bodyfalls.bodyfall_wood1'
    BodyFallSounds[7]=Sound'CBW_DYN_Foley.bodyfalls.bodyfall_gravel1'
    BodyFallSounds[8]=Sound'CBW_DYN_Foley.bodyfalls.bodyfall_stone1'
    BodyFallSounds[9]=Sound'CBW_DYN_Foley.bodyfalls.bodyfall_water1'
    BodyFallSounds[10]=Sound'CBW_DYN_Foley.bodyfalls.bodyfall_gravel1'
    BodyFallSounds[11]=Sound'CBW_DYN_Foley.bodyfalls.bodyfall_gravel1'
    MeleeImpactSounds[0]=Sound'CBW_DYN_Foley.melee.melee_stone1'
    MeleeImpactSounds[1]=Sound'CBW_DYN_Foley.melee.melee_gravel1'
    MeleeImpactSounds[2]=Sound'CBW_DYN_Foley.melee.melee_sand1'
    MeleeImpactSounds[3]=Sound'CBW_DYN_Foley.melee.melee_metal1'
    MeleeImpactSounds[4]=Sound'CBW_DYN_Foley.melee.melee_stone1'
    MeleeImpactSounds[5]=Sound'CBW_DYN_Foley.melee.melee_water1'
    MeleeImpactSounds[6]=Sound'CBW_DYN_Foley.melee.melee_wood1'
    MeleeImpactSounds[7]=Sound'CBW_DYN_Foley.melee.melee_debris1'
    MeleeImpactSounds[8]=Sound'CBW_DYN_Foley.melee.melee_jungle1'
    MeleeImpactSounds[9]=Sound'CBW_DYN_Foley.melee.melee_mud1'
    MeleeImpactSounds[10]=Sound'CBW_DYN_Foley.melee.melee_mud1'
    MeleeImpactSounds[11]=Sound'CBW_DYN_Foley.melee.melee_flesh1'
}