class MOHAUIMap extends UIObject
    native
    hidecategories(Object,UIRoot,Object);

const MAX_FLOORS = 5;

var export editinlineuse UITexture FloorTextures[5];
var(Textures) noclear const export editinline UIComp_DrawImage BaseMap;
var(Textures) noclear const export editinline UIComp_DrawImage PlayerIcon;
var(Textures) noclear const export editinline UIComp_DrawImage ObjectiveIcon;
var(Textures) noclear const export editinline UIComp_DrawImage SelectedObjectiveIcon;
var(Textures) noclear const export editinline UIComp_DrawImage ObjectiveCompleteIcon;
var(Textures) noclear const export editinline UIComp_DrawImage SelectedObjectiveCompleteIcon;
var TextureCoordinates TexCoordinates;
var int PlayerSize;
var int HalfPlayerSize;
var int ObjectiveSize;
var int HalfObjectiveSize;
var float Width;
var float Height;
var float MapX;
var float MapY;
var float MapWidth;
var float MapHeight;
var float FloorX;
var float FloorY;
var float FloorWidth;
var float FloorHeight;
var float PlayerX;
var float PlayerY;
var float PlayerZ;
var int NumFloors;
var int CurrentFloor;
var float ObjHeightThreshold;
var float HeightAlphaMod;
var bool RenderObjectives;

// Export UMOHAUIMap::execSetBaseMap(FFrame&, void* const)
native function SetBaseMap(Surface NewImage);

function OnSetMapGroundTexture(UIAction_SetMapGroundTexture Action)
{
    SetBaseMap(Action.NewTexture);
    MapX = Action.X;
    MapY = Action.Y;
    MapWidth = Action.Width;
    MapHeight = Action.Height;
    //return;    
}

function OnSetMapFloorTexture(UIAction_SetMapFloorTexture Action)
{
    // End:0x0C
    if(NumFloors < 5)
    {
    }
    //return;    
}

function OnSetMapFloorCoords(UIAction_SetMapFloorCoords Action)
{
    FloorX = Action.X;
    FloorY = Action.Y;
    FloorWidth = Action.Width;
    FloorHeight = Action.Height;
    //return;    
}

function OnSetMapFloor(UIAction_SetMapFloor Action)
{
    CurrentFloor = Action.Floor;
    //return;    
}

function OnGetMapCurrentFloor(UIAction_GetMapCurrentFloor Action)
{
    // End:0x6D
    if(Action != none)
    {
        SeqVar_String(Action.VariableLinks[1].LinkedVariables[0]).StrValue = ("<Strings:UIStrings.GeneralStrings.Floor" $ string(CurrentFloor)) $ ">";
    }
    //return;    
}

function OnToggleUIMapRender(UIAction_ToggleUIMapRender Action)
{
    RenderObjectives = Action.bRenderObjectives;
    //return;    
}

event FillPlayerPosition()
{
    local PlayerController localPlayerController;

    // End:0xCE
    foreach GetScene().GetWorldInfo().DynamicActors(Class'Engine.PlayerController', localPlayerController)
    {
        // End:0xCD
        if(NetConnection(localPlayerController.Player) == none)
        {
            // End:0xCA
            if(localPlayerController.Pawn != none)
            {
                PlayerX = localPlayerController.Pawn.Location.X;
                PlayerY = localPlayerController.Pawn.Location.Y;
                PlayerZ = localPlayerController.Pawn.Location.Z;
            }
            // End:0xCE
            break;
        }        
    }    
    //return;    
}

defaultproperties
{
    // Reference: UIComp_DrawImage'Default__MOHAUIMap.BaseMapTemplate'
    begin object name=BaseMapTemplate class=Class'Engine.UIComp_DrawImage'
    end object
    BaseMap=BaseMapTemplate
    // Reference: UIComp_DrawImage'Default__MOHAUIMap.PlayerIconTemplate'
    begin object name=PlayerIconTemplate class=Class'Engine.UIComp_DrawImage'
    end object
    PlayerIcon=PlayerIconTemplate
    // Reference: UIComp_DrawImage'Default__MOHAUIMap.ObjectiveIconTemplate'
    begin object name=ObjectiveIconTemplate class=Class'Engine.UIComp_DrawImage'
    end object
    ObjectiveIcon=ObjectiveIconTemplate
    // Reference: UIComp_DrawImage'Default__MOHAUIMap.SelectedObjectiveIconTemplate'
    begin object name=SelectedObjectiveIconTemplate class=Class'Engine.UIComp_DrawImage'
    end object
    SelectedObjectiveIcon=SelectedObjectiveIconTemplate
    // Reference: UIComp_DrawImage'Default__MOHAUIMap.ObjectiveCompleteIconTemplate'
    begin object name=ObjectiveCompleteIconTemplate class=Class'Engine.UIComp_DrawImage'
    end object
    ObjectiveCompleteIcon=ObjectiveCompleteIconTemplate
    // Reference: UIComp_DrawImage'Default__MOHAUIMap.SelectedObjectiveCompleteIconTemplate'
    begin object name=SelectedObjectiveCompleteIconTemplate class=Class'Engine.UIComp_DrawImage'
    end object
    SelectedObjectiveCompleteIcon=SelectedObjectiveCompleteIconTemplate
    PlayerSize=16
    HalfPlayerSize=8
    ObjectiveSize=32
    HalfObjectiveSize=16
    ObjHeightThreshold=300.0000000
    HeightAlphaMod=0.5000000
    RenderObjectives=true
    PrimaryStyle=(DefaultStyleTag="DefaultImageStyle",RequiredStyleClass=Class'Engine.UIStyle_Image')
    bSupportsPrimaryStyle=false
    Position=(ScaleType=6,ScaleType[1]=6,ScaleType[2]=6,ScaleType[3]=6)
    // Reference: UIComp_Event'Default__MOHAUIMap.WidgetEventComponent'
    begin object name=WidgetEventComponent
    end object
    EventProvider=WidgetEventComponent
}