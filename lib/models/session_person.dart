class SessionPerson {
  int id;
  int personId;
  int sessionId;
  DateTime createdAt;
  SessionPerson({
    required this.id,
    required this.personId,
    required this.sessionId,
    required this.createdAt,
  });

  factory SessionPerson.fromMap(Map<String, dynamic> map){
    return SessionPerson(id: map['id'], personId: map["person_id"], sessionId: map['session_id'], createdAt: map['created_at']);
  }
}
