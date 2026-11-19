class SeqAct_R6KnockOutPlayer extends SequenceAction
    native
    hidecategories(Object);

defaultproperties
{
    InputLinks[0]=(LinkDesc="Knock Down",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    InputLinks[1]=(LinkDesc="Get Up",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[0]=(Links=none,LinkDesc="Getting Down",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    OutputLinks[1]=(Links=none,LinkDesc="Getting Up",bHasImpulse=false,bDisabled=false,LinkAction="None",DrawY=0,bHidden=false)
    ObjName="Knock Out Player"
    ObjCategory="Player"
}