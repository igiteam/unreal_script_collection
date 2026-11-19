//=============================================================================
class ObjectiveInteraction extends Input
	within GameViewportClient
	native
	config(Input)
	transient
    inherits(FExec);

enum EObjectivePointColors
{
    Red,
    Blue,
    Green,
    Yellow,
    Orange,
};

enum EObjectiveType
{
    Primary,
    Secondary,
};

struct native ObjectiveProperties        
{
    var string ObjectiveText;
    var vector ObjectivePosition;
    var EObjectiveType ObjectiveType;
    var int Priority;
    var EObjectivePointColors ObjectiveColors;
    var bool bObjectivePosition;
    var bool bCompleted;
    var bool bHide;  
    var int count;  
    
	structdefaultproperties
	{
        bObjectivePosition=false;
        bCompleted=false;
        bHide=false;
	}      
};

var array<ObjectiveProperties>ObjectiveList;
var int ObjectiveCount;
var Pawn m_thePawn;
var bool bIsActive;
var bool bToggleObjectiveScreen;

var array<Texture2D> NavIndicatorIcon;
var Texture2D NotebookTexure;
var array<Texture2D> LevelMap;

var TPPlayerController TPC;

var float ElapsedTime;
var bool bObjectiveAddedText;
var bool bObjectiveCompletedText;





struct native ObjectiveElementDrawFlags
{
	var() bool bDrawObjectiveMessages;
	
	structdefaultproperties
	{
		bDrawObjectiveMessages=true
	}
	
};

var ObjectiveElementDrawFlags DrawFlags;


///////////////////////////////////////////////////////////////////
// These are the actual dimensions of the world map in unreal units
///////////////////////////////////////////////////////////////////
//
//    |--------(X1,Y1)
//    |           |
//    | VSLICEMAP |
//    |           |
//  (X0,Y0)-------|








/**
 * Process an input key event routed through unrealscript from another object. This method is assigned as the value for the
 * OnRecievedNativeInputKey delegate so that native input events are routed to this unrealscript function.
 *
 * @param	ControllerId	the controller that generated this input key event
 * @param	Key				the name of the key which an event occured for (KEY_Up, KEY_Down, etc.)
 * @param	EventType		the type of event which occured (pressed, released, etc.)
 * @param	AmountDepressed	for analog keys, the depression percent.
 *
 * @return	true to consume the key event, false to pass it on.
 */
function bool InputKey( int ControllerId, name Key, EInputEvent Event, float AmountDepressed = 1.f, bool bGamepad = FALSE )
{
	return false;
}

function PostRender(Canvas Canvas)
{
	Canvas.SetDrawColor( 255, 255, 255, 255 );
	
	Canvas.Font = class'Engine'.Static.GetSmallFont();
		
	Canvas.SetPos(30, 30);
	
	if( DrawFlags.bDrawObjectiveMessages )
	{
		if(bObjectiveAddedText)
			Canvas.DrawText("Objective Added");
		else if(bObjectiveCompletedText)
			Canvas.DrawText("Objective Completed"); 
		else
			Canvas.DrawText("");     
	}
}

//Base tick event
event Tick(float DeltaTime)
{
	if(bObjectiveAddedText || bObjectiveCompletedText)
        ElapsedTime += DeltaTime;
    
    if(ElapsedTime > 3.0)
	{
       bObjectiveAddedText = false;
       bObjectiveCompletedText = false; 
       ElapsedTime = 0;
    }	
}

function DrawNavPoints(Canvas Canvas)
{   
    local int NavIndex;
    local float NavAngle, X1, Y1;
    local float Radius;
    
    // The radius is hard coded to 64 because the size of the compass is 128
    // Needs to be changed later
    Radius = Canvas.SizeX/16;

    // Draw nav points on the compass
    for(NavIndex=0; NavIndex < ObjectiveCount; NavIndex++)
    {
        if(!ObjectiveList[NavIndex].bCompleted && ObjectiveList[NavIndex].bObjectivePosition)
        { 
            NavAngle = GetNavPointAngle(ObjectiveList[NavIndex].ObjectivePosition);
            
            ConvertPolarToCartesian(NavAngle, Radius, X1, Y1);
            //`log("X1 is "@X1);
            //`log("Y1 is "@Y1);18.2857
            Canvas.SetOrigin((0.04*Canvas.SizeX)+(Canvas.SizeX/18.3), (0.80 * Canvas.SizeY)+(Canvas.SizeX/18.0));
            Canvas.SetPos(X1,Y1);
            Canvas.DrawTile(NavIndicatorIcon[ObjectiveList[NavIndex].ObjectiveColors], Canvas.SizeX/68.27, Canvas.SizeX/68.27, 0, 0, 32, 32);
            Canvas.SetOrigin(0,0);
        }
    }  
}

