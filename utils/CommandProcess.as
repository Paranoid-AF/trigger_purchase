namespace Utils{
  string lineDelimiter = "|";
  string escapeSymbol = "\\";

  array<string> SplitCommands(string CommandText){ // TODO
    array<string> Raw = CommandText.Split(lineDelimiter);
    for(uint i = 0; i < Raw.length(); i++){
      Raw[i] = CleanSpace(Raw[i]); // Remove whitespace first, to avoid problems in length.
      int LineLength = Raw[i].Length();
      if(Raw[i].SubString(LineLength-1, 1) == escapeSymbol){ // Merge two lines when the last character is a escape symbol.
        if(i < Raw.length() - 1){ // Only if it's not the last item in array, though.
          Raw[i] = Raw[i].SubString(0, LineLength-1) + lineDelimiter;
          Raw[i] = Raw[i] + CleanSpace(Raw[i+1]); // Be sure to remove the whitespace of the next.
          Raw.removeAt(i+1);
        }
      }
    }
    return Raw;
  }

  string ProcessVariables(string Input, CBasePlayer@ pPlayer){ // TODO
    while(Input.Find("%PLAYER%", 0) != String::INVALID_INDEX){
      Input.Replace("%PLAYER%", pPlayer.pev.netname);
    }
    while(Input.Find("%RANDOMPLAYER%", 0) != String::INVALID_INDEX){
      Input.Replace("%RANDOMPLAYER%", GetRandomPlayerName());
    }
    while(Input.Find("%SPACE%", 0) != String::INVALID_INDEX){
      Input.Replace("%SPACE%", " ");
    }
    return Input;
  }

  string GetRandomPlayerName(){
    string Name = "";
    if(g_PlayerFuncs.GetNumPlayers() > 0){
      CBasePlayer@ pPlayer = null;
      while(pPlayer is null){
        int Index = int(Math.RandomLong(1, g_Engine.maxClients));
        @pPlayer = g_PlayerFuncs.FindPlayerByIndex(Index);
      }
      Name = pPlayer.pev.netname;
    }
    return Name;
  }

  string CleanSpace(string RawString){
    while(RawString.SubString(0, 1) == " " && RawString.Length() > 1){ // Remove whitespace from head.
      RawString = RawString.SubString(1, RawString.Length()-1);
    }
    while(RawString.SubString(RawString.Length()-1, 1) == " " && RawString.Length() > 1){ // Remove whitespace from tail.
      RawString = RawString.SubString(0, RawString.Length()-1);
    }
    return RawString; // Well, at this point it's not raw, but whatever.
  }
}