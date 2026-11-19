class SPDAction_SetAngularVelocity extends SPDAction
    native
    editinlinenew
    collapsecategories;

/** VARIABLE DECLARATIONS */
var(SPDAction) float DegreesPerSecond;
var(SPDAction) Vector AxisOfRotation;

event SPDProcessManager.SPDActionState Run(float ElapsedTime, Actor Actor, SPDProcessManager Manager, SPDDamage DamageInfo)
{
    local editinline MeshComponent MeshComp;
    local float radians;
    local Vector W;

    MeshComp = Actor.GetSkeletalMeshComponent();
    // End:0x37
    if(MeshComp == none)
    {
        MeshComp = Actor.GetStaticMeshComponent();
    }
    // End:0xB0
    if(MeshComp != none)
    {
        radians = (DegreesPerSecond * 3.1415930) / 180.0000000;
        W = Normal(AxisOfRotation);
        W = W * radians;
        MeshComp.SetRBAngularVelocity(W);
        MeshComp.SetRBLinearVelocity(Actor.Velocity);
    }
    return 1;
    //return ReturnValue;    
}

defaultproperties
{
    AxisOfRotation=(X=0.0000000,Y=0.0000000,Z=1.0000000)
    Action="Sets the angulat (rotational) velocity."
}