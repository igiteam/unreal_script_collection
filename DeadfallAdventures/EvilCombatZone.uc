class EvilCombatZone extends Volume
    hidecategories(Navigation,Object,Movement,Display);

var() bool bEnabled;

simulated function OnToggle(SeqAct_Toggle Action)
{
    super.OnToggle(Action);
    // End:0x59
    if(Action.InputLinks[0].bHasImpulse)
    {
        bEnabled = true;        
    }
    else
    {
        // End:0x9F
        if(Action.InputLinks[1].bHasImpulse)
        {
            bEnabled = false;            
        }
        else
        {
            // End:0xEE
            if(Action.InputLinks[2].bHasImpulse)
            {
                bEnabled = !bEnabled;
            }
        }
    }
    //return;    
}

defaultproperties
{
    bEnabled=true
    // Reference: BrushComponent'Default__EvilCombatZone.BrushComponent0'
    begin object name=BrushComponent0
        ReplacementPrimitive=none
    end object
    BrushComponent=BrushComponent0
    Components[0]=BrushComponent0
    bStatic=false
    CollisionComponent=BrushComponent0
}