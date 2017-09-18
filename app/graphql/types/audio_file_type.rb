Types::AudioFileType = GraphQL::ObjectType.define do
  name 'AudioFile'

  backed_by_model :audio_file do
    attr :id
    attr :url
    attr :duration
    attr :segments
    attr :recitation_id
  end
end
