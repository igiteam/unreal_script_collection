class Speakers extends Core.Object
    Config(Speakers)
    native;

struct native SpeakerInfo
{
   var config name SpeakerID;
   var config localized string SpeakerString;
   var config string PreFormatting;
   var config string PostFormatting;
   var config bool bUsePlayerNameInMP;
};

var config array<SpeakerInfo> Speaker;

var private native noexport const int SpeakerMap[5];  //Declared as a TMap<FName, FSpeakerInfo*> in ASpeakerInfo.h

// Decompiled with UE Explorer.
defaultproperties
{
    Speaker[0]=(SpeakerID="ld",SpeakerString="Player",PreFormatting="[c=00ff00][b]",PostFormatting="[\\b]",bUsePlayerNameInMP=true)
    Speaker[1]=(SpeakerID="r1",SpeakerString="Officer Reynolds",PreFormatting="[c=ff0000][b]",PostFormatting="[\\b]",bUsePlayerNameInMP=true)
    Speaker[2]=(SpeakerID="b1",SpeakerString="Officer Fields",PreFormatting="[c=0066ff][b]",PostFormatting="[\\b]",bUsePlayerNameInMP=true)
    Speaker[3]=(SpeakerID="r2",SpeakerString="Officer Girard",PreFormatting="[c=ff0000][b]",PostFormatting="[\\b]",bUsePlayerNameInMP=true)
    Speaker[4]=(SpeakerID="b2",SpeakerString="Officer Jackson",PreFormatting="[c=0066ff][b]",PostFormatting="[\\b]",bUsePlayerNameInMP=true)
    Speaker[5]=(SpeakerID="gf",SpeakerString="Gladys Fairfax",PreFormatting="[c=ff9900][b]",PostFormatting="[\\b]",bUsePlayerNameInMP=false)
    Speaker[6]=(SpeakerID="dis",SpeakerString="Dispatch",PreFormatting="[c=ffff00][b]",PostFormatting="[\\b]",bUsePlayerNameInMP=false)
    Speaker[7]=(SpeakerID="hg",SpeakerString="Highground",PreFormatting="[c=ffff00][b]",PostFormatting="[\\b]",bUsePlayerNameInMP=false)
    Speaker[8]=(SpeakerID="s1",SpeakerString="Sierra 1",PreFormatting="[c=ffff00][b]",PostFormatting="[\\b]",bUsePlayerNameInMP=false)
    Speaker[9]=(SpeakerID="s2",SpeakerString="Sierra 2",PreFormatting="[c=ffff00][b]",PostFormatting="[\\b]",bUsePlayerNameInMP=false)
    Speaker[10]=(SpeakerID="TOC",SpeakerString="T.O.C.",PreFormatting="[c=ffff00][b]",PostFormatting="[\\b]",bUsePlayerNameInMP=false)
    Speaker[11]=(SpeakerID="u1",SpeakerString="Sonny Bonds",PreFormatting="[c=ffff00][b]",PostFormatting="[\\b]",bUsePlayerNameInMP=false)
    Speaker[12]=(SpeakerID="tv1",SpeakerString="Reporter",PreFormatting="[c=ff9900][b]",PostFormatting="[\\b]",bUsePlayerNameInMP=false)
    Speaker[13]=(SpeakerID="wk",SpeakerString="Woman on Radio",PreFormatting="[c=ff9900][b]",PostFormatting="[\\b]",bUsePlayerNameInMP=false)
    Speaker[14]=(SpeakerID="aj",SpeakerString="Alex Jimenez",PreFormatting="[c=ff9900][b]",PostFormatting="[\\b]",bUsePlayerNameInMP=false)
    Speaker[15]=(SpeakerID="ak",SpeakerString="Allen Kruse",PreFormatting="[c=ff9900][b]",PostFormatting="[\\b]",bUsePlayerNameInMP=false)
    Speaker[16]=(SpeakerID="alj",SpeakerString="Alice Jenkins",PreFormatting="[c=ff9900][b]",PostFormatting="[\\b]",bUsePlayerNameInMP=false)
    Speaker[17]=(SpeakerID="cj",SpeakerString="Carl Jennings",PreFormatting="[c=ff9900][b]",PostFormatting="[\\b]",bUsePlayerNameInMP=false)
    Speaker[18]=(SpeakerID="hk",SpeakerString="Hadeon Koshka",PreFormatting="[c=ff9900][b]",PostFormatting="[\\b]",bUsePlayerNameInMP=false)
    Speaker[19]=(SpeakerID="jt",SpeakerString="Jean Trouffant",PreFormatting="[c=ff9900][b]",PostFormatting="[\\b]",bUsePlayerNameInMP=false)
    Speaker[20]=(SpeakerID="lb",SpeakerString="Louie Baccus",PreFormatting="[c=ff9900][b]",PostFormatting="[\\b]",bUsePlayerNameInMP=false)
    Speaker[21]=(SpeakerID="lf",SpeakerString="Lawrence Fairfax",PreFormatting="[c=ff9900][b]",PostFormatting="[\\b]",bUsePlayerNameInMP=false)
    Speaker[22]=(SpeakerID="ln",SpeakerString="Lian Niu",PreFormatting="[c=ff9900][b]",PostFormatting="[\\b]",bUsePlayerNameInMP=false)
    Speaker[23]=(SpeakerID="ms1",SpeakerString="Male Suspect",PreFormatting="[c=ff9900][b]",PostFormatting="[\\b]",bUsePlayerNameInMP=false)
    Speaker[24]=(SpeakerID="ms2",SpeakerString="Male Suspect",PreFormatting="[c=ff9900][b]",PostFormatting="[\\b]",bUsePlayerNameInMP=false)
    Speaker[25]=(SpeakerID="ms3",SpeakerString="Male Suspect",PreFormatting="[c=ff9900][b]",PostFormatting="[\\b]",bUsePlayerNameInMP=false)
    Speaker[26]=(SpeakerID="ms4",SpeakerString="Male Suspect",PreFormatting="[c=ff9900][b]",PostFormatting="[\\b]",bUsePlayerNameInMP=false)
    Speaker[27]=(SpeakerID="sg",SpeakerString="Simon Gowan",PreFormatting="[c=ff9900][b]",PostFormatting="[\\b]",bUsePlayerNameInMP=false)
    Speaker[28]=(SpeakerID="ga",SpeakerString="Gary Altman",PreFormatting="[c=ff9900][b]",PostFormatting="[\\b]",bUsePlayerNameInMP=false)
    Speaker[29]=(SpeakerID="hjp",SpeakerString="Hyun Jun Park",PreFormatting="[c=ff9900][b]",PostFormatting="[\\b]",bUsePlayerNameInMP=false)
    Speaker[30]=(SpeakerID="jb",SpeakerString="James Bettencourt",PreFormatting="[c=ff9900][b]",PostFormatting="[\\b]",bUsePlayerNameInMP=false)
    Speaker[31]=(SpeakerID="la",SpeakerString="Lawrence Adams",PreFormatting="[c=ff9900][b]",PostFormatting="[\\b]",bUsePlayerNameInMP=false)
    Speaker[32]=(SpeakerID="mk",SpeakerString="Melinda Kline",PreFormatting="[c=ff9900][b]",PostFormatting="[\\b]",bUsePlayerNameInMP=false)
    Speaker[33]=(SpeakerID="ts",SpeakerString="Theodore Stylins",PreFormatting="[c=ff9900][b]",PostFormatting="[\\b]",bUsePlayerNameInMP=false)
    Speaker[34]=(SpeakerID="wr",SpeakerString="Walter Rooney",PreFormatting="[c=ff9900][b]",PostFormatting="[\\b]",bUsePlayerNameInMP=false)
    Speaker[35]=(SpeakerID="VIP",SpeakerString="VIP",PreFormatting="[c=ff9900][b]",PostFormatting="[\\b]",bUsePlayerNameInMP=false)
    Speaker[36]=(SpeakerID="at",SpeakerString="Andrew Taronne",PreFormatting="[c=ff9900][b]",PostFormatting="[\\b]",bUsePlayerNameInMP=false)
    Speaker[37]=(SpeakerID="fh1",SpeakerString="Female Hostage",PreFormatting="[c=ff9900][b]",PostFormatting="[\\b]",bUsePlayerNameInMP=false)
    Speaker[38]=(SpeakerID="fh2",SpeakerString="Female Hostage",PreFormatting="[c=ff9900][b]",PostFormatting="[\\b]",bUsePlayerNameInMP=false)
    Speaker[39]=(SpeakerID="fh3",SpeakerString="Female Hostage",PreFormatting="[c=ff9900][b]",PostFormatting="[\\b]",bUsePlayerNameInMP=false)
    Speaker[40]=(SpeakerID="fh4",SpeakerString="Female Hostage",PreFormatting="[c=ff9900][b]",PostFormatting="[\\b]",bUsePlayerNameInMP=false)
    Speaker[41]=(SpeakerID="mh1",SpeakerString="Male Hostage",PreFormatting="[c=ff9900][b]",PostFormatting="[\\b]",bUsePlayerNameInMP=false)
    Speaker[42]=(SpeakerID="mh2",SpeakerString="Male Hostage",PreFormatting="[c=ff9900][b]",PostFormatting="[\\b]",bUsePlayerNameInMP=false)
    Speaker[43]=(SpeakerID="mh3",SpeakerString="Male Hostage",PreFormatting="[c=ff9900][b]",PostFormatting="[\\b]",bUsePlayerNameInMP=false)
}