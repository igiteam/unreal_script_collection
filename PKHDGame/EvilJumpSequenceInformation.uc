class EvilJumpSequenceInformation extends Object;

var() JumpPhase JumpStart;
var() JumpPhase JumpFalling;
var() JumpPhase JumpPreLand;
var() JumpPhase JumpLand;
var() float PreLandTime;

defaultproperties
{
    JumpStart=(CustomGravityScaling=1.0000000,AnimName="None",AnimSpeed=1.0000000,Chance=1.0000000,OverrideBlendTimes=false,BlendInTime=0.2000000,BlendOutTime=0.2000000)
    JumpFalling=(CustomGravityScaling=1.0000000,AnimName="None",AnimSpeed=1.0000000,Chance=1.0000000,OverrideBlendTimes=false,BlendInTime=0.2000000,BlendOutTime=0.2000000)
    JumpPreLand=(CustomGravityScaling=1.0000000,AnimName="None",AnimSpeed=1.0000000,Chance=1.0000000,OverrideBlendTimes=false,BlendInTime=0.2000000,BlendOutTime=0.2000000)
    JumpLand=(CustomGravityScaling=1.0000000,AnimName="None",AnimSpeed=1.0000000,Chance=1.0000000,OverrideBlendTimes=false,BlendInTime=0.2000000,BlendOutTime=0.2000000)
    PreLandTime=0.1500000
}