function ConvertPolarToCartesian(float Angle, float Radius, out float X, out float Y)
{

    X = Radius * (cos(Angle));
    Y = Radius * (sin(Angle));
}

// Get the nav point angle based on player position 
function float GetNavPointAngle(vector ObjectivePosition)
{
    local float NavAngle, NormLookAt, NormCamToNav, NormY;
    local vector CamLoc, CamToNav, CamLookAt, Y, Z;
    local rotator CamRot;
    local float RightHalf;

    TPC.PlayerCamera.GetCameraViewPoint(CamLoc, CamRot);
    
    CamToNav.X = (ObjectivePosition.X - CamLoc.X); 
    CamToNav.Y = (ObjectivePosition.Y - CamLoc.Y);
    CamToNav.Z = 0;
    
    GetAxes(CamRot, CamLookAt, Y, Z);
    NormCamToNav = sqrt(CamToNav.X * CamToNav.X + CamToNav.Y * CamToNav.Y);  
    CamLookAt.Z = 0;
    NormLookAt = sqrt(CamLookAt.X * CamLookAt.X + CamLookAt.Y * CamLookAt.Y); 
    NavAngle = ( CamLookAt dot CamToNav) / (NormLookAt * NormCamToNav);
    NavAngle = ACos(NavAngle);
    
    NormY = sqrt(Y.X * Y.X + Y.Y * Y.Y);
    RightHalf = (Y dot CamToNav) / (NormY * NormCamToNav);
    
    // rotate navangle position
    if(RightHalf >= -1 && RightHalf <= 0)
    {
        return (-NavAngle - 1.5707963265);
    }
    else
        return (NavAngle - 1.5707963265);
                
}

// Recieves new Objective Text from Kismet 
event AddObjectiveText( string ObjectiveText,      
                           vector ObjectivePosition, 
                           EObjectiveType ObjectiveType, 
                           int Priority, 
                           EObjectivePointColors ObjectiveColors,
                           optional bool bObjectivePosition)
{        
    bObjectiveAddedText = true;
    
    ObjectiveList.Insert(ObjectiveCount,1);
    ObjectiveList[ObjectiveCount].ObjectiveText = ObjectiveText;
    ObjectiveList[ObjectiveCount].ObjectivePosition = ObjectivePosition;
    ObjectiveList[ObjectiveCount].ObjectiveType = ObjectiveType;
    ObjectiveList[ObjectiveCount].Priority = Priority;
    ObjectiveList[ObjectiveCount].ObjectiveColors = ObjectiveColors;
    ObjectiveList[ObjectiveCount].count = ObjectiveCount;
    ObjectiveList[ObjectiveCount].bObjectivePosition = bObjectivePosition;
    ObjectiveCount++;
   
    SortObjectiveList();
}

// 
event CompletedObjective(string ObjectiveText, vector ObjectivePosition, bool bObjectiveCompleted)
{
    local int i;
    
    bObjectiveCompletedText = true;
    
    for(i=0; i<ObjectiveList.Length; i++)
    {
        if(ObjectiveList[i].ObjectiveText == ObjectiveText && ObjectiveList[i].ObjectivePosition == ObjectivePosition)
        {
            ObjectiveList[i].bCompleted = bObjectiveCompleted;
            break;
        }
    }
}

event HideObjective(string ObjectiveText, vector ObjectivePosition, bool bHide)
{
    local int i;
    
    for(i=0; i<ObjectiveList.Length; i++)
    {
        if(ObjectiveList[i].ObjectiveText == ObjectiveText && ObjectiveList[i].ObjectivePosition == ObjectivePosition)
        {
            ObjectiveList[i].bHide = bHide;
            break;
        }
    }
}    

// Quick bubble sort of the objective list 
function SortObjectiveList()
{
    local int i,j;
    local ObjectiveProperties TempObjectives; 
      
    if(ObjectiveCount > 1)
    {
        // sorts the primary and secondary objectives
        for(i=0; i<ObjectiveCount-1; i++)
        {
            if( ObjectiveList[i].ObjectiveType > ObjectiveList[i+1].ObjectiveType ) 
			{
				//SwapObjectives(ObjectiveList[i], ObjectiveList[i+1]);
				
				TempObjectives= ObjectiveList[i]; 
				ObjectiveList[i]= ObjectiveList[i+1]; 
				ObjectiveList[i+1] = TempObjectives;

			}
		}
		// sorts primary objectives
        for(i=0; i<ObjectiveCount; i++)
	    {
		    for(j=0; j<ObjectiveCount-1; j++)
		    {
			    if(ObjectiveList[j].Priority > ObjectiveList[j+1].Priority && (ObjectiveList[j+1].ObjectiveType != Secondary))
			    {
                    //SwapObjectives(ObjectiveList[j], ObjectiveList[j+1]);
                    
					TempObjectives= ObjectiveList[j]; 
					ObjectiveList[j]= ObjectiveList[j+1]; 
					ObjectiveList[j+1] = TempObjectives;
                    
			    }
		    }
	    }
		// sorts secondary objectives
        for(i=0; i<ObjectiveCount; i++)
	    {
		    for(j=0; j<ObjectiveCount-1; j++)
		    {
			    if(ObjectiveList[j].Priority > ObjectiveList[j+1].Priority && (ObjectiveList[j].ObjectiveType != Primary))
			    {
                    //SwapObjectives(ObjectiveList[j], ObjectiveList[j+1]);
                    
					TempObjectives= ObjectiveList[j]; 
					ObjectiveList[j]= ObjectiveList[j+1]; 
					ObjectiveList[j+1] = TempObjectives;
                    
			    }
		    }
	    }
	}     
}

