class SPRTPDamageMaskPersistent extends SPRenderTargetProxy
    native;

struct native DamageImpact
{
    var float U;
    var float V;
    var float Size;
    var float TimeStamp;

    structdefaultproperties
    {
        U=0.0000000
        V=0.0000000
        Size=0.0000000
        TimeStamp=0.0000000
    }
};

var DamageImpact hits[100];
var int MaxNumImpacts;
var int LastImpactID;
var int NextImpactID;
var float recoverTime;
var Texture2D ImageMask;
var Texture2D ImageClear;
var bool bInitialImpact;
var bool bSkinMelt;
var int Counter;
var float InitialImpactSize;

// Export USPRTPDamageMaskPersistent::execSetupRT(FFrame&, void* const)
native function SetupRT();

// Export USPRTPDamageMaskPersistent::execResetTarget(FFrame&, void* const)
native function ResetTarget(bool bPreserveSurface);

// Export USPRTPDamageMaskPersistent::execMeltSkin(FFrame&, void* const)
native function MeltSkin();

// Export USPRTPDamageMaskPersistent::execUpdateProxyData(FFrame&, void* const)
native function UpdateProxyData();
