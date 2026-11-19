class EvilObjectives extends Info
    hidecategories(Navigation,Movement,Collision);

enum ObjectiveState
{
    OS_NotStarted,                  // 0
    OS_InProgress,                  // 1
    OS_Complete,                    // 2
    OS_Failed,                      // 3
    OS_MAX                          // 4
};

struct native WaypointInfo
{
    var Actor Target;
    var bool Hidden;

    structdefaultproperties
    {
        Target=none
        Hidden=false
    }
};

struct native ObjectiveInfo
{
    var const localized string Id;
    var const localized string ShortName;
    var const localized string Description;
    var EvilObjectives.ObjectiveState State;
    var Actor Target;
    var bool Main;
    var bool Hidden;

    structdefaultproperties
    {
        Id=""
        ShortName=""
        Description=""
        State=ObjectiveState.OS_NotStarted
        Target=none
        Main=false
        Hidden=false
    }
};

var WaypointInfo Waypoint;
var array<ObjectiveInfo> Objectives;
var array<ObjectiveInfo> ActiveObjectives;
var const localized string NewObjective;
var const localized string CompletedObjective;
var ObjectiveInfo DefaultObjective;

function SetWaypoint(bool Hidden, optional Actor Target = none)
{
    // End:0x3A
    if(Target != none)
    {
        Waypoint.Target = Target;
    }
    Waypoint.Hidden = Hidden;
    //return;    
}

function RestartObjectives()
{
    local ObjectiveInfo Obj;

    // End:0x55
    foreach Objectives(Obj)
    {
        Obj.Target = none;
        Obj.State = 0;        
    }    
    StartObjective("default", none, true);
    //return;    
}

function StartObjective(string Code, Actor Target, optional bool Main = false, optional bool Hidden = false, optional bool verbose = true)
{
    local Controller Player;
    local int Id;

    // End:0xAB
    if(Code != "default")
    {
        Id = Objectives.Find('Id', "default");        
        // End:0xAB
        if(Id != -1)
        {
            Objectives[Id].State = 0;
            ActiveObjectives.RemoveItem(Objectives[Id]);            
        }
    }
    Id = Objectives.Find('Id', Code);    
    // End:0x2E6
    if(Id != -1)
    {
        // End:0x2E6
        if(int(Objectives[Id].State) != int(1))
        {
            // End:0x209
            if(verbose)
            {
                // End:0x208
                foreach Class'Engine.WorldInfo'.static.GetWorldInfo().AllControllers(Class'Engine.Controller', Player)
                {
                    EvilGFxHudWrapper(PlayerController(Player).myHUD).HudMovie.AddMessage("text", (NewObjective $ ": ") $ Objectives[Id].ShortName);                    
                }                
            }
            Objectives[Id].Target = Target;
            Objectives[Id].State = 1;
            Objectives[Id].Main = Main;
            Objectives[Id].Hidden = Hidden;
            ActiveObjectives.AddItem(Objectives[Id]);            
        }
    }
    //return;    
}

function CompleteObjective(string Code, optional bool verbose = true)
{
    local PlayerController Player;
    local int Id;

    // End:0x1E
    if(Code == "default")
    {
        return;
    }
    Id = Objectives.Find('Id', Code);    
    // End:0x24D
    if(Id != -1)
    {
        // End:0x24D
        if(int(Objectives[Id].State) == int(1))
        {
            // End:0x1D3
            if(verbose)
            {
                // End:0x1D2
                foreach Class'Engine.WorldInfo'.static.GetWorldInfo().AllControllers(Class'Engine.PlayerController', Player)
                {
                    EvilGFxHudWrapper(Player.myHUD).HudMovie.AddMessage("text", (CompletedObjective $ ": ") $ Objectives[Id].ShortName);
                    EvilGame(Player.WorldInfo.Game).ScoreCompleteObjective(Player, 1000);                    
                }                
            }
            Objectives[Id].State = 2;
            Id = ActiveObjectives.Find('Id', Code);            
            // End:0x24D
            if(Id != -1)
            {
                ActiveObjectives.Remove(Id, 1);                
            }
        }
    }
    // End:0x2C2
    if(ActiveObjectives.Length < 1)
    {
        Id = Objectives.Find('Id', "default");        
        // End:0x2C2
        if(Id != -1)
        {
            Objectives[Id].State = 1;
        }
    }
    //return;    
}

function LogAllActiveObjectives()
{
    local ObjectiveInfo Obj;

    // End:0x18
    foreach ActiveObjectives(Obj)
    {        
    }    
    //return;    
}
