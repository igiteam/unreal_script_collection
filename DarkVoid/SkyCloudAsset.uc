class SkyCloudAsset extends Object
    native;

struct native SkyCloudProperties
{
    var() float Percent;
    var() int EmitterIndex;

    structdefaultproperties
    {
        Percent=1.0000000
        EmitterIndex=0
    }
};

struct native SkyCloudBox
{
    var() bool bUseCustomProperties;
    var() array<SkyCloudProperties> SpriteProperties;
    var KBoxElem Box;
    var() name BoxName;

    structdefaultproperties
    {
        bUseCustomProperties=false
        SpriteProperties[0]=(Percent=1.0000000,EmitterIndex=0)
        Box=(TM=(XPlane=(W=0.0000000,X=1.0000000,Y=0.0000000,Z=0.0000000),YPlane=(W=0.0000000,X=0.0000000,Y=1.0000000,Z=0.0000000),ZPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=1.0000000),WPlane=(W=1.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000)),Location=(X=0.0000000,Y=0.0000000,Z=0.0000000),Rotation=(Pitch=0,Yaw=0,Roll=0),X=10.0000000,Y=10.0000000,Z=10.0000000,bNoRBCollision=false,bNoRBCollisionResponse=false,bTrigger=false,bPerPolyShape=false)
        BoxName="None"
    }
};

var editoronly native const transient Pointer SkyCloudEditorPtr;
var editoronly const transient SkyCloudActor SkyCloudEditorActor;
var editoronly native transient Vector EditorSunDirection;
var(Lighting) LinearColor CMin;
var(Lighting) LinearColor CMedian;
var(Lighting) LinearColor CMax;
var const export editinline ParticleSystem PartSys;
var() export editinline ParticleModuleColorByHeight PM_ColorByHeight;
var() int Seed;
