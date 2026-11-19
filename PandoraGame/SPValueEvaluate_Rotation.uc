class SPValueEvaluate_Rotation extends SPValueEvaluate
    editinlinenew
    collapsecategories;

/** `define SPLOG(t)  `LOG("SPValueEvaluate_Rotation: " $ `t) STRUCT DECLARATIONS VARIABLE DECLARATIONS */
var() SPValueEvaluate.eRotAxisAv m_RotAxis;

function float GetActorValue(Actor Actor)
{
    local float degrees;
    local Vector Euler;
    local Rotator Rot;

    Rot = NormalizeRot(Actor.Rotation);
    Euler = GetEuler(Rot);
    switch(m_RotAxis)
    {
        // End:0x52
        case 0:
            degrees = Euler.Y;
            // End:0x91
            break;
        // End:0x70
        case 1:
            degrees = Euler.Z;
            // End:0x91
            break;
        // End:0x8E
        case 2:
            degrees = Euler.X;
            // End:0x91
            break;
        // End:0xFFFF
        default:
            break;
    }
    return degrees;
    //return ReturnValue;    
}
