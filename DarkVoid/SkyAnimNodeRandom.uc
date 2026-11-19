class SkyAnimNodeRandom extends SkyAnimBlendBase
    native;

struct native SkyRandomAnimInfo
{
    var() float Chance;
    var() byte LoopCountMin;
    var() byte LoopCountMax;
    var() Vector2D PlayRateRange;

    structdefaultproperties
    {
        Chance=1.0000000
        LoopCountMin=0
        LoopCountMax=0
        PlayRateRange=(X=1.0000000,Y=1.0000000)
    }
};

var() array<SkyRandomAnimInfo> RandomInfo;
var() bool bSetFirstChildActiveOnBecomeRelevant;
var transient AnimNodeSequence PlayingSeqNode;
var transient int LoopsLeft;

// Export USkyAnimNodeRandom::execOnChildAnimLoop(FFrame&, void* const)
native function OnChildAnimLoop(AnimNodeSequence Child, float PlayedTime, float ExcessTime, AnimNode ImmediateChild);
