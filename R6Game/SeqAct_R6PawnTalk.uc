class SeqAct_R6PawnTalk extends SeqAct_Latent
    native
    hidecategories(Object);

var() /*0x04000000-0x00000000*/ SoundCue m_VoiceLine;
var bool m_bFinished;

// Export USeqAct_R6PawnTalk::execFinished(FFrame&, void* const)
native final function Finished();

// Export USeqAct_R6PawnTalk::execInterrupted(FFrame&, void* const)
native final function Interrupted();

defaultproperties
{
    InputLinks[0]=(LinkDesc="In",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[1]=(LinkDesc="Stop",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="TalkingPawn",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="PawnToFocusOn",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjName="Pawn Talk"
    ObjCategory="Pawn"
}