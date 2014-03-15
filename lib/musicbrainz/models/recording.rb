module MusicBrainz
  class Recording < BaseModel
    field :id, String
    field :mbid, String
    field :title, String
    field :artist, String
		field :releases, String
		field :score, Integer

    class << self
      def find(id)
				super({ id: id })
      end

			def search(track_name, artist_name)
				super({recording: track_name, artist: artist_name})
			end

      def search(release_name, track_name, artist_name)
        super({release: release_name, recording: track_name, artist: artist_name})
      end

      def search(query = {}) 
        super(query)
      end
    end
  end
end
