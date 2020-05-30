mixin Parcelable {
  Map<String, Object> metadata;

  Object getMetadata(String key, Object fallback) {
    if (this.metadata == null || !this.metadata.containsKey(key))
      return fallback;
    else
      return this.metadata[key];
  }
}
