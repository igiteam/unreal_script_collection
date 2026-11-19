//=============================================================================
// Emitter: An Unreal Sprite Particle Emitter.
//=============================================================================
class SpriteEmitter extends ParticleEmitter
	native;


struct native SpriteEmitterVertex
{
	var vector	Position; 
	var color	Color; 
	var float	U, V,		
				U2, V2;
};

enum EParticleDirectionUsage
{
	PTDU_None,
	PTDU_Up,
	PTDU_Right,
	PTDU_Forward,
	PTDU_Normal,
	PTDU_UpAndNormal,
	PTDU_RightAndNormal,
	PTDU_Scale
};


var (Sprite)		EParticleDirectionUsage		UseDirectionAs;
var (Sprite)		vector						ProjectionNormal;

var transient		vector							RealProjectionNormal;
var transient		array<SpriteEmitterVertex>		SpriteEmitterData;


// Decompiled with UE Explorer.
defaultproperties
{
    ProjectionNormal=(X=0.0000000,Y=0.0000000,Z=1.0000000)
}