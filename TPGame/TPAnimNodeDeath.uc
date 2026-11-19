class TPAnimNodeDeath extends TPAnimNodeBlendByHitBone
		native;

var Name	MomentumBoneName;
var int		MomentumInitializeSteps;
var vector	MomentumStartLoc;
var vector	MomentumEndLoc;
var quat	MomentumStartRot;
var quat	MomentumEndRot;
var float	MomentumTime;
var float	SavedForceScale;

var() float		DefaultForceScale; // default force scale (0-1) multiply by anim force scale

var() float		EncroachCylinderRadius;
var() float		EncroachCylinderHeight;
var() float		EncroachCylinderZOffset;
var() Name		EncroachAnimName;			// Animation to play when not enough space

var   name        ForcedDeathAnim;
var   bool        bNoRagDollAfterDeathAnim;
var   array<name> fixedBones;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

function NoRagDollAfterDeathAnim(bool value)
{
    bNoRagDollAfterDeathAnim = value;
}

function ForceNextDeathAnim(name AnimName, optional out array<name> extraFixedBones)
{
    if (ForcedDeathAnim != '')
    {
        ;
    }

    fixedBones      = extraFixedBones;
    ForcedDeathAnim = AnimName;
}


