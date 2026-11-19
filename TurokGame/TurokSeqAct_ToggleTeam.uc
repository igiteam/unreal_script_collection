class TurokSeqAct_ToggleTeam extends SequenceAction
    hidecategories(Object);

struct InstigatorInfo
{
    var int mTeamIndex;
    var bool mHasTeamConflict;

    structdefaultproperties
    {
        mTeamIndex=0
        mHasTeamConflict=false
    }
};

function GetInstigatorTeamInfo(out @NULL Info)
{
    local array objInstigators;
    local int TeamIndex, idx;
    local @NULL currPawn;
    local int currControllerTeamID;

    Info.mTeamIndex = 255;
    Info.mHasTeamConflict = false;
    TeamIndex = -1;
    GetObjectVars(objInstigators, "Instigator");
    idx = 0;
    J0x4D:

    // End:0x103 [Loop If]
    if(idx < objInstigators.Length)
    {
        currPawn = Pawn(objInstigators[idx]);
        // End:0x81
        if(currPawn == none)
        {
            // [Explicit Continue]
            goto J0xF9;
        }
        // End:0xF9
        if(currPawn.Controller != none)
        {
            currControllerTeamID = int(currPawn.Controller.GetTeamNum());
            // End:0xD6
            if(TeamIndex == -1)
            {
                TeamIndex = currControllerTeamID;
                // [Explicit Continue]
                goto J0xF9;
            }
            // End:0xF9
            if(TeamIndex != currControllerTeamID)
            {
                Info.mHasTeamConflict = true;
                return;
            }
        }
        J0xF9:

        idx++;
        // [Loop Continue]
        goto J0x4D;
    }
    // End:0x127
    if(TeamIndex != -1)
    {
        Info.mTeamIndex = TeamIndex;
    }
    //return;    
}

defaultproperties
{
    InputLinks[0]=(LinkDesc="Set",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,DrawY=0,bHidden=false)
    InputLinks[1]=(LinkDesc="Clear",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,DrawY=0,bHidden=false)
    InputLinks[2]=(LinkDesc="Toggle",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,DrawY=0,bHidden=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Instigator",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="None",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    ObjName="Toggle Team"
    ObjCategory="Turok Multiplayer"
}