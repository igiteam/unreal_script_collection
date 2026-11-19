class SeqAct_CleanWeaponPickups extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

event Activated()
{
    local WorldInfo WI;
    local EvilTouchPickUp_WeaponBase Pickup;

    WI = Class'Engine.WorldInfo'.static.GetWorldInfo();
    // End:0xB5
    if(WI != none)
    {
        // End:0xB4
        foreach WI.AllActors(Class'EvilGame.EvilTouchPickUp_WeaponBase', Pickup)
        {
            // End:0xB3
            if((Pickup != none) && !Pickup.bDeleteMe)
            {
                Pickup.Destroy();
            }            
        }        
    }
    //return;    
}

defaultproperties
{
    bCallHandler=false
    VariableLinks=none
    ObjName="Clean Weapon Pickups"
}