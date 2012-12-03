require 'compass'
require 'sinatra'
require 'haml'


configure do
  set :haml, {format: :html5, escape_html: false}
  set :scss, {style: :compact, debug_info: false}
  Compass.add_project_configuration(File.join(Sinatra::Application.root, 'config', 'compass.rb'))
end

get '/stylesheets/:name.css' do
  content_type 'text/css', charset: 'utf-8'
  scss(:"stylesheets/#{params[:name]}" )
end

# page definitions

get '/' do
  haml :index
end

get '/:page' do
  @page = params[:page]
  @links = {preview: "JOHNNY'S FAVORITES",
            life_story: "LIFESTORY",
            pro_baseball: "PRO BASEBALL",
            pro_football: "PRO FOOTBALL",
            corporate: "CORPORATE",
            high_school: "HIGH SCHOOL"
            }.delete_if {|key, value| key == @page.to_sym}
  
  old_style = ['preview','life_story','pro_baseball'] # pages using the legacy haml
  
  begin
    unless old_style.include? @page
      haml :gallery
    else
      haml params[:page].to_sym 
    end
  rescue Errno::ENOENT
    not_found
  end
end

not_found {haml :'404', layout: false} # graceful 404s

#get '/preview' do #replace these with :page
#  haml :preview, locals: {page: "preview"}
#end

#get '/lifestory' do
#  haml :lifestory, locals: {page: "lifestory"}
#end

#get '/pro_baseball' do
#  haml :pro_baseball, locals: {page: "pro_baseball"}
#end

#helper methods

helpers do
  def image_tag name, options=nil # refactor with args hash
    page = caller[0][/\/(?:.(?!\/))+$/][/.*\./][1..-2]
    # This ugly regex hack isolates the filename from which this method was called
    # I'm sure it could be reduced to a single regex if I had any experience writing them
    
    # The point of this is to programmatically determine whether the caller is 
    # the layout since it's the only place that doesn't rely on an @page variable
    
    #puts page + " " + name
    if page == "layout"
      "<img src=\"http://d1zguf60fl3jx1.cloudfront.net/jvslite/#{name}\" #{options}>"
    else
      "<img src=\"http://d1zguf60fl3jx1.cloudfront.net/jvslite/gallery/#{@page}/#{name}\" #{options}>"
    end
  end

  def partial page, options={}
    haml page.to_sym, options.merge!(layout: false)
  end
  
  def frame_tag side, title, image, description
    haml :_frame, {locals: {side: side, title: title, image: image, description: description}, layout: false}
  end
  
  def image_name img_number
    if img_number < 10
      "0#{img_number}.png"
    else
      "#{img_number}.png"
    end
  end
  
  # Page Text Helpers
  # FFS, these need to be moved to a database!  
  def corporate_text
    [["Chase","Natural Finish on Oak"], # 01.png
    ["Emrys Partners","Translucent Yellow on Curly Maple"], # 02.png
    ["Tire Exchange & Warner Brothers ","Black on Maple"], # 03.png
    ["ESPN Cleveland","Opaque Red on Maple"], # 04.png
    ["Mechanic Street","Silver on Maple"], # 05.png
    ["Chicago Fundamental","Opaque White on Maple"], # 06.png
    ["Post Alloy","Black Cherry on Ash"], # 07.png
    ["Raging Wolf Solutions","Black on Ash"], # 08.png
    ["Vertical Knowledge","Black on Maple"], # 09.png
    ["Cobalt Capital","Translucent Blue on Maple"], # 10.png
    ["Delta Psychological","Translucent Green on Maple"], # 11.png
    ["Joebees Bee Great!","Translucent Yellow on Maple"], # 12.png
    ["Brighton Best","Black on Maple"], # 13.png
    ["Ralph Lauren","Translucent Blue on Maple"], # 14.png
    ["Something New Florists","Pearl White on Maple"], # 15.png
    ["Locus Corp, Indians and Golf Clubs","Light Oak Finish on Oak"]] # 16.png
  end
  
  def high_school_text
    [["Aurora vs. Chagrin Falls Big Stick","Linseed Oil on Oak"], # 01.png
    ["Lake Catholic vs. Cardinal Mooney","Linseed Oil on Oak"], # 02.png
    ["Avon Lake vs. Avon Big Stick Award","Honey Amber on Oak"], # 03.png
    ["St. Ignatius","Translucent Yellow on Ash"], # 04.png
    ["St. Edward","Translucent Green on Maple"], # 05.png
    ["Gilmour Academy, UNC","Honey Amber on Oak"], # 06.png
    ["Brecksville Bees","Translucent Yellow on Maple"], # 07.png
    ["Massillon Tigers","Black on Maple"], # 08.png
    ["Padua Franciscan","Black Cherry on Oak"], # 09.png
    ["Nordonia Knights","Pearl White on Maple"], # 10.png
    ["Wadsworth","Natural Finish on Oak"], # 11.png
    ["Crestview","Black on Maple"], # 12.png
    ["Diamond Boys","Translucent Red on Oak"], # 13.png
    ["The Chosen Ones","Black Cherry on Oak"], # 14.png
    ["CABA Most Valuable Player","Translucent Blue on Maple"], # 15.png
    ["CABA Most Valuable Hitter","Translucent Red on Maple"]] # 16.png
  end
  
  def pro_football_text
    [["Chicago Bears","Honey Amber on Oak"], # 01.png
	  ["NY Jets","Light Oak Finish on Oak"], # 02.png
	  ["Miami Dolphins","Translucent Orange on Maple"], # 03.png
	  ["Cleveland Browns","Honey Amber on Oak"], # 04.png
	  ["New Orleans Saints","Black on Maple"], # 05.png
	  ["Green Bay Packers","Translucent Yellow on Maple"], #06.png
	  ["Steelers Green Bay Superbowl","Translucent Yellow on Maple"], # 07.png
	  ["Steelers Lombardy Trophy","Black on Maple"], # 08.png
	  ["Steelers Polamalu","Translucent Yellow on Maple"], # 09.png
	  ["Steelers Jack Lambert","Translucent Yellow on Maple"], # 10.png
	  ["Cincinnati Bengals","Translucent Orange on Maple"], # 11.png
	  ["Cleveland Gladiators","Translucent Red on Maple"], # 12.png
	  ["Minnesota Vikings","Translucent Purple on Maple"], # 13.png
	  ["Oakland Raiders","Black on Maple"]] # 14.png
  end
end
