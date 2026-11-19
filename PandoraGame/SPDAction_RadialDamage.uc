class SPDAction_RadialDamage extends SPDAction
    editinlinenew
    collapsecategories;

var() class<PandoraDamageType> DamageType;
var() float Radius;
var() float Damage;

event SPDProcessManager.SPDActionState Run(float ElapsedTime, Actor Actor, SPDProcessManager Manager, SPDDamage DamageInfo)
{
    Manager.HurtRadius(Damage, Radius, DamageType, 0.0000000, DamageInfo.Location);
    return 1;
    //return ReturnValue;    
}

defaultproperties
{
    Radius=100.0000000
    Damage=1.0000000
    Action="Radial Damage - Damages every actor in a given radius"
}