class MOHAStimulusSender extends Actor
    notplaceable
    hidecategories(Navigation);

var export editinline StimulusComponent Stimulus;

function SendStimulus(name StimulusTemplate, float Lifetime, optional int LodType = 0, optional bool fireOnce, optional bool worldRelative, optional bool ProxySort)
{
    SetTimer(Lifetime);
    // End:0x67
    if(worldRelative)
    {
        Stimulus.AttachSender(StimulusTemplate, StimulusTemplate, Location, rot(0, 0, 0),, LodType, fireOnce, worldRelative, ProxySort);        
    }
    else
    {
        Stimulus.SetProxyActor(self);
        Stimulus.AttachSender(StimulusTemplate, StimulusTemplate, vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0),, LodType, fireOnce, worldRelative, ProxySort);
    }
    //return;    
}

simulated function Timer()
{
    Destroy();
    //return;    
}

defaultproperties
{
    // Reference: StimulusComponent'Default__MOHAStimulusSender.Stimulus0'
    begin object name=Stimulus0 class=Class'EAKynapse.StimulusComponent'
    end object
    Stimulus=Stimulus0
    Components[0]=Stimulus0
    CollisionType=0
}