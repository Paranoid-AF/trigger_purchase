#include "entity/trigger_purchase"
namespace Trigger_Purchase{
  void Activate(){
    InitEcco();
    g_CustomEntityFuncs.RegisterCustomEntity("Entity::CTriggerPurchase", "trigger_purchase");
  }
}
