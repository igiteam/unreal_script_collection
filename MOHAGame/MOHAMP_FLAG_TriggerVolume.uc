class MOHAMP_FLAG_TriggerVolume extends TriggerVolume
    hidecategories(Navigation,Object,Movement,Display);

var() MPObjective_FLAG AssociatedMPObjective_FLAG;

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    super(Actor).Touch(Other, OtherComp, HitLocation, HitNormal);
    // End:0x35
    if(int(WorldInfo.NetMode) == int(NM_Client))
    {
        return;
    }
    // End:0xB9
    if(Other.IsA('MOHAMultiplayerPawn') && MOHAMultiplayerPawn(Other).Controller != none)
    {
        // End:0xB9
        if(MOHAMultiplayerController(MOHAMultiplayerPawn(Other).Controller).PlayerReplicationInfo != none)
        {
            AssociatedMPObjective_FLAG.TouchedBy(MOHAMultiplayerController(MOHAMultiplayerPawn(Other).Controller));
        }
    }
    //return;    
}

simulated event UnTouch(Actor Other)
{
    super(Actor).UnTouch(Other);
    // End:0x26
    if(int(WorldInfo.NetMode) == int(NM_Client))
    {
        return;
    }
    // End:0xAA
    if(Other.IsA('MOHAMultiplayerPawn') && MOHAMultiplayerPawn(Other).Controller != none)
    {
        // End:0xAA
        if(MOHAMultiplayerController(MOHAMultiplayerPawn(Other).Controller).PlayerReplicationInfo != none)
        {
            AssociatedMPObjective_FLAG.UnTouchedBy(MOHAMultiplayerController(MOHAMultiplayerPawn(Other).Controller));
        }
    }
    //return;    
}

defaultproperties
{
    BrushColor=(R=100,G=200,B=100,A=255)
    // Reference: BrushComponent'Default__MOHAMP_FLAG_TriggerVolume.BrushComponent0'
    begin object name=BrushComponent0
    end object
    BrushComponent=BrushComponent0
    Components[0]=BrushComponent0
    CollisionComponent=BrushComponent0
}