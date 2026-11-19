class UIAction_GiveUIStatValues extends UIAction
    hidecategories(Object);

var MOHAPlayerController Player;

function Activated()
{
    local MOHAPlayerController localPlayerController;

    // End:0x42
    foreach GetWorldInfo().DynamicActors(Class'MOHAPlayerController', localPlayerController)
    {
        // End:0x41
        if(NetConnection(localPlayerController.Player) == none)
        {
            Player = localPlayerController;
            // End:0x42
            break;
        }        
    }    
    SeqVar_String(VariableLinks[0].LinkedVariables[0]).StrValue = string(Player.playerStats.GetShotsFired());
    SeqVar_String(VariableLinks[1].LinkedVariables[0]).StrValue = string(Player.playerStats.GetShotsHit());
    SeqVar_String(VariableLinks[2].LinkedVariables[0]).StrValue = string(Player.playerStats.GetKills());
    //return;    
}

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_String',LinkedVariables=none,LinkDesc="Shots Fired",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_String',LinkedVariables=none,LinkDesc="Shots Hit",LinkVar="None",PropertyName="None",bWriteable=true,bHidden=true,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[2]=(ExpectedType=Class'Engine.SeqVar_String',LinkedVariables=none,LinkDesc="Kills",LinkVar="None",PropertyName="GamepadID",bWriteable=true,bHidden=true,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    ObjName="Get Stats"
}