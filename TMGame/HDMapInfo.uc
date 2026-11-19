//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDMapInfo extends TMMapInfo;

var array<Pawn>    TeamPawn;
var HDGFxTeamMiniMap HDGFxTeamMiniMap;

//Draw GFx
    simulated function DrawGFxMap()
    {
     HDGFxTeamMiniMap.UpdataInfo();
    }
    simulated function DrawTaskTip()
    {
        if(CurrentTaskTipHud != none)
            {
            CurrentTaskTipHud.TaskTip.UpdataInfo(bTaskTipAutoClose);
            }
    }
    simulated function SetTaskTip(float X)
    {
        if(CurrentTaskTipHud != none)
            {
            CurrentTaskTipHud.TaskTip.SetRootMC(X);
            }
    }
