class SeqAct_BreakFractureMeshRadial extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() bool bDebug;
var Actor Origin;
var() float Radius;
var float FracturePartVelocity;
var array<FracturedStaticMeshActor> Fractures;
var() class<DamageType> dmgType;

event Activated()
{
    local FracturedStaticMeshActor FracActor;

    // End:0x11
    if(Origin == none)
    {
        return;
    }
    // End:0xCF
    foreach Fractures(FracActor)
    {
        // End:0xCE
        if((int(FracActor.Physics) == int(0)) && FracActor.IsFracturedByDamageType(dmgType))
        {
            FracActor.BreakOffPartsInRadius(Origin.Location, Radius, FracturePartVelocity, true);
        }        
    }    
    //return;    
}

defaultproperties
{
    Radius=50.0000000
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Origin",LinkVar="None",PropertyName="Origin",bWriteable=true,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Fracture actors",LinkVar="None",PropertyName="Fractures",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Break fracture mesh - radial"
}