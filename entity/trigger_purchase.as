#include "../utils/Executer"
#include "../utils/CommandProcess"
namespace Entity{
  class CTriggerPurchase : ScriptBaseEntity
  {
    string m_echoCommand;
    string m_echoCommandDelayed;
    string m_echoCommandError;
    string m_echoCommandLowScore;
    float m_echoCommandTime;
    float m_cost;
    string i_targetLowScore;
    string i_targetCommandError;
    string i_targetLater;

    bool KeyValue(const string & in szKey, const string & in szValue)
    {
      if(szKey == "m_echoCommand"){
        m_echoCommand = szValue;
        return true;
      }else if(szKey == "m_echoCommandDelayed"){
        m_echoCommandDelayed = szValue;
        return true;
      }else if(szKey == "m_echoCommandError"){
        m_echoCommandError = szValue;
        return true;
      }else if(szKey == "m_echoCommandLowScore"){
        m_echoCommandLowScore = szValue;
        return true;
      }else if(szKey == "m_echoCommandTime"){
        m_echoCommandTime = atof(szValue);
        return true;
      }else if(szKey == "m_cost"){
        m_cost = atof(szValue);
        return true;
      }else if(szKey == "i_targetLowScore"){
        i_targetLowScore = szValue;
        return true;
      }else if(szKey == "i_targetCommandError"){
        i_targetCommandError = szValue;
        return true;
      }else if(szKey == "i_targetLater"){
        i_targetLater = szValue;
        return true;
      }else{
        return BaseClass.KeyValue(szKey, szValue);
      }
    }

    void Use(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float value)
    {
      CBasePlayer@ pPlayer = cast<CBasePlayer@>(pActivator);
      if(!isspace(m_echoCommand) && m_echoCommand != ""){
        if(DeductScore(m_cost, pPlayer)){
          if(Run(m_echoCommand, pPlayer)){
              // Command successful
              UseTarget(pev.target, pPlayer);
              if(m_echoCommandTime >= 0){
                g_Scheduler.SetInterval(@this, "TaskLater", m_echoCommandTime, 1, @pPlayer);
              }
          }else{
            pPlayer.pev.frags += m_cost;
            // Command error
            UseTarget(i_targetCommandError, pPlayer);
            Run(m_echoCommandError, pPlayer);
          }
        }else{
          // Command failed for not enough score
          UseTarget(i_targetLowScore, pPlayer);
          Run(m_echoCommandLowScore, pPlayer);
        }
      }
    }

    private bool DeductScore(float amount, CBasePlayer@ pPlayer){
      if(pPlayer.pev.frags >= amount){
        pPlayer.pev.frags -= amount;
        return true;
      }else{
        return false;
      }
    }

    private void UseTarget(string TargetName, CBasePlayer@ pPlayer){
      if(!isspace(TargetName) && TargetName != ""){
        CBaseEntity@ pTarget = g_EntityFuncs.FindEntityByTargetname(null, TargetName);
        if(pTarget !is null){
          pTarget.Use(pPlayer, self, USE_TOGGLE, 0);
        }
      }
    }

    private bool Run(string CommandLine, CBasePlayer@ pPlayer){
      bool result = true;
      array<string> commandList = Utils::SplitCommands(CommandLine);
      for(uint i=0; i<commandList.length(); i++){
        commandList[i] = Utils::ProcessVariables(commandList[i], pPlayer);
        result = result && e_ScriptParser.Execute(commandList[i], pPlayer);
        if(!result){
          break;
        }
      }
      return result;
    }

    private void TaskLater(CBasePlayer@ pPlayer){
      if(!isspace(m_echoCommandDelayed) && m_echoCommandDelayed != ""){
        Run(m_echoCommandDelayed, pPlayer);
      }
      UseTarget(i_targetLater, pPlayer);
    }
  }
}