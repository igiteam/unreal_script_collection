class Compass extends Actor;

const COMPASS_WIDTH = 76;
const COMPASS_SCALE = 1000;
const DOT_WIDTH = 6;

const MAX_WAYPOINTS = 30;

//155/40
const START_X = 157;
const START_Y = 40;

const TOP_WIDTH_1 = 30;
const TOP_WIDTH_2 = 240;
const TOP_SLANT_WIDTH = 14;
const TOP_SLANT_HEIGHT = 7;

const BOTTOM_SLANT_WIDTH = 12;
const BOTTOM_SLANT_HEIGHT = 12;

const BOTTOM_WIDTH = 302;

const SIDE_HEIGHT = 20;
const LINE_WIDTH = 2;

//const NUM_COMPASS_POINTS = 32;
const NUM_COMPASS_POINTS = 64;

const BASE_POS = 30;

const WAY_BASE_X = 200;
const WAY_SPREAD = 120;	//should be 1/2 TOP_WIDTH_2

//490,60
const WAY_OFF_X = 160;
const WAY_OFF_Y_OFFSET = 15;

//var rotator BaseRot;
var vector CompassPoints[NUM_COMPASS_POINTS];
var string CompassDir[8];

var Waypoint WaypointList[MAX_WAYPOINTS];
var int CurWaypoint;
var int NextWaypointSlot;

var int CompWayIdx;
var int CompWayOffIdx;
var int CompWayOffBlurIdx;

var Texture CompassCorner;
var Texture Square;

function SetNorth(vector n)
{
	local int i;
	local rotator card;

	CompassPoints[0] = n;

	card.yaw = 65536/NUM_COMPASS_POINTS;

	for (i=1; i<NUM_COMPASS_POINTS; i++)
	{
		CompassPoints[i]= CompassPoints[i-1] >> card;
//		log("CompassPoints["$i$"]: " $ CompassPoints[i]);
	}
	
//	BaseRot = rotator(North);
//	SetRotation(BaseRot);
}

//JAYHACK!!! - Fix it!!!
function AdjustCurWaypoint()
{
	while ((CurWaypoint<MAX_WAYPOINTS) && (WaypointList[CurWaypoint]==none))
	{
		CurWaypoint++;
	}

	if (CurWaypoint==MAX_WAYPOINTS)
	{
		CurWaypoint--;
	}
}

function InitWaypoints()
{
	local Waypoint w;
	CurWaypoint = 0;
//	NextWaypointSlot = 0;

	foreach AllActors( class 'Waypoint', w )
	{
		if (w.Number<MAX_WAYPOINTS)
		{
			if (WaypointList[w.Number] != none)
			{
				log("WAY: Duplicate entries for waypoint " $ w.Number);	
			}

			WaypointList[w.Number] = w;
		}
		else
		{
			log("WAY: Waypoint Set above max of " $ MAX_WAYPOINTS);
		}
	}

	AdjustCurWaypoint();
}

function UpdateWaypoints(Pawn myPawn)
{
	if ((WaypointList[CurWaypoint]!=none) && (WaypointList[CurWaypoint].CheckRadius(myPawn)))
	{
		WaypointList[CurWaypoint].OnHit(myPawn);
		CurWaypoint++;

		AdjustCurWaypoint();
	}
}

simulated event DrawBox(Canvas c, float x, float y, float w, float h)
{
	c.SetPos(x*c.ScaleX, y*c.ScaleY);
	c.DrawTile(Square, w*c.ScaleX, h*c.ScaleY, 0, 0, 1, 1);
}

