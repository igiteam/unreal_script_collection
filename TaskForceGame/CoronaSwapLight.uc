class CoronaSwapLight extends Light
	placeable;
	//native;

//#exec Texture Import File=..\Engine\Textures\S_Light.dds  Name=S_Light Mips=Off MASKED=1

//var (Corona)	float	MinCoronaSize;
//var (Corona)	float	MaxCoronaSize;
//var (Corona)	float	CoronaRotation;
//var (Corona)	float	CoronaRotationOffset;
//var (Corona)	bool	UseOwnFinalBlend;

function Trigger( actor Other, pawn EventInstigator )
{
	local material tempSkinIdx;
	tempSkinIdx=Skins[0];
	Skins[0] = Skins[1];
	Skins[1] = tempSkinIdx;
		
}



// Decompiled with UE Explorer.
defaultproperties
{
    bCorona=true
    bStatic=false
}