class SPValueEvaluate_Speed extends SPValueEvaluate
    editinlinenew
    collapsecategories;

enum eSPVelType
{
    eSP3DVelocity,                  // 0
    eSPHorizantalVelocity,          // 1
    eSPVerticalVelocity,            // 2
    eSPVelType_MAX                  // 3
};

/** VARIABLE DECLARATIONS */
var() SPValueEvaluate_Speed.eSPVelType VelocityType;

function float GetActorValue(Actor Actor)
{
    local Vector Vel;

    Vel = vect(0.0000000, 0.0000000, 0.0000000);
    switch(VelocityType)
    {
        // End:0x32
        case 0:
            return VSize(Actor.Velocity);
        // End:0x95
        case 1:
            Vel.X = Actor.Velocity.X;
            Vel.Y = Actor.Velocity.Y;
            return VSize(Vel);
        // End:0xAE
        case 2:
            return Vel.Z;
            // End:0xB1
            break;
        // End:0xFFFF
        default:
            break;
    }
    return 0.0000000;
    //return ReturnValue;    
}
