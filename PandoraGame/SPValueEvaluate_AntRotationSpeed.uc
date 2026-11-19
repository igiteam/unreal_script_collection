class SPValueEvaluate_AntRotationSpeed extends SPValueEvaluate
    editinlinenew
    collapsecategories;

/** `define SPLOG(t)  `LOG("SPValueEvaluate_AntRotationSpeed: " $ `t) STRUCT DECLARATIONS VARIABLE DECLARATIONS */
var() SPValueEvaluate.eRotAxisAv m_RotAxis;

function float GetActorValue(Actor Actor)
{
    local float angularSpeed;
    local SPSkeletalMeshActorMATSMover Ant;
    local Vector Euler;

    Ant = SPSkeletalMeshActorMATSMover(Actor);
    // End:0x21
    if(Ant == none)
    {
        return 0.0000000;
    }
    Euler = GetEuler(Ant.spAngularVelocity);
    switch(m_RotAxis)
    {
        // End:0x62
        case 0:
            angularSpeed = Euler.Y;
            // End:0xA1
            break;
        // End:0x80
        case 1:
            angularSpeed = Euler.Z;
            // End:0xA1
            break;
        // End:0x9E
        case 2:
            angularSpeed = Euler.X;
            // End:0xA1
            break;
        // End:0xFFFF
        default:
            break;
    }
    return angularSpeed;
    //return ReturnValue;    
}
