class AnimNodeRandom extends AnimNodeBlendList
    native
    hidecategories(Object,Object,Object,Object);

struct RandomAnimInfo
{
    var() float Chance;
    var() byte LoopCountMin;
    var() byte LoopCountMax;
    var() float BlendInTime;
    var byte LoopCount;

    structdefaultproperties
    {
        Chance=1.0000000
        LoopCountMin=1
        LoopCountMax=1
        BlendInTime=0.1000000
        LoopCount=0
    }
};

var() editinline array<editinline RandomAnimInfo> RandomInfo;

defaultproperties
{
    ActiveChildIndex=-1
}