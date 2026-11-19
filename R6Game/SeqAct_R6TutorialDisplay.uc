class SeqAct_R6TutorialDisplay extends SeqAct_Latent
    native
    hidecategories(Object);

var() string m_VerbTextId;
var string m_ActionTextId;
var() R6EngineEnums.ER6Tutorial m_TutorialScenario;
var() R6GameEnums.ETutorialNodeType m_eType;
var() R6GameEnums.ETutorialAxisInput m_eAxisToAnimate;
var float m_fTimeToShowDescription;
var() bool m_bHideWhenFinished;
var() bool m_bDontShowButtonIcon;
var bool m_bAttachedToVolume;
var bool m_bTutorialFinished;
var bool m_bTutorialActivated;
var bool m_bCancelled;
var bool m_bClosed;
var() array<R6TutMultiTextInfo> m_aExtraDesc;

defaultproperties
{
    m_TutorialScenario=1
    m_fTimeToShowDescription=3.0000000
    m_bHideWhenFinished=true
    InputLinks[0]=(LinkDesc="Activate",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[1]=(LinkDesc="Cancel",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[2]=(LinkDesc="Completed",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[3]=(LinkDesc="Close",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[0]=(Links=none,LinkDesc="Finished",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Cancelled",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="AttachedVolume",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0)
    ObjClassVersion=2
    ObjName="Display Tutorial"
    ObjCategory="Tutorial"
}