class VetVisit {
  final int id;
  final String date;
  final String notes;
  final int vetId;
  final int dogProfileId;
  final List<String> documentPaths;

  VetVisit(this.id, this.date, this.notes, this.vetId, this.dogProfileId, this.documentPaths);
}