#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'net/http'
require 'uri'

def query(radical, type)
  {
    action: 'query',
    generator: 'search',
    gsrnamespace: '6',
    gsrsearch: "#{radical}-#{type}.svg",
    prop: 'imageinfo',
    iiprop: 'url',
    format: 'xml'
  }.map {|attr, value| "#{attr}=#{URI.escape(value)}"}.join('&')
end

url = URI::HTTP.build(
  host: 'commons.wikimedia.org',
  path: '/w/api.php',
  query: query('火', 'oracle')
)

req = Net::HTTP::Get.new(url.path)
req.add_field("User-Agent", "Analects Data (arne@arnebrasseur.net)")
res = Net::HTTP.new(url.host, url.port).start do |http|
  http.request(req)
end
puts res.body

# #x=HTTParty.get('https://commons.wikimedia.org/w/api.php?action=query&generator=search&gsrnamespace=6&gsrsearch=' + URI.escape('火-oracle.svg') + '&gsrlimit=20&gsroffset=20&prop=imageinfo&iiprop=url&format=xml', :headers => { 'User-Agent' => 'Birdsound (arne.brasseur@gmail.com)' })
# x=HTTParty.get('https://commons.wikimedia.org/w/api.php?action=query&generator=search&gsrnamespace=6&gsrsearch=' + URI.escape('火-oracle.svg') + '&prop=imageinfo&iiprop=url&format=xml', :headers => { 'User-Agent' => 'Birdsound (arne.brasseur@gmail.com)' })

# p( x.parsed_response )
# >> "http://commons.wikimedia.org/w/api.php?action=query&generator=search&gsrnamespace=6&gsrsearch=%E7%81%AB-oracle.svg&prop=imageinfo&iiprop=url&format=xml"
