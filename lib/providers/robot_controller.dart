import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:conduite/models/robot_command.dart';

enum RobotConnectionState { disconnected, connecting, connected }

class RobotController extends ChangeNotifier {
  BluetoothConnection? _connection;

  RobotConnectionState _connectionState = RobotConnectionState.disconnected;
  String _lastStatus = "En attente...";
  String _mpuData = "0.0";

  double _batteryVoltage = 12.6;

  // MODE SIMULATION
  bool _simulation = false;

  // NOUVEAUX RÉGLAGES UTILISATEUR

  // Sensibilité des boutons (1.0 = normal)
  double _touchSensitivity = 1.0;

  // Couleur du fond du PilotScreen
  int _backgroundColor = 0xFF001133;

  // Couleur globale du glow des boutons
  int _buttonGlowColor = 0xFF00FFFF;

  // Mode conduite : automatique ou manuel
  bool _autoMode = false;

  // GETTERS
  RobotConnectionState get connectionState => _connectionState;
  String get lastStatus => _lastStatus;
  String get mpuData => _mpuData;
  double get batteryVoltage => _batteryVoltage;
  bool get isSimulated => _simulation;

  // 🔧 nouveaux getters
  double get touchSensitivity => _touchSensitivity;
  int get backgroundColor => _backgroundColor;
  int get buttonGlowColor => _buttonGlowColor;
  bool get autoMode => _autoMode;

  // 🔧 setters
  void setTouchSensitivity(double value) {
    _touchSensitivity = value;
    notifyListeners();
  }

  void setBackgroundColor(int color) {
    _backgroundColor = color;
    notifyListeners();
  }

  void setButtonGlowColor(int color) {
    _buttonGlowColor = color;
    notifyListeners();
  }

  void setAutoMode(bool enabled) {
    _autoMode = enabled;
    notifyListeners();
  }

  // ---------------------------------------------------------
  // -------------------- CONNEXION BLUETOOTH ----------------
  // ---------------------------------------------------------

  Future<void> connectToDevice(BluetoothDevice device) async {
    if (_simulation) {
      _lastStatus = "Simulation activée → aucune vraie connexion.";
      notifyListeners();
      return;
    }

    if (_connectionState == RobotConnectionState.connected) return;

    _connectionState = RobotConnectionState.connecting;
    _lastStatus = "Connexion à ${device.name}...";
    notifyListeners();

    try {
      _connection = await BluetoothConnection.toAddress(device.address);

      _connectionState = RobotConnectionState.connected;
      _lastStatus = "Connecté à ${device.name}";

      _connection!.input!.listen(_onDataReceived).onDone(() {
        disconnect();
      });

    } catch (e) {
      _connectionState = RobotConnectionState.disconnected;
      _lastStatus = "Erreur: $e";
      _connection = null;
    }

    notifyListeners();
  }

  void disconnect() {
    if (_simulation) {
      _simulation = false;
    }

    _connection?.dispose();
    _connection = null;
    _connectionState = RobotConnectionState.disconnected;
    _lastStatus = "Déconnecté.";
    notifyListeners();
  }

  // SIMULATION

  void enableSimulation() {
    _simulation = true;
    _connectionState = RobotConnectionState.connected;
    _lastStatus = "Mode simulation activé ✔";
    notifyListeners();
  }

  void _sendSimulated(Command cmd) {
    _lastStatus = "Commande simulée : ${cmd.code}";
    notifyListeners();
  }

  // RÉCEPTION

  void _onDataReceived(Uint8List data) {
    try {
      String message = String.fromCharCodes(data).trim();
      if (message.isEmpty) return;

      _mpuData = message;
      notifyListeners();

    } catch (e) {
      print("Erreur décodage MPU: $e");
    }
  }

  //  ENVOI CMD - CORRIGÉ POUR AJOUTER \n

  void sendCommand(Command cmd) async {
    // Mode automatique : envoie en continu (dans l'étape suivante)
    if (_autoMode && cmd == Command.start) {
      _lastStatus = "Mode automatique → contrôle IA";
      notifyListeners();
    }

    if (_simulation) {
      _sendSimulated(cmd);
      return;
    }

    if (_connectionState != RobotConnectionState.connected ||
        _connection == null) {
      _lastStatus = "Non connecté → commande ignorée.";
      notifyListeners();
      return;
    }

    try {
      // IMPORTANT: Ajouter '\n' à la fin pour que l'Arduino reconnaisse la commande
      String message;
      if (cmd == Command.start) {
        message = 'START\n';  // '\n' est crucial pour la commande START
      } else {
        message = '${cmd.code}\n';  // '\n' pour toutes les autres commandes
      }

      _connection!.output.add(Uint8List.fromList(message.codeUnits));
      await _connection!.output.allSent;

      _lastStatus = "Commande envoyée: ${cmd.code}";
    } catch (e) {
      _lastStatus = "Erreur envoi: $e";
    }

    notifyListeners();
  }

  // Commandes playstation - MODIFIÉES

  void startCar() => sendCommand(Command.start);
  void accelerate() => sendCommand(Command.accel);
  void brake() => sendCommand(Command.brake);
  void reverse() => sendCommand(Command.reverse);  // NOUVEAU
  void stop() => sendCommand(Command.stop);

  // Supprimer driftMode() puisque drift est retiré

  // Nouveau getter pour vérifier la connexion
  bool get isConnected => _connectionState == RobotConnectionState.connected;

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }

  void resetColors() {
    _backgroundColor = 0xFF001133;
    _buttonGlowColor = 0xFF00FFFF;
    notifyListeners();
  }
}