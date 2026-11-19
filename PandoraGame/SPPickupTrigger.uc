class SPPickupTrigger extends Trigger;

simulated function Tick(float DeltaTime)
{
    super(Actor).Tick(DeltaTime);
    // End:0x44
    if((Owner != none) && Owner.Location != Location)
    {
        SetLocation(Owner.Location);
    }
    //return;    
}
