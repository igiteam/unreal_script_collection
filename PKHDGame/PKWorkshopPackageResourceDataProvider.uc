class PKWorkshopPackageResourceDataProvider extends UDKUIResourceDataProvider
    transient
    config(Game)
    perobjectconfig
    hidecategories(Object,UIRoot);

var config string PackageName;
var config string Author;
var config array<config string> RawSinglePlayerMapNames;
var config array<config string> RawOtherMapNames;

function Dump()
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x31 [Loop If]
    if(I < RawSinglePlayerMapNames.Length)
    {
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    I = 0;
    J0x3C:

    // End:0x62 [Loop If]
    if(I < RawOtherMapNames.Length)
    {
        I++;
        // [Loop Continue]
        goto J0x3C;
    }
    //return;    
}
