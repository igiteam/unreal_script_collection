//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDAttachment_CommandSystem extends HDSpecialWeaponAttachment;

var ParticleSystem                          PS_LaserEffect[2];
var Emitter                                 EM_LaserEffect;
var bool                                    bHiddenLaserEffect;
var transient   bool                        bDoTeamCompareFlag;

simulated function TeamCompareFlag()
{
    local PlayerController  PC;
    // do filter first
    if ( !bDoTeamCompareFlag )
    {
       PC = Instigator.GetALocalPlayerController();
        if ( PC != None && PC.PlayerReplicationInfo != None && PC.PlayerReplicationInfo.Team != None )
        {
            if ( PC.PlayerReplicationInfo.Team.TeamIndex != Instigator.GetTeam().TeamIndex )
            {
                bHiddenLaserEffect = True;
                EM_LaserEffect.ParticleSystemComponent.SetActive(False);
            }
            bDoTeamCompareFlag = True;
        }
    }
}

simulated event PostBeginPlay()
{
	//local HDPawn_MP   LocalPawn;

    Super.PostBeginPlay();
    bHiddenLaserEffect = False;
    bDoTeamCompareFlag = False;

    TeamCompareFlag();

    if ( EM_LaserEffect == None )
    {
		EM_LaserEffect = Spawn(class'TMEmitter',Self,, Location);
		EM_LaserEffect.LifeSpan = 0;
		EM_LaserEffect.SetOnlyOwnerSee(FALSE);
		EM_LaserEffect.SetTemplate(PS_LaserEffect[Instigator.GetTeam().TeamIndex]);
		EM_LaserEffect.ParticleSystemComponent.ActivateSystem();
		EM_LaserEffect.ParticleSystemComponent.SetActive(HDPawn_MP(Instigator).bCommandSystemActived && !bHiddenLaserEffect);
		EM_LaserEffect.SetLocation(HDPawn_MP(Instigator).CommandSystemLocation);
    }
}

simulated event Destroyed()
{
    if ( EM_LaserEffect != None )
    {
        EM_LaserEffect.Destroy();
        EM_LaserEffect = None;
    }
}

simulated function SetLaserEffectActive( bool bActive )
{
    TeamCompareFlag();

    if ( bHiddenLaserEffect ) return;

    if ( bActive != EM_LaserEffect.ParticleSystemComponent.bIsActive )
        EM_LaserEffect.ParticleSystemComponent.SetActive(bActive);
}

simulated function SetLaserEffectLocation( vector Loc )
{
    if ( bHiddenLaserEffect ) return;
    EM_LaserEffect.SetLocation(Loc);
}


