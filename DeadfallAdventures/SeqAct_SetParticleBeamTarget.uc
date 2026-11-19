class SeqAct_SetParticleBeamTarget extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() bool bDetachTarget;
var BeamTargetPoint BeamTarget;
var() name ParticleParamName;
var Emitter Particle;

event Activated()
{
    // End:0x1E
    if(self.BeamTarget == none)
    {
        return;
    }
    // End:0x65
    if(self.bDetachTarget)
    {
        self.BeamTarget.ParentParticle = none;
    }
    // End:0xA9
    if((self.Particle == none) || self.ParticleParamName == 'None')
    {
        return;
    }
    self.BeamTarget.ParticleParamName = self.ParticleParamName;
    self.BeamTarget.ParentParticle = self.Particle;
    //return;    
}

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Emitter",LinkVar="None",PropertyName="Particle",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="BeamTargetPoint",LinkVar="None",PropertyName="BeamTarget",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Set Particle Beam Target"
}