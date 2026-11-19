class SkyAnimNotify_Recoil extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

enum ERecoilType
{
    ERT_RecoilBegin,                // 0
    ERT_RecoilEnd,                  // 1
    ERT_MAX                         // 2
};

var() SkyAnimNotify_Recoil.ERecoilType RecoilType;
var() bool bAuxiliary;
var() int AuxiliaryIndex;
var() int BarrelIndex;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local SkyPawn SP;
    local SkyVehicle SV;
    local SkyWeapon SW;
    local SkyVWeap SVW;

    SP = SkyPawn(Owner);
    SV = SkyVehicle(Owner);
    // End:0x105
    if(SP != none)
    {
        // End:0x93
        if(((bAuxiliary && SP != none) && AuxiliaryIndex >= 0) && AuxiliaryIndex < SP.AuxWeapons.Length)
        {
            SW = SP.AuxWeapons[AuxiliaryIndex].Instance;            
        }
        else
        {
            SW = SkyWeapon(SP.Weapon);
        }
        // End:0x102
        if(SW != none)
        {
            // End:0xE0
            if(int(RecoilType) == int(0))
            {
                SW.LastRecoilSeq = AnimSeqInstigator;                
            }
            else
            {
                // End:0x102
                if(int(RecoilType) == int(1))
                {
                    SW.bRecoilInProgress = false;
                }
            }
        }        
    }
    else
    {
        // End:0x1A8
        if((SV != none) && BarrelIndex != -1)
        {
            SVW = SkyVWeap(SV.Seats[0].Gun);
            // End:0x1A8
            if(SVW != none)
            {
                // End:0x181
                if(int(RecoilType) == int(0))
                {
                    SVW.LastRecoilSeq[BarrelIndex] = AnimSeqInstigator;                    
                }
                else
                {
                    // End:0x1A8
                    if(int(RecoilType) == int(1))
                    {
                        SVW.bRecoilInProgress[BarrelIndex] = false;
                    }
                }
            }
        }
    }
    //return;    
}
