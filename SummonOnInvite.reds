// == SummonOnInvite.reds ==
// Automatyczne przywołanie do Panam po odpowiedzi "I'm on my way"
// Tylko dla Panam Palmer – jej własny samochód albo teleport
// Autor: AzAsAsyn

@addMethod(TextMessageThread)
public func OnPlayerReplySummon(inviteMsg: ref<TextMessage>) -> Void {
  let player = GameInstance.GetPlayerSystem(this.GetGameInstance()).GetLocalPlayerMainGameObject();
  let npc = inviteMsg.GetSender();

  // Sprawdzamy czy to dokładnie Panam Palmer
  if !IsDefined(npc) { return; }
  if !Equals(npc.GetRecordID(), n"Character.panam_palmer") { return; }

  let pos = npc.GetWorldPosition();

  // 1. Najpierw próbujemy wezwać jej własny samochód (Thorton albo Basilisk)
  let vehicleSystem = GameInstance.GetVehicleSystem(this.GetGameInstance());
  let summoned = vehicleSystem.RequestSummonVehicle(npc.GetEntityID(), pos);

  // 2. Jeśli nie ma auta albo nie da się wezwać – teleportujemy gracza od razu do niej
  if !summoned {
    GameInstance.GetTeleportationFacility(this.GetGameInstance()).Teleport(player, pos);
  }

  // Dźwięk klaksonu Panam – taki charakterystyczny dla Aldecaldos
  GameInstance.GetAudioSystem(this.GetGameInstance()).PlaySound(n"v_nomad_car_horn", player);

  // Mały efekt wizualny – pył i iskry jak przy przywołaniu auta
  GameInstance.GetScriptableSystemsContainer().Get(n"VehicleSystem").QueueEvent(new class VehicleSpawnedEvent());
}
