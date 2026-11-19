class SeqAct_R6MovieControl extends SequenceAction
    native
    hidecategories(Object);

var() TextureMovie Movie;

defaultproperties
{
    InputLinks[0]=(LinkDesc="Play",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[1]=(LinkDesc="Pause",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[2]=(LinkDesc="Stop",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[3]=(LinkDesc="Toggle Loop",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[0]=(Links=none,LinkDesc="Playing",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Paused",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[2]=(Links=none,LinkDesc="Stopped",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[3]=(Links=none,LinkDesc="Toggled Loop",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    VariableLinks=none
    ObjName="Movie Controller"
    ObjCategory="PIP"
}