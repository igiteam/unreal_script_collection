class MOHAMPTriggerVolume extends TriggerVolume
    hidecategories(Navigation,Object,Movement,Display);

var() MPObjective AssociatedMPObjective;

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    super(Actor).Touch(Other, OtherComp, HitLocation, HitNormal);
    // End:0x77
    if(Other.IsA('MOHAMultiplayerPawn') && MOHAMultiplayerPawn(Other).Controller != none)
    {
        MOHAMultiplayerController(MOHAMultiplayerPawn(Other).Controller).MPObjectiveTouch(AssociatedMPObjective);
    }
    //return;    
}

simulated event UnTouch(Actor Other)
{
    super(Actor).UnTouch(Other);
    // End:0x63
    if(Other.IsA('MOHAMultiplayerPawn') && MOHAMultiplayerPawn(Other).Controller != none)
    {
        MOHAMultiplayerController(MOHAMultiplayerPawn(Other).Controller).MPObjectiveClear();
    }
    //return;    
}

defaultproperties
{
    BrushColor=(R=100,G=200,B=100,A=255)
    // Reference: BrushComponent'Default__MOHAMPTriggerVolume.BrushComponent0'
    begin object name=BrushComponent0
    end object
    BrushComponent=BrushComponent0
    Components[0]=BrushComponent0
    CollisionComponent=BrushComponent0
    CollisionType=0
}