class SeqAct_BreakFractureMeshInterp extends SeqAct_Latent
    forcescriptorder(true)
    hidecategories(Object);

var() bool bDebug;
var Actor StartPoint;
var Actor EndPoint;
var() float InterpolationSpeed;
var() float Radius;
var float FracturePartVelocity;
var() float FracturingDelay;
var() class<DamageType> dmgType;
var float CurrentInterpValue;
var float LastFractureTime;
var array<FracturedStaticMeshActor> Fractures;

event Activated()
{
    CurrentInterpValue = 0.0000000;
    // End:0x4D
    if(((Fractures.Length == 0) || StartPoint == none) || EndPoint == none)
    {
        bAborted = true;
    }
    LastFractureTime = Class'Engine.WorldInfo'.static.GetWorldInfo().TimeSeconds - float(999);
    //return;    
}

event bool Update(float DeltaTime)
{
    local Vector CurrentOrigin;
    local float CurrentTime;
    local FracturedStaticMeshActor FracActor;

    CurrentOrigin = StartPoint.Location + ((EndPoint.Location - StartPoint.Location) * CurrentInterpValue);
    CurrentTime = Class'Engine.WorldInfo'.static.GetWorldInfo().TimeSeconds;
    CurrentInterpValue += (DeltaTime * InterpolationSpeed);
    // End:0xE9
    if(CurrentTime < LastFractureTime)
    {
        return true;
    }
    LastFractureTime = CurrentTime + FracturingDelay;
    // End:0x1B0
    foreach Fractures(FracActor)
    {
        // End:0x1AF
        if((int(FracActor.Physics) == int(0)) && FracActor.IsFracturedByDamageType(dmgType))
        {
            FracActor.BreakOffPartsInRadius(CurrentOrigin, Radius, FracturePartVelocity, true);
        }        
    }    
    return CurrentInterpValue < float(1);
    //return ReturnValue;    
}

defaultproperties
{
    InterpolationSpeed=1.0000000
    Radius=50.0000000
    FracturingDelay=0.1000000
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="StartPoint",LinkVar="None",PropertyName="StartPoint",bWriteable=true,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="EndPoint",LinkVar="None",PropertyName="EndPoint",bWriteable=true,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[2]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Fracture actors",LinkVar="None",PropertyName="Fractures",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Break fracture mesh - interp"
}