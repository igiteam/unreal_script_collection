class SPDefendAreaVolume extends TriggerVolume
    native;

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    local SPPawn spPawnage;
    local SPAIController spAI;

    super(Actor).Touch(Other, OtherComp, HitLocation, HitNormal);
    spPawnage = SPPawn(Other);
    // End:0x66
    if((spPawnage != none) && spPawnage.Controller != none)
    {
        spAI = SPAIController(spPawnage.Controller);
    }
    // End:0x9A
    if(spAI != none)
    {
        // End:0x9A
        if(spAI.IsDefendingTriggerVolume(self))
        {
            spAI.SetHasBeenInDefendArea(true);
        }
    }
    //return;    
}
