/// Définition de toutes les commandes envoyées au robot.
/// Chaque commande correspond à une lettre ou un mot envoyé via Bluetooth.
///
/// Commandes :
/*
  L → Gauche
  R → Droite
  A → Accélération
  B → Frein
  I → Mode IA
  D → Mode Drift
  S → Stop
  START → Démarrer la voiture    (NOUVEAU)
*/


enum Command {
  left('L'),
  right('R'),
  accel('A'),
  brake('B'),
  ia('I'),
  reverse('W'),  // NOUVEAU - Reculer
  stop('S'),
  start('START');

  final String code;

  const Command(this.code);
}
