#include "../addons.conf"
namespace Utils{

  class CommandExecuter{
    private dictionary ScriptMacros;

    void Register(string CommandName, CustomMacro NewCustomMacro){
      ScriptMacros.set(CommandName, @NewCustomMacro);
    }

    bool Execute(string CommandLine, CBasePlayer@ pPlayer){ // single line of command
      bool status = true;
      array<string> args = CommandLine.Split(" ");
      if(args.length() >= 1){
        string funcName = args[0];
        args.removeAt(0);
        if(!isspace(funcName) && funcName != "" && ScriptMacros.exists(funcName)){
          CustomMacro@ MacroRun = cast<CustomMacro@>(ScriptMacros[funcName]);
          status = status && MacroRun.MacroFunc(pPlayer, args);
        }
      }
      return status;
    }
  }

}

funcdef bool CustomMacroFunc(CBasePlayer@, array<string>@);
class CustomMacro{
  CustomMacroFunc@ MacroFunc;
  CustomMacro(CustomMacroFunc@ NewCustomMacro){
    @MacroFunc = NewCustomMacro;
  }
}

Utils::CommandExecuter e_ScriptParser; // Initialize as a global variable, to unify the runtime.