#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'net/http'
require 'uri'
require 'nokogiri'

$LOAD_PATH.unshift(File.join(ENV['HOME'], 'github', 'analects', 'lib'))

require 'analects'

def query(radical, type)
  {
    action: 'query',
    generator: 'search',
    gsrnamespace: '6',
    gsrsearch: "\"#{radical}-#{type}.svg\"",
    prop: 'imageinfo',
    iiprop: 'url',
    format: 'xml'
  }.map {|attr, value| "#{attr}=#{URI.escape(value)}"}.join('&')
end

def build_url(radical, type)
  URI::HTTP.build(
    host: 'commons.wikimedia.org',
    path: '/w/api.php',
    query: query(radical, type)
  )
end

def local_file(radical, type, index = nil)
  basename = [radical, type, index].compact.join('-')
  File.expand_path("../../ancient_radicals/#{ basename }.svg", __FILE__)
end

UA = "Analects Data (arne@arnebrasseur.net)"

def request(url)
  #puts url
  http = Net::HTTP.new(url.host, url.port)
  req  = Net::HTTP::Get.new(url, {'User-Agent' => UA})
  response = http.request(req)
  response
end

def fetch(radical, type)
  retries = 0

  res = request(URI(URI.escape("http://commons.wikimedia.org/wiki/File:#{radical}-#{type}.svg")))

  return false unless res && res.code == '200'

    doc = Nokogiri(res.body)

    unless doc
      puts 'no doc'
      return false
    end

    link = (doc / '.fullImageLink a').first

    unless link
      puts 'no link'
      return false
    end

    return fetch_image(radical, type, URI('http:' + link['href']))

    true
end

def fetch_image(radical, type, url, index = nil)
  svg = request(URI(url))

  unless svg.code == '200'
    puts 'no svg'
    return false
  end

  File.write(local_file(radical, type, index), svg.body)
end

def green(s)
  "\e[32m%s\e[0m" % s
end

def red(s)
  "\e[31m%s\e[0m" % s
end

def blue(s)
  "\e[34m%s\e[0m" % s
end

%w[oracle bronze bigseal seal].each do |type|
  puts "= #{type} ============================================================"
  Analects::Models::Zi.each_radical do |radical|
    radical = Analects::Models::KangxiRadical.compat(radical)
    if File.exist?(local_file(radical, type))
      print blue(radical)
      next
    end
    result = fetch(radical,type)
    print(result ? green(radical) : red(radical))
    sleep 1
  end
  puts
end