//No longer allowed to pass a dynamic array element as the value for an out parameter (codedrop 150030)
//function SwapObjectives(out ObjectiveProperties ObjectiveListA, out ObjectiveProperties ObjectiveListB) 
//{
//    local ObjectiveProperties TempObjectives; 
//    
//    TempObjectives= ObjectiveListA; 
//	ObjectiveListA= ObjectiveListB; 
//	ObjectiveListB = TempObjectives;
//}

state Inactive
{
	simulated event BeginState(name PreviousStateName)
	{
       bIsActive = false;
	}
}

function Toggle( PlayerPawn thePawn)
{
    if (bIsActive)
    	GotoState('Inactive');
    else
    	GotoState('Active');

    m_thePawn = thePawn;
}


state Active
{
	simulated event BeginState(name PreviousStateName)
	{
        bIsActive = true;
        
	}
	simulated event EndState(name NextStateName)
	{
	}

	event Tick(float DeltaTime)
	{
	}
	
	function bool InputKey( int ControllerId, name Key, EInputEvent Event, float AmountDepressed = 1.f, bool bGamepad = FALSE )
	{
		//`log("bluff key=" @ Key);

		if( event == IE_Pressed )
		{
			if(Key == 'D' || Key == 'XboxTypes_DPad_Right' || Key == 'A' ||  Key == 'XboxTypes_DPad_Left')
			{
                ToggleObjectiveScreen();
                return true;
			}
		}
		
		//absorb 
		return false;	      
	}
	
    // This looks like poo - Fix later
/*	event bool InputAxis(int ControllerId,name Key,float Delta,float DeltaTime,bool bGamepad)
	{
		if(Delta > 0.5 || Delta < -0.5)
		{
            if(Key=='XboxTypeS_LeftX')
                ToggleObjectiveScreen();
            return true;
		}


		//absorb
		return true;
	} */
	
	function ToggleObjectiveScreen()
	{
	    bToggleObjectiveScreen = !bToggleObjectiveScreen;
    }
             	   

	function PostRender(Canvas Canvas)
	{
        //if(bToggleObjectiveScreen)
        //{           
            RenderObjectiveList(Canvas);
        //}
        //else
        //{
        //    RenderLevelMap(Canvas);
        //}
    }
    
    function RenderLevelMap(Canvas Canvas)
    {
        local int i;
        local vector MapCoordinates, CamLoc;
        local rotator CamRot;             
        
        Canvas.SetDrawColor( 255, 255, 255, 255 );
        Canvas.SetPos(0,0);
        Canvas.DrawTile(LevelMap[0],Canvas.SizeX, Canvas.SizeY, 0,0, 1024,1024);
        
        // draw active nav points
        for(i=0; i<ObjectiveCount; i++)
        {
            if(ObjectiveList[i].bObjectivePosition && !ObjectiveList[i].bCompleted)
            {
                MapCoordinates = ConvertWorldSpaceTo2D(ObjectiveList[i].ObjectivePosition.X, ObjectiveList[i].ObjectivePosition.Y, Canvas);
                Canvas.SetOrigin(Canvas.SizeX/5.3894,Canvas.SizeX/4.61261);
                Canvas.SetPos(MapCoordinates.X, MapCoordinates.Y);
                Canvas.DrawTile(NavIndicatorIcon[ObjectiveList[i].ObjectiveColors], Canvas.SizeX/51.2, Canvas.SizeX/51.2, 0, 0, 32, 32);
            }     
        } 
        
        // draw player position on the map
        TPC.PlayerCamera.GetCameraViewPoint(CamLoc, CamRot);
        CamLoc = ConvertWorldSpaceTo2D(CamLoc.X, CamLoc.Y, Canvas);
        Canvas.SetPos(CamLoc.X, CamLoc.Y);
       
        Canvas.SetDrawColor( 0, 0, 0, 255 );
        Canvas.Font = class'Engine'.Static.GetMediumFont();
        Canvas.DrawText("P");
        Canvas.SetOrigin(0,0);                
    } 
    
    // This only works for the vertical slice at the moment which is pretty poopie
    function vector ConvertWorldSpaceTo2D(float ObjPosX, float ObjPosY, Canvas Canvas)
    {
        local vector MapCoordinates;
        local float PctX, PctY;
        
        // Unreal axis' are retarded so invert the  X and Y
        PctX = (-11821- ObjPosY)/27068;
        PctY = (430- ObjPosX)/43955;
        
        // This is based on the viewable size of the vertical slice map texture
        // (190,222)-----|
        //  |            |
        //  |-----(868,822)
        MapCoordinates.X = Abs(Canvas.SizeX/1.5103 * PctX); 
        MapCoordinates.Y = Abs(Canvas.SizeX/1.7067 * PctY);
                
        return MapCoordinates;
    }
    
    function RenderObjectiveList(Canvas Canvas)
    {
        local int i,j;
        local float PosX, PosY;
        local float xl, yl;
        local bool bPrintPrimary, bPrintSecondary;
        local string s;
        
        // init
        PosX = 0;
        PosY = 0;
        bPrintSecondary=false;
        bPrintPrimary=false;
        
        Canvas.SetDrawColor(255, 255, 255, 255); //this affects the textures too

	    // Draw the notebook background
	    Canvas.SetPos(PosX,PosY);
	    Canvas.DrawTile(NotebookTexure,Canvas.SizeX, Canvas.SizeY, 0,0, 1024,1024);
        
        //reset the origin
	    Canvas.SetOrigin( (Canvas.SizeX/3.2), (Canvas.SizeX/5.12) );         
        
        
        // Print Objective List
        for(i=0; i<ObjectiveCount; i++)
        {
            if(!ObjectiveList[i].bHide)
            {
                if(ObjectiveList[i].ObjectiveText != "")
                {                         
                    Canvas.SetDrawColor(0, 0, 0, 255); //this affects the textures too
                    // Print the Primary objective header
                    if(!bPrintPrimary && ObjectiveList[i].ObjectiveType == Primary)
                    {
                        Canvas.Font = class'Engine'.Static.GetMediumFont();
                        Canvas.SetPos(0,0);
                        Canvas.DrawText("Primary Objectives");
                        PosY+=30;
                        bPrintPrimary=true;
                    }
                    
                    // Print the Secondary objective header
                    if(!bPrintSecondary && ObjectiveList[i].ObjectiveType == Secondary)
                    {
                        Canvas.Font = class'Engine'.Static.GetMediumFont();
                        Canvas.SetPos(0,PosY);
                        Canvas.DrawText("Secondary Objectives");
                        PosY+=30;
                        bPrintSecondary=true;
                    }
                    
                    Canvas.SetPos(PosX, PosY);
                    Canvas.Font = class'Engine'.Static.GetSmallFont();
                    if(ObjectiveList[i].bObjectivePosition)
                    {
                        Canvas.SetDrawColor(255, 255, 255, 255);
                        Canvas.DrawTile(NavIndicatorIcon[ObjectiveList[i].ObjectiveColors], 12, 12, 0, 0, 32, 32);

                    }
                    Canvas.SetDrawColor(0, 0, 0, 255); //this affects the textures too
                    s=(" "@ObjectiveList[i].ObjectiveText);
                    Canvas.DrawText(s);
                    
                    if(ObjectiveList[i].bCompleted)
                    {
                        Canvas.StrLen(ObjectiveList[i].ObjectiveText,xl,yl);
                        for(j=0; j<xl-1; j++)
                        {
                            Canvas.SetPos(PosX+j, PosY);
                            Canvas.DrawText("-",false);
                        }
                    }
                    PosY+=20; 
                }      
            }
        }
        Canvas.SetOrigin(0,0);
    }

	event bool InputChar(int ControllerId,string Unicode)
	{
		//absorb
		return true;
	}
}

function ClearAllObjectives()
{
    local int i;
    
    //`log("Clearing all objectives");
    for(i=0; i<ObjectiveList.Length; i++)
    {   
        ObjectiveList.Remove(i--,1);
    }
    ObjectiveCount=0;
}

/**
 * Called when the Interaction is added to the GameViewportClient's Interactions array.
 */
function Initialized()
{
	// initialize the Objective counter
    ObjectiveCount = 0;
    
    GotoState('Inactive');
    Super.Initialized();
}

function GetPlayerController(TPPlayerController PlayerController)
{
    TPC = PlayerController;
}


function NotifyGameSessionEnded()
{
	m_thePawn = None;
	TPC = none;
    
    ClearAllObjectives();
    
	super.NotifyGameSessionEnded();
}



