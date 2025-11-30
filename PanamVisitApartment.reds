// == PanamVisitApartment.reds ==
// Po odpowiedzi "ok/już/idę" na SMS-a od Panam → Panam pojawia się w mieszkaniu V
// Działa we wszystkich apartamentach V (Northside, Corpo Plaza, The Glen, Japantown)
// Autor: AzAsAsyn

module PanamVisit

import GenerativeTexting.*

@wrapMethod(TextMessageThread)
public func OnPlayerReply(reply: String, msg: ref<TextMessage>) -> Void {
  wrappedMethod(reply, msg);

  let sender = msg.GetSender();
  if !IsDefined(sender) { return; }

  // Sprawdzamy czy to dokładnie Panam Palmer
  if !Equals(sender.GetRecordID(), n"Character.panam_palmer") { return; }

  // Sprawdzamy czy gracz napisał coś w stylu "ok", "już", "idę", "dobra"
  let lowerReply = StrLower(reply);
  if StrContains(lowerReply, "ok") || StrContains(lowerReply, "już") || 
     StrContains(lowerReply, "idę") || StrContains(lowerReply, "dobra") ||
     StrContains(lowerReply, "jasne") || StrContains(lowerReply, "coming") {
    
    this.ScheduleDelayed(2.0, new PanamVisitCallback()); // 2 sekundy opóźnienia – wygląda naturalnie
  }
}

public class PanamVisitCallback extends DelayCallback {
  public func Call() -> Void {
    let player = GetPlayer(GetGameInstance());
    let apartment = GameInstance.GetApartmentSystem(GetGameInstance()).GetPlayerApartment();
    let pos = apartment.GetEntrancePosition() + new Vector4(1.5, 0.0, 0.0, 1.0);

    // Teleportuje Panam dokładnie tam, gdzie pojawia się Judy w vanilla
    let panam = GameInstance.GetScriptableSystemsContainer()
                .Get(n"EntitySpawnerSystem")
                .Spawn(n"Character.panam_palmer", pos, EulerAngles.ToQuat(new EulerAngles(0.0, 0.0, 180.0)));

    if IsDefined(panam) {
      panam.GetAIControllerComponent().SetAttitudeGroup(c"att_group_friendly");
      GameInstance.GetAudioSystem(GetGameInstance()).PlaySound(n"ono_panam_knock", player);
    }
  }
}
