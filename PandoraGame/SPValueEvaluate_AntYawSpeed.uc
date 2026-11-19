class SPValueEvaluate_AntYawSpeed extends SPValueEvaluate
    editinlinenew
    collapsecategories;

function float GetActorValue(Actor Actor)
{
    local SPSkeletalMeshActorMATSMover Ant;
    local Vector Euler;

    Ant = SPSkeletalMeshActorMATSMover(Actor);
    // End:0x21
    if(Ant == none)
    {
        return 0.0000000;
    }
    Euler = GetEuler(Ant.spAngularVelocity);
    return Euler.Z;
    //return ReturnValue;    
}
