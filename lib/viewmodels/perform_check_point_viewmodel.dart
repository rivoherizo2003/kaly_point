import 'package:flutter/material.dart';
import 'package:kaly_point/dto/new_person_dto.dart';
import 'package:kaly_point/dto/new_person_check_point_dto.dart';
import 'package:kaly_point/dto/new_session_person_dto.dart';
import 'package:kaly_point/dto/person_check_point_dto.dart';
import 'package:kaly_point/models/person.dart';
import 'package:kaly_point/models/person_check_point.dart';
import 'package:kaly_point/models/session_person.dart';
import 'package:kaly_point/models/state_check_point.dart';
import 'package:kaly_point/services/check_point_person_service.dart';
import 'package:kaly_point/services/perform_checkpoint_session_service.dart';
import 'package:kaly_point/services/person_service.dart';
import 'package:kaly_point/services/session_person_service.dart';

class PerformCheckPointViewModel extends ChangeNotifier {
  final PerformCheckpointSessionService _performCheckPointSessionService =
      PerformCheckpointSessionService();
  final PersonService _personService = PersonService();
  final SessionPersonService _sessionPersonService = SessionPersonService();
  final CheckPointPersonService _checkPointPersonService = CheckPointPersonService();

  List<PersonCheckPointDto> _personsToServe = [];
  List<PersonCheckPointDto> get personsToServe => _personsToServe;

  List<PersonCheckPointDto> _personsServed = [];
  List<PersonCheckPointDto> get personsServed => _personsServed;


  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = false;
  int _currentPage = 1;
  final int _pageSize = 5;
  String? _errorMessage;


  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoadingMore => _isLoadingMore;

  StateCheckPoint _stateCheckPoint = StateCheckPoint(
    nbrPersonInSession: 0,
    nbrPersonServed: 0,
    nbrPersonToServe: 0,
  );
  StateCheckPoint get stateCheckPoint => _stateCheckPoint;
  
  Future<void> initialize({
    required int sessionId,
    required int checkPointId,
  }) async {
    await fetchStateCheckPoint(
      sessionId: sessionId,
      checkPointId: checkPointId,
    );
    notifyListeners();
  }

  Future<void> fetchStateCheckPoint({
    required int sessionId,
    required int checkPointId,
  }) async {
    int nbrPersonInSession = await _performCheckPointSessionService
        .countPersonInSession(sessionId: sessionId);
    int nbrServedPersonCheckPoint = await _performCheckPointSessionService
        .countServedPersonCheckPoint(
          sessionId: sessionId,
          checkPointId: checkPointId,
        );

    _stateCheckPoint = StateCheckPoint(
      nbrPersonInSession: nbrPersonInSession,
      nbrPersonServed: nbrServedPersonCheckPoint,
      nbrPersonToServe: (nbrPersonInSession - nbrServedPersonCheckPoint),
    );
  }

  Future<void> assignNewPersonToCheckPointAndSession(NewPersonDto newPerson, int checkPointId, int sessionId) async {
    late Person person;
    try {
      person = await _personService.insertPerson(newPerson);
      
      _errorMessage = null;
    } catch (error) {
      _errorMessage = 'Erreur lors de la création d\'une personne';
    }

    //add this person to session
    try {
      await _sessionPersonService.assignPersonToSession(
        NewSessionPersonDto(
          personId: person.id,
          sessionId: sessionId,
          createdAt: DateTime.now(),
        ),
      );
    } catch (error) {
      _errorMessage = 'Erreur lors de l\'ajout de la personne sur une session';
    }

    //add this person to check point of the session
    try {
      NewPersonCheckPointDto newPersonCheckPointDto = NewPersonCheckPointDto(personId: person.id, sessionId: sessionId, checkPointId: checkPointId, createdAt: DateTime.now());
      PersonCheckPoint personCheckPoint = await _checkPointPersonService.createPersonCheckPoint(newPersonCheckPointDto);

      _personsServed.insert(
        0,
        PersonCheckPointDto(personId: person.id, sessionId: sessionId, checkPointId: checkPointId, lastname: person.lastname, firstname: person.firstname, id: personCheckPoint.id),
      );
    } catch (error) {
      _errorMessage = 'Erreur lors de l\'affection de la personne à un pointage';
    }
    notifyListeners();
  }

  Future<void> loadMore({required int sessionId, required int checkPointId}) async {
    if(_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    _currentPage++;
    notifyListeners();
    await fetchToServePersons(
      sessionId: sessionId,
      checkPointId: checkPointId,
    );

    _isLoadingMore = false;
    notifyListeners();
  }
  
  Future<void> fetchToServePersons({required int sessionId, required int checkPointId}) async {
    _isLoading = true;
    _errorMessage = null;
    _personsServed.clear();
    notifyListeners();

    try {
      final personsToServe = await _checkPointPersonService.fetchToServePersons(sessionId:sessionId,page: _currentPage,
        limit: _pageSize,);
        if(personsToServe.isNotEmpty){
          _personsToServe.addAll(personsToServe);
          _hasMore = true;
        } else {
          _hasMore = false;
        }
    } catch (e) {
      _errorMessage = 'Erreur lors de la récupération de la liste des personnes à servir';
    } finally{
      _isLoading = false;
      notifyListeners();
    }
  }
}
