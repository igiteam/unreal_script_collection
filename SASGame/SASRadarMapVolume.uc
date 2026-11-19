//class which activates volume for change in radar maps
class  SASRadarMapVolume extends Volume
	placeable;
	
var SASPawn				touchingPawn;
var SASPlayerController	pc;

var(RadarMaps) Texture Map;
//the actual world coordinates
var(RadarMaps) vector UtMapCoOrds1;
var(RadarMaps) vector UtMapCoOrds2;

//the corresponding radar map coordinates
var(RadarMaps) vector RadarMapCoOrds1;
var(RadarMaps) vector RadarMapCoOrds2;

event Touch(Actor aTouched)
{						
	if ( (SASPawn(aTouched) != None) && SASPawn(aTouched).IsHumanControlled() )
	{					
		Level.GetMapToDisplayFromVolume(Map,UtMapCoOrds1,UtMapCoOrds2,RadarMapCoOrds1,RadarMapCoOrds2);				
	}					
}		


// Decompiled with UE Explorer.
defaultproperties
{
    BrushColor=(R=80,G=80,B=255,A=255)
    bColored=true
    bStatic=false
    bNoDelete=false
}