function DrawCompass(Canvas c, Pawn myPawn, int glow)
{
	UpdateWaypoints(myPawn);

	return;
///////////////////////////////////////////////////

	c.SetDrawColor(0, 0, 0, 100);

	DrawBox(c, START_X+LINE_WIDTH, START_Y+LINE_WIDTH, TOP_WIDTH_1+TOP_SLANT_WIDTH+TOP_WIDTH_2+TOP_SLANT_WIDTH+TOP_WIDTH_1-LINE_WIDTH, SIDE_HEIGHT-LINE_WIDTH);
	DrawBox(c, START_X+TOP_WIDTH_1+TOP_SLANT_WIDTH+LINE_WIDTH, START_Y-TOP_SLANT_HEIGHT+LINE_WIDTH, TOP_WIDTH_2-LINE_WIDTH, TOP_SLANT_HEIGHT);
	DrawBox(c, START_X+BOTTOM_SLANT_WIDTH+LINE_WIDTH, START_Y+SIDE_HEIGHT, BOTTOM_WIDTH-LINE_WIDTH, BOTTOM_SLANT_HEIGHT);

	c.SetDrawColor(255, 255, 255);
	
	//top angles
	c.SetPos((START_X+TOP_WIDTH_1)*c.ScaleY, (START_Y-TOP_SLANT_HEIGHT)*c.ScaleY);
	c.DrawTile(CompassCorner, (TOP_SLANT_WIDTH+LINE_WIDTH)*c.ScaleY, (TOP_SLANT_HEIGHT+LINE_WIDTH)*c.ScaleY, 2, 2, 12, 12);
	
	c.SetPos((START_X+TOP_WIDTH_1+TOP_SLANT_WIDTH+TOP_WIDTH_2)*c.ScaleY, (START_Y-TOP_SLANT_HEIGHT)*c.ScaleY);
	c.DrawTile(CompassCorner, (TOP_SLANT_WIDTH+LINE_WIDTH)*c.ScaleY, (TOP_SLANT_HEIGHT+LINE_WIDTH)*c.ScaleY, -2, 2, -12, 12);
	
	//bottom angles
	c.SetPos((START_X)*c.ScaleY, (START_Y+SIDE_HEIGHT)*c.ScaleY);
	c.DrawTile(CompassCorner, (BOTTOM_SLANT_WIDTH+LINE_WIDTH)*c.ScaleY, BOTTOM_SLANT_HEIGHT*c.ScaleY, 2, -2, 12, -12);
	
	c.SetPos((START_X+BOTTOM_SLANT_WIDTH+BOTTOM_WIDTH)*c.ScaleY, (START_Y+SIDE_HEIGHT)*c.ScaleY);
	c.DrawTile(CompassCorner, (BOTTOM_SLANT_WIDTH+LINE_WIDTH)*c.ScaleY, BOTTOM_SLANT_HEIGHT*c.ScaleY, -2, -2, -12, -12);
	
	//top
	DrawBox(c, START_X, START_Y, TOP_WIDTH_1, LINE_WIDTH);
	DrawBox(c, START_X+TOP_WIDTH_1+TOP_SLANT_WIDTH, START_Y-TOP_SLANT_HEIGHT, TOP_WIDTH_2, LINE_WIDTH);
	DrawBox(c, START_X+TOP_WIDTH_1+TOP_SLANT_WIDTH+TOP_SLANT_WIDTH+TOP_WIDTH_2, START_Y, TOP_WIDTH_1, LINE_WIDTH);
	//bottom
	DrawBox(c, START_X+BOTTOM_SLANT_WIDTH, START_Y+SIDE_HEIGHT+BOTTOM_SLANT_HEIGHT-LINE_WIDTH, BOTTOM_WIDTH, LINE_WIDTH);
	//sides
	DrawBox(c, START_X, START_Y, LINE_WIDTH, SIDE_HEIGHT);
	DrawBox(c, START_X+((TOP_WIDTH_1+TOP_SLANT_WIDTH)*2)+TOP_WIDTH_2-LINE_WIDTH, START_Y, LINE_WIDTH, SIDE_HEIGHT);

	DrawWaypoints(c, MyPawn);
}

