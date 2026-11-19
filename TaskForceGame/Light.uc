//=============================================================================
// The light class.
//=============================================================================
class Light extends Actor
	placeable
	native;

#exec Texture Import File=Textures\S_Light.dds  Name=S_Light Mips=Off MASKED=1

var (Corona)	float	MinCoronaSize;
var (Corona)	float	MaxCoronaSize;
var (Corona)	float	CoronaRotation;
var (Corona)	float	CoronaRotationOffset;
var (Corona)	bool	UseOwnFinalBlend;


// Decompiled with UE Explorer.
defaultproperties
{
    MaxCoronaSize=1000.0000000
    LightType=1
    LightBrightness=64.0000000
    LightRadius=64.0000000
    LightSaturation=255
    LightPeriod=32
    LightCone=128
    bStatic=true
    bHidden=true
    bNoDelete=true
    Texture=Texture'S_Light'
    bMovable=false
    CollisionRadius=24.0000000
    CollisionHeight=24.0000000
}