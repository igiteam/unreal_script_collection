class BeamTargetPoint extends TargetPoint
    hidecategories(Navigation);

var() Emitter ParentParticle;
var() name ParticleParamName;

event Tick(float DeltaTime)
{
    // End:0x59
    if((self.ParentParticle != none) && self.ParticleParamName != 'None')
    {
        self.UpdateParticleBeam();
    }
    super(Actor).Tick(DeltaTime);
    //return;    
}

protected function UpdateParticleBeam()
{
    self.ParentParticle.ParticleSystemComponent.SetVectorParameter(self.ParticleParamName, self.Location);
    //return;    
}
