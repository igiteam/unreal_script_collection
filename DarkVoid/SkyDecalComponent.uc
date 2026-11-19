class SkyDecalComponent extends DecalComponent
    native
    editinlinenew;

var transient bool bSkyPoolActive;

simulated function InitForPooling()
{
    Reset();
    //return;    
}

simulated function DestroyFromPooling()
{
    //return;    
}

simulated function bool IsPoolAvailable()
{
    return !bSkyPoolActive;
    //return ReturnValue;    
}

simulated function Init(MaterialInterface InDecalMaterial, Vector InDecalLocation, Rotator InDecalOrientation, float InDecalRotation, float InWidth, float InHeight, float InThickness, bool InbNoClip, PrimitiveComponent InHitComponent, bool InbProjectOnTerrain, bool InbProjectOnSkeletalMeshes, name InHitBone, int InHitNodeIndex, int InHitLevelIndex, optional float InDepthBias = -0.0001000, optional float Backface = 0.0010000, optional float InTileX = 1.0000000, optional float InTileY = 1.0000000, optional float InOffsetX = 0.0000000, optional float InOffsetY = 0.0000000)
{
    bSkyPoolActive = true;
    Location = InDecalLocation;
    Orientation = InDecalOrientation;
    DecalRotation = InDecalRotation;
    Width = InWidth;
    Height = InHeight;
    FarPlane = InThickness * 0.5000000;
    NearPlane = -FarPlane;
    bNoClip = InbNoClip;
    HitComponent = InHitComponent;
    HitBone = InHitBone;
    HitNodeIndex = InHitNodeIndex;
    HitLevelIndex = InHitLevelIndex;
    SetDecalMaterial(InDecalMaterial);
    bProjectOnTerrain = InbProjectOnTerrain;
    bProjectOnSkeletalMeshes = InbProjectOnSkeletalMeshes;
    DepthBias = InDepthBias;
    BackfaceAngle = Backface;
    TileX = InTileX;
    TileY = InTileY;
    OffsetX = InOffsetX;
    OffsetY = InOffsetY;
    SetHidden(false);
    //return;    
}

simulated function Reset()
{
    bSkyPoolActive = false;
    //return;    
}
