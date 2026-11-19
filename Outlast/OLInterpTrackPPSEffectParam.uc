class OLInterpTrackPPSEffectParam extends InterpTrackFloatBase
	native;

cpptext
{
	virtual INT AddKeyframe(FLOAT Time, UInterpTrackInst* TrInst, EInterpCurveMode InitInterpMode);
	virtual void PreviewUpdateTrack(FLOAT NewPosition, UInterpTrackInst* TrInst);
	virtual void UpdateTrack(FLOAT NewPosition, UInterpTrackInst* TrInst, UBOOL bJump);
}

enum TrackPropertyType
{
	TPP_MaterialInstance,
	TPP_UberMovieIntensity
};

/** Material that this track should modify */
var()	MaterialInstanceConstant EffectMaterial;

/** Scalar parameter in the material that this track will modify */
var()	name ParamName;

/** Name of an Effect in the PPS chain that this track should enable or disable */
var()	name	EffectName;

/** Allows changing some specific post-fx properties directly. Ignores all other properties. */
var() TrackPropertyType PropertyType;

defaultproperties
{
	TrackInstClass=class'OLGame.OLInterpTrackInstPPSEffectParam'
	TrackTitle="PPS Effect Param"
	PropertyType=TPP_MaterialInstance
}
