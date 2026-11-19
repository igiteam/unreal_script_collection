class AnimNotify_PlayParticleByType extends AnimNotify_Scripted
    editinlinenew
    collapsecategories
    hidecategories(Object);

struct PawnParticleType
{
    var() ParticleSystem PSTemplate;
    var() int Type;

    structdefaultproperties
    {
        PSTemplate=none
        Type=0
    }
};

var() array<PawnParticleType> PSTemplateByTypes;
var() ParticleSystem DefaultPSTemplate;
var() name SocketName;
var() name BoneName;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local int I, Size;

    super.Notify(Owner, AnimSeqInstigator);
    // End:0x36
    if(EvilPawn(Owner) == none)
    {
        return;
    }
    Size = PSTemplateByTypes.Length;
    I = 0;
    J0x55:

    // End:0x13C [Loop If]
    if(I < Size)
    {
        // End:0x12E
        if(EvilPawn(Owner).PawnAIType == PSTemplateByTypes[I].Type)
        {
            // End:0x12C
            if(PSTemplateByTypes[I].PSTemplate != none)
            {
                PlayParticleEffect(EvilPawn(Owner), PSTemplateByTypes[I].PSTemplate);
            }
            return;
        }
        I++;
        // [Loop Continue]
        goto J0x55;
    }
    // End:0x170
    if(DefaultPSTemplate != none)
    {
        PlayParticleEffect(EvilPawn(Owner), DefaultPSTemplate);
    }
    //return;    
}

function PlayParticleEffect(EvilPawn Owner, ParticleSystem InParticleSystem)
{
    local editinline ParticleSystemComponent EffectPSC;

    // End:0x11
    if(Owner == none)
    {
        return;
    }
    EffectPSC = new (self) Class'Engine.ParticleSystemComponent';
    EffectPSC.SetTemplate(InParticleSystem);
    // End:0xE0
    if(Owner.Mesh.GetSocketByName(SocketName) != none)
    {
        Owner.Mesh.AttachComponent(EffectPSC, SocketName);        
    }
    else
    {
        Owner.Mesh.AttachComponent(EffectPSC, BoneName);
    }
    EffectPSC.ActivateSystem();
    //return;    
}
