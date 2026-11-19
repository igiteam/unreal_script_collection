class EvilComboAction_Emitter extends EvilComboAction_Base
    editinlinenew
    hidecategories(Object)
    autoexpandcategories(Action,Emitter);

var(Emitter) ParticleSystem Template;
var(Emitter) bool bPlayOnInstigator;

function float Run(EvilPawn Instigator, out ComboActionState S)
{
    Class'Engine.WorldInfo'.static.GetWorldInfo().MyEmitterPool.SpawnEmitter(Template, S.Location, ((bPlayOnInstigator) ? Instigator.Rotation : S.FirstOther.Rotation));
    return 0.0000000;
    //return ReturnValue;    
}

defaultproperties
{
    bPlayOnInstigator=true
}