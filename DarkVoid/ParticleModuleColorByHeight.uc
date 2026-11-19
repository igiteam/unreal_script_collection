class ParticleModuleColorByHeight extends ParticleModuleColorBase
    native
    editinlinenew
    collapsecategories;

struct native ColorHeight
{
    var() LinearColor Color;
    var() float Height;

    structdefaultproperties
    {
        Color=(R=1.0000000,G=1.0000000,B=1.0000000,A=1.0000000)
        Height=0.0000000
    }
};

var() array<ColorHeight> ColorByHeight;