__END__
2F00;KANGXI RADICAL ONE;So;0;ON;<compat> 4E00;;;;N;;;;;
2F01;KANGXI RADICAL LINE;So;0;ON;<compat> 4E28;;;;N;;;;;
2F02;KANGXI RADICAL DOT;So;0;ON;<compat> 4E36;;;;N;;;;;
2F03;KANGXI RADICAL SLASH;So;0;ON;<compat> 4E3F;;;;N;;;;;
2F04;KANGXI RADICAL SECOND;So;0;ON;<compat> 4E59;;;;N;;;;;
2F05;KANGXI RADICAL HOOK;So;0;ON;<compat> 4E85;;;;N;;;;;
2F06;KANGXI RADICAL TWO;So;0;ON;<compat> 4E8C;;;;N;;;;;
2F07;KANGXI RADICAL LID;So;0;ON;<compat> 4EA0;;;;N;;;;;
2F08;KANGXI RADICAL MAN;So;0;ON;<compat> 4EBA;;;;N;;;;;
2F09;KANGXI RADICAL LEGS;So;0;ON;<compat> 513F;;;;N;;;;;
2F0A;KANGXI RADICAL ENTER;So;0;ON;<compat> 5165;;;;N;;;;;
2F0B;KANGXI RADICAL EIGHT;So;0;ON;<compat> 516B;;;;N;;;;;
2F0C;KANGXI RADICAL DOWN BOX;So;0;ON;<compat> 5182;;;;N;;;;;
2F0D;KANGXI RADICAL COVER;So;0;ON;<compat> 5196;;;;N;;;;;
2F0E;KANGXI RADICAL ICE;So;0;ON;<compat> 51AB;;;;N;;;;;
2F0F;KANGXI RADICAL TABLE;So;0;ON;<compat> 51E0;;;;N;;;;;
2F10;KANGXI RADICAL OPEN BOX;So;0;ON;<compat> 51F5;;;;N;;;;;
2F11;KANGXI RADICAL KNIFE;So;0;ON;<compat> 5200;;;;N;;;;;
2F12;KANGXI RADICAL POWER;So;0;ON;<compat> 529B;;;;N;;;;;
2F13;KANGXI RADICAL WRAP;So;0;ON;<compat> 52F9;;;;N;;;;;
2F14;KANGXI RADICAL SPOON;So;0;ON;<compat> 5315;;;;N;;;;;
2F15;KANGXI RADICAL RIGHT OPEN BOX;So;0;ON;<compat> 531A;;;;N;;;;;
2F16;KANGXI RADICAL HIDING ENCLOSURE;So;0;ON;<compat> 5338;;;;N;;;;;
2F17;KANGXI RADICAL TEN;So;0;ON;<compat> 5341;;;;N;;;;;
2F18;KANGXI RADICAL DIVINATION;So;0;ON;<compat> 535C;;;;N;;;;;
2F19;KANGXI RADICAL SEAL;So;0;ON;<compat> 5369;;;;N;;;;;
2F1A;KANGXI RADICAL CLIFF;So;0;ON;<compat> 5382;;;;N;;;;;
2F1B;KANGXI RADICAL PRIVATE;So;0;ON;<compat> 53B6;;;;N;;;;;
2F1C;KANGXI RADICAL AGAIN;So;0;ON;<compat> 53C8;;;;N;;;;;
2F1D;KANGXI RADICAL MOUTH;So;0;ON;<compat> 53E3;;;;N;;;;;
2F1E;KANGXI RADICAL ENCLOSURE;So;0;ON;<compat> 56D7;;;;N;;;;;
2F1F;KANGXI RADICAL EARTH;So;0;ON;<compat> 571F;;;;N;;;;;
2F20;KANGXI RADICAL SCHOLAR;So;0;ON;<compat> 58EB;;;;N;;;;;
2F21;KANGXI RADICAL GO;So;0;ON;<compat> 5902;;;;N;;;;;
2F22;KANGXI RADICAL GO SLOWLY;So;0;ON;<compat> 590A;;;;N;;;;;
2F23;KANGXI RADICAL EVENING;So;0;ON;<compat> 5915;;;;N;;;;;
2F24;KANGXI RADICAL BIG;So;0;ON;<compat> 5927;;;;N;;;;;
2F25;KANGXI RADICAL WOMAN;So;0;ON;<compat> 5973;;;;N;;;;;
2F26;KANGXI RADICAL CHILD;So;0;ON;<compat> 5B50;;;;N;;;;;
2F27;KANGXI RADICAL ROOF;So;0;ON;<compat> 5B80;;;;N;;;;;
2F28;KANGXI RADICAL INCH;So;0;ON;<compat> 5BF8;;;;N;;;;;
2F29;KANGXI RADICAL SMALL;So;0;ON;<compat> 5C0F;;;;N;;;;;
2F2A;KANGXI RADICAL LAME;So;0;ON;<compat> 5C22;;;;N;;;;;
2F2B;KANGXI RADICAL CORPSE;So;0;ON;<compat> 5C38;;;;N;;;;;
2F2C;KANGXI RADICAL SPROUT;So;0;ON;<compat> 5C6E;;;;N;;;;;
2F2D;KANGXI RADICAL MOUNTAIN;So;0;ON;<compat> 5C71;;;;N;;;;;
2F2E;KANGXI RADICAL RIVER;So;0;ON;<compat> 5DDB;;;;N;;;;;
2F2F;KANGXI RADICAL WORK;So;0;ON;<compat> 5DE5;;;;N;;;;;
2F30;KANGXI RADICAL ONESELF;So;0;ON;<compat> 5DF1;;;;N;;;;;
2F31;KANGXI RADICAL TURBAN;So;0;ON;<compat> 5DFE;;;;N;;;;;
2F32;KANGXI RADICAL DRY;So;0;ON;<compat> 5E72;;;;N;;;;;
2F33;KANGXI RADICAL SHORT THREAD;So;0;ON;<compat> 5E7A;;;;N;;;;;
2F34;KANGXI RADICAL DOTTED CLIFF;So;0;ON;<compat> 5E7F;;;;N;;;;;
2F35;KANGXI RADICAL LONG STRIDE;So;0;ON;<compat> 5EF4;;;;N;;;;;
2F36;KANGXI RADICAL TWO HANDS;So;0;ON;<compat> 5EFE;;;;N;;;;;
2F37;KANGXI RADICAL SHOOT;So;0;ON;<compat> 5F0B;;;;N;;;;;
2F38;KANGXI RADICAL BOW;So;0;ON;<compat> 5F13;;;;N;;;;;
2F39;KANGXI RADICAL SNOUT;So;0;ON;<compat> 5F50;;;;N;;;;;
2F3A;KANGXI RADICAL BRISTLE;So;0;ON;<compat> 5F61;;;;N;;;;;
2F3B;KANGXI RADICAL STEP;So;0;ON;<compat> 5F73;;;;N;;;;;
2F3C;KANGXI RADICAL HEART;So;0;ON;<compat> 5FC3;;;;N;;;;;
2F3D;KANGXI RADICAL HALBERD;So;0;ON;<compat> 6208;;;;N;;;;;
2F3E;KANGXI RADICAL DOOR;So;0;ON;<compat> 6236;;;;N;;;;;
2F3F;KANGXI RADICAL HAND;So;0;ON;<compat> 624B;;;;N;;;;;
2F40;KANGXI RADICAL BRANCH;So;0;ON;<compat> 652F;;;;N;;;;;
2F41;KANGXI RADICAL RAP;So;0;ON;<compat> 6534;;;;N;;;;;
2F42;KANGXI RADICAL SCRIPT;So;0;ON;<compat> 6587;;;;N;;;;;
2F43;KANGXI RADICAL DIPPER;So;0;ON;<compat> 6597;;;;N;;;;;
2F44;KANGXI RADICAL AXE;So;0;ON;<compat> 65A4;;;;N;;;;;
2F45;KANGXI RADICAL SQUARE;So;0;ON;<compat> 65B9;;;;N;;;;;
2F46;KANGXI RADICAL NOT;So;0;ON;<compat> 65E0;;;;N;;;;;
2F47;KANGXI RADICAL SUN;So;0;ON;<compat> 65E5;;;;N;;;;;
2F48;KANGXI RADICAL SAY;So;0;ON;<compat> 66F0;;;;N;;;;;
2F49;KANGXI RADICAL MOON;So;0;ON;<compat> 6708;;;;N;;;;;
2F4A;KANGXI RADICAL TREE;So;0;ON;<compat> 6728;;;;N;;;;;
2F4B;KANGXI RADICAL LACK;So;0;ON;<compat> 6B20;;;;N;;;;;
2F4C;KANGXI RADICAL STOP;So;0;ON;<compat> 6B62;;;;N;;;;;
2F4D;KANGXI RADICAL DEATH;So;0;ON;<compat> 6B79;;;;N;;;;;
2F4E;KANGXI RADICAL WEAPON;So;0;ON;<compat> 6BB3;;;;N;;;;;
2F4F;KANGXI RADICAL DO NOT;So;0;ON;<compat> 6BCB;;;;N;;;;;
2F50;KANGXI RADICAL COMPARE;So;0;ON;<compat> 6BD4;;;;N;;;;;
2F51;KANGXI RADICAL FUR;So;0;ON;<compat> 6BDB;;;;N;;;;;
2F52;KANGXI RADICAL CLAN;So;0;ON;<compat> 6C0F;;;;N;;;;;
2F53;KANGXI RADICAL STEAM;So;0;ON;<compat> 6C14;;;;N;;;;;
2F54;KANGXI RADICAL WATER;So;0;ON;<compat> 6C34;;;;N;;;;;
2F55;KANGXI RADICAL FIRE;So;0;ON;<compat> 706B;;;;N;;;;;
2F56;KANGXI RADICAL CLAW;So;0;ON;<compat> 722A;;;;N;;;;;
2F57;KANGXI RADICAL FATHER;So;0;ON;<compat> 7236;;;;N;;;;;
2F58;KANGXI RADICAL DOUBLE X;So;0;ON;<compat> 723B;;;;N;;;;;
2F59;KANGXI RADICAL HALF TREE TRUNK;So;0;ON;<compat> 723F;;;;N;;;;;
2F5A;KANGXI RADICAL SLICE;So;0;ON;<compat> 7247;;;;N;;;;;
2F5B;KANGXI RADICAL FANG;So;0;ON;<compat> 7259;;;;N;;;;;
2F5C;KANGXI RADICAL COW;So;0;ON;<compat> 725B;;;;N;;;;;
2F5D;KANGXI RADICAL DOG;So;0;ON;<compat> 72AC;;;;N;;;;;
2F5E;KANGXI RADICAL PROFOUND;So;0;ON;<compat> 7384;;;;N;;;;;
2F5F;KANGXI RADICAL JADE;So;0;ON;<compat> 7389;;;;N;;;;;
2F60;KANGXI RADICAL MELON;So;0;ON;<compat> 74DC;;;;N;;;;;
2F61;KANGXI RADICAL TILE;So;0;ON;<compat> 74E6;;;;N;;;;;
2F62;KANGXI RADICAL SWEET;So;0;ON;<compat> 7518;;;;N;;;;;
2F63;KANGXI RADICAL LIFE;So;0;ON;<compat> 751F;;;;N;;;;;
2F64;KANGXI RADICAL USE;So;0;ON;<compat> 7528;;;;N;;;;;
2F65;KANGXI RADICAL FIELD;So;0;ON;<compat> 7530;;;;N;;;;;
2F66;KANGXI RADICAL BOLT OF CLOTH;So;0;ON;<compat> 758B;;;;N;;;;;
2F67;KANGXI RADICAL SICKNESS;So;0;ON;<compat> 7592;;;;N;;;;;
2F68;KANGXI RADICAL DOTTED TENT;So;0;ON;<compat> 7676;;;;N;;;;;
2F69;KANGXI RADICAL WHITE;So;0;ON;<compat> 767D;;;;N;;;;;
2F6A;KANGXI RADICAL SKIN;So;0;ON;<compat> 76AE;;;;N;;;;;
2F6B;KANGXI RADICAL DISH;So;0;ON;<compat> 76BF;;;;N;;;;;
2F6C;KANGXI RADICAL EYE;So;0;ON;<compat> 76EE;;;;N;;;;;
2F6D;KANGXI RADICAL SPEAR;So;0;ON;<compat> 77DB;;;;N;;;;;
2F6E;KANGXI RADICAL ARROW;So;0;ON;<compat> 77E2;;;;N;;;;;
2F6F;KANGXI RADICAL STONE;So;0;ON;<compat> 77F3;;;;N;;;;;
2F70;KANGXI RADICAL SPIRIT;So;0;ON;<compat> 793A;;;;N;;;;;
2F71;KANGXI RADICAL TRACK;So;0;ON;<compat> 79B8;;;;N;;;;;
2F72;KANGXI RADICAL GRAIN;So;0;ON;<compat> 79BE;;;;N;;;;;
2F73;KANGXI RADICAL CAVE;So;0;ON;<compat> 7A74;;;;N;;;;;
2F74;KANGXI RADICAL STAND;So;0;ON;<compat> 7ACB;;;;N;;;;;
2F75;KANGXI RADICAL BAMBOO;So;0;ON;<compat> 7AF9;;;;N;;;;;
2F76;KANGXI RADICAL RICE;So;0;ON;<compat> 7C73;;;;N;;;;;
2F77;KANGXI RADICAL SILK;So;0;ON;<compat> 7CF8;;;;N;;;;;
2F78;KANGXI RADICAL JAR;So;0;ON;<compat> 7F36;;;;N;;;;;
2F79;KANGXI RADICAL NET;So;0;ON;<compat> 7F51;;;;N;;;;;
2F7A;KANGXI RADICAL SHEEP;So;0;ON;<compat> 7F8A;;;;N;;;;;
2F7B;KANGXI RADICAL FEATHER;So;0;ON;<compat> 7FBD;;;;N;;;;;
2F7C;KANGXI RADICAL OLD;So;0;ON;<compat> 8001;;;;N;;;;;
2F7D;KANGXI RADICAL AND;So;0;ON;<compat> 800C;;;;N;;;;;
2F7E;KANGXI RADICAL PLOW;So;0;ON;<compat> 8012;;;;N;;;;;
2F7F;KANGXI RADICAL EAR;So;0;ON;<compat> 8033;;;;N;;;;;
2F80;KANGXI RADICAL BRUSH;So;0;ON;<compat> 807F;;;;N;;;;;
2F81;KANGXI RADICAL MEAT;So;0;ON;<compat> 8089;;;;N;;;;;
2F82;KANGXI RADICAL MINISTER;So;0;ON;<compat> 81E3;;;;N;;;;;
2F83;KANGXI RADICAL SELF;So;0;ON;<compat> 81EA;;;;N;;;;;
2F84;KANGXI RADICAL ARRIVE;So;0;ON;<compat> 81F3;;;;N;;;;;
2F85;KANGXI RADICAL MORTAR;So;0;ON;<compat> 81FC;;;;N;;;;;
2F86;KANGXI RADICAL TONGUE;So;0;ON;<compat> 820C;;;;N;;;;;
2F87;KANGXI RADICAL OPPOSE;So;0;ON;<compat> 821B;;;;N;;;;;
2F88;KANGXI RADICAL BOAT;So;0;ON;<compat> 821F;;;;N;;;;;
2F89;KANGXI RADICAL STOPPING;So;0;ON;<compat> 826E;;;;N;;;;;
2F8A;KANGXI RADICAL COLOR;So;0;ON;<compat> 8272;;;;N;;;;;
2F8B;KANGXI RADICAL GRASS;So;0;ON;<compat> 8278;;;;N;;;;;
2F8C;KANGXI RADICAL TIGER;So;0;ON;<compat> 864D;;;;N;;;;;
2F8D;KANGXI RADICAL INSECT;So;0;ON;<compat> 866B;;;;N;;;;;
2F8E;KANGXI RADICAL BLOOD;So;0;ON;<compat> 8840;;;;N;;;;;
2F8F;KANGXI RADICAL WALK ENCLOSURE;So;0;ON;<compat> 884C;;;;N;;;;;
2F90;KANGXI RADICAL CLOTHES;So;0;ON;<compat> 8863;;;;N;;;;;
2F91;KANGXI RADICAL WEST;So;0;ON;<compat> 897E;;;;N;;;;;
2F92;KANGXI RADICAL SEE;So;0;ON;<compat> 898B;;;;N;;;;;
2F93;KANGXI RADICAL HORN;So;0;ON;<compat> 89D2;;;;N;;;;;
2F94;KANGXI RADICAL SPEECH;So;0;ON;<compat> 8A00;;;;N;;;;;
2F95;KANGXI RADICAL VALLEY;So;0;ON;<compat> 8C37;;;;N;;;;;
2F96;KANGXI RADICAL BEAN;So;0;ON;<compat> 8C46;;;;N;;;;;
2F97;KANGXI RADICAL PIG;So;0;ON;<compat> 8C55;;;;N;;;;;
2F98;KANGXI RADICAL BADGER;So;0;ON;<compat> 8C78;;;;N;;;;;
2F99;KANGXI RADICAL SHELL;So;0;ON;<compat> 8C9D;;;;N;;;;;
2F9A;KANGXI RADICAL RED;So;0;ON;<compat> 8D64;;;;N;;;;;
2F9B;KANGXI RADICAL RUN;So;0;ON;<compat> 8D70;;;;N;;;;;
2F9C;KANGXI RADICAL FOOT;So;0;ON;<compat> 8DB3;;;;N;;;;;
2F9D;KANGXI RADICAL BODY;So;0;ON;<compat> 8EAB;;;;N;;;;;
2F9E;KANGXI RADICAL CART;So;0;ON;<compat> 8ECA;;;;N;;;;;
2F9F;KANGXI RADICAL BITTER;So;0;ON;<compat> 8F9B;;;;N;;;;;
2FA0;KANGXI RADICAL MORNING;So;0;ON;<compat> 8FB0;;;;N;;;;;
2FA1;KANGXI RADICAL WALK;So;0;ON;<compat> 8FB5;;;;N;;;;;
2FA2;KANGXI RADICAL CITY;So;0;ON;<compat> 9091;;;;N;;;;;
2FA3;KANGXI RADICAL WINE;So;0;ON;<compat> 9149;;;;N;;;;;
2FA4;KANGXI RADICAL DISTINGUISH;So;0;ON;<compat> 91C6;;;;N;;;;;
2FA5;KANGXI RADICAL VILLAGE;So;0;ON;<compat> 91CC;;;;N;;;;;
2FA6;KANGXI RADICAL GOLD;So;0;ON;<compat> 91D1;;;;N;;;;;
2FA7;KANGXI RADICAL LONG;So;0;ON;<compat> 9577;;;;N;;;;;
2FA8;KANGXI RADICAL GATE;So;0;ON;<compat> 9580;;;;N;;;;;
2FA9;KANGXI RADICAL MOUND;So;0;ON;<compat> 961C;;;;N;;;;;
2FAA;KANGXI RADICAL SLAVE;So;0;ON;<compat> 96B6;;;;N;;;;;
2FAB;KANGXI RADICAL SHORT TAILED BIRD;So;0;ON;<compat> 96B9;;;;N;;;;;
2FAC;KANGXI RADICAL RAIN;So;0;ON;<compat> 96E8;;;;N;;;;;
2FAD;KANGXI RADICAL BLUE;So;0;ON;<compat> 9751;;;;N;;;;;
2FAE;KANGXI RADICAL WRONG;So;0;ON;<compat> 975E;;;;N;;;;;
2FAF;KANGXI RADICAL FACE;So;0;ON;<compat> 9762;;;;N;;;;;
2FB0;KANGXI RADICAL LEATHER;So;0;ON;<compat> 9769;;;;N;;;;;
2FB1;KANGXI RADICAL TANNED LEATHER;So;0;ON;<compat> 97CB;;;;N;;;;;
2FB2;KANGXI RADICAL LEEK;So;0;ON;<compat> 97ED;;;;N;;;;;
2FB3;KANGXI RADICAL SOUND;So;0;ON;<compat> 97F3;;;;N;;;;;
2FB4;KANGXI RADICAL LEAF;So;0;ON;<compat> 9801;;;;N;;;;;
2FB5;KANGXI RADICAL WIND;So;0;ON;<compat> 98A8;;;;N;;;;;
2FB6;KANGXI RADICAL FLY;So;0;ON;<compat> 98DB;;;;N;;;;;
2FB7;KANGXI RADICAL EAT;So;0;ON;<compat> 98DF;;;;N;;;;;
2FB8;KANGXI RADICAL HEAD;So;0;ON;<compat> 9996;;;;N;;;;;
2FB9;KANGXI RADICAL FRAGRANT;So;0;ON;<compat> 9999;;;;N;;;;;
2FBA;KANGXI RADICAL HORSE;So;0;ON;<compat> 99AC;;;;N;;;;;
2FBB;KANGXI RADICAL BONE;So;0;ON;<compat> 9AA8;;;;N;;;;;
2FBC;KANGXI RADICAL TALL;So;0;ON;<compat> 9AD8;;;;N;;;;;
2FBD;KANGXI RADICAL HAIR;So;0;ON;<compat> 9ADF;;;;N;;;;;
2FBE;KANGXI RADICAL FIGHT;So;0;ON;<compat> 9B25;;;;N;;;;;
2FBF;KANGXI RADICAL SACRIFICIAL WINE;So;0;ON;<compat> 9B2F;;;;N;;;;;
2FC0;KANGXI RADICAL CAULDRON;So;0;ON;<compat> 9B32;;;;N;;;;;
2FC1;KANGXI RADICAL GHOST;So;0;ON;<compat> 9B3C;;;;N;;;;;
2FC2;KANGXI RADICAL FISH;So;0;ON;<compat> 9B5A;;;;N;;;;;
2FC3;KANGXI RADICAL BIRD;So;0;ON;<compat> 9CE5;;;;N;;;;;
2FC4;KANGXI RADICAL SALT;So;0;ON;<compat> 9E75;;;;N;;;;;
2FC5;KANGXI RADICAL DEER;So;0;ON;<compat> 9E7F;;;;N;;;;;
2FC6;KANGXI RADICAL WHEAT;So;0;ON;<compat> 9EA5;;;;N;;;;;
2FC7;KANGXI RADICAL HEMP;So;0;ON;<compat> 9EBB;;;;N;;;;;
2FC8;KANGXI RADICAL YELLOW;So;0;ON;<compat> 9EC3;;;;N;;;;;
2FC9;KANGXI RADICAL MILLET;So;0;ON;<compat> 9ECD;;;;N;;;;;
2FCA;KANGXI RADICAL BLACK;So;0;ON;<compat> 9ED1;;;;N;;;;;
2FCB;KANGXI RADICAL EMBROIDERY;So;0;ON;<compat> 9EF9;;;;N;;;;;
2FCC;KANGXI RADICAL FROG;So;0;ON;<compat> 9EFD;;;;N;;;;;
2FCD;KANGXI RADICAL TRIPOD;So;0;ON;<compat> 9F0E;;;;N;;;;;
2FCE;KANGXI RADICAL DRUM;So;0;ON;<compat> 9F13;;;;N;;;;;
2FCF;KANGXI RADICAL RAT;So;0;ON;<compat> 9F20;;;;N;;;;;
2FD0;KANGXI RADICAL NOSE;So;0;ON;<compat> 9F3B;;;;N;;;;;
2FD1;KANGXI RADICAL EVEN;So;0;ON;<compat> 9F4A;;;;N;;;;;
2FD2;KANGXI RADICAL TOOTH;So;0;ON;<compat> 9F52;;;;N;;;;;
2FD3;KANGXI RADICAL DRAGON;So;0;ON;<compat> 9F8D;;;;N;;;;;
2FD4;KANGXI RADICAL TURTLE;So;0;ON;<compat> 9F9C;;;;N;;;;;
2FD5;KANGXI RADICAL FLUTE;So;0;ON;<compat> 9FA0;;;;N;;;;;