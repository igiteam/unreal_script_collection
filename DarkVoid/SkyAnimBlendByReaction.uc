class SkyAnimBlendByReaction extends SkyAnimBlendBase
    native;

struct native SkyAnimNodeReactionProfile
{
    var() SkyPawn.EReactionCategory Type;
    var() float Parameter;
    var() class<DamageType> DamageType;
    var() float Duration;

    structdefaultproperties
    {
        Type=ERC_NONE
        Parameter=0.0000000
        DamageType=none
        Duration=0.0000000
    }
};

var() array<SkyAnimNodeReactionProfile> ChildReactions;
var transient float LastPendingTime;
var transient float LastPlayedReactionTime;
