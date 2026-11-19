class SkySeqAct_CamShakeByDistance extends SequenceAction;

enum EShakeFalloff
{
    Linear,                         // 0
    Exponential,                    // 1
    EShakeFalloff_MAX               // 2
};

var() ViewShakeInfo CameraShake;
var() float MaxDistance;

function Activated()
{
    local SkyPlayerControllerBase PC;
    local int I;
    local Actor TargetActor;
    local float Dist, distParam;
    local ViewShakeInfo shake;

    PC = SkyPlayerControllerBase(SeqVar_Object(VariableLinks[1].LinkedVariables[0]).GetObjectValue());
    // End:0x40
    if(PC == none)
    {
        return;
    }
    I = 0;
    J0x47:

    // End:0x157 [Loop If]
    if(I < Targets.Length)
    {
        TargetActor = Actor(SeqVar_Object(VariableLinks[0].LinkedVariables[I]).GetObjectValue());
        // End:0x9C
        if(TargetActor == none)
        {
            // [Explicit Continue]
            goto J0x14D;
        }
        Dist = Abs(VSize(PC.Pawn.Location - TargetActor.Location));
        // End:0xE2
        if(Dist > MaxDistance)
        {
            // [Explicit Continue]
            goto J0x14D;
        }
        distParam = 1.0000000 - (Dist / MaxDistance);
        shake = CameraShake;
        shake.OffsetMag *= distParam;
        shake.OffsetRate *= distParam;
        PC.ShakeView(shake);
        J0x14D:

        ++I;
        // [Loop Continue]
        goto J0x47;
    }
    //return;    
}
