class SPDAction_SpawnLight extends SPDAction_SpawnActor
    editinlinenew
    collapsecategories;

/** VARIABLE DECLARATIONS */
var(SPDAction) float Brightness;
var(SPDAction) Color LightColor;
var(SPDAction) float Radius;

event SPDProcessManager.SPDActionState Run(float ElapsedTime, Actor Actor, SPDProcessManager Manager, SPDDamage DamageInfo)
{
    local SPDLightActor newLight;
    local editinline LightComponent lcomponent;
    local editinline PointLightComponent pComponent;

    newLight = SPDLightActor(CreateActor(Manager, Actor, DamageInfo));
    // End:0xC9
    if(newLight != none)
    {
        lcomponent = newLight.GetLightComponent();
        // End:0xBA
        if(lcomponent != none)
        {
            pComponent = PointLightComponent(lcomponent);
            // End:0x80
            if(pComponent != none)
            {
                pComponent.Radius = Radius;
            }
            lcomponent.SetLightProperties(Brightness, LightColor, lcomponent.Function);
            lcomponent.SetEnabled(true);
        }
        FindBestSpotForSpawnLocation(newLight);
    }
    return 1;
    //return ReturnValue;    
}

defaultproperties
{
    Brightness=1.0000000
    LightColor=(R=255,G=255,B=255,A=0)
    Radius=200.0000000
    bCheckForSpawnCollision=false
    NewActorClass=Class'SPDLightActor'
    Action="Spawn Light"
}