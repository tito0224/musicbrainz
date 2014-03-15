# -*- encoding : utf-8 -*-

require "spec_helper"

describe MusicBrainz::ReleaseGroup do
  describe '.find' do
    it "gets no exception while loading release group info" do
      lambda {
        MusicBrainz::ReleaseGroup.find("6f33e0f0-cde2-38f9-9aee-2c60af8d1a61")
      }.should_not raise_error(Exception)
    end
  
    it "gets correct instance" do
      release_group = MusicBrainz::ReleaseGroup.find("6f33e0f0-cde2-38f9-9aee-2c60af8d1a61")
      release_group.should be_an_instance_of(MusicBrainz::ReleaseGroup)
    end
  
    it "gets correct release group data" do
      release_group = MusicBrainz::ReleaseGroup.find("6f33e0f0-cde2-38f9-9aee-2c60af8d1a61")
      release_group.id.should == "6f33e0f0-cde2-38f9-9aee-2c60af8d1a61"
      release_group.type.should == "Album"
      release_group.title.should == "Empire"
      release_group.first_release_date.should == Date.new(2006, 8, 28)
      release_group.urls[:wikipedia].should == 'http://en.wikipedia.org/wiki/Empire_(Kasabian_album)'
    end
  end
  
  describe '.search' do
    context 'without type filter' do
      it "searches release group by artist name and title" do
        matches = MusicBrainz::ReleaseGroup.search('Kasabian', 'Empire')
        matches.length.should be > 0
        matches.first[:title].should == 'Empire'
        matches.first[:type].should == 'Album'
      end
    end
    
    context 'with type filter' do
      it "searches release group by artist name and title" do
        matches = MusicBrainz::ReleaseGroup.search('Kasabian', 'Empire', 'Album')
        matches.length.should be > 0
        matches.first[:title].should == 'Empire'
        matches.first[:type].should == 'Album'
      end
    end
  end
  
  describe '.find_by_artist_and_title' do
    it "gets first release group by artist name and title" do
      release_group = MusicBrainz::ReleaseGroup.find_by_artist_and_title('Kasabian', 'Empire')
      release_group.id.should == '6f33e0f0-cde2-38f9-9aee-2c60af8d1a61'
    end
  end
  
  describe '#releases' do
    it "gets correct release group's releases" do
      MusicBrainz::Client.any_instance.stub(:get_contents).with('http://musicbrainz.org/ws/2/release-group/6f33e0f0-cde2-38f9-9aee-2c60af8d1a61?inc=url-rels').
      and_return({ status: 200, body: File.open(File.join(File.dirname(__FILE__), "../fixtures/release_group/entity.xml")).read})
      
      MusicBrainz::Client.any_instance.stub(:get_contents).with('http://musicbrainz.org/ws/2/release?release-group=6f33e0f0-cde2-38f9-9aee-2c60af8d1a61&inc=media+release-groups&limit=100').
      and_return({ status: 200, body: File.open(File.join(File.dirname(__FILE__), "../fixtures/release/list.xml")).read})
      
      releases = MusicBrainz::ReleaseGroup.find("6f33e0f0-cde2-38f9-9aee-2c60af8d1a61").releases
      releases.length.should be >= 5
      releases.first.id.should == "30d5e730-ce0a-464d-93e1-7d76e4bb3e31"
      releases.first.status.should == "Official"
      releases.first.title.should == "Empire"
      releases.first.date.should == Date.new(2006, 8, 28)
      releases.first.country.should == "GB"
      releases.first.type.should == "Album"
    end
  end
end
