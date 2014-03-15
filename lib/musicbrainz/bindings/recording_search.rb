# -*- encoding : utf-8 -*-
module MusicBrainz
  module Bindings
    module RecordingSearch 
      def parse(xml)
        xml.xpath('./recording-list/recording').map do |xml|
          {
            id: (xml.attribute('id').value rescue nil),
            mbid: (xml.attribute('id').value rescue nil), # Old shit
            title: (xml.xpath('./title').text.gsub(/[`’]/, "'") rescue nil),
            artist: (xml.xpath('./artist-credit/name-credit/artist').map { |xml| 
              { 
                mbid: xml.attribute('id'), 
                name: xml.xpath('./name').text
              }
            } rescue nil),
						releases: (xml.xpath('./release-list/release').map{ |xml| 
              {
                mbid: xml.attribute('id'), 
                title: xml.xpath('./title').text,
                status: xml.xpath('./status').text,
                type: xml.xpath('./release-group').attribute('type'),
                date: xml.xpath('./date').text,
                country: xml.xpath('./country').text
              } 
            } rescue []),
						score: (xml.attribute('score').value.to_i rescue nil)
          } rescue nil
        end.delete_if{ |item| item.nil? }
      end

      extend self
    end
  end
end
