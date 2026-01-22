import 'package:flutter/material.dart';
import 'package:kaly_point/models/check_point.dart';
import 'package:kaly_point/dto/edit_check_point_dto.dart';
import 'package:kaly_point/dto/new_check_point_dto.dart';
import 'package:kaly_point/services/checkpoint_service.dart';

class CheckpointViewmodel extends ChangeNotifier {
  final CheckpointService _checkpointService = CheckpointService();

  final List<CheckPoint> _checkPoints = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = false;
  int _currentPage = 1;
  final int _pageSize = 5;
  String? _errorMessage;

  //Getters
  List<CheckPoint> get checkpoints => _checkPoints;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get errorMessage => _errorMessage;


  Future<void> initialize({required int sessionId, bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      _checkPoints.clear();
      notifyListeners();
    } else {
      _isLoading = true;
      notifyListeners();
    }

    await fetchCheckPoints(sessionId:sessionId);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadMore({required int sessionId}) async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    _currentPage++;
    notifyListeners();
    await fetchCheckPoints(sessionId: sessionId);

    _isLoadingMore = false;
    notifyListeners();
  }
  
  Future<void> fetchCheckPoints({required int sessionId}) async {
    _isLoading = true;
    _errorMessage = null;
    _checkPoints.clear();
    notifyListeners();
    try {
      final checkpoints = await _checkpointService.getCheckPoints(
        page: _currentPage,
        limit: _pageSize,
        sessionId: sessionId
      );
      if (checkpoints.isNotEmpty) {
        _checkPoints.addAll(checkpoints);
        _hasMore = true;
      } else {
        _hasMore = false;
      }
    } catch (e) {
      _errorMessage = 'Erreur lors de la récupération de la liste des pointages';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteCheckpoint(int checkpointId, int sessionId) async {
    try {
      await _checkpointService.deleteCheckPoint(checkpointId);
        _checkPoints.remove(_checkPoints.where((s) => s.id == checkpointId).first);

      if(_checkPoints.length < _pageSize){
        _checkPoints.clear();
        await fetchCheckPoints(sessionId: sessionId);
      }

      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to delete session: $e';
    } finally {
      notifyListeners();
    }
  }

  void createCheckPoint(NewCheckPointDto newCheckPoint) async {
    if (newCheckPoint.title.isEmpty) {
      _errorMessage = 'Titre pointage ne peut être vide';
      notifyListeners();
      return;
    }

    try {
      int idNewCheckPoint = await _checkpointService.insertNewCheckPoint(newCheckPoint);
      _checkPoints.insert(0, CheckPoint(id: idNewCheckPoint, title: newCheckPoint.title, createdAt: newCheckPoint.createdAt, description: newCheckPoint.description, sessionId: newCheckPoint.sessionId));
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Impossible de créer le pointage!!';
    }
    notifyListeners();
  }

  Future<void> saveCheckPoint(EditCheckPointDto editCheckPoint) async {
    try {
      final checkPointUpdated = await _checkpointService.updateCheckPoint(editCheckPoint);
      final index = _checkPoints.indexWhere((s) => s.id == editCheckPoint.id);
      if (index != -1) {
        final checkPoint = _checkPoints[index];
        _checkPoints[index] = CheckPoint(
          id: checkPointUpdated.id,
          title: checkPointUpdated.title,
          description: checkPointUpdated.description,
          createdAt: checkPoint.createdAt,
          sessionId: checkPoint.sessionId
        );
      }
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Erreur lors de la mise à jour';
    }
    notifyListeners();
  }
}