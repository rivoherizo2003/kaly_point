import 'package:flutter/material.dart';
import 'package:kaly_point/dto/new_person_dto.dart';
import 'package:kaly_point/dto/new_person_check_point_dto.dart';
import 'package:kaly_point/dto/new_session_person_dto.dart';
import 'package:kaly_point/dto/person_check_point_dto.dart';
import 'package:kaly_point/models/person.dart';
import 'package:kaly_point/models/person_check_point.dart';
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
  final CheckPointPersonService _checkPointPersonService =
      CheckPointPersonService();

  final List<PersonCheckPointDto> _personsToServe = [];
  List<PersonCheckPointDto> get personsToServe => _personsToServe;

  final List<PersonCheckPointDto> _personsServed = [];
  List<PersonCheckPointDto> get personsServed => _personsServed;

  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = false;
  int _currentPage = 1;
  final int _pageSize = 15;
  String? _errorMessage;


  bool _isListPersonsToServeRefreshed = false;
  bool _isListPersonsServedRefreshed = false;
  bool _isLoadingServedPersons = false;
  bool _isLoadingMoreServedPersons = false;
  int _currentPageServedPersons = 1;
  bool _hasMoreServedPersons = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoadingMore => _isLoadingMore;
  bool get isListPersonsToServeRefreshed => _isListPersonsToServeRefreshed;

  bool get isListPersonsServedRefreshed => _isListPersonsServedRefreshed;
  bool get isLoadingServedPersons => _isLoadingServedPersons;
  bool get isLoadingMoreServedPersons => _isLoadingMoreServedPersons;
  int get currentPageServedPersons => _currentPageServedPersons;
  bool get hasMoreServedPersons => _hasMoreServedPersons;

  StateCheckPoint _stateCheckPoint = StateCheckPoint(
    nbrPersonInSession: 0,
    nbrPersonServed: 0,
    nbrPersonToServe: 0,
  );
  StateCheckPoint get stateCheckPoint => _stateCheckPoint;

  Future<void> initializeTabToServePersons({
    required int sessionId,
    required int checkPointId,
  }) async {
    if (isListPersonsToServeRefreshed) return;

    debugPrint("initializeTabToServePersons $isListPersonsToServeRefreshed");
    await fetchStateCheckPoint(
      sessionId: sessionId,
      checkPointId: checkPointId,
    );
    notifyListeners();

    await fetchToServePersons(sessionId: sessionId, checkPointId: checkPointId);
    notifyListeners();

    _isListPersonsToServeRefreshed = true;
    notifyListeners();
  }

  Future<void> initializeTabServedPersons({
    required int sessionId,
    required int checkPointId,
  }) async {
    if (isListPersonsServedRefreshed) return;

    await fetchStateCheckPoint(
      sessionId: sessionId,
      checkPointId: checkPointId,
    );
    notifyListeners();

    await fetchServedPersons(sessionId: sessionId, checkPointId: checkPointId);
    notifyListeners();

    _isListPersonsServedRefreshed = true;
    notifyListeners();
  }

  Future<void> fetchStateCheckPoint({
    required int sessionId,
    required int checkPointId,
  }) async {
    debugPrint("fetch state point");
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
    notifyListeners();
  }

  Future<void> assignNewPersonToCheckPointAndSession(
    NewPersonDto newPerson,
    int checkPointId,
    int sessionId,
  ) async {
    late Person person;
    _errorMessage = null;
    try {
      person = await _personService.insertPerson(newPerson);
      notifyListeners();
    } catch (error) {
      _errorMessage = 'Erreur lors de la création d\'une personne';
      notifyListeners();
      return;
    }

    //add this person to session
    assignPersonToSession(personId: person.id, sessionId: sessionId);

    //add this person to check point of the session
    try {
      NewPersonCheckPointDto newPersonCheckPointDto = NewPersonCheckPointDto(
        personId: person.id,
        sessionId: sessionId,
        checkPointId: checkPointId,
        createdAt: DateTime.now(),
      );
      PersonCheckPoint personCheckPoint = await _checkPointPersonService
          .createPersonCheckPoint(newPersonCheckPointDto);

      _personsServed.insert(
        0,
        PersonCheckPointDto(
          personId: person.id,
          lastname: person.lastname,
          firstname: person.firstname,
          checkPointId: checkPointId,
          checkPointPersonId: personCheckPoint.id,
        ),
      );
      notifyListeners();
    } catch (error) {
      _errorMessage =
          'Erreur lors de l\'affection de la personne à un pointage';
      notifyListeners();
      return;
    }

    await fetchStateCheckPoint(
      sessionId: sessionId,
      checkPointId: checkPointId,
    );
  }

  Future<void> assignPersonToCheckPoint(
    int personId,
    int checkPointId,
    int sessionId,
  ) async {
    //add this person to check point of the session
    try {
      NewPersonCheckPointDto newPersonCheckPointDto = NewPersonCheckPointDto(
        personId: personId,
        sessionId: sessionId,
        checkPointId: checkPointId,
        createdAt: DateTime.now(),
      );
      PersonCheckPoint personCheckPoint = await _checkPointPersonService
          .createPersonCheckPoint(newPersonCheckPointDto);
      final Person person = await _personService.findOneById(personId);
      _personsServed.insert(
        0,
        PersonCheckPointDto(
          personId: person.id,
          lastname: person.lastname,
          firstname: person.firstname,
          checkPointId: checkPointId,
          checkPointPersonId: personCheckPoint.id,
        ),
      );
      _isListPersonsToServeRefreshed = false;
      _errorMessage = null;
      notifyListeners();
    } catch (error) {
      _errorMessage =
          'Erreur lors de l\'affection de la personne à un pointage';
      notifyListeners();
    }

    await fetchStateCheckPoint(
      sessionId: sessionId,
      checkPointId: checkPointId,
    );
  }

  Future<void> loadMoreToServePersons({
    required int sessionId,
    required int checkPointId,
  }) async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    _currentPage++;
    notifyListeners();
    await fetchToServePersons(sessionId: sessionId, checkPointId: checkPointId);

    _isLoadingMore = false;
    notifyListeners();
  }

  Future<void> loadMoreServedPersons({
    required int sessionId,
    required int checkPointId,
  }) async {
    if (_isLoadingMoreServedPersons) return;

    _isLoadingMoreServedPersons = true;
    notifyListeners();

    _currentPageServedPersons++;
    notifyListeners();
    await fetchServedPersons(sessionId: sessionId, checkPointId: checkPointId);

    _isLoadingMoreServedPersons = false;
    notifyListeners();
  }

  Future<void> fetchToServePersons({
    required int sessionId,
    required int checkPointId,
  }) async {
    debugPrint("to serve persons");
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      int offset = (_currentPage - 1) * _pageSize;
      notifyListeners();
      final personsToServe = await _checkPointPersonService.fetchToServePersons(
        checkPointId: checkPointId,
        limit: _pageSize,
        offset: offset,
      );
      if (personsToServe.isNotEmpty) {
        _personsToServe.addAll(personsToServe);
        _hasMore = true;
      } else {
        _hasMore = false;
      }
    } catch (e) {
      debugPrint("error $e");
      _errorMessage =
          'Erreur lors de la récupération de la liste des personnes à servir';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchServedPersons({
    required int sessionId,
    required int checkPointId,
  }) async {
    debugPrint("fetch served persons");
    _isLoadingServedPersons = true;
    _errorMessage = null;
    notifyListeners();
    try {
      int offset = (_currentPageServedPersons - 1) * _pageSize;
      notifyListeners();
      final personsServed = await _checkPointPersonService.fetchServedPersons(
        checkPointId: checkPointId,
        limit: _pageSize,
        offset: offset,
      );
      if (personsServed.isNotEmpty) {
        _personsServed.addAll(personsServed);
        _hasMoreServedPersons = true;
      } else {
        _hasMoreServedPersons = false;
      }
    } catch (e) {
      _errorMessage =
          'Erreur lors de la récupération de la liste des personnes servi';
    } finally {
      _isLoadingServedPersons = false;
      notifyListeners();
    }
  }

  Future<void> deletePersonCheckPoint(
    int checkPointPersonId,
    int sessionId,
    int checkPointId,
  ) async {
    debugPrint("deletePersonCheckPoint");
    try {
      await _checkPointPersonService.deleteCheckPointPerson(
        checkPointPersonId: checkPointPersonId,
      );
      _personsServed.remove(
        _personsServed
            .where((s) => s.checkPointPersonId == checkPointPersonId)
            .first,
      );
      _errorMessage = null;
      _isListPersonsToServeRefreshed = false;
      notifyListeners();
    } catch (e) {
      _errorMessage =
          'Erreur lors de la récupération de la liste des personnes servi';
      notifyListeners();
    }

    await fetchStateCheckPoint(
      sessionId: sessionId,
      checkPointId: checkPointId,
    );
  }

  Future<void> searchPerson(
    String query,
    int sessionId,
    int checkPointId,
    int indexActiveTab,
  ) async {
    try {
      if (query.isEmpty) {
        handleEmptyQuerySearchByTab(sessionId, checkPointId, indexActiveTab);
        return;
      }
      final searchResults = await _performCheckPointSessionService.searchPerson(
        query,
        indexActiveTab,
        checkPointId,
        sessionId
      );
      handleSearchResultByTab(searchResults, indexActiveTab);
    } catch (error) {
      _errorMessage = "Erreur lors de la recherche d'une personne.";
      debugPrint("$error");
      notifyListeners();
    }
  }

  void handleEmptyQuerySearchByTab(
    int sessionId,
    int checkPointId,
    int indexActiveTab,
  ) {
    if (indexActiveTab == 0) {
      _personsToServe.clear();
        _isListPersonsToServeRefreshed = false;
      fetchToServePersons(sessionId: sessionId, checkPointId: checkPointId);
      return;
    }
    _personsServed.clear();
    _isListPersonsServedRefreshed = false;
    fetchServedPersons(sessionId: sessionId, checkPointId: checkPointId);
  }

  void handleSearchResultByTab(
    List<PersonCheckPointDto> results,
    int indexActiveTab,
  ) {
    if (indexActiveTab == 0) {
      _personsToServe.clear();
      _personsToServe.addAll(results);
      notifyListeners();
      return;
    }
    _personsServed.clear();
    _personsServed.addAll(results);
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> assignPersonToSession({
    required int personId,
    required int sessionId,
  }) async {
    try {
      await _sessionPersonService.assignPersonToSession(
        NewSessionPersonDto(
          personId: personId,
          sessionId: sessionId,
          createdAt: DateTime.now(),
        ),
      );
    } catch (error) {
      _errorMessage = 'Erreur lors de l\'ajout de la personne sur une session';
      notifyListeners();
      return;
    }
  }
}
