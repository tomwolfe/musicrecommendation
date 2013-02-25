class Itunes
	AFFILIATE_WRAPPER = "http://click.linksynergy.com/fs-bin/stat?id=CBIMl*gYY/8&offerid=146261&type=3&subid=0&tmpid=1826&RD_PARM1="
	PARTNER_ID = "30"

	def self.itunes_data(track)
		results = ITunesSearchAPI.search(term: "#{track.artist_name} #{track.name}", media: "music", entity: "song")
		results.empty? ? [] : results
	end

	def self.itunes_affiliate_data
		base_data = self.itunes_track_data
		return [] if base_data.empty?
		base_data.collect { |hash| modify_url(hash) }
	end
	
	def self.modify_url(hash)
		urls_to_modify = %w{artistViewUrl collectionViewUrl trackViewUrl}
		urls_to_modify.each { |url| hash[url] = "#{AFFILIATE_WRAPPER}#{Track.escape_link(hash[url])}" }
		hash
	end

	def self.escape_link(link)
		CGI.escape(CGI.escape("#{link}&partnerId=#{PARTNER_ID}"))
	end
end
