class TurokSkeletalVolume extends TriggerVolume
    native
    hidecategories(Navigation,Object,Movement,Display);

var bool mbVolumeEnabled;

simulated function OnToggle(@NULL Action)
{
    // End:0x29
    if(Action.InputLinks[0].bHasImpulse)
    {
        mbVolumeEnabled = true;        
    }
    else
    {
        // End:0x52
        if(Action.InputLinks[1].bHasImpulse)
        {
            mbVolumeEnabled = false;            
        }
        else
        {
            // End:0x80
            if(Action.InputLinks[2].bHasImpulse)
            {
                mbVolumeEnabled = !mbVolumeEnabled;
            }
        }
    }
    super(Volume).OnToggle(Action);
    //return;    
}

defaultproperties
{
    BrushColor=(R=170,G=240,B=120,A=255)
    // Reference: BrushComponent'Default__TurokSkeletalVolume.BrushComponent0'
    begin object name=BrushComponent0
        CollideActors=false
        BlockNonZeroExtent=false
    end object
    BrushComponent=BrushComponent0
    bWorldGeometry=true
    bCollideActors=false
    bProjTarget=false
    Components[0]=BrushComponent0
    CollisionComponent=BrushComponent0
    SupportedEvents=none
}