class SPValueEvaluate_Pitch extends SPValueEvaluate
    editinlinenew
    collapsecategories;

function float GetActorValue(Actor Actor)
{
    local Vector Euler;
    local Rotator Rot;

    Rot = NormalizeRot(Actor.Rotation);
    Euler = GetEuler(Rot);
    return Euler.Y;
    //return ReturnValue;    
}
