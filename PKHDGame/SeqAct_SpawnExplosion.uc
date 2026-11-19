class SeqAct_SpawnExplosion extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() EvilExplosion ExplosionTemplate;
var() Actor Locator;

event Activated()
{
    local EvilExplosionActor ExplosionActor;
    local EvilExplosion ExplosionObject;

    // End:0x119
    if((Locator != none) && ExplosionTemplate != none)
    {
        ExplosionObject = new ExplosionTemplate.Class (ExplosionTemplate);
        ExplosionActor = Locator.Spawn(Class'EvilExplosionActor', Locator,, Locator.Location);
        ExplosionObject.HitNormal = Vector(Locator.Rotation);
        ExplosionActor.Explode(ExplosionObject);
    }
    //return;    
}

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Locator",LinkVar="None",PropertyName="Locator",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Spawn Explosion"
}