class Event {
  final int eventId;

  Event(this.eventId);

  @override
  bool operator ==(other) => this.eventId == other.eventId;

  @override
  int get hashCode => this.eventId.hashCode;
}
