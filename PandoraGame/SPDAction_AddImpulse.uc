class SPDAction_AddImpulse extends SPDAction
    editinlinenew
    collapsecategories;

/** STRUCT DECLARATIONS VARIABLE DECLARATIONS */
var(SPDAction) PrimitiveComponent.ERadialImpulseFalloff ImpulseFalloff;
var(SPDAction) float ImpulseDamageDelay;
var(SPDAction) int ImpulseStrength;
var(SPDAction) int ImpulseDamage;
var(SPDAction) class<PandoraDamageType> ImpulseDamageType;
var(SPDAction) float ImpulseRadius;
var(SPDAction) Vector PositionOffset;

event SPDProcessManager.SPDActionState Run(float ElapsedTime, Actor Actor, SPDProcessManager Manager, SPDDamage DamageInfo)
{
    local SPDImpulseActor impulseActor;
    local Vector pos;

    // End:0x2B
    if(Actor == none)
    {
        pos = PositionOffset + DamageInfo.Location;        
    }
    else
    {
        pos = PositionOffset + Actor.Location;
    }
    impulseActor = Manager.Spawn(Class'SPDImpulseActor',,, pos);
    impulseActor.ImpulseComponent.ImpulseFalloff = ImpulseFalloff;
    impulseActor.ImpulseComponent.ImpulseStrength = float(ImpulseStrength);
    impulseActor.ImpulseComponent.ImpulseRadius = ImpulseRadius;
    impulseActor.delay = ImpulseDamageDelay;
    impulseActor.Damage = ImpulseDamage;
    impulseActor.DamageRadius = ImpulseRadius;
    impulseActor.DamageType = ImpulseDamageType;
    impulseActor.ShowDebug = DamageInfo.ShowDebug;
    return 1;
    //return ReturnValue;    
}
