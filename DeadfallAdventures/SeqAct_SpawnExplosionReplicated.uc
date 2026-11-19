class SeqAct_SpawnExplosionReplicated extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() EvilExplosion ExplosionTemplate;
var() Actor Locator;

event Activated()
{
    local EvilExplosionActorReplicated ExplosionActor;

    // End:0xC2
    if((Locator != none) && ExplosionTemplate != none)
    {
        ExplosionActor = Locator.Spawn(Class'EvilExplosionActorReplicated', Locator,, Locator.Location, Locator.Rotation);
        ExplosionActor.Explode(ExplosionTemplate);
    }
    //return;    
}

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Locator",LinkVar="None",PropertyName="Locator",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Spawn Explosion Replicated"
}