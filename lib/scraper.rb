require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = File.read(index_url)
    index = Nokogiri::HTML(html)
    index.css('div.roster-cards-container div.student-card').collect do |student|
    	{:name => student.css('div.card-text-container h4.student-name').text,
    	 :location => student.css('div.card-text-container p.student-location').text,
    	 :profile_url => student.css('a').attribute('href').value
    	}
    end

  end

  def self.scrape_profile_page(profile_url)
    html = File.read(profile_url)
    profile = Nokogiri::HTML(html)
    student_hash = {
    	:profile_quote => profile.css('div.profile-quote').text,
    	:bio => profile.css('div.description-holder p').text}	

    social_icons = profile.css('div.social-icon-container a')

   

    twitter = social_icons.find{|x| x.attribute('href').value.include?('twitter')}
   	github = social_icons.find{|x| x.attribute('href').value.include?('github')}
   	linkedin = social_icons.find{|x| x.attribute('href').value.include?('linkedin')}
   	blog = social_icons.find do |x|
   		!x.attribute('href').value.include?('twitter') && !x.attribute('href').value.include?('github') && !x.attribute('href').value.include?('linkedin')
   	end

   	student_hash[:twitter] = twitter.attribute('href').value if twitter
   	student_hash[:github] = github.attribute('href').value if github
   	student_hash[:linkedin] = linkedin.attribute('href').value if linkedin
   	student_hash[:blog] = blog.attribute('href').value if blog

   	student_hash
  end
    

end