function DrawWaypoints(Canvas c, Pawn MyPawn)
{
	local vector wayPointLoc;
//	local rotator rot;
	local vector delta;
//	local vector trans;
//	local float sinA;
//	local float cosA;
	local float mag;
	//local int i;
	
	local float dot;
	local vector facing;
	local vector crossProd;
	local float t;
	local float view;
	local float aCosView;
	local float aCosDot;
//	local float pos;
	local float Mag3d;

	c.SetDrawColor(255, 255, 255);

	class'ZombieFontDescriptor'.static.SetRadarFont(c, 18);

	if (WaypointList[CurWaypoint] != none)
	{
		facing = vector(myPawn.Rotation);
		facing.Z = 0;
		facing = normal(facing);
		
		view = cos(myPawn.Controller.FOVAngle/180*PI/2);
		aCosView = myPawn.Controller.FOVAngle/180*PI/2;
		
		wayPointLoc = WaypointList[CurWaypoint].Location;
//		delta = MyPawn.Location-wayPointLoc;
		delta = wayPointLoc - MyPawn.Location;
		
		Mag3d = VSize(delta);
		
		delta.Z = 0;

		mag = VSize(delta);

		delta /= mag;

		if (WaypointList[CurWaypoint].bUse3DPosition)
		{
			mag = Mag3d;
		}

		dot = delta dot facing;
		
		crossProd = delta Cross facing;
		
		if (crossProd.Z > 0)
		{
			t = -1;
		}
		else
		{
			t = 1;
		}
	
		mag -= WaypointList[CurWaypoint].Radius;
	
		mag /= 24;	//convert mag to feet
		mag *= 0.3048; //convert mag to meters
		if ( mag < 0.f )
		{
			mag = 0.f;
		}
		
		if(dot < view)
		{
			//draw offscreen			
			if (t<0)
			{
				class'ZombieGame.HUDIconMgr'.static.DrawImageHW(c, HIM_WAYPOINT_OFFSCREEN, (320)+(WAY_OFF_X*t), BASE_POS + WAY_OFF_Y_OFFSET);
				
				//c.SetDrawColor(255,255,255);
				class'BasicHUD'.static.DrawTextJustify(c, mag$"m", (320)+(WAY_OFF_X*t)+16+8, 
					//BASE_POS + 13,
					BASE_POS + WAY_OFF_Y_OFFSET,
					JUST_Left);
			}
			else
			{
				class'ZombieGame.HUDIconMgr'.static.DrawImageFlip(c, HIM_WAYPOINT_OFFSCREEN, (320)+(WAY_OFF_X*t)-16, BASE_POS + WAY_OFF_Y_OFFSET, true, false);
				
				//c.SetDrawColor(255,255,255);
				class'BasicHUD'.static.DrawTextJustify(c, mag$"m", (320)+(WAY_OFF_X*t)-16-8, 
					//BASE_POS + 13,
					BASE_POS + WAY_OFF_Y_OFFSET,
					JUST_Right);
			}
			
			c.SetDrawColor(255,255,255);
			
			class'ZombieFontDescriptor'.static.ResetFont(c);
			
			return;
		}
		else
		{
			aCosDot = acos(dot);

			class'ZombieGame.HUDIconMgr'.static.DrawImageHW(c, HIM_WAYPOINT_ICON, (WAY_BASE_X+WAY_SPREAD)+(WAY_SPREAD*(aCosDot/aCosView*t)), BASE_POS + 3, 19, 19);
			
			class'BasicHUD'.static.DrawTextJustify(c, mag$"m", (WAY_BASE_X+WAY_SPREAD)+(WAY_SPREAD*(aCosDot/aCosView*t)), 
				BASE_POS + WAY_OFF_Y_OFFSET,
				JUST_Center, false, 0, 0, WAY_BASE_X, WAY_BASE_X+WAY_SPREAD+WAY_SPREAD);
			
		}
	}
	
	class'ZombieFontDescriptor'.static.ResetFont(c);
}


// Decompiled with UE Explorer.
defaultproperties
{
    CompassDir[0]="N"
    CompassDir[1]="NE"
    CompassDir[2]="E"
    CompassDir[3]="SE"
    CompassDir[4]="S"
    CompassDir[5]="SW"
    CompassDir[6]="W"
    CompassDir[7]="NW"
    CompWayIdx=62
    CompWayOffIdx=63
    CompWayOffBlurIdx=64
    DrawType=0
}